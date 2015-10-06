From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH -resend 1/1] fcoe: use continue instead of goto+label
Date: Tue,  6 Oct 2015 14:27:45 +0200
Message-ID: <1444134465-3693-1-git-send-email-jslaby@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: JBottomley@Odin.com, kxie@chelsio.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>, Robert Love <robert.w.love@intel.com>, fcoe-devel@open-fcoe.org
List-Id: linux-scsi@vger.kernel.org

There is a label pointing to the start of a while loop and a goto
nested only in the loop. The goto jumps to the label in some cases.
Replace the goto and the label by simple continue.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Robert Love <robert.w.love@intel.com>
Cc: fcoe-devel@open-fcoe.org
---
Sent on:
May 5

 drivers/scsi/fcoe/fcoe.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index d3eb80c46bbe..d187ba9b361d 100644
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
2.6.1
