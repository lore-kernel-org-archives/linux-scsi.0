From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi_debug: Logical Block Provisioning (SBC3r26)
Date: Tue, 08 Mar 2011 02:08:11 -0500
Message-ID: <yq1oc5mcco4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:23888 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1CHHJN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2011 02:09:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Douglas Gilbert <dgilbert@interlog.com>


Update scsi_debug to support the Logical Block Provisioning commands and
bits as defined in SBC3r26. The old tp* parameters have been
transitioned to the new lbp* scheme found in the draft standard.

The old tpu option to enable UNMAP is now called lbpu. tpws to signal
support for WRITE SAME(16) with the UNMAP bit set is now lbpws. Support
for WRITE SAME(10) with the UNMAP bit set is also available using the
lpuws10 parameter.

Limiting the maximum number of blocks per WRITE SAME command has been
implemented and is available via the write_same_length module parameter.

As part of the renaming process the parameter lists have been sorted
alphabetically (request from Doug).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a6b2d72..5c48c50 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -89,32 +89,34 @@ static const char * scsi_debug_version_date = "20100324";
 /* With these defaults, this driver will make 1 host with 1 target
  * (id 0) containing 1 logical unit (lun 0). That is 1 device.
  */
+#define DEF_ATO 1
 #define DEF_DELAY   1
 #define DEF_DEV_SIZE_MB   8
-#define DEF_EVERY_NTH   0
-#define DEF_NUM_PARTS   0
-#define DEF_OPTS   0
-#define DEF_SCSI_LEVEL   5    /* INQUIRY, byte2 [5->SPC-3] */
-#define DEF_PTYPE   0
+#define DEF_DIF 0
+#define DEF_DIX 0
 #define DEF_D_SENSE   0
-#define DEF_NO_LUN_0   0
-#define DEF_VIRTUAL_GB   0
+#define DEF_EVERY_NTH   0
 #define DEF_FAKE_RW	0
-#define DEF_VPD_USE_HOSTNO 1
-#define DEF_SECTOR_SIZE 512
-#define DEF_DIX 0
-#define DEF_DIF 0
 #define DEF_GUARD 0
-#define DEF_ATO 1
-#define DEF_PHYSBLK_EXP 0
+#define DEF_LBPU 0
+#define DEF_LBPWS 0
+#define DEF_LBPWS10 0
 #define DEF_LOWEST_ALIGNED 0
+#define DEF_NO_LUN_0   0
+#define DEF_NUM_PARTS   0
+#define DEF_OPTS   0
 #define DEF_OPT_BLKS 64
+#define DEF_PHYSBLK_EXP 0
+#define DEF_PTYPE   0
+#define DEF_SCSI_LEVEL   5    /* INQUIRY, byte2 [5->SPC-3] */
+#define DEF_SECTOR_SIZE 512
+#define DEF_UNMAP_ALIGNMENT 0
+#define DEF_UNMAP_GRANULARITY 1
 #define DEF_UNMAP_MAX_BLOCKS 0xFFFFFFFF
 #define DEF_UNMAP_MAX_DESC 256
-#define DEF_UNMAP_GRANULARITY 1
-#define DEF_UNMAP_ALIGNMENT 0
-#define DEF_TPWS 0
-#define DEF_TPU 0
+#define DEF_VIRTUAL_GB   0
+#define DEF_VPD_USE_HOSTNO 1
+#define DEF_WRITESAME_LENGTH 0xFFFF
 
 /* bit mask values for scsi_debug_opts */
 #define SCSI_DEBUG_OPT_NOISE   1
@@ -155,36 +157,38 @@ static const char * scsi_debug_version_date = "20100324";
 #define SCSI_DEBUG_CANQUEUE  255
 
 static int scsi_debug_add_host = DEF_NUM_HOST;
+static int scsi_debug_ato = DEF_ATO;
 static int scsi_debug_delay = DEF_DELAY;
 static int scsi_debug_dev_size_mb = DEF_DEV_SIZE_MB;
+static int scsi_debug_dif = DEF_DIF;
+static int scsi_debug_dix = DEF_DIX;
+static int scsi_debug_dsense = DEF_D_SENSE;
 static int scsi_debug_every_nth = DEF_EVERY_NTH;
