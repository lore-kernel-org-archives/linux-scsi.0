From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 2/5] iscsi-target: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:38:51 +0530
Message-ID: <1506074934-15062-3-git-send-email-allen.lkml@gmail.com>
References: <1506074934-15062-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35934 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751847AbdIVKJH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 06:09:07 -0400
In-Reply-To: <1506074934-15062-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, target-devel@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index dc13afb..e608fd5 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -866,10 +866,9 @@ static void iscsi_start_login_thread_timer(struct iscsi_np *np)
 	 * point we do not have access to ISCSI_TPG_ATTRIB(tpg)->login_timeout
 	 */
 	spin_lock_bh(&np->np_thread_lock);
-	init_timer(&np->np_login_timer);
+	setup_timer(&np->np_login_timer, iscsi_handle_login_thread_timeout,
+		    (unsigned long)np);
 	np->np_login_timer.expires = (get_jiffies_64() + TA_LOGIN_TIMEOUT * HZ);
-	np->np_login_timer.data = (unsigned long)np;
-	np->np_login_timer.function = iscsi_handle_login_thread_timeout;
 	np->np_login_timer_flags &= ~ISCSI_TF_STOP;
 	np->np_login_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&np->np_login_timer);
-- 
2.7.4
