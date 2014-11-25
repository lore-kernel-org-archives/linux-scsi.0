From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 5/5] scsi_debug: Add Report supported opcodes+tmfs; Compare
 and write
Date: Mon, 24 Nov 2014 23:05:40 -0500
Message-ID: <54740014.8060605@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060508030505090808030209"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54399 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbaKYEFz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 23:05:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@ORACLE.COM>

This is a multi-part message in MIME format.
--------------060508030505090808030209
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

From: Douglas Gilbert <dgilbert@interlog.com>
Date: Mon, 24 Nov 2014 21:27:12 -0500
Subject: [PATCH 5/5] Add Report supported opcodes+tmfs; Compare and write

The Report supported operation codes command is very closely integrated
into the table driven parser and very useful for testing it. Its cdb
masks form the basis of the 'strict' parameter's checks. The Report
supported TMFs command is a simple extension. The Compare and write
command may even be useful, as it should be atomic due to the read-write
lock that the driver uses on its backing store (ram).
---
  drivers/scsi/scsi_debug.c | 326 +++++++++++++++++++++++++++++++++++++++++++---
  1 file changed, 307 insertions(+), 19 deletions(-)

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------060508030505090808030209
Content-Type: text/x-patch;
 name="0005-Add-Report-supported-opcodes-tmfs-Compare-and-write.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-Add-Report-supported-opcodes-tmfs-Compare-and-write.pat";
 filename*1="ch"

>From aacd419f11adb4601a45fe17bef4314e0c261610 Mon Sep 17 00:00:00 2001
From: Douglas Gilbert <dgilbert@interlog.com>
Date: Mon, 24 Nov 2014 21:27:12 -0500
Subject: [PATCH 5/5] Add Report supported opcodes+tmfs; Compare and write