+static int scsi_debug_fake_rw = DEF_FAKE_RW;
+static int scsi_debug_guard = DEF_GUARD;
+static int scsi_debug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int scsi_debug_max_luns = DEF_MAX_LUNS;
 static int scsi_debug_max_queue = SCSI_DEBUG_CANQUEUE;
-static int scsi_debug_num_parts = DEF_NUM_PARTS;
+static int scsi_debug_no_lun_0 = DEF_NO_LUN_0;
 static int scsi_debug_no_uld = 0;
+static int scsi_debug_num_parts = DEF_NUM_PARTS;
 static int scsi_debug_num_tgts = DEF_NUM_TGTS; /* targets per host */
+static int scsi_debug_opt_blks = DEF_OPT_BLKS;
 static int scsi_debug_opts = DEF_OPTS;
-static int scsi_debug_scsi_level = DEF_SCSI_LEVEL;
+static int scsi_debug_physblk_exp = DEF_PHYSBLK_EXP;
 static int scsi_debug_ptype = DEF_PTYPE; /* SCSI peripheral type (0==disk) */
-static int scsi_debug_dsense = DEF_D_SENSE;
-static int scsi_debug_no_lun_0 = DEF_NO_LUN_0;
+static int scsi_debug_scsi_level = DEF_SCSI_LEVEL;
+static int scsi_debug_sector_size = DEF_SECTOR_SIZE;
 static int scsi_debug_virtual_gb = DEF_VIRTUAL_GB;
-static int scsi_debug_fake_rw = DEF_FAKE_RW;
 static int scsi_debug_vpd_use_hostno = DEF_VPD_USE_HOSTNO;
-static int scsi_debug_sector_size = DEF_SECTOR_SIZE;
-static int scsi_debug_dix = DEF_DIX;
-static int scsi_debug_dif = DEF_DIF;
-static int scsi_debug_guard = DEF_GUARD;
-static int scsi_debug_ato = DEF_ATO;
-static int scsi_debug_physblk_exp = DEF_PHYSBLK_EXP;
-static int scsi_debug_lowest_aligned = DEF_LOWEST_ALIGNED;
-static int scsi_debug_opt_blks = DEF_OPT_BLKS;
-static unsigned int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
-static unsigned int scsi_debug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
-static unsigned int scsi_debug_unmap_granularity = DEF_UNMAP_GRANULARITY;
+static unsigned int scsi_debug_lbpu = DEF_LBPU;
+static unsigned int scsi_debug_lbpws = DEF_LBPWS;
+static unsigned int scsi_debug_lbpws10 = DEF_LBPWS10;
 static unsigned int scsi_debug_unmap_alignment = DEF_UNMAP_ALIGNMENT;
-static unsigned int scsi_debug_tpws = DEF_TPWS;
-static unsigned int scsi_debug_tpu = DEF_TPU;
+static unsigned int scsi_debug_unmap_granularity = DEF_UNMAP_GRANULARITY;
+static unsigned int scsi_debug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
+static unsigned int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
+static unsigned int scsi_debug_write_same_length = DEF_WRITESAME_LENGTH;
 
 static int scsi_debug_cmnd_count = 0;
 
@@ -206,6 +210,11 @@ static int sdebug_sectors_per;		/* sectors per cylinder */
 
 #define SCSI_DEBUG_MAX_CMD_LEN 32
 
