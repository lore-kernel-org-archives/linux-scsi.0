From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 30/48] hpsa: optimize cmd_alloc function by remembering
 last allocation
Date: Fri, 23 Jan 2015 16:43:41 -0600
Message-ID: <20150123224340.14919.95076.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:49087 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbbAWWof (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:44:35 -0500
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id EFF5B15C7
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2015 22:44:34 +0000 (UTC)
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Empirically, this improves performance slightly (~2% max IOPS) by
allowing cmd_alloc to remember where it left off searching for
free commands between calls instead of always starting its search
at command 0.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    7 +++++--
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c95a20c..72abcf3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4649,9 +4649,10 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 	union u64bit temp64;
 	dma_addr_t cmd_dma_handle, err_dma_handle;
 	int refcount;
-	unsigned long offset = 0;
+	unsigned long offset;
 
-	/* There is some *extremely* small but non-zero chance that that
+	/*
+	 * There is some *extremely* small but non-zero chance that that
 	 * multiple threads could get in here, and one thread could
 	 * be scanning through the list of bits looking for a free
 	 * one, but the free ones are always behind him, and other
@@ -4662,6 +4663,7 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 	 * infrequently as to be indistinguishable from never.
 	 */
 
+	offset = h->last_allocation; /* benignly racy */
 	for (;;) {
 		i = find_next_zero_bit(h->cmd_pool_bits, h->nr_cmds, offset);
 		if (unlikely(i == h->nr_cmds)) {
@@ -4679,6 +4681,7 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 			h->cmd_pool_bits + (i / BITS_PER_LONG));
 		break; /* it's ours now. */
 	}
+	h->last_allocation = i; /* benignly racy */
 
 	/* Zero out all of commandlist except the last field, refcount */
 	memset(c, 0, offsetof(struct CommandList, refcount));
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 679e4d2..981479a 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -133,6 +133,7 @@ struct ctlr_info {
 	struct CfgTable __iomem *cfgtable;
 	int	interrupts_enabled;
 	int 	max_commands;
+	int last_allocation;
 	atomic_t commands_outstanding;
 #	define PERF_MODE_INT	0
 #	define DOORBELL_INT	1

