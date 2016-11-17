From: Christoph Hellwig <hch@lst.de>
Subject: use PCI layer IRQ affinity in lpfc
Date: Thu, 17 Nov 2016 16:14:51 +0100
Message-ID: <1479395693-5781-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49050 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932346AbcKQRFs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2016 12:05:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@broadcom.com
Cc: hare@suse.de, linux-scsi@vger.kernel.org

This series has two patches: the first is a simple conversion of
lpfc to use pci_alloc_irq_vectors.  The second is more interesting,
and makes use of the PCI_IRQ_AFFINITY option to use the core interrupt
affinity assignment that takes nodes into account and can be easily
queried.  It also ensures we propagate this information to blk-mq
to make sure the block layer queues are properly aligned to the
interrupt vectors.

Note that these patches require core IRQ changes from a stable
branch in the tip tree to be pulled in first:

	git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/for-block

Also be aware that I don't have any lpfc hardware to actually test these.
