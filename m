Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E817C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 04:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbiDHEI4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 00:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbiDHEIk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 00:08:40 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E6D12C9CB
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 21:06:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 684342041CE;
        Fri,  8 Apr 2022 05:57:07 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SWOpHUBdghAp; Fri,  8 Apr 2022 05:57:03 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 04CD92041CF;
        Fri,  8 Apr 2022 05:56:59 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@lst.de
Subject: [PATCH 5/6] scsi_debug: reinstate cmd_len > 32
Date:   Thu,  7 Apr 2022 23:56:50 -0400
Message-Id: <20220408035651.6472-6-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408035651.6472-1-dgilbert@interlog.com>
References: <20220408035651.6472-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Example of converting a SCSI low level driver (LLD) to handle
cmd_len > 32 bytes.

When (opts & 1) print out all cdb_s up to 64 bytes in length
(was up to 32 bytes). For testing using sg_raw in user space
via a sg device to send long cdb_s (i.e. > 32 bytes).

Use 'cdb' when referring to a SCSI CDB as 'cmd' gets confused
with other things such as a pointer to a scsi_cmnd object.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 410 ++++++++++++++++++++------------------
 1 file changed, 213 insertions(+), 197 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c607755cce00..d61d039836a0 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -246,7 +246,7 @@ static const char *sdebug_version_date = "20210520";
 
 #define SDEBUG_MAX_PARTS 4
 
-#define SDEBUG_MAX_CMD_LEN 32
+#define SDEBUG_MAX_CMD_LEN 64
 
 #define SDEB_XA_NOT_IN_USE XA_MARK_1
 
@@ -1573,12 +1573,12 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	unsigned char pq_pdt;
 	unsigned char *arr;
-	unsigned char *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	u32 alloc_len, n;
 	int ret;
 	bool have_wlun, is_disk, is_zbc, is_disk_zbc;
 
-	alloc_len = get_unaligned_be16(cmd + 3);
+	alloc_len = get_unaligned_be16(cdb + 3);
 	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
 	if (! arr)
 		return DID_REQUEUE << 16;
@@ -1593,11 +1593,11 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	else
 		pq_pdt = (sdebug_ptype & 0x1f);
 	arr[0] = pq_pdt;
