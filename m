From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 077/103] target/iblock: Use request_queue->nr_request for se_device defaults
Date: Thu, 21 Jul 2011 00:12:00 -0700
Message-ID: <1311232346-6674-78-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm5.bullet.mail.bf1.yahoo.com ([98.139.212.164]:40032 "HELO
	nm5.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751926Ab1GUHIR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:08:17 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts iblock_create_virtdevice() to use request_queue->nr_request
for se_dev_limits usage of ->hw_queue_depth and ->queue_depth for individual
struct se_device export.

It also removes the now unused defines for IBLOCK_DEVICE_QUEUE_DEPTH and
IBLOCK_MAX_DEVICE_QUEUE_DEPTH

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |    4 ++--
 drivers/target/target_core_iblock.h |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 814a85b..d43fc91 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -164,8 +164,8 @@ static struct se_device *iblock_create_virtdevice(
 	limits->logical_block_size = bdev_logical_block_size(bd);
 	limits->max_hw_sectors = queue_max_hw_sectors(q);
 	limits->max_sectors = queue_max_sectors(q);
-	dev_limits.hw_queue_depth = IBLOCK_MAX_DEVICE_QUEUE_DEPTH;
-	dev_limits.queue_depth = IBLOCK_DEVICE_QUEUE_DEPTH;
+	dev_limits.hw_queue_depth = q->nr_requests;
+	dev_limits.queue_depth = q->nr_requests;
 
 	ib_dev->ibd_major = MAJOR(bd->bd_dev);
 	ib_dev->ibd_minor = MINOR(bd->bd_dev);
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 6b6d17b..a69b7c2 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -3,8 +3,6 @@
 
 #define IBLOCK_VERSION		"4.0"
 
-#define IBLOCK_DEVICE_QUEUE_DEPTH	32
-#define IBLOCK_MAX_DEVICE_QUEUE_DEPTH	128
 #define IBLOCK_MAX_CDBS		16
 #define IBLOCK_LBA_SHIFT	9
 
-- 
1.7.6

