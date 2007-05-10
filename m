From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: use_sg != 0 assumption (was Re: [PATCH 5/9] Drop single buffer request
 support.)
Date: Thu, 10 May 2007 12:38:31 +0200
Message-ID: <4642F627.5040400@s5r6.in-berlin.de>
References: <11787529952207-git-send-email-krh@redhat.com> <11787530023454-git-send-email-krh@redhat.com> <11787530031570-git-send-email-krh@redhat.com> <11787530031450-git-send-email-krh@redhat.com> <11787530043878-git-send-email-krh@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:37164 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbXEJKjb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2007 06:39:31 -0400
In-Reply-To: <11787530043878-git-send-email-krh@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Cc: linux1394-devel <linux1394-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

Kristian H=F8gsberg wrote:
> The SCSI layer only passes sg requests down, so drop the
> use_sg =3D=3D 0, request_bufflen !=3D 0 case.
>=20
> Signed-off-by: Kristian Hoegsberg <krh@redhat.com>
> ---
>  drivers/firewire/fw-sbp2.c |   43 +---------------------------------=
---------
>  1 files changed, 1 insertions(+), 42 deletions(-)

[...]

> @@ -1063,21 +1035,8 @@ static int sbp2_scsi_queuecommand(struct scsi_=
cmnd *cmd, scsi_done_fn_t done)
>  		orb->request.misc |=3D
>  			COMMAND_ORB_DIRECTION(SBP2_DIRECTION_TO_MEDIA);
> =20
> -	if (cmd->use_sg) {
> -		if (sbp2_command_orb_map_scatterlist(orb) < 0)
> -			goto fail_map_payload;
> -	} else if (cmd->request_bufflen > SBP2_MAX_SG_ELEMENT_LENGTH) {
> -		/*
> -		 * FIXME: Need to split this into a sg list... but
> -		 * could we get the scsi or blk layer to do that by
> -		 * reporting our max supported block size?
> -		 */
> -		fw_error("command > 64k\n");
> +	if (cmd->use_sg && sbp2_command_orb_map_scatterlist(orb) < 0)
>  		goto fail_map_payload;
> -	} else if (cmd->request_bufflen > 0) {
> -		if (sbp2_command_orb_map_buffer(orb) < 0)
> -			goto fail_map_payload;
> -	}
> =20
>  	fw_memcpy_to_be32(&orb->request, &orb->request, sizeof orb->request=
);
> =20

Would a BUG_ON(cmd->use_sg =3D=3D 0); be in order?
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D -=3D-=3D -=3D-=3D-
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
