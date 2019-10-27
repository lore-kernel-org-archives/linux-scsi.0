Return-Path: <SRS0=OYiK=YU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08428CA9EBC
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 14:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C420320679
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 14:06:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lJUgsoPu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfJ0OGE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:06:04 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:11568 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfJ0OGE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Oct 2019 10:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572185240; x=1603721240;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5cvE0oaFONE+MtgJwCgpa8BlpWWXdkUaTDADwKXP7sY=;
  b=lJUgsoPuKUonyT5TLz45UKlmgV3+Uh76G+E4DPRjLaDoJNWXImUy8C8i
   HP/IqqIrGkd+K2zsdDU80IqH1/abLa8/1GbQGetuIzTdhmyrk+FrD5g3y
   9o4ZUCP8fPrxDgZ/QkCUfj9/r9nqLXgh8IuDKUHQ7Q+ayONvZR4AF8udz
   ejDDDsMSCdxymK/GtowAR4DekOYObsiXnJ1PzBWEkx7/+8Hm4rZhVE7D9
   e76R6RNWIObTHEvw95MPHdHLkYBqJzaHB8zItHH/6qEPF4KRUWeMvHdJ6
   vDb5lrcgCQ+CYH3yJyFj133rne4TX4SBW1/0iN7gt3VYRdfzJ1YHjaYjD
   A==;
IronPort-SDR: 9BsfnFCXObD66iJRXD/3Zlq528hG5MFpSuLU4Xy2o67GBss17c0nDNf61nDSOYq+yQY0hgSstN
 PoBiQ5F5631wPl2rY7i0MHqNRoYHMnBZwugqHeLHdhYG3ZknVaRuju9OSdmmxvHYhqwFiOSfvr
 c5J/zUKpsz7OpWLGF1ACU4WWyV8u0HyOXRl2GWXb/EMTH1uRiitpnqJDcchE82VTQK8MdWHE43
 QYpWlQtzQIldkpn3N/blSwTPuWevDixMHdCnqBrzkId5Xpj6tNtQk6RpfzEVRoiE5GIm+5Vvkx
 VLM=
X-IronPort-AV: E=Sophos;i="5.68,236,1569254400"; 
   d="scan'208";a="222578551"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2019 22:07:19 +0800
IronPort-SDR: TJJhNDX1GKTkIy3JFqgfTefzVby21FmeNl2te6+lQW2Xqfnm0RuFzOyLka+t2e1ZtXcWe27yOf
 vjrJEiy9T3qjpAQuyOPTsPF7A6x1cs8gWQBT4cBUiNrCN7y9nu2JFu0JE25ZX6nnP5djQTDMQd
 P91AAh4v9DdU9gkripiVUvdqsPpeeEKlylinIZgKJ7tY2A1HDJ82cmorWqyHn5ZLT6ztid2/Tk
 k8v8Dor2c0fRSl0jVa/C7HRTX4kb8UVkJMmai7MjQJQIyJvFlUPOfNfPM3fOvnZU12iPm8Yje8
 E3dS92BgYuDEDmHabTcZySvq
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 07:01:27 -0700
IronPort-SDR: xsDPaaX7ug3izD4+t1ANL9/KQMDmbU4f3DDNjrwLsfkJndSpOKgGt6scuMfMQJCEPQOOqwzWYA
 y92DaZ45IgcYGF0KTRJnlkjjif9OuVzxhe/xsvHGhk5uOsI+lCBnMb+bcR269eCkQI57xEnLpw
 IzxLlwRqxVRvZLEcHWC24/jtxIOUZE8ufm+W877LON5TZg4nOIJwOgt0Nqqq0Ys5RDuHnqaY/A
 /11OlB6nDVFNPhq0HvE86JgaTxCnYd3zqRo61hnHUqm0Wt5ShbdUTHyblUwOZJfDDa2/FbfGN3
 0P0=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Oct 2019 07:06:01 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc:     Ajay Joshi <ajay.joshi@wdc.com>,
        Matias Bjorling <matias.bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6/8] scsi: sd_zbc: add zone open, close, and finish support
Date:   Sun, 27 Oct 2019 23:05:47 +0900
Message-Id: <20191027140549.26272-7-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191027140549.26272-1-damien.lemoal@wdc.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ajay Joshi <ajay.joshi@wdc.com>

Implement REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH
support to allow explicit control of zone states.

