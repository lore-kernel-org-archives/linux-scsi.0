From: Christoph Hellwig <hch@lst.de>
Subject: Re: [regression] vmw_pvscsi probe fails on 4.11
Date: Thu, 2 Mar 2017 17:05:53 +0100
Message-ID: <20170302160553.GA4353@lst.de>
References: <cd383513-7fc2-5cec-9471-808e97bef27a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56913 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752427AbdCBQ3I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Mar 2017 11:29:08 -0500
Content-Disposition: inline
In-Reply-To: <cd383513-7fc2-5cec-9471-808e97bef27a@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Lo=EFc?= Yhuel <loic.yhuel@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jim Gill <jgill@vmware.com>, linux-scsi@vger.kernel.org

Please try this patch:

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index ef474a748744..c374e3b5c678 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1487,7 +1487,7 @@ static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		irq_flag &= ~PCI_IRQ_MSI;
 
 	error = pci_alloc_irq_vectors(adapter->dev, 1, 1, irq_flag);
-	if (error)
+	if (error < 0)
 		goto out_reset_adapter;
 
 	adapter->use_req_threshold = pvscsi_setup_req_threshold(adapter, true);
