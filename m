From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 061/103] target/pscsi: Use min_t for sector limits
Date: Thu, 21 Jul 2011 00:08:13 -0700
Message-ID: <1311232135-6653-62-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm14-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.162]:24332
	"HELO nm14-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752017Ab1GUHFb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:05:31 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index a62350d..5df329c 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -328,10 +328,8 @@ static struct se_device *pscsi_add_device_to_list(
 	q = sd->request_queue;
 	limits = &dev_limits.limits;
 	limits->logical_block_size = sd->sector_size;
-	limits->max_hw_sectors = (sd->host->max_sectors > queue_max_hw_sectors(q)) ?
-				  queue_max_hw_sectors(q) : sd->host->max_sectors;
-	limits->max_sectors = (sd->host->max_sectors > queue_max_sectors(q)) ?
-				  queue_max_sectors(q) : sd->host->max_sectors;
+	limits->max_hw_sectors = min_t(int, sd->host->max_sectors, queue_max_hw_sectors(q));
+	limits->max_sectors = min_t(int, sd->host->max_sectors, queue_max_sectors(q));
 	dev_limits.hw_queue_depth = sd->queue_depth;
 	dev_limits.queue_depth = sd->queue_depth;
 	/*
-- 
1.7.6

