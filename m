From: Hannes Reinecke <hare@suse.de>
Subject: Re: [V2 PATCH 03/11] aacraid: 4KB sector support
Date: Fri, 27 Mar 2015 11:15:05 +0100
Message-ID: <55152DA9.1060106@suse.de>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com> <1427380892-1978-4-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbbC0KPG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2015 06:15:06 -0400
In-Reply-To: <1427380892-1978-4-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Achim.Leubner@pmcs.com

On 03/26/2015 03:41 PM, Mahesh Rajashekhara wrote:
> Add 4KB sector support
>=20
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
> ---
>  drivers/scsi/aacraid/aachba.c  |  240 ++++++++++++++++++++++++++++++=
+--------
>  drivers/scsi/aacraid/aacraid.h |   11 ++-
>  2 files changed, 200 insertions(+), 51 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aac=
hba.c
> index b32e77d..aee3eaa 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -111,6 +111,41 @@
>  #define BYTE2(x) (unsigned char)((x) >> 16)
>  #define BYTE3(x) (unsigned char)((x) >> 24)
> =20
> +/* MODE_SENSE data format */
> +typedef struct {
> +	struct {
> +		u8	data_length;
> +		u8	med_type;
> +		u8	dev_par;
> +		u8	bd_length;
> +	} __attribute__((packed)) hd;
> +	struct {
> +		u8	dens_code;
> +		u8	block_count[3];
> +		u8	reserved;
> +		u8	block_length[3];
> +	} __attribute__((packed)) bd;
> +		u8	mpc_buf[3];
> +} __attribute__((packed)) aac_modep_data;
> +
> +/* MODE_SENSE_10 data format */
> +typedef struct {
> +	struct {
> +		u8	data_length[2];
> +		u8	med_type;
> +		u8	dev_par;
> +		u8	rsrvd[2];
> +		u8	bd_length[2];
> +	} __attribute__((packed)) hd;
> +	struct {
> +		u8	dens_code;
> +		u8	block_count[3];
> +		u8	reserved;
> +		u8	block_length[3];
> +	} __attribute__((packed)) bd;
> +		u8	mpc_buf[3];
> +} __attribute__((packed)) aac_modep10_data;
> +
>  /*------------------------------------------------------------------=
------------
>   *              S T R U C T S / T Y P E D E F S
>   *------------------------------------------------------------------=
----------*/
> @@ -438,7 +473,7 @@ static void get_container_name_callback(void *con=
text, struct fib * fibptr)
>  	if ((le32_to_cpu(get_name_reply->status) =3D=3D CT_OK)
>  	 && (get_name_reply->data[0] !=3D '\0')) {
>  		char *sp =3D get_name_reply->data;
> -		sp[sizeof(((struct aac_get_name_resp *)NULL)->data)-1] =3D '\0';
> +		sp[sizeof(((struct aac_get_name_resp *)NULL)->data)] =3D '\0';
>  		while (*sp =3D=3D ' ')
>  			++sp;
>  		if (*sp) {
What has this to do with 4k block support?
Looks rather like an unrelated bugfix to me...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
