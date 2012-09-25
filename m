From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] ahci: add a boot option to enable promise ahci
Date: Mon, 24 Sep 2012 23:05:18 -0400
Message-ID: <50611F6E.8000607@pobox.com>
References: <1AF0FA078A5A3541A8A8019D26081C2E88DCE6D976@ptt-ex02.promise.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57655 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2IYDFW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2012 23:05:22 -0400
In-Reply-To: <1AF0FA078A5A3541A8A8019D26081C2E88DCE6D976@ptt-ex02.promise.com.tw>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?Big5?B?VG9ueSBIdW5nIC0gUFRUIKx4t+fArw==?= <tony.hung@tw.promise.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 09/23/2012 10:34 PM, Tony Hung - PTT =ACx=B7=E7=C0=AF wrote:
> linux-3.2.0/drivers/ata/ahci.c: In function 'hptiop_host_request_call=
back':
>=20
> Use min_t(size_t, ...) to fix.
>=20
> Signed-off-by: Tony Hung <tony.hung@tw.promise.com>
> ---
>=20
> diff --git a/linux-3.2.0/drivers/ata/ahci.c b/linux-3.2.0/drivers/ata=
/ahci.c
> --- a/linux-3.2.0/drivers/ata/ahci.c	2012-08-29 13:40:26.046851693 +0=
800
> +++ b/linux-3.2.0/drivers/ata/ahci.c	2012-08-30 17:23:10.207838960 +0=
800
> @@ -430,6 +430,9 @@ static int marvell_enable =3D 1;
>   module_param(marvell_enable, int, 0644);
>   MODULE_PARM_DESC(marvell_enable, "Marvell SATA via AHCI (1 =3D enab=
led)");
>=20
> +static int promise_enable;
> +module_param(promise_enable, int, 0644);
> +MODULE_PARM_DESC(promise_enable, "Promise SATA via AHCI (1 =3D enabl=
ed)");
>=20
>   static void ahci_pci_save_initial_config(struct pci_dev *pdev,
>   					 struct ahci_host_priv *hpriv)
> @@ -1049,6 +1052,16 @@ static int ahci_init_one(struct pci_dev
>   	if (pdev->vendor =3D=3D PCI_VENDOR_ID_MARVELL && !marvell_enable)
>   		return -ENODEV;
>=20
> +        /*
> +         * In RAID mode, Promise software RAID need to replace
> +         * original AHCI module, but if AHCI driver build-in kernel,
> +         * Promise AHCI module need a boot option to disable it
> +         */
> +        if (promise_enable &&
> +            ((pdev->class >> 8) =3D=3D PCI_CLASS_STORAGE_RAID) &&
> +             (pdev->vendor =3D=3D PCI_VENDOR_ID_ATI ||
> +              pdev->vendor =3D=3D PCI_VENDOR_ID_AMD))
> +                return -ENODEV;

We need the patch for the Promise Software RAID driver, to accept this.=
=2E.

	Jeff




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
