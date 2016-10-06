From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 03/12] scsi/atari_scsi: Make device register accessors
 re-enterant
Date: Thu,  6 Oct 2016 19:41:07 -0400 (EDT)
Message-ID: <01e95bb5b972d922af8415831ce23b8fbc516766.1475791899.git.fthain@telegraphics.com.au>
References: <cover.1475791899.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:45970 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752415AbcJFXlJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2016 19:41:09 -0400
In-Reply-To: <cover.1475791899.git.fthain@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch fixes an old bug: accesses to device registers from the
interrupt handler (after reselection, DMA completion etc.) could mess
up a device register access elsewhere, if the latter takes place outside
of an irq lock (during selection etc.).

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/atari_scsi.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index a59ad94..862f30c 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -670,14 +670,26 @@ static void atari_scsi_tt_reg_write(unsigned char reg, unsigned char value)
 
 static unsigned char atari_scsi_falcon_reg_read(unsigned char reg)
 {
-	dma_wd.dma_mode_status= (u_short)(0x88 + reg);
-	return (u_char)dma_wd.fdc_acces_seccount;
+	unsigned long flags;
+	unsigned char result;
+
+	reg += 0x88;
+	local_irq_save(flags);
+	dma_wd.dma_mode_status = (u_short)reg;
+	result = (u_char)dma_wd.fdc_acces_seccount;
+	local_irq_restore(flags);
+	return result;
 }
 
 static void atari_scsi_falcon_reg_write(unsigned char reg, unsigned char value)
 {
-	dma_wd.dma_mode_status = (u_short)(0x88 + reg);
+	unsigned long flags;
+
+	reg += 0x88;
+	local_irq_save(flags);
+	dma_wd.dma_mode_status = (u_short)reg;
 	dma_wd.fdc_acces_seccount = (u_short)value;
+	local_irq_restore(flags);
 }
 
 
-- 
2.7.3

