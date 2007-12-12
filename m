From: Dave Jones <davej@redhat.com>
Subject: fix cciss locking bug.
Date: Tue, 11 Dec 2007 22:44:18 -0500
Message-ID: <20071212034418.GA25644@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbXLLDo2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Dec 2007 22:44:28 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Miller <mike.miller@hp.com>

do_cciss_intr takes the controller lock on entry,
and if something goes wrong, it calls fail_all_cmds
which tries to take the same lock.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 7d70496..1c57583 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2756,6 +2756,7 @@ static irqreturn_t do_cciss_intr(int irq, void *dev_id)
 					printk(KERN_WARNING
 					       "cciss: controller cciss%d failed, stopping.\n",
 					       h->ctlr);
+					spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 					fail_all_cmds(h->ctlr);
 					return IRQ_HANDLED;
 				}

-- 
http://www.codemonkey.org.uk