The Report supported operation codes command is very closely integrated
into the table driven parser and very useful for testing it. Its cdb
masks form the basis of the 'strict' parameter's checks. The Report
supported TMFs command is a simple extension. The Compare and write
command may even be useful, as it should be atomic due to the read-write
lock that the driver uses on its backing store (ram).
---
 drivers/scsi/scsi_debug.c | 326 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 307 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 58e6040..cc2b382 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -307,7 +307,6 @@ static const unsigned char opcode_ind_arr[256] = {
 #define FF_SA (F_SA_HIGH | F_SA_LOW)
 
 struct sdebug_dev_info;
-static int scsi_debug_queuecommand(struct scsi_cmnd *scp);
 static int resp_inquiry(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_report_luns(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_requests(struct scsi_cmnd *, struct sdebug_dev_info *);
@@ -322,9 +321,12 @@ static int resp_readcap16(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_get_lba_status(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_report_tgtpgs(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_unmap(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_rsup_opcodes(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_rsup_tmfs(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_same_10(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_same_16(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_xdwriteread_10(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_comp_write(struct scsi_cmnd *, struct sdebug_dev_info *);
 
 struct opcode_info_t {
 	u8 num_attached;	/* 0 if this is it (i.e. a leaf); use 0xff
@@ -383,10 +385,10 @@ static const struct opcode_info_t vl_iarr[1] = {	/* VARIABLE LENGTH */
 };
 
 static const struct opcode_info_t maint_in_iarr[2] = {
-	{0, 0xa3, 0xc, F_SA_LOW | F_D_IN, NULL, NULL,
+	{0, 0xa3, 0xc, F_SA_LOW | F_D_IN, resp_rsup_opcodes, NULL,
 	    {12,  0xc, 0x87, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0,
 	     0xc7, 0, 0, 0, 0} },
-	{0, 0xa3, 0xd, F_SA_LOW | F_D_IN, NULL, NULL,
+	{0, 0xa3, 0xd, F_SA_LOW | F_D_IN, resp_rsup_tmfs, NULL,
 	    {12,  0xd, 0x80, 0, 0, 0, 0xff, 0xff, 0xff, 0xff, 0, 0xc7, 0, 0,
 	     0, 0} },
 };
@@ -487,7 +489,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	{0, 0x35, 0, F_DELAY_OVERR | FF_DIRECT_IO, NULL, NULL, /* SYNC_CACHE */
 	    {10,  0x7, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xc7, 0, 0,
 	     0, 0, 0, 0} },
-	{0, 0x89, 0, F_D_OUT | FF_DIRECT_IO, NULL, NULL,
+	{0, 0x89, 0, F_D_OUT | FF_DIRECT_IO, resp_comp_write, NULL,
 	    {16,  0xf8, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0, 0,
 	     0, 0xff, 0x1f, 0xc7} },		/* COMPARE AND WRITE */
 
@@ -1603,6 +1605,184 @@ static int resp_report_tgtpgs(struct scsi_cmnd * scp,
 	return ret;
 }
 
+static int
+resp_rsup_opcodes(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	bool rctd;
+	u8 reporting_opts, req_opcode, sdeb_i, supp;
+	u16 req_sa, u;
+	u32 alloc_len, a_len;
+	int k, offset, len, errsts, count, bump, na;
+	const struct opcode_info_t *oip;
+	const struct opcode_info_t *r_oip;
+	u8 *arr;
+	u8 *cmd = scp->cmnd;
+
+	rctd = !!(cmd[2] & 0x80);
+	reporting_opts = cmd[2] & 0x7;
+	req_opcode = cmd[3];
+	req_sa = get_unaligned_be16(cmd + 4);
+	alloc_len = get_unaligned_be32(cmd + 6);
+	if (alloc_len < 4 && alloc_len > 0xffff) {
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 6, -1);
+		return check_condition_result;
+	}
+	if (alloc_len > 8192)
+		a_len = 8192;
+	else
+		a_len = alloc_len;
+	arr = kzalloc((a_len < 256) ? 320 : a_len + 64, GFP_KERNEL);
+	if (NULL == arr) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
+				INSUFF_RES_ASCQ);
+		return check_condition_result;
+	}
+	switch (reporting_opts) {
+	case 0:	/* all commands */
+		/* count number of commands */
+		for (count = 0, oip = opcode_info_arr;
+		     oip->num_attached != 0xff; ++oip) {
+			if (F_INV_OP & oip->flags)
+				continue;
+			count += (oip->num_attached + 1);
+		}
+		bump = rctd ? 20 : 8;
+		put_unaligned_be32(count * bump, arr);
+		for (offset = 4, oip = opcode_info_arr;
+		     oip->num_attached != 0xff && offset < a_len; ++oip) {
+			if (F_INV_OP & oip->flags)
+				continue;
+			na = oip->num_attached;
+			arr[offset] = oip->opcode;
+			put_unaligned_be16(oip->sa, arr + offset + 2);
+			if (rctd)
+				arr[offset + 5] |= 0x2;
+			if (FF_SA & oip->flags)
+				arr[offset + 5] |= 0x1;
+			put_unaligned_be16(oip->len_mask[0], arr + offset + 6);
+			if (rctd)
+				put_unaligned_be16(0xa, arr + offset + 8);
+			r_oip = oip;
+			for (k = 0, oip = oip->arrp; k < na; ++k, ++oip) {
+				if (F_INV_OP & oip->flags)
+					continue;
+				offset += bump;
+				arr[offset] = oip->opcode;
+				put_unaligned_be16(oip->sa, arr + offset + 2);
+				if (rctd)
+					arr[offset + 5] |= 0x2;
+				if (FF_SA & oip->flags)
+					arr[offset + 5] |= 0x1;
+				put_unaligned_be16(oip->len_mask[0],
+						   arr + offset + 6);
+				if (rctd)
+					put_unaligned_be16(0xa,
+							   arr + offset + 8);
+			}
+			oip = r_oip;
+			offset += bump;
+		}
+		break;
+	case 1:	/* one command: opcode only */
+	case 2:	/* one command: opcode plus service action */
+	case 3:	/* one command: if sa==0 then opcode only else opcode+sa */
+		sdeb_i = opcode_ind_arr[req_opcode];
+		oip = &opcode_info_arr[sdeb_i];
+		if (F_INV_OP & oip->flags) {
+			supp = 1;
+			offset = 4;
+		} else {
+			if (1 == reporting_opts) {
+				if (FF_SA & oip->flags) {
+					mk_sense_invalid_fld(scp, SDEB_IN_CDB,
+							     2, 2);
+					kfree(arr);
+					return check_condition_result;
+				}
+				req_sa = 0;
+			} else if (2 == reporting_opts &&
+				   0 == (FF_SA & oip->flags)) {
+				mk_sense_invalid_fld(scp, SDEB_IN_CDB, 4, -1);
+				kfree(arr);	/* point at requested sa */
+				return check_condition_result;
+			}
+			if (0 == (FF_SA & oip->flags) &&
+			    req_opcode == oip->opcode)
+				supp = 3;
+			else if (0 == (FF_SA & oip->flags)) {
+				na = oip->num_attached;
+				for (k = 0, oip = oip->arrp; k < na;
+				     ++k, ++oip) {
+					if (req_opcode == oip->opcode)
+						break;
+				}
+				supp = (k >= na) ? 1 : 3;
+			} else if (req_sa != oip->sa) {
+				na = oip->num_attached;
+				for (k = 0, oip = oip->arrp; k < na;
+				     ++k, ++oip) {
+					if (req_sa == oip->sa)
+						break;
+				}
+				supp = (k >= na) ? 1 : 3;
+			} else
+				supp = 3;
+			if (3 == supp) {
+				u = oip->len_mask[0];
+				put_unaligned_be16(u, arr + 2);
+				arr[4] = oip->opcode;
+				for (k = 1; k < u; ++k)
+					arr[4 + k] = (k < 16) ?
+						 oip->len_mask[k] : 0xff;
+				offset = 4 + u;
+			} else
+				offset = 4;
+		}
+		arr[1] = (rctd ? 0x80 : 0) | supp;
+		if (rctd) {
+			put_unaligned_be16(0xa, arr + offset);
+			offset += 12;
+		}
+		break;
+	default:
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 2);
+		kfree(arr);
+		return check_condition_result;
+	}
+	offset = (offset < a_len) ? offset : a_len;
+	len = (offset < alloc_len) ? offset : alloc_len;
+	errsts = fill_from_dev_buffer(scp, arr, len);
+	kfree(arr);
+	return errsts;
+}
+
+static int
+resp_rsup_tmfs(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	bool repd;
+	u32 alloc_len, len;
+	u8 arr[16];
+	u8 *cmd = scp->cmnd;
+
+	memset(arr, 0, sizeof(arr));
+	repd = !!(cmd[2] & 0x80);
+	alloc_len = get_unaligned_be32(cmd + 6);
+	if (alloc_len < 4) {
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 6, -1);
+		return check_condition_result;
+	}
+	arr[0] = 0xc8;		/* ATS | ATSS | LURS */
+	arr[1] = 0x1;		/* ITNRS */
+	if (repd) {
+		arr[3] = 0xc;
+		len = 16;
+	} else
+		len = 4;
+
+	len = (len < alloc_len) ? len : alloc_len;
+	return fill_from_dev_buffer(scp, arr, len);
+}
+
 /* <<Following mode page info copied from ST318451LW>> */
 
 static int resp_err_recov_pg(unsigned char * p, int pcontrol, int target)
@@ -2165,6 +2345,38 @@ do_device_access(struct scsi_cmnd *scmd, u64 lba, u32 num, bool do_write)
 	return ret;
 }
 
+/* If fake_store(lba,num) compares equal to arr(num), then copy top half of
+ * arr into fake_store(lba,num) and return true. If comparison fails then
+ * return false. */
+static bool
+comp_write_worker(u64 lba, u32 num, const u8 *arr)
+{
+	bool res;
+	u64 block, rest = 0;
+	u32 store_blks = sdebug_store_sectors;
+	u32 lb_size = scsi_debug_sector_size;
+
+	block = do_div(lba, store_blks);
+	if (block + num > store_blks)
+		rest = block + num - store_blks;
+
+	res = !memcmp(fake_storep + (block * lb_size), arr,
+		      (num - rest) * lb_size);
+	if (!res)
+		return res;
+	if (rest)
+		res = memcmp(fake_storep, arr + ((num - rest) * lb_size),
+			     rest * lb_size);
+	if (!res)
+		return res;
+	arr += num * lb_size;
+	memcpy(fake_storep + (block * lb_size), arr, (num - rest) * lb_size);
+	if (rest)
+		memcpy(fake_storep, arr + ((num - rest) * lb_size),
+		       rest * lb_size);
+	return res;
+}
+
 static __be16 dif_compute_csum(const void *buf, int len)
 {
 	__be16 csum;
@@ -2821,6 +3033,82 @@ resp_write_same_16(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return resp_write_same(scp, lba, num, ei_lba, unmap, ndob);
 }
 
+static int
+resp_comp_write(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	u8 *cmd = scp->cmnd;
+	u8 *arr;
+	u8 *fake_storep_hold;
+	u64 lba;
+	u32 dnum;
+	u32 lb_size = scsi_debug_sector_size;
+	u8 num;
+	unsigned long iflags;
+	int ret;
+
+	lba = get_unaligned_be32(cmd + 2);
+	num = cmd[13];		/* 1 to a maximum of 255 logical blocks */
+	if (0 == num)
+		return 0;	/* degenerate case, not an error */
+	dnum = 2 * num;
+	arr = kzalloc(dnum * lb_size, GFP_ATOMIC);
+	if (NULL == arr) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
+				INSUFF_RES_ASCQ);
+		return check_condition_result;
+	}
+	if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
+	    (cmd[1] & 0xe0)) {
+		mk_sense_invalid_opcode(scp);
+		return check_condition_result;
+	}
+	if ((scsi_debug_dif == SD_DIF_TYPE1_PROTECTION ||
+	     scsi_debug_dif == SD_DIF_TYPE3_PROTECTION) &&
+	    (cmd[1] & 0xe0) == 0)
+		sdev_printk(KERN_ERR, scp->device, "Unprotected WR "
+			    "to DIF device\n");
+
+	/* inline check_device_access_params() */
+	if (lba + num > sdebug_capacity) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
+		return check_condition_result;
+	}
+	/* transfer length excessive (tie in to block limits VPD page) */
+	if (num > sdebug_store_sectors) {
+		/* needs work to find which cdb byte 'num' comes from */
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		return check_condition_result;
+	}
+
+	write_lock_irqsave(&atomic_rw, iflags);
+
+	/* trick do_device_access() to fetch both compare and write buffers
+	 * from data-in into arr. Safe (atomic) since write_lock held. */
+	fake_storep_hold = fake_storep;
+	fake_storep = arr;
+	ret = do_device_access(scp, 0, dnum, true);
+	fake_storep = fake_storep_hold;
+	if (ret == -1) {
+		write_unlock_irqrestore(&atomic_rw, iflags);
+		kfree(arr);
+		return DID_ERROR << 16;
+	} else if ((ret < (dnum * lb_size)) &&
+		 (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
+		sdev_printk(KERN_INFO, scp->device, "%s: compare_write: cdb "
+			    "indicated=%u, IO sent=%d bytes\n", my_name,
+			    dnum * lb_size, ret);
+	if (!comp_write_worker(lba, num, arr)) {
+		write_unlock_irqrestore(&atomic_rw, iflags);
+		kfree(arr);
+		mk_sense_buffer(scp, MISCOMPARE, MISCOMPARE_VERIFY_ASC, 0);
+		return check_condition_result;
+	}
+	if (scsi_debug_lbp())
+		map_region(lba, num);
+	write_unlock_irqrestore(&atomic_rw, iflags);
+	return 0;
+}
+
 struct unmap_block_desc {
 	__be64	lba;
 	__be32	blocks;
@@ -4669,21 +4957,6 @@ static void sdebug_remove_adapter(void)
 }
 
 static int
-sdebug_queuecommand_lock_or_not(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
-{
-	if (scsi_debug_host_lock) {
-		unsigned long iflags;
-		int rc;
-
-		spin_lock_irqsave(shost->host_lock, iflags);
-		rc = scsi_debug_queuecommand(cmd);
-		spin_unlock_irqrestore(shost->host_lock, iflags);
-		return rc;
-	} else
-		return scsi_debug_queuecommand(cmd);
-}
-
-static int
 sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
 {
 	int num_in_q = 0;
@@ -4912,6 +5185,21 @@ check_cond:
 	return schedule_resp(scp, devip, check_condition_result, 0);
 }
 
+static int
+sdebug_queuecommand_lock_or_not(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
+{
+	if (scsi_debug_host_lock) {
+		unsigned long iflags;
+		int rc;
+
+		spin_lock_irqsave(shost->host_lock, iflags);
+		rc = scsi_debug_queuecommand(cmd);
+		spin_unlock_irqrestore(shost->host_lock, iflags);
+		return rc;
+	} else
+		return scsi_debug_queuecommand(cmd);
+}
+
 static struct scsi_host_template sdebug_driver_template = {
 	.show_info =		scsi_debug_show_info,
 	.write_info =		scsi_debug_write_info,
-- 
1.9.1


--------------060508030505090808030209--
