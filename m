From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] Megaraid update, submission
Date: Tue, 16 May 2006 14:07:00 -0400
Message-ID: <446A14C4.8050002@garzik.org>
References: <Pine.LNX.4.10.10605161020140.3589-200000@master.linux-ide.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:15502 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751563AbWEPSHF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 14:07:05 -0400
In-Reply-To: <Pine.LNX.4.10.10605161020140.3589-200000@master.linux-ide.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@linux-ide.org>
Cc: linux-scsi@vger.kernel.org, Seokmann.Ju@lsil.com, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Atul Mukker <Atul.Mukker@lsil.com>

Andre Hedrick wrote:
> +static int megaraid_pci_master_abort(struct pci_dev* dev)
> +{
> +	u16 status, error_bits;
> +
> +	pci_read_config_word(dev, PCI_STATUS, &status);
> +	if (error_bits)
> +		pci_write_config_word(dev, PCI_STATUS, error_bits);
> +	pci_read_config_word(dev, PCI_STATUS, &status);

error_bits is used before a value is assigned to it.  Presumably you are 
missing a duplicate of a line further down in the function,

	error_bits = (status & PCI_STATUS_REC_MASTER_ABORT);

The list stuff looks OK, to my quick glance.

	Jeff


