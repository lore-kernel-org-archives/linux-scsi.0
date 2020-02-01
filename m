Return-Path: <SRS0=vSKu=3V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0492EC33C9E
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Feb 2020 06:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C76E8206E6
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Feb 2020 06:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgBAGyr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Feb 2020 01:54:47 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:55350 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726038AbgBAGyq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 1 Feb 2020 01:54:46 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BF7838182F603C0CDF03;
        Sat,  1 Feb 2020 14:54:43 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.231) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Sat, 1 Feb 2020
 14:54:33 +0800
Message-ID: <5E3520A7.5030501@huawei.com>
Date:   Sat, 1 Feb 2020 14:54:31 +0800
From:   AlexChen <alex.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>, <zhengchuan@huawei.com>,
        <jiangyiwen@huawei.com>, <robin.yb@huawei.com>
Subject: [PATCH V2] scsi: add a new flag to set whether SCSI disks support
 WRITE_SAME_16 by default
References: <5E28118F.3070706@huawei.com>
In-Reply-To: <5E28118F.3070706@huawei.com>
X-Forwarded-Message-Id: <5E28118F.3070706@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.231]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the SCSI device is initialized, check whether it supports
WRITE_SAME_16 or WRITE_SAME_10 in the sd_read_write_same(). If
the back-end storage device does not support queries, it will not
set sdkp->ws16 as 1.

When the WRITE_SAME io is issued through the blkdev_issue_write_same(),
the WRITE_SAME type is set to WRITE_SAME_10 by default in
the sd_setup_write_same_cmnd() since of "sdkp->ws16=0". If the storage
device does not support WRITE_SAME_10, then the SCSI device is set to
not support WRITE_SAME.

Currently, some storage devices do not provide queries for WRITE_SAME_16
support, and only WRITE_SAME_16 is supported, not WRITE_SAME_10.
Therefore, we need to provide a new flag for these storage devices. When
initializing these devices, we will no longer query for support for
WRITE_SAME_16 in the sd_read_write_same(), but set these SCSI disks to
support WRITE_SAME_16 by default. In that way, we can add
'vendor:product:flag' to the module parameter 'dev_flags' for these
storage devices.

Signed-off-by: AlexChen <alex.chen@huawei.com>
---
 drivers/scsi/sd.c           | 4 +++-
 include/scsi/scsi_devinfo.h | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4f7e7b607..a208ba5b5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -68,6 +68,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
+#include <scsi/scsi_devinfo.h>

 #include "sd.h"
 #include "scsi_priv.h"
@@ -3014,7 +3015,8 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 			sdev->no_write_same = 1;
 	}

-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1)
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1 ||
+			sdev->sdev_bflags & BLIST_SUPPORT_WS16)
 		sdkp->ws16 = 1;

 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME) == 1)
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 3fdb322d4..da70d4795 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -67,8 +67,10 @@
 #define BLIST_RETRY_ITF		((__force blist_flags_t)(1ULL << 32))
 /* Always retry ABORTED_COMMAND with ASC 0xc1 */
 #define BLIST_RETRY_ASC_C1	((__force blist_flags_t)(1ULL << 33))
+/* support for write_same_16, no need to query */
+#define BLIST_SUPPORT_WS16      ((__force blist_flags_t)(1ULL << 34))

-#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
+#define __BLIST_LAST_USED BLIST_SUPPORT_WS16

 #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
 			       (__force blist_flags_t) \
-- 
2.19.1


