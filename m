Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D429C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 08:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDD0F2073C
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 08:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730847AbgKXIud (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 03:50:33 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7725 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730755AbgKXIud (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 03:50:33 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CgHlc4blhzkdKN;
        Tue, 24 Nov 2020 16:50:04 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 16:50:21 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH v2 1/3] scsi: hisi_sas: Reduce some indirection in v3 hw driver
Date:   Tue, 24 Nov 2020 16:46:32 +0800
Message-ID: <1606207594-196362-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1606207594-196362-1-git-send-email-john.garry@huawei.com>
References: <1606207594-196362-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sometimes local functions are called indirectly from the hw driver, which
only makes the code harder to follow. Remove these.

Method .hw_init is only called from platform driver probe, which is not
relevant, so don't set this either.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 7133ca859b5e..db409f6847bb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3142,7 +3142,6 @@ static struct scsi_host_template sht_v3_hw = {
 };
 
 static const struct hisi_sas_hw hisi_sas_v3_hw = {
-	.hw_init = hisi_sas_v3_init,
 	.setup_itct = setup_itct_v3_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v3_hw,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v3_hdr),
@@ -3322,7 +3321,7 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		goto err_out_register_ha;
 
-	rc = hisi_hba->hw->hw_init(hisi_hba);
+	rc = hisi_sas_v3_init(hisi_hba);
 	if (rc)
 		goto err_out_register_ha;
 
@@ -3511,7 +3510,7 @@ static int _resume_v3_hw(struct device *device)
 		pci_disable_device(pdev);
 		return rc;
 	}
-	hisi_hba->hw->phys_init(hisi_hba);
+	phys_init_v3_hw(hisi_hba);
 	sas_resume_ha(sha);
 	clear_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags);
 
-- 
2.26.2

