From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH] hpsa: fix volume offline state
Date: Mon, 20 Mar 2017 16:15:09 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D194F34174C@avsrvexchmbx1.microsemi.net>
References: <1490024568-4301-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0052.outbound.protection.outlook.com ([104.47.32.52]:59840
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756058AbdCTQub (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Mar 2017 12:50:31 -0400
In-Reply-To: <1490024568-4301-1-git-send-email-thenzl@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Monday, March 20, 2017 10:43 AM
> To: linux-scsi@vger.kernel.org
> Cc: Don Brace <don.brace@microsemi.com>; joseph.szczypek@hpe.com
> Subject: [PATCH] hpsa: fix volume offline state
>=20
> EXTERNAL EMAIL
>=20
>=20
> In a previous patch a hpsa_scsi_dev_t.volume_offline update line
> has been removed, so let us put it back..
>=20
> Fixes: 85b29008d8 (hpsa: update check for logical volume status)
>=20
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/hpsa.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 0d0be7754a..9d659aaace 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3885,6 +3885,7 @@ static int hpsa_update_device_info(struct
> ctlr_info *h,
>                 if (h->fw_support & MISC_FW_RAID_OFFLOAD_BASIC)
>                         hpsa_get_ioaccel_status(h, scsi3addr, this_device=
);
>                 volume_offline =3D hpsa_volume_offline(h, scsi3addr);
> +               this_device->volume_offline =3D volume_offline;
>                 if (volume_offline =3D=3D HPSA_LV_FAILED) {
>                         rc =3D HPSA_LV_FAILED;
>                         dev_err(&h->pdev->dev,
> --
> 2.7.4

Acked-by: Don Brace <don.brace@microsemi.com>

Thanks Tomas.
