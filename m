From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] tmscsim: Fix big left-shifts of unsigned char
Date: Thu, 18 Jun 2009 14:14:26 +0200
Message-ID: <4A3A2FA2.60005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:51964 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbZFRKOM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2009 06:14:12 -0400
Received: by ewy6 with SMTP id 6so1376003ewy.37
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2009 03:14:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: garloff@suse.de, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Shifting of u8 causes promotion to signed 'int'

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I believe this was not intentionally?
see http://osdir.com/ml/git/2009-06/msg01347.html

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 9a42734..09a3c12 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -894,7 +894,7 @@ din_1:
 	    if (!i) printk (KERN_ERR "DC390: DMA Blast aborted unfinished!\n");
 	    //DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD);
 	    dc390_laststatus &= ~0xff000000;
-	    dc390_laststatus |= bval << 24;
+	    dc390_laststatus |= (unsigned)bval << 24;
 
 	    DEBUG1(printk (KERN_DEBUG "Blast: Read %i times DMA_Status %02x", 0xa000-i, bval));
 	    ResidCnt = (((u32) DC390_read8 (CtcReg_High) << 16) |
