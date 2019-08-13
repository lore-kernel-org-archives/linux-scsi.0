Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58927C433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 18:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37BE92064A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 18:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfHMSBR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 14:01:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38953 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbfHMSBR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 14:01:17 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hxb6f-0007FU-U5; Tue, 13 Aug 2019 18:01:14 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jianyun Li <jyli@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mvumi: fix 32 bit shift of a u32 value
Date:   Tue, 13 Aug 2019 19:01:13 +0100
Message-Id: <20190813180113.14245-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the top 32 bits of a 64 bit address is being calculated
by shifting a u32 twice by 16 bits and then being cast into a 64
bit address.  Shifting a u32 twice by 16 bits always ends up with
a zero.  Fix this by casting the u32 to a 64 bit address first
and then shifting it 32 bits.

Addresses-Coverity: ("Operands don't affect result")
Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 8906aceda4c4..62df69f1e71e 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -296,7 +296,7 @@ static void mvumi_delete_internal_cmd(struct mvumi_hba *mhba,
 			sgd_getsz(mhba, m_sg, size);
 
 			phy_addr = (dma_addr_t) m_sg->baseaddr_l |
-				(dma_addr_t) ((m_sg->baseaddr_h << 16) << 16);
+				   (dma_addr_t) m_sg->baseaddr_h << 32;
 
 			dma_free_coherent(&mhba->pdev->dev, size, cmd->data_buf,
 								phy_addr);
-- 
2.20.1

