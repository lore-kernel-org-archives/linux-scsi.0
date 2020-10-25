Return-Path: <SRS0=2Tp4=EA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5A6C388F7
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 23:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4C8B223BD
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 23:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aFZ3ZGnu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1420398AbgJYXDl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 19:03:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55134 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1419413AbgJYXDi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Oct 2020 19:03:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09PMxl7w014830;
        Sun, 25 Oct 2020 23:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=B8/pZtClnINozBHxvHIG7PHhLYoPYy9YXFLAnc9F1dE=;
 b=aFZ3ZGnuqhSRbflfoTVoFP/tXfRDs8F+Ebu5YU+FEU1WpUx2ItPS85oW1Rr9MWlx/iPU
 fKZuub6dcZ6k9OytNyK9NcRpspRJ2Ai5LX3H/rqMq3mV1Ha3YW+rvbjLjXaeVxPOConM
 ODQwXyR8SeQaeN4Z28j3U70Du7aQVYkMHMqgKjB8YfRVxTWr9pRRs3WFxYlQVPaNN1mV
 F17gaJfGgzZk4NWRsmG9fbrqwezNkrGKuDLvnUKWAM7Vdx5Kz4Kafoei6hZy8ByfWsLM
 9+JSg0TS3qB79iCrTR334GIIdWhsEGdpQjtMi+3SbGT3+6i1hpVcMrR8HbRACP21ywlC Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kjg70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 25 Oct 2020 23:03:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09PN0IX2032893;
        Sun, 25 Oct 2020 23:03:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwujrt6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Oct 2020 23:03:27 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09PN3QWh013510;
        Sun, 25 Oct 2020 23:03:26 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 25 Oct 2020 16:03:26 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 6/7] target: make state_list per cpu'ish
Date:   Sun, 25 Oct 2020 18:03:17 -0500
Message-Id: <1603666998-8086-7-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
References: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=2
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010250174
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do a state_list/execute_task_lock per cpu, so we can do submissions
from different CPUs without contention.

Note: tcm_fc was passing TARGET_SCF_USE_CPUID, but never set cpuid.
I think it wanted to set the cpuid to the CPU it was submitting
from so it will get this behavior with this patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |   3 -
 drivers/target/target_core_device.c    |  16 +++-
 drivers/target/target_core_tmr.c       | 166 +++++++++++++++++----------------
 drivers/target/target_core_transport.c |  22 ++---
 drivers/target/tcm_fc/tfc_cmd.c        |   2 +-
 include/target/target_core_base.h      |  14 ++-
 6 files changed, 121 insertions(+), 102 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index c971c4f..2be24f2 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -457,9 +457,6 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	if (bidi)
 		target_flags |= TARGET_SCF_BIDI_OP;
 
