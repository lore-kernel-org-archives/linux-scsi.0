From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] target: Convert se_nacl->nacl_sess_lock to use spin_lock_irq()
Date: Mon, 13 Dec 2010 15:58:43 -0800
Message-ID: <1292284723-6806-3-git-send-email-nab@linux-iscsi.org>
References: <1292284723-6806-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm28-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.234]:25371 "HELO
	nm28-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756864Ab0LMX64 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Dec 2010 18:58:56 -0500
In-Reply-To: <1292284723-6806-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the usage of se_nacl->nacl_sess_lock to use
spin_[un]lock_irq in __transport_register_session() and
transport_deregister_session_configfs(), along with the iSCSI specific
fabric_lib TransportID handlers in target_core_fabric_lib.c

This patch also changes PRI logic in core_scsi3_pri_read_full_status() to
increment pr_reg->pr_res_holders and drop pr_tmpl->registration_lock while
calling TPG_TFO(se_tpg)->tpg_get_pr_transport_id*() for the iSCSI TransportID
case that needs to obtain se_nacl->nacl_sess_lock.

This has been done to allow transport_deregister_session_configfs() to be called
from interrupt context for HW target mode.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit cc8a8c3cb55293822871ce40c2cec73163206203)
---
 drivers/target/target_core_fabric_lib.c |    8 ++++----
 drivers/target/target_core_pr.c         |   11 +++++++++++
 drivers/target/target_core_transport.c  |    8 ++++----
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index f4b34d3..3e6986d 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -229,7 +229,7 @@ u32 iscsi_get_pr_transport_id(
 	u32 off = 4, padding = 0;
 	u16 len = 0;
 
-	spin_lock(&se_nacl->nacl_sess_lock);
+	spin_lock_irq(&se_nacl->nacl_sess_lock);
 	/*
 	 * Set PROTOCOL IDENTIFIER to 5h for iSCSI
 	*/
@@ -293,7 +293,7 @@ u32 iscsi_get_pr_transport_id(
 		buf[off+len] = '\0'; off++;
 		len += 7;
 	}
-	spin_unlock(&se_nacl->nacl_sess_lock);
+	spin_unlock_irq(&se_nacl->nacl_sess_lock);
 	/*
 	 * The ADDITIONAL LENGTH field specifies the number of bytes that follow
 	 * in the TransportID. The additional length shall be at least 20 and
@@ -323,7 +323,7 @@ u32 iscsi_get_pr_transport_id_len(
 {
 	u32 len = 0, padding = 0;
 
-	spin_lock(&se_nacl->nacl_sess_lock);
+	spin_lock_irq(&se_nacl->nacl_sess_lock);
 	len = strlen(se_nacl->initiatorname);
 	/*
 	 * Add extra byte for NULL terminator
@@ -342,7 +342,7 @@ u32 iscsi_get_pr_transport_id_len(
 		*format_code = 1;
 	} else
 		*format_code = 0;
-	spin_unlock(&se_nacl->nacl_sess_lock);
+	spin_unlock_irq(&se_nacl->nacl_sess_lock);
 	/*
 	 * The ADDITIONAL LENGTH field specifies the number of bytes that follow
 	 * in the TransportID. The additional length shall be at least 20 and
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 5d6c545..6b275bb 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -4042,6 +4042,10 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		se_nacl = pr_reg->pr_reg_nacl;
 		se_tpg = pr_reg->pr_reg_nacl->se_tpg;
 		add_desc_len = 0;
+
+		atomic_inc(&pr_reg->pr_res_holders);
+		smp_mb__after_atomic_inc();
+		spin_unlock(&pr_tmpl->registration_lock);
 		/*
 		 * Determine expected length of $FABRIC_MOD specific
 		 * TransportID full status descriptor..
@@ -4052,6 +4056,9 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		if ((exp_desc_len + add_len) > cmd->data_length) {
 			printk(KERN_WARNING "SPC-3 PRIN READ_FULL_STATUS ran"
 				" out of buffer: %d\n", cmd->data_length);
+			spin_lock(&pr_tmpl->registration_lock);
+			atomic_dec(&pr_reg->pr_res_holders);
+			smp_mb__after_atomic_dec();
 			break;
 		}
 		/*
@@ -4110,6 +4117,10 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		 */
 		desc_len = TPG_TFO(se_tpg)->tpg_get_pr_transport_id(se_tpg,
 				se_nacl, pr_reg, &format_code, &buf[off+4]);
+
+		spin_lock(&pr_tmpl->registration_lock);
+		atomic_dec(&pr_reg->pr_res_holders);
+		smp_mb__after_atomic_dec();
 		/*
 		 * Set the ADDITIONAL DESCRIPTOR LENGTH
 		 */
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 019ccbc..dbc2800 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -474,7 +474,7 @@ void __transport_register_session(
 					&buf[0], PR_REG_ISID_LEN);
 			se_sess->sess_bin_isid = get_unaligned_be64(&buf[0]);
 		}
-		spin_lock_bh(&se_nacl->nacl_sess_lock);
+		spin_lock_irq(&se_nacl->nacl_sess_lock);
 		/*
 		 * The se_nacl->nacl_sess pointer will be set to the
 		 * last active I_T Nexus for each struct se_node_acl.
@@ -483,7 +483,7 @@ void __transport_register_session(
 
 		list_add_tail(&se_sess->sess_acl_list,
 			      &se_nacl->acl_sess_list);
-		spin_unlock_bh(&se_nacl->nacl_sess_lock);
+		spin_unlock_irq(&se_nacl->nacl_sess_lock);
 	}
 	list_add_tail(&se_sess->sess_list, &se_tpg->tpg_sess_list);
 
@@ -513,7 +513,7 @@ void transport_deregister_session_configfs(struct se_session *se_sess)
 	 */
 	se_nacl = se_sess->se_node_acl;
 	if ((se_nacl)) {
-		spin_lock_bh(&se_nacl->nacl_sess_lock);
+		spin_lock_irq(&se_nacl->nacl_sess_lock);
 		list_del(&se_sess->sess_acl_list);
 		/*
 		 * If the session list is empty, then clear the pointer.
@@ -527,7 +527,7 @@ void transport_deregister_session_configfs(struct se_session *se_sess)
 					se_nacl->acl_sess_list.prev,
 					struct se_session, sess_acl_list);	
 		}
-		spin_unlock_bh(&se_nacl->nacl_sess_lock);
+		spin_unlock_irq(&se_nacl->nacl_sess_lock);
 	}
 }
 EXPORT_SYMBOL(transport_deregister_session_configfs);
-- 
1.5.6.5

