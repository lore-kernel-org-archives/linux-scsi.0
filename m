Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7990BC33CB1
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 14:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CC84206D7
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 14:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgASONv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 09:13:51 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9203 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726860AbgASONv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Jan 2020 09:13:51 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7BAA58CD3BB7BC693BF3;
        Sun, 19 Jan 2020 22:13:48 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.231) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Sun, 19 Jan 2020
 22:13:40 +0800
Message-ID: <5E246413.8010408@huawei.com>
Date:   Sun, 19 Jan 2020 22:13:39 +0800
From:   AlexChen <alex.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <zhengchuan@huawei.com>,
        <jiangyiwen@huawei.com>, <robin.yb@huawei.com>
Subject: [PATCH] scsi: sd: provide a new module parameter to set whether SCSI
 disks support WRITE_SAME_16 by default
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
the back-end storage device does not support queries, it will not set
sdkp->ws16 as 1.

When the WRITE_SAME io is issued through the blkdev_issue_write_same(),
the WRITE_SAME type is set to WRITE_SAME_10 by default in the
sd_setup_write_same_cmnd() since of "sdkp->ws16=0". If the storage device
does not support WRITE_SAME_10, then the SCSI device is set to not support
WRITE_SAME.

Currently, some storage devices do not provide queries for
WRITE_SAME_16/WRITE_SAME_10 support, but they do support WRITE_SAME_16 and
do not support WRITE_SAME_10. So in order for these devices to use
WRITE_SAME, we need a new module parameter to set whether SCSI disks
support WRITE_SAME_16 by default.

Signed-off-by: AlexChen <alex.chen@huawei.com>
---
 drivers/scsi/sd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4f7e7b607..ff368701d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -104,6 +104,9 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 #define SD_MINORS	0
 #endif

+static int sd_default_support_ws16;
+module_param(sd_default_support_ws16, int, 0644);
+
 static void sd_config_discard(struct scsi_disk *, unsigned int);
 static void sd_config_write_same(struct scsi_disk *);
 static int  sd_revalidate_disk(struct gendisk *);
@@ -3014,7 +3017,8 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 			sdev->no_write_same = 1;
 	}

-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1)
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1 ||
+			sd_default_support_ws16)
 		sdkp->ws16 = 1;

 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME) == 1)
-- 2.19.1

