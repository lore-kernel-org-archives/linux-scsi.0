Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8242CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8875A205C9
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502590AbfJXOLn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:11:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5162 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391297AbfJXOLm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 10:11:42 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6C028B73F6A57353BA4E;
        Thu, 24 Oct 2019 22:11:35 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Thu, 24 Oct 2019 22:11:28 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v2 17/18] scsi: hisi_sas: Delete the debugfs folder of hisi_sas when the probe fails
Date:   Thu, 24 Oct 2019 22:08:24 +0800
Message-ID: <1571926105-74636-18-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1571926105-74636-1-git-send-email-john.garry@huawei.com>
References: <1571926105-74636-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

Although if the debugfs initialization fails, we will delete the debugfs
folder of hisi_sas, but we did not consider the scenario where debugfs was
successfully initialized, but the probe failed for other reasons. We found
out that hisi_sas folder is still remain after the probe failed.

When probe fail, we should delete debugfs folder to avoid the above issue.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 7fa9a5a51b80..669ad7463615 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2686,6 +2686,7 @@ int hisi_sas_probe(struct platform_device *pdev,
 err_out_register_ha:
 	scsi_remove_host(shost);
 err_out_ha:
+	hisi_sas_debugfs_exit(hisi_hba);
 	hisi_sas_free(hisi_hba);
 	scsi_host_put(shost);
 	return rc;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 19a8cfeb8f6e..e4da309009c0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3266,6 +3266,7 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_out_register_ha:
 	scsi_remove_host(shost);
 err_out_ha:
+	hisi_sas_debugfs_exit(hisi_hba);
 	scsi_host_put(shost);
 err_out_regions:
 	pci_release_regions(pdev);
-- 
2.17.1

