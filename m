From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH] scsi: hpsa: remove memory allocate failure message
Date: Fri, 9 Dec 2016 15:31:56 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D194180A16E@avsrvexchmbx1.microsemi.net>
References: <1481282264-11103-1-git-send-email-kushwaha.a@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0069.outbound.protection.outlook.com ([104.47.42.69]:11488
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753971AbcLIPcC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Dec 2016 10:32:02 -0500
In-Reply-To: <1481282264-11103-1-git-send-email-kushwaha.a@samsung.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "kushwaha.a@samsung.com" <kushwaha.a@samsung.com>, "JBottomley@odin.com" <JBottomley@odin.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "d.wadhawan@samsung.com" <d.wadhawan@samsung.com>

> -----Original Message-----
> From: kushwaha.a@samsung.com [mailto:kushwaha.a@samsung.com]
> Sent: Friday, December 09, 2016 5:18 AM
> To: Don Brace; JBottomley@odin.com
> Cc: linux-scsi@vger.kernel.org; kushwaha.a@samsung.com;
> d.wadhawan@samsung.com
> Subject: [PATCH] scsi: hpsa: remove memory allocate failure message
>=20
> EXTERNAL EMAIL
>=20
>=20
> From: Amit Kushwaha <kushwaha.a@samsung.com>
>=20
> This patch cleanup warning reported by checkpatch.pl
> WARNING: Possible unnecessary 'out of memory' message
> With no available memory, a warn on message already gets printed
> by page alloc apis
>=20
> Signed-off-by: Amit Kushwaha <kushwaha.a@samsung.com>

I notice that checkpatch reports other similar messages when run=20
against the entire driver, which driver version did you run
checkpatch on?

Thanks,
Don

> ---
>  drivers/scsi/hpsa.c |   21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 40669f8..bf14405 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1455,10 +1455,9 @@ static void hpsa_monitor_offline_device(struct
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
> @@ -1928,17 +1927,15 @@ static int hpsa_alloc_sg_chain_blocks(struct
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
> @@ -3759,11 +3756,9 @@ static void hpsa_update_scsi_devices(struct
> ctlr_info *h, int hostno)
>                 }
>=20
>                 currentsd[i] =3D kzalloc(sizeof(*currentsd[i]), GFP_KERNE=
L);
> -               if (!currentsd[i]) {
> -                       dev_warn(&h->pdev->dev, "out of memory at %s:%d\n=
",
> -                               __FILE__, __LINE__);
> +               if (!currentsd[i])
>                         goto out;
> -               }
> +
>                 ndev_allocated++;
>         }
>=20
> --
> 1.7.9.5

