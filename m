Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB68C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 12:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA321610D1
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 12:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245082AbhIYMz0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Sep 2021 08:55:26 -0400
Received: from mx22.baidu.com ([220.181.50.185]:45530 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245184AbhIYMzZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Sep 2021 08:55:25 -0400
Received: from BC-Mail-Ex28.internal.baidu.com (unknown [172.31.51.22])
        by Forcepoint Email with ESMTPS id D9E4957825CD372D13C8;
        Sat, 25 Sep 2021 20:53:47 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex28.internal.baidu.com (172.31.51.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 25 Sep 2021 20:53:47 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 25 Sep 2021 20:53:47 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Michael Reed <mdr@sgi.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] scsi: lpfc: Fix a function name in comments
Date:   Sat, 25 Sep 2021 20:53:23 +0800
Message-ID: <20210925125324.1760-3-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210925125324.1760-1-caihuoqing@baidu.com>
References: <20210925125324.1760-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex01.internal.baidu.com (10.127.64.11) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use dma_map_sg() instead of pci_map_sg(),
because only dma_map_sg() is called here.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 27ea8f552ede..83ad03d22a49 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -894,7 +894,7 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	bpl += 2;
 	if (scsi_sg_count(scsi_cmnd)) {
 		/*
-		 * The driver stores the segment count returned from pci_map_sg
+		 * The driver stores the segment count returned from dma_map_sg
 		 * because this a count of dma-mappings used to map the use_sg
 		 * pages.  They are not guaranteed to be the same for those
 		 * architectures that implement an IOMMU.
@@ -2589,7 +2589,7 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 	bpl += 2;
 	if (scsi_sg_count(scsi_cmnd)) {
 		/*
-		 * The driver stores the segment count returned from pci_map_sg
+		 * The driver stores the segment count returned from dma_map_sg
 		 * because this a count of dma-mappings used to map the use_sg
 		 * pages.  They are not guaranteed to be the same for those
 		 * architectures that implement an IOMMU.
@@ -3249,7 +3249,7 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	 */
 	if (scsi_sg_count(scsi_cmnd)) {
 		/*
-		 * The driver stores the segment count returned from pci_map_sg
+		 * The driver stores the segment count returned from dma_map_sg
 		 * because this a count of dma-mappings used to map the use_sg
 		 * pages.  They are not guaranteed to be the same for those
 		 * architectures that implement an IOMMU.
@@ -3488,7 +3488,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	 */
 	if (scsi_sg_count(scsi_cmnd)) {
 		/*
-		 * The driver stores the segment count returned from pci_map_sg
+		 * The driver stores the segment count returned from dma_map_sg
 		 * because this a count of dma-mappings used to map the use_sg
 		 * pages.  They are not guaranteed to be the same for those
 		 * architectures that implement an IOMMU.
-- 
2.25.1

