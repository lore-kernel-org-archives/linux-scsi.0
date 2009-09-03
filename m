From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V3.
Date: Thu, 03 Sep 2009 16:52:31 -0500
Message-ID: <4AA03A9F.2040500@linux.vnet.ibm.com>
References: <1252006675.18725.20.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47119 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211AbZICVwd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 17:52:33 -0400
In-Reply-To: <1252006675.18725.20.camel@ank32.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akataria@vmware.com
Cc: James Bottomley <James.Bottomley@suse.de>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Matthew Wilcox <matthew@wil.cx>, Roland Dreier <rdreier@cisco.com>, Bart Van Assche <bvanassche@acm.org>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, pv-drivers@vmware.com

Alok Kataria wrote:
> +
> +struct pvscsi_adapter {
> +	char			*mmioBase;
> +	unsigned int		irq;
> +	u8			rev;
> +	bool			use_msi;
> +	bool			use_msix;
> +	bool			use_msg;
> +
> +	spinlock_t		hw_lock;

Why not just use host_lock in the scsi_host structure?


> +
> +/*
> + * Map all data buffers for a command into PCI space and
> + * setup the scatter/gather list if needed.
> + */
> +static void pvscsi_map_buffers(struct pvscsi_adapter *adapter,
> +			       struct pvscsi_ctx *ctx,
> +			       struct scsi_cmnd *cmd, PVSCSIRingReqDesc *e)
> +{
> +	unsigned count;
> +	unsigned bufflen = scsi_bufflen(cmd);
> +	struct scatterlist *sg;
> +
> +	e->dataLen = bufflen;
> +	e->dataAddr = 0;
> +	if (bufflen == 0)
> +		return;
> +
> +	sg = scsi_sglist(cmd);
> +	count = scsi_sg_count(cmd);
> +	if (count != 0) {
> +		int segs = pci_map_sg(adapter->dev, sg, count,
> +				      cmd->sc_data_direction);

Should use scsi_dma_map here instead.

> +		if (segs > 1) {
> +			pvscsi_create_sg(ctx, sg, segs);
> +
> +			e->flags |= PVSCSI_FLAG_CMD_WITH_SG_LIST;
> +			ctx->sglPA = pci_map_single(adapter->dev, ctx->sgl,
> +						    SGL_SIZE, PCI_DMA_TODEVICE);
> +			e->dataAddr = ctx->sglPA;
> +		} else
> +			e->dataAddr = sg_dma_address(sg);
> +	} else {
> +		/*
> +		 * In case there is no S/G list, scsi_sglist points
> +		 * directly to the buffer.
> +		 */
> +		ctx->dataPA = pci_map_single(adapter->dev, sg, bufflen,
> +					     cmd->sc_data_direction);
> +		e->dataAddr = ctx->dataPA;
> +	}
> +}
> +
> +static void pvscsi_unmap_buffers(const struct pvscsi_adapter *adapter,
> +				 struct pvscsi_ctx *ctx)
> +{
> +	struct scsi_cmnd *cmd;
> +	unsigned bufflen;
> +
> +	cmd = ctx->cmd;
> +	bufflen = scsi_bufflen(cmd);
> +
> +	if (bufflen != 0) {
> +		unsigned count = scsi_sg_count(cmd);
> +
> +		if (count != 0) {
> +			pci_unmap_sg(adapter->dev, scsi_sglist(cmd), count,
> +				     cmd->sc_data_direction);

Use scsi_dma_unmap here instead.

> +			if (ctx->sglPA) {
> +				pci_unmap_single(adapter->dev, ctx->sglPA,
> +						 SGL_SIZE, PCI_DMA_TODEVICE);
> +				ctx->sglPA = 0;
> +			}
> +		} else
> +			pci_unmap_single(adapter->dev, ctx->dataPA, bufflen,
> +					 cmd->sc_data_direction);
> +	}
> +	if (cmd->sense_buffer)
> +		pci_unmap_single(adapter->dev, ctx->sensePA,
> +				 SCSI_SENSE_BUFFERSIZE, PCI_DMA_FROMDEVICE);
> +}
> +


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


