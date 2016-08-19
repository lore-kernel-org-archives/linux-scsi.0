From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 03/29] be2iscsi: Reduce driver load/unload time
Date: Fri, 19 Aug 2016 15:20:00 +0530
Message-ID: <1471600226-22055-4-git-send-email-jitendra.bhivare@broadcom.com>
References: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37596 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753410AbcHSJvK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2016 05:51:10 -0400
Received: by mail-wm0-f41.google.com with SMTP id i5so32719510wmg.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2016 02:50:54 -0700 (PDT)
In-Reply-To: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Driver takes significant time to load 1m:20s and unload 40s.

Checkpatch script threw warning:
WARNING: msleep < 20ms can sleep for up to 20ms; see
Documentation/timers/timers-howto.txt

To eliminate this warning msleep(1) was replaced with msleep(20) before
submitting.

msleep(20) in init and uninit path for creation and destroying of number
of WRBQs, CQs, and EQs is adding to load/unload time.

Replace msleep with schedule_timeout_uninterruptible of 1ms as its
enough in most cases.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/be2iscsi/be_cmds.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 0ef3d5a..59b8e2d 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -655,7 +655,8 @@ static int be_mbox_db_ready_poll(struct be_ctrl_info *ctrl)
 
 		if (time_after(jiffies, timeout))
 			break;
-		msleep(20);
+		/* 1ms sleep is enough in most cases */
+		schedule_timeout_uninterruptible(msecs_to_jiffies(1));
 	} while (!ready);
 
 	beiscsi_log(phba, KERN_ERR,
-- 
1.9.1

