From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 4/4] scsi_debug: add resp_write_scat function
Date: Mon, 11 Dec 2017 20:10:08 -0500
Message-ID: <20171212011008.27689-5-dgilbert@interlog.com>
References: <20171212011008.27689-1-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59807 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750759AbdLLBKN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Dec 2017 20:10:13 -0500
In-Reply-To: <20171212011008.27689-1-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, bart.vanassche@sandisk.com, hare@suse.de

Add resp_write_scat() function to support decoding WRITE SCATTERED
(16 and 32). Also weave resp_write_scat() into the cdb decoding
logic. Split SDEB_I_SERV_ACT_IN into 12 and 16 byte variants
(similarly for SERV_ACT_OUT). As yet the driver doesn't need
either of the 12 byte variants.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 207 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 192 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 707c24155fd0..a0f61e7df4b4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -93,6 +93,7 @@ static const char *sdebug_version_date = "20171202";
 #define MISCOMPARE_VERIFY_ASC 0x1d
 #define MICROCODE_CHANGED_ASCQ 0x1	/* with TARGET_CHANGED_ASC */
 #define MICROCODE_CHANGED_WO_RESET_ASCQ 0x16
+#define WRITE_ERROR_ASC 0xc
 
 /* Additional Sense Code Qualifier (ASCQ) */
 #define ACK_NAK_TO 0x3
