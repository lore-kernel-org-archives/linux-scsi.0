From: yalin wang <yalin.wang2010@gmail.com>
Subject: Re: [TRIVIAL PATCH] block: Correct misuses of 0x%<decimal>
Date: Mon, 3 Aug 2015 15:25:38 +0800
Message-ID: <9547AF94-2168-4987-AD89-B7F111084CC2@gmail.com>
References: <1438547113.29569.5.camel@perches.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33339 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbbHCHZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2015 03:25:45 -0400
In-Reply-To: <1438547113.29569.5.camel@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Don Brace <don.brace@pmcs.com>, linux-kernel@vger.kernel.org, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi <linux-scsi@vger.kernel.org>


> On Aug 3, 2015, at 04:25, Joe Perches <joe@perches.com> wrote:
>=20
> Correct misuse of 0x%d in logging messages.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> drivers/block/DAC960.c | 4 ++--
> drivers/block/cciss.c  | 2 +-
> 2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
> index 811e11c..d9b32f2 100644
> --- a/drivers/block/DAC960.c
> +++ b/drivers/block/DAC960.c
> @@ -2954,7 +2954,7 @@ DAC960_DetectController(struct pci_dev *PCI_Dev=
ice,
>        case DAC960_PD_Controller:
>          if (!request_region(Controller->IO_Address, 0x80,
>                              Controller->FullModelName)) {
> -               DAC960_Error("IO port 0x%d busy for Controller at\n",
> +               DAC960_Error("IO port 0x%x busy for Controller at\n",
>                             Controller, Controller->IO_Address);
>                goto Failure;
>          }
> @@ -2990,7 +2990,7 @@ DAC960_DetectController(struct pci_dev *PCI_Dev=
ice,
>        case DAC960_P_Controller:
>          if (!request_region(Controller->IO_Address, 0x80,
>                              Controller->FullModelName)){
> -               DAC960_Error("IO port 0x%d busy for Controller at\n",
> +               DAC960_Error("IO port 0x%x busy for Controller at\n",
>                             Controller, Controller->IO_Address);
>                goto Failure;
>          }
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 0422c47..2758982 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -3854,7 +3854,7 @@ static void print_cfg_table(ctlr_info_t *h)
>               readl(&(tb->HostWrite.CoalIntDelay)));
>        dev_dbg(&h->pdev->dev, "   Coalesce Interrupt Count =3D 0x%x\n=
",
>               readl(&(tb->HostWrite.CoalIntCount)));
> -       dev_dbg(&h->pdev->dev, "   Max outstanding commands =3D 0x%d\=
n",
> +       dev_dbg(&h->pdev->dev, "   Max outstanding commands =3D 0x%x\=
n",
>               readl(&(tb->CmdsOutMax)));
>        dev_dbg(&h->pdev->dev, "   Bus Types =3D 0x%x\n",
>                readl(&(tb->BusTypes)));
> =97
why not use like this : dev_dbg(&h->pdev->dev, "   Max outstanding comm=
ands =3D %#x\n=94  ?=20
%#x will add 0x prefix automatically .

Thanks



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
