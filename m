Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877E8C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 12:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A14760E74
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 12:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbhJLMdw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 08:33:52 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3971 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236437AbhJLMdn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 08:33:43 -0400
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HTFLh46pcz67bMk;
        Tue, 12 Oct 2021 20:28:12 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 12 Oct 2021 14:31:39 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 12 Oct 2021 13:31:37 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <yanaijie@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 4/4] scsi: hisi_sas: Disable SATA disk phy for severe I_T nexus reset failure
Date:   Tue, 12 Oct 2021 20:26:28 +0800
Message-ID: <1634041588-74824-5-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1634041588-74824-1-git-send-email-john.garry@huawei.com>
References: <1634041588-74824-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

If the softreset fails in the I_T reset, libsas will then continue to
issue a controller reset to try to recover.

However a faulty disk may cause the softreset to fail, and resetting the
controller will not help this scenario. Indeed, we will just continue the
cycle of error handle handling to try to recover.

So if the softreset fails upon certain conditions, just disable the phy
associated with the disk. The user needs to handle this problem.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 29 ++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 5b091388c095..f206c433de32 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1870,14 +1870,33 @@ static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
 	}
 	hisi_sas_dereg_device(hisi_hba, device);
 
-	if (dev_is_sata(device)) {
+	rc = hisi_sas_debug_I_T_nexus_reset(device);
+	if (rc == TMF_RESP_FUNC_COMPLETE && dev_is_sata(device)) {
+		struct sas_phy *local_phy;
+
 		rc = hisi_sas_softreset_ata_disk(device);
-		if (rc == TMF_RESP_FUNC_FAILED)
-			return TMF_RESP_FUNC_FAILED;
+		switch (rc) {
+		case -ECOMM:
+			rc = -ENODEV;
+			break;
+		case TMF_RESP_FUNC_FAILED:
+		case -EMSGSIZE:
+		case -EIO:
+			local_phy = sas_get_local_phy(device);
+			rc = sas_phy_enable(local_phy, 0);
+			if (!rc) {
+				local_phy->enabled = 0;
+				dev_err(dev, "Disabled local phy of ATA disk %016llx due to softreset fail (%d)\n",
+					SAS_ADDR(device->sas_addr), rc);
+				rc = -ENODEV;
+			}
+			sas_put_local_phy(local_phy);
+			break;
+		default:
+			break;
+		}
 	}
 
-	rc = hisi_sas_debug_I_T_nexus_reset(device);
-
 	if ((rc == TMF_RESP_FUNC_COMPLETE) || (rc == -ENODEV))
 		hisi_sas_release_task(hisi_hba, device);
 
-- 
2.26.2

