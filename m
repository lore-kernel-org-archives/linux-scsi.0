From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 1/9] hpsa: allow modifying device queue depth.
Date: Thu, 25 Feb 2010 14:02:51 -0600
Message-ID: <20100225200251.7508.13920.stgit@beardog.cce.hp.com>
References: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:10772 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430Ab0BYT7m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 14:59:42 -0500
In-Reply-To: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@suse.de, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: allow modifying device queue depth.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 03697ba..745c624 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -43,6 +43,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include <linux/cciss_ioctl.h>
 #include <linux/string.h>
 #include <linux/bitmap.h>
@@ -134,6 +135,8 @@ static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
 static void hpsa_scan_start(struct Scsi_Host *);
 static int hpsa_scan_finished(struct Scsi_Host *sh,
 	unsigned long elapsed_time);
+static int hpsa_change_queue_depth(struct scsi_device *sdev,
+	int qdepth, int reason);
 
 static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd);
 static int hpsa_slave_alloc(struct scsi_device *sdev);
@@ -182,6 +185,7 @@ static struct scsi_host_template hpsa_driver_template = {
 	.queuecommand		= hpsa_scsi_queue_command,
 	.scan_start		= hpsa_scan_start,
 	.scan_finished		= hpsa_scan_finished,
+	.change_queue_depth	= hpsa_change_queue_depth,
 	.this_id		= -1,
 	.sg_tablesize		= MAXSGENTRIES,
 	.use_clustering		= ENABLE_CLUSTERING,
@@ -2077,6 +2081,23 @@ static int hpsa_scan_finished(struct Scsi_Host *sh,
 	return finished;
 }
 
+static int hpsa_change_queue_depth(struct scsi_device *sdev,
+	int qdepth, int reason)
+{
+	struct ctlr_info *h = sdev_to_hba(sdev);
+
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -ENOTSUPP;
+
+	if (qdepth < 1)
+		qdepth = 1;
+	else
+		if (qdepth > h->nr_cmds)
+			qdepth = h->nr_cmds;
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	return sdev->queue_depth;
+}
+
 static void hpsa_unregister_scsi(struct ctlr_info *h)
 {
 	/* we are being forcibly unloaded, and may not refuse. */

