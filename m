From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 4/5] qla2xxx: Add Block Multi Queue functionality.
Date: Thu, 1 Dec 2016 02:25:37 -0800
Message-ID: <20161201102537.GA7894@infradead.org>
References: <1480537497-16429-1-git-send-email-himanshu.madhani@cavium.com>
 <1480537497-16429-5-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45125 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755413AbcLAKZk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2016 05:25:40 -0500
Content-Disposition: inline
In-Reply-To: <1480537497-16429-5-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

> -	pci_disable_msix(ha->pdev);
> +	pci_free_irq_vectors(ha->pdev);

Please make the switch to pci_alloc_irq_vectors / pci_free_irq_vectors
a se[arate patch.

> +	ret = pci_alloc_irq_vectors(ha->pdev,
> +		MIN_MSIX_COUNT, ha->msix_count, PCI_IRQ_MSIX);

And for proper blk-mq support you must use PCI_IRQ_AFFINITY to get
the affinity right.

>  		/* Recalculate queue values */
> -		if (ql2xmqsupport) {
> +		if (ha->mqiobase && ql2xmqsupport) {

Where is that change coming from?

>  			cpus = num_online_cpus();
>  			ha->max_req_queues = (ha->msix_count - 1 > cpus) ?
>  				(cpus + 1) : (ha->msix_count - 1);
> -			ha->max_rsp_queues = ha->max_req_queues;
>  
>  			/* ATIOQ needs 1 vector. That's 1 less QPair */
>  			if (QLA_TGT_MODE_ENABLED())
>  				ha->max_req_queues--;

And don't do your own look at online cpus and queue spreading, that's
what PCI_IRQ_AFFINITY and blk_mq_pci_map_queues are for.

>  		    "MSI: Enabled.\n");
> @@ -3273,11 +3261,10 @@ struct qla_init_msix_entry {
>  
>  	if (ha->flags.msix_enabled)
>  		qla24xx_disable_msix(ha);
> -	else if (ha->flags.msi_enabled) {
> -		free_irq(ha->pdev->irq, rsp);
> -		pci_disable_msi(ha->pdev);
> -	} else
> -		free_irq(ha->pdev->irq, rsp);
> +	else {
> +		free_irq(pci_irq_vector(ha->pdev, 0), rsp);
> +		pci_free_irq_vectors(ha->pdev);
> +	}

Please also kill off qla24xx_disable_msix, and have a single
callsite that iterates over all vectors and finally calls
pci_free_irq_vectors.

> -	if (ql2xmqsupport) {
> +	if (ql2xmqsupport && ha->max_qpairs) {

Where does this come from?
