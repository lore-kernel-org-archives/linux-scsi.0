From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] mpt3sas: switch to pci_alloc_irq_vectors
Date: Fri, 2 Dec 2016 15:30:37 +0100
Message-ID: <20161202143036.GB31264@lst.de>
References: <1480679607-79306-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34089 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758563AbcLBOaj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 09:30:39 -0500
Content-Disposition: inline
In-Reply-To: <1480679607-79306-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

> +static inline u16
>  _base_get_msix_index(struct MPT3SAS_ADAPTER *ioc)
>  {
> +	return pci_irq_get_affinity_vector(ioc->pdev, raw_smp_processor_id());
>  }

This looks extremely sketchy. Are we guaranteed to always have enough
MSI-X vectors that each CPU has it's own?  I'd much prefer to keep the
indirection array of the existing code.

> +static int scsih_map_queues(struct Scsi_Host *shost)
> +{
> +	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
> +
> +	return blk_mq_pci_map_queues(&shost->tag_set, ioc->pdev, 0);
> +}

Given that mpt3sas only supports a single hardware queue (and doesn't
set the nr_hw_queues field) this is pointless and won't have any effect.
