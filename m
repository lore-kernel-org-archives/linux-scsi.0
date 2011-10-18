From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ibmvscsis: Initial IBM vSCSI Target merge for v3.2-rc1
Date: Tue, 18 Oct 2011 11:08:49 +0200
Message-ID: <20111018090849.GA22131@lst.de>
References: <1318585132-3618-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36309 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242Ab1JRJIv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Oct 2011 05:08:51 -0400
Content-Disposition: inline
In-Reply-To: <1318585132-3618-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@Parallels.com>

This needs a patch like the one below folded in.  In addition to not
unessecarily offload new command mapping to the fabric thread this
also fixes the currenly incorrect (outdated) handling of the return
values from transport_generic_allocate_tasks.  I don't even have
a ppc compiler at hand right now, so handle it with care.

---
From: Christoph Hellwig <hch@lst.de>
Subject: ibmvscsis: do not offload new command processing to the fabric thread

tcm_queuecommand is always called from process context, so prepare the command
in-process instead of offloading it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/scsi/ibmvscsi/ibmvscsis.c
===================================================================
--- lio-core.orig/drivers/scsi/ibmvscsi/ibmvscsis.c	2011-10-14 14:06:51.440394983 +0200
+++ lio-core/drivers/scsi/ibmvscsi/ibmvscsis.c	2011-10-14 14:07:06.072895825 +0200
@@ -424,7 +424,6 @@ static struct configfs_attribute *ibmvsc
 static int ibmvscsis_write_pending(struct se_cmd *se_cmd);
 static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd);
 static int ibmvscsis_queue_status(struct se_cmd *se_cmd);
-static int ibmvscsis_new_cmd_map(struct se_cmd *se_cmd);
 static void ibmvscsis_check_stop_free(struct se_cmd *se_cmd);
 
 static struct target_core_fabric_ops ibmvscsis_ops = {
@@ -444,7 +443,6 @@ static struct target_core_fabric_ops ibm
 	.tpg_alloc_fabric_acl		= ibmvscsis_alloc_fabric_acl,
 	.tpg_release_fabric_acl		= ibmvscsis_release_fabric_acl,
 	.tpg_get_inst_index		= ibmvscsis_tpg_get_inst_index,
-	.new_cmd_map			= ibmvscsis_new_cmd_map,
 	.check_stop_free		= ibmvscsis_check_stop_free,
 	.release_cmd			= ibmvscsis_release_cmd,
 	.shutdown_session		= ibmvscsis_shutdown_session,
@@ -839,8 +837,11 @@ static inline struct viosrp_crq *next_cr
 
 static int tcm_queuecommand(struct ibmvscsis_adapter *adapter,
 			    struct ibmvscsis_cmnd *vsc,
-			    struct srp_cmd *cmd)
+			    struct srp_cmd *scmd)
 {
+	struct scsi_cmnd *sc = &vsc->sc;
+	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
+
 	struct se_cmd *se_cmd;
 	int attr;
 	int data_len;
@@ -858,63 +859,50 @@ static int tcm_queuecommand(struct ibmvs
 		break;
 	default:
 		printk(KERN_WARNING "Task attribute %d not supported\n",
-		       cmd->task_attr);
+		       scmd->task_attr);
 		attr = MSG_SIMPLE_TAG;
 	}
 
-	data_len = srp_data_length(cmd, srp_cmd_direction(cmd));
+	data_len = srp_data_length(scmd, srp_cmd_direction(scmd));
 
 	se_cmd = &vsc->se_cmd;
 
 	transport_init_se_cmd(se_cmd,
 			      adapter->se_tpg.se_tpg_tfo,
 			      adapter->se_sess, data_len,
-			      srp_cmd_direction(cmd),
+			      srp_cmd_direction(scmd),
 			      attr, vsc->sense_buf);
 
-	ret = transport_lookup_cmd_lun(se_cmd, cmd->lun);
+	ret = transport_lookup_cmd_lun(se_cmd, scmd->lun);
 	if (ret) {
-		printk(KERN_ERR "invalid lun %u\n", GETLUN(cmd->lun));
+		printk(KERN_ERR "invalid lun %u\n", GETLUN(scmd->lun));
 		transport_send_check_condition_and_sense(se_cmd,
 							 se_cmd->scsi_sense_reason,
 							 0);
 		return ret;
 	}
 
-	transport_generic_handle_cdb_map(se_cmd);
-
-	return 0;
-}
-
-static int ibmvscsis_new_cmd_map(struct se_cmd *se_cmd)
-{
-	struct ibmvscsis_cmnd *cmd =
-		container_of(se_cmd, struct ibmvscsis_cmnd, se_cmd);
-	struct scsi_cmnd *sc = &cmd->sc;
-	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
-	struct srp_cmd *scmd = iue->sbuf->buf;
-	int ret;
-
 	/*
 	 * Allocate the necessary tasks to complete the received CDB+data
 	 */
 	ret = transport_generic_allocate_tasks(se_cmd, scmd->cdb);
-	if (ret == -1) {
-		/* Out of Resources */
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-	} else if (ret == -2) {
-		/*
-		 * Handle case for SAM_STAT_RESERVATION_CONFLICT
-		 */
+	if (ret == -ENOMEM) {
+		transport_send_check_condition_and_sense(se_cmd,
+				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
+		transport_generic_free_cmd(se_cmd, 0);
+		return;
+	}
+	if (ret == -EINVAL) {
 		if (se_cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT)
-			return PYX_TRANSPORT_RESERVATION_CONFLICT;
-		/*
-		 * Otherwise, return SAM_STAT_CHECK_CONDITION and return
-		 * sense data
-		 */
-		return PYX_TRANSPORT_USE_SENSE_REASON;
+			ibmvscsis_queue_status(se_cmd);
+		else
+			transport_send_check_condition_and_sense(se_cmd,
+					se_cmd->scsi_sense_reason, 0);
+		transport_generic_free_cmd(se_cmd, 0);
+		return;
 	}
 
+	transport_handle_cdb_direct(se_cmd);
 	return 0;
 }
 
