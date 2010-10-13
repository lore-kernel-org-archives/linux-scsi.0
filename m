From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/5] tcm: Unify INQUIRY subsystem plugin handling
Date: Wed, 13 Oct 2010 01:48:01 -0700
Message-ID: <1286959681-3445-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the following two struct se_subsystem_api function pointer
ops for INQUIRY emulation reponse payload Product and Product Rev:

       /*
        * Used to obtain INQUIRY Product field field
        */
       char *(*get_inquiry_prod)(struct se_device *);
       /*
        * Used to obtain INQUIRY Production revision field
        */
       char *(*get_inquiry_rev)(struct se_device *);

and updates virtual IBLOCK, FILEIO and RAMDISK_[DR,MCP] to return their
respective informational INQUIRY emulation values.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reported-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c      |   34 ++++++----------
 drivers/target/target_core_iblock.c    |   31 ++++++---------
 drivers/target/target_core_rd.c        |   41 ++++++++-----------
 drivers/target/target_core_transport.c |   67 ++++++++++++--------------------
 include/target/target_core_transport.h |   12 ++++-
 5 files changed, 76 insertions(+), 109 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index a5ad51c..97e068f 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -358,27 +358,6 @@ static void *fd_allocate_request(
 	return (void *)fd_req;
 }
 
