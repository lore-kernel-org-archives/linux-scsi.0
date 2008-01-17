From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/8] NCR5380: Not sg-chain ready
Date: Thu, 17 Jan 2008 18:46:06 +0200
Message-ID: <478F864E.7050705@panasas.com>
References: <478F8435.5000907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:6434 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750953AbYAQQqP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 11:46:15 -0500
In-Reply-To: <478F8435.5000907@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


  NCR5380 core is not sg-chain ready, so maximum scatterlist supported
  is SCSI_MAX_SG_SEGMENTS. Define it so, in core, and let all drivers
  use it for the sg_tablesize in host templates.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/NCR5380.h       |    3 +++
 drivers/scsi/arm/cumana_1.c  |    2 +-
 drivers/scsi/arm/oak.c       |    2 +-
 drivers/scsi/dmx3191d.c      |    2 +-
 drivers/scsi/dtc.c           |    2 +-
 drivers/scsi/g_NCR5380.c     |    2 +-
 drivers/scsi/mac_scsi.c      |    9 ++++-----
 drivers/scsi/mac_scsi.h      |    4 ----
 drivers/scsi/sun3_scsi.c     |    4 ++--
 drivers/scsi/sun3_scsi.h     |    4 ----
 drivers/scsi/sun3_scsi_vme.c |    4 ++--
 11 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index bdc468c..cd7e258 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -37,6 +37,9 @@
 #define NCR5380_PUBLIC_RELEASE 7
 #define NCR53C400_PUBLIC_RELEASE 2
 
