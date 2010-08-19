From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5/6] scsi_debug: Update thin provisioning support
Date: Thu, 19 Aug 2010 11:49:00 -0400
Message-ID: <1282232941-9910-6-git-send-email-martin.petersen@oracle.com>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

The previous thin provisioning support was not very user friendly
because it depended on all the relevant options being set on the command
line.

Implement support for the Thin Provisioning VPD page from SBC3 r24 and
add module options for TPU (UNMAP) and TPWS (WRITE SAME (16) with UNMAP
bit).  This allows us to have sane default and to enable thin
provisioning with a simple tpu=1 or tpws=1 on the command line depending
on whether we want UNMAP or WRITE SAME behavior.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_debug.c |  100 +++++++++++++++++++++++++++++++--------------
 1 files changed, 69 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 136329b..dbade50 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -109,10 +109,12 @@ static const char * scsi_debug_version_date = "20100324";
 #define DEF_PHYSBLK_EXP 0
 #define DEF_LOWEST_ALIGNED 0
 #define DEF_OPT_BLKS 64
-#define DEF_UNMAP_MAX_BLOCKS 0
-#define DEF_UNMAP_MAX_DESC 0
-#define DEF_UNMAP_GRANULARITY 0
+#define DEF_UNMAP_MAX_BLOCKS 0xFFFFFFFF
+#define DEF_UNMAP_MAX_DESC 256
+#define DEF_UNMAP_GRANULARITY 1
 #define DEF_UNMAP_ALIGNMENT 0
+#define DEF_TPWS 0
+#define DEF_TPU 0
 
 /* bit mask values for scsi_debug_opts */
 #define SCSI_DEBUG_OPT_NOISE   1
@@ -177,10 +179,12 @@ static int scsi_debug_ato = DEF_ATO;
 static int scsi_debug_physblk_exp = DEF_PHYSBLK_EXP;
 static int scsi_debug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int scsi_debug_opt_blks = DEF_OPT_BLKS;
-static int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
-static int scsi_debug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
-static int scsi_debug_unmap_granularity = DEF_UNMAP_GRANULARITY;
-static int scsi_debug_unmap_alignment = DEF_UNMAP_ALIGNMENT;
+static unsigned int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
+static unsigned int scsi_debug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
+static unsigned int scsi_debug_unmap_granularity = DEF_UNMAP_GRANULARITY;
+static unsigned int scsi_debug_unmap_alignment = DEF_UNMAP_ALIGNMENT;
+static unsigned int scsi_debug_tpws = DEF_TPWS;
+static unsigned int scsi_debug_tpu = DEF_TPU;
 
 static int scsi_debug_cmnd_count = 0;
 
@@ -723,16 +727,9 @@ static int inquiry_evpd_b0(unsigned char * arr)
 	/* Optimal Transfer Length */
 	put_unaligned_be32(scsi_debug_opt_blks, &arr[8]);
 
-	if (scsi_debug_unmap_max_desc) {
-		unsigned int blocks;
-
-		if (scsi_debug_unmap_max_blocks)
-			blocks = scsi_debug_unmap_max_blocks;
-		else
-			blocks = 0xffffffff;
-
+	if (scsi_debug_tpu) {
 		/* Maximum Unmap LBA Count */
-		put_unaligned_be32(blocks, &arr[16]);
+		put_unaligned_be32(scsi_debug_unmap_max_blocks, &arr[16]);
 
 		/* Maximum Unmap Block Descriptor Count */
 		put_unaligned_be32(scsi_debug_unmap_max_desc, &arr[20]);
@@ -745,10 +742,9 @@ static int inquiry_evpd_b0(unsigned char * arr)
 	}
 
 	/* Optimal Unmap Granularity */
-	if (scsi_debug_unmap_granularity) {
-		put_unaligned_be32(scsi_debug_unmap_granularity, &arr[24]);
-		return 0x3c; /* Mandatory page length for thin provisioning */
-	}
+	put_unaligned_be32(scsi_debug_unmap_granularity, &arr[24]);
+
+	return 0x3c; /* Mandatory page length for thin provisioning */
 
 	return sizeof(vpdb0_data);
 }
@@ -765,6 +761,21 @@ static int inquiry_evpd_b1(unsigned char *arr)
 	return 0x3c;
 }
 
+/* Thin provisioning VPD page (SBC-3) */
+static int inquiry_evpd_b2(unsigned char *arr)
+{
+	memset(arr, 0, 0x8);
+	arr[0] = 0;			/* threshold exponent */
+
+	if (scsi_debug_tpu)
+		arr[1] = 1 << 7;
+
+	if (scsi_debug_tpws)
+		arr[1] |= 1 << 6;
+
+	return 0x8;
+}
+
 #define SDEBUG_LONG_INQ_SZ 96
 #define SDEBUG_MAX_INQ_ARR_SZ 584
 