-/*	fd_emulate_inquiry():
- *
- *
- */
-static int fd_emulate_inquiry(struct se_task *task)
-{
-	unsigned char prod[64], se_location[128];
-	struct se_cmd *cmd = TASK_CMD(task);
-	struct fd_dev *fdev = task->se_dev->dev_ptr;
-	struct se_hba *hba = task->se_dev->se_hba;
-
-	memset(prod, 0, 64);
-	memset(se_location, 0, 128);
-
-	sprintf(prod, "FILEIO");
-	sprintf(se_location, "%u_%u", hba->hba_id, fdev->fd_dev_id);
-
-	return transport_generic_emulate_inquiry(cmd, TYPE_DISK, prod,
-		FD_VERSION, se_location);
-}
-
 /*	fd_emulate_read_cap():
  *
  *
@@ -1130,6 +1109,16 @@ static u32 fd_get_device_type(struct se_device *dev)
 	return TYPE_DISK;
 }
 
+static char *fd_get_inquiry_prod(struct se_device *dev)
+{
+	return "FILEIO";
+}
+
+static char *fd_get_inquiry_rev(struct se_device *dev)
+{
+	return FD_VERSION;
+}
+
 /*	fd_get_dma_length(): (Part of se_subsystem_api_t template)
  *
  *
@@ -1203,6 +1192,8 @@ static struct se_subsystem_api fileio_template = {
 	.get_blocksize		= fd_get_blocksize,
 	.get_device_rev		= fd_get_device_rev,
 	.get_device_type	= fd_get_device_type,
+	.get_inquiry_prod	= fd_get_inquiry_prod,
+	.get_inquiry_rev	= fd_get_inquiry_rev,
 	.get_dma_length		= fd_get_dma_length,
 	.get_max_sectors	= fd_get_max_sectors,
 	.get_queue_depth	= fd_get_queue_depth,
@@ -1211,7 +1202,6 @@ static struct se_subsystem_api fileio_template = {
 };
 
 static struct se_subsystem_api_cdb fileio_cdb_template = {
-	.emulate_inquiry	= fd_emulate_inquiry,
 	.emulate_read_cap	= fd_emulate_read_cap,
 	.emulate_read_cap16	= fd_emulate_read_cap16,
 	.emulate_unmap		= fd_emulate_unmap,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d999f10..4880891 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -340,24 +340,6 @@ static void *iblock_allocate_request(
 	return (void *)ib_req;
 }
 
-static int iblock_emulate_inquiry(struct se_task *task)
-{
-	unsigned char prod[64], se_location[128];
-	struct se_cmd *cmd = TASK_CMD(task);
-	struct iblock_dev *ibd = task->se_dev->dev_ptr;
-	struct se_hba *hba = task->se_dev->se_hba;
-
-	memset(prod, 0, 64);
-	memset(se_location, 0, 128);
-
-	sprintf(prod, "IBLOCK");
-	sprintf(se_location, "%u_%u_%u", hba->hba_id, ibd->ibd_major,
-		ibd->ibd_minor);
-
-	return transport_generic_emulate_inquiry(cmd, TYPE_DISK, prod,
-		IBLOCK_VERSION, se_location);
-}
-
 static unsigned long long iblock_emulate_read_cap_with_block_size(
 	struct se_device *dev,
 	struct block_device *bd,
@@ -1029,6 +1011,16 @@ static u32 iblock_get_device_type(struct se_device *dev)
 	return TYPE_DISK;
 }
 
+static char *iblock_get_inquiry_rev(struct se_device *dev)
+{
+	return IBLOCK_VERSION;
+}
+
+static char *iblock_get_inquiry_prod(struct se_device *dev)
+{
+	return "IBLOCK";
+}
+
 static u32 iblock_get_dma_length(u32 task_size, struct se_device *dev)
 {
 	return PAGE_SIZE;
@@ -1123,6 +1115,8 @@ static struct se_subsystem_api iblock_template = {
 	.get_blocksize		= iblock_get_blocksize,
 	.get_device_rev		= iblock_get_device_rev,
 	.get_device_type	= iblock_get_device_type,
+	.get_inquiry_prod	= iblock_get_inquiry_prod,
+	.get_inquiry_rev	= iblock_get_inquiry_rev,
 	.get_dma_length		= iblock_get_dma_length,
 	.get_max_sectors	= iblock_get_max_sectors,
 	.get_queue_depth	= iblock_get_queue_depth,
@@ -1131,7 +1125,6 @@ static struct se_subsystem_api iblock_template = {
 };
 
 static struct se_subsystem_api_cdb iblock_cdb_template = {
-	.emulate_inquiry	= iblock_emulate_inquiry,
 	.emulate_read_cap	= iblock_emulate_read_cap,
 	.emulate_read_cap16	= iblock_emulate_read_cap16,
 	.emulate_unmap		= iblock_emulate_unmap,
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 374cd16..e29fd09 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -385,28 +385,6 @@ static void *rd_allocate_request(
 	return (void *)rd_req;
 }
 
-/*	rd_emulate_inquiry():
- *
- *
- */
-static int rd_emulate_inquiry(struct se_task *task)
-{
-	unsigned char prod[64], se_location[128];
-	struct rd_dev *rd_dev = task->se_dev->dev_ptr;
-	struct se_cmd *cmd = TASK_CMD(task);
-	struct se_hba *hba = task->se_dev->se_hba;
-
-	memset(prod, 0, 64);
-	memset(se_location, 0, 128);
-
-	sprintf(prod, "RAMDISK-%s", (rd_dev->rd_direct) ? "DR" : "MCP");
-	sprintf(se_location, "%u_%u", hba->hba_id, rd_dev->rd_dev_id);
-
-	return transport_generic_emulate_inquiry(cmd, TYPE_DISK, prod,
-			(hba->transport->do_se_mem_map) ? RD_DR_VERSION :
-			RD_MCP_VERSION, se_location);
-}
-
 /*	rd_emulate_read_cap():
  *
  *
@@ -1338,6 +1316,20 @@ static u32 rd_get_device_type(struct se_device *dev)
 	return TYPE_DISK;
 }
 
+static char *rd_get_inquiry_prod(struct se_device *dev)
+{
+	struct rd_dev *rd_dev = dev->dev_ptr;
+
+	return (rd_dev->rd_direct) ? "RAMDISK-DR" : "RAMDISK-MCP";
+}
+
+static char *rd_get_inquiry_rev(struct se_device *dev)
+{
+	struct rd_dev *rd_dev = dev->dev_ptr;
+
+	return (rd_dev->rd_direct) ? RD_DR_VERSION : RD_MCP_VERSION;
+}
+
 /*	rd_get_dma_length(): (Part of se_subsystem_api_t template)
  *
  *
@@ -1406,6 +1398,8 @@ static struct se_subsystem_api rd_dr_template = {
 	.get_blocksize		= rd_get_blocksize,
 	.get_device_rev		= rd_get_device_rev,
 	.get_device_type	= rd_get_device_type,
+	.get_inquiry_prod	= rd_get_inquiry_prod,
+	.get_inquiry_rev	= rd_get_inquiry_rev,
 	.get_dma_length		= rd_get_dma_length,
 	.get_max_sectors	= rd_get_max_sectors,
 	.get_queue_depth	= rd_get_queue_depth,
@@ -1447,6 +1441,8 @@ static struct se_subsystem_api rd_mcp_template = {
 	.get_blocksize		= rd_get_blocksize,
 	.get_device_rev		= rd_get_device_rev,
 	.get_device_type	= rd_get_device_type,
+	.get_inquiry_prod	= rd_get_inquiry_prod,
+	.get_inquiry_rev	= rd_get_inquiry_rev,
 	.get_dma_length		= rd_get_dma_length,
 	.get_max_sectors	= rd_get_max_sectors,
 	.get_queue_depth	= rd_get_queue_depth,
@@ -1455,7 +1451,6 @@ static struct se_subsystem_api rd_mcp_template = {
 };
 
 static struct se_subsystem_api_cdb rd_cdb_template = {
-	.emulate_inquiry	= rd_emulate_inquiry,
 	.emulate_read_cap	= rd_emulate_read_cap,
 	.emulate_read_cap16	= rd_emulate_read_cap16,
 	.emulate_unmap		= NULL,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e678686..a49c190 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4495,8 +4495,7 @@ extern int transport_generic_emulate_inquiry(
 	struct se_cmd *cmd,
 	unsigned char type,
 	unsigned char *prod,
-	unsigned char *version,
-	unsigned char *se_location)
+	unsigned char *version)
 {
 	struct se_device *dev = SE_DEV(cmd);
 	struct se_lun *lun = SE_LUN(cmd);
@@ -4507,8 +4506,8 @@ extern int transport_generic_emulate_inquiry(
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 	unsigned char *buf = (unsigned char *) T_TASK(cmd)->t_task_buf;
 	unsigned char *cdb = T_TASK(cmd)->t_task_cdb;
-	unsigned char *iqn_sn, binary, binary_new;
-	u32 prod_len, iqn_sn_len, se_location_len;
+	unsigned char binary, binary_new;
+	u32 prod_len;
 	u32 unit_serial_len, off = 0;
 	int i;
 	u16 len = 0, id_len;
@@ -4599,19 +4598,28 @@ after_tpgs:
 	switch (cdb[2]) {
 	case 0x00: /* supported vital product data pages */
 		buf[1] = 0x00;
