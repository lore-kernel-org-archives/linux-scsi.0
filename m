From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 4/5] qla2xxx: Add Block Multi Queue functionality.
Date: Tue, 13 Dec 2016 04:16:50 -0800
Message-ID: <20161213121650.GC16734@infradead.org>
References: <1481582409-22027-1-git-send-email-himanshu.madhani@cavium.com>
 <1481582409-22027-5-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46064 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932577AbcLMMQ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 07:16:57 -0500
Content-Disposition: inline
In-Reply-To: <1481582409-22027-5-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Mon, Dec 12, 2016 at 02:40:08PM -0800, Himanshu Madhani wrote:
> From: Michael Hernandez <michael.hernandez@cavium.com>
> 
> Tell the SCSI layer how many hardware queues we have based on the number
> of max queue pairs created. The number of max queue pairs created will
> depend on number of MSI-X vector count.
> 
> This feature can be turned on via CONFIG_SCSI_MQ_DEFAULT or passing
> scsi_mod.use_blk_mq=Y as a parameter to the kernel

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

> +static int qla2xxx_map_queues(struct Scsi_Host *shost)
> +{
> +	scsi_qla_host_t *vha = (scsi_qla_host_t *)shost->hostdata;
> +
> +	return blk_mq_pci_map_queues(&shost->tag_set, vha->hw->pdev);
> +}

FYI, without the PCI_IRQ_AFFINITY flag this is useless, but also
harmless.  I'd suggest you send a patch to introduce irq-layer
affinity once we have that in mainline.
