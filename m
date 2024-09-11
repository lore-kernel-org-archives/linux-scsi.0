Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C461418641;
	Wed, 11 Sep 2024 05:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726033314; cv=none; b=KVY9cn6kTaZ/qNjxuN3mlNgP8ol/Ro8vJdmJeDVGPNnEWJdELWCJq3jI2su/Qk9OPJJv+VBtYe1DMHSKcfqf/lis4MHGccOl6CPKr+Zrv9Vpvrxcqmfed60biWjSiMvF45gnca9pTLfWY9pkuG0bFDiJ67jeLTCGsM+qVx8muGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726033314; c=relaxed/simple;
	bh=XgrWzxebU+d3++6PTNXiYZ14weJ0eapT+x2fvHGkz7Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gVAl52yCPbcsbREF/pMd/msZsaJIRn9WM390rYK0n9xuQHHDVvVEQxgkdnSfHZc6z5ubEUjPYbw3Rrk/z8ihlUraIaf+/RARmeZo8neZN07RkbgZsAjCwXteFMwTf7yYJ2XhYXP/domx0/LPMY7CFevI3REOCe6Me6CUJeSW3FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ME0IxlYh; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ME0IxlYh"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726033311; x=1757569311;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XgrWzxebU+d3++6PTNXiYZ14weJ0eapT+x2fvHGkz7Y=;
  b=ME0IxlYhjPfND4wjD9ZYEyFr+emX6sYSCbTvmSIw1Gtvwxdato8LKRhC
   gXsZSsrqstS9yRzmDm5ty2BEJ8ibvwO2rdGgvZ8f3BMoJpMeJXYSEeraU
   SIAddq8n05KXH28FU3kweMmN5n/jFDve/HGWj2SYZxgaQ2IppHlH6JeOz
   NV0xGBQ6ZLhN+NVM8RNyRTYjCKZIoBNeLKPO6EVwgujCE3tMa+a8CYbdC
   xfzsUi8GqnFjmtf7AARYMr9h7btE6DPKPCzLmOgbOpIEUSbBXCh2O2xuw
   2T43L0Ii4CduvSxknn7Pe0/A9mWsFsdKeYHBsYvntm1LfKZPL53SDM8uP
   g==;
X-CSE-ConnectionGUID: CYy/QLHzQneWJExG4uEvcA==
X-CSE-MsgGUID: VknJoOkAQ+e1Efd1GETmUA==
X-IronPort-AV: E=Sophos;i="6.10,219,1719849600"; 
   d="scan'208";a="26787824"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Sep 2024 13:41:43 +0800
IronPort-SDR: 66e11f72_msdi3LRROnnmQ47FihvpsEFtBn9E7ELLEB7r24hlB7+yO7x
 Tx2RoacIjY8bW4SR4Ym3rv+OXaxjWxP871B5ixw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Sep 2024 21:41:22 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Sep 2024 22:41:41 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs: Zero utp_upiu_req at the beginning of each command
Date: Wed, 11 Sep 2024 08:39:51 +0300
Message-Id: <20240911053951.4032533-1-avri.altman@wdc.com>
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

No changes to  struct utp_upiu_req memory layout: not its size nor
cacheline usage.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c        | 14 +++++++++++++-
 include/uapi/scsi/scsi_bsg_ufs.h | 12 +++++++-----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8ea5a82503a9..0f7ad1acfda0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2735,6 +2735,11 @@ ufshcd_prepare_req_desc_hdr(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 	req_desc->prd_table_length = 0;
 }
 
+static void zero_utp_upiu(struct utp_upiu_req *req)
+{
+	memset(&req->utp_upiu, 0, sizeof(req->utp_upiu));
+}
+
 /**
  * ufshcd_prepare_utp_scsi_cmd_upiu() - fills the utp_transfer_req_desc,
  * for scsi commands
@@ -2758,10 +2763,11 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u8 upiu_flags)
 
 	WARN_ON_ONCE(ucd_req_ptr->header.task_tag != lrbp->task_tag);
 
+	zero_utp_upiu(ucd_req_ptr);
+
 	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(cmd->sdb.length);
 
 	cdb_len = min_t(unsigned short, cmd->cmd_len, UFS_CDB_SIZE);
-	memset(ucd_req_ptr->sc.cdb, 0, UFS_CDB_SIZE);
 	memcpy(ucd_req_ptr->sc.cdb, cmd->cmnd, cdb_len);
 
 	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
@@ -2795,6 +2801,8 @@ static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
 				0,
 	};
 
+	zero_utp_upiu(ucd_req_ptr);
+
 	/* Copy the Query Request buffer as is */
 	memcpy(&ucd_req_ptr->qr, &query->request.upiu_req,
 			QUERY_OSF_SIZE);
@@ -7170,6 +7178,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	/* update the task tag in the request upiu */
 	req_upiu->header.task_tag = tag;
 
+	zero_utp_upiu(lrbp->ucd_req_ptr);
+
 	/* just copy the upiu request as it is */
 	memcpy(lrbp->ucd_req_ptr, req_upiu, sizeof(*lrbp->ucd_req_ptr));
 	if (desc_buff && desc_op == UPIU_QUERY_OPCODE_WRITE_DESC) {
@@ -7322,6 +7332,8 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 	/* update the task tag */
 	req_upiu->header.task_tag = tag;
 
+	zero_utp_upiu(lrbp->ucd_req_ptr);
+
 	/* copy the UPIU(contains CDB) request as it is */
 	memcpy(lrbp->ucd_req_ptr, req_upiu, sizeof(*lrbp->ucd_req_ptr));
 	/* Copy EHS, starting with byte32, immediately after the CDB package */
diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
index 8c29e498ef98..b0d60d54d6c9 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -162,11 +162,13 @@ struct utp_upiu_cmd {
  */
 struct utp_upiu_req {
 	struct utp_upiu_header header;
-	union {
-		struct utp_upiu_cmd		sc;
-		struct utp_upiu_query		qr;
-		struct utp_upiu_query		uc;
-	};
+	struct_group(utp_upiu,
+		union {
+			struct utp_upiu_cmd	sc;
+			struct utp_upiu_query	qr;
+			struct utp_upiu_query	uc;
+		};
+	);
 };
 
 struct ufs_arpmb_meta {
-- 
2.25.1