@@ -323,12 +324,12 @@ enum sdeb_opcode_index {
 	SDEB_I_READ = 9,		/* 6, 10, 12, 16 */
 	SDEB_I_WRITE = 10,		/* 6, 10, 12, 16 */
 	SDEB_I_START_STOP = 11,
-	SDEB_I_SERV_ACT_IN = 12,	/* 12, 16 */
-	SDEB_I_SERV_ACT_OUT = 13,	/* 12, 16 */
+	SDEB_I_SERV_ACT_IN_16 = 12,	/* add ...SERV_ACT_IN_12 if needed */
+	SDEB_I_SERV_ACT_OUT_16 = 13,	/* add ...SERV_ACT_OUT_12 if needed */
 	SDEB_I_MAINT_IN = 14,
 	SDEB_I_MAINT_OUT = 15,
 	SDEB_I_VERIFY = 16,		/* 10 only */
-	SDEB_I_VARIABLE_LEN = 17,
+	SDEB_I_VARIABLE_LEN = 17,	/* READ(32), WRITE(32), WR_SCAT(32) */
 	SDEB_I_RESERVE = 18,		/* 6, 10 */
 	SDEB_I_RELEASE = 19,		/* 6, 10 */
 	SDEB_I_ALLOW_REMOVAL = 20,	/* PREVENT ALLOW MEDIUM REMOVAL */
@@ -373,12 +374,12 @@ static const unsigned char opcode_ind_arr[256] = {
 	0, 0, 0, 0, 0, SDEB_I_ATA_PT, 0, 0,
 	SDEB_I_READ, SDEB_I_COMP_WRITE, SDEB_I_WRITE, 0, 0, 0, 0, 0,
 	0, 0, 0, SDEB_I_WRITE_SAME, 0, 0, 0, 0,
-	0, 0, 0, 0, 0, 0, SDEB_I_SERV_ACT_IN, SDEB_I_SERV_ACT_OUT,
+	0, 0, 0, 0, 0, 0, SDEB_I_SERV_ACT_IN_16, SDEB_I_SERV_ACT_OUT_16,
 /* 0xa0; 0xa0->0xbf: 12 byte cdbs */
 	SDEB_I_REPORT_LUNS, SDEB_I_ATA_PT, 0, SDEB_I_MAINT_IN,
 	     SDEB_I_MAINT_OUT, 0, 0, 0,
-	SDEB_I_READ, SDEB_I_SERV_ACT_OUT, SDEB_I_WRITE, SDEB_I_SERV_ACT_IN,
-	     0, 0, 0, 0,
+	SDEB_I_READ, 0 /* SDEB_I_SERV_ACT_OUT_12 */, SDEB_I_WRITE,
+	     0 /* SDEB_I_SERV_ACT_IN_12 */, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
 /* 0xc0; 0xc0->0xff: vendor specific */
@@ -397,6 +398,7 @@ static int resp_log_sense(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_readcap(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_read_dt0(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_dt0(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_write_scat(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_start_stop(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_readcap16(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_get_lba_status(struct scsi_cmnd *, struct sdebug_dev_info *);
@@ -448,10 +450,13 @@ static const struct opcode_info_t sa_in_iarr[1] = {
 	     0xff, 0xff, 0xff, 0, 0xc7} },
 };
 
-static const struct opcode_info_t vl_iarr[1] = {	/* VARIABLE LENGTH */
+static const struct opcode_info_t vl_iarr[2] = {	/* VARIABLE LENGTH */
 	{0, 0x7f, 0xb, F_SA_HIGH | F_D_OUT | FF_DIRECT_IO, resp_write_dt0,
-	    NULL, {32,  0xc7, 0, 0, 0, 0, 0x1f, 0x18, 0x0, 0xb, 0xfa,
-		   0, 0xff, 0xff, 0xff, 0xff} },	/* WRITE(32) */
+	    NULL, {32,  0xc7, 0, 0, 0, 0, 0x3f, 0x18, 0x0, 0xb, 0xfa,
+		0, 0xff, 0xff, 0xff, 0xff} },	/* WRITE(32) */
+	{0, 0x7f, 0x11, F_SA_HIGH | F_D_OUT | FF_DIRECT_IO, resp_write_scat,
+	    NULL, {32,  0xc7, 0, 0, 0, 0, 0x3f, 0x18, 0x0, 0x11, 0xf8,
+		0, 0xff, 0xff, 0x0, 0x0} },   /* WRITE SCATTERED(32) */
 };
 
 static const struct opcode_info_t maint_in_iarr[2] = {
@@ -518,9 +523,10 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	    {6,  0x1, 0, 0xf, 0xf7, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{1, 0x9e, 0x10, F_SA_LOW | F_D_IN, resp_readcap16, sa_in_iarr,
 	    {16,  0x10, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
-	     0xff, 0xff, 0xff, 0x1, 0xc7} },	/* READ CAPACITY(16) */
-	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* SA OUT */
-	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	     0xff, 0xff, 0xff, 0x1, 0xc7} },/* SA_IN(16), READ CAPACITY(16) */
+	{0, 0x9f, 0x12, F_SA_LOW | F_D_OUT, resp_write_scat, NULL,
+	    {16,  0x12, 0xf9, 0x0, 0xff, 0xff, 0, 0, 0xff, 0xff, 0xff, 0xff,
+	     0xff, 0xff, 0xff, 0xc7} },  /* SA_OUT(16), WRITE SCATTERED(16) */
 	{2, 0xa3, 0xa, F_SA_LOW | F_D_IN, resp_report_tgtpgs, maint_in_iarr,
 	    {12,  0xea, 0, 0, 0, 0, 0xff, 0xff, 0xff, 0xff, 0, 0xc7, 0, 0, 0,
 	     0} },
@@ -529,9 +535,9 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	{0, 0x2f, 0, F_D_OUT_MAYBE | FF_DIRECT_IO, NULL, NULL, /* VERIFY(10) */
 	    {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc7,
 	     0, 0, 0, 0, 0, 0} },
-	{1, 0x7f, 0x9, F_SA_HIGH | F_D_IN | FF_DIRECT_IO, resp_read_dt0,
-	    vl_iarr, {32,  0xc7, 0, 0, 0, 0, 0x1f, 0x18, 0x0, 0x9, 0xfe, 0,
-		      0xff, 0xff, 0xff, 0xff} },/* VARIABLE LENGTH, READ(32) */
+	{2, 0x7f, 0x9, F_SA_HIGH | F_D_IN | FF_DIRECT_IO, resp_read_dt0,
+	    vl_iarr, {32,  0xc7, 0, 0, 0, 0, 0x3f, 0x18, 0x0, 0x9, 0xfe, 0,
+		0xff, 0xff, 0xff, 0xff} },    /* VARIABLE LENGTH, READ(32) */
 	{1, 0x56, 0, F_D_OUT, NULL, reserve_iarr, /* RESERVE(10) */
 	    {10,  0xff, 0xff, 0xff, 0, 0, 0, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0,
 	     0} },
@@ -3030,6 +3036,177 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return 0;
 }
 
+/*
+ * T10 has only specified WRITE SCATTERED(16) and WRITE SCATTERED(32).
+ * No READ GATHERED yet (requires bidi or long cdb holding gather list).
+ */
+static int resp_write_scat(struct scsi_cmnd *scp,
+			   struct sdebug_dev_info *devip)
+{
+	u8 *cmd = scp->cmnd;
+	u8 *lrdp = NULL;
+	u8 *up;
+	u8 wrprotect;
+	u16 lbdof, num_lrd, k;
+	u32 num, num_by, bt_len, lbdof_blen, sg_off, cum_lb;
+	u32 lb_size = sdebug_sector_size;
+	u32 ei_lba;
+	u64 lba;
+	unsigned long iflags;
+	int ret, res;
+	bool check_prot, is_16;
+	static const u32 lrd_size = 32; /* + parameter list header size */
+
+	if (cmd[0] == VARIABLE_LENGTH_CMD) {
+		is_16 = false;
+		wrprotect = (cmd[10] >> 5) & 0x7;
+		lbdof = get_unaligned_be16(cmd + 12);
+		num_lrd = get_unaligned_be16(cmd + 16);
+		bt_len = get_unaligned_be32(cmd + 28);
+		check_prot = false;
+	} else {        /* that leaves WRITE SCATTERED(16) */
+		is_16 = true;
+		wrprotect = (cmd[2] >> 5) & 0x7;
+		lbdof = get_unaligned_be16(cmd + 4);
+		num_lrd = get_unaligned_be16(cmd + 8);
+		bt_len = get_unaligned_be32(cmd + 10);
+		check_prot = true;
+	}
+	if (unlikely(have_dif_prot && check_prot)) {
+		if (sdebug_dif == T10_PI_TYPE2_PROTECTION && wrprotect) {
+			mk_sense_invalid_opcode(scp);
+			return illegal_condition_result;
+		}
+		if ((sdebug_dif == T10_PI_TYPE1_PROTECTION ||
+		     sdebug_dif == T10_PI_TYPE3_PROTECTION) &&
+		     wrprotect == 0)
+			sdev_printk(KERN_ERR, scp->device,
+				    "Unprotected WR to DIF device\n");
+	}
+	if ((num_lrd == 0) || (bt_len == 0))
+		return 0;       /* T10 says these do-nothings are not errors */
+	if ((lbdof == 0) || (lbdof >= bt_len)) {
+		if (sdebug_verbose)
+			sdev_printk(KERN_INFO, scp->device,
+				"%s: %s: LB Data Offset field bad\n",
+				my_name, __func__);
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		return illegal_condition_result;
+	}
+	lbdof_blen = lbdof * lb_size;
+	if ((lrd_size + (num_lrd * lrd_size)) > lbdof_blen) {
+		if (sdebug_verbose)
+			sdev_printk(KERN_INFO, scp->device,
+				"%s: %s: LBA range descriptors don't fit\n",
+				my_name, __func__);
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		return illegal_condition_result;
+	}
+	lrdp = kzalloc(lbdof_blen, GFP_ATOMIC);
+	if (lrdp == NULL) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
+				INSUFF_RES_ASCQ);
+		return illegal_condition_result;
+	}
+	if (sdebug_verbose)
+		sdev_printk(KERN_INFO, scp->device,
+			"%s: %s: Fetch header+scatter_list, lbdof_blen=%u\n",
+			my_name, __func__, lbdof_blen);
+	res = fetch_to_dev_buffer(scp, lrdp, lbdof_blen);
+	if (res == -1) {
+		ret = DID_ERROR << 16;
+		goto err_out;
+	}
+
+	write_lock_irqsave(&atomic_rw, iflags);
+	sg_off = lbdof_blen;
+	/* Spec says Buffer xfer Length field in number of LBs in dout */
+	cum_lb = 0;
+	for (k = 0, up = lrdp + lrd_size; k < num_lrd; ++k, up += lrd_size) {
+		lba = get_unaligned_be64(up + 0);
+		num = get_unaligned_be32(up + 8);
+		if (sdebug_verbose)
+			sdev_printk(KERN_INFO, scp->device,
+				"%s: %s: k=%d  LBA=0x%llx num=%u  sg_off=%u\n",
+				my_name, __func__, k, lba, num, sg_off);
+		if (num == 0)
+			continue;
+		ret = check_device_access_params(scp, lba, num);
+		if (ret)
+			goto err_out_unlock;
+		num_by = num * lb_size;
+		ei_lba = is_16 ? 0 : get_unaligned_be32(up + 12);
+
+		if ((cum_lb + num) > bt_len) {
+			if (sdebug_verbose)
+				sdev_printk(KERN_INFO, scp->device,
+				    "%s: %s: sum of blocks > data provided\n",
+				    my_name, __func__);
+			mk_sense_buffer(scp, ILLEGAL_REQUEST, WRITE_ERROR_ASC,
+					0);
+			ret = illegal_condition_result;
+			goto err_out_unlock;
+		}
+
+		/* DIX + T10 DIF */
+		if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
+			int prot_ret = prot_verify_write(scp, lba, num,
+							 ei_lba);
+
+			if (prot_ret) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10,
+						prot_ret);
+				ret = illegal_condition_result;
+				goto err_out_unlock;
+			}
+		}
+
+		ret = do_device_access(scp, sg_off, lba, num, true);
+		if (unlikely(scsi_debug_lbp()))
+			map_region(lba, num);
+		if (unlikely(-1 == ret)) {
+			ret = DID_ERROR << 16;
+			goto err_out_unlock;
+		} else if (unlikely(sdebug_verbose && (ret < num_by)))
+			sdev_printk(KERN_INFO, scp->device,
+			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
+			    my_name, num_by, ret);
+
+		if (unlikely(sdebug_any_injecting_opt)) {
+			struct sdebug_queued_cmd *sqcp =
+				(struct sdebug_queued_cmd *)scp->host_scribble;
+
+			if (sqcp) {
+				if (sqcp->inj_recovered) {
+					mk_sense_buffer(scp, RECOVERED_ERROR,
+							THRESHOLD_EXCEEDED, 0);
+					ret = illegal_condition_result;
+					goto err_out_unlock;
+				} else if (sqcp->inj_dif) {
+					/* Logical block guard check failed */
+					mk_sense_buffer(scp, ABORTED_COMMAND,
+							0x10, 1);
+					ret = illegal_condition_result;
+					goto err_out_unlock;
+				} else if (sqcp->inj_dix) {
+					mk_sense_buffer(scp, ILLEGAL_REQUEST,
+							0x10, 1);
+					ret = illegal_condition_result;
+					goto err_out_unlock;
+				}
+			}
+		}
+		sg_off += num_by;
+		cum_lb += num;
+	}
+	ret = 0;
+err_out_unlock:
+	write_unlock_irqrestore(&atomic_rw, iflags);
+err_out:
+	kfree(lrdp);
+	return ret;
+}
+
 static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 			   u32 ei_lba, bool unmap, bool ndob)
 {
-- 
2.14.1
