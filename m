Return-Path: <SRS0=ks1E=5A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC35FC5ACC0
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 09:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3D35206EB
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 09:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgCOJmt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Mar 2020 05:42:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:58162 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728145AbgCOJms (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Mar 2020 05:42:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B691FAD5C;
        Sun, 15 Mar 2020 09:42:47 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 7/8] scsi: core: Use scnprintf() for avoiding potential buffer overflow
Date:   Sun, 15 Mar 2020 10:42:40 +0100
Message-Id: <20200315094241.9086-8-tiwai@suse.de>
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

Reviewed-by: Bart van Assche <bvanassche@acm.org>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
v1->v2: no change

 drivers/scsi/scsi_sysfs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index c3a30ba4ae08..163dbcb741c1 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1045,14 +1045,14 @@ sdev_show_blacklist(struct device *dev, struct device_attribute *attr,
 			name = sdev_bflags_name[i];
 
 		if (name)
-			len += snprintf(buf + len, PAGE_SIZE - len,
-					"%s%s", len ? " " : "", name);
+			len += scnprintf(buf + len, PAGE_SIZE - len,
+					 "%s%s", len ? " " : "", name);
 		else
-			len += snprintf(buf + len, PAGE_SIZE - len,
-					"%sINVALID_BIT(%d)", len ? " " : "", i);
+			len += scnprintf(buf + len, PAGE_SIZE - len,
+					 "%sINVALID_BIT(%d)", len ? " " : "", i);
 	}
 	if (len)
-		len += snprintf(buf + len, PAGE_SIZE - len, "\n");
+		len += scnprintf(buf + len, PAGE_SIZE - len, "\n");
 	return len;
 }
 static DEVICE_ATTR(blacklist, S_IRUGO, sdev_show_blacklist, NULL);
-- 
2.16.4