-	if (se_cmd->cpuid != WORK_CPU_UNBOUND)
-		target_flags |= TARGET_SCF_USE_CPUID;
-
 	sess = cmd->sess;
 	if (!sess) {
 		pr_err("Unable to locate struct fc_port from qla_tgt_cmd\n");
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 405d82d..55b0980 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -724,11 +724,24 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 {
 	struct se_device *dev;
 	struct se_lun *xcopy_lun;
+	int i;
 
 	dev = hba->backend->ops->alloc_device(hba, name);
 	if (!dev)
 		return NULL;
 
+	dev->queues = kcalloc(nr_cpu_ids, sizeof(*dev->queues), GFP_KERNEL);
+	if (!dev->queues) {
+		dev->transport->free_device(dev);
+		return NULL;
+	}
+
+	dev->queue_cnt = nr_cpu_ids;
+	for (i = 0; i < dev->queue_cnt; i++) {
+		INIT_LIST_HEAD(&dev->queues[i].state_list);
+		spin_lock_init(&dev->queues[i].lock);
+	}
+
 	dev->se_hba = hba;
 	dev->transport = hba->backend->ops;
 	dev->transport_flags = dev->transport->transport_flags_default;
@@ -738,9 +751,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	INIT_LIST_HEAD(&dev->dev_sep_list);
 	INIT_LIST_HEAD(&dev->dev_tmr_list);
 	INIT_LIST_HEAD(&dev->delayed_cmd_list);
-	INIT_LIST_HEAD(&dev->state_list);
 	INIT_LIST_HEAD(&dev->qf_cmd_list);
-	spin_lock_init(&dev->execute_task_lock);
 	spin_lock_init(&dev->delayed_cmd_lock);
 	spin_lock_init(&dev->dev_reservation_lock);
 	spin_lock_init(&dev->se_port_lock);
@@ -1013,6 +1024,7 @@ void target_free_device(struct se_device *dev)
 	if (dev->transport->free_prot)
 		dev->transport->free_prot(dev);
 
+	kfree(dev->queues);
 	dev->transport->free_device(dev);
 }
 
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index e4513ef..6e12541 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -121,57 +121,61 @@ void core_tmr_abort_task(
 	unsigned long flags;
 	bool rc;
 	u64 ref_tag;
-
-	spin_lock_irqsave(&dev->execute_task_lock, flags);
-	list_for_each_entry_safe(se_cmd, next, &dev->state_list, state_list) {
-
-		if (se_sess != se_cmd->se_sess)
-			continue;
-
-		/* skip task management functions, including tmr->task_cmd */
-		if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
-			continue;
-
-		ref_tag = se_cmd->tag;
-		if (tmr->ref_task_tag != ref_tag)
-			continue;
-
-		printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
-			se_cmd->se_tfo->fabric_name, ref_tag);
-
-		spin_lock(&se_sess->sess_cmd_lock);
-		rc = __target_check_io_state(se_cmd, se_sess, 0);
-		spin_unlock(&se_sess->sess_cmd_lock);
-		if (!rc)
-			continue;
-
-		list_move_tail(&se_cmd->state_list, &aborted_list);
-		se_cmd->state_active = false;
-
-		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
-
-		/*
-		 * Ensure that this ABORT request is visible to the LU RESET
-		 * code.
-		 */
-		if (!tmr->tmr_dev)
-			WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd) <
-					0);
-
-		if (dev->transport->tmr_notify)
-			dev->transport->tmr_notify(dev, TMR_ABORT_TASK,
-						   &aborted_list);
-
-		list_del_init(&se_cmd->state_list);
-		target_put_cmd_and_wait(se_cmd);
-
-		printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for"
-				" ref_tag: %llu\n", ref_tag);
-		tmr->response = TMR_FUNCTION_COMPLETE;
-		atomic_long_inc(&dev->aborts_complete);
-		return;
+	int i;
+
+	for (i = 0; i < dev->queue_cnt; i++) {
+		spin_lock_irqsave(&dev->queues[i].lock, flags);
+		list_for_each_entry_safe(se_cmd, next, &dev->queues[i].state_list,
+					 state_list) {
+			if (se_sess != se_cmd->se_sess)
+				continue;
+
+			/*
+			 * skip task management functions, including
+			 * tmr->task_cmd
+			 */
+			if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
+				continue;
+
+			ref_tag = se_cmd->tag;
+			if (tmr->ref_task_tag != ref_tag)
+				continue;
+
+			printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
+			       se_cmd->se_tfo->fabric_name, ref_tag);
+
+			spin_lock(&se_sess->sess_cmd_lock);
+			rc = __target_check_io_state(se_cmd, se_sess, 0);
+			spin_unlock(&se_sess->sess_cmd_lock);
+			if (!rc)
+				continue;
+
+			list_move_tail(&se_cmd->state_list, &aborted_list);
+			se_cmd->state_active = false;
+			spin_unlock_irqrestore(&dev->queues[i].lock, flags);
+
+			/*
+			 * Ensure that this ABORT request is visible to the LU
+			 * RESET code.
+			 */
+			if (!tmr->tmr_dev)
+				WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd) < 0);
+
+			if (dev->transport->tmr_notify)
+				dev->transport->tmr_notify(dev, TMR_ABORT_TASK,
+							   &aborted_list);
+
+			list_del_init(&se_cmd->state_list);
+			target_put_cmd_and_wait(se_cmd);
+
+			printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: %llu\n",
+			       ref_tag);
+			tmr->response = TMR_FUNCTION_COMPLETE;
+			atomic_long_inc(&dev->aborts_complete);
+			return;
+		}
+		spin_unlock_irqrestore(&dev->queues[i].lock, flags);
 	}
