Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C89319408B;
	Thu, 19 Sep 2024 08:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726735447; cv=none; b=gzjh0x2sF0UCA9FGspxo0EQ+wfKCmU5tOEMDUHu408n+pmYYXFadY1FchPJczaO7J3OyrGSUVSsOoSeoC27dy29dVi0NHC2RIVup8RhX3Ut+2tJRnsKw/rM5bRt1eM2AtRwfbII+WPW2p+bAeS/C1xna5TDLaKSCTVskGHrjW70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726735447; c=relaxed/simple;
	bh=vgWlXIIODT5FR5QzYPKyO4RY8gbXOj2gG7v3YbL+nfE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uNgI+85slUS1XnY9JZ+GUSnsrLWYMPRRq/qQn1xxZ57IN3pk/hiipgzhIcZtqXZG+GJfS6Cc+7YSGghEYrtrZTdTvDfpCcfGvDT+IIePmVt9fdF4EvkBANjTD+haMkSOPDsopSLOI4SrMdj6Vl4aBEaaD9Qm4+DAkqkv6GSUf7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ZGm/K6zK; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZGm/K6zK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726735444; x=1758271444;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vgWlXIIODT5FR5QzYPKyO4RY8gbXOj2gG7v3YbL+nfE=;
  b=ZGm/K6zKslhvvVceCIp6cM1xNobznZVdSGgs8OpK30bV8tpMGWnHvr3s
   tEtCjiAewXjsLxRQeuLvvoNqcstVho25JU1x+1g/zgVrFUN3c2ljmUQer
   gH3o6pdHytQSUeXo2oVw798qreEOCJNAb904o99Jz+YFaxz+4JgEdv8L/
   qXrBpqvd38FYNNfcghhyKjrRKtfp8aVdbtsfo8VeNh/hdEIggvngh48aW
   w5bnMdQpCgrU3DlC62G+SizSeo9BuPsTd5h39GwJQV+EYTs1lAnPtBjUw
   vpu/gwelJa1ytB23Id+crxSf9SzJ0enqz3trXs7MldTZ03XcZ7lHBLTv4
   g==;
X-CSE-ConnectionGUID: wN62j8SwSJyUcCxXpwTOlw==
X-CSE-MsgGUID: qXZYHRTnT06CuHoJ6rHI6Q==
X-IronPort-AV: E=Sophos;i="6.10,241,1719849600"; 
   d="scan'208";a="27426777"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2024 16:43:55 +0800
IronPort-SDR: 66ebd61c_85py7IKN2EaVDuEmGC2Tj7lNKwioe/SazL9MCVd517bc+7A
 k7c+68TxLrCHMM0e4xrhilDVZn6Sr8fByse0m1g==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Sep 2024 00:43:25 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Sep 2024 01:43:54 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3] scsi: ufs: Zero utp_upiu_req at the beginning of each command
Date: Thu, 19 Sep 2024 11:41:55 +0300
Message-Id: <20240919084155.17004-1-avri.altman@wdc.com>
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

Signed-off-by: Avri Altman <avri.altman@wdc.com>

---
Changes in v3:
 - initialize *ucd_req_ptr once (Bart)

Changes in v2:
 - Simplify things (Bart)
---
 drivers/ufs/core/ufshcd.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8ea5a82503a9..ddd0f9892c29 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2761,7 +2761,6 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u8 upiu_flags)
 	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(cmd->sdb.length);
 
 	cdb_len = min_t(unsigned short, cmd->cmd_len, UFS_CDB_SIZE);
-	memset(ucd_req_ptr->sc.cdb, 0, UFS_CDB_SIZE);
 	memcpy(ucd_req_ptr->sc.cdb, cmd->cmnd, cdb_len);
 
 	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
@@ -2864,6 +2863,27 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
 }
 
+static void __ufshcd_setup_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
+			     struct scsi_cmnd *cmd, u8 lun, int tag)
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
+	__ufshcd_setup_cmd(hba, lrbp, cmd, lun, tag);
+	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba);
+	lrbp->req_abort_skip = false;
+
+	ufshcd_comp_scsi_upiu(hba, lrbp);
+}
+
 /**
  * ufshcd_upiu_wlun_to_scsi_wlun - maps UPIU W-LUN id to SCSI W-LUN ID
  * @upiu_wlun_id: UPIU W-LUN id
@@ -2997,16 +3017,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
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
@@ -3034,11 +3046,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 static void ufshcd_setup_dev_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 			     enum dev_cmd_type cmd_type, u8 lun, int tag)
 {
-	lrbp->cmd = NULL;
-	lrbp->task_tag = tag;
-	lrbp->lun = lun;
+	__ufshcd_setup_cmd(hba, lrbp, NULL, lun, tag);
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
-	ufshcd_prepare_lrbp_crypto(NULL, lrbp);
 	hba->dev_cmd.type = cmd_type;
 }
 
-- 
2.25.1

