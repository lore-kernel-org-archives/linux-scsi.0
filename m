Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486C1C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 09:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238217AbiA0JI3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 04:08:29 -0500
Received: from smtpbguseast3.qq.com ([54.243.244.52]:51641 "EHLO
        smtpbguseast3.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238215AbiA0JI2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2022 04:08:28 -0500
X-QQ-mid: bizesmtp2t1643274495tyh25xokj
Received: from localhost.localdomain (unknown [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 27 Jan 2022 17:08:08 +0800 (CST)
X-QQ-SSF: 0140000000200090E000C00A0000000
X-QQ-FEAT: TskX/GkkryBPF5HT0HtElpIA2By6DbVGrlZBlksv/OSb1ADRISEZBY7nx878I
        p1NVq/zYH9i4AZJrcRVPtAWnot/SnvtEI1zRyJHwd2jUGAde8dvgP9kqTazKIwQIfXr60vS
        se60qq76pZOowKThJYNnLF+n8+fQ5dRB0QUMQIrfOTOmp5dZOsH27YltfXWsz9/ihVAdKU8
        zWGj4pjowRG1HSmzqc8n9RKt17YbdNTCHXQlP4he81tWMzq1s3e0vVIYb/X1Ggg6ltHjN4p
        6NujUGwzqqfEfK3KhF+e9xjIH3xUaq7ZIwdnGr6+5H9UMKFy66Dt0TgA6X+zLwYfbK0nfMQ
        wKjYZwa4+Sgj7b74hTOG/YG8oJhHFz0ieqOtLRhrwQQF/7/Ry8=
X-QQ-GoodBg: 2
From:   tangmeng <tangmeng@uniontech.com>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tangmeng <tangmeng@uniontech.com>
Subject: [PATCH v2] scsi: sr: Improve the judgment statement
Date:   Thu, 27 Jan 2022 17:08:06 +0800
Message-Id: <20220127090806.8201-1-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign6
X-QQ-Bgrelay: 1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The previous code has a less-than-perfect usage of judgment syntax.

When the med->media_event_code value is equal to 2 or 3, the same
value is returned, so it would be better to combine the implementation
statements when the med->media_event_code value is equal to 2 or 3.

Moreover, when a variable is equal to multiple values, it is better
to use a switch judgment statement.

Signed-off-by: tangmeng <tangmeng@uniontech.com>
---
 drivers/scsi/sr.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index f925b1f1f9ad..610baa630067 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -222,12 +222,16 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	if (eh->nea || eh->notification_class != 0x4)
 		return 0;
 
-	if (med->media_event_code == 1)
+	switch (med->media_event_code) {
+	case 1:
 		return DISK_EVENT_EJECT_REQUEST;
-	else if (med->media_event_code == 2)
-		return DISK_EVENT_MEDIA_CHANGE;
-	else if (med->media_event_code == 3)
+	case 2:
+	case 3:
 		return DISK_EVENT_MEDIA_CHANGE;
+	default:
+		break;
+	}
+
 	return 0;
 }
 
-- 
2.20.1



