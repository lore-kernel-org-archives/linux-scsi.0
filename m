From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 1/2] qla2xxx: Fix a recently introduced memory leak
Date: Sun, 29 Jan 2017 10:07:36 +0100
Message-ID: <20170129090736.GA10369@lst.de>
References: <20170123163446.9227-1-bart.vanassche@sandisk.com> <20170123163446.9227-2-bart.vanassche@sandisk.com> <1485359225.3093.3.camel@sandisk.com> <20170126143614.GA19849@lst.de> <1485667034.15853.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43483 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751057AbdA2NXe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Jan 2017 08:23:34 -0500
Content-Disposition: inline
In-Reply-To: <1485667034.15853.1.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Bart,

thanks for the analysis.  I think the main issue here is that we shouldn't
try to assign affinity masks if there are not affinity vectors left to
assign.

Does the patch below fix the issue for you?

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 50c5003..96c0713 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1206,6 +1206,11 @@ int pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
 	if (flags & PCI_IRQ_AFFINITY) {
 		if (!affd)
 			affd = &msi_default_affd;
+
+		if (affd->pre_vectors + affd->post_vectors > min_vecs)
+			return -EINVAL;
+		if (affd->pre_vectors + affd->post_vectors == min_vecs)
+			flags &=~ PCI_IRQ_AFFINITY;
 	} else {
 		if (WARN_ON(affd))
 			affd = NULL;
