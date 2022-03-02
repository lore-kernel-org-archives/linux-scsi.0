Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C1CC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238651AbiCBFh0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239528AbiCBFhR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:37:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBD3B16FD
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:36:34 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222bNBb010964
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=yNi5yyuOMZJkepAmkYj38hAa/Fa8Vy9y7z/jpgDWPgM=;
 b=MrPqUTJRpH7mfo7tE8koqx/M9NIOg5eYxIcAv1Hu4cLtU7IemIpCbcHX77TybF0L3cvh
 NP5u2NctgROA7k2ljT9+5HJVAxsrWA14SRRyPG97L6PBffer9gxZy1qMfB7hkiWebPzl
 ucdxHP947Z2/Lu5iRV+HYMB+fKS8sN6bbKSSxx/UERXemfPn2hAoQpKCkMdgfzgJgheL
 HKwTLzLo+q2gtS+5hfxWFQH43QZdi5GpMDWdywiUvTE/tRO62pftcGDOjW20k0kfbZgr
 YkcpQYWP2g85HNK44zxYrnYYaB0SdRvCeXJLQgcAuv7kPqEr7a7/wUYxZ9RS8nr+6DuS cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14bvwcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225Irp6175878
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3efc15vakh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:33 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225aRZp014395
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:32 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3efc15vaeg-12;
        Wed, 02 Mar 2022 05:36:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 11/14] scsi: sd: Implement support for NDOB flag in WRITE SAME(16)
Date:   Wed,  2 Mar 2022 00:35:56 -0500
Message-Id: <20220302053559.32147-12-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302053559.32147-1-martin.petersen@oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 5rRo_iM3GoXe1Z8KrjZ2mSCZfn3vpdKM
X-Proofpoint-ORIG-GUID: 5rRo_iM3GoXe1Z8KrjZ2mSCZfn3vpdKM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The NDOB flag removes the need for a zeroed logical block in the data-out
buffer when using WRITE SAME(16) to zero block ranges.  Implement support
for NDOB in the SCSI disk driver to mirror WRITE ZEROES in NVMe.

The only way to detect whether a device supports NDOB is through
REPORT SUPPORTED OPERATION CODES. Since we can't safely send that
command to all devices we only attempt this if the device implements
the Block Provisioning VPD page and sets the LBPWS flag.

If we issue a WRITE SAME(16) we check whether NDOB is set for the
device in question. If so we do not allocate a zeroed page from the
pool and simply issue the command with a zero-length payload.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_trace.c |  3 +-
 drivers/scsi/sd.c         | 93 ++++++++++++++++++++++++++-------------
 drivers/scsi/sd.h         |  4 ++
 3 files changed, 69 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 41a950075913..1d1f25f689ef 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -83,7 +83,8 @@ scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
 			 cdb[1] >> 5);
 
 	if (cdb[0] == WRITE_SAME_16)
