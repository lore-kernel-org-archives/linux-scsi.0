Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7C5C00454
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 16:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78F2520836
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 16:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576080511;
	bh=fWIUNSbPleNggmA6BWe/9j6tT59UNH1kNlCk7NEguWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=QivutrEtWPeJCpuIu0GtpnSu1dRCAAVX3NPT7oVW1Iar/JAoOvOBAUTIy2NxLS3ce
	 8Sg6eCZIhn3YzwenCj3raENFsgt9q9Kn86264nqRZYEOUHX9jkvJaBhbK1nBAoHEA7
	 +h8RKLeDnHDZpoL+1NiEQ27ESbVYvNGWfX1v2T68=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731077AbfLKPMR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 10:12:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731075AbfLKPMP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 696F624654;
        Wed, 11 Dec 2019 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077135;
        bh=fWIUNSbPleNggmA6BWe/9j6tT59UNH1kNlCk7NEguWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1w8YoSA1G/WhB7FfPy7NV/S46HrVDqELwus4GzE/TMLBOU4Ksy6h2ZYV4rNwJlazN
         AuaytO9BcNOR5oRZGhf5SrEmEIAl2yiVAItW9Hf0+z7AMZA99FmDuuPH9UbKN15YW3
         vq/RdnPZ4DvsaFcxENcjvNnWsK+X3D0V4nUtARFM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 022/134] scsi: hisi_sas: Delete the debugfs folder of hisi_sas when the probe fails
Date:   Wed, 11 Dec 2019 10:09:58 -0500
Message-Id: <20191211151150.19073-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

[ Upstream commit cabe7c10c97a0857a9fb14b6c772ab784947995d ]

Although if the debugfs initialization fails, we will delete the debugfs
folder of hisi_sas, but we did not consider the scenario where debugfs was
successfully initialized, but the probe failed for other reasons. We found
out that hisi_sas folder is still remain after the probe failed.

When probe fail, we should delete debugfs folder to avoid the above issue.

Link: https://lore.kernel.org/r/1571926105-74636-18-git-send-email-john.garry@huawei.com
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 20f0cb4698b7f..633effb09c9cc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2682,6 +2682,7 @@ int hisi_sas_probe(struct platform_device *pdev,
 err_out_register_ha:
 	scsi_remove_host(shost);
 err_out_ha:
+	hisi_sas_debugfs_exit(hisi_hba);
 	hisi_sas_free(hisi_hba);
 	scsi_host_put(shost);
 	return rc;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index cb8d087762dbd..ef32ee12f6065 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3259,6 +3259,7 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_out_register_ha:
 	scsi_remove_host(shost);
 err_out_ha:
+	hisi_sas_debugfs_exit(hisi_hba);
 	scsi_host_put(shost);
 err_out_regions:
 	pci_release_regions(pdev);
-- 
2.20.1

