From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/8] firewire: ieee1394: Move away from SG_ALL
Date: Thu, 17 Jan 2008 18:41:47 +0200
Message-ID: <478F854B.2030302@panasas.com>
References: <478F8435.5000907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27736 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750926AbYAQQmE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 11:42:04 -0500
In-Reply-To: <478F8435.5000907@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


  SG_ALL wants to be ~0 meaning "any future size".
  Below group of drivers preallocate a scatter list
  buffer of max_size, so set that size to be 255 (Like before).

  A better schema can be advised with a more dynamic allocation.
  Perhaps from a kmem_cache.

  List of drivers/files:
	drivers/firewire/fw-sbp2.c
	drivers/ieee1394/sbp2.[ch]

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/firewire/fw-sbp2.c |    6 ++++--
 drivers/ieee1394/sbp2.c    |    2 +-
 drivers/ieee1394/sbp2.h    |    4 +++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index c2169d2..078501c 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -151,6 +151,7 @@ struct sbp2_target {
 };
 
 #define SBP2_MAX_SG_ELEMENT_LENGTH	0xf000
+#define SBP2_MAX_SG_COUNT		255
 #define SBP2_MAX_SECTORS		255	/* Max sectors supported */
 #define SBP2_ORB_TIMEOUT		2000	/* Timeout in ms */
 
@@ -272,7 +273,8 @@ struct sbp2_command_orb {
 	scsi_done_fn_t done;
 	struct sbp2_logical_unit *lu;
 
-	struct sbp2_pointer page_table[SG_ALL] __attribute__((aligned(8)));
+	struct sbp2_pointer page_table[SBP2_MAX_SG_COUNT]
+						__attribute__((aligned(8)));
 	dma_addr_t page_table_bus;
 };
 
@@ -1329,7 +1331,7 @@ static struct scsi_host_template scsi_driver_template = {
 	.slave_configure	= sbp2_scsi_slave_configure,
 	.eh_abort_handler	= sbp2_scsi_abort,
 	.this_id		= -1,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= SBP2_MAX_SG_COUNT,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.cmd_per_lun		= 1,
 	.can_queue		= 1,
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 1eda11a..070763a 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -324,7 +324,7 @@ static struct scsi_host_template sbp2_shost_template = {
 	.slave_configure	 = sbp2scsi_slave_configure,
 	.slave_destroy		 = sbp2scsi_slave_destroy,
 	.this_id		 = -1,
-	.sg_tablesize		 = SG_ALL,
+	.sg_tablesize		 = SBP2_MAX_SG_COUNT,
 	.use_clustering		 = ENABLE_CLUSTERING,
 	.cmd_per_lun		 = SBP2_MAX_CMDS,
 	.can_queue		 = SBP2_MAX_CMDS,
diff --git a/drivers/ieee1394/sbp2.h b/drivers/ieee1394/sbp2.h
index 333a4bb..ae31788 100644
--- a/drivers/ieee1394/sbp2.h
+++ b/drivers/ieee1394/sbp2.h
@@ -222,6 +222,7 @@ struct sbp2_status_block {
  */
 
 #define SBP2_MAX_SG_ELEMENT_LENGTH		0xf000
+#define SBP2_MAX_SG_COUNT			255
 #define SBP2_MAX_SECTORS			255
 /* There is no real limitation of the queue depth (i.e. length of the linked
  * list of command ORBs) at the target. The chosen depth is merely an
@@ -257,7 +258,8 @@ struct sbp2_command_info {
 
 	/* Also need s/g structure for each sbp2 command */
 	struct sbp2_unrestricted_page_table
-		scatter_gather_element[SG_ALL] __attribute__((aligned(8)));
+		scatter_gather_element[SBP2_MAX_SG_COUNT]
+						__attribute__((aligned(8)));
 	dma_addr_t sge_dma;
 	void *sge_buffer;
 	dma_addr_t cmd_dma;
-- 
1.5.3.3


