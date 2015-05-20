From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] mptsas: fix depth param in  scsi_track_queue_full
Date: Wed, 20 May 2015 14:44:44 +0200
Message-ID: <1432125884-467-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbbETMou (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2015 08:44:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sreekanth.reddy@avagotech.com

A user of scsi_track_queue_full should pass to the function
a constant value untill the queue-depth changes, otherwise the
internal logic in scsi_track_queue_full rejects the change.
Other users of this function use a 'sdev->queue_depth - 1'
as depth parameter, let's do the same.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/message/fusion/mptsas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 551262e4b9..7a8eebd8ba 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4096,7 +4096,7 @@ mptsas_handle_queue_full_event(struct fw_event_work *fw_event)
 					continue;
 				}
 				depth = scsi_track_queue_full(sdev,
-				    current_depth - 1);
+					sdev->queue_depth - 1);
 				if (depth > 0)
 					sdev_printk(KERN_INFO, sdev,
 					"Queue depth reduced to (%d)\n",
-- 
1.9.3

