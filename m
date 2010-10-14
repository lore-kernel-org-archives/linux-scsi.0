From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Preload virtual backstore INQUIRY Product Model and Revision
Date: Thu, 14 Oct 2010 00:20:38 -0700
Message-ID: <1287040838-7077-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.ac4.yahoo.com ([76.13.13.243]:40777 "HELO
	smtp104.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754537Ab0JNHUn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2010 03:20:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds two 'const char *inquiry_prod' and 'const char *inquiry_rev'
parameters to transport_add_device_to_core_hba() used by IBLOCK, FILEIO and
RAMDISK subsystem plugins to preload these values into DEV_T10_WWN(dev)->model
and DEV_T10_WWN(dev)->revision respectively.

This allows these virtual subsystem plugins to function with TCM/pSCSI passthrough
to extract the INQUIRY information during transport_add_device_to_core_hba() setup
call from their respective struct se_subsystem_api->create_virtdevice().

It also removes the struct se_subsystem_api->get_inquiry_[prod,rev]() calls
introduced in commit ed3c0b7d1f7c2.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reported-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c      |   15 ++-------------
 drivers/target/target_core_iblock.c    |   15 ++-------------
 drivers/target/target_core_pscsi.c     |    3 ++-
 drivers/target/target_core_rd.c        |   26 +++++++-------------------
 drivers/target/target_core_transport.c |   26 +++++++++++++++++++++++---
 include/target/target_core_transport.h |   10 +---------
 6 files changed, 37 insertions(+), 58 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 86c8cce..c3a2e84 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -225,7 +225,8 @@ static struct se_device *fd_create_virtdevice(
 	 * call bd_release() on the referenced struct block_device.
 	 */
 	dev = transport_add_device_to_core_hba(hba, &fileio_template,
-				se_dev, dev_flags, (void *)fd_dev);
+				se_dev, dev_flags, (void *)fd_dev,
+				"FILEIO", FD_VERSION);
 	if (!(dev))
 		goto fail;
 
@@ -962,16 +963,6 @@ static u32 fd_get_device_type(struct se_device *dev)
 	return TYPE_DISK;
 }
 
-static char *fd_get_inquiry_prod(struct se_device *dev)
-{
-	return "FILEIO";
-}
-
-static char *fd_get_inquiry_rev(struct se_device *dev)
-{
-	return FD_VERSION;
-}
-
 /*	fd_get_dma_length(): (Part of se_subsystem_api_t template)
  *
  *
@@ -1056,8 +1047,6 @@ static struct se_subsystem_api fileio_template = {
 	.get_blocksize		= fd_get_blocksize,
 	.get_device_rev		= fd_get_device_rev,
 	.get_device_type	= fd_get_device_type,
-	.get_inquiry_prod	= fd_get_inquiry_prod,
-	.get_inquiry_rev	= fd_get_inquiry_rev,
 	.get_dma_length		= fd_get_dma_length,
 	.get_max_sectors	= fd_get_max_sectors,
 	.get_blocks		= fd_get_blocks,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 463f992..4c2caa5 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -181,7 +181,8 @@ static struct se_device *iblock_create_virtdevice(
 	 * call bd_release() on the referenced struct block_device.
 	 */
 	dev = transport_add_device_to_core_hba(hba,
-			&iblock_template, se_dev, dev_flags, (void *)ib_dev);
+			&iblock_template, se_dev, dev_flags, (void *)ib_dev,
+			"IBLOCK", IBLOCK_VERSION);
 	if (!(dev))
 		goto failed;
 
@@ -875,16 +876,6 @@ static u32 iblock_get_device_type(struct se_device *dev)
 	return TYPE_DISK;
 }
 