@@ -820,6 +831,7 @@ static int resp_inquiry(struct scsi_cmnd * scp, int target,
 			arr[n++] = 0x89;  /* ATA information */
 			arr[n++] = 0xb0;  /* Block limits (SBC) */
 			arr[n++] = 0xb1;  /* Block characteristics (SBC) */
+			arr[n++] = 0xb2;  /* Thin provisioning (SBC) */
 			arr[3] = n - 4;	  /* number of supported VPD pages */
 		} else if (0x80 == cmd[2]) { /* unit serial number */
 			arr[1] = cmd[2];	/*sanity */
@@ -867,6 +879,9 @@ static int resp_inquiry(struct scsi_cmnd * scp, int target,
 		} else if (0xb1 == cmd[2]) { /* Block characteristics (SBC) */
 			arr[1] = cmd[2];        /*sanity */
 			arr[3] = inquiry_evpd_b1(&arr[4]);
+		} else if (0xb2 == cmd[2]) { /* Thin provisioning (SBC) */
+			arr[1] = cmd[2];        /*sanity */
+			arr[3] = inquiry_evpd_b2(&arr[4]);
 		} else {
 			/* Illegal request, invalid field in cdb */
 			mk_sense_buffer(devip, ILLEGAL_REQUEST,
@@ -1038,7 +1053,7 @@ static int resp_readcap16(struct scsi_cmnd * scp,
 	arr[13] = scsi_debug_physblk_exp & 0xf;
 	arr[14] = (scsi_debug_lowest_aligned >> 8) & 0x3f;
 
-	if (scsi_debug_unmap_granularity)
+	if (scsi_debug_tpu || scsi_debug_tpws)
 		arr[14] |= 0x80; /* TPE */
 
 	arr[15] = scsi_debug_lowest_aligned & 0xff;
@@ -2706,6 +2721,8 @@ module_param_named(unmap_max_blocks, scsi_debug_unmap_max_blocks, int, S_IRUGO);
 module_param_named(unmap_max_desc, scsi_debug_unmap_max_desc, int, S_IRUGO);
 module_param_named(unmap_granularity, scsi_debug_unmap_granularity, int, S_IRUGO);
 module_param_named(unmap_alignment, scsi_debug_unmap_alignment, int, S_IRUGO);
+module_param_named(tpu, scsi_debug_tpu, int, S_IRUGO);
+module_param_named(tpws, scsi_debug_tpws, int, S_IRUGO);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -2737,10 +2754,12 @@ MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
 MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
 MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
 MODULE_PARM_DESC(ato, "application tag ownership: 0=disk 1=host (def=1)");
-MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0)");
-MODULE_PARM_DESC(unmap_max_desc, "max # of ranges that can be unmapped in one cmd (def=0)");
-MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=0)");
+MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0xffffffff)");
+MODULE_PARM_DESC(unmap_max_desc, "max # of ranges that can be unmapped in one cmd (def=256)");
+MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
 MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)");
+MODULE_PARM_DESC(tpu, "enable TP, support UNMAP command (def=0)");
+MODULE_PARM_DESC(tpws, "enable TP, support WRITE SAME(16) with UNMAP bit (def=0)");
 
 static char sdebug_info[256];
 
@@ -3128,7 +3147,7 @@ static ssize_t sdebug_map_show(struct device_driver *ddp, char *buf)
 {
 	ssize_t count;
 
-	if (scsi_debug_unmap_granularity == 0)
+	if (scsi_debug_tpu == 0 && scsi_debug_tpws == 0)
 		return scnprintf(buf, PAGE_SIZE, "0-%u\n",
 				 sdebug_store_sectors);
 
@@ -3320,10 +3339,21 @@ static int __init scsi_debug_init(void)
 		memset(dif_storep, 0xff, dif_size);
 	}
 
-	if (scsi_debug_unmap_granularity) {
+	/* Thin Provisioning */
+	if (scsi_debug_tpu || scsi_debug_tpws) {
 		unsigned int map_bytes;
 
-		if (scsi_debug_unmap_granularity < scsi_debug_unmap_alignment) {
+		scsi_debug_unmap_max_blocks =
+			clamp(scsi_debug_unmap_max_blocks, 0U, 0xffffffffU);
+
+		scsi_debug_unmap_max_desc =
+			clamp(scsi_debug_unmap_max_desc, 0U, 256U);
+
+		scsi_debug_unmap_granularity =
+			clamp(scsi_debug_unmap_granularity, 1U, 0xffffffffU);
+
+		if (scsi_debug_unmap_alignment &&
+		    scsi_debug_unmap_granularity < scsi_debug_unmap_alignment) {
 			printk(KERN_ERR
 			       "%s: ERR: unmap_granularity < unmap_alignment\n",
 			       __func__);
@@ -3640,7 +3670,7 @@ int scsi_debug_queuecommand(struct scsi_cmnd *SCpnt, done_funct_t done)
 			errsts = resp_readcap16(SCpnt, devip);
 		else if (cmd[1] == SAI_GET_LBA_STATUS) {
 
-			if (scsi_debug_unmap_max_desc == 0) {
+			if (scsi_debug_tpu == 0 && scsi_debug_tpws == 0) {
 				mk_sense_buffer(devip, ILLEGAL_REQUEST,
 						INVALID_COMMAND_OPCODE, 0);
 				errsts = check_condition_result;
@@ -3751,8 +3781,16 @@ write:
 		}
 		break;
 	case WRITE_SAME_16:
-		if (cmd[1] & 0x8)
-			unmap = 1;
+		if (cmd[1] & 0x8) {
+			if (scsi_debug_tpws == 0) {
+				mk_sense_buffer(devip, ILLEGAL_REQUEST,
+						INVALID_FIELD_IN_CDB, 0);
+				errsts = check_condition_result;
+			} else
+				unmap = 1;
+		}
+		if (errsts)
+			break;
 		/* fall through */
 	case WRITE_SAME:
 		errsts = check_readiness(SCpnt, 0, devip);
@@ -3766,7 +3804,7 @@ write:
 		if (errsts)
 			break;
 
-		if (scsi_debug_unmap_max_desc == 0) {
+		if (scsi_debug_unmap_max_desc == 0 || scsi_debug_tpu == 0) {
 			mk_sense_buffer(devip, ILLEGAL_REQUEST,
 					INVALID_COMMAND_OPCODE, 0);
 			errsts = check_condition_result;
-- 
1.7.2.1

