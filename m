From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 4/8] wd33c93: Not sg-chain ready
Date: Thu, 17 Jan 2008 18:48:39 +0200
Message-ID: <478F86E7.7010400@panasas.com>
References: <478F8435.5000907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27124 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751232AbYAQQso (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 11:48:44 -0500
In-Reply-To: <478F8435.5000907@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


  wd33c93 core is not sg-chain ready, so maximum scatterlist supported
  is SCSI_MAX_SG_SEGMENTS. Define it so, in core, and let all drivers
  use it for the sg_tablesize in host templates.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/a2091.c   |    2 +-
 drivers/scsi/a3000.c   |    2 +-
 drivers/scsi/gvp11.c   |    2 +-
 drivers/scsi/mvme147.c |    2 +-
 drivers/scsi/sgiwd93.c |    2 +-
 drivers/scsi/wd33c93.h |    2 ++
 6 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 23f27c9..a5a511f 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -217,7 +217,7 @@ static struct scsi_host_template driver_template = {
 	.eh_host_reset_handler	= wd33c93_host_reset,
 	.can_queue		= CAN_QUEUE,
 	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= WD_MAX_SG,
 	.cmd_per_lun		= CMD_PER_LUN,
 	.use_clustering		= DISABLE_CLUSTERING
 };
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index d7255c8..aaadf73 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -222,7 +222,7 @@ static struct scsi_host_template driver_template = {
 	.eh_host_reset_handler	= wd33c93_host_reset,
 	.can_queue		= CAN_QUEUE,
 	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= WD_MAX_SG,
 	.cmd_per_lun		= CMD_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING
 };
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 37741e9..e56c257 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -371,7 +371,7 @@ static struct scsi_host_template driver_template = {
 	.eh_host_reset_handler	= wd33c93_host_reset,
 	.can_queue		= CAN_QUEUE,
 	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= WD_MAX_SG,
 	.cmd_per_lun		= CMD_PER_LUN,
 	.use_clustering		= DISABLE_CLUSTERING
 };
diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index be41aad..e69c108 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -140,7 +140,7 @@ static struct scsi_host_template driver_template = {
 	.eh_host_reset_handler	= wd33c93_host_reset,
 	.can_queue		= CAN_QUEUE,
 	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= WD_MAX_SG,
 	.cmd_per_lun		= CMD_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING
 };
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index d4ebe8c..60cc3d1 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -208,7 +208,7 @@ static struct scsi_host_template sgiwd93_template = {
 	.eh_host_reset_handler	= wd33c93_host_reset,
 	.can_queue		= 16,
 	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= WD_MAX_SG,
 	.cmd_per_lun		= 8,
 	.use_clustering		= DISABLE_CLUSTERING,
 };
diff --git a/drivers/scsi/wd33c93.h b/drivers/scsi/wd33c93.h
index 00123f2..e54d7f4 100644
--- a/drivers/scsi/wd33c93.h
+++ b/drivers/scsi/wd33c93.h
@@ -339,6 +339,8 @@ struct WD33C93_hostdata {
 #define PR_TEST      1<<6
 #define PR_STOP      1<<7
 
+/* FIXME: Not sg-chain ready */
+#define WD_MAX_SG SCSI_MAX_SG_SEGMENTS
 
 void wd33c93_init (struct Scsi_Host *instance, const wd33c93_regs regs,
          dma_setup_t setup, dma_stop_t stop, int clock_freq);
-- 
1.5.3.3


