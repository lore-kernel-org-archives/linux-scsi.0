From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] iscsi-target: Set session_fall_back_to_erl0 when forcing reinstatement
Date: Wed,  3 May 2017 06:13:35 +0000
Message-ID: <1493792016-6435-3-git-send-email-nab@linux-iscsi.org>
References: <1493792016-6435-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42694 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751863AbdECGMH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2017 02:12:07 -0400
In-Reply-To: <1493792016-6435-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Gary Guo <ghg@datera.io>, Bill Borsari <wgb@datera.io>, Raghu Krishnamurthy <rk@datera.io>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

While testing modification of per se_node_acl queue_depth forcing
session reinstatement via lio_target_nacl_cmdsn_depth_store() ->
core_tpg_set_initiator_node_queue_depth(), a hung task bug triggered
when changing cmdsn_depth invoked session reinstatement while an iscsi
login was already waiting for session reinstatement to complete.

This can happen when an outstanding se_cmd descriptor is taking a
long time to complete, and session reinstatement from iscsi login
or cmdsn_depth change occurs concurrently.

To address this bug, explicitly set session_fall_back_to_erl0 = 1
when forcing session reinstatement, so session reinstatement is
not attempted if an active session is already being shutdown.

This patch has been tested with two scenarios.  The first when
iscsi login is blocked waiting for iscsi session reinstatement
to complete followed by queue_depth change via configfs, and
second when queue_depth change via configfs us blocked followed
by a iscsi login driven session reinstatement.

Note this patch depends on commit d36ad77f702 to handle multiple
sessions per se_node_acl when changing cmdsn_depth, and for
pre v4.5 kernels will need to be included for stable as well.

Reported-by: Gary Guo <ghg@datera.io>
Tested-by: Gary Guo <ghg@datera.io>
Cc: Gary Guo <ghg@datera.io>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c          | 1 +
 drivers/target/iscsi/iscsi_target_configfs.c | 1 +
 drivers/target/iscsi/iscsi_target_login.c    | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 0f7ade0..26a9bcd 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4663,6 +4663,7 @@ int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 			continue;
 		}
 		atomic_set(&sess->session_reinstatement, 1);
+		atomic_set(&sess->session_fall_back_to_erl0, 1);
 		spin_unlock(&sess->conn_lock);
 
 		list_move_tail(&se_sess->sess_list, &free_list);
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 344e844..96d9c73 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1528,6 +1528,7 @@ static void lio_tpg_close_session(struct se_session *se_sess)
 		return;
 	}
 	atomic_set(&sess->session_reinstatement, 1);
+	atomic_set(&sess->session_fall_back_to_erl0, 1);
 	spin_unlock(&sess->conn_lock);
 
 	iscsit_stop_time2retain_timer(sess);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index ad8f301..6623847 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -208,6 +208,7 @@ int iscsi_check_for_session_reinstatement(struct iscsi_conn *conn)
 			    initiatorname_param->value) &&
 		   (sess_p->sess_ops->SessionType == sessiontype))) {
 			atomic_set(&sess_p->session_reinstatement, 1);
+			atomic_set(&sess_p->session_fall_back_to_erl0, 1);
 			spin_unlock(&sess_p->conn_lock);
 			iscsit_inc_session_usage_count(sess_p);
 			iscsit_stop_time2retain_timer(sess_p);
-- 
1.9.1
