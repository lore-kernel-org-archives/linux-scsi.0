From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Mon, 4 Aug 2008 14:43:20 -0600
Message-ID: <200808041443.20942.bjorn.helgaas@hp.com>
References: <1217786532.4179.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1217786532.4179.24.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-pci-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sunday 03 August 2008 12:02:12 pm James Bottomley wrote:
> +static void pci_note_irq_problem(struct pci_dev *pdev, const char *reason)
> +{
> +	struct pci_dev *parent = to_pci_dev(pdev->dev.parent);
> +
> +	dev_printk(KERN_ERR, &pdev->dev,
> +		   "Potentially misrouted IRQ (Bridge %s %04x:%04x)\n",
> +		   parent->dev.bus_id, parent->vendor, parent->device);

Do you prefer "dev_printk(KERN_ERR, ...)" over "dev_err(...)"?  Easier
to grep for the former, maybe?  If so, should we deprecate "dev_err()"
and friends?  When I converted most of the PCI core to use dev_printk(),
(80ccba1186d48f ...) I used dev_err(), but I don't really care one way
or the other.

Maybe use pci_name(parent)?

I tried to standardize the PCI core on "[%04x/%04x]" for vendor/device ID.

Bjorn
