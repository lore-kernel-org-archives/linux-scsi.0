Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185ADC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Dec 2022 12:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiLUMgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Dec 2022 07:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiLUMf7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2022 07:35:59 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1390B63BB
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 04:35:51 -0800 (PST)
X-UUID: 8fe2169f3040466db1ee99ab31df73f7-20221221
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=sKAkC8LWfN/jcdcvoGUk3sUZ7DVsqrt4wsD3pihgPRI=;
        b=WXyCEng8a784DBlL5JlYj3Zcfc/nvDyZv+dNdj4sc7BS1/Quyao+4d9V06m5YzR4YIMqofIz5dRbfumkR3A1RFvRmVO35ATGXHryAw1KaWYuGSjU40l4inWLLtRH43QCUGPB59+sAUt0Pg1RW2N+hEgIe+pszAcayf2HRd/WyTo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:aa5be2b1-6028-4e0a-9a85-ee34ad824304,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:95
X-CID-INFO: VERSION:1.1.14,REQID:aa5be2b1-6028-4e0a-9a85-ee34ad824304,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTION
        :quarantine,TS:95
X-CID-META: VersionHash:dcaaed0,CLOUDID:48c790f3-ff42-4fb0-b929-626456a83c14,B
        ulkID:221221203543GFGRXSST,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 8fe2169f3040466db1ee99ab31df73f7-20221221
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1333923163; Wed, 21 Dec 2022 20:35:41 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 21 Dec 2022 20:35:40 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 21 Dec 2022 20:35:40 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>
Subject: [PATCH v1] ufs: core: wlun resume SSU(Acitve) fail recovery
Date:   Wed, 21 Dec 2022 20:35:37 +0800
Message-ID: <20221221123537.30148-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

When wlun resume SSU(Active) timeout, scsi try eh_host_reset_handler.
But ufshcd_eh_host_reset_handler hang at wait flush_work(&hba->eh_work).
And ufshcd_err_handler hang at wait rpm resume.
Do link recovery only in this case. Below is IO hang stack dump.

<ffffffdd78e02b34> schedule+0x110/0x204
<ffffffdd78e0be60> schedule_timeout+0x98/0x138
<ffffffdd78e040e8> wait_for_common_io+0x130/0x2d0
<ffffffdd77d6a000> blk_execute_rq+0x10c/0x16c
<ffffffdd78126d90> __scsi_execute+0xfc/0x278
<ffffffdd7813891c> ufshcd_set_dev_pwr_mode+0x1c8/0x40c
<ffffffdd78137d1c> __ufshcd_wl_resume+0xf0/0x5cc
<ffffffdd78137ae0> ufshcd_wl_runtime_resume+0x40/0x18c
<ffffffdd78136108> scsi_runtime_resume+0x88/0x104
<ffffffdd7809a4f8> __rpm_callback+0x1a0/0xaec
<ffffffdd7809b624> rpm_resume+0x7e0/0xcd0
<ffffffdd7809a788> __rpm_callback+0x430/0xaec
<ffffffdd7809b644> rpm_resume+0x800/0xcd0
<ffffffdd780a0778> pm_runtime_work+0x148/0x198

<ffffffdd78e02b34> schedule+0x110/0x204
<ffffffdd78e0be10> schedule_timeout+0x48/0x138
<ffffffdd78e03d9c> wait_for_common+0x144/0x2dc
<ffffffdd7758bba4> __flush_work+0x3d0/0x508
<ffffffdd7815572c> ufshcd_eh_host_reset_handler+0x134/0x3a8
<ffffffdd781216f4> scsi_try_host_reset+0x54/0x204
<ffffffdd78120594> scsi_eh_ready_devs+0xb30/0xd48
<ffffffdd7812373c> scsi_error_handler+0x260/0x874

<ffffffdd78e02b34> schedule+0x110/0x204
<ffffffdd7809af64> rpm_resume+0x120/0xcd0
<ffffffdd7809fde8> __pm_runtime_resume+0xa0/0x17c
<ffffffdd7815193c> ufshcd_err_handling_prepare+0x40/0x430
<ffffffdd7814cce8> ufshcd_err_handler+0x1c4/0xd4c

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e18c9f4463ec..5aaffd13e132 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7363,9 +7363,27 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 	int err = SUCCESS;
 	unsigned long flags;
 	struct ufs_hba *hba;
+	struct device *dev;
 
 	hba = shost_priv(cmd->device->host);
 
+	/*
+	 * If __ufshcd_wl_suspend get fail and runtime_status = RPM_RESUMING,
+	 * do link recovery only. Because schedule eh work will get dead lock
+	 * in ufshcd_rpm_get_sync to wait wlun resume, but wlun resume get
+	 * error and wait eh work finish.
+	 */
+	dev = &hba->sdev_ufs_device->sdev_gendev;
+	if (dev->power.runtime_status == RPM_RESUMING) {
+		err = ufshcd_link_recovery(hba);
+		if (err) {
+			dev_err(hba->dev, "WL Device PM: status:%d, err:%d\n",
+				dev->power.runtime_status,
+				dev->power.runtime_error);
+		}
+		return err;
+	}
+
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->force_reset = true;
 	ufshcd_schedule_eh_work(hba);
-- 
2.18.0

