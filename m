From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 03/24] hpsa: remove unused fields from struct ctlr_info
Date: Thu, 29 May 2014 10:52:31 -0500
Message-ID: <20140529155231.8180.55127.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:19775 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757688AbaE2Pyf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:54:35 -0400
Received: from g2t2354.austin.hp.com (g2t2354.austin.hp.com [15.217.128.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 026251D5A
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:34:49 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

The fields "major", "max_outstanding", and "usage_count"
of struct ctlr_info were not used for anything.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Mike Miller <michael.miller@canonical.com>
Reviewed-by: Webb Scales <webb.scales@hp.com>
---
 drivers/scsi/hpsa.c |    2 --
 drivers/scsi/hpsa.h |    3 ---
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ef66905..7ba4e30 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5481,8 +5481,6 @@ static void start_io(struct ctlr_info *h)
 		 * condition.
 		 */
 		h->commands_outstanding++;
-		if (h->commands_outstanding > h->max_outstanding)
-			h->max_outstanding = h->commands_outstanding;
 
 		/* Tell the controller execute command */
 		spin_unlock_irqrestore(&h->lock, flags);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 44235a2..b988e04 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -115,11 +115,8 @@ struct ctlr_info {
 	int 	nr_cmds; /* Number of commands allowed on this controller */
 	struct CfgTable __iomem *cfgtable;
 	int	interrupts_enabled;
-	int	major;
 	int 	max_commands;
 	int	commands_outstanding;
-	int 	max_outstanding; /* Debug */
-	int	usage_count;  /* number of opens all all minor devices */
 #	define PERF_MODE_INT	0
 #	define DOORBELL_INT	1
 #	define SIMPLE_MODE_INT	2