-		buf[3] = 3;
 		if (cmd->data_length < 8)
 			return 0;
 		buf[4] = 0x0;
-		buf[5] = 0x80;
-		buf[6] = 0x83;
-		buf[7] = 0x86;
-		len = 3;
+		/*
+		 * Only report the INQUIRY EVPD=1 pages after a valid NAA
+		 * Registered Extended LUN WWN has been set via ConfigFS
+		 * during device creation/restart.
+		 */
+		if (dev->se_sub_dev->su_dev_flags &
+					SDF_EMULATED_VPD_UNIT_SERIAL) {
+			buf[3] = 3;
+			buf[5] = 0x80;
+			buf[6] = 0x83;
+			buf[7] = 0x86;
+			len = 3;
+		}
 		break;
 	case 0x80: /* unit serial number */
 		buf[1] = 0x80;
 		if (dev->se_sub_dev->su_dev_flags &
 					SDF_EMULATED_VPD_UNIT_SERIAL) {
+
 			unit_serial_len =
 				strlen(&DEV_T10_WWN(dev)->unit_serial[0]);
 			unit_serial_len++; /* For NULL Terminator */
@@ -4622,23 +4630,9 @@ after_tpgs:
 			}
 			len += sprintf((unsigned char *)&buf[4], "%s",
 				&DEV_T10_WWN(dev)->unit_serial[0]);
