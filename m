Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09ED1C69C;
	Sun, 15 Sep 2024 07:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726386641; cv=none; b=MdE4p3fwhn3+hGuyQV+UyuGpm+wXFZKhz1MbcocwSJ/x+E2cMc/ZbH/47OzLoduHmzr9zXGhxg9fNcDyVva5gsKa+9h1wOaRPHXawPVy4JCarUiRypTfoc6768u3qKWbnIUqSbMxN553HEizJrsaqmJCFfTcA+WQKPqdZB/ye9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726386641; c=relaxed/simple;
	bh=lLr9bdWkckgYhAIUM9LylQ1iK/DbmLn2UfjaZur6YMg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SyXB+IMxAS6Bu0OTuiRS39RdQzoCiuPyL6Qh9qol8VM32NFgZw/Lo/ucgqHEpYChILSQanymf3txJnLsYJlNYB6GRBjXwGFAd63Wgld7280L1wsqMxX6NH0v1sHJmYjettf9mrhhBEkcfQPBYhK/cYjE7Krcz8m3kNB/e5yh8/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kxyTxuYw; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kxyTxuYw"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726386639; x=1757922639;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lLr9bdWkckgYhAIUM9LylQ1iK/DbmLn2UfjaZur6YMg=;
  b=kxyTxuYwp5J1hFKlHKqAHrvH8bu6fpFGRdNOtdiB/t7XgwQjzVwEIceO
   aQhqvxhj/YWuisG0o9Ze65V7lxyHwNj7e2p/U7oPmTX06ecqHiPIiQkAw
   c3q9SwtibFWyQ6R661MZsRFa2M9W6y7ueKREUe3s3iGq4G7/xJJYOYSND
   07fA4SdAEF2Rb3DyQNqnj/NCyBDn4bbEjAcVjbeAvuj8nUZB97NVQx8rt
   GokryM9EqZlc1hkftcvSYvs8lwSze6eUDN+y/ekt3alcRFU+lF2waaplk
   TEiwVc4HlCRYhsZNrbSvCxYdXPV9IKKmKtHqhyEwN+x5hJjobbLGRYtMd
   A==;
X-CSE-ConnectionGUID: WHpMz4WHSaeyPa+zjef7LA==
X-CSE-MsgGUID: oFi29HRoSomU/744LwByVg==
X-IronPort-AV: E=Sophos;i="6.10,230,1719849600"; 
   d="scan'208";a="27540762"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Sep 2024 15:50:32 +0800
IronPort-SDR: 66e684e5_iI1xTiBCs83ttupI/Ur+jbipuA5i8SLEbm8I7zCPD2VFYp9
 A2gPRRy/+IeUPUJLzvWoTfv6rvxU1E0iHnM61Aw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Sep 2024 23:55:33 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Sep 2024 00:50:32 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2] scsi: ufs: Zero utp_upiu_req at the beginning of each command
Date: Sun, 15 Sep 2024 10:48:42 +0300
Message-Id: <20240915074842.4111336-1-avri.altman@wdc.com>
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

Signed-off-by: Avri Altman <avri.altman@wdc.com>

---
Changes in v2:
 - Simplify things (Bart)
---
 drivers/ufs/core/ufshcd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8ea5a82503a9..1f6575afc1c5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2761,7 +2761,6 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u8 upiu_flags)
 	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(cmd->sdb.length);
 
 	cdb_len = min_t(unsigned short, cmd->cmd_len, UFS_CDB_SIZE);
-	memset(ucd_req_ptr->sc.cdb, 0, UFS_CDB_SIZE);
 	memcpy(ucd_req_ptr->sc.cdb, cmd->cmnd, cdb_len);
 
 	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
@@ -2834,6 +2833,8 @@ static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
 	u8 upiu_flags;
 	int ret = 0;
 
+	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
+
 	ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags, DMA_NONE, 0);
 
 	if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
@@ -2858,6 +2859,8 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	unsigned int ioprio_class = IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
 	u8 upiu_flags;
 
+	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
+
 	ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags, lrbp->cmd->sc_data_direction, 0);
 	if (ioprio_class == IOPRIO_CLASS_RT)
 		upiu_flags |= UPIU_CMD_FLAGS_CP;
@@ -7165,6 +7168,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	ufshcd_setup_dev_cmd(hba, lrbp, cmd_type, 0, tag);
 
+	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
+
 	ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags, DMA_NONE, 0);
 
 	/* update the task tag in the request upiu */
@@ -7317,6 +7322,8 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 
 	ufshcd_setup_dev_cmd(hba, lrbp, DEV_CMD_TYPE_RPMB, UFS_UPIU_RPMB_WLUN, tag);
 
+	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
+
 	ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags, DMA_NONE, ehs);
 
 	/* update the task tag */
-- 
2.25.1

