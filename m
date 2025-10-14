Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AAC20296A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 13:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760447890; cv=none; b=MOkICU1rOkIbc44f0V47G1j1PweNB3TPaNea0R0PGZN3qUG1P8o1G2SCcU591/G1XuQViYDHDKEn4KvQLTEM+oGKaTz4cHHeFfgwnhcmMuXXuvGY2/U+NBBQply8BqEcWKJBMhFf4RTGsiM3gQF0vZErpCqKL6YogZIIt2jSFKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760447890; c=relaxed/simple;
	bh=8s1KwrYnQoRE7ByXfll4MmvWnXA1IyZVX7cnZlGg2sI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G0J/ZjJEYsdPz6+gL94t7eufCQBqsjCc84gouRF29Ru0tz+fmlFa6+wxDpGxpWENY6eMkpP9vxRnD2QtwTFkzhT+sTU477FuAfuezxTz3nb3xLKu8lVjtrVtaMeObOBdHGqiI7sx4tZ75fo8J39AE12UQLuYi4FsCBgf00EVSKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=mH7M1wNs; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="mH7M1wNs"
X-UUID: 35cd9968a90011f0ae1e63ff8927bad3-20251014
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=b+/W5GqzX/f5jDv4MiVoAwbQFTs/rNKTXRmIxjri/8c=;
	b=mH7M1wNsVq3Hu5og42+L//ge6BNCmRZ8RMLzM/4SCUBzzIzVwQOL0cNQ1Gix8VQIXgMiJ0cGiXSRbri59ivt9P2v/X0ucT6rAmjM7WkF+tIXkQOnRAku0bWumSFCXjB8sBuc0shKbQywMJ5DpsktLLz2azVXhkRahFQZseHj2AM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:8cad5a82-ee4f-4b82-a158-ecccac790f13,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:a9d874c,CLOUDID:d1670c51-c509-4cf3-8dc0-fcdaad49a6d3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 35cd9968a90011f0ae1e63ff8927bad3-20251014
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 998302681; Tue, 14 Oct 2025 21:18:01 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 14 Oct 2025 21:18:00 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Tue, 14 Oct 2025 21:18:00 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<qilin.tan@mediatek.com>, <lin.gui@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v1 1/2] ufs: core: update CQ Entry to UFS 4.1 format
Date: Tue, 14 Oct 2025 21:15:55 +0800
Message-ID: <20251014131758.270324-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251014131758.270324-1-peter.wang@mediatek.com>
References: <20251014131758.270324-1-peter.wang@mediatek.com>
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
 include/ufs/ufshci.h      | 17 +++++++++++++----
 2 files changed, 15 insertions(+), 6 deletions(-)

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
index 612500a7088f..8b14f6e5e6f5 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -567,10 +567,19 @@ struct cq_entry {
 	__le16  prd_table_offset;
 
 	/* DW 4 */
-	__le32 status;
-
-	/* DW 5-7 */
-	__le32 reserved[3];
+	u8 overall_status;
+	u8 extended_error_code;
+	__le16 reserved_1;
+
+	/* DW 5 */
+	u8 task_tag;
+	u8 lun;
+	u8 iid:4;
+	u8 ext_iid:4;
+	u8 reserved_2;
+
+	/* DW 6-7 */
+	__le32 reserved_3[2];
 };
 
 static_assert(sizeof(struct cq_entry) == 32);
-- 
2.45.2

