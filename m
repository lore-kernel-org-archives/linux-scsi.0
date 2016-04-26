From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/12] scsi_debug: rework resp_report_luns
Date: Tue, 26 Apr 2016 08:26:40 +0200
Message-ID: <571F0A20.5040205@suse.de>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
 <1461600999-28893-9-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbcDZG0m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 02:26:42 -0400
In-Reply-To: <1461600999-28893-9-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 04/25/2016 06:16 PM, Douglas Gilbert wrote:
> Based on "[PATH V2] scsi_debug: rework resp_report_luns" patch
> sent by Tomas Winkler on Thursday, 26 Feb 2015. His notes:
>   1. Remove duplicated boundary checks which simplify the fill-in
>      loop
>   2. Use more of scsi generic API
> Replace fixed length response array a with heap allocation
> allowing up to 16383 LUNs per target.
>=20
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/scsi_debug.c | 138 ++++++++++++++++++++++++++++++------=
----------
>  1 file changed, 91 insertions(+), 47 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index cf44ab0..eac62b8 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3205,63 +3205,99 @@ static int resp_get_lba_status(struct scsi_cm=
nd *scp,
>  	return fill_from_dev_buffer(scp, arr, SDEBUG_GET_LBA_STATUS_LEN);
>  }
> =20
> -#define SDEBUG_RLUN_ARR_SZ 256
> -
> -static int resp_report_luns(struct scsi_cmnd * scp,
> -			    struct sdebug_dev_info * devip)
> +/* Even though each pseudo target has a REPORT LUNS "well known logi=
cal unit"
> + * (W-LUN), the normal Linux scanning logic does not associate it wi=
th a
> + * device (e.g. /dev/sg7). The following magic will make that associ=
ation:
> + *   "cd /sys/class/scsi_host/host<n> ; echo '- - 49409' > scan"
> + * where <n> is a host number. If there are multiple targets in a ho=
st then
> + * the above will associate a W-LUN to each target. To only get a W-=
LUN
> + * for target 2, then use "echo '- 2 49409' > scan" . */
> +static int resp_report_luns(struct scsi_cmnd *scp,
> +			    struct sdebug_dev_info *devip)
>  {
> +	unsigned char *cmd =3D scp->cmnd;
>  	unsigned int alloc_len;
> -	int lun_cnt, i, upper, num, n, want_wlun, shortish;
> +	unsigned char select_report;
>  	u64 lun;
> -	unsigned char *cmd =3D scp->cmnd;
> -	int select_report =3D (int)cmd[2];
> -	struct scsi_lun *one_lun;
> -	unsigned char arr[SDEBUG_RLUN_ARR_SZ];
> -	unsigned char * max_addr;
> +	struct scsi_lun *lun_p;
> +	u8 *arr;
> +	unsigned int lun_cnt;	/* normal LUN count (max: 16383) */
> +	unsigned int wlun_cnt;	/* report luns W-LUN count */
> +	unsigned int tlun_cnt;	/* total LUN count */
> +	unsigned int rlen;	/* response length (in bytes) less header */
> +	int i, res;
> =20
>  	clear_luns_changed_on_target(devip);
> -	alloc_len =3D cmd[9] + (cmd[8] << 8) + (cmd[7] << 16) + (cmd[6] << =
24);
> -	shortish =3D (alloc_len < 4);
> -	if (shortish || (select_report > 2)) {
> -		mk_sense_invalid_fld(scp, SDEB_IN_CDB, shortish ? 6 : 2, -1);
> +
> +	select_report =3D cmd[2];
> +	alloc_len =3D get_unaligned_be32(cmd + 6);
> +
> +	if (alloc_len < 4) {
> +		pr_err("alloc len too small %d\n", alloc_len);
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 6, -1);
>  		return check_condition_result;
>  	}
> -	/* can produce response with up to 16k luns (lun 0 to lun 16383) */
> -	memset(arr, 0, SDEBUG_RLUN_ARR_SZ);
> +
> +	if (select_report > 0x02) {
> +		pr_err("select report invalid %d\n", select_report);
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
> +		return check_condition_result;
> +	}
> +
>  	lun_cnt =3D sdebug_max_luns;
> -	if (1 =3D=3D select_report)
> +	wlun_cnt =3D 0;
> +
> +	/* report only w_lun */
> +	if (select_report =3D=3D 0x01)
>  		lun_cnt =3D 0;
> -	else if (sdebug_no_lun_0 && (lun_cnt > 0))
> +
> +	if (sdebug_no_lun_0 && (lun_cnt > 0))
>  		--lun_cnt;
> -	want_wlun =3D (select_report > 0) ? 1 : 0;
> -	num =3D lun_cnt + want_wlun;
> -	arr[2] =3D ((sizeof(struct scsi_lun) * num) >> 8) & 0xff;
> -	arr[3] =3D (sizeof(struct scsi_lun) * num) & 0xff;
> -	n =3D min((int)((SDEBUG_RLUN_ARR_SZ - 8) /
> -			    sizeof(struct scsi_lun)), num);
> -	if (n < num) {
> -		want_wlun =3D 0;
> -		lun_cnt =3D n;
> -	}
> -	one_lun =3D (struct scsi_lun *) &arr[8];
> -	max_addr =3D arr + SDEBUG_RLUN_ARR_SZ;
> -	for (i =3D 0, lun =3D (sdebug_no_lun_0 ? 1 : 0);
> -             ((i < lun_cnt) && ((unsigned char *)(one_lun + i) < max=
_addr));
> -	     i++, lun++) {
> -		upper =3D (lun >> 8) & 0x3f;
> -		if (upper)
> -			one_lun[i].scsi_lun[0] =3D
> -			    (upper | (SAM2_LUN_ADDRESS_METHOD << 6));
> -		one_lun[i].scsi_lun[1] =3D lun & 0xff;
> -	}
> -	if (want_wlun) {
> -		one_lun[i].scsi_lun[0] =3D (SCSI_W_LUN_REPORT_LUNS >> 8) & 0xff;
> -		one_lun[i].scsi_lun[1] =3D SCSI_W_LUN_REPORT_LUNS & 0xff;
> -		i++;
> -	}
> -	alloc_len =3D (unsigned char *)(one_lun + i) - arr;
> -	return fill_from_dev_buffer(scp, arr,
> -				    min((int)alloc_len, SDEBUG_RLUN_ARR_SZ));
> +
> +	/* report w_lun */
> +	if (select_report =3D=3D 0x01 || select_report =3D=3D 0x02)
> +		wlun_cnt =3D 1;
> +
> +	tlun_cnt =3D lun_cnt + wlun_cnt;
> +	/* can produce response with up to 16k luns (lun 0 to lun 16383) */
> +	arr =3D kzalloc((tlun_cnt * sizeof(lun_p->scsi_lun)) + 8, GFP_ATOMI=
C);
> +	if (!arr) {
> +		pr_warn("No space for report luns response\n");
> +		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
> +				INSUFF_RES_ASCQ);
> +		return check_condition_result;
> +	}
> +	pr_debug("select_report %d luns =3D %d wluns =3D %d no_lun0 %d\n",
> +		 select_report, lun_cnt, wlun_cnt, sdebug_no_lun_0);
> +
> +	lun =3D 0LL;
> +	/* luns start at offset 8 after the byte length */
> +	lun_p =3D (struct scsi_lun *)&arr[8];
> +
> +	/* skip lun 0 */
> +	if (sdebug_no_lun_0)
> +		lun++;
> +	/*
> +	 * Address method (we use Peripherial =3D 00b)
> +	 * 10b - Logical unit
> +	 * 00b - Peripherial device - Use this one
> +	 * 01b - Logical device
> +	 * 11b - reserved
> +	 */
> +	for (i =3D 0; i < lun_cnt; i++)
> +		int_to_scsilun(lun++, lun_p++);
> +
> +	/* report SCSI_W_LUN_REPORT_LUN */
> +	if (wlun_cnt)
> +		int_to_scsilun(SCSI_W_LUN_REPORT_LUNS, lun_p++);
> +
> +	rlen =3D tlun_cnt * sizeof(struct scsi_lun);
> +
> +	put_unaligned_be32(rlen, &arr[0]);
> +
> +	res =3D fill_from_dev_buffer(scp, arr, rlen + 8);
> +	kfree(arr);
> +	return res;
>  }
> =20
>  static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long lon=
g lba,
> @@ -4299,6 +4335,10 @@ static ssize_t max_luns_store(struct device_dr=
iver *ddp, const char *buf,
>  	bool changed;
> =20
>  	if ((count > 0) && (1 =3D=3D sscanf(buf, "%d", &n)) && (n >=3D 0)) =
{
> +		if (n > 16383) {
> +			pr_warn("max_luns can be no more than 16383\n");
> +			return -EINVAL;
> +		}
>  		changed =3D (sdebug_max_luns !=3D n);
>  		sdebug_max_luns =3D n;
>  		sdebug_max_tgts_luns();
> @@ -4643,6 +4683,10 @@ static int __init scsi_debug_init(void)
>  		pr_err("invalid physblk_exp %u\n", sdebug_physblk_exp);
>  		return -EINVAL;
>  	}
> +	if (sdebug_max_luns > 16383) {
> +		pr_warn("max_luns can be no more than 16383, use default\n");
> +		sdebug_max_luns =3D DEF_MAX_LUNS;
> +	}
> =20
>  	if (sdebug_lowest_aligned > 0x3fff) {
>  		pr_err("lowest_aligned too big: %u\n", sdebug_lowest_aligned);
>=20
Hmm.

Have you actually checked this?

Thing is, only LUNs 0-255 are numbered sequentially; any higher LUNs
has to use one of the various encoding schemes, at which point the
sequentiality (sp?) breaks down.

So to be correct you probably should be using a loop from 0-255 to
generate the low-order LUNs, and another loop from 255 - lun_cnt to
construct the higher-order LUNs from the address method + lun number.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