-		trace_seq_printf(p, " unmap=%u", cdb[1] >> 3 & 1);
+		trace_seq_printf(p, " unmap=%u ndob=%u", cdb[1] >> 3 & 1,
+				 cdb[1] & 1);
 
 	trace_seq_putc(p, 0);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ee4f4aea5f0f..2c2e86738578 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -379,6 +379,7 @@ static const char *lbp_mode[] = {
 	[SD_LBP_FULL]		= "full",
 	[SD_LBP_UNMAP]		= "unmap",
 	[SD_LBP_WS16]		= "writesame_16",
+	[SD_LBP_WS16_NDOB]	= "writesame_16_ndob",
 	[SD_LBP_WS10]		= "writesame_10",
 	[SD_LBP_ZERO]		= "writesame_zero",
 	[SD_LBP_DISABLE]	= "disabled",
@@ -429,12 +430,14 @@ static DEVICE_ATTR_RW(provisioning_mode);
 
 /* sysfs_match_string() requires dense arrays */
 static const char *zeroing_mode[] = {
-	[SD_ZERO_DEFAULT]	= "default",
-	[SD_ZERO_WRITE]		= "write",
-	[SD_ZERO_WS]		= "writesame",
-	[SD_ZERO_WS16_UNMAP]	= "writesame_16_unmap",
-	[SD_ZERO_WS10_UNMAP]	= "writesame_10_unmap",
-	[SD_ZERO_DISABLE]	= "disabled",
+	[SD_ZERO_DEFAULT]		= "default",
+	[SD_ZERO_WRITE]			= "write",
+	[SD_ZERO_WS]			= "writesame",
+	[SD_ZERO_WS16_UNMAP_NDOB]	= "writesame_16_unmap_ndob",
+	[SD_ZERO_WS16_UNMAP]		= "writesame_16_unmap",
+	[SD_ZERO_WS10_UNMAP]		= "writesame_10_unmap",
+	[SD_ZERO_WS16_NDOB]		= "writesame_16_ndob",
+	[SD_ZERO_DISABLE]		= "disabled",
 };
 
 static ssize_t
@@ -870,13 +873,14 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
  *
  * The possible values for provisioning_mode in sysfs are:
  *
- *   "default"	      - use heuristics outlined above to decide on command
- *   "full"           - the device does not support discard
- *   "unmap"          - use the UNMAP command
- *   "writesame_16"   - use the WRITE SAME(16) command with the UNMAP bit set
- *   "writesame_10"   - use the WRITE SAME(10) command with the UNMAP bit set
- *   "writesame_zero" - use WRITE SAME(16) with a zeroed payload, no UNMAP bit
- *   "disabled"	      - discards disabled due to command failure
+ *   "default"		 - use heuristics outlined above to decide on command
+ *   "full"		 - the device does not support discard
+ *   "unmap"		 - use the UNMAP command
+ *   "writesame_16"	 - use the WRITE SAME(16) command with the UNMAP bit set
+ *   "writesame_16_ndob" - use WRITE SAME(16) with UNMAP and NDOB bits set
+ *   "writesame_10"	 - use the WRITE SAME(10) command with the UNMAP bit set
+ *   "writesame_zero"	 - use WRITE SAME(16) with a zeroed payload, no UNMAP bit
+ *   "disabled"		 - discards disabled due to command failure
  */
 static void sd_config_discard(struct scsi_disk *sdkp, enum sd_lbp_mode mode)
 {
@@ -889,9 +893,12 @@ static void sd_config_discard(struct scsi_disk *sdkp, enum sd_lbp_mode mode)
 			if (sdkp->lbpvpd) { /* Logical Block Provisioning VPD */
 				if (sdkp->lbpu && sdkp->max_unmap_blocks)
 					mode = SD_LBP_UNMAP;
-				else if (sdkp->lbpws)
-					mode = SD_LBP_WS16;
-				else if (sdkp->lbpws10)
+				else if (sdkp->lbpws) {
+					if (sdkp->ndob)
+						mode = SD_LBP_WS16_NDOB;
+					else
+						mode = SD_LBP_WS16;
+				} else if (sdkp->lbpws10)
 					mode = SD_LBP_WS10;
 				else
 					mode = SD_LBP_FULL;
@@ -925,6 +932,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, enum sd_lbp_mode mode)
 		break;
 
 	case SD_LBP_WS16:
+	case SD_LBP_WS16_NDOB:
 		if (sdkp->device->unmap_limit_for_ws)
 			max_blocks = sdkp->max_unmap_blocks;
 		else
@@ -994,7 +1002,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 }
 
 static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
-		bool unmap)
+		bool unmap, bool ndob)
 {
 	struct scsi_device *sdp = cmd->device;
 	struct request *rq = scsi_cmd_to_rq(cmd);
@@ -1003,23 +1011,32 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
 
-	rq->special_vec.bv_page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
-	if (!rq->special_vec.bv_page)
-		return BLK_STS_RESOURCE;
-	clear_highpage(rq->special_vec.bv_page);
-	rq->special_vec.bv_offset = 0;
-	rq->special_vec.bv_len = data_len;
+	if (ndob) {
+		rq->special_vec.bv_page = NULL;
+		rq->special_vec.bv_len = 0;
+	} else {
+		rq->special_vec.bv_page =
+			mempool_alloc(sd_page_pool, GFP_ATOMIC);
+		if (!rq->special_vec.bv_page)
+			return BLK_STS_RESOURCE;
+		clear_highpage(rq->special_vec.bv_page);
+		rq->special_vec.bv_len = data_len;
+	}
+
 	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
+	rq->special_vec.bv_offset = 0;
 
 	cmd->cmd_len = 16;
 	cmd->cmnd[0] = WRITE_SAME_16;
 	if (unmap)
 		cmd->cmnd[1] = 0x8; /* UNMAP */
+	if (ndob)
+		cmd->cmnd[1] |= 0x1; /* NDOB */
 	put_unaligned_be64(lba, &cmd->cmnd[2]);
 	put_unaligned_be32(nr_blocks, &cmd->cmnd[10]);
 
 	cmd->allowed = sdkp->max_retries;
-	cmd->transfersize = data_len;
+	cmd->transfersize = rq->special_vec.bv_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
 	return scsi_alloc_sgtables(cmd);
@@ -1064,10 +1081,14 @@ static void sd_config_write_zeroes(struct scsi_disk *sdkp,
 	unsigned int logical_block_size = sdkp->device->sector_size;
 
 	if (mode == SD_ZERO_DEFAULT && !sdkp->zeroing_override) {
-		if (sdkp->lbprz && sdkp->lbpws)
+		if (sdkp->lbprz && sdkp->lbpws && sdkp->ndob)
+			mode = SD_ZERO_WS16_UNMAP_NDOB;
+		else if (sdkp->lbprz && sdkp->lbpws)
 			mode = SD_ZERO_WS16_UNMAP;
 		else if (sdkp->lbprz && sdkp->lbpws10)
 			mode = SD_ZERO_WS10_UNMAP;
+		else if (sdkp->max_ws_blocks && sdkp->ndob)
+			mode = SD_ZERO_WS16_NDOB;
 		else if (sdkp->max_ws_blocks)
 			mode = SD_ZERO_WS;
 		else
@@ -1092,8 +1113,10 @@ static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 
 	if (!(rq->cmd_flags & REQ_NOUNMAP)) {
 		switch (sdkp->zeroing_mode) {
+		case SD_ZERO_WS16_UNMAP_NDOB:
+			return sd_setup_write_same16_cmnd(cmd, true, true);
 		case SD_ZERO_WS16_UNMAP:
-			return sd_setup_write_same16_cmnd(cmd, true);
+			return sd_setup_write_same16_cmnd(cmd, true, false);
 		case SD_ZERO_WS10_UNMAP:
 			return sd_setup_write_same10_cmnd(cmd, true);
 		}
@@ -1104,8 +1127,12 @@ static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 		return BLK_STS_TARGET;
 	}
 
-	if (sdkp->ws16 || lba > 0xffffffff || nr_blocks > 0xffff)
-		return sd_setup_write_same16_cmnd(cmd, false);
+	if (sdkp->ws16 || lba > 0xffffffff || nr_blocks > 0xffff) {
+		if (sdkp->zeroing_mode == SD_ZERO_WS16_NDOB)
+			return sd_setup_write_same16_cmnd(cmd, false, true);
+		else
+			return sd_setup_write_same16_cmnd(cmd, false, false);
+	}
 
 	return sd_setup_write_same10_cmnd(cmd, false);
 }
@@ -1372,7 +1399,9 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 		case SD_LBP_UNMAP:
 			return sd_setup_unmap_cmnd(cmd);
 		case SD_LBP_WS16:
-			return sd_setup_write_same16_cmnd(cmd, true);
+			return sd_setup_write_same16_cmnd(cmd, true, false);
+		case SD_LBP_WS16_NDOB:
+			return sd_setup_write_same16_cmnd(cmd, true, true);
 		case SD_LBP_WS10:
 			return sd_setup_write_same10_cmnd(cmd, true);
 		case SD_LBP_ZERO:
@@ -3122,9 +3151,13 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		rcu_read_unlock();
 	}
 
-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1)
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1) {
 		sdkp->ws16 = 1;
 
+		if (get_unaligned_be16(&buffer[2]) >= 2)
+			sdkp->ndob = buffer[5] & 1;
+	}
+
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME) == 1)
 		sdkp->ws10 = 1;
 }
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index e0ee4215a3b4..2cef9e884b2a 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -56,6 +56,7 @@ enum sd_lbp_mode {
 	SD_LBP_FULL,		/* Full logical block provisioning */
 	SD_LBP_UNMAP,		/* Use UNMAP command */
 	SD_LBP_WS16,		/* Use WRITE SAME(16) with UNMAP bit */
+	SD_LBP_WS16_NDOB,	/* Use WRITE SAME(16) with UNMAP + NDOB bits */
 	SD_LBP_WS10,		/* Use WRITE SAME(10) with UNMAP bit */
 	SD_LBP_ZERO,		/* Use WRITE SAME(10) with zeroed payload */
 	SD_LBP_DISABLE,		/* Discard disabled due to failed cmd */
@@ -65,8 +66,10 @@ enum sd_zeroing_mode {
 	SD_ZERO_DEFAULT = 0,	/* Default mode based on what device reports */
 	SD_ZERO_WRITE,		/* Use WRITE(10/16) command */
 	SD_ZERO_WS,		/* Use WRITE SAME(10/16) command */
+	SD_ZERO_WS16_UNMAP_NDOB,/* Use WRITE SAME(16) with UNMAP + NDOB bits */
 	SD_ZERO_WS16_UNMAP,	/* Use WRITE SAME(16) with UNMAP */
 	SD_ZERO_WS10_UNMAP,	/* Use WRITE SAME(10) with UNMAP */
+	SD_ZERO_WS16_NDOB,	/* Use WRITE SAME(16) with NDOB */
 	SD_ZERO_DISABLE,	/* Write Zeroes disabled due to failed cmd */
 };
 
@@ -114,6 +117,7 @@ struct scsi_disk {
 	bool		lblvpd;
 	bool		provisioning_override;
 	bool		zeroing_override;
+	bool		ndob;
 	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	cache_override : 1; /* temp override of WCE,RCD */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
-- 
2.32.0

