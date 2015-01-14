From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 05/48] hpsa: correct change_queue_depth
Date: Wed, 14 Jan 2015 16:00:00 -0600
Message-ID: <20150114220000.21325.18614.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55205 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbbANWAr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:00:47 -0500
Received: from g2t2353.austin.hp.com (g2t2353.austin.hp.com [15.217.128.52])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 597CD4524
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 22:00:47 +0000 (UTC)
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

scsi_adjust_queue_depth was changed to scsi_change_queue_depth

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 371d0a8..7dfe829 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -217,6 +217,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static void hpsa_scan_start(struct Scsi_Host *);
 static int hpsa_scan_finished(struct Scsi_Host *sh,
 	unsigned long elapsed_time);
+static int hpsa_change_queue_depth(struct scsi_device *sdev, int qdepth);
 
 static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd);
 static int hpsa_eh_abort_handler(struct scsi_cmnd *scsicmd);
@@ -672,7 +673,7 @@ static struct scsi_host_template hpsa_driver_template = {
 	.queuecommand		= hpsa_scsi_queue_command,
 	.scan_start		= hpsa_scan_start,
 	.scan_finished		= hpsa_scan_finished,
-	.change_queue_depth	= scsi_change_queue_depth,
+	.change_queue_depth	= hpsa_change_queue_depth,
 	.this_id		= -1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_abort_handler	= hpsa_eh_abort_handler,
@@ -4007,6 +4008,19 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
 	spin_unlock_irqrestore(&h->scan_lock, flags);
 }
 
+static int hpsa_change_queue_depth(struct scsi_device *sdev, int qdepth)
+{
+	struct ctlr_info *h = sdev_to_hba(sdev);
+
+	if (qdepth < 1)
+		qdepth = 1;
+	else
+		if (qdepth > h->nr_cmds)
+			qdepth = h->nr_cmds;
+	scsi_change_queue_depth(sdev, qdepth);
+	return sdev->queue_depth;
+}
+
 static int hpsa_scan_finished(struct Scsi_Host *sh,
 	unsigned long elapsed_time)
 {

