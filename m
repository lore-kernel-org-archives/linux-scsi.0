From: akpm@osdl.org
Subject: [patch 21/45] ioremap balanced with iounmap for drivers/scsi/ncr53c8xx.c
Date: Fri, 20 Oct 2006 14:48:21 -0700
Message-ID: <200610202148.k9KLmLm9004130@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:41094 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992778AbWJTVsf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:48:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, amol@verismonetworks.com, alan@lxorguk.ukuu.org.uk

From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/ncr53c8xx.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/ncr53c8xx.c~ioremap-balanced-with-iounmap-drivers-scsi-ncr53c8xxc drivers/scsi/ncr53c8xx.c
--- a/drivers/scsi/ncr53c8xx.c~ioremap-balanced-with-iounmap-drivers-scsi-ncr53c8xxc
+++ a/drivers/scsi/ncr53c8xx.c
@@ -8563,6 +8563,8 @@ struct Scsi_Host * __init ncr_attach(str
 		m_free_dma(np->script0, sizeof(struct script), "SCRIPT");
 	if (np->ccb)
 		m_free_dma(np->ccb, sizeof(struct ccb), "CCB");
+	if (!device->slot.base_v && np->vaddr)
+		iounmap(np->vaddr);
 	m_free_dma(np, sizeof(struct ncb), "NCB");
 	host_data->ncb = NULL;
 
_
