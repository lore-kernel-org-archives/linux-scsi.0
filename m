Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD9ABA34
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2025 08:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758615725; cv=none; b=QrCQJn/1yQZj2wn8i4jU8xgwMKLkEJQE4rE0u787n4lzecjVzqduYh/8CFlgK6sLMQsaO61C1D9RtPX4aqsgsinlLuHJgCsML7nuZcJNGY8h00ZZljm0r8Xr2hSU1blZVhFeQkOxyL11SrGcChs4Rewu1GYHRyFbfhbQ3geNrU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758615725; c=relaxed/simple;
	bh=m2NxzuCT8yEJuD8PRr/IvAeYM/MWpE7SR9YjT+Rk2Z0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=M9ThvM7b1RD9j8/ithp0WwGWJdiOXBE2tGs/XfSb6A6cjKjem+YaWqk3e8Ck+pPmFSD7qdQvsW2UXrRqLWzc+BFu7O+E03RbXZH1U96LBnEq/a9406lW7fJzyCcoMiRyS/INiIqEFLZ6V+XIIVho4WlZvFXFCDci236iLGfF0CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=FtW8NTLH; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="FtW8NTLH"
X-UUID: 5a6e6190985611f0b33aeb1e7f16c2b6-20250923
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=HR4kzmV/LEaTa3hngEfRhjuk6ILuJiKVoLiLmmgCLIE=;
	b=FtW8NTLH95iXXpeZkS9tC6XFz9Lr+JnGPK/DiRdhRzDZ14FuqAoglMawJ4i/N02XPAvwbsKEbenOfyPolP9fpe+YcJoOzHYLw54MI/2rR0QzVWwy6uD67aDNpxp60/hk9RmrQUrGZ3Iz8FoG9dUfyWraoFvM18DJU7fMHe6bx2g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:a094d803-b036-45ce-8a06-1ec84868e3e2,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:1ca6b93,CLOUDID:67c398f8-ebfe-43c9-88c9-80cb93f22ca4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|836|888|898,TC:-5,Content:0|15|5
	0,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5a6e6190985611f0b33aeb1e7f16c2b6-20250923
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 378425524; Tue, 23 Sep 2025 16:21:50 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 23 Sep 2025 16:21:48 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Tue, 23 Sep 2025 16:21:48 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1] ufs: core: Fix runtime suspend error deadlock
Date: Tue, 23 Sep 2025 16:20:58 +0800
Message-ID: <20250923082147.2491450-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
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

Resolve the deadlock issue during runtime suspend when an
error triggers the error handler. Prevent the deadlock
by checking pm_op_in_progress and performing a quick recovery.
This approach ensures that the error handler does not wait
indefinitely for runtime PM to resume, allowing runtime
suspend to proceed smoothly.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 88a0e9289ca6..0735bd5df1cc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6681,6 +6681,11 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	if (hba->pm_op_in_progress) {
+		ufshcd_link_recovery(hba);
+		return;
+	}
+
 	ufshcd_err_handling_prepare(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-- 
2.45.2

