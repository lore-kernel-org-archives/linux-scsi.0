From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1] fcoe: use continue instead of goto+label
Date: Tue,  5 May 2015 14:56:39 +0200
Message-ID: <1430830599-19406-1-git-send-email-jslaby@suse.cz>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57450 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1423065AbbEEM4r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 08:56:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: robert.w.love@intel.com
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>, fcoe-devel@open-fcoe.org

There is a label pointing to the start of a while loop and a goto
nested only in the loop. The goto jumps to the label in some cases.
Replace the goto and the label by simple continue.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Robert Love <robert.w.love@intel.com>
Cc: fcoe-devel@open-fcoe.org
---
 drivers/scsi/fcoe/fcoe.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ec193a8357d7..179d0ff5562f 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1873,7 +1873,6 @@ static int fcoe_percpu_receive_thread(void *arg)
 
 	set_user_nice(current, MIN_NICE);
 
-retry:
 	while (!kthread_should_stop()) {
 
 		spin_lock_bh(&p->fcoe_rx_list.lock);
@@ -1883,7 +1882,7 @@ retry:
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock_bh(&p->fcoe_rx_list.lock);
 			schedule();
-			goto retry;
+			continue;
 		}
 
 		spin_unlock_bh(&p->fcoe_rx_list.lock);
-- 
2.3.5

