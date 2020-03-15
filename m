Return-Path: <SRS0=ks1E=5A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AEAAC2BB1D
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 09:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42237206BE
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 09:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgCOJmr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Mar 2020 05:42:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:58074 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgCOJmq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Mar 2020 05:42:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EC0CFACA4;
        Sun, 15 Mar 2020 09:42:44 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: [PATCH v2 1/8] scsi: aacraid: Use scnprintf() for avoiding potential buffer overflow
Date:   Sun, 15 Mar 2020 10:42:34 +0100
Message-Id: <20200315094241.9086-2-tiwai@suse.de>
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

Acked-by: Balsundar P <Balsundar.P@microchip.com>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
v1->v2: Align the remaining lines to the open parenthesis

 drivers/scsi/aacraid/linit.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index b1d133de29ab..8b583eec25b5 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1287,20 +1287,21 @@ static ssize_t aac_show_flags(struct device *cdev,
 	if (nblank(dprintk(x)))
 		len = snprintf(buf, PAGE_SIZE, "dprintk\n");
 #ifdef AAC_DETAILED_STATUS_INFO
-	len += snprintf(buf + len, PAGE_SIZE - len,
-			"AAC_DETAILED_STATUS_INFO\n");
+	len += scnprintf(buf + len, PAGE_SIZE - len,
+			 "AAC_DETAILED_STATUS_INFO\n");
 #endif
 	if (dev->raw_io_interface && dev->raw_io_64)
-		len += snprintf(buf + len, PAGE_SIZE - len,
-				"SAI_READ_CAPACITY_16\n");
+		len += scnprintf(buf + len, PAGE_SIZE - len,
+				 "SAI_READ_CAPACITY_16\n");
 	if (dev->jbod)
-		len += snprintf(buf + len, PAGE_SIZE - len, "SUPPORTED_JBOD\n");
+		len += scnprintf(buf + len, PAGE_SIZE - len,
+				 "SUPPORTED_JBOD\n");
 	if (dev->supplement_adapter_info.supported_options2 &
 		AAC_OPTION_POWER_MANAGEMENT)
-		len += snprintf(buf + len, PAGE_SIZE - len,
-				"SUPPORTED_POWER_MANAGEMENT\n");
+		len += scnprintf(buf + len, PAGE_SIZE - len,
+				 "SUPPORTED_POWER_MANAGEMENT\n");
 	if (dev->msi)
-		len += snprintf(buf + len, PAGE_SIZE - len, "PCI_HAS_MSI\n");
+		len += scnprintf(buf + len, PAGE_SIZE - len, "PCI_HAS_MSI\n");
 	return len;
 }
 
-- 
2.16.4