+/* FIXME: Not sg-chain ready */
+#define NCR5380_MAX_SG SCSI_MAX_SG_SEGMENTS
+
 #define NDEBUG_ARBITRATION	0x1
 #define NDEBUG_AUTOSENSE	0x2
 #define NDEBUG_DMA		0x4
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index 49d838e..6315730 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -220,7 +220,7 @@ static struct scsi_host_template cumanascsi_template = {
 	.eh_bus_reset_handler	= NCR5380_bus_reset,
 	.can_queue		= 16,
 	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= NCR5380_MAX_SG,
 	.cmd_per_lun		= 2,
 	.unchecked_isa_dma	= 0,
 	.use_clustering		= DISABLE_CLUSTERING,
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index 849cdf8..69d9afd 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -123,7 +123,7 @@ static struct scsi_host_template oakscsi_template = {
 	.eh_bus_reset_handler	= NCR5380_bus_reset,
 	.can_queue		= 16,
 	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= NCR5380_MAX_SG,
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.proc_name		= "oakscsi",
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index fa738ec..92e89b8 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -63,7 +63,7 @@ static struct scsi_host_template dmx3191d_driver_template = {
 	.eh_bus_reset_handler	= NCR5380_bus_reset,
 	.can_queue		= 32,
 	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= NCR5380_MAX_SG,
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 };
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index c2677ba..f8e5dd9 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -479,7 +479,7 @@ static struct scsi_host_template driver_template = {
 	.bios_param     		= dtc_biosparam,
 	.can_queue      		= CAN_QUEUE,
 	.this_id        		= 7,
-	.sg_tablesize   		= SG_ALL,
+	.sg_tablesize   		= NCR5380_MAX_SG,
 	.cmd_per_lun    		= CMD_PER_LUN,
 	.use_clustering 		= DISABLE_CLUSTERING,
 };
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 75585a5..aded3be 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -922,7 +922,7 @@ static struct scsi_host_template driver_template = {
 	.bios_param     	= NCR5380_BIOSPARAM,
 	.can_queue      	= CAN_QUEUE,
         .this_id        	= 7,
-        .sg_tablesize   	= SG_ALL,
+        .sg_tablesize   	= NCR5380_MAX_SG,
 	.cmd_per_lun    	= CMD_PER_LUN,
         .use_clustering		= DISABLE_CLUSTERING,
 };
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 3b09ab2..d8a27c0 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -180,9 +180,8 @@ static int __init mac_scsi_setup(char *str) {
 	if (ints[0] >= 3) {
 		if (ints[3] >= 0) {
 			setup_sg_tablesize = ints[3];
-			/* Must be <= SG_ALL (255) */
-			if (setup_sg_tablesize > SG_ALL)
-				setup_sg_tablesize = SG_ALL;
+			if (setup_sg_tablesize > NCR5380_MAX_SG)
+				setup_sg_tablesize = NCR5380_MAX_SG;
 		}
 	}
 	if (ints[0] >= 4) {
@@ -252,7 +251,7 @@ int macscsi_detect(struct scsi_host_template * tpnt)
     tpnt->cmd_per_lun =
 	(setup_cmd_per_lun > 0) ? setup_cmd_per_lun : CMD_PER_LUN;
     tpnt->sg_tablesize = 
-	(setup_sg_tablesize >= 0) ? setup_sg_tablesize : SG_TABLESIZE;
+	(setup_sg_tablesize > 0) ? setup_sg_tablesize : 1;
 
     if (setup_hostid >= 0)
 	tpnt->this_id = setup_hostid;
@@ -590,7 +589,7 @@ static struct scsi_host_template driver_template = {
 	.eh_bus_reset_handler		= macscsi_bus_reset,
 	.can_queue			= CAN_QUEUE,
 	.this_id			= 7,
-	.sg_tablesize			= SG_ALL,
+	.sg_tablesize			= NCR5380_MAX_SG,
 	.cmd_per_lun			= CMD_PER_LUN,
 	.unchecked_isa_dma		= 0,
 	.use_clustering			= DISABLE_CLUSTERING
diff --git a/drivers/scsi/mac_scsi.h b/drivers/scsi/mac_scsi.h
index d26e331..3bc9919 100644
--- a/drivers/scsi/mac_scsi.h
+++ b/drivers/scsi/mac_scsi.h
@@ -41,10 +41,6 @@
 #define CAN_QUEUE 16
 #endif
 
-#ifndef SG_TABLESIZE
-#define SG_TABLESIZE SG_NONE
-#endif
-
 #ifndef USE_TAGGED_QUEUING
 #define	USE_TAGGED_QUEUING 0
 #endif
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index e606cf0..ff06208 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -222,7 +222,7 @@ int sun3scsi_detect(struct scsi_host_template * tpnt)
 	tpnt->cmd_per_lun =
 		(setup_cmd_per_lun > 0) ? setup_cmd_per_lun : CMD_PER_LUN;
 	tpnt->sg_tablesize = 
-		(setup_sg_tablesize >= 0) ? setup_sg_tablesize : SG_TABLESIZE;
+		(setup_sg_tablesize > 0) ? setup_sg_tablesize : 1;
 
 	if (setup_hostid >= 0)
 		tpnt->this_id = setup_hostid;
@@ -631,7 +631,7 @@ static struct scsi_host_template driver_template = {
 	.eh_bus_reset_handler  	= sun3scsi_bus_reset,
 	.can_queue		= CAN_QUEUE,
 	.this_id		= 7,
-	.sg_tablesize		= SG_TABLESIZE,
+	.sg_tablesize		= NCR5380_MAX_SG,
 	.cmd_per_lun		= CMD_PER_LUN,
 	.use_clustering		= DISABLE_CLUSTERING
 };
diff --git a/drivers/scsi/sun3_scsi.h b/drivers/scsi/sun3_scsi.h
index b29a9d6..b44e7b4 100644
--- a/drivers/scsi/sun3_scsi.h
+++ b/drivers/scsi/sun3_scsi.h
@@ -63,10 +63,6 @@ static int sun3scsi_release (struct Scsi_Host *);
 #define CAN_QUEUE 16
 #endif
 
-#ifndef SG_TABLESIZE
-#define SG_TABLESIZE SG_NONE
-#endif
-
 #ifndef MAX_TAGS
 #define MAX_TAGS 32
 #endif
diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.c
index 02d9727..e9c3632 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -170,7 +170,7 @@ static int sun3scsi_detect(struct scsi_host_template * tpnt)
 	tpnt->cmd_per_lun =
 		(setup_cmd_per_lun > 0) ? setup_cmd_per_lun : CMD_PER_LUN;
 	tpnt->sg_tablesize = 
-		(setup_sg_tablesize >= 0) ? setup_sg_tablesize : SG_TABLESIZE;
+		(setup_sg_tablesize > 0) ? setup_sg_tablesize : 1;
 	
 	if (setup_hostid >= 0)
 		tpnt->this_id = setup_hostid;
@@ -574,7 +574,7 @@ static struct scsi_host_template driver_template = {
 	.eh_bus_reset_handler  	= sun3scsi_bus_reset,
 	.can_queue		= CAN_QUEUE,
 	.this_id		= 7,
-	.sg_tablesize		= SG_TABLESIZE,
+	.sg_tablesize		= NCR5380_MAX_SG,
 	.cmd_per_lun		= CMD_PER_LUN,
 	.use_clustering		= DISABLE_CLUSTERING
 };
-- 
1.5.3.3


