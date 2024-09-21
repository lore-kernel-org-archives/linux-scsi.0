Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F333874BF8;
	Sat, 21 Sep 2024 06:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726899898; cv=none; b=kJopWH7P3on+1XGSMFvEbkBvIpdLmClSGjhL+2O1YdOfEdNrH4mbegi7QiEyWeaS+4pI22KiCkyRFBNYwr9JDnW0u6psFMWvIJ1GvoQiNRZ3NOUnOXjjhNbI0ohtv8Sp0gno5zr4GsKbuJolnPda/Ka26NAcyxGJy15Ct0dVDwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726899898; c=relaxed/simple;
	bh=5mH7mMTVTr3FhqnocQwFbpDBgHlshX4tmQnu+pFtNeg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nNbsoADrbW53LlrcK0Iiy2ypHkMQeMTsVeBzMcC17MHrJB7/DFaGQXY0uV5aDjWBEmeG3GIwctJDQG974SRUXUNpb2fCyokrKGrXyiC74XstBZ8B4FojHdlffMwTg0nlMk1NTb8BQN3Sz3EbdATX9JHLxARiV2+OXil2JWN+u5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PjtdbXOd; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PjtdbXOd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726899895; x=1758435895;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5mH7mMTVTr3FhqnocQwFbpDBgHlshX4tmQnu+pFtNeg=;
  b=PjtdbXOdHq6WslT53E1xD0fW9IDBqPoW9cAYnzz+iAT178+eCZ551Xsl
   bo03xYW3uW0u0GqsY3z4Pm9TphorQbxHEq0LRtPpdOwCf7BlHx+nD7DMh
   7a9pMbCNfv/Pml2aBKzXAWcMGlbnjedADeu1AwkoH+MSKBZj3HRh5Bxul
   EU4fj7yLUDqDZhZJ5YZUWABGZxz3kyQH9mD6QSpwgB+3jeg1vYX4T1dXc
   MJOxIXk79VKAKjDbgDW27Cv58wF1VimHHwGKSe+gFQOGYwrxnbFfETeG9
   FaspC2fkZpRQBhunCwaNMzdWujdi5uYwGDoZvWIKmu2OmmIwVfTRzCywG
   A==;
X-CSE-ConnectionGUID: jI2AIvWBRJSV86V50oa9JQ==
X-CSE-MsgGUID: KPN99nuQQSWDd2TJnyjcYw==
X-IronPort-AV: E=Sophos;i="6.10,246,1719849600"; 
   d="scan'208";a="28226048"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Sep 2024 14:24:54 +0800
IronPort-SDR: 66ee5885_OR5yk4Ajn5bE8ZwbPgxAlxJWPJJ6Ot9cOKbeCoAScoOaDCi
 dNp8p5jImZ0Ir7uQvo5ozLPV7p2IbBTGQBLkXeQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Sep 2024 22:24:21 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Sep 2024 23:24:53 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4] scsi: ufs: Zero utp_upiu_req at the beginning of each command
Date: Sat, 21 Sep 2024 09:23:06 +0300
Message-Id: <20240921062306.56019-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces a previously missing step: zeroing the
`utp_upiu_req` structure at the beginning of each upiu transaction. This
ensures that the upiu request fields are properly initialized,
preventing potential issues caused by residual data from previous
commands.

While at it, re-use some of the common initializations for query and
command upiu.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Avri Altman <avri.altman@wdc.com>

---
Changes in v4:
 - Remove a redundant argument (Bart)

Changes in v3:
 - initialize *ucd_req_ptr once (Bart)

Changes in v2:
 - Simplify things (Bart)
---
 drivers/ufs/core/ufshcd.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8ea5a82503a9..9187cf5c949c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2761,7 +2761,6 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u8 upiu_flags)
 	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(cmd->sdb.length);
 
 	cdb_len = min_t(unsigned short, cmd->cmd_len, UFS_CDB_SIZE);
-	memset(ucd_req_ptr->sc.cdb, 0, UFS_CDB_SIZE);
 	memcpy(ucd_req_ptr->sc.cdb, cmd->cmnd, cdb_len);
 
 	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
@@ -2864,6 +2863,26 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
 }
 
+static void __ufshcd_setup_cmd(struct ufshcd_lrb *lrbp, struct scsi_cmnd *cmd, u8 lun, int tag)
+{
+	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
+
+	lrbp->cmd = cmd;
+	lrbp->task_tag = tag;
+	lrbp->lun = lun;
+	ufshcd_prepare_lrbp_crypto(cmd ? scsi_cmd_to_rq(cmd) : NULL, lrbp);
+}
+
+static void ufshcd_setup_scsi_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
+				  struct scsi_cmnd *cmd, u8 lun, int tag)
+{
+	__ufshcd_setup_cmd(lrbp, cmd, lun, tag);
+	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba);
+	lrbp->req_abort_skip = false;
+
+	ufshcd_comp_scsi_upiu(hba, lrbp);
+}
+
 /**
  * ufshcd_upiu_wlun_to_scsi_wlun - maps UPIU W-LUN id to SCSI W-LUN ID
  * @upiu_wlun_id: UPIU W-LUN id
@@ -2997,16 +3016,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	ufshcd_hold(hba);
 
 	lrbp = &hba->lrb[tag];
-	lrbp->cmd = cmd;
-	lrbp->task_tag = tag;
-	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
-	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba);
 
-	ufshcd_prepare_lrbp_crypto(scsi_cmd_to_rq(cmd), lrbp);
-
-	lrbp->req_abort_skip = false;
-
-	ufshcd_comp_scsi_upiu(hba, lrbp);
+	ufshcd_setup_scsi_cmd(hba, lrbp, cmd, ufshcd_scsi_to_upiu_lun(cmd->device->lun), tag);
 
 	err = ufshcd_map_sg(hba, lrbp);
 	if (err) {
@@ -3034,11 +3045,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 static void ufshcd_setup_dev_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 			     enum dev_cmd_type cmd_type, u8 lun, int tag)
 {
-	lrbp->cmd = NULL;
-	lrbp->task_tag = tag;
-	lrbp->lun = lun;
+	__ufshcd_setup_cmd(lrbp, NULL, lun, tag);
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
-	ufshcd_prepare_lrbp_crypto(NULL, lrbp);
 	hba->dev_cmd.type = cmd_type;
 }
 
-- 
2.25.1

