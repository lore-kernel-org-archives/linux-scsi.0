From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 29/31] scsi/bnx2i: Initialize timer
Date: Wed, 20 Sep 2017 16:27:53 -0700
Message-ID: <1505950075-50223-30-git-send-email-keescook@chromium.org>
References: <1505950075-50223-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505950075-50223-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>, QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There was a seemingly missing call to setup_timer() in one handler,
so add setup_timer() here to remove the open-coded initialization.

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index bffc7e91b7e5..337139dadad0 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1611,9 +1611,9 @@ static int bnx2i_conn_start(struct iscsi_cls_conn *cls_conn)
 	 * this should normally not sleep for a long time so it should
 	 * not disrupt the caller.
 	 */
+	setup_timer(&bnx2i_conn->ep->ofld_timer, bnx2i_ep_ofld_timer,
+		    (unsigned long) bnx2i_conn->ep);
 	bnx2i_conn->ep->ofld_timer.expires = 1 * HZ + jiffies;
-	bnx2i_conn->ep->ofld_timer.function = bnx2i_ep_ofld_timer;
-	bnx2i_conn->ep->ofld_timer.data = (unsigned long) bnx2i_conn->ep;
 	add_timer(&bnx2i_conn->ep->ofld_timer);
 	/* update iSCSI context for this conn, wait for CNIC to complete */
 	wait_event_interruptible(bnx2i_conn->ep->ofld_wait,
-- 
2.7.4
