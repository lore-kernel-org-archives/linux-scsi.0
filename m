Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8527A13A89C;
	Mon, 15 Jul 2024 06:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721025523; cv=none; b=Q0Bp5A2RtCIoRxJl/OrfKoMEoiNpyTUnRxHSSmSdC2S1wVG8AW8na0LBmEbit2a7X6xs9G7r2JUi5lbR5jYmG6KShwSYUfzdnQ+r6taeceDrkWLezUPxV6BnBZB/qwEbzq9TG7Tu33rujyahEgzeuqyc5GKtyQGIXGRON4c8EP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721025523; c=relaxed/simple;
	bh=/SgEi/cPw5Y2Z5O/uOQS46UkRrzoVC7aDgUBSthupkY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EvgF9fute/q+R0skPPrc4M/wBjvFwXLbcKOzLGjjV+H/CoC/ztORbQHglYdNCHY6MOeZwmPKQxEtfA5HUXs+WtoCFGu6xcwEyQod7MZATgSa2aHnfUrBGXPjNGA3byvQsO5ZpSaXKpqiK/BqFpTB18Kb4vbD2P+AZO9MV0736RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rrSlfgOI; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rrSlfgOI"
X-UUID: da29933e427411ef87684b57767b52b1-20240715
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Ux42MBhKvUi2fk9gzCfspVLZvKyc5prnYP9PyQvj1VU=;
	b=rrSlfgOI1ExCwkygG4QS7v8yhVCUm1NpKOoMkzo2f0/WQ8aGLB+RR2CsRIVl6JO33jC7uPLbw7+mRzWlF6Jw1nIt1NVJUcdWTFO2m4haicYMPc6rnm8fL+2ZMHsQh709fzdkGbMjDHM3OHJQohK2Aj7jbiRW83ACK2OY8Vg9wj4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:48728659-8bd8-4264-a263-c7c0fa40ba2c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:3acb7cd1-436f-4604-ad9d-558fa44a3bbe,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: da29933e427411ef87684b57767b52b1-20240715
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1973392370; Mon, 15 Jul 2024 14:38:31 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 15 Jul 2024 14:38:32 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 15 Jul 2024 14:38:32 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <chu.stanley@gmail.com>, <huobean@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH v2] ufs: core: fix deadlock when rtc update
Date: Mon, 15 Jul 2024 14:38:31 +0800
Message-ID: <20240715063831.29792-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

There is a deadlock when runtime suspend waits for the flush of RTC work,
and the RTC work calls ufshcd_rpm_get_sync to wait for runtime resume.

Here is deadlock backtrace
kworker/0:1     D 4892.876354 10 10971 4859 0x4208060 0x8 10 0 120 670730152367
ptr            f0ffff80c2e40000 0 1 0x00000001 0x000000ff 0x000000ff 0x000000ff
<ffffffee5e71ddb0> __switch_to+0x1a8/0x2d4
<ffffffee5e71e604> __schedule+0x684/0xa98
<ffffffee5e71ea60> schedule+0x48/0xc8
<ffffffee5e725f78> schedule_timeout+0x48/0x170
<ffffffee5e71fb74> do_wait_for_common+0x108/0x1b0
<ffffffee5e71efe0> wait_for_completion+0x44/0x60
<ffffffee5d6de968> __flush_work+0x39c/0x424
<ffffffee5d6decc0> __cancel_work_sync+0xd8/0x208
<ffffffee5d6dee2c> cancel_delayed_work_sync+0x14/0x28
<ffffffee5e2551b8> __ufshcd_wl_suspend+0x19c/0x480
<ffffffee5e255fb8> ufshcd_wl_runtime_suspend+0x3c/0x1d4
<ffffffee5dffd80c> scsi_runtime_suspend+0x78/0xc8
<ffffffee5df93580> __rpm_callback+0x94/0x3e0
<ffffffee5df90b0c> rpm_suspend+0x2d4/0x65c
<ffffffee5df91448> __pm_runtime_suspend+0x80/0x114
<ffffffee5dffd95c> scsi_runtime_idle+0x38/0x6c
<ffffffee5df912f4> rpm_idle+0x264/0x338
<ffffffee5df90f14> __pm_runtime_idle+0x80/0x110
<ffffffee5e24ce44> ufshcd_rtc_work+0x128/0x1e4
<ffffffee5d6e3a40> process_one_work+0x26c/0x650
<ffffffee5d6e65c8> worker_thread+0x260/0x3d8
<ffffffee5d6edec8> kthread+0x110/0x134
<ffffffee5d616b18> ret_from_fork+0x10/0x20

Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
Cc: <stable@vger.kernel.org> 6.9.x

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd-priv.h | 5 +++++
 drivers/ufs/core/ufshcd.c      | 5 ++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index f42d99ce5bf1..81d6f0cfb148 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -329,6 +329,11 @@ static inline int ufshcd_rpm_get_sync(struct ufs_hba *hba)
 	return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
 }
 
+static inline int ufshcd_rpm_get_if_active(struct ufs_hba *hba)
+{
+	return pm_runtime_get_if_active(&hba->ufs_device_wlun->sdev_gendev);
+}
+
 static inline int ufshcd_rpm_put_sync(struct ufs_hba *hba)
 {
 	return pm_runtime_put_sync(&hba->ufs_device_wlun->sdev_gendev);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 46433ecf0c4d..2e5adfa0f757 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8171,7 +8171,10 @@ static void ufshcd_update_rtc(struct ufs_hba *hba)
 	 */
 	val = ts64.tv_sec - hba->dev_info.rtc_time_baseline;
 
-	ufshcd_rpm_get_sync(hba);
+	/* Skip update RTC if RPM state is not RPM_ACTIVE */
+	if (ufshcd_rpm_get_if_active(hba) <= 0)
+		return;
+
 	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR, QUERY_ATTR_IDN_SECONDS_PASSED,
 				0, 0, &val);
 	ufshcd_rpm_put_sync(hba);
-- 
2.18.0

