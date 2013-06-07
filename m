From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 7/9] target: Drop legacy se_cmd->check_release bit
Date: Fri,  7 Jun 2013 21:34:22 +0000
Message-ID: <1370640864-15568-8-git-send-email-nab@linux-iscsi.org>
References: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48629 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab3FGVr6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jun 2013 17:47:58 -0400
In-Reply-To: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Now with iscsi-target using modern se_cmd->cmd_kref accounting in
v3.10 code, it's safe to go ahead and drop the legacy release
codepath + se_cmd->check_release bit in transport_release_cmd()

Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Moussa Ba <moussaba@micron.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    8 +-------
 include/target/target_core_base.h      |    2 --
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 77c0b29..abb7e40 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1951,11 +1951,7 @@ static void transport_release_cmd(struct se_cmd *cmd)
 	 * If this cmd has been setup with target_get_sess_cmd(), drop
 	 * the kref and call ->release_cmd() in kref callback.
 	 */
-	 if (cmd->check_release != 0) {
-		target_put_sess_cmd(cmd->se_sess, cmd);
-		return;
-	}
-	cmd->se_tfo->release_cmd(cmd);
+	target_put_sess_cmd(cmd->se_sess, cmd);
 }
 
 /**
@@ -2171,8 +2167,6 @@ int target_get_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd,
 		goto out;
 	}
 	list_add_tail(&se_cmd->se_cmd_list, &se_sess->sess_cmd_list);
-	se_cmd->check_release = 1;
-
 out:
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 	return ret;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 3b337b9..a5c97db 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -424,8 +424,6 @@ struct se_cmd {
 	int			sam_task_attr;
 	/* Transport protocol dependent state, see transport_state_table */
 	enum transport_state_table t_state;
-	/* Used to signal cmd->se_tfo->check_release_cmd() usage per cmd */
-	unsigned		check_release:1;
 	unsigned		cmd_wait_set:1;
 	unsigned		unknown_data_length:1;
 	/* See se_cmd_flags_table */
-- 
1.7.2.5

