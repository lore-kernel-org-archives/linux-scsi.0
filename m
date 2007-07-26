From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 8/21] advansys: Rewrite resource management
Date: Thu, 26 Jul 2007 15:41:22 -0400
Message-ID: <46A8F8E2.60309@garzik.org>
References: 20070726171141.GE19275@parisc-linux.org <11854705773172-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50961 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763272AbXGZTlY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 15:41:24 -0400
In-Reply-To: <11854705773172-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> @@ -18787,8 +18765,10 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	int ioport;
>  	struct Scsi_Host *shost;
>  
> -	if (pci_enable_device(pdev))
> +	if (pci_request_regions(pdev, "advansys"))
>  		goto fail;
> +	if (pci_enable_device(pdev))
> +		goto release_regions;
>  
>  	ioport = pci_resource_start(pdev, 0);
>  	shost = advansys_board_found(ioport, &pdev->dev, ASC_IS_PCI);
> @@ -18799,6 +18779,8 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	}
>  
>  	pci_disable_device(pdev);
> + release_regions:
> +	pci_release_regions(pdev);
>   fail:
>  	return -ENODEV;
>  }
> @@ -18807,6 +18789,7 @@ static void __devexit advansys_pci_remove(struct pci_dev *pdev)
>  {
>  	advansys_remove(pci_get_drvdata(pdev));
>  	pci_disable_device(pdev);
> +	pci_release_regions(pdev);

Your ordering here is completely backwards.

You do not have resources to reserve, until you have enabled the device.

pci_enable_device() ALWAYS comes first, and pci_disable_device() always 
comes next-to-last (pci_set_drvdata(pdev, NULL) is last).

	Jeff


