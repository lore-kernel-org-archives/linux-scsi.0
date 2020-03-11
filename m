Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEAEC10F27
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 09:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3C1220848
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 09:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgCKJQg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 05:16:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:47692 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgCKJQg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Mar 2020 05:16:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 92716AAB8;
        Wed, 11 Mar 2020 09:16:34 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: [PATCH 1/8] scsi: aacraid: Use scnprintf() for avoiding potential buffer overflow
Date:   Wed, 11 Mar 2020 10:16:23 +0100
Message-Id: <20200311091630.22565-2-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200311091630.22565-1-tiwai@suse.de>
References: <20200311091630.22565-1-tiwai@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/scsi/aacraid/linit.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index b1d133de29ab..046fef4ff1f0 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1287,20 +1287,20 @@ static ssize_t aac_show_flags(struct device *cdev,
 	if (nblank(dprintk(x)))
 		len = snprintf(buf, PAGE_SIZE, "dprintk\n");
 #ifdef AAC_DETAILED_STATUS_INFO
-	len += snprintf(buf + len, PAGE_SIZE - len,
+	len += scnprintf(buf + len, PAGE_SIZE - len,
 			"AAC_DETAILED_STATUS_INFO\n");
 #endif
 	if (dev->raw_io_interface && dev->raw_io_64)
-		len += snprintf(buf + len, PAGE_SIZE - len,
+		len += scnprintf(buf + len, PAGE_SIZE - len,
 				"SAI_READ_CAPACITY_16\n");
 	if (dev->jbod)
-		len += snprintf(buf + len, PAGE_SIZE - len, "SUPPORTED_JBOD\n");
+		len += scnprintf(buf + len, PAGE_SIZE - len, "SUPPORTED_JBOD\n");
 	if (dev->supplement_adapter_info.supported_options2 &
 		AAC_OPTION_POWER_MANAGEMENT)
-		len += snprintf(buf + len, PAGE_SIZE - len,
+		len += scnprintf(buf + len, PAGE_SIZE - len,
 				"SUPPORTED_POWER_MANAGEMENT\n");
 	if (dev->msi)
-		len += snprintf(buf + len, PAGE_SIZE - len, "PCI_HAS_MSI\n");
+		len += scnprintf(buf + len, PAGE_SIZE - len, "PCI_HAS_MSI\n");
 	return len;
 }
 
-- 
2.16.4

