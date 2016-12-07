From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 3/6] qla2xxx: Utilize
 pci_alloc_irq_vectors/pci_free_irq_vectors calls.
Date: Wed, 7 Dec 2016 11:03:42 -0800
Message-ID: <20161207190342.GA29031@infradead.org>
References: <1481051266-32362-1-git-send-email-himanshu.madhani@cavium.com>
 <1481051266-32362-4-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34040 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932473AbcLGTDy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2016 14:03:54 -0500
Content-Disposition: inline
In-Reply-To: <1481051266-32362-4-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>  static int
>  qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
>  {
>  #define MIN_MSIX_COUNT	2
>  #define ATIO_VECTOR	2
>  	int i, ret;
>  	struct qla_msix_entry *qentry;
>  	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
>  
> +	ret = pci_alloc_irq_vectors(ha->pdev,
> +	    MIN_MSIX_COUNT, ha->msix_count, PCI_IRQ_MSIX|PCI_IRQ_AFFINITY);

Given that as-is the code only uses two vectors, and they are not
for per-cpu queues using PCI_IRQ_AFFINITY is actually wrong, and
you're better off without it.  Also please fix the spacing:
tabs for aligning continued arguments, and spaces around operators
(although the revised version won't have an operator - so this is
just for future reference:

	ret = pci_alloc_irq_vectors(ha->pdev, MIN_MSIX_COUNT,
			ha->msix_count, PCI_IRQ_MSIX);

> +	struct rsp_que *rsp = (struct rsp_que *)e->handle;

No need for the cast here.

> +	struct rsp_que *rsp = (struct rsp_que *)e->handle;

Same here.
