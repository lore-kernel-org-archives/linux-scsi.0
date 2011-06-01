From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target: merge release_cmd methods
Date: Tue, 31 May 2011 23:56:57 -0400
Message-ID: <20110601035657.GA17204@infradead.org>
References: <20110601015718.GA28574@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41172
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161048Ab1FAD46 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2011 23:56:58 -0400
Content-Disposition: inline
In-Reply-To: <20110601015718.GA28574@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

[add the missing lists]

On Tue, May 31, 2011 at 09:57:18PM -0400, Christoph Hellwig wrote:
The release_cmd_to_pool and release_cmd_direct methods are always the same.
Merge them into a single release_cmd method, and clean up the fallout.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/Documentation/target/tcm_mod_builder.py
===================================================================
--- lio-core.orig/Documentation/target/tcm_mod_builder.py	2011-06-01 10:49:28.612952513 +0900
+++ lio-core/Documentation/target/tcm_mod_builder.py	2011-06-01 10:49:56.186139886 +0900
@@ -391,8 +391,7 @@ def tcm_mod_build_configfs(proto_ident,
 	buf += "	.tpg_alloc_fabric_acl		= " + fabric_mod_name + "_alloc_fabric_acl,\n"
 	buf += "	.tpg_release_fabric_acl		= " + fabric_mod_name + "_release_fabric_acl,\n"
 	buf += "	.tpg_get_inst_index		= " + fabric_mod_name + "_tpg_get_inst_index,\n"
-	buf += "	.release_cmd_to_pool		= " + fabric_mod_name + "_release_cmd,\n"
-	buf += "	.release_cmd_direct		= " + fabric_mod_name + "_release_cmd,\n"
+	buf += "	.release_cmd			= " + fabric_mod_name + "_release_cmd,\n"
 	buf += "	.shutdown_session		= " + fabric_mod_name + "_shutdown_session,\n"
 	buf += "	.close_session			= " + fabric_mod_name + "_close_session,\n"
 	buf += "	.stop_session			= " + fabric_mod_name + "_stop_session,\n"
@@ -814,7 +813,7 @@ def tcm_mod_dump_fabric_ops(proto_ident,
 			buf += "}\n\n"
 			bufi += "u32 " + fabric_mod_name + "_tpg_get_inst_index(struct se_portal_group *);\n"
 
-		if re.search('release_cmd_to_pool', fo):
+		if re.search('release_cmd', fo):
 			buf += "void " + fabric_mod_name + "_release_cmd(struct se_cmd *se_cmd)\n"
 			buf += "{\n"
 			buf += "	return;\n"
Index: lio-core/drivers/infiniband/ulp/srpt/ib_srpt.c
===================================================================
--- lio-core.orig/drivers/infiniband/ulp/srpt/ib_srpt.c	2011-06-01 10:49:28.612952513 +0900
+++ lio-core/drivers/infiniband/ulp/srpt/ib_srpt.c	2011-06-01 10:49:56.190140643 +0900
@@ -1347,7 +1347,7 @@ static void srpt_put_send_ioctx(struct s
 	WARN_ON(srpt_get_cmd_state(ioctx) != SRPT_STATE_DONE);
 
 	srpt_unmap_sg_to_ib_sge(ioctx->ch, ioctx);
-	transport_generic_free_cmd(&ioctx->cmd, 0, 1, 0);
+	transport_generic_free_cmd(&ioctx->cmd, 0, 0);
 
 	if (ioctx->n_rbuf > 1) {
 		kfree(ioctx->rbufs);
@@ -3845,8 +3845,7 @@ static struct target_core_fabric_ops srp
 	.tpg_alloc_fabric_acl		= srpt_alloc_fabric_acl,
 	.tpg_release_fabric_acl		= srpt_release_fabric_acl,
 	.tpg_get_inst_index		= srpt_tpg_get_inst_index,
-	.release_cmd_to_pool		= srpt_release_cmd,
-	.release_cmd_direct		= srpt_release_cmd,
+	.release_cmd			= srpt_release_cmd,
 	.check_stop_free		= srpt_check_stop_free,
 	.shutdown_session		= srpt_shutdown_session,
 	.close_session			= srpt_close_session,
Index: lio-core/drivers/scsi/ibmvscsi/ibmvscsis.c
===================================================================
--- lio-core.orig/drivers/scsi/ibmvscsi/ibmvscsis.c	2011-06-01 10:49:28.612952513 +0900
+++ lio-core/drivers/scsi/ibmvscsi/ibmvscsis.c	2011-06-01 10:49:56.198141506 +0900
@@ -446,8 +446,7 @@ static struct target_core_fabric_ops ibm
 	.tpg_get_inst_index		= ibmvscsis_tpg_get_inst_index,
 	.new_cmd_map			= ibmvscsis_new_cmd_map,
 	.check_stop_free		= ibmvscsis_check_stop_free,
-	.release_cmd_to_pool		= ibmvscsis_release_cmd,
-	.release_cmd_direct		= ibmvscsis_release_cmd,
+	.release_cmd			= ibmvscsis_release_cmd,
 	.shutdown_session		= ibmvscsis_shutdown_session,
 	.close_session			= ibmvscsis_close_session,
 	.stop_session			= ibmvscsis_stop_session,
@@ -923,7 +922,7 @@ static void ibmvscsis_check_stop_free(st
 {
 	if (se_cmd->se_tmr_req)
 		return;
-	transport_generic_free_cmd(se_cmd, 0, 1, 0);
+	transport_generic_free_cmd(se_cmd, 0, 0);
 }
 
 static u64 scsi_lun_to_int(u64 lun)
Index: lio-core/drivers/target/iscsi/iscsi_target_configfs.c
===================================================================
--- lio-core.orig/drivers/target/iscsi/iscsi_target_configfs.c	2011-06-01 10:49:28.616669144 +0900
+++ lio-core/drivers/target/iscsi/iscsi_target_configfs.c	2011-06-01 10:49:56.202164421 +0900
@@ -1758,13 +1758,6 @@ static void lio_set_default_node_attribu
 	iscsit_set_default_node_attribues(acl);
 }
 
-static void lio_release_cmd_direct(struct se_cmd *se_cmd)
-{
-	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
-
-	iscsit_release_cmd(cmd);
-}
-
 static void lio_release_cmd(struct se_cmd *se_cmd)
 {
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
@@ -1809,8 +1802,7 @@ int iscsi_target_register_configfs(void)
 	fabric->tf_ops.tpg_alloc_fabric_acl = &lio_tpg_alloc_fabric_acl;
 	fabric->tf_ops.tpg_release_fabric_acl = &lio_tpg_release_fabric_acl;
 	fabric->tf_ops.tpg_get_inst_index = &lio_tpg_get_inst_index;
-	fabric->tf_ops.release_cmd_to_pool = &lio_release_cmd;
-	fabric->tf_ops.release_cmd_direct = &lio_release_cmd_direct;
+	fabric->tf_ops.release_cmd = &lio_release_cmd;
 	fabric->tf_ops.shutdown_session = &lio_tpg_shutdown_session;
 	fabric->tf_ops.close_session = &lio_tpg_close_session;
 	fabric->tf_ops.stop_session = &lio_tpg_stop_session;
Index: lio-core/drivers/target/loopback/tcm_loop.c
===================================================================
--- lio-core.orig/drivers/target/loopback/tcm_loop.c	2011-06-01 10:49:28.616669144 +0900
+++ lio-core/drivers/target/loopback/tcm_loop.c	2011-06-01 10:49:56.206198785 +0900
@@ -204,13 +204,10 @@ static void tcm_loop_check_stop_free(str
 	 * Release the struct se_cmd, which will make a callback to release
 	 * struct tcm_loop_cmd * in tcm_loop_deallocate_core_cmd()
 	 */
-	transport_generic_free_cmd(se_cmd, 0, 1, 0);
+	transport_generic_free_cmd(se_cmd, 0, 0);
 }
 
-/*
- * Called from struct target_core_fabric_ops->release_cmd_to_pool()
- */
-static void tcm_loop_deallocate_core_cmd(struct se_cmd *se_cmd)
+static void tcm_loop_release_cmd(struct se_cmd *se_cmd)
 {
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
 				struct tcm_loop_cmd, tl_se_cmd);
@@ -395,7 +392,7 @@ static int tcm_loop_device_reset(struct
 		SUCCESS : FAILED;
 release:
 	if (se_cmd)
-		transport_generic_free_cmd(se_cmd, 1, 1, 0);
+		transport_generic_free_cmd(se_cmd, 1, 0);
 	else
 		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 	kfree(tl_tmr);
@@ -1415,8 +1412,7 @@ static int tcm_loop_register_configfs(vo
 	 */
 	fabric->tf_ops.new_cmd_map = &tcm_loop_new_cmd_map;
 	fabric->tf_ops.check_stop_free = &tcm_loop_check_stop_free;
-	fabric->tf_ops.release_cmd_to_pool = &tcm_loop_deallocate_core_cmd;
-	fabric->tf_ops.release_cmd_direct = &tcm_loop_deallocate_core_cmd;
+	fabric->tf_ops.release_cmd = &tcm_loop_release_cmd;
 	fabric->tf_ops.shutdown_session = &tcm_loop_shutdown_session;
 	fabric->tf_ops.close_session = &tcm_loop_close_session;
 	fabric->tf_ops.stop_session = &tcm_loop_stop_session;
Index: lio-core/drivers/target/target_core_configfs.c
===================================================================
--- lio-core.orig/drivers/target/target_core_configfs.c	2011-06-01 10:49:28.616669144 +0900
+++ lio-core/drivers/target/target_core_configfs.c	2011-06-01 10:49:56.206198785 +0900
@@ -427,12 +427,8 @@ static int target_fabric_tf_ops_check(
 		printk(KERN_ERR "Missing tfo->tpg_get_inst_index()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->release_cmd_to_pool)) {
-		printk(KERN_ERR "Missing tfo->release_cmd_to_pool()\n");
-		return -EINVAL;
-	}
-	if (!(tfo->release_cmd_direct)) {
-		printk(KERN_ERR "Missing tfo->release_cmd_direct()\n");
+	if (!tfo->release_cmd) {
+		printk(KERN_ERR "Missing tfo->release_cmd()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->shutdown_session)) {
Index: lio-core/drivers/target/target_core_transport.c
===================================================================
--- lio-core.orig/drivers/target/target_core_transport.c	2011-06-01 10:49:28.616669144 +0900
+++ lio-core/drivers/target/target_core_transport.c	2011-06-01 10:49:56.214140137 +0900
@@ -213,7 +213,7 @@ static u32 transport_allocate_tasks(stru
 		struct list_head *mem_list, int set_counts);
 static int transport_generic_get_mem(struct se_cmd *cmd, u32 length);
 static int transport_generic_remove(struct se_cmd *cmd,
-		int release_to_pool, int session_reinstatement);
+		int session_reinstatement);
 static int transport_cmd_get_valid_sectors(struct se_cmd *cmd);
 static int transport_map_sg_to_mem(struct se_cmd *cmd,
 		struct list_head *se_mem_list, struct scatterlist *sgl);
@@ -738,7 +738,7 @@ void transport_cmd_finish_abort(struct s
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return;
 	if (remove)
-		transport_generic_remove(cmd, 0, 0);
+		transport_generic_remove(cmd, 0);
 }
 
 void transport_cmd_finish_abort_tmr(struct se_cmd *cmd)
@@ -748,7 +748,7 @@ void transport_cmd_finish_abort_tmr(stru
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return;
 
-	transport_generic_remove(cmd, 0, 0);
+	transport_generic_remove(cmd, 0);
 }
 
 static void transport_add_cmd_to_queue(
@@ -2151,7 +2151,7 @@ static void transport_generic_request_ti
 	}
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	transport_generic_remove(cmd, 0, 0);
+	transport_generic_remove(cmd, 0);
 }
 
 static int
@@ -3831,13 +3831,11 @@ static void transport_release_fe_cmd(str
 free_pages:
 	transport_free_pages(cmd);
 	transport_free_se_cmd(cmd);
-	cmd->se_tfo->release_cmd_direct(cmd);
+	cmd->se_tfo->release_cmd(cmd);
 }
 
-static int transport_generic_remove(
-	struct se_cmd *cmd,
-	int release_to_pool,
-	int session_reinstatement)
+static int
+transport_generic_remove(struct se_cmd *cmd, int session_reinstatement)
 {
 	unsigned long flags;
 
@@ -3864,14 +3862,7 @@ static int transport_generic_remove(
 
 free_pages:
 	transport_free_pages(cmd);
-
-	if (release_to_pool) {
-		transport_release_cmd_to_pool(cmd);
-	} else {
-		transport_free_se_cmd(cmd);
-		cmd->se_tfo->release_cmd_direct(cmd);
-	}
-
+	transport_release_cmd(cmd);
 	return 0;
 }
 
@@ -4901,18 +4892,14 @@ static int transport_generic_write_pendi
 	return PYX_TRANSPORT_WRITE_PENDING;
 }
 
-/*	transport_release_cmd_to_pool():
- *
- *
- */
-void transport_release_cmd_to_pool(struct se_cmd *cmd)
+void transport_release_cmd(struct se_cmd *cmd)
 {
 	BUG_ON(!cmd->se_tfo);
 
 	transport_free_se_cmd(cmd);
-	cmd->se_tfo->release_cmd_to_pool(cmd);
+	cmd->se_tfo->release_cmd(cmd);
 }
-EXPORT_SYMBOL(transport_release_cmd_to_pool);
+EXPORT_SYMBOL(transport_release_cmd);
 
 /*	transport_generic_free_cmd():
  *
@@ -4921,11 +4908,10 @@ EXPORT_SYMBOL(transport_release_cmd_to_p
 void transport_generic_free_cmd(
 	struct se_cmd *cmd,
 	int wait_for_tasks,
-	int release_to_pool,
 	int session_reinstatement)
 {
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD))
-		transport_release_cmd_to_pool(cmd);
+		transport_release_cmd(cmd);
 	else {
 		core_dec_lacl_count(cmd->se_sess->se_node_acl, cmd);
 
@@ -4943,8 +4929,7 @@ void transport_generic_free_cmd(
 
 		transport_free_dev_tasks(cmd);
 
-		transport_generic_remove(cmd, release_to_pool,
-				session_reinstatement);
+		transport_generic_remove(cmd, session_reinstatement);
 	}
 }
 EXPORT_SYMBOL(transport_generic_free_cmd);
@@ -5217,7 +5202,7 @@ remove:
 	if (!remove_cmd)
 		return;
 
-	transport_generic_free_cmd(cmd, 0, 0, session_reinstatement);
+	transport_generic_free_cmd(cmd, 0, session_reinstatement);
 }
 
 static int transport_get_sense_codes(
@@ -5623,7 +5608,7 @@ static void transport_processing_shutdow
 				transport_lun_remove_cmd(cmd);
 
 				if (transport_cmd_check_stop(cmd, 1, 0))
-					transport_generic_remove(cmd, 0, 0);
+					transport_generic_remove(cmd, 0);
 			}
 
 			spin_lock_irqsave(&dev->execute_task_lock, flags);
@@ -5651,7 +5636,7 @@ static void transport_processing_shutdow
 			transport_lun_remove_cmd(cmd);
 
 			if (transport_cmd_check_stop(cmd, 1, 0))
-				transport_generic_remove(cmd, 0, 0);
+				transport_generic_remove(cmd, 0);
 		}
 
 		spin_lock_irqsave(&dev->execute_task_lock, flags);
@@ -5674,7 +5659,7 @@ static void transport_processing_shutdow
 		} else {
 			transport_lun_remove_cmd(cmd);
 			if (transport_cmd_check_stop(cmd, 1, 0))
-				transport_generic_remove(cmd, 0, 0);
+				transport_generic_remove(cmd, 0);
 		}
 	}
 }
@@ -5746,10 +5731,10 @@ get_cmd:
 			transport_generic_complete_ok(cmd);
 			break;
 		case TRANSPORT_REMOVE:
-			transport_generic_remove(cmd, 1, 0);
+			transport_generic_remove(cmd, 0);
 			break;
 		case TRANSPORT_FREE_CMD_INTR:
-			transport_generic_free_cmd(cmd, 0, 1, 0);
+			transport_generic_free_cmd(cmd, 0, 0);
 			break;
 		case TRANSPORT_PROCESS_TMR:
 			transport_generic_do_tmr(cmd);
Index: lio-core/drivers/target/tcm_fc/tfc_conf.c
===================================================================
--- lio-core.orig/drivers/target/tcm_fc/tfc_conf.c	2011-06-01 10:49:28.616669144 +0900
+++ lio-core/drivers/target/tcm_fc/tfc_conf.c	2011-06-01 10:49:56.218140368 +0900
@@ -536,8 +536,7 @@ static struct target_core_fabric_ops ft_
 	.tpg_release_fabric_acl =	ft_tpg_release_fabric_acl,
 	.tpg_get_inst_index =		ft_tpg_get_inst_index,
 	.check_stop_free =		ft_check_stop_free,
-	.release_cmd_to_pool =		ft_release_cmd,
-	.release_cmd_direct =		ft_release_cmd,
+	.release_cmd =			ft_release_cmd,
 	.shutdown_session =		ft_sess_shutdown,
 	.close_session =		ft_sess_close,
 	.stop_session =			ft_sess_stop,
Index: lio-core/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
===================================================================
--- lio-core.orig/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c	2011-06-01 10:49:28.616669144 +0900
+++ lio-core/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c	2011-06-01 10:49:56.226168154 +0900
@@ -1212,8 +1212,7 @@ static struct target_core_fabric_ops tcm
 	.tpg_get_inst_index		= tcm_qla2xxx_tpg_get_inst_index,
 	.new_cmd_map			= tcm_qla2xxx_new_cmd_map,
 	.check_stop_free		= tcm_qla2xxx_check_stop_free,
-	.release_cmd_to_pool		= tcm_qla2xxx_release_cmd,
-	.release_cmd_direct		= tcm_qla2xxx_release_cmd,
+	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.shutdown_session		= tcm_qla2xxx_shutdown_session,
 	.close_session			= tcm_qla2xxx_close_session,
 	.stop_session			= tcm_qla2xxx_stop_session,
@@ -1263,8 +1262,7 @@ static struct target_core_fabric_ops tcm
 	.tpg_alloc_fabric_acl		= tcm_qla2xxx_alloc_fabric_acl,
 	.tpg_release_fabric_acl		= tcm_qla2xxx_release_fabric_acl,
 	.tpg_get_inst_index		= tcm_qla2xxx_tpg_get_inst_index,
-	.release_cmd_to_pool		= tcm_qla2xxx_release_cmd,
-	.release_cmd_direct		= tcm_qla2xxx_release_cmd,
+	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.shutdown_session		= tcm_qla2xxx_shutdown_session,
 	.close_session			= tcm_qla2xxx_close_session,
 	.stop_session			= tcm_qla2xxx_stop_session,
Index: lio-core/drivers/target/tcm_vhost/tcm_vhost_configfs.c
===================================================================
--- lio-core.orig/drivers/target/tcm_vhost/tcm_vhost_configfs.c	2011-06-01 10:49:28.620869063 +0900
+++ lio-core/drivers/target/tcm_vhost/tcm_vhost_configfs.c	2011-06-01 10:49:56.232961784 +0900
@@ -615,8 +615,7 @@ static struct target_core_fabric_ops tcm
 	.tpg_release_fabric_acl		= tcm_vhost_release_fabric_acl,
 	.tpg_get_inst_index		= tcm_vhost_tpg_get_inst_index,
 	.new_cmd_map			= tcm_vhost_new_cmd_map,
-	.release_cmd_to_pool		= tcm_vhost_release_cmd,
-	.release_cmd_direct		= tcm_vhost_release_cmd,
+	.release_cmd			= tcm_vhost_release_cmd,
 	.shutdown_session		= tcm_vhost_shutdown_session,
 	.close_session			= tcm_vhost_close_session,
 	.stop_session			= tcm_vhost_stop_session,
Index: lio-core/include/target/target_core_fabric_ops.h
===================================================================
--- lio-core.orig/include/target/target_core_fabric_ops.h	2011-06-01 10:49:28.620869063 +0900
+++ lio-core/include/target/target_core_fabric_ops.h	2011-06-01 10:49:56.236794826 +0900
@@ -43,8 +43,7 @@ struct target_core_fabric_ops {
 	 * I/O descriptor in transport_cmd_check_stop()
 	 */
 	void (*check_stop_free)(struct se_cmd *);
-	void (*release_cmd_to_pool)(struct se_cmd *);
-	void (*release_cmd_direct)(struct se_cmd *);
+	void (*release_cmd)(struct se_cmd *);
 	/*
 	 * Called with spin_lock_bh(struct se_portal_group->session_lock held.
 	 */
Index: lio-core/drivers/target/iscsi/iscsi_target.c
===================================================================
--- lio-core.orig/drivers/target/iscsi/iscsi_target.c	2011-06-01 10:49:28.612952513 +0900
+++ lio-core/drivers/target/iscsi/iscsi_target.c	2011-06-01 10:49:56.236794826 +0900
@@ -3570,7 +3570,7 @@ get_immediate:
 					iscsit_release_cmd(cmd);
 				else
 					transport_generic_free_cmd(SE_CMD(cmd),
-								1, 1, 0);
+								1, 0);
 				goto get_immediate;
 			case ISTATE_SEND_NOPIN_WANT_RESPONSE:
 				spin_unlock_bh(&cmd->istate_lock);
@@ -3985,7 +3985,7 @@ static void iscsit_release_commands_from
 			if (cmd->tmr_req && se_cmd->transport_wait_for_tasks)
 				se_cmd->transport_wait_for_tasks(se_cmd, 1, 1);
 			else if (SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD)
-				transport_release_cmd_to_pool(se_cmd);
+				transport_release_cmd(se_cmd);
 			else
 				iscsit_release_cmd(cmd);
 
Index: lio-core/drivers/target/tcm_fc/tfc_cmd.c
===================================================================
--- lio-core.orig/drivers/target/tcm_fc/tfc_cmd.c	2011-06-01 10:49:28.616669144 +0900
+++ lio-core/drivers/target/tcm_fc/tfc_cmd.c	2011-06-01 10:49:56.240642544 +0900
@@ -150,7 +150,7 @@ void ft_release_cmd(struct se_cmd *se_cm
 
 void ft_check_stop_free(struct se_cmd *se_cmd)
 {
-	transport_generic_free_cmd(se_cmd, 0, 1, 0);
+	transport_generic_free_cmd(se_cmd, 0, 0);
 }
 
 /*
Index: lio-core/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
===================================================================
--- lio-core.orig/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c	2011-06-01 10:49:28.616669144 +0900
+++ lio-core/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c	2011-06-01 10:49:56.250139600 +0900
@@ -407,7 +407,7 @@ void tcm_qla2xxx_check_stop_free(struct
 		 * Release the associated se_cmd->se_tmr_req and se_cmd
 		 * TMR related state now.
 		 */
-		transport_generic_free_cmd(se_cmd, 1, 1, 0);
+		transport_generic_free_cmd(se_cmd, 1, 0);
 		qla_tgt_free_mcmd(mcmd);
 		return;
 	}
@@ -709,7 +709,7 @@ int tcm_qla2xxx_handle_tmr(struct qla_tg
 	 * Locate the underlying TCM struct se_lun from sc->device->lun
 	 */
 	if (transport_lookup_tmr_lun(se_cmd, lun) < 0) {
-		transport_generic_free_cmd(se_cmd, 1, 1, 0);
+		transport_generic_free_cmd(se_cmd, 1, 0);
 		return -EINVAL;
 	}
 	/*
Index: lio-core/include/target/target_core_transport.h
===================================================================
--- lio-core.orig/include/target/target_core_transport.h	2011-06-01 10:49:09.741141041 +0900
+++ lio-core/include/target/target_core_transport.h	2011-06-01 10:49:56.250139600 +0900
@@ -179,8 +179,8 @@ extern int transport_clear_lun_from_sess
 extern int transport_check_aborted_status(struct se_cmd *, int);
 extern int transport_send_check_condition_and_sense(struct se_cmd *, u8, int);
 extern void transport_send_task_abort(struct se_cmd *);
-extern void transport_release_cmd_to_pool(struct se_cmd *);
-extern void transport_generic_free_cmd(struct se_cmd *, int, int, int);
+extern void transport_release_cmd(struct se_cmd *);
+extern void transport_generic_free_cmd(struct se_cmd *, int, int);
 extern void transport_generic_wait_for_cmds(struct se_cmd *, int);
 extern int transport_init_task_sg(struct se_task *, struct se_mem *, u32);
 extern int transport_map_mem_to_sg(struct se_task *, struct list_head *,
