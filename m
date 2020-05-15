Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCDAC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 14:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F18A2078C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 14:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgEOORq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 10:17:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4790 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbgEOORq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 May 2020 10:17:46 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id ADF4730F2C92631CD838;
        Fri, 15 May 2020 22:17:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 15 May 2020 22:17:36 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 1/4] scsi: hisi_sas: Do not reset phy timer to wait for stray phyup
Date:   Fri, 15 May 2020 22:13:42 +0800
Message-ID: <1589552025-165012-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1589552025-165012-1-git-send-email-john.garry@huawei.com>
References: <1589552025-165012-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

We found out that after phy up, the hardware report another oob interrupt,
but did not follow a phy up interrupt:

oob ready -> phy up -> DEV found -> oob read -> wait phy up -> timeout

We run link reset when wait phy up timeout, and it make a normal disk into
reset processing. So we made some circumvention action in the code, so that
this abnormal oob interrupt will not start the timer to wait for phy up.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9a6deb21fe4d..11caa4b0d797 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -898,8 +898,11 @@ void hisi_sas_phy_oob_ready(struct hisi_hba *hisi_hba, int phy_no)
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct device *dev = hisi_hba->dev;
 
+	dev_dbg(dev, "phy%d OOB ready\n", phy_no);
+	if (phy->phy_attached)
+		return;
+
 	if (!timer_pending(&phy->timer)) {
-		dev_dbg(dev, "phy%d OOB ready\n", phy_no);
 		phy->timer.expires = jiffies + HISI_SAS_WAIT_PHYUP_TIMEOUT * HZ;
 		add_timer(&phy->timer);
 	}
-- 
2.16.4