-	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
 	if (dev->transport->tmr_notify)
 		dev->transport->tmr_notify(dev, TMR_ABORT_TASK, &aborted_list);
@@ -273,7 +277,7 @@ static void core_tmr_drain_state_list(
 	struct se_session *sess;
 	struct se_cmd *cmd, *next;
 	unsigned long flags;
-	int rc;
+	int rc, i;
 
 	/*
 	 * Complete outstanding commands with TASK_ABORTED SAM status.
@@ -297,35 +301,39 @@ static void core_tmr_drain_state_list(
 	 * Note that this seems to be independent of TAS (Task Aborted Status)
 	 * in the Control Mode Page.
 	 */
-	spin_lock_irqsave(&dev->execute_task_lock, flags);
-	list_for_each_entry_safe(cmd, next, &dev->state_list, state_list) {
-		/*
-		 * For PREEMPT_AND_ABORT usage, only process commands
-		 * with a matching reservation key.
-		 */
-		if (target_check_cdb_and_preempt(preempt_and_abort_list, cmd))
-			continue;
-
-		/*
-		 * Not aborting PROUT PREEMPT_AND_ABORT CDB..
-		 */
-		if (prout_cmd == cmd)
-			continue;
-
-		sess = cmd->se_sess;
-		if (WARN_ON_ONCE(!sess))
-			continue;
-
-		spin_lock(&sess->sess_cmd_lock);
-		rc = __target_check_io_state(cmd, tmr_sess, tas);
-		spin_unlock(&sess->sess_cmd_lock);
-		if (!rc)
-			continue;
-
-		list_move_tail(&cmd->state_list, &drain_task_list);
-		cmd->state_active = false;
+	for (i = 0; i < dev->queue_cnt; i++) {
+		spin_lock_irqsave(&dev->queues[i].lock, flags);
+		list_for_each_entry_safe(cmd, next, &dev->queues[i].state_list,
+					 state_list) {
+			/*
+			 * For PREEMPT_AND_ABORT usage, only process commands
+			 * with a matching reservation key.
+			 */
+			if (target_check_cdb_and_preempt(preempt_and_abort_list,
+							 cmd))
+				continue;
+
+			/*
+			 * Not aborting PROUT PREEMPT_AND_ABORT CDB..
+			 */
+			if (prout_cmd == cmd)
+				continue;
+
+			sess = cmd->se_sess;
+			if (WARN_ON_ONCE(!sess))
+				continue;
+
+			spin_lock(&sess->sess_cmd_lock);
+			rc = __target_check_io_state(cmd, tmr_sess, tas);
+			spin_unlock(&sess->sess_cmd_lock);
+			if (!rc)
+				continue;
+
+			list_move_tail(&cmd->state_list, &drain_task_list);
+			cmd->state_active = false;
+		}
+		spin_unlock_irqrestore(&dev->queues[i].lock, flags);
 	}
-	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
 	if (dev->transport->tmr_notify)
 		dev->transport->tmr_notify(dev, preempt_and_abort_list ?
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b228c66..71a6ec3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -659,12 +659,12 @@ static void target_remove_from_state_list(struct se_cmd *cmd)
 	if (!dev)
 		return;
 
-	spin_lock_irqsave(&dev->execute_task_lock, flags);
+	spin_lock_irqsave(&dev->queues[cmd->cpuid].lock, flags);
 	if (cmd->state_active) {
 		list_del(&cmd->state_list);
 		cmd->state_active = false;
 	}
-	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
+	spin_unlock_irqrestore(&dev->queues[cmd->cpuid].lock, flags);
 }
 
 /*
@@ -875,10 +875,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 
 	INIT_WORK(&cmd->work, success ? target_complete_ok_work :
 		  target_complete_failure_work);
-	if (cmd->se_cmd_flags & SCF_USE_CPUID)
-		queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
-	else
-		queue_work(target_completion_wq, &cmd->work);
+	queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
 }
 EXPORT_SYMBOL(target_complete_cmd);
 
@@ -906,12 +903,13 @@ static void target_add_to_state_list(struct se_cmd *cmd)
 	struct se_device *dev = cmd->se_dev;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dev->execute_task_lock, flags);
+	spin_lock_irqsave(&dev->queues[cmd->cpuid].lock, flags);
 	if (!cmd->state_active) {
-		list_add_tail(&cmd->state_list, &dev->state_list);
+		list_add_tail(&cmd->state_list,
+			      &dev->queues[cmd->cpuid].state_list);
 		cmd->state_active = true;
 	}
-	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
+	spin_unlock_irqrestore(&dev->queues[cmd->cpuid].lock, flags);
 }
 
 /*
@@ -1398,6 +1396,7 @@ void transport_init_se_cmd(
 	cmd->sam_task_attr = task_attr;
 	cmd->sense_buffer = sense_buffer;
 	cmd->orig_fe_lun = unpacked_lun;
+	cmd->cpuid = smp_processor_id();
 
 	cmd->state_active = false;
 }
@@ -1625,11 +1624,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 				data_length, data_dir, task_attr, sense,
 				unpacked_lun);
 
-	if (flags & TARGET_SCF_USE_CPUID)
-		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
-	else
-		se_cmd->cpuid = WORK_CPU_UNBOUND;
-
 	if (flags & TARGET_SCF_UNKNOWN_SIZE)
 		se_cmd->unknown_data_length = 1;
 	/*
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index a7ed566..8936a09 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -551,7 +551,7 @@ static void ft_send_work(struct work_struct *work)
 	if (target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, fcp->fc_cdb,
 			      &cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
 			      ntohl(fcp->fc_dl), task_attr, data_dir,
-			      TARGET_SCF_ACK_KREF | TARGET_SCF_USE_CPUID))
+			      TARGET_SCF_ACK_KREF))
 		goto err;
 
 	pr_debug("r_ctl %x target_submit_cmd %p\n", fh->fh_r_ctl, cmd);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 2824463..7b42dc7 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -143,7 +143,6 @@ enum se_cmd_flags_table {
 	SCF_COMPARE_AND_WRITE		= 0x00080000,
 	SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC = 0x00200000,
 	SCF_ACK_KREF			= 0x00400000,
-	SCF_USE_CPUID			= 0x00800000,
 	SCF_TASK_ATTR_SET		= 0x01000000,
 	SCF_TREAT_READ_AS_NORMAL	= 0x02000000,
 };
@@ -540,6 +539,10 @@ struct se_cmd {
 	unsigned int		t_prot_nents;
 	sense_reason_t		pi_err;
 	sector_t		bad_sector;
+	/*
+	 * CPU LIO will execute the cmd on. Defaults to the CPU the cmd is
+	 * initialized on. Drivers can override.
+	 */
 	int			cpuid;
 };
 
@@ -760,6 +763,11 @@ struct se_dev_stat_grps {
 	struct config_group scsi_lu_group;
 };
 
+struct se_device_queue {
+	struct list_head	state_list;
+	spinlock_t		lock;
+};
+
 struct se_device {
 	/* RELATIVE TARGET PORT IDENTIFER Counter */
 	u16			dev_rpti_counter;
@@ -792,7 +800,6 @@ struct se_device {
 	atomic_t		dev_qf_count;
 	u32			export_count;
 	spinlock_t		delayed_cmd_lock;
-	spinlock_t		execute_task_lock;
 	spinlock_t		dev_reservation_lock;
 	unsigned int		dev_reservation_flags;
 #define DRF_SPC2_RESERVATIONS			0x00000001
@@ -811,7 +818,6 @@ struct se_device {
 	struct list_head	dev_tmr_list;
 	struct work_struct	qf_work_queue;
 	struct list_head	delayed_cmd_list;
-	struct list_head	state_list;
 	struct list_head	qf_cmd_list;
 	/* Pointer to associated SE HBA */
 	struct se_hba		*se_hba;
@@ -838,6 +844,8 @@ struct se_device {
 	/* For se_lun->lun_se_dev RCU read-side critical access */
 	u32			hba_index;
 	struct rcu_head		rcu_head;
+	int			queue_cnt;
+	struct se_device_queue	*queues;
 };
 
 struct se_hba {
-- 
1.8.3.1

