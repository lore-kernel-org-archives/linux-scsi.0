From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] target: Fix missing complete during ABORT_TASK +
	CMD_T_FABRIC_STOP
Date: Thu, 26 May 2016 08:33:42 +0200
Message-ID: <20160526063342.GA21689@lst.de>
References: <1464205660-7171-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464205660-7171-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <mchristi@redhat.com>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

I think the function could be further cut down, given that
 
 a) there is no need to take a lock to read a single field
 b) CMD_T_FABRIC_STOP is never cleared and we can check it later

See the incremental patch below:

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 69abcef..dad4ab8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2550,26 +2550,18 @@ static void target_release_cmd_kref(struct kref *kref)
 	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
 	struct se_session *se_sess = se_cmd->se_sess;
 	unsigned long flags;
-	bool fabric_stop;
 
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-
-	spin_lock(&se_cmd->t_state_lock);
-	fabric_stop = (se_cmd->transport_state & CMD_T_FABRIC_STOP);
-	spin_unlock(&se_cmd->t_state_lock);
-
-	if (se_cmd->cmd_wait_set || fabric_stop) {
-		list_del_init(&se_cmd->se_cmd_list);
-		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
-		target_free_cmd_mem(se_cmd);
-		complete(&se_cmd->cmd_wait_comp);
-		return;
-	}
 	list_del_init(&se_cmd->se_cmd_list);
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 
 	target_free_cmd_mem(se_cmd);
-	se_cmd->se_tfo->release_cmd(se_cmd);
+
+	if (se_cmd->cmd_wait_set ||
+	    (se_cmd->transport_state & CMD_T_FABRIC_STOP))
+		complete(&se_cmd->cmd_wait_comp);
+	else
+		se_cmd->se_tfo->release_cmd(se_cmd);
 }
 
 /* target_put_sess_cmd - Check for active I/O shutdown via kref_put