+static unsigned int scsi_debug_lbp(void)
+{
+	return scsi_debug_lbpu | scsi_debug_lbpws | scsi_debug_lbpws10;
+}
+
 struct sdebug_dev_info {
 	struct list_head dev_list;
 	unsigned char sense_buff[SDEBUG_SENSE_LEN];	/* weak nexus */
@@ -727,7 +736,7 @@ static int inquiry_evpd_b0(unsigned char * arr)
 	/* Optimal Transfer Length */
 	put_unaligned_be32(scsi_debug_opt_blks, &arr[8]);
 
-	if (scsi_debug_tpu) {
+	if (scsi_debug_lbpu) {
 		/* Maximum Unmap LBA Count */
 		put_unaligned_be32(scsi_debug_unmap_max_blocks, &arr[16]);
 
@@ -744,7 +753,10 @@ static int inquiry_evpd_b0(unsigned char * arr)
 	/* Optimal Unmap Granularity */
 	put_unaligned_be32(scsi_debug_unmap_granularity, &arr[24]);
 
-	return 0x3c; /* Mandatory page length for thin provisioning */
+	/* Maximum WRITE SAME Length */
+	put_unaligned_be64(scsi_debug_write_same_length, &arr[32]);
+
+	return 0x3c; /* Mandatory page length for Logical Block Provisioning */
 
 	return sizeof(vpdb0_data);
 }
@@ -767,12 +779,15 @@ static int inquiry_evpd_b2(unsigned char *arr)
 	memset(arr, 0, 0x8);
 	arr[0] = 0;			/* threshold exponent */
 
-	if (scsi_debug_tpu)
+	if (scsi_debug_lbpu)
 		arr[1] = 1 << 7;
 
-	if (scsi_debug_tpws)
+	if (scsi_debug_lbpws)
 		arr[1] |= 1 << 6;
 
+	if (scsi_debug_lbpws10)
+		arr[1] |= 1 << 5;
+
 	return 0x8;
 }
 
@@ -831,7 +846,8 @@ static int resp_inquiry(struct scsi_cmnd * scp, int target,
 			arr[n++] = 0x89;  /* ATA information */
 			arr[n++] = 0xb0;  /* Block limits (SBC) */
 			arr[n++] = 0xb1;  /* Block characteristics (SBC) */
-			arr[n++] = 0xb2;  /* Thin provisioning (SBC) */
+			if (scsi_debug_lbp()) /* Logical Block Prov. (SBC) */
+				arr[n++] = 0xb2;
 			arr[3] = n - 4;	  /* number of supported VPD pages */
 		} else if (0x80 == cmd[2]) { /* unit serial number */
 			arr[1] = cmd[2];	/*sanity */
@@ -879,7 +895,7 @@ static int resp_inquiry(struct scsi_cmnd * scp, int target,
 		} else if (0xb1 == cmd[2]) { /* Block characteristics (SBC) */
 			arr[1] = cmd[2];        /*sanity */
 			arr[3] = inquiry_evpd_b1(&arr[4]);
-		} else if (0xb2 == cmd[2]) { /* Thin provisioning (SBC) */
+		} else if (0xb2 == cmd[2]) { /* Logical Block Prov. (SBC) */
 			arr[1] = cmd[2];        /*sanity */
 			arr[3] = inquiry_evpd_b2(&arr[4]);
 		} else {
@@ -1053,8 +1069,8 @@ static int resp_readcap16(struct scsi_cmnd * scp,
 	arr[13] = scsi_debug_physblk_exp & 0xf;
 	arr[14] = (scsi_debug_lowest_aligned >> 8) & 0x3f;
 
-	if (scsi_debug_tpu || scsi_debug_tpws)
-		arr[14] |= 0x80; /* TPE */
+	if (scsi_debug_lbp())
+		arr[14] |= 0x80; /* LBPME */
 
 	arr[15] = scsi_debug_lowest_aligned & 0xff;
 
@@ -2084,6 +2100,12 @@ static int resp_write_same(struct scsi_cmnd *scmd, unsigned long long lba,
 	if (ret)
 		return ret;
 
+	if (num > scsi_debug_write_same_length) {
+		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
+				0);
+		return check_condition_result;
+	}
+
 	write_lock_irqsave(&atomic_rw, iflags);
 
 	if (unmap && scsi_debug_unmap_granularity) {
@@ -2695,37 +2717,40 @@ static int schedule_resp(struct scsi_cmnd * cmnd,
    /sys/bus/pseudo/drivers/scsi_debug directory is changed.
  */
 module_param_named(add_host, scsi_debug_add_host, int, S_IRUGO | S_IWUSR);
+module_param_named(ato, scsi_debug_ato, int, S_IRUGO);
 module_param_named(delay, scsi_debug_delay, int, S_IRUGO | S_IWUSR);
 module_param_named(dev_size_mb, scsi_debug_dev_size_mb, int, S_IRUGO);
+module_param_named(dif, scsi_debug_dif, int, S_IRUGO);
+module_param_named(dix, scsi_debug_dix, int, S_IRUGO);
 module_param_named(dsense, scsi_debug_dsense, int, S_IRUGO | S_IWUSR);
 module_param_named(every_nth, scsi_debug_every_nth, int, S_IRUGO | S_IWUSR);
 module_param_named(fake_rw, scsi_debug_fake_rw, int, S_IRUGO | S_IWUSR);
+module_param_named(guard, scsi_debug_guard, int, S_IRUGO);
+module_param_named(lbpu, scsi_debug_lbpu, int, S_IRUGO);
+module_param_named(lbpws, scsi_debug_lbpws, int, S_IRUGO);
+module_param_named(lbpws10, scsi_debug_lbpws10, int, S_IRUGO);
+module_param_named(lowest_aligned, scsi_debug_lowest_aligned, int, S_IRUGO);
 module_param_named(max_luns, scsi_debug_max_luns, int, S_IRUGO | S_IWUSR);
 module_param_named(max_queue, scsi_debug_max_queue, int, S_IRUGO | S_IWUSR);
 module_param_named(no_lun_0, scsi_debug_no_lun_0, int, S_IRUGO | S_IWUSR);
 module_param_named(no_uld, scsi_debug_no_uld, int, S_IRUGO);
 module_param_named(num_parts, scsi_debug_num_parts, int, S_IRUGO);
 module_param_named(num_tgts, scsi_debug_num_tgts, int, S_IRUGO | S_IWUSR);
+module_param_named(opt_blks, scsi_debug_opt_blks, int, S_IRUGO);
 module_param_named(opts, scsi_debug_opts, int, S_IRUGO | S_IWUSR);
+module_param_named(physblk_exp, scsi_debug_physblk_exp, int, S_IRUGO);
 module_param_named(ptype, scsi_debug_ptype, int, S_IRUGO | S_IWUSR);
 module_param_named(scsi_level, scsi_debug_scsi_level, int, S_IRUGO);
-module_param_named(virtual_gb, scsi_debug_virtual_gb, int, S_IRUGO | S_IWUSR);
-module_param_named(vpd_use_hostno, scsi_debug_vpd_use_hostno, int,
-		   S_IRUGO | S_IWUSR);
 module_param_named(sector_size, scsi_debug_sector_size, int, S_IRUGO);
-module_param_named(dix, scsi_debug_dix, int, S_IRUGO);
-module_param_named(dif, scsi_debug_dif, int, S_IRUGO);
-module_param_named(guard, scsi_debug_guard, int, S_IRUGO);
-module_param_named(ato, scsi_debug_ato, int, S_IRUGO);
-module_param_named(physblk_exp, scsi_debug_physblk_exp, int, S_IRUGO);
-module_param_named(opt_blks, scsi_debug_opt_blks, int, S_IRUGO);
-module_param_named(lowest_aligned, scsi_debug_lowest_aligned, int, S_IRUGO);
+module_param_named(unmap_alignment, scsi_debug_unmap_alignment, int, S_IRUGO);
+module_param_named(unmap_granularity, scsi_debug_unmap_granularity, int, S_IRUGO);
 module_param_named(unmap_max_blocks, scsi_debug_unmap_max_blocks, int, S_IRUGO);
 module_param_named(unmap_max_desc, scsi_debug_unmap_max_desc, int, S_IRUGO);
-module_param_named(unmap_granularity, scsi_debug_unmap_granularity, int, S_IRUGO);
-module_param_named(unmap_alignment, scsi_debug_unmap_alignment, int, S_IRUGO);
-module_param_named(tpu, scsi_debug_tpu, int, S_IRUGO);
-module_param_named(tpws, scsi_debug_tpws, int, S_IRUGO);
+module_param_named(virtual_gb, scsi_debug_virtual_gb, int, S_IRUGO | S_IWUSR);
+module_param_named(vpd_use_hostno, scsi_debug_vpd_use_hostno, int,
+		   S_IRUGO | S_IWUSR);
+module_param_named(write_same_length, scsi_debug_write_same_length, int,
+		   S_IRUGO | S_IWUSR);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -2733,36 +2758,38 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(SCSI_DEBUG_VERSION);
 
 MODULE_PARM_DESC(add_host, "0..127 hosts allowed(def=1)");
+MODULE_PARM_DESC(ato, "application tag ownership: 0=disk 1=host (def=1)");
 MODULE_PARM_DESC(delay, "# of jiffies to delay response(def=1)");
 MODULE_PARM_DESC(dev_size_mb, "size in MB of ram shared by devs(def=8)");
+MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
+MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
 MODULE_PARM_DESC(dsense, "use descriptor sense format(def=0 -> fixed)");
 MODULE_PARM_DESC(every_nth, "timeout every nth command(def=0)");
 MODULE_PARM_DESC(fake_rw, "fake reads/writes instead of copying (def=0)");
+MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
+MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
+MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
+MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
+MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
 MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to 255(def))");
 MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
 MODULE_PARM_DESC(no_uld, "stop ULD (e.g. sd driver) attaching (def=0))");
 MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
 MODULE_PARM_DESC(num_tgts, "number of targets per host to simulate(def=1)");
+MODULE_PARM_DESC(opt_blks, "optimal transfer length in block (def=64)");
 MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recovered_err... (def=0)");
+MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=5[SPC-3])");
-MODULE_PARM_DESC(virtual_gb, "virtual gigabyte size (def=0 -> use dev_size_mb)");
-MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
 MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
-MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
-MODULE_PARM_DESC(opt_blks, "optimal transfer length in block (def=64)");
-MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
-MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
-MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
-MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
-MODULE_PARM_DESC(ato, "application tag ownership: 0=disk 1=host (def=1)");
+MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)");
+MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
 MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0xffffffff)");
 MODULE_PARM_DESC(unmap_max_desc, "max # of ranges that can be unmapped in one cmd (def=256)");
-MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
-MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)");
-MODULE_PARM_DESC(tpu, "enable TP, support UNMAP command (def=0)");
-MODULE_PARM_DESC(tpws, "enable TP, support WRITE SAME(16) with UNMAP bit (def=0)");
+MODULE_PARM_DESC(virtual_gb, "virtual gigabyte size (def=0 -> use dev_size_mb)");
+MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
+MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xffff)");
 
 static char sdebug_info[256];
 
