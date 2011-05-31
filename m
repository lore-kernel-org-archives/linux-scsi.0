From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5] target: remove the always-noop ->new_cmd_failure method
Date: Tue, 31 May 2011 17:06:42 -0400
Message-ID: <20110531210702.702395664@bombadil.infradead.org>
References: <20110531210641.032149131@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42330
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932528Ab1EaVHD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2011 17:07:03 -0400
Content-Disposition: inline; filename=lio-kill-new_cmd_failure
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/Documentation/target/tcm_mod_builder.py
===================================================================
--- lio-core.orig/Documentation/target/tcm_mod_builder.py	2011-06-01 05:08:25.302132113 +0900
+++ lio-core/Documentation/target/tcm_mod_builder.py	2011-06-01 05:18:40.646628702 +0900
@@ -405,7 +405,6 @@ def tcm_mod_build_configfs(proto_ident,
 	buf += "	.set_default_node_attributes	= " + fabric_mod_name + "_set_default_node_attrs,\n"
 	buf += "	.get_task_tag			= " + fabric_mod_name + "_get_task_tag,\n"
 	buf += "	.get_cmd_state			= " + fabric_mod_name + "_get_cmd_state,\n"
-	buf += "	.new_cmd_failure		= " + fabric_mod_name + "_new_cmd_failure,\n"
 	buf += "	.queue_data_in			= " + fabric_mod_name + "_queue_data_in,\n"
 	buf += "	.queue_status			= " + fabric_mod_name + "_queue_status,\n"
 	buf += "	.queue_tm_rsp			= " + fabric_mod_name + "_queue_tm_rsp,\n"
@@ -899,13 +898,6 @@ def tcm_mod_dump_fabric_ops(proto_ident,
 			buf += "}\n\n"
 			bufi += "int " + fabric_mod_name + "_get_cmd_state(struct se_cmd *);\n"
 
-		if re.search('new_cmd_failure\)\(', fo):
-			buf += "void " + fabric_mod_name + "_new_cmd_failure(struct se_cmd *se_cmd)\n"
-			buf += "{\n"
-			buf += "	return;\n"
-			buf += "}\n\n"
-			bufi += "void " + fabric_mod_name + "_new_cmd_failure(struct se_cmd *);\n"
-
 		if re.search('queue_data_in\)\(', fo):
 			buf += "int " + fabric_mod_name + "_queue_data_in(struct se_cmd *se_cmd)\n"
 			buf += "{\n"
Index: lio-core/drivers/infiniband/ulp/srpt/ib_srpt.c
===================================================================
--- lio-core.orig/drivers/infiniband/ulp/srpt/ib_srpt.c	2011-06-01 05:08:50.594851892 +0900
+++ lio-core/drivers/infiniband/ulp/srpt/ib_srpt.c	2011-06-01 05:18:40.646628702 +0900
@@ -3596,10 +3596,6 @@ static int srpt_get_tcm_cmd_state(struct
 	return srpt_get_cmd_state(ioctx);
 }
 
-static void srpt_new_cmd_failure(struct se_cmd *se_cmd)
-{
-}
-
 static u16 srpt_set_fabric_sense_len(struct se_cmd *cmd, u32 sense_length)
 {
 	return 0;
@@ -3864,7 +3860,6 @@ static struct target_core_fabric_ops srp
 	.set_default_node_attributes	= srpt_set_default_node_attrs,
 	.get_task_tag			= srpt_get_task_tag,
 	.get_cmd_state			= srpt_get_tcm_cmd_state,
-	.new_cmd_failure		= srpt_new_cmd_failure,
 	.queue_data_in			= srpt_queue_response,
 	.queue_status			= srpt_queue_status,
 	.queue_tm_rsp			= srpt_queue_response,
Index: lio-core/drivers/scsi/ibmvscsi/ibmvscsis.c
===================================================================
--- lio-core.orig/drivers/scsi/ibmvscsi/ibmvscsis.c	2011-06-01 05:08:25.330131112 +0900
+++ lio-core/drivers/scsi/ibmvscsi/ibmvscsis.c	2011-06-01 05:18:40.650628569 +0900
@@ -291,11 +291,6 @@ static int ibmvscsis_get_cmd_state(struc
 	return 0;
 }
 
-static void ibmvscsis_new_cmd_failure(struct se_cmd *se_cmd)
-{
-	return;
-}
-
 static int ibmvscsis_queue_tm_rsp(struct se_cmd *se_cmd)
 {
 	return 0;
@@ -465,7 +460,6 @@ static struct target_core_fabric_ops ibm
 	.set_default_node_attributes	= ibmvscsis_set_default_node_attrs,
 	.get_task_tag			= ibmvscsis_get_task_tag,
 	.get_cmd_state			= ibmvscsis_get_cmd_state,
-	.new_cmd_failure		= ibmvscsis_new_cmd_failure,
 	.queue_data_in			= ibmvscsis_queue_data_in,
 	.queue_status			= ibmvscsis_queue_status,
 	.queue_tm_rsp			= ibmvscsis_queue_tm_rsp,
Index: lio-core/drivers/target/iscsi/iscsi_target_configfs.c
===================================================================
--- lio-core.orig/drivers/target/iscsi/iscsi_target_configfs.c	2011-06-01 05:08:51.054627663 +0900
+++ lio-core/drivers/target/iscsi/iscsi_target_configfs.c	2011-06-01 05:18:40.650628569 +0900
@@ -1508,11 +1508,6 @@ static int iscsi_get_cmd_state(struct se
 	return cmd->i_state;
 }
 
-static void iscsi_new_cmd_failure(struct se_cmd *se_cmd)
-{
-	/* We no longer sleep while core allocs (we do alloc), so we can ignore this */
-}
-
 static int iscsi_is_state_remove(struct se_cmd *se_cmd)
 {
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
@@ -1829,7 +1824,6 @@ int iscsi_target_register_configfs(void)
 				&lio_set_default_node_attributes;
 	fabric->tf_ops.get_task_tag = &iscsi_get_task_tag;
 	fabric->tf_ops.get_cmd_state = &iscsi_get_cmd_state;
-	fabric->tf_ops.new_cmd_failure = &iscsi_new_cmd_failure;
 	fabric->tf_ops.queue_data_in = &lio_queue_data_in;
 	fabric->tf_ops.queue_status = &lio_queue_status;
 	fabric->tf_ops.queue_tm_rsp = &lio_queue_tm_rsp;
Index: lio-core/drivers/target/loopback/tcm_loop.c
===================================================================
--- lio-core.orig/drivers/target/loopback/tcm_loop.c	2011-06-01 05:08:51.058627606 +0900
+++ lio-core/drivers/target/loopback/tcm_loop.c	2011-06-01 05:18:40.658628440 +0900
@@ -772,16 +772,6 @@ static u32 tcm_loop_get_inst_index(struc
 	return 1;
 }
 
-static void tcm_loop_new_cmd_failure(struct se_cmd *se_cmd)
-{
-	/*
-	 * Since TCM_loop is already passing struct scatterlist data from
-	 * struct scsi_cmnd, no more Linux/SCSI failure dependent state need
-	 * to be handled here.
-	 */
-	return;
-}
-
 static int tcm_loop_is_state_remove(struct se_cmd *se_cmd)
 {
 	/*
@@ -1443,7 +1433,6 @@ static int tcm_loop_register_configfs(vo
 					&tcm_loop_set_default_node_attributes;
 	fabric->tf_ops.get_task_tag = &tcm_loop_get_task_tag;
 	fabric->tf_ops.get_cmd_state = &tcm_loop_get_cmd_state;
-	fabric->tf_ops.new_cmd_failure = &tcm_loop_new_cmd_failure;
 	fabric->tf_ops.queue_data_in = &tcm_loop_queue_data_in;
 	fabric->tf_ops.queue_status = &tcm_loop_queue_status;
 	fabric->tf_ops.queue_tm_rsp = &tcm_loop_queue_tm_rsp;
Index: lio-core/drivers/target/target_core_configfs.c
===================================================================
--- lio-core.orig/drivers/target/target_core_configfs.c	2011-06-01 05:08:25.366135971 +0900
+++ lio-core/drivers/target/target_core_configfs.c	2011-06-01 05:18:40.666628498 +0900
@@ -479,10 +479,6 @@ static int target_fabric_tf_ops_check(
 		printk(KERN_ERR "Missing tfo->get_cmd_state()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->new_cmd_failure)) {
-		printk(KERN_ERR "Missing tfo->new_cmd_failure()\n");
-		return -EINVAL;
-	}
 	if (!(tfo->queue_data_in)) {
 		printk(KERN_ERR "Missing tfo->queue_data_in()\n");
 		return -EINVAL;
Index: lio-core/drivers/target/target_core_tmr.c
===================================================================
--- lio-core.orig/drivers/target/target_core_tmr.c	2011-06-01 05:08:51.062133656 +0900
+++ lio-core/drivers/target/target_core_tmr.c	2011-06-01 05:18:40.674629167 +0900
@@ -367,11 +367,6 @@ int core_tmr_lun_reset(
 			atomic_read(&cmd->t_fe_count));
 		/*
 		 * Signal that the command has failed via cmd->se_cmd_flags,
-		 * and call TFO->new_cmd_failure() to wakeup any fabric
-		 * dependent code used to wait for unsolicited data out
-		 * allocation to complete.  The fabric module is expected
-		 * to dump any remaining unsolicited data out for the aborted
-		 * command at this point.
 		 */
 		transport_new_cmd_failure(cmd);
 
Index: lio-core/drivers/target/target_core_transport.c
===================================================================
--- lio-core.orig/drivers/target/target_core_transport.c	2011-06-01 05:08:51.062133656 +0900
+++ lio-core/drivers/target/target_core_transport.c	2011-06-01 05:18:40.682628525 +0900
@@ -2592,8 +2592,6 @@ void transport_new_cmd_failure(struct se
 	se_cmd->se_cmd_flags |= SCF_SE_CMD_FAILED;
 	se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 	spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
-
-	se_cmd->se_tfo->new_cmd_failure(se_cmd);
 }
 
 static void transport_nop_wait_for_tasks(struct se_cmd *, int, int);
Index: lio-core/drivers/target/tcm_fc/tcm_fc.h
===================================================================
--- lio-core.orig/drivers/target/tcm_fc/tcm_fc.h	2011-06-01 05:08:25.398628943 +0900
+++ lio-core/drivers/target/tcm_fc/tcm_fc.h	2011-06-01 05:18:40.690629733 +0900
@@ -194,7 +194,6 @@ int ft_write_pending(struct se_cmd *);
 int ft_write_pending_status(struct se_cmd *);
 u32 ft_get_task_tag(struct se_cmd *);
 int ft_get_cmd_state(struct se_cmd *);
-void ft_new_cmd_failure(struct se_cmd *);
 int ft_queue_tm_resp(struct se_cmd *);
 int ft_is_state_remove(struct se_cmd *);
 
Index: lio-core/drivers/target/tcm_fc/tfc_cmd.c
===================================================================
--- lio-core.orig/drivers/target/tcm_fc/tfc_cmd.c	2011-06-01 05:08:51.062133656 +0900
+++ lio-core/drivers/target/tcm_fc/tfc_cmd.c	2011-06-01 05:18:40.690629733 +0900
@@ -295,12 +295,6 @@ int ft_is_state_remove(struct se_cmd *se
 	return 0;	/* XXX TBD */
 }
 
-void ft_new_cmd_failure(struct se_cmd *se_cmd)
-{
-	/* XXX TBD */
-	printk(KERN_INFO "%s: se_cmd %p\n", __func__, se_cmd);
-}
-
 /*
  * FC sequence response handler for follow-on sequences (data) and aborts.
  */
Index: lio-core/drivers/target/tcm_fc/tfc_conf.c
===================================================================
--- lio-core.orig/drivers/target/tcm_fc/tfc_conf.c	2011-06-01 05:08:47.430127397 +0900
+++ lio-core/drivers/target/tcm_fc/tfc_conf.c	2011-06-01 05:18:40.698629773 +0900
@@ -550,7 +550,6 @@ static struct target_core_fabric_ops ft_
 	.set_default_node_attributes =	ft_set_default_node_attr,
 	.get_task_tag =			ft_get_task_tag,
 	.get_cmd_state =		ft_get_cmd_state,
-	.new_cmd_failure =		ft_new_cmd_failure,
 	.queue_data_in =		ft_queue_data_in,
 	.queue_status =			ft_queue_status,
 	.queue_tm_rsp =			ft_queue_tm_resp,
Index: lio-core/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
===================================================================
--- lio-core.orig/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c	2011-06-01 05:08:51.062133656 +0900
+++ lio-core/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c	2011-06-01 05:18:40.706628239 +0900
@@ -1226,7 +1226,6 @@ static struct target_core_fabric_ops tcm
 	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
 	.get_task_tag			= tcm_qla2xxx_get_task_tag,
 	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
-	.new_cmd_failure		= tcm_qla2xxx_new_cmd_failure,
 	.queue_data_in			= tcm_qla2xxx_queue_data_in,
 	.queue_status			= tcm_qla2xxx_queue_status,
 	.queue_tm_rsp			= tcm_qla2xxx_queue_tm_rsp,
@@ -1278,7 +1277,6 @@ static struct target_core_fabric_ops tcm
 	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
 	.get_task_tag			= tcm_qla2xxx_get_task_tag,
 	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
-	.new_cmd_failure		= tcm_qla2xxx_new_cmd_failure,
 	.queue_data_in			= tcm_qla2xxx_queue_data_in,
 	.queue_status			= tcm_qla2xxx_queue_status,
 	.queue_tm_rsp			= tcm_qla2xxx_queue_tm_rsp,
Index: lio-core/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
===================================================================
--- lio-core.orig/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c	2011-06-01 05:08:51.062133656 +0900
+++ lio-core/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c	2011-06-01 05:18:40.714628399 +0900
@@ -561,11 +561,6 @@ int tcm_qla2xxx_get_cmd_state(struct se_
 	return 0;
 }
 
-void tcm_qla2xxx_new_cmd_failure(struct se_cmd *se_cmd)
-{
-	return;
-}
-
 /*
  * Main entry point for incoming ATIO packets from qla_target.c
  * and qla2xxx LLD code.
Index: lio-core/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h
===================================================================
--- lio-core.orig/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h	2011-06-01 05:08:51.062133656 +0900
+++ lio-core/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h	2011-06-01 05:18:40.722357128 +0900
@@ -38,7 +38,6 @@ extern int tcm_qla2xxx_write_pending_sta
 extern void tcm_qla2xxx_set_default_node_attrs(struct se_node_acl *);
 extern u32 tcm_qla2xxx_get_task_tag(struct se_cmd *);
 extern int tcm_qla2xxx_get_cmd_state(struct se_cmd *);
-extern void tcm_qla2xxx_new_cmd_failure(struct se_cmd *);
 extern int tcm_qla2xxx_handle_cmd(struct scsi_qla_host *, struct qla_tgt_cmd *,
                         uint32_t, uint32_t, int, int, int);
 extern int tcm_qla2xxx_new_cmd_map(struct se_cmd *);
Index: lio-core/drivers/target/tcm_vhost/tcm_vhost_configfs.c
===================================================================
--- lio-core.orig/drivers/target/tcm_vhost/tcm_vhost_configfs.c	2011-06-01 05:08:51.066159565 +0900
+++ lio-core/drivers/target/tcm_vhost/tcm_vhost_configfs.c	2011-06-01 05:18:40.730404967 +0900
@@ -629,7 +629,6 @@ static struct target_core_fabric_ops tcm
 	.set_default_node_attributes	= tcm_vhost_set_default_node_attrs,
 	.get_task_tag			= tcm_vhost_get_task_tag,
 	.get_cmd_state			= tcm_vhost_get_cmd_state,
-	.new_cmd_failure		= tcm_vhost_new_cmd_failure,
 	.queue_data_in			= tcm_vhost_queue_data_in,
 	.queue_status			= tcm_vhost_queue_status,
 	.queue_tm_rsp			= tcm_vhost_queue_tm_rsp,
Index: lio-core/drivers/target/tcm_vhost/tcm_vhost_fabric.c
===================================================================
--- lio-core.orig/drivers/target/tcm_vhost/tcm_vhost_fabric.c	2011-06-01 05:08:51.066159565 +0900
+++ lio-core/drivers/target/tcm_vhost/tcm_vhost_fabric.c	2011-06-01 05:18:40.730404967 +0900
@@ -351,11 +351,6 @@ int tcm_vhost_get_cmd_state(struct se_cm
 	return 0;
 }
 
-void tcm_vhost_new_cmd_failure(struct se_cmd *se_cmd)
-{
-	return;
-}
-
 int tcm_vhost_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct tcm_vhost_cmd *tv_cmd = container_of(se_cmd,
Index: lio-core/drivers/target/tcm_vhost/tcm_vhost_fabric.h
===================================================================
--- lio-core.orig/drivers/target/tcm_vhost/tcm_vhost_fabric.h	2011-06-01 05:08:51.066159565 +0900
+++ lio-core/drivers/target/tcm_vhost/tcm_vhost_fabric.h	2011-06-01 05:18:40.734630003 +0900
@@ -30,7 +30,6 @@ int tcm_vhost_write_pending_status(struc
 void tcm_vhost_set_default_node_attrs(struct se_node_acl *);
 u32 tcm_vhost_get_task_tag(struct se_cmd *);
 int tcm_vhost_get_cmd_state(struct se_cmd *);
-void tcm_vhost_new_cmd_failure(struct se_cmd *);
 int tcm_vhost_queue_data_in(struct se_cmd *);
 int tcm_vhost_queue_status(struct se_cmd *);
 int tcm_vhost_queue_tm_rsp(struct se_cmd *);
Index: lio-core/include/target/target_core_fabric_ops.h
===================================================================
--- lio-core.orig/include/target/target_core_fabric_ops.h	2011-06-01 05:08:51.154236383 +0900
+++ lio-core/include/target/target_core_fabric_ops.h	2011-06-01 05:18:40.742358557 +0900
@@ -65,7 +65,6 @@ struct target_core_fabric_ops {
 	void (*set_default_node_attributes)(struct se_node_acl *);
 	u32 (*get_task_tag)(struct se_cmd *);
 	int (*get_cmd_state)(struct se_cmd *);
-	void (*new_cmd_failure)(struct se_cmd *);
 	int (*queue_data_in)(struct se_cmd *);
 	int (*queue_status)(struct se_cmd *);
 	int (*queue_tm_rsp)(struct se_cmd *);

