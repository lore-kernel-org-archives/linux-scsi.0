From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH v2] scsi: hpsa: remove memory allocate failure message
Date: Mon, 12 Dec 2016 14:39:40 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D194180A852@avsrvexchmbx1.microsemi.net>
References: <1481540661-18493-1-git-send-email-kushwaha.a@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0053.outbound.protection.outlook.com ([104.47.40.53]:44403
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752419AbcLLOjq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Dec 2016 09:39:46 -0500
In-Reply-To: <1481540661-18493-1-git-send-email-kushwaha.a@samsung.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "kushwaha.a@samsung.com" <kushwaha.a@samsung.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akkushwaha9896@gmail.com" <akkushwaha9896@gmail.com>, "vidushi.koul@samsung.com" <vidushi.koul@samsung.com>

> -----Original Message-----
> From: kushwaha.a@samsung.com [mailto:kushwaha.a@samsung.com]
> Sent: Monday, December 12, 2016 5:04 AM
> To: Don Brace; jejb@linux.vnet.ibm.com
> Cc: linux-scsi@vger.kernel.org; akkushwaha9896@gmail.com;
> vidushi.koul@samsung.com
> Subject: [PATCH v2] scsi: hpsa: remove memory allocate failure message
>=20
> EXTERNAL EMAIL
>=20
>=20
> From: Amit Kushwaha <kushwaha.a@samsung.com>
>=20
> This patch cleanup warning reported by checkpatch.pl
> WARNING: Possible unnecessary 'out of memory' message
> With no available memory, a warn on message already gets printed
> by page alloc apis and modified goto use if memory unallocated.
>=20
> Signed-off-by: Amit Kushwaha <kushwaha.a@samsung.com>

Acked-by: Don Brace <don.brace@microsemi.com>

Thanks!

> ---
> Changes in v2:
>   - using driver version "3.4.16-0"
>=20
>  drivers/scsi/hpsa.c |   37 ++++++++++++-------------------------
>  1 file changed, 12 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index d007ec1..42844ef 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1543,10 +1543,9 @@ static void hpsa_monitor_offline_device(struct
> ctlr_info *h,
>=20
>         /* Device is not on the list, add it. */
>         device =3D kmalloc(sizeof(*device), GFP_KERNEL);
> -       if (!device) {
> -               dev_warn(&h->pdev->dev, "out of memory in %s\n", __func__=
);
> +       if (!device)
>                 return;
> -       }
> +
>         memcpy(device->scsi3addr, scsi3addr, sizeof(device->scsi3addr));
>         spin_lock_irqsave(&h->offline_device_lock, flags);
>         list_add_tail(&device->offline_list, &h->offline_device_list);
> @@ -2127,17 +2126,15 @@ static int hpsa_alloc_sg_chain_blocks(struct
> ctlr_info *h)
>=20
>         h->cmd_sg_list =3D kzalloc(sizeof(*h->cmd_sg_list) * h->nr_cmds,
>                                 GFP_KERNEL);
> -       if (!h->cmd_sg_list) {
> -               dev_err(&h->pdev->dev, "Failed to allocate SG list\n");
> +       if (!h->cmd_sg_list)
>                 return -ENOMEM;
> -       }
> +
>         for (i =3D 0; i < h->nr_cmds; i++) {
>                 h->cmd_sg_list[i] =3D kmalloc(sizeof(*h->cmd_sg_list[i]) =
*
>                                                 h->chainsize, GFP_KERNEL)=
;
> -               if (!h->cmd_sg_list[i]) {
> -                       dev_err(&h->pdev->dev, "Failed to allocate cmd SG=
\n");
> +               if (!h->cmd_sg_list[i])
>                         goto clean;
> -               }
> +
>         }
>         return 0;
>=20
> @@ -3443,11 +3440,8 @@ static void hpsa_get_sas_address(struct ctlr_info
> *h, unsigned char *scsi3addr,
>                 struct bmic_sense_subsystem_info *ssi;
>=20
>                 ssi =3D kzalloc(sizeof(*ssi), GFP_KERNEL);
> -               if (ssi =3D=3D NULL) {
> -                       dev_warn(&h->pdev->dev,
> -                               "%s: out of memory\n", __func__);
> +               if (!ssi)
>                         return;
> -               }
>=20
>                 rc =3D hpsa_bmic_sense_subsystem_information(h,
>                                         scsi3addr, 0, ssi, sizeof(*ssi));
> @@ -4295,8 +4289,6 @@ static void hpsa_update_scsi_devices(struct
> ctlr_info *h)
>=20
>                 currentsd[i] =3D kzalloc(sizeof(*currentsd[i]), GFP_KERNE=
L);
>                 if (!currentsd[i]) {
> -                       dev_warn(&h->pdev->dev, "out of memory at %s:%d\n=
",
> -                               __FILE__, __LINE__);
>                         h->drv_req_rescan =3D 1;
>                         goto out;
>                 }
> @@ -8599,14 +8591,12 @@ static int hpsa_luns_changed(struct ctlr_info *h)
>          */
>=20
>         if (!h->lastlogicals)
> -               goto out;
> +               return rc;
>=20
>         logdev =3D kzalloc(sizeof(*logdev), GFP_KERNEL);
> -       if (!logdev) {
> -               dev_warn(&h->pdev->dev,
> -                       "Out of memory, can't track lun changes.\n");
> -               goto out;
> -       }
> +       if (!logdev)
> +               return rc;
> +
>         if (hpsa_scsi_do_report_luns(h, 1, logdev, sizeof(*logdev), 0)) {
>                 dev_warn(&h->pdev->dev,
>                         "report luns failed, can't track lun changes.\n")=
;
> @@ -8992,11 +8982,8 @@ static void hpsa_disable_rld_caching(struct
> ctlr_info *h)
>                 return;
>=20
>         options =3D kzalloc(sizeof(*options), GFP_KERNEL);
> -       if (!options) {
> -               dev_err(&h->pdev->dev,
> -                       "Error: failed to disable rld caching, during all=
oc.\n");
> +       if (!options)
>                 return;
> -       }
>=20
>         c =3D cmd_alloc(h);
>=20
> --
> 1.7.9.5

