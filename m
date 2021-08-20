Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B3AC4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89BDC60EBC
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbhHTDR2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 23:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237843AbhHTDR1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 23:17:27 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3D4C061575;
        Thu, 19 Aug 2021 20:16:50 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id u21so3456475qtw.8;
        Thu, 19 Aug 2021 20:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b7g37l4t7Ju+WLF2XEeW10CYMCF8+xCIWkifCZ8VFAE=;
        b=mlowRgmwYT35XypRP0yhkN4vBnSF3SSpIn2C00ujzZZDygAbe9zEiN24Jv9fq4tfw4
         m98so206znQWTIFlTr4yz9bxTWzBbhlkcKilf4pdAMHDUVdT09SlBKepG8QEY0P1j+Yx
         JjMAnuDO2PHIWZ9mrxmF6BJjjFGRjfBYqs9FMGjNe4iOzy2VjHWuauM4I6QP7fq9+yrg
         qedBmZNN9WGYS5oZLhV0SddXi8OnaOLAOq2nsThHIY8DRXecZHj8Ww3qe/mylu6/dHXf
         K7WeKZSc3IcMKqsxWxOocSDHOWDrhA/G3v0mMzh/GZMSZbDH2J4iY1ngNKedYDLRDriI
         335Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b7g37l4t7Ju+WLF2XEeW10CYMCF8+xCIWkifCZ8VFAE=;
        b=bCe/FPTEqElGHxftRddSklROnF3ZWveUucFPxnbW7i9IDNH4ekXea14/8bi66QXAJf
         JLoQt3zsLIBNi+Os5WD/zrqNScV6kwjzFh9AGdzIWRvJCBLrlbDeKjehAWI9Au6eTUDx
         tXdZm5fxEkUceEO0PfSMY7Envqj2kCiBPiL5h5y77euXZOMCz4/VTCQ5UBWfXg5vXtez
         jzt9KSb035iWfY36hHd6fC9KlFwkytx+2/PGLZA0rxBT+vktoQFObBbY7QYDOmxbbjn3
         t7HK6vRZm+FrvA3FpYMovwSXRrBcB5U3B9wQMbDPiXgbQ3PiCmzfX2FmKpOb0dzFeHiC
         /eMg==
X-Gm-Message-State: AOAM530zS4Zw7AVKQxQWbQQvSwbeynkKET89nigeGtOFcIKpDOB0pQ8U
        W7f16bMCF56WmtZ85YCtlFowyQhInt4=
X-Google-Smtp-Source: ABdhPJySio9nLJMz9mHWe+MuiXHiY6OAU3m1StriQDzTMLxkRb2/lb9NvFATnyiAHlu1etvFawS9Ew==
X-Received: by 2002:ac8:5e46:: with SMTP id i6mr1309619qtx.33.1629429409607;
        Thu, 19 Aug 2021 20:16:49 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id j18sm2570954qkl.12.2021.08.19.20.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 20:16:49 -0700 (PDT)
From:   CGEL <cgel.zte@gmail.com>
X-Google-Original-From: CGEL <jing.yangyang@zte.com.cn>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jing yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] scsi: remove unneeded semicolon
Date:   Thu, 19 Aug 2021 20:16:39 -0700
Message-Id: <2efd9ecdaac8a24371b5f778d3c8e14519c4fc8d.1629195119.git.jing.yangyang@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jing yangyang <jing.yangyang@zte.com.cn>

Eliminate the following coccicheck warning:

./drivers/scsi/aha1542.c:557:2-3: Unneeded semicolon
./drivers/scsi/aha1542.c:586:2-3: Unneeded semicolon
./drivers/scsi/aha1542.c:609:2-3: Unneeded semicolon
./drivers/scsi/aha1542.c:308:2-3: Unneeded semicolon
./drivers/scsi/aha1542.c:350:3-4: Unneeded semicolon
./drivers/scsi/aha1542.c:415:2-3: Unneeded semicolon
./drivers/scsi/aha1542.c:644:2-3: Unneeded semicolon
./drivers/scsi/aha1542.c:662:2-3: Unneeded semicolon
./drivers/scsi/aha1542.c:681:2-3: Unneeded semicolon
./drivers/scsi/aha1542.c:542:2-3: Unneeded semicolon

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: jing yangyang <jing.yangyang@zte.com.cn>
---
 drivers/scsi/aha1542.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 584a595..044c391 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -305,7 +305,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 		if (flag & SCRD)
 			printk("SCRD ");
 		printk("status %02x\n", inb(STATUS(sh->io_port)));