-	if (0x2 & cmd[1]) {  /* CMDDT bit set */
+	if (0x2 & cdb[1]) {  /* CMDDT bit set */
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 1);
 		kfree(arr);
 		return check_condition_result;
-	} else if (0x1 & cmd[1]) {  /* EVPD bit set */
+	} else if (0x1 & cdb[1]) {  /* EVPD bit set */
 		int lu_id_num, port_group_id, target_dev_id;
 		u32 len;
 		char lu_id_str[6];
@@ -1612,8 +1612,8 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		target_dev_id = ((host_no + 1) * 2000) +
 				 (devip->target * 1000) - 3;
 		len = scnprintf(lu_id_str, 6, "%d", lu_id_num);
-		if (0 == cmd[2]) { /* supported vital product data pages */
-			arr[1] = cmd[2];	/*sanity */
+		if (0 == cdb[2]) { /* supported vital product data pages */
+			arr[1] = cdb[2];	/*sanity */
 			n = 4;
 			arr[n++] = 0x0;   /* this page */
 			arr[n++] = 0x80;  /* unit serial number */
@@ -1633,24 +1633,24 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 					arr[n++] = 0xb6;  /* ZB dev. char. */
 			}
 			arr[3] = n - 4;	  /* number of supported VPD pages */
-		} else if (0x80 == cmd[2]) { /* unit serial number */
-			arr[1] = cmd[2];	/*sanity */
+		} else if (0x80 == cdb[2]) { /* unit serial number */
+			arr[1] = cdb[2];	/*sanity */
 			arr[3] = len;
 			memcpy(&arr[4], lu_id_str, len);
-		} else if (0x83 == cmd[2]) { /* device identification */
-			arr[1] = cmd[2];	/*sanity */
+		} else if (0x83 == cdb[2]) { /* device identification */
+			arr[1] = cdb[2];	/*sanity */
 			arr[3] = inquiry_vpd_83(&arr[4], port_group_id,
 						target_dev_id, lu_id_num,
 						lu_id_str, len,
 						&devip->lu_name);
-		} else if (0x84 == cmd[2]) { /* Software interface ident. */
-			arr[1] = cmd[2];	/*sanity */
+		} else if (0x84 == cdb[2]) { /* Software interface ident. */
+			arr[1] = cdb[2];	/*sanity */
 			arr[3] = inquiry_vpd_84(&arr[4]);
-		} else if (0x85 == cmd[2]) { /* Management network addresses */
-			arr[1] = cmd[2];	/*sanity */
+		} else if (0x85 == cdb[2]) { /* Management network addresses */
+			arr[1] = cdb[2];	/*sanity */
 			arr[3] = inquiry_vpd_85(&arr[4]);
-		} else if (0x86 == cmd[2]) { /* extended inquiry */
-			arr[1] = cmd[2];	/*sanity */
+		} else if (0x86 == cdb[2]) { /* extended inquiry */
+			arr[1] = cdb[2];	/*sanity */
 			arr[3] = 0x3c;	/* number of following entries */
 			if (sdebug_dif == T10_PI_TYPE3_PROTECTION)
 				arr[4] = 0x4;	/* SPT: GRD_CHK:1 */
@@ -1659,31 +1659,31 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			else
 				arr[4] = 0x0;   /* no protection stuff */
 			arr[5] = 0x7;   /* head of q, ordered + simple q's */
-		} else if (0x87 == cmd[2]) { /* mode page policy */
-			arr[1] = cmd[2];	/*sanity */
+		} else if (0x87 == cdb[2]) { /* mode page policy */
+			arr[1] = cdb[2];	/*sanity */
 			arr[3] = 0x8;	/* number of following entries */
 			arr[4] = 0x2;	/* disconnect-reconnect mp */
 			arr[6] = 0x80;	/* mlus, shared */
 			arr[8] = 0x18;	 /* protocol specific lu */
 			arr[10] = 0x82;	 /* mlus, per initiator port */
-		} else if (0x88 == cmd[2]) { /* SCSI Ports */
-			arr[1] = cmd[2];	/*sanity */
+		} else if (0x88 == cdb[2]) { /* SCSI Ports */
+			arr[1] = cdb[2];	/*sanity */
 			arr[3] = inquiry_vpd_88(&arr[4], target_dev_id);
-		} else if (is_disk_zbc && 0x89 == cmd[2]) { /* ATA info */
-			arr[1] = cmd[2];        /*sanity */
+		} else if (is_disk_zbc && 0x89 == cdb[2]) { /* ATA info */
+			arr[1] = cdb[2];        /*sanity */
 			n = inquiry_vpd_89(&arr[4]);
 			put_unaligned_be16(n, arr + 2);
-		} else if (is_disk_zbc && 0xb0 == cmd[2]) { /* Block limits */
-			arr[1] = cmd[2];        /*sanity */
+		} else if (is_disk_zbc && 0xb0 == cdb[2]) { /* Block limits */
+			arr[1] = cdb[2];        /*sanity */
 			arr[3] = inquiry_vpd_b0(&arr[4]);
-		} else if (is_disk_zbc && 0xb1 == cmd[2]) { /* Block char. */
-			arr[1] = cmd[2];        /*sanity */
+		} else if (is_disk_zbc && 0xb1 == cdb[2]) { /* Block char. */
+			arr[1] = cdb[2];        /*sanity */
 			arr[3] = inquiry_vpd_b1(devip, &arr[4]);
-		} else if (is_disk && 0xb2 == cmd[2]) { /* LB Prov. */
-			arr[1] = cmd[2];        /*sanity */
+		} else if (is_disk && 0xb2 == cdb[2]) { /* LB Prov. */
+			arr[1] = cdb[2];        /*sanity */
 			arr[3] = inquiry_vpd_b2(&arr[4]);
-		} else if (is_zbc && cmd[2] == 0xb6) { /* ZB dev. charact. */
-			arr[1] = cmd[2];        /*sanity */
+		} else if (is_zbc && cdb[2] == 0xb6) { /* ZB dev. charact. */
+			arr[1] = cdb[2];        /*sanity */
 			arr[3] = inquiry_vpd_b6(devip, &arr[4]);
 		} else {
 			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
@@ -1740,10 +1740,10 @@ static unsigned char iec_m_pg[] = {0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
 static int resp_requests(struct scsi_cmnd *scp,
 			 struct sdebug_dev_info *devip)
 {
-	unsigned char *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	unsigned char arr[SCSI_SENSE_BUFFERSIZE];	/* assume >= 18 bytes */
-	bool dsense = !!(cmd[1] & 1);
-	u32 alloc_len = cmd[4];
+	bool dsense = !!(cdb[1] & 1);
+	u32 alloc_len = cdb[4];
 	u32 len = 18;
 	int stopped_state = atomic_read(&devip->stopped);
 
@@ -1793,16 +1793,16 @@ static int resp_requests(struct scsi_cmnd *scp,
 
 static int resp_start_stop(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
-	unsigned char *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	int power_cond, want_stop, stopped_state;
 	bool changing;
 
-	power_cond = (cmd[4] & 0xf0) >> 4;
+	power_cond = (cdb[4] & 0xf0) >> 4;
 	if (power_cond) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 4, 7);
 		return check_condition_result;
 	}
-	want_stop = !(cmd[4] & 1);
+	want_stop = !(cdb[4] & 1);
 	stopped_state = atomic_read(&devip->stopped);
 	if (stopped_state == 2) {
 		ktime_t now_ts = ktime_get_boottime();
@@ -1828,7 +1828,7 @@ static int resp_start_stop(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	changing = (stopped_state != want_stop);
 	if (changing)
 		atomic_xchg(&devip->stopped, want_stop);
-	if (!changing || (cmd[1] & 0x1))  /* state unchanged or IMMED bit set in cdb */
+	if (!changing || (cdb[1] & 0x1))  /* state unchanged or IMMED bit set in cdb */
 		return SDEG_RES_IMMED_MASK;
 	else
 		return 0;
@@ -1868,11 +1868,11 @@ static int resp_readcap(struct scsi_cmnd *scp,
 static int resp_readcap16(struct scsi_cmnd *scp,
 			  struct sdebug_dev_info *devip)
 {
-	unsigned char *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	unsigned char arr[SDEBUG_READCAP16_ARR_SZ];
 	u32 alloc_len;
 
-	alloc_len = get_unaligned_be32(cmd + 10);
+	alloc_len = get_unaligned_be32(cdb + 10);
 	/* following just in case virtual_gb changed */
 	sdebug_capacity = get_sdebug_capacity();
 	memset(arr, 0, SDEBUG_READCAP16_ARR_SZ);
@@ -1907,14 +1907,14 @@ static int resp_readcap16(struct scsi_cmnd *scp,
 static int resp_report_tgtpgs(struct scsi_cmnd *scp,
 			      struct sdebug_dev_info *devip)
 {
-	unsigned char *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	unsigned char *arr;
 	int host_no = devip->sdbg_host->shost->host_no;
 	int port_group_a, port_group_b, port_a, port_b;
 	u32 alen, n, rlen;
 	int ret;
 
-	alen = get_unaligned_be32(cmd + 6);
+	alen = get_unaligned_be32(cdb + 6);
 	arr = kzalloc(SDEBUG_MAX_TGTPGS_ARR_SZ, GFP_ATOMIC);
 	if (! arr)
 		return DID_REQUEUE << 16;
@@ -1992,13 +1992,13 @@ static int resp_rsup_opcodes(struct scsi_cmnd *scp,
 	const struct opcode_info_t *oip;
 	const struct opcode_info_t *r_oip;
 	u8 *arr;
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 
-	rctd = !!(cmd[2] & 0x80);
-	reporting_opts = cmd[2] & 0x7;
-	req_opcode = cmd[3];
-	req_sa = get_unaligned_be16(cmd + 4);
-	alloc_len = get_unaligned_be32(cmd + 6);
+	rctd = !!(cdb[2] & 0x80);
+	reporting_opts = cdb[2] & 0x7;
+	req_opcode = cdb[3];
+	req_sa = get_unaligned_be16(cdb + 4);
+	alloc_len = get_unaligned_be32(cdb + 6);
 	if (alloc_len < 4 || alloc_len > 0xffff) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 6, -1);
 		return check_condition_result;
@@ -2138,11 +2138,11 @@ static int resp_rsup_tmfs(struct scsi_cmnd *scp,
 	bool repd;
 	u32 alloc_len, len;
 	u8 arr[16];
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 
 	memset(arr, 0, sizeof(arr));
-	repd = !!(cmd[2] & 0x80);
-	alloc_len = get_unaligned_be32(cmd + 6);
+	repd = !!(cdb[2] & 0x80);
+	alloc_len = get_unaligned_be32(cdb + 6);
 	if (alloc_len < 4) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 6, -1);
 		return check_condition_result;
@@ -2331,22 +2331,22 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	int target = scp->device->id;
 	unsigned char *ap;
 	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
-	unsigned char *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	bool dbd, llbaa, msense_6, is_disk, is_zbc, bad_pcode;
 
-	dbd = !!(cmd[1] & 0x8);		/* disable block descriptors */
-	pcontrol = (cmd[2] & 0xc0) >> 6;
-	pcode = cmd[2] & 0x3f;
-	subpcode = cmd[3];
-	msense_6 = (MODE_SENSE == cmd[0]);
-	llbaa = msense_6 ? false : !!(cmd[1] & 0x10);
+	dbd = !!(cdb[1] & 0x8);		/* disable block descriptors */
+	pcontrol = (cdb[2] & 0xc0) >> 6;
+	pcode = cdb[2] & 0x3f;
+	subpcode = cdb[3];
+	msense_6 = (MODE_SENSE == cdb[0]);
+	llbaa = msense_6 ? false : !!(cdb[1] & 0x10);
 	is_disk = (sdebug_ptype == TYPE_DISK);
 	is_zbc = (devip->zmodel != BLK_ZONED_NONE);
 	if ((is_disk || is_zbc) && !dbd)
 		bd_len = llbaa ? 16 : 8;
 	else
 		bd_len = 0;
-	alloc_len = msense_6 ? cmd[4] : get_unaligned_be16(cmd + 7);
+	alloc_len = msense_6 ? cdb[4] : get_unaligned_be16(cdb + 7);
 	memset(arr, 0, SDEBUG_MAX_MSENSE_SZ);
 	if (0x3 == pcontrol) {  /* Saving values not supported */
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, SAVING_PARAMS_UNSUP, 0);
@@ -2494,13 +2494,13 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 	int pf, sp, ps, md_len, bd_len, off, spf, pg_len;
 	int param_len, res, mpage;
 	unsigned char arr[SDEBUG_MAX_MSELECT_SZ];
-	unsigned char *cmd = scp->cmnd;
-	int mselect6 = (MODE_SELECT == cmd[0]);
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
+	int mselect6 = (MODE_SELECT == cdb[0]);
 
 	memset(arr, 0, sizeof(arr));
-	pf = cmd[1] & 0x10;
-	sp = cmd[1] & 0x1;
-	param_len = mselect6 ? cmd[4] : get_unaligned_be16(cmd + 7);
+	pf = cdb[1] & 0x10;
+	sp = cdb[1] & 0x1;
+	param_len = mselect6 ? cdb[4] : get_unaligned_be16(cdb + 7);
 	if ((0 == pf) || sp || (param_len > SDEBUG_MAX_MSELECT_SZ)) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, mselect6 ? 4 : 7, -1);
 		return check_condition_result;
@@ -2613,18 +2613,18 @@ static int resp_log_sense(struct scsi_cmnd *scp,
 	int ppc, sp, pcode, subpcode;
 	u32 alloc_len, len, n;
 	unsigned char arr[SDEBUG_MAX_LSENSE_SZ];
-	unsigned char *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 
 	memset(arr, 0, sizeof(arr));
-	ppc = cmd[1] & 0x2;
-	sp = cmd[1] & 0x1;
+	ppc = cdb[1] & 0x2;
+	sp = cdb[1] & 0x1;
 	if (ppc || sp) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, ppc ? 1 : 0);
 		return check_condition_result;
 	}
-	pcode = cmd[2] & 0x3f;
-	subpcode = cmd[3] & 0xff;
-	alloc_len = get_unaligned_be16(cmd + 7);
+	pcode = cdb[2] & 0x3f;
+	subpcode = cdb[3] & 0xff;
+	alloc_len = get_unaligned_be16(cdb + 7);
 	arr[0] = pcode;
 	if (0 == subpcode) {
 		switch (pcode) {
@@ -3132,6 +3132,7 @@ static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
 	struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
 						scp->device->hostdata, true);
 	struct t10_pi_tuple *sdt;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 
 	for (i = 0; i < sectors; i++, ei_lba++) {
 		sector = start_sec + i;
@@ -3147,7 +3148,7 @@ static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
 		 * which type of error to return. Otherwise we would
 		 * have to iterate over the PI twice.
 		 */
-		if (scp->cmnd[1] >> 5) { /* RDPROTECT */
+		if (cdb[1] >> 5) { /* RDPROTECT */
 			ret = dif_verify(sdt, lba2fake_store(sip, sector),
 					 sector, ei_lba);
 			if (ret) {
@@ -3235,56 +3236,56 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	int ret;
 	u64 lba;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 
-	switch (cmd[0]) {
+	switch (cdb[0]) {
 	case READ_16:
 		ei_lba = 0;
-		lba = get_unaligned_be64(cmd + 2);
-		num = get_unaligned_be32(cmd + 10);
+		lba = get_unaligned_be64(cdb + 2);
+		num = get_unaligned_be32(cdb + 10);
 		check_prot = true;
 		break;
 	case READ_10:
 		ei_lba = 0;
-		lba = get_unaligned_be32(cmd + 2);
-		num = get_unaligned_be16(cmd + 7);
+		lba = get_unaligned_be32(cdb + 2);
+		num = get_unaligned_be16(cdb + 7);
 		check_prot = true;
 		break;
 	case READ_6:
 		ei_lba = 0;
-		lba = (u32)cmd[3] | (u32)cmd[2] << 8 |
-		      (u32)(cmd[1] & 0x1f) << 16;
-		num = (0 == cmd[4]) ? 256 : cmd[4];
+		lba = (u32)cdb[3] | (u32)cdb[2] << 8 |
+		      (u32)(cdb[1] & 0x1f) << 16;
+		num = (0 == cdb[4]) ? 256 : cdb[4];
 		check_prot = true;
 		break;
 	case READ_12:
 		ei_lba = 0;
-		lba = get_unaligned_be32(cmd + 2);
-		num = get_unaligned_be32(cmd + 6);
+		lba = get_unaligned_be32(cdb + 2);
+		num = get_unaligned_be32(cdb + 6);
 		check_prot = true;
 		break;
 	case XDWRITEREAD_10:
 		ei_lba = 0;
-		lba = get_unaligned_be32(cmd + 2);
-		num = get_unaligned_be16(cmd + 7);
+		lba = get_unaligned_be32(cdb + 2);
+		num = get_unaligned_be16(cdb + 7);
 		check_prot = false;
 		break;
 	default:	/* assume READ(32) */
-		lba = get_unaligned_be64(cmd + 12);
-		ei_lba = get_unaligned_be32(cmd + 20);
-		num = get_unaligned_be32(cmd + 28);
+		lba = get_unaligned_be64(cdb + 12);
+		ei_lba = get_unaligned_be32(cdb + 20);
+		num = get_unaligned_be32(cdb + 28);
 		check_prot = false;
 		break;
 	}
 	if (unlikely(have_dif_prot && check_prot)) {
 		if (sdebug_dif == T10_PI_TYPE2_PROTECTION &&
-		    (cmd[1] & 0xe0)) {
+		    (cdb[1] & 0xe0)) {
 			mk_sense_invalid_opcode(scp);
 			return check_condition_result;
 		}
 		if ((sdebug_dif == T10_PI_TYPE1_PROTECTION ||
 		     sdebug_dif == T10_PI_TYPE3_PROTECTION) &&
-		    (cmd[1] & 0xe0) == 0)
+		    (cdb[1] & 0xe0) == 0)
 			sdev_printk(KERN_ERR, scp->device, "Unprotected RD "
 				    "to DIF device\n");
 	}
@@ -3319,7 +3320,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		switch (prot_verify_read(scp, lba, num, ei_lba)) {
 		case 1: /* Guard tag error */
-			if (cmd[1] >> 5 != 3) { /* RDPROTECT != 3 */
+			if (cdb[1] >> 5 != 3) { /* RDPROTECT != 3 */
 				sdeb_read_unlock(sip);
 				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
 				return check_condition_result;
@@ -3330,7 +3331,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			}
 			break;
 		case 3: /* Reference tag error */
-			if (cmd[1] >> 5 != 3) { /* RDPROTECT != 3 */
+			if (cdb[1] >> 5 != 3) { /* RDPROTECT != 3 */
 				sdeb_read_unlock(sip);
 				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 3);
 				return check_condition_result;
@@ -3376,6 +3377,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 	int ret;
 	struct t10_pi_tuple *sdt;
 	void *daddr;
+	const u8 *cdb = scsi_cmnd_get_cdb(SCpnt);
 	sector_t sector = start_sec;
 	int ppage_offset;
 	int dpage_offset;
@@ -3415,7 +3417,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			sdt = piter.addr + ppage_offset;
 			daddr = diter.addr + dpage_offset;
 
-			if (SCpnt->cmnd[1] >> 5 != 3) { /* WRPROTECT */
+			if (cdb[1] >> 5 != 3) { /* WRPROTECT */
 				ret = dif_verify(sdt, daddr, sector, ei_lba);
 				if (ret)
 					goto out;
@@ -3532,56 +3534,56 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	int ret;
 	u64 lba;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 
-	switch (cmd[0]) {
+	switch (cdb[0]) {
 	case WRITE_16:
 		ei_lba = 0;
-		lba = get_unaligned_be64(cmd + 2);
-		num = get_unaligned_be32(cmd + 10);
+		lba = get_unaligned_be64(cdb + 2);
+		num = get_unaligned_be32(cdb + 10);
 		check_prot = true;
 		break;
 	case WRITE_10:
 		ei_lba = 0;
-		lba = get_unaligned_be32(cmd + 2);
-		num = get_unaligned_be16(cmd + 7);
+		lba = get_unaligned_be32(cdb + 2);
+		num = get_unaligned_be16(cdb + 7);
 		check_prot = true;
 		break;
 	case WRITE_6:
 		ei_lba = 0;
-		lba = (u32)cmd[3] | (u32)cmd[2] << 8 |
-		      (u32)(cmd[1] & 0x1f) << 16;
-		num = (0 == cmd[4]) ? 256 : cmd[4];
+		lba = (u32)cdb[3] | (u32)cdb[2] << 8 |
+		      (u32)(cdb[1] & 0x1f) << 16;
+		num = (0 == cdb[4]) ? 256 : cdb[4];
 		check_prot = true;
 		break;
 	case WRITE_12:
 		ei_lba = 0;
-		lba = get_unaligned_be32(cmd + 2);
-		num = get_unaligned_be32(cmd + 6);
+		lba = get_unaligned_be32(cdb + 2);
+		num = get_unaligned_be32(cdb + 6);
 		check_prot = true;
 		break;
 	case 0x53:	/* XDWRITEREAD(10) */
 		ei_lba = 0;
-		lba = get_unaligned_be32(cmd + 2);
-		num = get_unaligned_be16(cmd + 7);
+		lba = get_unaligned_be32(cdb + 2);
+		num = get_unaligned_be16(cdb + 7);
 		check_prot = false;
 		break;
 	default:	/* assume WRITE(32) */
-		lba = get_unaligned_be64(cmd + 12);
-		ei_lba = get_unaligned_be32(cmd + 20);
-		num = get_unaligned_be32(cmd + 28);
+		lba = get_unaligned_be64(cdb + 12);
+		ei_lba = get_unaligned_be32(cdb + 20);
+		num = get_unaligned_be32(cdb + 28);
 		check_prot = false;
 		break;
 	}
 	if (unlikely(have_dif_prot && check_prot)) {
 		if (sdebug_dif == T10_PI_TYPE2_PROTECTION &&
-		    (cmd[1] & 0xe0)) {
+		    (cdb[1] & 0xe0)) {
 			mk_sense_invalid_opcode(scp);
 			return check_condition_result;
 		}
 		if ((sdebug_dif == T10_PI_TYPE1_PROTECTION ||
 		     sdebug_dif == T10_PI_TYPE3_PROTECTION) &&
-		    (cmd[1] & 0xe0) == 0)
+		    (cdb[1] & 0xe0) == 0)
 			sdev_printk(KERN_ERR, scp->device, "Unprotected WR "
 				    "to DIF device\n");
 	}
@@ -3601,7 +3603,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 				sdeb_write_unlock(sip);
 				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
 				return illegal_condition_result;
-			} else if (scp->cmnd[1] >> 5 != 3) { /* WRPROTECT != 3 */
+			} else if (cdb[1] >> 5 != 3) { /* WRPROTECT != 3 */
 				sdeb_write_unlock(sip);
 				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
 				return check_condition_result;
@@ -3612,7 +3614,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 				sdeb_write_unlock(sip);
 				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 3);
 				return illegal_condition_result;
-			} else if (scp->cmnd[1] >> 5 != 3) { /* WRPROTECT != 3 */
+			} else if (cdb[1] >> 5 != 3) { /* WRPROTECT != 3 */
 				sdeb_write_unlock(sip);
 				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 3);
 				return check_condition_result;
@@ -3663,7 +3665,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 static int resp_write_scat(struct scsi_cmnd *scp,
 			   struct sdebug_dev_info *devip)
 {
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	u8 *lrdp = NULL;
 	u8 *up;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
@@ -3677,18 +3679,18 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	bool is_16;
 	static const u32 lrd_size = 32; /* + parameter list header size */
 
-	if (cmd[0] == VARIABLE_LENGTH_CMD) {
+	if (cdb[0] == VARIABLE_LENGTH_CMD) {
 		is_16 = false;
-		wrprotect = (cmd[10] >> 5) & 0x7;
-		lbdof = get_unaligned_be16(cmd + 12);
-		num_lrd = get_unaligned_be16(cmd + 16);
-		bt_len = get_unaligned_be32(cmd + 28);
+		wrprotect = (cdb[10] >> 5) & 0x7;
+		lbdof = get_unaligned_be16(cdb + 12);
+		num_lrd = get_unaligned_be16(cdb + 16);
+		bt_len = get_unaligned_be32(cdb + 28);
 	} else {        /* that leaves WRITE SCATTERED(16) */
 		is_16 = true;
-		wrprotect = (cmd[2] >> 5) & 0x7;
-		lbdof = get_unaligned_be16(cmd + 4);
-		num_lrd = get_unaligned_be16(cmd + 8);
-		bt_len = get_unaligned_be32(cmd + 10);
+		wrprotect = (cdb[2] >> 5) & 0x7;
+		lbdof = get_unaligned_be16(cdb + 4);
+		num_lrd = get_unaligned_be16(cdb + 8);
+		bt_len = get_unaligned_be32(cdb + 10);
 		if (unlikely(have_dif_prot)) {
 			if (sdebug_dif == T10_PI_TYPE2_PROTECTION &&
 			    wrprotect) {
@@ -3887,21 +3889,21 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 static int resp_write_same_10(struct scsi_cmnd *scp,
 			      struct sdebug_dev_info *devip)
 {
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	u32 lba;
 	u16 num;
 	u32 ei_lba = 0;
 	bool unmap = false;
 
-	if (cmd[1] & 0x8) {
+	if (cdb[1] & 0x8) {
 		if (sdebug_lbpws10 == 0) {
 			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 3);
 			return check_condition_result;
 		} else
 			unmap = true;
 	}
-	lba = get_unaligned_be32(cmd + 2);
-	num = get_unaligned_be16(cmd + 7);
+	lba = get_unaligned_be32(cdb + 2);
+	num = get_unaligned_be16(cdb + 7);
 	if (num > sdebug_write_same_length) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 7, -1);
 		return check_condition_result;
@@ -3912,24 +3914,24 @@ static int resp_write_same_10(struct scsi_cmnd *scp,
 static int resp_write_same_16(struct scsi_cmnd *scp,
 			      struct sdebug_dev_info *devip)
 {
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	u64 lba;
 	u32 num;
 	u32 ei_lba = 0;
 	bool unmap = false;
 	bool ndob = false;
 
-	if (cmd[1] & 0x8) {	/* UNMAP */
+	if (cdb[1] & 0x8) {	/* UNMAP */
 		if (sdebug_lbpws == 0) {
 			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 3);
 			return check_condition_result;
 		} else
 			unmap = true;
 	}
-	if (cmd[1] & 0x1)  /* NDOB (no data-out buffer, assumes zeroes) */
+	if (cdb[1] & 0x1)  /* NDOB (no data-out buffer, assumes zeroes) */
 		ndob = true;
-	lba = get_unaligned_be64(cmd + 2);
-	num = get_unaligned_be32(cmd + 10);
+	lba = get_unaligned_be64(cdb + 2);
+	num = get_unaligned_be32(cdb + 10);
 	if (num > sdebug_write_same_length) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 10, -1);
 		return check_condition_result;
@@ -3943,12 +3945,12 @@ static int resp_write_same_16(struct scsi_cmnd *scp,
 static int resp_write_buffer(struct scsi_cmnd *scp,
 			     struct sdebug_dev_info *devip)
 {
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	struct scsi_device *sdp = scp->device;
 	struct sdebug_dev_info *dp;
 	u8 mode;
 
-	mode = cmd[1] & 0x1f;
+	mode = cdb[1] & 0x1f;
 	switch (mode) {
 	case 0x4:	/* download microcode (MC) and activate (ACT) */
 		/* set UAs on this device only */
@@ -3989,7 +3991,7 @@ static int resp_write_buffer(struct scsi_cmnd *scp,
 static int resp_comp_write(struct scsi_cmnd *scp,
 			   struct sdebug_dev_info *devip)
 {
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	u8 *arr;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u64 lba;
@@ -3999,18 +4001,18 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	int ret;
 	int retval = 0;
 
-	lba = get_unaligned_be64(cmd + 2);
-	num = cmd[13];		/* 1 to a maximum of 255 logical blocks */
+	lba = get_unaligned_be64(cdb + 2);
+	num = cdb[13];		/* 1 to a maximum of 255 logical blocks */
 	if (0 == num)
 		return 0;	/* degenerate case, not an error */
 	if (sdebug_dif == T10_PI_TYPE2_PROTECTION &&
-	    (cmd[1] & 0xe0)) {
+	    (cdb[1] & 0xe0)) {
 		mk_sense_invalid_opcode(scp);
 		return check_condition_result;
 	}
 	if ((sdebug_dif == T10_PI_TYPE1_PROTECTION ||
 	     sdebug_dif == T10_PI_TYPE3_PROTECTION) &&
-	    (cmd[1] & 0xe0) == 0)
+	    (cdb[1] & 0xe0) == 0)
 		sdev_printk(KERN_ERR, scp->device, "Unprotected WR "
 			    "to DIF device\n");
 	ret = check_device_access_params(scp, lba, num, false);
@@ -4057,13 +4059,14 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	unsigned char *buf;
 	struct unmap_block_desc *desc;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	unsigned int i, payload_len, descriptors;
 	int ret;
 
 	if (!scsi_debug_lbp())
 		return 0;	/* fib and say its done */
-	payload_len = get_unaligned_be16(scp->cmnd + 7);
+	payload_len = get_unaligned_be16(cdb + 7);
 	BUG_ON(scsi_bufflen(scp) != payload_len);
 
 	descriptors = (payload_len - 8) / 16;
@@ -4113,14 +4116,14 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 static int resp_get_lba_status(struct scsi_cmnd *scp,
 			       struct sdebug_dev_info *devip)
 {
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	u64 lba;
 	u32 alloc_len, mapped, num;
 	int ret;
 	u8 arr[SDEBUG_GET_LBA_STATUS_LEN];
 
-	lba = get_unaligned_be64(cmd + 2);
-	alloc_len = get_unaligned_be32(cmd + 10);
+	lba = get_unaligned_be64(cdb + 2);
+	alloc_len = get_unaligned_be32(cdb + 10);
 
 	if (alloc_len < 24)
 		return 0;
@@ -4158,20 +4161,20 @@ static int resp_sync_cache(struct scsi_cmnd *scp,
 	int res = 0;
 	u64 lba;
 	u32 num_blocks;
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 
-	if (cmd[0] == SYNCHRONIZE_CACHE) {	/* 10 byte cdb */
-		lba = get_unaligned_be32(cmd + 2);
-		num_blocks = get_unaligned_be16(cmd + 7);
+	if (cdb[0] == SYNCHRONIZE_CACHE) {	/* 10 byte cdb */
+		lba = get_unaligned_be32(cdb + 2);
+		num_blocks = get_unaligned_be16(cdb + 7);
 	} else {				/* SYNCHRONIZE_CACHE(16) */
-		lba = get_unaligned_be64(cmd + 2);
-		num_blocks = get_unaligned_be32(cmd + 10);
+		lba = get_unaligned_be64(cdb + 2);
+		num_blocks = get_unaligned_be32(cdb + 10);
 	}
 	if (lba + num_blocks > sdebug_capacity) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
 		return check_condition_result;
 	}
-	if (!write_since_sync || (cmd[1] & 0x2))
+	if (!write_since_sync || (cdb[1] & 0x2))
 		res = SDEG_RES_IMMED_MASK;
 	else		/* delay if write_since_sync and IMMED clear */
 		write_since_sync = false;
@@ -4192,16 +4195,16 @@ static int resp_pre_fetch(struct scsi_cmnd *scp,
 	u64 lba;
 	u64 block, rest = 0;
 	u32 nblks;
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 *fsp = sip->storep;
 
-	if (cmd[0] == PRE_FETCH) {	/* 10 byte cdb */
-		lba = get_unaligned_be32(cmd + 2);
-		nblks = get_unaligned_be16(cmd + 7);
+	if (cdb[0] == PRE_FETCH) {	/* 10 byte cdb */
+		lba = get_unaligned_be32(cdb + 2);
+		nblks = get_unaligned_be16(cdb + 7);
 	} else {			/* PRE-FETCH(16) */
-		lba = get_unaligned_be64(cmd + 2);
-		nblks = get_unaligned_be32(cmd + 10);
+		lba = get_unaligned_be64(cdb + 2);
+		nblks = get_unaligned_be32(cdb + 10);
 	}
 	if (lba + nblks > sdebug_capacity) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
@@ -4222,7 +4225,7 @@ static int resp_pre_fetch(struct scsi_cmnd *scp,
 		prefetch_range(fsp, rest * sdebug_sector_size);
 	sdeb_read_unlock(sip);
 fini:
-	if (cmd[1] & 0x2)
+	if (cdb[1] & 0x2)
 		res = SDEG_RES_IMMED_MASK;
 	return res | condition_met_result;
 }
@@ -4240,7 +4243,7 @@ static int resp_pre_fetch(struct scsi_cmnd *scp,
 static int resp_report_luns(struct scsi_cmnd *scp,
 			    struct sdebug_dev_info *devip)
 {
-	unsigned char *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	unsigned int alloc_len;
 	unsigned char select_report;
 	u64 lun;
@@ -4256,8 +4259,8 @@ static int resp_report_luns(struct scsi_cmnd *scp,
 
 	clear_luns_changed_on_target(devip);
 
-	select_report = cmd[2];
-	alloc_len = get_unaligned_be32(cmd + 6);
+	select_report = cdb[2];
+	alloc_len = get_unaligned_be32(cdb + 6);
 
 	if (alloc_len < 4) {
 		pr_err("alloc len too small %d\n", alloc_len);
@@ -4339,10 +4342,10 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	const u32 lb_size = sdebug_sector_size;
 	u64 lba;
 	u8 *arr;
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 
-	bytchk = (cmd[1] >> 1) & 0x3;
+	bytchk = (cdb[1] >> 1) & 0x3;
 	if (bytchk == 0) {
 		return 0;	/* always claim internal verify okay */
 	} else if (bytchk == 2) {
@@ -4351,14 +4354,14 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	} else if (bytchk == 3) {
 		is_bytchk3 = true;	/* 1 block sent, compared repeatedly */
 	}
-	switch (cmd[0]) {
+	switch (cdb[0]) {
 	case VERIFY_16:
-		lba = get_unaligned_be64(cmd + 2);
-		vnum = get_unaligned_be32(cmd + 10);
+		lba = get_unaligned_be64(cdb + 2);
+		vnum = get_unaligned_be32(cdb + 10);
 		break;
 	case VERIFY:		/* is VERIFY(10) */
-		lba = get_unaligned_be32(cmd + 2);
-		vnum = get_unaligned_be16(cmd + 7);
+		lba = get_unaligned_be32(cdb + 2);
+		vnum = get_unaligned_be16(cdb + 7);
 		break;
 	default:
 		mk_sense_invalid_opcode(scp);
@@ -4418,7 +4421,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	bool partial;
 	u64 lba, zs_lba;
 	u8 *arr = NULL, *desc;
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	struct sdeb_zone_state *zsp;
 	struct sdeb_store_info *sip = devip2sip(devip, false);
 
@@ -4426,12 +4429,12 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 		mk_sense_invalid_opcode(scp);
 		return check_condition_result;
 	}
-	zs_lba = get_unaligned_be64(cmd + 2);
-	alloc_len = get_unaligned_be32(cmd + 10);
+	zs_lba = get_unaligned_be64(cdb + 2);
+	alloc_len = get_unaligned_be32(cdb + 10);
 	if (alloc_len == 0)
 		return 0;	/* not an error */
-	rep_opts = cmd[14] & 0x3f;
-	partial = cmd[14] & 0x80;
+	rep_opts = cdb[14] & 0x3f;
+	partial = cdb[14] & 0x80;
 
 	if (zs_lba >= sdebug_capacity) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
@@ -4559,9 +4562,9 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	int res = 0;
 	u64 z_id;
 	enum sdebug_z_cond zc;
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	struct sdeb_zone_state *zsp;
-	bool all = cmd[14] & 0x01;
+	bool all = cdb[14] & 0x01;
 	struct sdeb_store_info *sip = devip2sip(devip, false);
 
 	if (!sdebug_dev_is_zoned(devip)) {
@@ -4586,7 +4589,7 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 
 	/* Open the specified zone */
-	z_id = get_unaligned_be64(cmd + 2);
+	z_id = get_unaligned_be64(cdb + 2);
 	if (z_id >= sdebug_capacity) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
 		res = check_condition_result;
@@ -4635,9 +4638,9 @@ static int resp_close_zone(struct scsi_cmnd *scp,
 {
 	int res = 0;
 	u64 z_id;
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	struct sdeb_zone_state *zsp;
-	bool all = cmd[14] & 0x01;
+	bool all = cdb[14] & 0x01;
 	struct sdeb_store_info *sip = devip2sip(devip, false);
 
 	if (!sdebug_dev_is_zoned(devip)) {
@@ -4653,7 +4656,7 @@ static int resp_close_zone(struct scsi_cmnd *scp,
 	}
 
 	/* Close specified zone */
-	z_id = get_unaligned_be64(cmd + 2);
+	z_id = get_unaligned_be64(cdb + 2);
 	if (z_id >= sdebug_capacity) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
 		res = check_condition_result;
@@ -4708,8 +4711,8 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
 	struct sdeb_zone_state *zsp;
 	int res = 0;
 	u64 z_id;
-	u8 *cmd = scp->cmnd;
-	bool all = cmd[14] & 0x01;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
+	bool all = cdb[14] & 0x01;
 	struct sdeb_store_info *sip = devip2sip(devip, false);
 
 	if (!sdebug_dev_is_zoned(devip)) {
@@ -4725,7 +4728,7 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
 	}
 
 	/* Finish the specified zone */
-	z_id = get_unaligned_be64(cmd + 2);
+	z_id = get_unaligned_be64(cdb + 2);
 	if (z_id >= sdebug_capacity) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
 		res = check_condition_result;
@@ -4788,8 +4791,8 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	struct sdeb_zone_state *zsp;
 	int res = 0;
 	u64 z_id;
-	u8 *cmd = scp->cmnd;
-	bool all = cmd[14] & 0x01;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
+	bool all = cdb[14] & 0x01;
 	struct sdeb_store_info *sip = devip2sip(devip, false);
 
 	if (!sdebug_dev_is_zoned(devip)) {
@@ -4804,7 +4807,7 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		goto fini;
 	}
 
-	z_id = get_unaligned_be64(cmd + 2);
+	z_id = get_unaligned_be64(cdb + 2);
 	if (z_id >= sdebug_capacity) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
 		res = check_condition_result;
@@ -5528,7 +5531,7 @@ static bool inject_on_this_cmd(void)
 
 static int process_deflect_incoming(struct scsi_cmnd *scp)
 {
-	u8 opcode = scp->cmnd[0];
+	u8 opcode = scsi_cmnd_get_cdb(scp)[0];
 
 	if (opcode == SYNCHRONIZE_CACHE || opcode == SYNCHRONIZE_CACHE_16)
 		return 0;
@@ -7436,6 +7439,7 @@ static int resp_not_ready(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u64 diff_ns = 0;
 	ktime_t now_ts = ktime_get_boottime();
 	struct scsi_device *sdp = scp->device;
+	const u8 *cmd = scsi_cmnd_get_cdb(scp);
 
 	stopped_state = atomic_read(&devip->stopped);
 	if (stopped_state == 2) {
@@ -7451,7 +7455,7 @@ static int resp_not_ready(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, sdp,
 				    "%s: Not ready: in process of becoming ready\n", my_name);
-		if (scp->cmnd[0] == TEST_UNIT_READY) {
+		if (cmd[0] == TEST_UNIT_READY) {
 			u64 tur_nanosecs_to_ready = (u64)sdeb_tur_ms_to_ready * 1000000;
 
 			if (diff_ns <= tur_nanosecs_to_ready)
@@ -7604,7 +7608,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	const struct opcode_info_t *oip;
 	const struct opcode_info_t *r_oip;
 	struct sdebug_dev_info *devip;
-	u8 *cmd = scp->cmnd;
+	const u8 *cdb = scsi_cmnd_get_cdb(scp);
 	int (*r_pfp)(struct scsi_cmnd *, struct sdebug_dev_info *);
 	int (*pfp)(struct scsi_cmnd *, struct sdebug_dev_info *) = NULL;
 	int k, na;
@@ -7612,7 +7616,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	u64 lun_index = sdp->lun & 0x3FFF;
 	u32 flags;
 	u16 sa;
-	u8 opcode = cmd[0];
+	u8 opcode = cdb[0];
 	bool has_wlun_rl;
 	bool inject_now;
 
@@ -7625,20 +7629,32 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	}
 	if (unlikely(sdebug_verbose &&
 		     !(SDEBUG_OPT_NO_CDB_NOISE & sdebug_opts))) {
-		char b[120];
+		char b[200];
 		int n, len, sb;
 
 		len = scp->cmd_len;
 		sb = (int)sizeof(b);
-		if (len > 32)
-			strcpy(b, "too long, over 32 bytes");
+		k = 0;
+		if (len > 64)
+			strcpy(b, "too long, over 64 bytes");
 		else {
-			for (k = 0, n = 0; k < len && n < sb; ++k)
+			for (n = 0; k < len && k < 16 && n < sb; ++k)
 				n += scnprintf(b + n, sb - n, "%02x ",
-					       (u32)cmd[k]);
+					       (u32)cdb[k]);
 		}
-		sdev_printk(KERN_INFO, sdp, "%s: tag=%#x, cmd %s\n", my_name,
+		sdev_printk(KERN_INFO, sdp, "%s: tag=%#x, cmd: %s\n", my_name,
 			    blk_mq_unique_tag(scsi_cmd_to_rq(scp)), b);
+		while (k > 0 && k < len) {
+			for (n = 0; (k < len && n < sb); ++k) {
+				n += scnprintf(b + n, sb - n, "%02x ",
+					       (u32)cdb[k]);
+				if (((k + 1) % 16) == 0) {
+					++k;
+					break;
+				}
+			}
+			sdev_printk(KERN_INFO, sdp, " extra cmd: %s\n", b);
+		}
 	}
 	if (unlikely(inject_now && (sdebug_opts & SDEBUG_OPT_HOST_BUSY)))
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -7663,9 +7679,9 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		r_oip = oip;
 		if (FF_SA & r_oip->flags) {
 			if (F_SA_LOW & oip->flags)
-				sa = 0x1f & cmd[1];
+				sa = 0x1f & cdb[1];
 			else
-				sa = get_unaligned_be16(cmd + 8);
+				sa = get_unaligned_be16(cdb + 8);
 			for (k = 0; k <= na; oip = r_oip->arrp + k++) {
 				if (opcode == oip->opcode && sa == oip->sa)
 					break;
@@ -7703,7 +7719,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		int j;
 
 		for (k = 1; k < oip->len_mask[0] && k < 16; ++k) {
-			rem = ~oip->len_mask[k] & cmd[k];
+			rem = ~oip->len_mask[k] & cdb[k];
 			if (rem) {
 				for (j = 7; j >= 0; --j, rem <<= 1) {
 					if (0x80 & rem)
@@ -7721,7 +7737,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		if (errsts)
 			goto check_cond;
 	}
-	if (unlikely(((F_M_ACCESS & flags) || scp->cmnd[0] == TEST_UNIT_READY) &&
+	if (unlikely(((F_M_ACCESS & flags) || cdb[0] == TEST_UNIT_READY) &&
 		     atomic_read(&devip->stopped))) {
 		errsts = resp_not_ready(scp, devip);
 		if (errsts)
-- 
2.25.1

