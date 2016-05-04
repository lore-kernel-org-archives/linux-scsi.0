From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Make scsi_vpd_lun_id() able to use T10 vendor ID
 based designators
Date: Wed, 4 May 2016 12:04:16 +0200
Message-ID: <5729C920.1040206@suse.de>
References: <20160504065830.GB19436@oak.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182AbcEDKES (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2016 06:04:18 -0400
In-Reply-To: <20160504065830.GB19436@oak.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@ozlabs.org>
Cc: linux-scsi@vger.kernel.org

On 05/04/2016 08:58 AM, Paul Mackerras wrote:
> This adds code to scsi_vpd_lun_id() to enable it to use T10 vendor ID
> based designators.  This is needed to allow alua to work on disks tha=
t
> don't have any designators of type 2, 3 or 8.  Commit 0047220c6c36
> ("scsi_dh_alua: use unique device id", 2016-02-19) added a requiremen=
t
> that alua can only be used on disks for which scsi_vpd_lun_id() can
> produce an identifying string.
>=20
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> ---
>  drivers/scsi/scsi_lib.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 8106515..f4f69cc 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3214,6 +3214,20 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, =
char *id, size_t id_len)
>  			goto next_desig;
> =20
>  		switch (d[1] & 0xf) {
> +		case 0x1:
> +			/* T10 vendor ID */
> +			if (cur_id_size > d[3])
> +				break;
> +			/* Prefer EUI-64 or NAA IEEE Registered Extended */
> +			if ((cur_id_type =3D=3D 0x2 || cur_id_type =3D=3D 0x3) &&
> +			    cur_id_size =3D=3D d[3])
> +				break;
> +			cur_id_size =3D d[3];
> +			cur_id_str =3D d + 4;
> +			cur_id_type =3D d[1] & 0xf;
> +			id_size =3D snprintf(id, id_len, "%*phN", cur_id_size,
> +					   cur_id_str);
> +			break;
>  		case 0x2:
>  			/* EUI-64 */
>  			if (cur_id_size > d[3])
>=20
Nearly.
The thing is, a T-10 vendor specific ID is _supposed_ to be an ASCII
string. So I'd rather have it decoded as such.
And we're missing decoding for 'vendor-specific' ID, too.

I'll be sending a replacement patch.

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
