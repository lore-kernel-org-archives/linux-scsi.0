From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v3 4/6] scsi_debug: vpd and mode page work
Date: Fri,  6 May 2016 00:40:27 -0400
Message-ID: <1462509629-24282-5-git-send-email-dgilbert@interlog.com>
References: <1462509629-24282-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55624 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbcEFEkp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2016 00:40:45 -0400
In-Reply-To: <1462509629-24282-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

Cleanup some mode and vpd pages. Stop reporting SBC (disk) pages
when peripheral type is something else (e.g. tape). Update
version descriptors. Expand LBPRZ flag handling.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 187 ++++++++++++++++++++++++++--------------------
 1 file changed, 108 insertions(+), 79 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2ee55d5..afbbfaa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -125,7 +125,7 @@ static const char *sdebug_version_date = "20160430";
 #define DEF_PHYSBLK_EXP 0
 #define DEF_PTYPE   TYPE_DISK
 #define DEF_REMOVABLE false
-#define DEF_SCSI_LEVEL   6    /* INQUIRY, byte2 [6->SPC-4] */
+#define DEF_SCSI_LEVEL   7    /* INQUIRY, byte2 [6->SPC-4; 7->SPC-5] */
 #define DEF_SECTOR_SIZE 512
 #define DEF_UNMAP_ALIGNMENT 0
 #define DEF_UNMAP_GRANULARITY 1
@@ -661,7 +661,11 @@ static const int device_qfull_result =
 	(DID_OK << 16) | (COMMAND_COMPLETE << 8) | SAM_STAT_TASK_SET_FULL;
 
 
