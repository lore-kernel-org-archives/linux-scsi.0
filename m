From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch resend] firewire: ieee1394: Move away from SG_ALL
Date: Mon, 4 Aug 2008 20:08:19 +0200 (CEST)
Message-ID: <tkrat.768de7e4b028b713@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45647 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYHDSIk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2008 14:08:40 -0400
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>

As a discussion reminded me today, I believe I should merge the
following patch (could have done so much earlier in fact).  Or is there
anything speaking against it?

Meanwhile, SG_ALL has been redefined from 255 to SCSI_MAX_SG_SEGMENTS =
128 without me noticing it.  But since several popular architectures
define ARCH_HAS_SG_CHAIN, we may want to go back to 255 in (fw-)sbp2.
(Besides, we should also do some tests to figure out an actual optimum.
And fw-sbp2.c's struct sbp2_command_orb should become variably sized.)

Does the most relevant user of large transfers with SBP-2 devices,
sd-mod, use chained s/g lists?



Date: Thu, 17 Jan 2008 18:41:47 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/8] firewire: ieee1394: Move away from SG_ALL

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
Stefan Richter
-=====-==--- =--- --=--
http://arcgraph.de/sr/


