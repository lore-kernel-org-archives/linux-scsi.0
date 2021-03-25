Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F8DC433C1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 12:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5336B61A16
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 12:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhCYMaF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 08:30:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14591 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhCYM3h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 08:29:37 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F5krg58P1z19H5L;
        Thu, 25 Mar 2021 20:27:31 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.498.0; Thu, 25 Mar 2021
 20:29:23 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>, <yanaijie@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <luojiaxing@huawei.com>, <chenxiang66@hisilicon.com>,
        <linuxarm@openeuler.org>
Subject: [PATCH v1 1/2] scsi: libsas: make switch and case at the same indent in sas_to_ata_err()
Date:   Thu, 25 Mar 2021 20:29:55 +0800
Message-ID: <1616675396-6108-2-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616675396-6108-1-git-send-email-luojiaxing@huawei.com>
References: <1616675396-6108-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

One checkpatch error is found in sas_to_ata_err() that switch and case is
not at the same indent. So fix it.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/scsi/libsas/sas_ata.c | 74 ++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 9f7fe67..4e4b55d 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -35,46 +35,40 @@ static enum ata_completion_errors sas_to_ata_err(struct task_status_struct *ts)
 	/* ts->resp == SAS_TASK_COMPLETE */
 	/* task delivered, what happened afterwards? */
 	switch (ts->stat) {
-		case SAS_DEV_NO_RESPONSE:
-			return AC_ERR_TIMEOUT;
-
-		case SAS_INTERRUPTED:
-		case SAS_PHY_DOWN:
-		case SAS_NAK_R_ERR:
-			return AC_ERR_ATA_BUS;
-
-
-		case SAS_DATA_UNDERRUN:
-			/*
-			 * Some programs that use the taskfile interface
-			 * (smartctl in particular) can cause underrun
-			 * problems.  Ignore these errors, perhaps at our
-			 * peril.
-			 */
-			return 0;
-
-		case SAS_DATA_OVERRUN:
-		case SAS_QUEUE_FULL:
-		case SAS_DEVICE_UNKNOWN:
-		case SAS_SG_ERR:
-			return AC_ERR_INVALID;
-
-		case SAS_OPEN_TO:
-		case SAS_OPEN_REJECT:
-			pr_warn("%s: Saw error %d.  What to do?\n",
-				__func__, ts->stat);
-			return AC_ERR_OTHER;
-
-		case SAM_STAT_CHECK_CONDITION:
-		case SAS_ABORTED_TASK:
-			return AC_ERR_DEV;
-
-		case SAS_PROTO_RESPONSE:
-			/* This means the ending_fis has the error
-			 * value; return 0 here to collect it */
-			return 0;
-		default:
-			return 0;
+	case SAS_DEV_NO_RESPONSE:
+		return AC_ERR_TIMEOUT;
+	case SAS_INTERRUPTED:
+	case SAS_PHY_DOWN:
+	case SAS_NAK_R_ERR:
+		return AC_ERR_ATA_BUS;
+	case SAS_DATA_UNDERRUN:
+		/*
+		 * Some programs that use the taskfile interface
+		 * (smartctl in particular) can cause underrun
+		 * problems.  Ignore these errors, perhaps at our
+		 * peril.
+		 */
+		return 0;
+	case SAS_DATA_OVERRUN:
+	case SAS_QUEUE_FULL:
+	case SAS_DEVICE_UNKNOWN:
+	case SAS_SG_ERR:
+		return AC_ERR_INVALID;
+	case SAS_OPEN_TO:
+	case SAS_OPEN_REJECT:
+		pr_warn("%s: Saw error %d.  What to do?\n",
+			__func__, ts->stat);
+		return AC_ERR_OTHER;
+	case SAM_STAT_CHECK_CONDITION:
+	case SAS_ABORTED_TASK:
+		return AC_ERR_DEV;
+	case SAS_PROTO_RESPONSE:
+		/* This means the ending_fis has the error
+		 * value; return 0 here to collect it
+		 */
+		return 0;
+	default:
+		return 0;
 	}
 }
 
-- 
2.7.4