-static inline unsigned int scsi_debug_lbp(void)
+/* Only do the extra work involved in logical block provisioning if one or
+ * more of the lbpu, lbpws or lbpws10 parameters are given and we are doing
+ * real reads and writes (i.e. not skipping them for speed).
+ */
+static inline bool scsi_debug_lbp(void)
 {
 	return 0 == sdebug_fake_rw &&
 		(sdebug_lbpu || sdebug_lbpws || sdebug_lbpws10);
@@ -922,10 +926,10 @@ static const u64 naa5_comp_b = 0x5333333000000000ULL;
 static const u64 naa5_comp_c = 0x5111111000000000ULL;
 
 /* Device identification VPD page. Returns number of bytes placed in arr */
-static int inquiry_evpd_83(unsigned char * arr, int port_group_id,
-			   int target_dev_id, int dev_id_num,
-			   const char * dev_id_str,
-			   int dev_id_str_len)
+static int inquiry_vpd_83(unsigned char *arr, int port_group_id,
+			  int target_dev_id, int dev_id_num,
+			  const char *dev_id_str,
+			  int dev_id_str_len)
 {
 	int num, port_a;
 	char b[32];
@@ -1004,14 +1008,14 @@ static unsigned char vpd84_data[] = {
 };
 
 /*  Software interface identification VPD page */
-static int inquiry_evpd_84(unsigned char * arr)
+static int inquiry_vpd_84(unsigned char *arr)
 {
 	memcpy(arr, vpd84_data, sizeof(vpd84_data));
 	return sizeof(vpd84_data);
 }
 
 /* Management network addresses VPD page */
-static int inquiry_evpd_85(unsigned char * arr)
+static int inquiry_vpd_85(unsigned char *arr)
 {
 	int num = 0;
 	const char * na1 = "https://www.kernel.org/config";
@@ -1046,7 +1050,7 @@ static int inquiry_evpd_85(unsigned char * arr)
 }
 
 /* SCSI ports VPD page */
-static int inquiry_evpd_88(unsigned char * arr, int target_dev_id)
+static int inquiry_vpd_88(unsigned char *arr, int target_dev_id)
 {
 	int num = 0;
 	int port_a, port_b;
@@ -1133,7 +1137,7 @@ static unsigned char vpd89_data[] = {
 };
 
 /* ATA Information VPD page */
-static int inquiry_evpd_89(unsigned char * arr)
+static int inquiry_vpd_89(unsigned char *arr)
 {
 	memcpy(arr, vpd89_data, sizeof(vpd89_data));
 	return sizeof(vpd89_data);
@@ -1148,7 +1152,7 @@ static unsigned char vpdb0_data[] = {
 };
 
 /* Block limits VPD page (SBC-3) */
-static int inquiry_evpd_b0(unsigned char * arr)
+static int inquiry_vpd_b0(unsigned char *arr)
 {
 	unsigned int gran;
 
@@ -1191,7 +1195,7 @@ static int inquiry_evpd_b0(unsigned char * arr)
 }
 
 /* Block device characteristics VPD page (SBC-3) */
-static int inquiry_evpd_b1(unsigned char *arr)
+static int inquiry_vpd_b1(unsigned char *arr)
 {
 	memset(arr, 0, 0x3c);
 	arr[0] = 0;
@@ -1202,24 +1206,22 @@ static int inquiry_evpd_b1(unsigned char *arr)
 	return 0x3c;
 }
 
-/* Logical block provisioning VPD page (SBC-3) */
-static int inquiry_evpd_b2(unsigned char *arr)
+/* Logical block provisioning VPD page (SBC-4) */
+static int inquiry_vpd_b2(unsigned char *arr)
 {
 	memset(arr, 0, 0x4);
 	arr[0] = 0;			/* threshold exponent */
-
 	if (sdebug_lbpu)
 		arr[1] = 1 << 7;
-
 	if (sdebug_lbpws)
 		arr[1] |= 1 << 6;
-
 	if (sdebug_lbpws10)
 		arr[1] |= 1 << 5;
-
-	if (sdebug_lbprz)
-		arr[1] |= 1 << 2;
-
+	if (sdebug_lbprz && scsi_debug_lbp())
+		arr[1] |= (sdebug_lbprz & 0x7) << 2;  /* sbc4r07 and later */
+	/* anc_sup=0; dp=0 (no provisioning group descriptor) */
+	/* minimum_percentage=0; provisioning_type=0 (unknown) */
+	/* threshold_percentage=0 */
 	return 0x4;
 }
 
@@ -1232,12 +1234,13 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	unsigned char * arr;
 	unsigned char *cmd = scp->cmnd;
 	int alloc_len, n, ret;
-	bool have_wlun;
+	bool have_wlun, is_disk;
 
 	alloc_len = get_unaligned_be16(cmd + 3);
 	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
 	if (! arr)
 		return DID_REQUEUE << 16;
+	is_disk = (sdebug_ptype == TYPE_DISK);
 	have_wlun = scsi_is_wlun(scp->device->lun);
 	if (have_wlun)
 		pq_pdt = TYPE_WLUN;	/* present, wlun */
@@ -1275,11 +1278,12 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			arr[n++] = 0x86;  /* extended inquiry */
 			arr[n++] = 0x87;  /* mode page policy */
 			arr[n++] = 0x88;  /* SCSI ports */
-			arr[n++] = 0x89;  /* ATA information */
-			arr[n++] = 0xb0;  /* Block limits (SBC) */
-			arr[n++] = 0xb1;  /* Block characteristics (SBC) */
-			if (scsi_debug_lbp()) /* Logical Block Prov. (SBC) */
-				arr[n++] = 0xb2;
+			if (is_disk) {	  /* SBC only */
+				arr[n++] = 0x89;  /* ATA information */
+				arr[n++] = 0xb0;  /* Block limits */
+				arr[n++] = 0xb1;  /* Block characteristics */
+				arr[n++] = 0xb2;  /* Logical Block Prov */
+			}
 			arr[3] = n - 4;	  /* number of supported VPD pages */
 		} else if (0x80 == cmd[2]) { /* unit serial number */
 			arr[1] = cmd[2];	/*sanity */
@@ -1287,21 +1291,21 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			memcpy(&arr[4], lu_id_str, len);
 		} else if (0x83 == cmd[2]) { /* device identification */
 			arr[1] = cmd[2];	/*sanity */
-			arr[3] = inquiry_evpd_83(&arr[4], port_group_id,
-						 target_dev_id, lu_id_num,
-						 lu_id_str, len);
+			arr[3] = inquiry_vpd_83(&arr[4], port_group_id,
+						target_dev_id, lu_id_num,
+						lu_id_str, len);
 		} else if (0x84 == cmd[2]) { /* Software interface ident. */
 			arr[1] = cmd[2];	/*sanity */
-			arr[3] = inquiry_evpd_84(&arr[4]);
+			arr[3] = inquiry_vpd_84(&arr[4]);
 		} else if (0x85 == cmd[2]) { /* Management network addresses */
 			arr[1] = cmd[2];	/*sanity */
-			arr[3] = inquiry_evpd_85(&arr[4]);
+			arr[3] = inquiry_vpd_85(&arr[4]);
 		} else if (0x86 == cmd[2]) { /* extended inquiry */
 			arr[1] = cmd[2];	/*sanity */
 			arr[3] = 0x3c;	/* number of following entries */
 			if (sdebug_dif == SD_DIF_TYPE3_PROTECTION)
 				arr[4] = 0x4;	/* SPT: GRD_CHK:1 */
-			else if (sdebug_dif)
+			else if (have_dif_prot)
 				arr[4] = 0x5;   /* SPT: GRD_CHK:1, REF_CHK:1 */
 			else
 				arr[4] = 0x0;   /* no protection stuff */
@@ -1315,20 +1319,20 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			arr[10] = 0x82;	 /* mlus, per initiator port */
 		} else if (0x88 == cmd[2]) { /* SCSI Ports */
 			arr[1] = cmd[2];	/*sanity */
-			arr[3] = inquiry_evpd_88(&arr[4], target_dev_id);
-		} else if (0x89 == cmd[2]) { /* ATA information */
+			arr[3] = inquiry_vpd_88(&arr[4], target_dev_id);
+		} else if (is_disk && 0x89 == cmd[2]) { /* ATA information */
 			arr[1] = cmd[2];        /*sanity */
-			n = inquiry_evpd_89(&arr[4]);
+			n = inquiry_vpd_89(&arr[4]);
 			put_unaligned_be16(n, arr + 2);
-		} else if (0xb0 == cmd[2]) { /* Block limits (SBC) */
+		} else if (is_disk && 0xb0 == cmd[2]) { /* Block limits */
 			arr[1] = cmd[2];        /*sanity */
-			arr[3] = inquiry_evpd_b0(&arr[4]);
-		} else if (0xb1 == cmd[2]) { /* Block characteristics (SBC) */
+			arr[3] = inquiry_vpd_b0(&arr[4]);
+		} else if (is_disk && 0xb1 == cmd[2]) { /* Block char. */
 			arr[1] = cmd[2];        /*sanity */
-			arr[3] = inquiry_evpd_b1(&arr[4]);
-		} else if (0xb2 == cmd[2]) { /* Logical Block Prov. (SBC) */
+			arr[3] = inquiry_vpd_b1(&arr[4]);
+		} else if (is_disk && 0xb2 == cmd[2]) { /* LB Prov. */
 			arr[1] = cmd[2];        /*sanity */
-			arr[3] = inquiry_evpd_b2(&arr[4]);
+			arr[3] = inquiry_vpd_b2(&arr[4]);
 		} else {
 			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
 			kfree(arr);
@@ -1355,15 +1359,17 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	memcpy(&arr[16], inq_product_id, 16);
 	memcpy(&arr[32], inq_product_rev, 4);
 	/* version descriptors (2 bytes each) follow */
-	arr[58] = 0x0; arr[59] = 0xa2;  /* SAM-5 rev 4 */
-	arr[60] = 0x4; arr[61] = 0x68;  /* SPC-4 rev 37 */
+	put_unaligned_be16(0xc0, arr + 58);   /* SAM-6 no version claimed */
+	put_unaligned_be16(0x5c0, arr + 60);  /* SPC-5 no version claimed */
 	n = 62;
-	if (sdebug_ptype == TYPE_DISK) {
-		arr[n++] = 0x4; arr[n++] = 0xc5; /* SBC-4 rev 36 */
-	} else if (sdebug_ptype == TYPE_TAPE) {
-		arr[n++] = 0x5; arr[n++] = 0x25; /* SSC-4 rev 3 */
-	}
-	arr[n++] = 0x20; arr[n++] = 0xe6;  /* SPL-3 rev 7 */
+	if (is_disk) {		/* SBC-4 no version claimed */
+		put_unaligned_be16(0x600, arr + n);
+		n += 2;
+	} else if (sdebug_ptype == TYPE_TAPE) {	/* SSC-4 rev 3 */
+		put_unaligned_be16(0x525, arr + n);
+		n += 2;
+	}
+	put_unaligned_be16(0x2100, arr + n);	/* SPL-4 no version claimed */
 	ret = fill_from_dev_buffer(scp, arr,
 			    min(alloc_len, SDEBUG_LONG_INQ_SZ));
 	kfree(arr);
@@ -1499,13 +1505,17 @@ static int resp_readcap16(struct scsi_cmnd * scp,
 
 	if (scsi_debug_lbp()) {
 		arr[14] |= 0x80; /* LBPME */
-		if (sdebug_lbprz)
-			arr[14] |= 0x40; /* LBPRZ */
+		/* from sbc4r07, this LBPRZ field is 1 bit, but the LBPRZ in
+		 * the LB Provisioning VPD page is 3 bits. Note that lbprz=2
+		 * in the wider field maps to 0 in this field.
+		 */
+		if (sdebug_lbprz & 1)	/* precisely what the draft requires */
+			arr[14] |= 0x40;
 	}
 
 	arr[15] = sdebug_lowest_aligned & 0xff;
 
-	if (sdebug_dif) {
+	if (have_dif_prot) {
 		arr[12] = (sdebug_dif - 1) << 1; /* P_TYPE */
 		arr[12] |= 1; /* PROT_EN */
 	}
@@ -1935,22 +1945,23 @@ static int resp_sas_sha_m_spg(unsigned char * p, int pcontrol)
 static int resp_mode_sense(struct scsi_cmnd *scp,
 			   struct sdebug_dev_info *devip)
 {
-	unsigned char dbd, llbaa;
 	int pcontrol, pcode, subpcode, bd_len;
 	unsigned char dev_spec;
-	int alloc_len, msense_6, offset, len, target_dev_id;
+	int alloc_len, offset, len, target_dev_id;
 	int target = scp->device->id;
 	unsigned char * ap;
 	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
 	unsigned char *cmd = scp->cmnd;
+	bool dbd, llbaa, msense_6, is_disk, bad_pcode;
 
-	dbd = !!(cmd[1] & 0x8);
+	dbd = !!(cmd[1] & 0x8);		/* disable block descriptors */
 	pcontrol = (cmd[2] & 0xc0) >> 6;
 	pcode = cmd[2] & 0x3f;
 	subpcode = cmd[3];
 	msense_6 = (MODE_SENSE == cmd[0]);
-	llbaa = msense_6 ? 0 : !!(cmd[1] & 0x10);
-	if ((sdebug_ptype == TYPE_DISK) && (dbd == 0))
+	llbaa = msense_6 ? false : !!(cmd[1] & 0x10);
+	is_disk = (sdebug_ptype == TYPE_DISK);
+	if (is_disk && !dbd)
 		bd_len = llbaa ? 16 : 8;
 	else
 		bd_len = 0;
@@ -1963,7 +1974,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	target_dev_id = ((devip->sdbg_host->shost->host_no + 1) * 2000) +
 			(devip->target * 1000) - 3;
 	/* for disks set DPOFUA bit and clear write protect (WP) bit */
-	if (sdebug_ptype == TYPE_DISK)
+	if (is_disk)
 		dev_spec = 0x10;	/* =0x90 if WP=1 implies read-only */
 	else
 		dev_spec = 0x0;
@@ -2002,6 +2013,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
 		return check_condition_result;
 	}
+	bad_pcode = false;
+
 	switch (pcode) {
 	case 0x1:	/* Read-Write error recovery page, direct access */
 		len = resp_err_recov_pg(ap, pcontrol, target);
@@ -2012,12 +2025,18 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		offset += len;
 		break;
         case 0x3:       /* Format device page, direct access */
-                len = resp_format_pg(ap, pcontrol, target);
-                offset += len;
+		if (is_disk) {
+			len = resp_format_pg(ap, pcontrol, target);
+			offset += len;
+		} else
+			bad_pcode = true;
                 break;
 	case 0x8:	/* Caching page, direct access */
-		len = resp_caching_pg(ap, pcontrol, target);
-		offset += len;
+		if (is_disk) {
+			len = resp_caching_pg(ap, pcontrol, target);
+			offset += len;
+		} else
+			bad_pcode = true;
 		break;
 	case 0xa:	/* Control Mode page, all devices */
 		len = resp_ctrl_m_pg(ap, pcontrol, target);
@@ -2046,8 +2065,12 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		if ((0 == subpcode) || (0xff == subpcode)) {
 			len = resp_err_recov_pg(ap, pcontrol, target);
 			len += resp_disconnect_pg(ap + len, pcontrol, target);
-			len += resp_format_pg(ap + len, pcontrol, target);
-			len += resp_caching_pg(ap + len, pcontrol, target);
+			if (is_disk) {
+				len += resp_format_pg(ap + len, pcontrol,
+						      target);
+				len += resp_caching_pg(ap + len, pcontrol,
+						       target);
+			}
 			len += resp_ctrl_m_pg(ap + len, pcontrol, target);
 			len += resp_sas_sf_m_pg(ap + len, pcontrol, target);
 			if (0xff == subpcode) {
@@ -2056,13 +2079,17 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 				len += resp_sas_sha_m_spg(ap + len, pcontrol);
 			}
 			len += resp_iec_m_pg(ap + len, pcontrol, target);
+			offset += len;
 		} else {
 			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
 			return check_condition_result;
                 }
-		offset += len;
 		break;
 	default:
+		bad_pcode = true;
+		break;
+	}
+	if (bad_pcode) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 5);
 		return check_condition_result;
 	}
@@ -2753,9 +2780,10 @@ static void unmap_region(sector_t lba, unsigned int len)
 		    lba + sdebug_unmap_granularity <= end &&
 		    index < map_size) {
 			clear_bit(index, map_storep);
-			if (sdebug_lbprz) {
+			if (sdebug_lbprz) {  /* for LBPRZ=2 return 0xff_s */
 				memset(fake_storep +
-				       lba * sdebug_sector_size, 0,
+				       lba * sdebug_sector_size,
+				       (sdebug_lbprz & 1) ? 0 : 0xff,
 				       sdebug_sector_size *
 				       sdebug_unmap_granularity);
 			}
@@ -4098,7 +4126,8 @@ MODULE_PARM_DESC(host_lock, "host_lock is ignored (def=0)");
 MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
-MODULE_PARM_DESC(lbprz, "unmapped blocks return 0 on read (def=1)");
+MODULE_PARM_DESC(lbprz,
+	"on read unmapped LBs return 0 when 1 (def), return 0xff when 2");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
 MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def))");
@@ -4112,7 +4141,7 @@ MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recovered_err...
 MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
-MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=6[SPC-4])");
+MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=7[SPC-5])");
 MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
 MODULE_PARM_DESC(statistics, "collect statistics on commands, queues (def=0)");
 MODULE_PARM_DESC(strict, "stricter checks: reserved field in cdb (def=0)");
@@ -4125,21 +4154,21 @@ MODULE_PARM_DESC(virtual_gb, "virtual gigabyte (GiB) size (def=0 -> use dev_size
 MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
 MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xffff)");
 
-static char sdebug_info[256];
+#define SDEBUG_INFO_LEN 256
+static char sdebug_info[SDEBUG_INFO_LEN];
 
 static const char * scsi_debug_info(struct Scsi_Host * shp)
 {
 	int k;
 
-	k = scnprintf(sdebug_info, sizeof(sdebug_info),
-		      "%s: version %s [%s], dev_size_mb=%d, opts=0x%x\n",
-		      my_name, SDEBUG_VERSION, sdebug_version_date,
-		      sdebug_dev_size_mb, sdebug_opts);
-	if (k >= (sizeof(sdebug_info) - 1))
+	k = scnprintf(sdebug_info, SDEBUG_INFO_LEN, "%s: version %s [%s]\n",
+		      my_name, SDEBUG_VERSION, sdebug_version_date);
+	if (k >= (SDEBUG_INFO_LEN - 1))
 		return sdebug_info;
-	scnprintf(sdebug_info + k, sizeof(sdebug_info) - k,
-		  "%s: submit_queues=%d, statistics=%d\n", my_name,
-		  submit_queues, (int)sdebug_statistics);
+	scnprintf(sdebug_info + k, SDEBUG_INFO_LEN - k,
+		  "  dev_size_mb=%d, opts=0x%x, submit_queues=%d, %s=%d",
+		  sdebug_dev_size_mb, sdebug_opts, submit_queues,
+		  "statistics", (int)sdebug_statistics);
 	return sdebug_info;
 }
 
-- 
2.7.4

