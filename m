From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 9/21] advansys: More PCI cleanups
Date: Thu, 26 Jul 2007 15:43:39 -0400
Message-ID: <46A8F96B.9080002@garzik.org>
References: 20070726171141.GE19275@parisc-linux.org <11854705772242-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50984 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765727AbXGZTnl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 15:43:41 -0400
In-Reply-To: <11854705772242-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> @@ -18759,6 +18558,19 @@ static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
>  
>  MODULE_DEVICE_TABLE(pci, advansys_pci_tbl);
>  
> +static void __devinit advansys_set_latency(struct pci_dev *pdev)
> +{
> +	if ((pdev->device == PCI_DEVICE_ID_ASP_1200A) ||
> +	    (pdev->device == PCI_DEVICE_ID_ASP_ABP940)) {
> +		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0);
> +	} else {
> +		u8 latency;
> +		pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &latency);
> +		if (latency < 0x20)
> +			pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x20);
> +	}

the latter branch is useless -- pci_set_master() ensures 
PCI_LATENCY_TIMER is adequate

