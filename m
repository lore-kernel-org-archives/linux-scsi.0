From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] ib_srpt: Call target_sess_cmd_list_set_waiting during shutdown_session
Date: Sat, 18 May 2013 00:40:31 +0000
Message-ID: <1368837631-2239-4-git-send-email-nab@linux-iscsi.org>
References: <1368837631-2239-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1368837631-2239-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Joern Engel <joern@logfs.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Given that srpt_release_channel_work() calls target_wait_for_sess_cmds()
to allow outstanding se_cmd_t->cmd_kref a change to complete, the call
to perform target_sess_cmd_list_set_waiting() needs to happen in
srpt_shutdown_session()

Also, this patch adds an explicit call to srpt_shutdown_session() within
srpt_drain_channel() so that target_sess_cmd_list_set_waiting() will be
called in the cases where TFO->shutdown_session() is not triggered
directly by TCM.

Cc: Joern Engel <joern@logfs.org>
Cc: Roland Dreier <roland@kernel.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   32 ++++++++++++++++++++++++--------
 drivers/infiniband/ulp/srpt/ib_srpt.h |    1 +
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c318f7c..824b704 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2227,6 +2227,27 @@ static void srpt_close_ch(struct srpt_rdma_ch *ch)
 }
 
 /**
+ * srpt_shutdown_session() - Whether or not a session may be shut down.
+ */
+static int srpt_shutdown_session(struct se_session *se_sess)
+{
+	struct srpt_rdma_ch *ch = se_sess->fabric_sess_ptr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ch->spinlock, flags);
+	if (ch->in_shutdown) {
+		spin_unlock_irqrestore(&ch->spinlock, flags);
+		return true;
+	}
+
+	ch->in_shutdown = true;
+	target_sess_cmd_list_set_waiting(se_sess);
+	spin_unlock_irqrestore(&ch->spinlock, flags);
+
+	return true;
+}
+
+/**
  * srpt_drain_channel() - Drain a channel by resetting the IB queue pair.
  * @cm_id: Pointer to the CM ID of the channel to be drained.
  *
@@ -2264,6 +2285,9 @@ static void srpt_drain_channel(struct ib_cm_id *cm_id)
 	spin_unlock_irq(&sdev->spinlock);
 
 	if (do_reset) {
+		if (ch->sess)
+			srpt_shutdown_session(ch->sess);
+
 		ret = srpt_ch_qp_err(ch);
 		if (ret < 0)
 			printk(KERN_ERR "Setting queue pair in error state"
@@ -3467,14 +3491,6 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 }
 
 /**
- * srpt_shutdown_session() - Whether or not a session may be shut down.
- */
-static int srpt_shutdown_session(struct se_session *se_sess)
-{
-	return true;
-}
-
-/**
  * srpt_close_session() - Forcibly close a session.
  *
  * Callback function invoked by the TCM core to clean up sessions associated
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 4caf55c..3dae156 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -325,6 +325,7 @@ struct srpt_rdma_ch {
 	u8			sess_name[36];
 	struct work_struct	release_work;
 	struct completion	*release_done;
+	bool			in_shutdown;
 };
 
 /**
-- 
1.7.2.5
