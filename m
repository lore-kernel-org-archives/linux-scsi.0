Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEB6C10F26
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 08:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADCDF20B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 08:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387843AbgDBI6v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 04:58:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12604 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387780AbgDBI6v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Apr 2020 04:58:51 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B46B36AA3EDD6D1F55C8;
        Thu,  2 Apr 2020 16:58:48 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Apr 2020
 16:58:39 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <chenxiang66@hisilicon.com>,
        <b.zolnierkie@samsung.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2] scsi: hisi_sas: Fix build error without SATA_HOST
Date:   Thu, 2 Apr 2020 16:58:12 +0800
Message-ID: <20200402085812.32948-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20200402063021.34672-1-yuehaibing@huawei.com>
References: <20200402063021.34672-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If SATA_HOST is n, build fails:

drivers/scsi/hisi_sas/hisi_sas_main.o: In function `hisi_sas_fill_ata_reset_cmd':
hisi_sas_main.c:(.text+0x2500): undefined reference to `ata_tf_to_fis'

Select SATA_HOST to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: bd322af15ce9 ("ata: make SATA_PMP option selectable only if any SATA host driver is enabled")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: use correct Fixes tag
---
 drivers/scsi/hisi_sas/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index 90a17452a50d..13ed9073fc72 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -6,6 +6,7 @@ config SCSI_HISI_SAS
 	select SCSI_SAS_LIBSAS
 	select BLK_DEV_INTEGRITY
 	depends on ATA
+	select SATA_HOST
 	help
 		This driver supports HiSilicon's SAS HBA, including support based
 		on platform device
-- 
2.17.1