Contains contributions from Matias Bjorling, Hans Holmberg,
Keith Busch and Damien Le Moal.

Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>
Signed-off-by: Matias Bjorling <matias.bjorling@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c     | 15 +++++++++++++--
 drivers/scsi/sd.h     |  8 +++++---
 drivers/scsi/sd_zbc.c | 22 +++++++++++++---------
 3 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 03163ac5fe95..ff0a22e2a34e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1290,9 +1290,17 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 	case REQ_OP_WRITE:
 		return sd_setup_read_write_cmnd(cmd);
 	case REQ_OP_ZONE_RESET:
-		return sd_zbc_setup_reset_cmnd(cmd, false);
+		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_RESET_WRITE_POINTER,
+						   false);
 	case REQ_OP_ZONE_RESET_ALL:
-		return sd_zbc_setup_reset_cmnd(cmd, true);
+		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_RESET_WRITE_POINTER,
+						   true);
+	case REQ_OP_ZONE_OPEN:
+		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_OPEN_ZONE, false);
+	case REQ_OP_ZONE_CLOSE:
+		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_CLOSE_ZONE, false);
+	case REQ_OP_ZONE_FINISH:
+		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_FINISH_ZONE, false);
 	default:
 		WARN_ON_ONCE(1);
 		return BLK_STS_NOTSUPP;
@@ -1960,6 +1968,9 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	case REQ_OP_WRITE_SAME:
 	case REQ_OP_ZONE_RESET:
 	case REQ_OP_ZONE_RESET_ALL:
+	case REQ_OP_ZONE_OPEN:
+	case REQ_OP_ZONE_CLOSE:
+	case REQ_OP_ZONE_FINISH:
 		if (!result) {
 			good_bytes = blk_rq_bytes(req);
 			scsi_set_resid(SCpnt, 0);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 1eab779f812b..bf2102a749bc 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -209,7 +209,8 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 
 extern int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
 extern void sd_zbc_print_zones(struct scsi_disk *sdkp);
-extern blk_status_t sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd, bool all);
+blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
+					 unsigned char op, bool all);
 extern void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 			    struct scsi_sense_hdr *sshdr);
 extern int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
@@ -225,8 +226,9 @@ static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
 
 static inline void sd_zbc_print_zones(struct scsi_disk *sdkp) {}
 
-static inline blk_status_t sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd,
-						   bool all)
+static inline blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
+						       unsigned char op,
+						       bool all)
 {
 	return BLK_STS_TARGET;
 }
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 1efc69e194f8..39f10ec0dfcf 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -207,13 +207,17 @@ static inline sector_t sd_zbc_zone_sectors(struct scsi_disk *sdkp)
 }
 
 /**
- * sd_zbc_setup_reset_cmnd - Prepare a RESET WRITE POINTER scsi command.
+ * sd_zbc_setup_zone_mgmt_cmnd - Prepare a zone ZBC_OUT command. The operations
+ *			can be RESET WRITE POINTER, OPEN, CLOSE or FINISH.
  * @cmd: the command to setup
- * @all: Reset all zones control.
+ * @op: Operation to be performed
+ * @all: All zones control
  *
- * Called from sd_init_command() for a REQ_OP_ZONE_RESET request.
+ * Called from sd_init_command() for REQ_OP_ZONE_RESET, REQ_OP_ZONE_RESET_ALL,
+ * REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE or REQ_OP_ZONE_FINISH requests.
  */
-blk_status_t sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd, bool all)
+blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
+					 unsigned char op, bool all)
 {
 	struct request *rq = cmd->request;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
@@ -234,7 +238,7 @@ blk_status_t sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd, bool all)
 	cmd->cmd_len = 16;
 	memset(cmd->cmnd, 0, cmd->cmd_len);
 	cmd->cmnd[0] = ZBC_OUT;
-	cmd->cmnd[1] = ZO_RESET_WRITE_POINTER;
+	cmd->cmnd[1] = op;
 	if (all)
 		cmd->cmnd[14] = 0x1;
 	else
@@ -263,14 +267,14 @@ void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 	int result = cmd->result;
 	struct request *rq = cmd->request;
 
-	if (req_op(rq) == REQ_OP_ZONE_RESET &&
+	if (op_is_zone_mgmt(req_op(rq)) &&
 	    result &&
 	    sshdr->sense_key == ILLEGAL_REQUEST &&
 	    sshdr->asc == 0x24) {
 		/*
-		 * INVALID FIELD IN CDB error: reset of a conventional
-		 * zone was attempted. Nothing to worry about, so be
-		 * quiet about the error.
+		 * INVALID FIELD IN CDB error: a zone management command was
+		 * attempted on a conventional zone. Nothing to worry about,
+		 * so be quiet about the error.
 		 */
 		rq->rq_flags |= RQF_QUIET;
 	}
-- 
2.21.0

