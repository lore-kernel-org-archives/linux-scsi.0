From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 6/24] advansys: Convert to pci_register_driver interface
Date: Fri, 27 Jul 2007 10:15:20 -0400
Message-ID: <46A9FDF8.9000504@garzik.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437531497-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58033 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933505AbXG0OPW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 10:15:22 -0400
In-Reply-To: <11855437531497-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> +static int __devinit
> +advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	int err, ioport;
> +	struct Scsi_Host *shost;
> +
> +	err = pci_enable_device(pdev);
> +	if (err)
> +		goto fail;
> +
> +	ioport = pci_resource_start(pdev, 0);
> +	shost = advansys_board_found(ioport, &pdev->dev, ASC_IS_PCI);
> +
> +	if (shost) {
> +		pci_set_drvdata(pdev, shost);
> +		return 0;
> +	}
> +
> +	err = -ENODEV;
> +	pci_disable_device(pdev);
> + fail:
> +	return err;


minor nit:

it is far more like other Linux drivers to do

	if (!shost) {
		err = -ENODEV;
		goto err_out_shost;
	}

	pci_set_drvdata(pdev, shost);
	return 0;

It keeps the main, non-error path at the lowest indentation level, which 
is more future-proof (easier to add more clauses later).

It also makes your PCI probe function easier to review, to ensure that 
the order of initialization matches the reversed-order of shutdown in 
pci_driver::remove()

	Jeff


