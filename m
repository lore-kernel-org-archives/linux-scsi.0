From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 5/14] megaraid_sas: Fix probe_one to clear MSI-X flags
 in kdump
Date: Wed, 30 Mar 2011 14:30:54 +0200
Message-ID: <4D93227E.4040407@redhat.com>
References: <AANLkTimG4HbXCNUdkcpGHbP7D2oNmvymbyKMOkCFNxJD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab1C3Ma7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 08:30:59 -0400
In-Reply-To: <AANLkTimG4HbXCNUdkcpGHbP7D2oNmvymbyKMOkCFNxJD@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On 02/25/2011 05:56 AM, adam radford wrote:
> James/Linux-scsi,
>
> The following patch for megaraid_sas fixes megasas_probe_one() to
> clear MSI-X flags in kdump when the 'reset_devices' kernel parameter
> is passed in.
>
> Signed-off-by: Adam Radford <aradford@gmail.com>
>
>   

> diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
> scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
> --- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
> 18:43:13.853276151 -0800
> +++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
> 18:47:27.480306538 -0800
> @@ -3901,9 +3901,26 @@
>  static int __devinit
>  megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
> -	int rval;
> +	int rval, pos;
>  	struct Scsi_Host *host;
>  	struct megasas_instance *instance;
> +	u16 control = 0;
> +
> +	/* Reset MSI-X in the kdump kernel */
> +	if (reset_devices) {
> +		pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
> +		if (pos) {
> +			pci_read_config_word(pdev, msi_control_reg(pos),
> +					     &control);
> +			if (control & PCI_MSIX_FLAGS_ENABLE) {
> +				dev_info(&pdev->dev, "resetting MSI-X\n");
> +				pci_write_config_word(pdev,
> +						      msi_control_reg(pos),
> +						      control &
> +						      ~PCI_MSIX_FLAGS_ENABLE);
> +			}
> +		}
> +	}
>
>  	/*
>  	 * Announce PCI information
> diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h
> scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h
> --- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h	2011-02-24
> 18:03:29.324307767 -0800
> +++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h	2011-02-24
> 18:47:51.394307254 -0800
> @@ -1477,4 +1477,7 @@
>  	int max_index;
>  };
>
> +#define msi_control_reg(base) (base + PCI_MSI_FLAGS)
> +#define PCI_MSIX_FLAGS_ENABLE (1 << 15)
> +
>  #endif				/*LSI_MEGARAID_SAS_H */
>   
Hi Adam,
sorry I'm late, but this is still not applied I think.

The above #define are already defined in msi.h and pci_regs.h
I'd prefer to include those files instead of define the values.

Thanks, Tomas


