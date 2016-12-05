From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 3/6] qla2xxx: Utilize
 pci_alloc_irq_vectors/pci_free_irq_vectors calls.
Date: Mon, 5 Dec 2016 04:54:30 -0800
Message-ID: <20161205125430.GA23221@infradead.org>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
 <1480715097-13611-4-git-send-email-himanshu.madhani@cavium.com>
 <91f64303-4677-7740-4c3e-7a0c71f7faca@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57919 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbcLEMyd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 07:54:33 -0500
Content-Disposition: inline
In-Reply-To: <91f64303-4677-7740-4c3e-7a0c71f7faca@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

> > +	if (ha->flags.msix_enabled) {
> > +		for (i = 0; i < ha->msix_count; i++) {
> > +			qentry = &ha->msix_entries[i];
> > +			if (qentry->have_irq) {
> > +				irq_set_affinity_notifier(qentry->vector, NULL);
> Not sure if that's still required; with the new irq affinity framework I
> guess you can drop it.

It shouldn't be required in the end, but keeping the switch to the
new IRQ helpers from the change to the affinity assignment separate
makes sense.
