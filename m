Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D76BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 14:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389126AbiDUOpE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 10:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbiDUOpD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 10:45:03 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810333F31A
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 07:42:09 -0700 (PDT)
X-UUID: a8df91121af0466c97beab265704ecd4-20220421
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.4,REQID:e4af70a6-73d3-481f-bd12-52c19fb819cd,OB:0,LO
        B:0,IP:0,URL:8,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:108
X-CID-INFO: VERSION:1.1.4,REQID:e4af70a6-73d3-481f-bd12-52c19fb819cd,OB:0,LOB:
        0,IP:0,URL:8,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,RULE:Spam_GS981B3D,AC
        TION:quarantine,TS:108
X-CID-META: VersionHash:faefae9,CLOUDID:8ef8a9ef-06b0-4305-bfbf-554bfc9d151a,C
        OID:9ec697a52236,Recheck:0,SF:13|15|28|17|19|48,TC:nil,Content:1,EDM:-3,Fi
        le:nil,QS:0,BEC:nil
X-UUID: a8df91121af0466c97beab265704ecd4-20220421
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1458044442; Thu, 21 Apr 2022 22:42:03 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 21 Apr 2022 22:42:02 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 21 Apr 2022 22:42:02 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <mikebi@micron.com>, <beanhuo@micron.com>
Subject: [PATCH v1] scsi: ufs: fix rpm racing issue
Date:   Thu, 21 Apr 2022 22:41:52 +0800
Message-ID: <20220421144152.23888-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Device WLun may enter RPM_SUSPENDED and the consumer is RPM_ACTIVE.

The error state is
Device Wlun RPM: status:2, usage_count:0
Consumer: 0:0:0:49476 Link: rpm_active:1, RPM: status:2, usage_count:0
Consumer: 0:0:0:49456 Link: rpm_active:1, RPM: status:2, usage_count:0
Consumer: 0:0:0:0 Link: rpm_active:1, RPM: status:2, usage_count:0
Consumer: 0:0:0:1 Link: rpm_active:1, RPM: status:2, usage_count:0
Consumer: 0:0:0:2 Link: rpm_active:1, RPM: status:0, usage_count:0

Because rpm enable before rpm delay set, scsi_autopm_put_device
invoke by scsi_sysfs_add_sdev may cause consumer enter suspend immediately.
Thas will always set rpm_active to 1.
If driver_probe_device invoke pm_runtime_get_suppliers just befor
previous scsi_autopm_put_device, the rpm_active will change to 1
after pm_runtime_put_suppliers.
Set this delay to avoid scsi_autopm_put_device enter suspend immediately.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3f9caafa91bf..1250792d16be 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5024,10 +5024,14 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	 * Block runtime-pm until all consumers are added.
 	 * Refer ufshcd_setup_links().
 	 */
-	if (is_device_wlun(sdev))
+	if (is_device_wlun(sdev)) {
 		pm_runtime_get_noresume(&sdev->sdev_gendev);
-	else if (ufshcd_is_rpm_autosuspend_allowed(hba))
+	} else if (ufshcd_is_rpm_autosuspend_allowed(hba)) {
 		sdev->rpm_autosuspend = 1;
+		pm_runtime_set_autosuspend_delay(&sdev->sdev_gendev,
+			RPM_AUTOSUSPEND_DELAY_MS);
+	}
+
 	/*
 	 * Do not print messages during runtime PM to avoid never-ending cycles
 	 * of messages written back to storage by user space causing runtime
-- 
2.18.0

