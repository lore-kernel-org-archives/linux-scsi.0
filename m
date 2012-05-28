From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v4 02/13] libata: bind the Linux device tree to the ACPI
 device tree
Date: Mon, 28 May 2012 10:51:31 +0100
Message-ID: <20120528105131.67d74d45@pyramind.ukuu.org.uk>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
	<1338181720-4149-3-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1338181720-4149-3-git-send-email-ming.m.lin@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <David.Woodhouse@intel.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +static int is_pci_ata(struct device *dev)
> +{
> +	struct pci_dev *pdev;
> +
> +	if (!is_pci_dev(dev))
> +		return 0;
> +
> +	pdev = to_pci_dev(dev);
> +
> +	if ((pdev->class >> 8) != PCI_CLASS_STORAGE_SATA &&
> +	    (pdev->class >> 8) != PCI_CLASS_STORAGE_IDE)
> +		return 0;

This needs a better name. It doesn't check if a device is PCI ATA or
anything of the sort, it checks if its probably a device in compatibility
mode. A lot of controllers will in fact report RAID class or similar in
native mode.

Alan
