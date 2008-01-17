From: Boaz Harrosh <bharrosh@panasas.com>
Subject: scsi: Drivers not ready for sg-chaining
Date: Thu, 17 Jan 2008 18:51:27 +0200
Message-ID: <478F878F.6040807@panasas.com>
References: <478F8435.5000907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:1286 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751270AbYAQQvd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 11:51:33 -0500
In-Reply-To: <478F8435.5000907@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


  All below drivers are not sg-chain ready do to incomplete software.
  Once fixed they can move back to SG_ALL. For now they are stuck on
  SCSI_MAX_SG_SEGMENTS.

  Affected drivers/files:
	drivers/scsi/aha152x.c
	drivers/scsi/esp_scsi.[ch]
	drivers/scsi/imm.c
	drivers/scsi/in2000.h
	drivers/scsi/pcmcia/nsp_cs.c
	drivers/scsi/ppa.c
	drivers/scsi/tmscsim.c

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/aha152x.c       |    5 ++++-
 drivers/scsi/esp_scsi.c      |    2 +-
 drivers/scsi/esp_scsi.h      |    3 +++
 drivers/scsi/imm.c           |    5 ++++-
 drivers/scsi/in2000.h        |    2 +-
 drivers/scsi/pcmcia/nsp_cs.c |    5 ++++-
 drivers/scsi/ppa.c           |    4 +++-
 drivers/scsi/tmscsim.c       |    5 ++++-
 8 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 6ccdc96..6be6008 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3460,6 +3460,9 @@ static int aha152x_adjust_queue(struct scsi_device *device)
 	return 0;
 }
 
+/* FIXME: Not sg-chain ready */
+#define AHA152X_MAX_SG SCSI_MAX_SG_SEGMENTS
+
 static struct scsi_host_template aha152x_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= AHA152X_REVID,
@@ -3473,7 +3476,7 @@ static struct scsi_host_template aha152x_driver_template = {
 	.bios_param			= aha152x_biosparam,
 	.can_queue			= 1,
 	.this_id			= 7,
-	.sg_tablesize			= SG_ALL,
+	.sg_tablesize			= AHA152X_MAX_SG,
 	.cmd_per_lun			= 1,
 	.use_clustering			= DISABLE_CLUSTERING,
 	.slave_alloc			= aha152x_adjust_queue,
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index bfdee59..83165f2 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2603,7 +2603,7 @@ struct scsi_host_template scsi_esp_template = {
 	.eh_host_reset_handler	= esp_eh_host_reset_handler,
 	.can_queue		= 7,
 	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= ESP_MAX_SG,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.max_sectors		= 0xffff,
 	.skip_settle_delay	= 1,
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index d5576d5..0f86a90 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -289,6 +289,9 @@ struct esp_cmd_entry {
 #define ESP_MAX_LUN		8
 #define ESP_MAX_TAG		256
 
+/* FIXME: not sg-chain ready */
+#define ESP_MAX_SG SCSI_MAX_SG_SEGMENTS
+
 struct esp_lun_data {
 	struct esp_cmd_entry	*non_tagged_cmd;
 	int			num_tagged;
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index f97d172..6b81692 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1112,6 +1112,9 @@ static int imm_adjust_queue(struct scsi_device *device)
 	return 0;
 }
 
+/* FIXME: not sg-chain ready */
+#define IMM_MAX_SG SCSI_MAX_SG_SEGMENTS
+
 static struct scsi_host_template imm_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "imm",
@@ -1123,7 +1126,7 @@ static struct scsi_host_template imm_template = {
 	.eh_host_reset_handler	= imm_reset,
 	.bios_param		= imm_biosparam,
 	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= IMM_MAX_SG,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.can_queue		= 1,
diff --git a/drivers/scsi/in2000.h b/drivers/scsi/in2000.h
index 0fb8b06..388e16f 100644
--- a/drivers/scsi/in2000.h
+++ b/drivers/scsi/in2000.h
@@ -405,7 +405,7 @@ static int in2000_bus_reset(Scsi_Cmnd *);
 
 
 #define IN2000_CAN_Q    16
-#define IN2000_SG       SG_ALL
+#define IN2000_SG       SCSI_MAX_SG_SEGMENTS /* FIXME: not sg-chain ready */
 #define IN2000_CPL      2
 #define IN2000_HOST_ID  7
 
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 5082ca3..a8f6d24 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -77,6 +77,9 @@ static int       free_ports = 0;
 module_param(free_ports, bool, 0);
 MODULE_PARM_DESC(free_ports, "Release IO ports after configuration? (default: 0 (=no))");
 
+/* FIXME: not sg-chain ready */
+#define NSP_MAX_SG SCSI_MAX_SG_SEGMENTS
+
 static struct scsi_host_template nsp_driver_template = {
 	.proc_name	         = "nsp_cs",
 	.proc_info		 = nsp_proc_info,
@@ -88,7 +91,7 @@ static struct scsi_host_template nsp_driver_template = {
 	.eh_host_reset_handler	 = nsp_eh_host_reset,
 	.can_queue		 = 1,
 	.this_id		 = NSP_INITIATOR_ID,
-	.sg_tablesize		 = SG_ALL,
+	.sg_tablesize		 = NSP_MAX_SG,
 	.cmd_per_lun		 = 1,
 	.use_clustering		 = DISABLE_CLUSTERING,
 };
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index f655ae3..a47309d 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -23,6 +23,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
+/* FIXME: Not chainning safe */
+#define PPA_MAX_SG SCSI_MAX_SG_SEGMENTS
 
 static void ppa_reset_pulse(unsigned int base);
 
@@ -986,7 +988,7 @@ static struct scsi_host_template ppa_template = {
 	.eh_host_reset_handler	= ppa_reset,
 	.bios_param		= ppa_biosparam,
 	.this_id		= -1,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= PPA_MAX_SG,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.can_queue		= 1,
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 5b04ddf..6a7824a 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2194,6 +2194,9 @@ static int dc390_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
+/* FIXME: not sg-chain ready */
+#define DC390_MAX_SG SCSI_MAX_SG_SEGMENTS
+
 static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "tmscsim", 
@@ -2206,7 +2209,7 @@ static struct scsi_host_template driver_template = {
 	.eh_bus_reset_handler	= DC390_bus_reset,
 	.can_queue		= 1,
 	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= DC390_MAX_SG,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.max_sectors		= 0x4000, /* 8MiB = 16 * 1024 * 512 */
-- 
1.5.3.3


