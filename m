From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH] csiostor: switch to pci_alloc_irq_vectors
Date: Mon, 3 Apr 2017 20:21:26 +0530
Message-ID: <20170403145124.GA1743@chelsio.com>
References: <1484325046-31032-1-git-send-email-hch@lst.de>
 <yq1h94tgsvd.fsf@oracle.com>
 <20170331065527.GA3024@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:19851 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753390AbdDCOvi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2017 10:51:38 -0400
Content-Disposition: inline
In-Reply-To: <20170331065527.GA3024@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Mar 31, 2017 at 12:25:27PM +0530, Christoph Hellwig wrote:
> On Fri, Jan 20, 2017 at 07:27:02PM -0500, Martin K. Petersen wrote:
> > >>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
> >
> > Christoph> And get automatic MSI-X affinity for free.
> >
> > Chelsio folks: Please review and test!
>
> ping!

csiostor driver is triggering WARN_ON with this patch
drivers/pci/msi.c:1193

1172 int pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
1173                                    unsigned int max_vecs, unsigned int flags,
1174                                    const struct irq_affinity *affd)
1175 {
1176         static const struct irq_affinity msi_default_affd;
1177         int vecs = -ENOSPC;
1178
1179         if (flags & PCI_IRQ_AFFINITY) {
		...
1192         } else {
1193                 if (WARN_ON(affd))
1194                         affd = NULL;
1195         }


PCI_IRQ_AFFINITY flag is missing

+	cnt = pci_alloc_irq_vectors_affinity(hw->pdev, min, cnt, PCI_IRQ_MSIX,
+			&desc);
+	if (cnt < 0)
 		return cnt;
-	}
