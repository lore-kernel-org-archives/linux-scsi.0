From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 5/8] arm/scsi: Not sg-chain ready
Date: Thu, 17 Jan 2008 18:49:56 +0200
Message-ID: <478F8734.8060303@panasas.com>
References: <478F8435.5000907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5316 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751243AbYAQQt7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 11:49:59 -0500
In-Reply-To: <478F8435.5000907@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


  arm-scsi core is not sg-chain ready, so maximum scatterlist supported
  is SCSI_MAX_SG_SEGMENTS. Define it so, in core, and let all drivers
  use it for the sg_tablesize in host templates.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/arm/acornscsi.c |    2 +-
 drivers/scsi/arm/arxescsi.c  |    2 +-
 drivers/scsi/arm/cumana_2.c  |    2 +-
 drivers/scsi/arm/eesox.c     |    2 +-
 drivers/scsi/arm/powertec.c  |    2 +-
 drivers/scsi/arm/scsi.h      |    2 ++
 6 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 3bedf24..58a88a8 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2981,7 +2981,7 @@ static struct scsi_host_template acornscsi_template = {
 	.reset			= acornscsi_reset,
 	.can_queue		= 16,
 	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= ARM_SCSI_MAX_SG,
 	.cmd_per_lun		= 2,
 	.unchecked_isa_dma	= 0,
 	.use_clustering		= DISABLE_CLUSTERING,
diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index 2836fe2..a35e7c1 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -270,7 +270,7 @@ static struct scsi_host_template arxescsi_template = {
 	.eh_abort_handler		= fas216_eh_abort,
 	.can_queue			= 0,
 	.this_id			= 7,
-	.sg_tablesize			= SG_ALL,
+	.sg_tablesize			= ARM_SCSI_MAX_SG,
 	.cmd_per_lun			= 1,
 	.use_clustering			= DISABLE_CLUSTERING,
 	.proc_name			= "arxescsi",
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 68a6412..3fe690c 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -390,7 +390,7 @@ static struct scsi_host_template cumanascsi2_template = {
 	.eh_abort_handler		= fas216_eh_abort,
 	.can_queue			= 1,
 	.this_id			= 7,
-	.sg_tablesize			= SG_ALL,
+	.sg_tablesize			= ARM_SCSI_MAX_SG,
 	.cmd_per_lun			= 1,
 	.use_clustering			= DISABLE_CLUSTERING,
 	.proc_name			= "cumanascsi2",
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index bb2477b..e0a1cf6 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -508,7 +508,7 @@ static struct scsi_host_template eesox_template = {
 	.eh_abort_handler		= fas216_eh_abort,
 	.can_queue			= 1,
 	.this_id			= 7,
-	.sg_tablesize			= SG_ALL,
+	.sg_tablesize			= ARM_SCSI_MAX_SG,
 	.cmd_per_lun			= 1,
 	.use_clustering			= DISABLE_CLUSTERING,
 	.proc_name			= "eesox",
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index d9a546d..ca27047 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -302,7 +302,7 @@ static struct scsi_host_template powertecscsi_template = {
 
 	.can_queue			= 8,
 	.this_id			= 7,
-	.sg_tablesize			= SG_ALL,
+	.sg_tablesize			= ARM_SCSI_MAX_SG,
 	.cmd_per_lun			= 2,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.proc_name			= "powertec",
diff --git a/drivers/scsi/arm/scsi.h b/drivers/scsi/arm/scsi.h
index c7415fc..dffd073 100644
--- a/drivers/scsi/arm/scsi.h
+++ b/drivers/scsi/arm/scsi.h
@@ -14,6 +14,8 @@
 
 #define BELT_AND_BRACES
 
+/* FIXME: all drivers that depend on this are not chain-safe */
+#define ARM_SCSI_MAX_SG SCSI_MAX_SG_SEGMENTS
 /*
  * The scatter-gather list handling.  This contains all
  * the yucky stuff that needs to be fixed properly.
-- 
1.5.3.3