-static char *iblock_get_inquiry_rev(struct se_device *dev)
-{
-	return IBLOCK_VERSION;
-}
-
-static char *iblock_get_inquiry_prod(struct se_device *dev)
-{
-	return "IBLOCK";
-}
-
 static u32 iblock_get_dma_length(u32 task_size, struct se_device *dev)
 {
 	return PAGE_SIZE;
@@ -989,8 +980,6 @@ static struct se_subsystem_api iblock_template = {
 	.get_blocksize		= iblock_get_blocksize,
 	.get_device_rev		= iblock_get_device_rev,
 	.get_device_type	= iblock_get_device_type,
-	.get_inquiry_prod	= iblock_get_inquiry_prod,
-	.get_inquiry_rev	= iblock_get_inquiry_rev,
 	.get_dma_length		= iblock_get_dma_length,
 	.get_max_sectors	= iblock_get_max_sectors,
 	.get_blocks		= iblock_get_blocks,
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index ea96636..d0a9384 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -252,7 +252,8 @@ static struct se_device *pscsi_add_device_to_list(
 	pdv->pdv_sd = sd;
 
 	dev = transport_add_device_to_core_hba(hba, &pscsi_template,
-				se_dev, dev_flags, (void *)pdv);
+				se_dev, dev_flags, (void *)pdv,
+				NULL, NULL);
 	if (!(dev)) {
 		pdv->pdv_sd = NULL;
 		return NULL;
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 61f4a1c..c85101e 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -268,6 +268,7 @@ static struct se_device *rd_create_virtdevice(
 	struct rd_dev *rd_dev = p;
 	struct rd_host *rd_host = hba->hba_ptr;
 	int dev_flags = 0;
+	char prod[16], rev[4];
 
 	if (rd_dev->rd_direct)
 		dev_flags |= DF_TRANSPORT_DMA_ALLOC;
@@ -275,9 +276,14 @@ static struct se_device *rd_create_virtdevice(
 	if (rd_build_device_space(rd_dev) < 0)
 		goto fail;
 
+	snprintf(prod, 16, "RAMDISK-%s", (rd_dev->rd_direct) ? "DR" : "MCP");
+	snprintf(rev, 4, "%s", (rd_dev->rd_direct) ? RD_DR_VERSION :
+						RD_MCP_VERSION);
+
 	dev = transport_add_device_to_core_hba(hba,
 			(rd_dev->rd_direct) ? &rd_dr_template :
-			&rd_mcp_template, se_dev, dev_flags, (void *)rd_dev);
+			&rd_mcp_template, se_dev, dev_flags, (void *)rd_dev,
+			prod, rev);
 	if (!(dev))
 		goto fail;
 
@@ -1289,20 +1295,6 @@ static u32 rd_get_device_type(struct se_device *dev)
 	return TYPE_DISK;
 }
 
-static char *rd_get_inquiry_prod(struct se_device *dev)
-{
-	struct rd_dev *rd_dev = dev->dev_ptr;
-
-	return (rd_dev->rd_direct) ? "RAMDISK-DR" : "RAMDISK-MCP";
-}
-
-static char *rd_get_inquiry_rev(struct se_device *dev)
-{
-	struct rd_dev *rd_dev = dev->dev_ptr;
-
-	return (rd_dev->rd_direct) ? RD_DR_VERSION : RD_MCP_VERSION;
-}
-
 /*	rd_get_dma_length(): (Part of se_subsystem_api_t template)
  *
  *
@@ -1380,8 +1372,6 @@ static struct se_subsystem_api rd_dr_template = {
 	.get_blocksize		= rd_get_blocksize,
 	.get_device_rev		= rd_get_device_rev,
 	.get_device_type	= rd_get_device_type,
-	.get_inquiry_prod	= rd_get_inquiry_prod,
-	.get_inquiry_rev	= rd_get_inquiry_rev,
 	.get_dma_length		= rd_get_dma_length,
 	.get_max_sectors	= rd_get_max_sectors,
 	.get_blocks		= rd_get_blocks,
@@ -1424,8 +1414,6 @@ static struct se_subsystem_api rd_mcp_template = {
 	.get_blocksize		= rd_get_blocksize,
 	.get_device_rev		= rd_get_device_rev,
 	.get_device_type	= rd_get_device_type,
-	.get_inquiry_prod	= rd_get_inquiry_prod,
-	.get_inquiry_rev	= rd_get_inquiry_rev,
 	.get_dma_length		= rd_get_dma_length,
 	.get_max_sectors	= rd_get_max_sectors,
 	.get_queue_depth	= rd_get_queue_depth,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 44376a3..612b078 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2206,7 +2206,9 @@ struct se_device *transport_add_device_to_core_hba(
 	struct se_subsystem_api *transport,
 	struct se_subsystem_dev *se_dev,
 	u32 device_flags,
-	void *transport_dev)
+	void *transport_dev,
+	const char *inquiry_prod,
+	const char *inquiry_rev)
 {
 	int ret = 0, force_pt;
 	struct se_device  *dev;
@@ -2301,6 +2303,24 @@ struct se_device *transport_add_device_to_core_hba(
 	 */
 	if (transport_generic_activate_device(dev) < 0)
 		goto out;
+	/*
+	 * Preload the initial INQUIRY const values if we are doing
+	 * anything virtual (IBLOCK, FILEIO, RAMDISK), but not for TCM/pSCSI
+	 * passthrough because this is being provided by the backend LLD.
+	 * This is required so that transport_get_inquiry() copies these
+	 * originals once back into DEV_T10_WWN(dev) for the virtual device
+	 * setup.
+	 */
+	if (TRANSPORT(dev)->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV) {
+		if (!(inquiry_prod) || !(inquiry_prod)) {
+			printk(KERN_ERR "All non TCM/pSCSI plugins require"
+				" INQUIRY consts\n");
+			goto out;
+		}
+
+		strncpy(&DEV_T10_WWN(dev)->model[0], inquiry_prod, 16);
+		strncpy(&DEV_T10_WWN(dev)->revision[0], inquiry_rev, 4);
+	}
 
 	ret = transport_get_inquiry(DEV_T10_WWN(dev), (void *)dev);
 	if (ret < 0)
@@ -5561,8 +5581,8 @@ int transport_emulate_control_cdb(struct se_task *task)
 	case INQUIRY:
 		ret = transport_generic_emulate_inquiry(cmd,
 				TRANSPORT(dev)->get_device_type(dev),
-				TRANSPORT(dev)->get_inquiry_prod(dev),
-				TRANSPORT(dev)->get_inquiry_rev(dev));
+				&DEV_T10_WWN(dev)->model[0],
+				&DEV_T10_WWN(dev)->revision[0]);
 		if (ret < 0)
 			return ret;
 		break;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index c156098..330edb9 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -192,7 +192,7 @@ extern int transport_rescan_evpd_device_ident(struct se_device *);
 extern struct se_device *transport_add_device_to_core_hba(struct se_hba *,
 					struct se_subsystem_api *,
 					struct se_subsystem_dev *, u32,
-					void *);
+					void *, const char *, const char *);
 extern int transport_generic_activate_device(struct se_device *);
 extern void transport_generic_deactivate_device(struct se_device *);
 extern void transport_generic_free_device(struct se_device *);
@@ -538,14 +538,6 @@ struct se_subsystem_api {
 	 */
 	u32 (*get_device_type)(struct se_device *);
 	/*
-	 * Used to obtain INQUIRY Product field field
-	 */
-	char *(*get_inquiry_prod)(struct se_device *);
-	/*
-	 * Used to obtain INQUIRY Production revision field
-	 */
-	char *(*get_inquiry_rev)(struct se_device *);
-	/*
 	 * get_dma_length():
 	 */
 	u32 (*get_dma_length)(u32, struct se_device *);
-- 
1.5.6.5

