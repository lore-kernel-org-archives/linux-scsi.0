Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D03C2BA83
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 09:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9570020714
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 09:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgBLJLx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 04:11:53 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:52478 "EHLO
        michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728696AbgBLJLx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2020 04:11:53 -0500
Received: from ramsan ([84.195.182.253])
        by michel.telenet-ops.be with bizsmtp
        id 1lBo2200o5USYZQ06lBpcD; Wed, 12 Feb 2020 10:11:51 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1j1o3g-0000Zh-ND; Wed, 12 Feb 2020 10:11:48 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1j1nkB-0002cA-D5; Wed, 12 Feb 2020 09:51:39 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] scsi: zorro_esp: Restore devm_ioremap() alignment
Date:   Wed, 12 Feb 2020 09:51:38 +0100
Message-Id: <20200212085138.10009-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Restore alignment of the continuations of the ioremap() calls in
zorro_esp_probe().  Join lines where all parameters can fit on a single
line.

Fixes: 4bdc0d676a643140 ("remove ioremap_nocache and devm_ioremap_nocache")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/scsi/zorro_esp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
index bdd82e497d5fcb7c..c6727bcbc2e3268d 100644
--- a/drivers/scsi/zorro_esp.c
+++ b/drivers/scsi/zorro_esp.c
@@ -801,8 +801,7 @@ static int zorro_esp_probe(struct zorro_dev *z,
 	/* additional setup required for Fastlane */
 	if (zep->zorro3 && ent->driver_data == ZORRO_BLZ1230II) {
 		/* map full address space up to ESP base for DMA */
-		zep->board_base = ioremap(board,
-						FASTLANE_ESP_ADDR-1);
+		zep->board_base = ioremap(board, FASTLANE_ESP_ADDR - 1);
 		if (!zep->board_base) {
 			pr_err("Cannot allocate board address space\n");
 			err = -ENOMEM;
@@ -843,7 +842,7 @@ static int zorro_esp_probe(struct zorro_dev *z,
 		 * dma_registers size if adding any more
 		 */
 		esp->dma_regs = ioremap(dmaaddr,
-				sizeof(struct fastlane_dma_registers));
+					sizeof(struct fastlane_dma_registers));
 	} else
 		/* ZorroII address space remapped nocache by early startup */
 		esp->dma_regs = ZTWO_VADDR(dmaaddr);
-- 
2.17.1

