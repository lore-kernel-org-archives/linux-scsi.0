Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AD2212566
	for <linux-scsi@vger.kernel.org>; Thu, 16 Oct 2025 02:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760582121; cv=none; b=FclGhL4N402Bhn01g8txFapObinxGB6EsFwFPhMo7BlYa1YIiNqXYSC84y8nzTvGCOyfli9qoLMcjFEBm5pcOcd63aLXUFsObWTr8wKMXZ38oFUkAygPViNwDCZ8lRtonci/loYiJZHAkTEQAV27MWCryilG4CXo7E6azEWrvw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760582121; c=relaxed/simple;
	bh=2RHwtLkHPvZtmXaq37EQkxkIA5vZRBJ19h9DSoKjghw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g4R3vUlQ74nwhWe7mPA2dKcjOcm8pH7KQVdyTo/F0XlBo1SwHSYlOWSCTdr1YEolAuYw7jfmC5ApKDIaUlzhnx7ap+yjFpiEk7m8Xv86JtJ/erfwRqTj2TPkMZLlP4WgRPmPk732z3pSpAlgdf5JIXMIRT4gYDo+LIxuGg2Kt3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=UN9w5Gvb; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="UN9w5Gvb"
X-UUID: bc75d32aaa3811f0b33aeb1e7f16c2b6-20251016
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=qgNriODO1u0bE0yabnIx47Jb530Z96AnvhCm/17Ey64=;
	b=UN9w5GvbmMflIgz87jJ6SyVHY98wCBxz6frbokwCQaeIGGbbHPyYszCB1yZnVp3L9duL0ytUmenQnyn1/SWddtWyh5w6+s5lcfIzTQFwSzeSmJoRPQETmuwSoMmliBogHQh33l5NQqObeXrdjATdmxxpfX6MeAtxDN5m5Ai/1og=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:7a7cfbb0-f805-4105-9c64-acf5dec832e3,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:a9d874c,CLOUDID:c3af4386-2e17-44e4-a09c-1e463bf6bc47,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bc75d32aaa3811f0b33aeb1e7f16c2b6-20251016
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 177711493; Thu, 16 Oct 2025 10:35:10 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Thu, 16 Oct 2025 10:35:08 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Thu, 16 Oct 2025 10:35:08 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<qilin.tan@mediatek.com>, <lin.gui@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v2 1/2] ufs: core: update CQ Entry to UFS 4.1 format
Date: Thu, 16 Oct 2025 10:32:31 +0800
Message-ID: <20251016023507.1000664-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251016023507.1000664-1-peter.wang@mediatek.com>
References: <20251016023507.1000664-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Update the completion queue (CQ) entry format with UFS 4.1
specifications. UFS 4.1 introduces new members in reserved
record DW5. This patch also refines the DW4 with detailed
members defined in UFS 4.0. Modify the code to
incorporate these changes by updating the overall_status
in the CQ entry structure.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c |  4 ++--
 include/ufs/ufshci.h      | 22 +++++++++++++++++++---
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ff7a3d60b11d..d779cc777a17 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -858,7 +858,7 @@ static enum utp_ocs ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp,
 				      struct cq_entry *cqe)
 {
 	if (cqe)
-		return le32_to_cpu(cqe->status) & MASK_OCS;
+		return cqe->overall_status & MASK_OCS;
 
 	return lrbp->utr_descriptor_ptr->header.ocs & MASK_OCS;
 }
@@ -5643,7 +5643,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 		scsi_done(cmd);
 	} else {
 		if (cqe) {
-			ocs = le32_to_cpu(cqe->status) & MASK_OCS;
+			ocs = cqe->overall_status & MASK_OCS;
 			lrbp->utr_descriptor_ptr->header.ocs = ocs;
 		}
 		complete(&hba->dev_cmd.complete);
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 612500a7088f..fee8f899a569 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -567,10 +567,26 @@ struct cq_entry {
 	__le16  prd_table_offset;
 
 	/* DW 4 */
-	__le32 status;
+	u8 overall_status;
+	u8 extended_error_code;
+	__le16 reserved_1;
 
-	/* DW 5-7 */
-	__le32 reserved[3];
+	/* DW 5 */
+	u8 task_tag;
+	u8 lun;
+#if defined(__BIG_ENDIAN)
+	u8 ext_iid:4;
+	u8 iid:4;
+#elif defined(__LITTLE_ENDIAN)
+	u8 iid:4;
+	u8 ext_iid:4;
+#else
+#error
+#endif
+	u8 reserved_2;
+
+	/* DW 6-7 */
+	__le32 reserved_3[2];
 };
 
 static_assert(sizeof(struct cq_entry) == 32);
-- 
2.45.2

