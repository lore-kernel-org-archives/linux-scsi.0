Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC2F86329
	for <linux-scsi@vger.kernel.org>; Thu, 16 Oct 2025 02:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760582120; cv=none; b=uuI15IiZkw38CD59JGTrJPVoGGa+AK7xRtRtQPX0DbhJSyZG0oaSmIfeE5uaTvEwLCQZKWXJns4lw6X+gGoz51/2MJyjSHmTO6z/pOA123x/I3lBFzbD1aGL/Ysyo1adha83YyFiZ47EeN4Dt+zpNWqmldCK9hCc8s5uLVhIqI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760582120; c=relaxed/simple;
	bh=xq9UGcZtcBm7X6XQUsvjodL9sN4bxo9YTGrFBxB3LBk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JT3aApLGnITRBA3EHFET9bhgXXnleFP5Qe+REbX44vSi2YT1azfS+AHztEmDSP3obW4TTR30AZkPKckJ+A6cyVIm6QyGha+zpI3X2yaI451xGQC6AH4bDW4BWLKOQsPOogCcgJdLqy6bDRNZW/YxTif3ZcpbA7NoAXtoc/uexK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=DtMcBXnW; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DtMcBXnW"
X-UUID: bc79230eaa3811f0b33aeb1e7f16c2b6-20251016
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=LpMbLrFO3xrtqtbWYAE6PugpJegq2buyMLaZMm5tQjM=;
	b=DtMcBXnWC6cJiFCgIZGDKIP1F9BKJ6d0tbN62JpaBGJA/UqXo//Ku2D06i/OX4m/Shg1vESGNOF2tvICJkJuV+bjj3I2hbi0Y1bv8wz4QGWFVYAoVieokq2Vibw5fA1wxfcOpZ18M9/yWNQxwpFWCV2njDeNrbUwp/wdga4ovzc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:78ee2f38-6525-4f38-994f-baf9a787b1a1,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:a9d874c,CLOUDID:62907002-eaf8-4c8c-94de-0bc39887e077,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bc79230eaa3811f0b33aeb1e7f16c2b6-20251016
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1414249278; Thu, 16 Oct 2025 10:35:10 +0800
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
Subject: [PATCH v2 2/2] ufs: core: support dumping CQ entry in MCQ Mode
Date: Thu, 16 Oct 2025 10:32:32 +0800
Message-ID: <20251016023507.1000664-3-peter.wang@mediatek.com>
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

Enhance the ufshcd_print_tr function to support dumping
completion queue (CQ) entries in MCQ mode when an error occurs.
This addition provides more detailed debugging information
by including the CQ entry data in the error logs, aiding
in the diagnosis of issues in MCQ mode.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d779cc777a17..c7d28d87ad85 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5535,8 +5535,11 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 	} /* end of switch */
 
 	if ((host_byte(result) != DID_OK) &&
-	    (host_byte(result) != DID_REQUEUE) && !hba->silence_err_logs)
+	    (host_byte(result) != DID_REQUEUE) && !hba->silence_err_logs) {
+		if (cqe)
+			ufshcd_hex_dump("UPIU CQE: ", cqe, sizeof(struct cq_entry));
 		ufshcd_print_tr(hba, lrbp->task_tag, true);
+	}
 	return result;
 }
 
-- 
2.45.2

