Return-Path: <SRS0=ks1E=5A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78540C5ACBF
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 09:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 506A3206EB
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 09:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgCOJmt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Mar 2020 05:42:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:58156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728141AbgCOJms (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Mar 2020 05:42:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B2C43AD2D;
        Sun, 15 Mar 2020 09:42:47 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 6/8] scsi: megaraid_sas: Use scnprintf() for avoiding potential buffer overflow
Date:   Sun, 15 Mar 2020 10:42:39 +0100
Message-Id: <20200315094241.9086-7-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200315094241.9086-1-tiwai@suse.de>
References: <20200315094241.9086-1-tiwai@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Also corrected the wrongly passed limit size.  The remaining buffer
size must be decremented.

Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc:  Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
v1->v2: Align the remaining lines to the open parenthesis

 drivers/scsi/megaraid/megaraid_sas_base.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 5bebdd397580..babe85d7b537 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2987,9 +2987,10 @@ megasas_dump_sys_regs(void __iomem *reg_set, char *buf)
 	u32 __iomem *reg = (u32 __iomem *)reg_set;
 
 	for (i = 0; i < sz / sizeof(u32); i++) {
-		bytes_wrote += snprintf(loc + bytes_wrote, PAGE_SIZE,
-					"%08x: %08x\n", (i * 4),
-					readl(&reg[i]));
+		bytes_wrote += scnprintf(loc + bytes_wrote,
+					 PAGE_SIZE - bytes_wrote,
+					 "%08x: %08x\n", (i * 4),
+					 readl(&reg[i]));
 	}
 	return bytes_wrote;
 }
-- 
2.16.4

