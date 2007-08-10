From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] [MEGARAID_SAS]: Use pr_info
Date: Fri, 10 Aug 2007 13:26:33 -0500
Message-ID: <46BCADD9.4090304@linux.vnet.ibm.com>
References: <0631C836DBF79F42B5A60C8C8D4E8229BF1885@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:56150 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbXHJS0s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2007 14:26:48 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7AIQkYT009838
	for <linux-scsi@vger.kernel.org>; Fri, 10 Aug 2007 14:26:46 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7AIQjVO215588
	for <linux-scsi@vger.kernel.org>; Fri, 10 Aug 2007 12:26:45 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7AIQj6n030565
	for <linux-scsi@vger.kernel.org>; Fri, 10 Aug 2007 12:26:45 -0600
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229BF1885@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Patro, Sumant" <Sumant.Patro@lsi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, linux-scsi@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

Patro, Sumant wrote:
> Hello Arnaldo,
> 	
> 	Throughout the megaraid_sas driver code there are printk's with
> appropriate flags (that includes KERN_INFO). What is the incentive to
> change printk with KERN_INFO to pr_info?

And why not change most of these to dev_printk and friends?

-Brian

> 
> Regards,
> 
> Sumant
> 
> -----Original Message-----
> From: Arnaldo Carvalho de Melo [mailto:arnaldo.melo@gmail.com] On Behalf
> Of Arnaldo Carvalho de Melo
> Sent: Wednesday, August 08, 2007 4:15 PM
> To: DL-MegaRAID Linux
> Cc: linux-scsi@vger.kernel.org; James Bottomley
> Subject: [PATCH] [MEGARAID_SAS]: Use pr_info
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> ---
>  drivers/scsi/megaraid/megaraid_sas.c |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas.c
> b/drivers/scsi/megaraid/megaraid_sas.c
> index 59099da..4a8cf06 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.c
> +++ b/drivers/scsi/megaraid/megaraid_sas.c
> @@ -1341,8 +1341,7 @@ megasas_transition_to_ready(struct
> megasas_instance* instance)
>  	fw_state =
> instance->instancet->read_fw_status_reg(instance->reg_set) &
> MFI_STATE_MASK;
> 
>  	if (fw_state != MFI_STATE_READY)
> - 		printk(KERN_INFO "megasas: Waiting for FW to come to
> ready"
> - 		       " state\n");
> + 		pr_info("megasas: Waiting for FW to come to ready
> state\n");
> 
>  	while (fw_state != MFI_STATE_READY) {
> 
> @@ -1444,7 +1443,7 @@ megasas_transition_to_ready(struct
> megasas_instance* instance)
>  			return -ENODEV;
>  		}
>  	};
> - 	printk(KERN_INFO "megasas: FW now in Ready state\n");
> + 	pr_info("megasas: FW now in Ready state\n");
> 
>  	return 0;
>  }
> @@ -2277,9 +2276,9 @@ megasas_probe_one(struct pci_dev *pdev, const
> struct pci_device_id *id)
>  	/*
>  	 * Announce PCI information
>  	 */
> -	printk(KERN_INFO "megasas: %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
> -	       pdev->vendor, pdev->device, pdev->subsystem_vendor,
> -	       pdev->subsystem_device);
> +	pr_info("megasas: %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
> +		pdev->vendor, pdev->device, pdev->subsystem_vendor,
> +		pdev->subsystem_device);
> 
>  	printk("bus %d:slot %d:func %d\n",
>  	       pdev->bus->number, PCI_SLOT(pdev->devfn),
> PCI_FUNC(pdev->devfn)); @@ -3030,8 +3029,7 @@ static int __init
> megasas_init(void)
>  	/*
>  	 * Announce driver version and other information
>  	 */
> -	printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
> -	       MEGASAS_EXT_VERSION);
> +	pr_info("megasas: %s %s\n", MEGASAS_VERSION,
> MEGASAS_EXT_VERSION);
> 
>  	/*
>  	 * Register character device node
> --
> 1.5.2.2
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
