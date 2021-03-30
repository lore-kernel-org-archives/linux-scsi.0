Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85264C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 11:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536846195C
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 11:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhC3Ljo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 07:39:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15105 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhC3Lje (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 07:39:34 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F8nVb2z7Mz19Jv9;
        Tue, 30 Mar 2021 19:37:27 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Tue, 30 Mar 2021
 19:39:24 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yanaijie@huawei.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: consider status is not good for offline devices
Date:   Tue, 30 Mar 2021 19:47:27 +0800
Message-ID: <20210330114727.234467-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
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

So return 0 in scsi_status_is_good() for offline devices to indicate
that the command has failed. And move scsi_status_is_good() down after
the definition of DID_NO_CONNECT so that we can compile fine.

[1] https://patchwork.kernel.org/project/linux-block/patch/20210318122621.330010-1-yanaijie@huawei.com/

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 include/scsi/scsi.h | 54 +++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index e75cca25338a..d7bfbfde0ea5 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -30,32 +30,6 @@ enum scsi_timeouts {
  */
 #define SCAN_WILD_CARD	~0
 
-/** scsi_status_is_good - check the status return.
- *
- * @status: the status passed up from the driver (including host and
- *          driver components)
- *
- * This returns true for known good conditions that may be treated as
- * command completed normally
- */
-static inline int scsi_status_is_good(int status)
-{
-	/*
-	 * FIXME: bit0 is listed as reserved in SCSI-2, but is
-	 * significant in SCSI-3.  For now, we follow the SCSI-2
-	 * behaviour and ignore reserved bits.
-	 */
-	status &= 0xfe;
-	return ((status == SAM_STAT_GOOD) ||
-		(status == SAM_STAT_CONDITION_MET) ||
-		/* Next two "intermediate" statuses are obsolete in SAM-4 */
-		(status == SAM_STAT_INTERMEDIATE) ||
-		(status == SAM_STAT_INTERMEDIATE_CONDITION_MET) ||
-		/* FIXME: this is obsolete in SAM-3 */
-		(status == SAM_STAT_COMMAND_TERMINATED));
-}
-
-
 /*
  * standard mode-select header prepended to all mode-select commands
  */
@@ -276,4 +250,32 @@ static inline int scsi_is_wlun(u64 lun)
 /* Used to obtain the PCI location of a device */
 #define SCSI_IOCTL_GET_PCI		0x5387
 
+/** scsi_status_is_good - check the status return.
+ *
+ * @status: the status passed up from the driver (including host and
+ *          driver components)
+ *
+ * This returns true for known good conditions that may be treated as
+ * command completed normally
+ */
+static inline int scsi_status_is_good(int status)
+{
+	if (host_byte(status) == DID_NO_CONNECT)
+	    return 0;
+
+	/*
+	 * FIXME: bit0 is listed as reserved in SCSI-2, but is
+	 * significant in SCSI-3.  For now, we follow the SCSI-2
+	 * behaviour and ignore reserved bits.
+	 */
+	status &= 0xfe;
+	return ((status == SAM_STAT_GOOD) ||
+		(status == SAM_STAT_CONDITION_MET) ||
+		/* Next two "intermediate" statuses are obsolete in SAM-4 */
+		(status == SAM_STAT_INTERMEDIATE) ||
+		(status == SAM_STAT_INTERMEDIATE_CONDITION_MET) ||
+		/* FIXME: this is obsolete in SAM-3 */
+		(status == SAM_STAT_COMMAND_TERMINATED));
+}
+
 #endif /* _SCSI_SCSI_H */
-- 
2.25.4

