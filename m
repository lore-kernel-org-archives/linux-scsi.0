From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH 2/5] mpt fusion: Added msi enable disable for FC,SPI and
	SAS
Date: Tue, 6 Jan 2009 10:00:16 -0800
Message-ID: <da824cf30901061000k249f06abi3f3e6419840590ba@mail.gmail.com>
References: <20090106093141.GD13033@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:15837 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbZAFSAW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 13:00:22 -0500
Received: from spaceape10.eur.corp.google.com (spaceape10.eur.corp.google.com [172.28.16.144])
	by smtp-out.google.com with ESMTP id n06I0KCo021335
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2009 10:00:21 -0800
Received: from bwz13 (bwz13.prod.google.com [10.188.26.13])
	by spaceape10.eur.corp.google.com with ESMTP id n06HxXse004602
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2009 10:00:16 -0800
Received: by bwz13 with SMTP id 13so644271bwz.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2009 10:00:16 -0800 (PST)
In-Reply-To: <20090106093141.GD13033@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com, sathyap@lsi.com, James.Bottomley@hansenpartnership.com

On Tue, Jan 6, 2009 at 1:32 AM, Kashyap, Desai <kashyap.desai@lsi.com> wrote:
>
> Added support for MSI enable/disable for different buses FC,SPI,SAS instead
> of having single MSI enable/disable feature.
> ---
>
> Signed-off-by: Kashyap Desai <kadesai@lsi.com>
> ---
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index c4e8b9a..55d9a7e 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -79,9 +79,22 @@ MODULE_VERSION(my_VERSION);
>  /*
>  *  cmd line parameters
>  */
> -static int mpt_msi_enable = -1;
> -module_param(mpt_msi_enable, int, 0);
> -MODULE_PARM_DESC(mpt_msi_enable, " MSI Support Enable (default=0)");
> +
> +static int mpt_msi_enable_spi;
> +module_param(mpt_msi_enable_spi, int, 0);
> +MODULE_PARM_DESC(mpt_msi_enable_spi, " Enable MSI Support for SPI \
> +               controllers (default=0)");

Hi,
This patch looks fine to me.

But, is there a reason the msi enable flags are 0 (disabled) by default?

I was expecting these to be enabled unless MPT firmware has
some known bugs. If the chipset is known buggy, a global flag will
disable MSI for all devices anyway.

thanks,
grant

> +
> +static int mpt_msi_enable_fc;
> +module_param(mpt_msi_enable_fc, int, 0);
> +MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
> +               controllers (default=0)");
> +
> +static int mpt_msi_enable_sas;
> +module_param(mpt_msi_enable_sas, int, 0);
> +MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
> +               controllers (default=0)");
> +
>
>  static int mpt_channel_mapping;
>  module_param(mpt_channel_mapping, int, 0);
> @@ -91,7 +104,9 @@ static int mpt_debug_level;
>  static int mpt_set_debug_level(const char *val, struct kernel_param *kp);
>  module_param_call(mpt_debug_level, mpt_set_debug_level, param_get_int,
>                  &mpt_debug_level, 0600);
> -MODULE_PARM_DESC(mpt_debug_level, " debug level - refer to mptdebug.h - (default=0)");
> +MODULE_PARM_DESC(mpt_debug_level, " debug level - refer to mptdebug.h \
> +       - (default=0)");
> +
>
>  #ifdef MFCNT
>  static int mfcounter = 0;
> @@ -1751,16 +1766,25 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>                ioc->bus_type = SAS;
>        }
>
> -       if (mpt_msi_enable == -1) {
> -               /* Enable on SAS, disable on FC and SPI */
> -               if (ioc->bus_type == SAS)
> -                       ioc->msi_enable = 1;
> -               else
> -                       ioc->msi_enable = 0;
> -       } else
> -               /* follow flag: 0 - disable; 1 - enable */
> -               ioc->msi_enable = mpt_msi_enable;
>
> +       switch (ioc->bus_type) {
> +
> +       case SAS:
> +               ioc->msi_enable = mpt_msi_enable_sas;
> +               break;
> +
> +       case SPI:
> +               ioc->msi_enable = mpt_msi_enable_spi;
> +               break;
> +
> +       case FC:
> +               ioc->msi_enable = mpt_msi_enable_fc;
> +               break;
> +
> +       default:
> +               ioc->msi_enable = 0;
> +               break;
> +       }
>        if (ioc->errata_flag_1064)
>                pci_disable_io_access(pdev);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
