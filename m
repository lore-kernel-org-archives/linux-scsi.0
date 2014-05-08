From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/19] hpsa: remove dev_dbg() calls from hot paths
Date: Thu, 08 May 2014 14:27:58 -0500
Message-ID: <20140508192758.13481.64859.stgit@beardog.cce.hp.com>
References: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:25276 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbaEHT3k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2014 15:29:40 -0400
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id AFF6C2C69
	for <linux-scsi@vger.kernel.org>; Thu,  8 May 2014 19:10:26 +0000 (UTC)
In-Reply-To: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: justin.lindley@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

They are not completely free of cost when disabled and
when enabled emitting debug output for every command
submitted produces far too much output to be useful.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index b988e04..da67c07 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -342,8 +342,6 @@ struct offline_device_entry {
 static void SA5_submit_command(struct ctlr_info *h,
 	struct CommandList *c)
 {
-	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
-		c->Header.Tag.lower);
 	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
 	(void) readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 }
@@ -351,8 +349,6 @@ static void SA5_submit_command(struct ctlr_info *h,
 static void SA5_submit_command_ioaccel2(struct ctlr_info *h,
 	struct CommandList *c)
 {
-	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
-		c->Header.Tag.lower);
 	if (c->cmd_type == CMD_IOACCEL2)
 		writel(c->busaddr, h->vaddr + IOACCEL2_INBOUND_POSTQ_32);
 	else
@@ -474,7 +470,6 @@ static bool SA5_intr_pending(struct ctlr_info *h)
 {
 	unsigned long register_value  =
 		readl(h->vaddr + SA5_INTR_STATUS);
-	dev_dbg(&h->pdev->dev, "intr_pending %lx\n", register_value);
 	return register_value & SA5_INTR_PENDING;
 }
 

