From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [V2 PATCH 03/11] aacraid: 4KB sector support
Date: Fri, 27 Mar 2015 10:59:45 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AB7F4A7A2@BBYEXM01.pmc-sierra.internal>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1427380892-1978-4-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <55152DA9.1060106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:47556 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467AbbC0LAE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2015 07:00:04 -0400
In-Reply-To: <55152DA9.1060106@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Achim Leubner <Achim.Leubner@pmcs.com>


Thanks Hannes,

When we created new 4K based logical drive/container with the name leng=
th 16 but we were seeing only first 15 characters in Linux OS by "sg_ma=
p -i", cat /proc/scsi/scsi.

This change fixes logical drive name display issue.
=20
-----Original Message-----
=46rom: Hannes Reinecke [mailto:hare@suse.de]=20
Sent: Friday, March 27, 2015 3:45 PM
To: Mahesh Rajashekhara; JBottomley@Parallels.com; linux-scsi@vger.kern=
el.org
Cc: Achim Leubner
Subject: Re: [V2 PATCH 03/11] aacraid: 4KB sector support

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
> diff --git a/drivers/scsi/aacraid/aachba.c=20
> b/drivers/scsi/aacraid/aachba.c index b32e77d..aee3eaa 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -111,6 +111,41 @@
>  #define BYTE2(x) (unsigned char)((x) >> 16)  #define BYTE3(x)=20
> (unsigned char)((x) >> 24)
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
>  =20
> *--------------------------------------------------------------------=
-
> -------*/ @@ -438,7 +473,7 @@ static void=20
> get_container_name_callback(void *context, struct fib * fibptr)
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
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton HRB =
21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
