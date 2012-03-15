From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/6] ipr: Increase max concurrent oustanding commands
Date: Wed, 14 Mar 2012 21:20:10 -0500
Message-ID: <201203150220.q2F2K6qs002943@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41950 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab2COCUm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Mar 2012 22:20:42 -0400
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 14 Mar 2012 22:20:40 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 4E2556E8049
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 22:20:09 -0400 (EDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2F2K82I295434
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 22:20:08 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2F2K7x7003003
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Increase the total number of max concurrent outstanding commands
for the most recent family of adapters in order to improve overall
adapter performance.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   17 +++++++++++++++++
 drivers/scsi/ipr.h |   10 ++++++----
 2 files changed, 23 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_increase_cmd_blocks drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_increase_cmd_blocks	2012-03-10 08:01:26.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2012-03-10 13:16:50.000000000 -0600
@@ -53,7 +53,7 @@
  * IPR_NUM_BASE_CMD_BLKS: This defines the maximum number of
  *	ops the mid-layer can send to the adapter.
  */
-#define IPR_NUM_BASE_CMD_BLKS				100
+#define IPR_NUM_BASE_CMD_BLKS			(ioa_cfg->max_cmds)
 
 #define PCI_DEVICE_ID_IBM_OBSIDIAN_E	0x0339
 
@@ -153,7 +153,7 @@
 #define IPR_NUM_INTERNAL_CMD_BLKS	(IPR_NUM_HCAMS + \
                                      ((IPR_NUM_RESET_RELOAD_RETRIES + 1) * 2) + 4)
 
-#define IPR_MAX_COMMANDS		IPR_NUM_BASE_CMD_BLKS
+#define IPR_MAX_COMMANDS		100
 #define IPR_NUM_CMD_BLKS		(IPR_NUM_BASE_CMD_BLKS + \
 						IPR_NUM_INTERNAL_CMD_BLKS)
 
@@ -1305,6 +1305,7 @@ struct ipr_interrupts {
 
 struct ipr_chip_cfg_t {
 	u32 mailbox;
+	u16 max_cmds;
 	u8 cache_line_size;
 	u8 clear_isr;
 	struct ipr_interrupt_offsets regs;
@@ -1503,8 +1504,9 @@ struct ipr_ioa_cfg {
 	struct ata_host ata_host;
 	char ipr_cmd_label[8];
 #define IPR_CMD_LABEL		"ipr_cmd"
-	struct ipr_cmnd *ipr_cmnd_list[IPR_NUM_CMD_BLKS];
-	dma_addr_t ipr_cmnd_list_dma[IPR_NUM_CMD_BLKS];
+	u32 max_cmds;
+	struct ipr_cmnd **ipr_cmnd_list;
+	dma_addr_t *ipr_cmnd_list_dma;
 }; /* struct ipr_ioa_cfg */
 
 struct ipr_cmnd {
diff -puN drivers/scsi/ipr.c~ipr_increase_cmd_blocks drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_increase_cmd_blocks	2012-03-10 08:01:30.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2012-03-10 13:17:13.000000000 -0600
@@ -104,6 +104,7 @@ static DEFINE_SPINLOCK(ipr_driver_lock);
 static const struct ipr_chip_cfg_t ipr_chip_cfg[] = {
 	{ /* Gemstone, Citrine, Obsidian, and Obsidian-E */
 		.mailbox = 0x0042C,
+		.max_cmds = 100,
 		.cache_line_size = 0x20,
 		.clear_isr = 1,
 		{
@@ -127,6 +128,7 @@ static const struct ipr_chip_cfg_t ipr_c
 	},
 	{ /* Snipe and Scamp */
 		.mailbox = 0x0052C,
+		.max_cmds = 100,
 		.cache_line_size = 0x20,
 		.clear_isr = 1,
 		{
@@ -150,6 +152,7 @@ static const struct ipr_chip_cfg_t ipr_c
 	},
 	{ /* CRoC */
 		.mailbox = 0x00044,
+		.max_cmds = 1000,
 		.cache_line_size = 0x20,
 		.clear_isr = 0,
 		{
@@ -8278,6 +8281,10 @@ static void ipr_free_cmd_blks(struct ipr
 	if (ioa_cfg->ipr_cmd_pool)
 		pci_pool_destroy (ioa_cfg->ipr_cmd_pool);
 
+	kfree(ioa_cfg->ipr_cmnd_list);
+	kfree(ioa_cfg->ipr_cmnd_list_dma);
+	ioa_cfg->ipr_cmnd_list = NULL;
+	ioa_cfg->ipr_cmnd_list_dma = NULL;
 	ioa_cfg->ipr_cmd_pool = NULL;
 }
 
@@ -8358,6 +8365,14 @@ static int __devinit ipr_alloc_cmd_blks(
 	if (!ioa_cfg->ipr_cmd_pool)
 		return -ENOMEM;
 
+	ioa_cfg->ipr_cmnd_list = kcalloc(IPR_NUM_CMD_BLKS, sizeof(struct ipr_cmnd *), GFP_KERNEL);
+	ioa_cfg->ipr_cmnd_list_dma = kcalloc(IPR_NUM_CMD_BLKS, sizeof(dma_addr_t), GFP_KERNEL);
+
+	if (!ioa_cfg->ipr_cmnd_list || !ioa_cfg->ipr_cmnd_list_dma) {
+		ipr_free_cmd_blks(ioa_cfg);
+		return -ENOMEM;
+	}
+
 	for (i = 0; i < IPR_NUM_CMD_BLKS; i++) {
 		ipr_cmd = pci_pool_alloc (ioa_cfg->ipr_cmd_pool, GFP_KERNEL, &dma_addr);
 
@@ -8585,6 +8600,7 @@ static void __devinit ipr_init_ioa_cfg(s
 	host->max_channel = IPR_MAX_BUS_TO_SCAN;
 	host->unique_id = host->host_no;
 	host->max_cmd_len = IPR_MAX_CDB_LEN;
+	host->can_queue = ioa_cfg->max_cmds;
 	pci_set_drvdata(pdev, ioa_cfg);
 
 	p = &ioa_cfg->chip_cfg->regs;
@@ -8770,6 +8786,7 @@ static int __devinit ipr_probe_ioa(struc
 	ioa_cfg->sis64 = ioa_cfg->ipr_chip->sis_type == IPR_SIS64 ? 1 : 0;
 	ioa_cfg->chip_cfg = ioa_cfg->ipr_chip->cfg;
 	ioa_cfg->clear_isr = ioa_cfg->chip_cfg->clear_isr;
+	ioa_cfg->max_cmds = ioa_cfg->chip_cfg->max_cmds;
 
 	if (ipr_transop_timeout)
 		ioa_cfg->transop_timeout = ipr_transop_timeout;
_

