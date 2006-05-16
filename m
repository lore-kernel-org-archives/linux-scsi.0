From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] Megaraid update, submission
Date: Tue, 16 May 2006 13:44:17 -0600
Message-ID: <20060516194417.GA1604@parisc-linux.org>
References: <446A14C4.8050002@garzik.org> <Pine.LNX.4.10.10605161112140.3589-200000@master.linux-ide.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57740 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750724AbWEPToT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 15:44:19 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.10.10605161112140.3589-200000@master.linux-ide.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@linux-ide.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, Seokmann.Ju@lsil.com, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Atul Mukker <Atul.Mukker@lsil.com>

On Tue, May 16, 2006 at 11:13:14AM -0700, Andre Hedrick wrote:
>  /**
> + * megaraid_pci_master_abort
> + * @dev                : pci device structure
> + *
> + * Tests for PCI Master Abort on the host adapter and clears state
> + * Returns state of error with inverted logic test to give proper
> + * state of the pci statuts bit describing master_abort.
> + */
> +static int megaraid_pci_master_abort(struct pci_dev* dev)
> +{
> +	u16 status, error_bits;
> +
> +	pci_read_config_word(dev, PCI_STATUS, &status);
> +	error_bits = (status & PCI_STATUS_REC_MASTER_ABORT);
> +	if (error_bits)
> +		pci_write_config_word(dev, PCI_STATUS, error_bits);
> +	pci_read_config_word(dev, PCI_STATUS, &status);
> +	error_bits = (status & PCI_STATUS_REC_MASTER_ABORT);
> +	return (!error_bits) ? 0 : 1;

A little clunky still.  How about:

	u16 status;
	pci_read_config_word(dev, PCI_STATUS, &status);
	if (!(status & PCI_STATUS_REC_MASTER_ABORT))
		return 0;
	pci_write_config_word(dev, PCI_STATUS, PCI_STATUS_REC_MASTER_ABORT);
	pci_read_config_word(dev, PCI_STATUS, &status);
	return (status & PCI_STATUS_REC_MASTER_ABORT) ? 1 : 0;

> @@ -2519,14 +2547,13 @@
>  	list_for_each_entry_safe(scb, tmp, &adapter->completed_list, list) {
>  
>  		if (scb->scp == scp) {	// Found command
> -
> -			list_del_init(&scb->list);	// from completed list
> -
>  			con_log(CL_ANN, (KERN_WARNING
>  			"megaraid: %ld:%d[%d:%d], abort from completed list\n",
>  				scp->serial_number, scb->sno,
>  				scb->dev_channel, scb->dev_target));
>  
> +			list_del_init(&scb->list);	// from completed list
> +
>  			scp->result = (DID_ABORT << 16);
>  			scp->scsi_done(scp);
>  

Not quite sure why this change makes any difference

> @@ -2549,8 +2576,6 @@
>  
>  		if (scb->scp == scp) {	// Found command
>  
> -			list_del_init(&scb->list);	// from pending list
> -
>  			ASSERT(!(scb->state & SCB_ISSUED));
>  
>  			con_log(CL_ANN, (KERN_WARNING
> @@ -2558,6 +2583,8 @@
>  				scp->serial_number, scb->dev_channel,
>  				scb->dev_target));
>  
> +			list_del_init(&scb->list);	// from pending list
> +
>  			scp->result = (DID_ABORT << 16);
>  			scp->scsi_done(scp);

ditto

