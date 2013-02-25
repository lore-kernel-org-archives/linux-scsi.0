From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/4] scsi: use 64-bit LUNs
Date: Mon, 25 Feb 2013 16:33:40 +0100
Message-ID: <512B8454.4050806@linux.vnet.ibm.com>
References: <1361261883-41467-1-git-send-email-hare@suse.de> <1361261883-41467-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:49636 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab3BYPeU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2013 10:34:20 -0500
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Mon, 25 Feb 2013 15:32:15 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id BF7DC17D8063
	for <linux-scsi@vger.kernel.org>; Mon, 25 Feb 2013 15:34:13 +0000 (GMT)
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r1PFXWxh29491392
	for <linux-scsi@vger.kernel.org>; Mon, 25 Feb 2013 15:33:32 GMT
Received: from d06av03.portsmouth.uk.ibm.com (localhost.localdomain [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r1PFXfDq012983
	for <linux-scsi@vger.kernel.org>; Mon, 25 Feb 2013 08:33:41 -0700
In-Reply-To: <1361261883-41467-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>

Hi Hannes,

I like the idea and most of the patch set, so I only have a few questio=
ns left and some review comments below.

Just curious: Do you also plan to adapt systemd/udev, especially path_i=
d for fc transport with its open coded copy of int_to_scsilun()?

Since I don't see zfcp touched in this patch set, assuming this set wil=
l get merged, I plan to adapt a few spots in zfcp that might not work w=
ith 64 bit luns out of the box although most of it already works with 6=
4 bit luns inside.

Speaking of opaque handling of scsi luns: Lately I noticed that some sg=
3_utils tools decode the lun format and only report parts of the entire=
 64 bit fcp lun, e.g. sg_scan or "sg_luns -d". I don't have enough hist=
orical scsi experience to know why that is, maybe because of some SPI b=
ackground. By itself this is not a problem, however, rescan-scsi-bus.sh=
 makes use of those scsi lun parts and then fails when matching those w=
ith the full scsi lun exposed by the midlayer to user space. E.g. with =
flat space addresses of IBM DS8000 this does not seem to work:

# sg_luns -v -s2 -d /dev/sg2 | head
    report luns cdb: a0 00 02 00 00 00 00 00 20 00 00 00
    report luns: requested 8192 bytes but got 4112 bytes
Lun list length =3D 4104 which imples 513 lun entries
Report luns [select_report=3D2]:
    c101000000000000
      REPORT LUNS well known logical unit
    4020400000000000
      Flat space addressing: lun=3D32
    4020400100000000
      Flat space addressing: lun=3D32
    4020400200000000
      Flat space addressing: lun=3D32
                                 ^^<=3D=3D=3D 0x20 of the lun's 1st sho=
rt

Did I overlook something or are rescan-scsi-bus.sh and maybe other tool=
s really broken with some "modern" scsi targets?

On 02/19/2013 09:18 AM, Hannes Reinecke wrote:
> The SCSI standard uses a 64-bit value for LUNs, and large arrays
> employing large LUN numbers become more and more common.
> So move the linux SCSI stack to use 64-bit LUN numbers.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---

>   drivers/scsi/scsi_proc.c                |    2 +-

>   drivers/scsi/scsi_sysfs.c               |   14 ++++----
>   drivers/scsi/scsi_transport_fc.c        |    4 +-
>   drivers/scsi/scsi_transport_iscsi.c     |    4 +-
>   drivers/scsi/scsi_transport_sas.c       |    2 +-
>   drivers/scsi/sg.c                       |    4 +-

>   include/scsi/scsi.h                     |    2 +-
>   include/scsi/scsi_device.h              |   22 ++++++------
>   include/scsi/scsi_transport.h           |    2 +-
>   50 files changed, 239 insertions(+), 247 deletions(-)

> --- a/drivers/scsi/scsi_proc.c
> +++ b/drivers/scsi/scsi_proc.c
> @@ -196,7 +196,7 @@ static int proc_print_scsidevice(struct device *d=
ev, void *data)
>=20
>   	sdev =3D to_scsi_device(dev);
>   	seq_printf(s,
> -		"Host: scsi%d Channel: %02d Id: %02d Lun: %02d\n  Vendor: ",
> +		"Host: scsi%d Channel: %02d Id: %02d Lun: %02llu\n  Vendor: ",
>   		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
>   	for (i =3D 0; i < 8; i++) {
>   		if (sdev->vendor[i] >=3D 0x20)

Is it intentional that you did not adapt scsi_add_single_device(), scsi=
_remove_single_device(), proc_scsi_write() to cope with 64 bit luns?
(in the admittedly old and probably somewhat deprecated procfs interfac=
e; but then again, proc_print_scsidevice can output 64 bit luns now)

> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 931a7d9..6e98f05 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -80,7 +80,7 @@ const char *scsi_host_state_name(enum scsi_host_sta=
te state)
>   	return name;
>   }
>=20
> -static int check_set(unsigned int *val, char *src)
> +static int check_set(unsigned long long *val, char *src)
>   {
>   	char *last;
>=20
> @@ -90,7 +90,7 @@ static int check_set(unsigned int *val, char *src)
>   		/*
>   		 * Doesn't check for int overflow
>   		 */
> -		*val =3D simple_strtoul(src, &last, 0);
> +		*val =3D simple_strtoull(src, &last, 0);
>   		if (*last !=3D '\0')
>   			return 1;
>   	}
> @@ -99,11 +99,11 @@ static int check_set(unsigned int *val, char *src=
)
>=20
>   static int scsi_scan(struct Scsi_Host *shost, const char *str)
>   {
> -	char s1[15], s2[15], s3[15], junk;
> -	unsigned int channel, id, lun;
> +	char s1[15], s2[15], s3[17], junk;

Since we use automatic base detection with the 3rd argument of simple_s=
trtoull() being 0 in check_set() above, I think the user is free to spe=
cify the lun to scan for in decimal/octal/hex base for s3.
With 64 bits, couldn't this need a maximum of 20 decimal digits (plus '=
\0' termination) which is more than 16? I think this is a legitimate us=
e case as long as the scsi lun is represented in decimal in sysfs so us=
ers might just have it from the h:c:t:l device name there.
While I don't think anyone would specify the lun in octal, it could eve=
n need 22 digits.
[Maximum number of digits is ceil(ln(2**64-1)/ln(base)) if I'm not mist=
aken.]

> +	unsigned long long channel, id, lun;
>   	int res;
>=20
> -	res =3D sscanf(str, "%10s %10s %10s %c", s1, s2, s3, &junk);
> +	res =3D sscanf(str, "%10s %10s %16s %c", s1, s2, s3, &junk);

ditto

>   	if (res !=3D 3)
>   		return -EINVAL;
>   	if (check_set(&channel, s1))

> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_tra=
nsport_fc.c
> index e894ca7..091210f 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -2093,7 +2093,7 @@ fc_timed_out(struct scsi_cmnd *scmd)
>    * on the rport.
>    */
>   static void
> -fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, uin=
t lun)
> +fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, uin=
t64_t lun)
>   {
>   	struct fc_rport *rport;
>   	unsigned long flags;
> @@ -2125,7 +2125,7 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint =
channel, uint id, uint lun)
>    * object as the parent.
>    */
>   static int
> -fc_user_scan(struct Scsi_Host *shost, uint channel, uint id, uint lu=
n)
> +fc_user_scan(struct Scsi_Host *shost, uint channel, uint id, uint64_=
t lun)

Is it OK, that the maximum lun 2**64-1 overlaps with SCAN_WILD_CARD=3D=3D=
~0 from scsi.h?

> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index be2c9a6..271d23d 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c

I guess we cannot adapt sg_ioctl SG_GET_SCSI_ID that easily without bre=
aking the user space interface. But how does a user of this interface k=
now that there are 64 bit luns in the kernel but the ioctl cannot handl=
e the new kernel functionality (and may be affected by aliasing)?

> @@ -2492,7 +2492,7 @@ static int sg_proc_seq_show_dev(struct seq_file=
 *s, void *v)
>   	read_lock_irqsave(&sg_index_lock, iflags);
>   	sdp =3D it ? sg_lookup_dev(it->index) : NULL;
>   	if (sdp && (scsidp =3D sdp->device) && (!sdp->detached))
> -		seq_printf(s, "%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
> +		seq_printf(s, "%d\t%d\t%d\t%llu\t%d\t%d\t%d\t%d\t%d\n",
>   			      scsidp->host->host_no, scsidp->channel,
>   			      scsidp->id, scsidp->lun, (int) scsidp->type,
>   			      1,
> @@ -2621,7 +2621,7 @@ static int sg_proc_seq_show_debug(struct seq_fi=
le *s, void *v)
>   			seq_printf(s, "detached pending close ");
>   		else
>   			seq_printf
> -			    (s, "scsi%d chan=3D%d id=3D%d lun=3D%d   em=3D%d",
> +			    (s, "scsi%d chan=3D%d id=3D%d lun=3D%llu   em=3D%d",
>   			     scsidp->host->host_no,
>   			     scsidp->channel, scsidp->id,
>   			     scsidp->lun,

Regards,
Steffen

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Gesch=E4ftsf=FChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