@@ -3150,7 +3177,7 @@ static ssize_t sdebug_map_show(struct device_driver *ddp, char *buf)
 {
 	ssize_t count;
 
-	if (scsi_debug_tpu == 0 && scsi_debug_tpws == 0)
+	if (!scsi_debug_lbp())
 		return scnprintf(buf, PAGE_SIZE, "0-%u\n",
 				 sdebug_store_sectors);
 
@@ -3333,8 +3360,8 @@ static int __init scsi_debug_init(void)
 		memset(dif_storep, 0xff, dif_size);
 	}
 
-	/* Thin Provisioning */
-	if (scsi_debug_tpu || scsi_debug_tpws) {
+	/* Logical Block Provisioning */
+	if (scsi_debug_lbp()) {
 		unsigned int map_bytes;
 
 		scsi_debug_unmap_max_blocks =
@@ -3664,7 +3691,7 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 			errsts = resp_readcap16(SCpnt, devip);
 		else if (cmd[1] == SAI_GET_LBA_STATUS) {
 
-			if (scsi_debug_tpu == 0 && scsi_debug_tpws == 0) {
+			if (scsi_debug_lbp() == 0) {
 				mk_sense_buffer(devip, ILLEGAL_REQUEST,
 						INVALID_COMMAND_OPCODE, 0);
 				errsts = check_condition_result;
@@ -3775,8 +3802,10 @@ write:
 		}
 		break;
 	case WRITE_SAME_16:
+	case WRITE_SAME:
 		if (cmd[1] & 0x8) {
-			if (scsi_debug_tpws == 0) {
+			if ((*cmd == WRITE_SAME_16 && scsi_debug_lbpws == 0) ||
+			    (*cmd == WRITE_SAME && scsi_debug_lbpws10 == 0)) {
 				mk_sense_buffer(devip, ILLEGAL_REQUEST,
 						INVALID_FIELD_IN_CDB, 0);
 				errsts = check_condition_result;
@@ -3785,8 +3814,6 @@ write:
 		}
 		if (errsts)
 			break;
-		/* fall through */
-	case WRITE_SAME:
 		errsts = check_readiness(SCpnt, 0, devip);
 		if (errsts)
 			break;
@@ -3798,7 +3825,7 @@ write:
 		if (errsts)
 			break;
 
-		if (scsi_debug_unmap_max_desc == 0 || scsi_debug_tpu == 0) {
+		if (scsi_debug_unmap_max_desc == 0 || scsi_debug_lbpu == 0) {
 			mk_sense_buffer(devip, ILLEGAL_REQUEST,
 					INVALID_COMMAND_OPCODE, 0);
 			errsts = check_condition_result;
