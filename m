From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] [SCSI] gdth: misc cleanups, preparation for
	ISA/EISA hotplug API
Date: Sat, 23 Feb 2008 23:58:10 -0500
Message-ID: <20080224045810.GA17051@infradead.org>
References: <017ac0b5a1e36b990eedfb7124c78d58f947f076.1203828195.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYBXE6L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Feb 2008 23:58:11 -0500
Content-Disposition: inline
In-Reply-To: <017ac0b5a1e36b990eedfb7124c78d58f947f076.1203828195.git.jeff@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 11:44:44PM -0500, Jeff Garzik wrote:
> Several misc. cleanups:
> 
> - remove recently-noop'd 'reverse_scan' module parm
> 
> - remove pointless function prototypes
> 
> - remove ha->pccb, its value always == &ha->cmdext
> 
> - move thrice-redundant DMA memory alloc and (in EISA's case, mapping)
>   into common functions gdth_ha_alloc(), gdth_ha_free()
> 
> - delete pointless zero-initializations of ha struct members, as these
>   are zeroed when ha is allocated (and never assigned any other value,
>   prior to the explicit zero initializations)
> 
> - consolidate thrice-repeated spinlock init

Good idea!

> +static void gdth_ha_free(gdth_ha_str *ha)
> +{
> +	if (ha->pscratch)
> +		pci_free_consistent(ha->pdev, GDTH_SCRATCH,
> +				    ha->pscratch, ha->scratch_phys);
> +	if (ha->pmsg)
> +		pci_free_consistent(ha->pdev, sizeof(gdth_msg_str),
> +				    ha->pmsg, ha->msg_phys);
> +
> +#ifdef INT_COAL
> +	if (ha->coal_stat)
> +		pci_free_consistent(ha->pdev,
> +				    sizeof(gdth_coal_status) * MAXOFFSETS,
> +				    ha->coal_stat, ha->coal_stat_phys);
> +#endif

Eventually we shoud just kill the INT_COAL ifdefed code.  It has never
been enabled and clutters up the driver quite badly.

> +#ifdef CONFIG_EISA
> +	if ((ha->type == GDT_EISA) && (ha->ccb_phys))
> +		pci_unmap_single(ha->pdev, ha->ccb_phys, sizeof(gdth_cmd_str),
> +				 PCI_DMA_BIDIRECTIONAL);
> +#endif /* CONFIG_EISA */

I don't think moving this into the common helper makes any sense, as
it's only ever done for the eisa adapter.  Just keep it local there.

> +#ifdef CONFIG_EISA
> +	if (ha->type == GDT_EISA) {
> +		ha->ccb_phys = pci_map_single(ha->pdev, &ha->cmdext,
> +				sizeof(gdth_cmd_str), PCI_DMA_BIDIRECTIONAL);
> +		if (!ha->ccb_phys)
> +			goto out_free;
> +	}
> +#endif /* CONFIG_EISA */

Same here.

