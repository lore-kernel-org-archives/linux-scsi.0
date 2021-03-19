Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AD7C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 02:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AE8064F24
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 02:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhCSC4I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 22:56:08 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14378 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbhCSCzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 22:55:46 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F1pPV11gjz9191;
        Fri, 19 Mar 2021 10:53:50 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Fri, 19 Mar 2021
 10:55:34 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <axboe@kernel.dk>, <ming.lei@redhat.com>, <hch@lst.de>,
        <keescook@chromium.org>, <kbusch@kernel.org>,
        <linux-block@vger.kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 1/3] scsi: check the whole result for reading write protect flag
Date:   Fri, 19 Mar 2021 11:01:26 +0800
Message-ID: <20210319030128.1345061-2-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210319030128.1345061-1-yanaijie@huawei.com>
References: <20210319030128.1345061-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the scsi device status is offline, mode sense command will return a
result with only DID_NO_CONNECT set. Then in sd_read_write_protect_flag(),
only status byte of the result is checked, we still consider the command
returned good, and read sdkp->write_prot from the buffer. And because of
bug [1], garbage data is copied to the buffer, the disk sometimes
be set readonly. When the scsi device is set running again, users cannot
write data to the disk.

Fix this by check the whole result returned by the driver.

[1] https://patchwork.kernel.org/project/linux-block/patch/20210318122621.330010-1-yanaijie@huawei.com/

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/sd.c   |  6 +++---
 include/scsi/scsi.h | 13 +++++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ed0b1bb99f08..16f8cd2895fd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2669,18 +2669,18 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 		 * 5: Illegal Request, Sense Code 24: Invalid field in
 		 * CDB.
 		 */
-		if (!scsi_status_is_good(res))
+		if (!scsi_result_is_good(res))
 			res = sd_do_mode_sense(sdkp, 0, 0, buffer, 4, &data, NULL);
 
 		/*
 		 * Third attempt: ask 255 bytes, as we did earlier.
 		 */
-		if (!scsi_status_is_good(res))
+		if (!scsi_result_is_good(res))
 			res = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 255,
 					       &data, NULL);
 	}
 
-	if (!scsi_status_is_good(res)) {
+	if (!scsi_result_is_good(res)) {
 		sd_first_printk(KERN_WARNING, sdkp,
 			  "Test WP failed, assume Write Enabled\n");
 	} else {
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index e75cca25338a..db0f346a31b2 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -55,6 +55,19 @@ static inline int scsi_status_is_good(int status)
 		(status == SAM_STAT_COMMAND_TERMINATED));
 }
 
+/** scsi_result_is_good - check the result return.
+ *
+ * @result: the result passed up from the driver (including host and
+ *          driver components)
+ *
+ * Drivers may only set other bytes but not status byte.
+ * This checks both the status byte and other bytes.
+ */
+static inline int scsi_result_is_good(int result)
+{
+	return scsi_status_is_good(result) && (result & ~0xff) == 0;
+}
+
 
 /*
  * standard mode-select header prepended to all mode-select commands
-- 
2.25.4