-	};
+	}
 #endif
 	number_serviced = 0;
 
@@ -347,7 +347,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 			if (!number_serviced)
 				shost_printk(KERN_WARNING, sh, "interrupt received, but no mail.\n");
 			return IRQ_HANDLED;
-		};
+		}
 
 		mbo = (scsi2int(mb[mbi].ccbptr) - (unsigned long)aha1542->ccb_handle) / sizeof(struct ccb);
 		mbistatus = mb[mbi].status;
@@ -412,7 +412,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 						 */
 		my_done(tmp_cmd);
 		number_serviced++;
-	};
+	}
 }
 
 static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
@@ -539,7 +539,7 @@ static void setup_mailboxes(struct Scsi_Host *sh)
 		any2scsi(aha1542->mb[i].ccbptr,
 			 aha1542->ccb_handle + i * sizeof(struct ccb));
 		aha1542->mb[AHA1542_MAILBOXES + i].status = 0;
-	};
+	}
 	aha1542_intr_reset(sh->io_port);	/* reset interrupts, so they don't block */
 	any2scsi(mb_cmd + 2, aha1542->mb_handle);
 	if (aha1542_out(sh->io_port, mb_cmd, 5))
@@ -554,7 +554,7 @@ static int aha1542_getconfig(struct Scsi_Host *sh)
 	i = inb(STATUS(sh->io_port));
 	if (i & DF) {
 		i = inb(DATA(sh->io_port));
-	};
+	}
 	aha1542_outb(sh->io_port, CMD_RETCONF);
 	aha1542_in(sh->io_port, inquiry_result, 3, 0);
 	if (!wait_mask(INTRFLAGS(sh->io_port), INTRMASK, HACC, 0, 0))
@@ -583,7 +583,7 @@ static int aha1542_getconfig(struct Scsi_Host *sh)
 	default:
 		shost_printk(KERN_ERR, sh, "Unable to determine DMA channel.\n");
 		return -1;
-	};
+	}
 	switch (inquiry_result[1]) {
 	case 0x40:
 		sh->irq = 15;
@@ -606,7 +606,7 @@ static int aha1542_getconfig(struct Scsi_Host *sh)
 	default:
 		shost_printk(KERN_ERR, sh, "Unable to determine IRQ level.\n");
 		return -1;
-	};
+	}
 	sh->this_id = inquiry_result[2] & 7;
 	return 0;
 }
@@ -641,7 +641,7 @@ static int aha1542_mbenable(struct Scsi_Host *sh)
 
 		if (aha1542_out(sh->io_port, mbenable_cmd, 3))
 			goto fail;
-	};
+	}
 	while (0) {
 fail:
 		shost_printk(KERN_ERR, sh, "Mailbox init failed\n");
@@ -659,7 +659,7 @@ static int aha1542_query(struct Scsi_Host *sh)
 	i = inb(STATUS(sh->io_port));
 	if (i & DF) {
 		i = inb(DATA(sh->io_port));
-	};
+	}
 	aha1542_outb(sh->io_port, CMD_INQUIRY);
 	aha1542_in(sh->io_port, inquiry_result, 4, 0);
 	if (!wait_mask(INTRFLAGS(sh->io_port), INTRMASK, HACC, 0, 0))
@@ -678,7 +678,7 @@ static int aha1542_query(struct Scsi_Host *sh)
 	if (inquiry_result[0] == 0x43) {
 		shost_printk(KERN_INFO, sh, "Emulation mode not supported for AHA-1740 hardware, use aha1740 driver instead.\n");
 		return 1;
-	};
+	}
 
 	/*
 	 * Always call this - boards that do not support extended bios translation
-- 
1.8.3.1


