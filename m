From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 2/3] scsi_dh_alua: Do not retry for unmapped device
Date: Fri, 28 Apr 2017 18:42:51 +0000
Message-ID: <1493404971.2767.15.camel@sandisk.com>
References: <20170428130626.32162-1-mwilck@suse.com>
         <20170428130626.32162-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:59055 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422934AbdD1Smz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2017 14:42:55 -0400
In-Reply-To: <20170428130626.32162-3-mwilck@suse.com>
Content-Language: en-US
Content-ID: <D0A9B26A7DC1CE4D989FB7AA40A673B6@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mwilck@suse.com" <mwilck@suse.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-04-28 at 15:06 +0200, Martin Wilck wrote:
> From: Hannes Reinecke <hare@suse.de>
>=20
> If a device becomes unmapped on the target we should be returning
> SCSI_DH_DEV_OFFLINED.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Martin Wilck <mwilck@suse.com>

Hello Hannes and Martin,

Have you considered to add "Cc: stable" to this patch and other patches in
this series?

>=20
>  		 * Retry on ALUA state transition or if any
>  		 * UNIT ATTENTION occurred.
> @@ -576,6 +576,9 @@ static int alua_rtpg(struct scsi_device *sdev, struct=
 alua_port_group *pg)
>  		if (sense_hdr.sense_key =3D=3D NOT_READY &&
>  		    sense_hdr.asc =3D=3D 0x04 && sense_hdr.ascq =3D=3D 0x0a)
>  			err =3D SCSI_DH_RETRY;
> +		if (sense_hdr.sense_key =3D=3D ILLEGAL_REQUEST &&
> +		    sense_hdr.asc =3D=3D 0x25 && sense_hdr.ascq =3D=3D 0x00)
> +			err =3D SCSI_DH_DEV_OFFLINED;
>  		else if (sense_hdr.sense_key =3D=3D UNIT_ATTENTION)
>  			err =3D SCSI_DH_RETRY;

Please be consistent in the code that checks the sense codes - either use
"else if" for the test that has been added or changed the existing "else if=
"
into "if". Otherwise this patch looks fine to me.

Thanks,

Bart.=
