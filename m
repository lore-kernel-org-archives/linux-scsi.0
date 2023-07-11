Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BC7C001DD
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 02:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjGKCom (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jul 2023 22:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjGKCoj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2023 22:44:39 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E88E49
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 19:44:38 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4R0Q9t1kykztR9l;
        Tue, 11 Jul 2023 10:41:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 11 Jul 2023 10:44:35 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        Yihang Li <liyihang9@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 3/3] scsi: hisi_sas: Delete unused lock in hisi_sas_port_notify_formed()
Date:   Tue, 11 Jul 2023 11:15:00 +0800
Message-ID: <1689045300-44318-4-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1689045300-44318-1-git-send-email-chenxiang66@hisilicon.com>
References: <1689045300-44318-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yihang Li <liyihang9@huawei.com>

Currently spinlock hisi_hba->lock is used by interrupt and thread together
which require to use spin_lock_irqsave/spin_unlcok_irqrestore, but some
places still use spin_lock/unlock.
Check with the code and find there is no necessary to use hisi_hba->lock
in function hisi_sas_port_notify_formed() which is the only place that
use spinlock in interrupt. So delete unused lock in
hisi_sas_port_notify_formed().

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 8f22ece..7a62590 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1065,23 +1065,18 @@ EXPORT_SYMBOL_GPL(hisi_sas_phy_enable);
 
 static void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy)
 {
-	struct sas_ha_struct *sas_ha = sas_phy->ha;
-	struct hisi_hba *hisi_hba = sas_ha->lldd_ha;
 	struct hisi_sas_phy *phy = sas_phy->lldd_phy;
 	struct asd_sas_port *sas_port = sas_phy->port;
 	struct hisi_sas_port *port;
-	unsigned long flags;
 
 	if (!sas_port)
 		return;
 
 	port = to_hisi_sas_port(sas_port);
-	spin_lock_irqsave(&hisi_hba->lock, flags);
 	port->port_attached = 1;
 	port->id = phy->port_id;
 	phy->port = port;
 	sas_port->lldd_port = port;
-	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 }
 
 static void hisi_sas_do_release_task(struct hisi_hba *hisi_hba, struct sas_task *task,
-- 
2.8.1

