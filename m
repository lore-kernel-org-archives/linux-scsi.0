From: "Kuzeja, William" <william.kuzeja@stratus.com>
Subject: RE: [PATCH] sd: Limit WRITE SAME / WRITE SAME(16) w/UNMAP length for
 certain devices
Date: Tue, 19 Sep 2017 17:32:48 +0000
Message-ID: <BY1PR0801MB09670B86B85E3FFAB06C17618C600@BY1PR0801MB0967.namprd08.prod.outlook.com>
References: <1505837661-2280-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us-smtp-delivery-131.mimecast.com ([216.205.24.131]:55502 "EHLO
        us-smtp-delivery-131.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750919AbdISRcy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Sep 2017 13:32:54 -0400
In-Reply-To: <1505837661-2280-1-git-send-email-emilne@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Ewan,

I like it, more generic than my patch. I never saw the other cases, so I li=
mited my=20
patch to WS16.

Acked-by: Bill Kuzeja <William.Kuzeja@stratus.com>

On Tue-09-19 at 12:14 Ewan D. Milne wrote:=20
> Some devices do not support a WRITE SAME / WRITE SAME(16) with the
> UNMAP
> bit set up to the length specified in the MAXIMUM WRITE SAME LENGTH
> field
> in the block limits VPD page (or, the field is zero, indicating there is
> no limit).  Limit the length by the MAXIMUM UNMAP LBA COUNT value.
> Otherwise the command might be rejected.
>=20
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/sd.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 6549e5c..fa07ac2 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -693,6 +693,7 @@ static void sd_config_discard(struct scsi_disk *sdkp,
> unsigned int mode)
>  =09struct request_queue *q =3D sdkp->disk->queue;
>  =09unsigned int logical_block_size =3D sdkp->device->sector_size;
>  =09unsigned int max_blocks =3D 0;
> +=09u32 max_ws_blocks =3D sdkp->max_ws_blocks;
>=20
>  =09q->limits.discard_alignment =3D
>  =09=09sdkp->unmap_alignment * logical_block_size;
> @@ -701,6 +702,13 @@ static void sd_config_discard(struct scsi_disk *sdkp=
,
> unsigned int mode)
>  =09=09    sdkp->unmap_granularity * logical_block_size);
>  =09sdkp->provisioning_mode =3D mode;
>=20
> +=09/*
> +=09 * Some devices limit WRITE SAME / WRITE SAME(16) w/UNMAP
> +=09 * by MAXIMUM UNMAP LBA COUNT instead of MAXIMUM WRITE
> SAME LENGTH.
> +=09 * Use the smaller of the two values to avoid ILLEGAL REQUEST
> errors.
> +=09 */
> +=09max_ws_blocks =3D min_not_zero(max_ws_blocks, sdkp-
> >max_unmap_blocks);
> +
>  =09switch (mode) {
>=20
>  =09case SD_LBP_FULL:
> @@ -715,17 +723,17 @@ static void sd_config_discard(struct scsi_disk *sdk=
p,
> unsigned int mode)
>  =09=09break;
>=20
>  =09case SD_LBP_WS16:
> -=09=09max_blocks =3D min_not_zero(sdkp->max_ws_blocks,
> +=09=09max_blocks =3D min_not_zero(max_ws_blocks,
>  =09=09=09=09=09  (u32)SD_MAX_WS16_BLOCKS);
>  =09=09break;
>=20
>  =09case SD_LBP_WS10:
> -=09=09max_blocks =3D min_not_zero(sdkp->max_ws_blocks,
> +=09=09max_blocks =3D min_not_zero(max_ws_blocks,
>  =09=09=09=09=09  (u32)SD_MAX_WS10_BLOCKS);
>  =09=09break;
>=20
>  =09case SD_LBP_ZERO:
> -=09=09max_blocks =3D min_not_zero(sdkp->max_ws_blocks,
> +=09=09max_blocks =3D min_not_zero(max_ws_blocks,
>  =09=09=09=09=09  (u32)SD_MAX_WS10_BLOCKS);
>  =09=09break;
>  =09}
> --
> 2.1.0
