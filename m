Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44546C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 09:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8955223FD
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 09:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772479AbgJZJB5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 05:01:57 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3475 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1772468AbgJZJB5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 05:01:57 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CKTNn36kQzhbqr;
        Mon, 26 Oct 2020 17:02:01 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Mon, 26 Oct 2020
 17:01:52 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <hare@suse.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH -next] [SCSI] aic7xxx: change the error value of ahx_pci_test_register_access from postive to negative
Date:   Mon, 26 Oct 2020 17:12:36 +0800
Message-ID: <20201026091236.68561-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A negative error code should be returned
instead of a positive one when going to
error path.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/scsi/aic7xxx/aic79xx_pci.c | 2 +-
 drivers/scsi/aic7xxx/aic7xxx_pci.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index 8397ae93f7dd..0edce0ebd944 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -419,7 +419,7 @@ ahd_pci_test_register_access(struct ahd_softc *ahd)
 	int	 error;
 	uint8_t	 hcntrl;
 
-	error = EIO;
+	error = -EIO;
 
 	/*
 	 * Enable PCI error interrupt status, but suppress NMIs
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
index 656f680c7802..cbeca694e883 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -1168,7 +1168,7 @@ ahc_pci_test_register_access(struct ahc_softc *ahc)
 	uint32_t cmd;
 	uint8_t	 hcntrl;
 
-	error = EIO;
+	error = -EIO;
 
 	/*
 	 * Enable PCI error interrupt status, but suppress NMIs
-- 
2.17.1