-		 } else {
-			iqn_sn = transport_get_iqn_sn();
-			iqn_sn_len = strlen(iqn_sn);
-			iqn_sn_len++; /* For ":" */
-			se_location_len = strlen(se_location);
-			se_location_len++; /* For NULL Terminator */
-
-			if (((len + 4) + (iqn_sn_len + se_location_len)) >
-					cmd->data_length) {
-				len += (iqn_sn_len + se_location_len);
-				goto set_len;
-			}
-			len += sprintf((unsigned char *)&buf[4], "%s:%s",
-				iqn_sn, se_location);
+			len++; /* Extra Byte for NULL Terminator */
+			buf[3] = len;
 		}
-		len++; /* Extra Byte for NULL Terminator */
-		buf[3] = len;
 		break;
 	case 0x83:
 		/*
@@ -4721,21 +4715,6 @@ check_t10_vend_desc:
 			id_len += sprintf((unsigned char *)&buf[off+12],
 					"%s:%s", prod,
 					&DEV_T10_WWN(dev)->unit_serial[0]);
-		} else {
-			iqn_sn = transport_get_iqn_sn();
-			iqn_sn_len = strlen(iqn_sn);
-			iqn_sn_len++; /* For ":" */
-			se_location_len = strlen(se_location);
-			se_location_len++; /* For NULL Terminator */
-
-			if ((len + (id_len + 4) + (prod_len + iqn_sn_len +
-					se_location_len)) > cmd->data_length) {
-				len += (prod_len + iqn_sn_len +
-						se_location_len);
-				goto check_port;
-			}
-			id_len += sprintf((unsigned char *)&buf[off+12],
-				"%s:%s:%s", prod, iqn_sn, se_location);
 		}
 		buf[off] = 0x2; /* ASCII */
 		buf[off+1] = 0x1; /* T10 Vendor ID */
@@ -5574,8 +5553,12 @@ int transport_emulate_control_cdb(struct se_task *task)
 
 	switch (T_TASK(cmd)->t_task_cdb[0]) {
 	case INQUIRY:
-		if (api_cdb->emulate_inquiry(task) < 0)
-			return PYX_TRANSPORT_INVALID_CDB_FIELD;
+		ret = transport_generic_emulate_inquiry(cmd,
+				TRANSPORT(dev)->get_device_type(dev),
+				TRANSPORT(dev)->get_inquiry_prod(dev),
+				TRANSPORT(dev)->get_inquiry_rev(dev));
+		if (ret < 0)
+			return ret;
 		break;
 	case READ_CAPACITY:
 		ret = api_cdb->emulate_read_cap(task);	
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 8e59144..a949dab 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -228,8 +228,7 @@ extern void transport_stop_all_task_timers(struct se_cmd *);
 extern int transport_execute_tasks(struct se_cmd *);
 extern unsigned char transport_asciihex_to_binaryhex(unsigned char val[2]);
 extern int transport_generic_emulate_inquiry(struct se_cmd *, unsigned char,
-					unsigned char *, unsigned char *,
-					unsigned char *);
+					unsigned char *, unsigned char *);
 extern int transport_generic_emulate_readcapacity(struct se_cmd *, u32);
 extern int transport_generic_emulate_readcapacity_16(struct se_cmd *,
 							unsigned long long);
@@ -319,7 +318,6 @@ struct se_mem {
  * subsystem plugins.for those CDBs that cannot be emulated generically.
  */
 struct se_subsystem_api_cdb {
-	int (*emulate_inquiry)(struct se_task *);
 	int (*emulate_read_cap)(struct se_task *);
 	int (*emulate_read_cap16)(struct se_task *);
 	int (*emulate_unmap)(struct se_task *);
@@ -554,6 +552,14 @@ struct se_subsystem_api {
 	 */
 	u32 (*get_device_type)(struct se_device *);
 	/*
+	 * Used to obtain INQUIRY Product field field
+	 */
+	char *(*get_inquiry_prod)(struct se_device *);
+	/*
+	 * Used to obtain INQUIRY Production revision field
+	 */
+	char *(*get_inquiry_rev)(struct se_device *);
+	/*
 	 * get_dma_length():
 	 */
 	u32 (*get_dma_length)(u32, struct se_device *);
-- 
1.5.6.5
