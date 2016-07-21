From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 04/28] be2iscsi: Reduce driver load/unload time
Date: Thu, 21 Jul 2016 14:37:41 +0530
Message-ID: <1469092085-14311-5-git-send-email-jitendra.bhivare@broadcom.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38027 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbcGUJIi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 05:08:38 -0400
Received: by mail-wm0-f53.google.com with SMTP id o80so16888121wme.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 02:08:37 -0700 (PDT)
In-Reply-To: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
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

