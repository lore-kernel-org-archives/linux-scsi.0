From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/4] lpfc 8.3.15: Add target queue depth throttling
Date: Wed, 14 Jul 2010 15:32:10 -0400
Message-ID: <1279135950.32010.4.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:37772 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754185Ab0GNTgt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2010 15:36:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add target queue depth throttling 

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    3 ++-
 lpfc_attr.c    |   12 +++++++++++-
 lpfc_hbadisc.c |    2 +-
 lpfc_scsi.c    |   15 ++++++++-------
 4 files changed, 22 insertions(+), 10 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2010-07-09 00:49:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2010-07-14 13:47:38.000000000 -0400
@@ -2208,6 +2208,13 @@ LPFC_VPORT_ATTR_R(lun_queue_depth, 30, 1
 		  "Max number of FCP commands we can queue to a specific LUN");
 
 /*
+# tgt_queue_depth:  This parameter is used to limit the number of outstanding
+# commands per target port. Value range is [10,65535]. Default value is 65535.
+*/
+LPFC_VPORT_ATTR_R(tgt_queue_depth, 65535, 10, 65535,
+	"Max number of FCP commands we can queue to a specific target port");
+
+/*
 # hba_queue_depth:  This parameter is used to limit the number of outstanding
 # commands per lpfc HBA. Value range is [32,8192]. If this parameter
 # value is greater than the maximum number of exchanges supported by the HBA,
@@ -3122,7 +3129,7 @@ lpfc_max_scsicmpl_time_set(struct lpfc_v
 			continue;
 		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 			continue;
-		ndlp->cmd_qdepth = LPFC_MAX_TGT_QDEPTH;
+		ndlp->cmd_qdepth = vport->cfg_tgt_queue_depth;
 	}
 	spin_unlock_irq(shost->host_lock);
 	return 0;
@@ -3326,6 +3333,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_temp_sensor,
 	&dev_attr_lpfc_log_verbose,
 	&dev_attr_lpfc_lun_queue_depth,
+	&dev_attr_lpfc_tgt_queue_depth,
 	&dev_attr_lpfc_hba_queue_depth,
 	&dev_attr_lpfc_peer_port_login,
 	&dev_attr_lpfc_nodev_tmo,
@@ -3387,6 +3395,7 @@ struct device_attribute *lpfc_vport_attr
 	&dev_attr_lpfc_drvr_version,
 	&dev_attr_lpfc_log_verbose,
 	&dev_attr_lpfc_lun_queue_depth,
+	&dev_attr_lpfc_tgt_queue_depth,
 	&dev_attr_lpfc_nodev_tmo,
 	&dev_attr_lpfc_devloss_tmo,
 	&dev_attr_lpfc_hba_queue_depth,
@@ -4575,6 +4584,7 @@ lpfc_get_vport_cfgparam(struct lpfc_vpor
 {
 	lpfc_log_verbose_init(vport, lpfc_log_verbose);
 	lpfc_lun_queue_depth_init(vport, lpfc_lun_queue_depth);
+	lpfc_tgt_queue_depth_init(vport, lpfc_tgt_queue_depth);
 	lpfc_devloss_tmo_init(vport, lpfc_devloss_tmo);
 	lpfc_nodev_tmo_init(vport, lpfc_nodev_tmo);
 	lpfc_peer_port_login_init(vport, lpfc_peer_port_login);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-07-09 00:49:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2010-07-14 13:47:38.000000000 -0400
@@ -48,7 +48,7 @@ struct lpfc_sli2_slim;
 #define LPFC_TGTQ_INTERVAL	40000	/* Min amount of time between tgt
 					   queue depth change in millisecs */
 #define LPFC_TGTQ_RAMPUP_PCENT	5	/* Target queue rampup in percentage */
-#define LPFC_MIN_TGT_QDEPTH	100
+#define LPFC_MIN_TGT_QDEPTH	10
 #define LPFC_MAX_TGT_QDEPTH	0xFFFF
 
 #define  LPFC_MAX_BUCKET_COUNT 20	/* Maximum no. of buckets for stat data
@@ -400,6 +400,7 @@ struct lpfc_vport {
 	uint32_t cfg_max_luns;
 	uint32_t cfg_enable_da_id;
 	uint32_t cfg_max_scsicmpl_time;
+	uint32_t cfg_tgt_queue_depth;
 
 	uint32_t dev_loss_tmo_changed;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-07-14 13:47:16.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-07-14 13:47:38.000000000 -0400
@@ -3583,7 +3583,7 @@ lpfc_initialize_node(struct lpfc_vport *
 	kref_init(&ndlp->kref);
 	NLP_INT_NODE_ACT(ndlp);
 	atomic_set(&ndlp->cmd_pending, 0);
-	ndlp->cmd_qdepth = LPFC_MAX_TGT_QDEPTH;
+	ndlp->cmd_qdepth = vport->cfg_tgt_queue_depth;
 }
 
 struct lpfc_nodelist *
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-07-14 13:46:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-07-14 13:47:38.000000000 -0400
@@ -2458,14 +2458,16 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		}
 		spin_unlock_irqrestore(shost->host_lock, flags);
 	} else if (pnode && NLP_CHK_NODE_ACT(pnode)) {
-		if ((pnode->cmd_qdepth < LPFC_MAX_TGT_QDEPTH) &&
+		if ((pnode->cmd_qdepth < vport->cfg_tgt_queue_depth) &&
 		   time_after(jiffies, pnode->last_change_time +
 			      msecs_to_jiffies(LPFC_TGTQ_INTERVAL))) {
 			spin_lock_irqsave(shost->host_lock, flags);
-			pnode->cmd_qdepth += pnode->cmd_qdepth *
-				LPFC_TGTQ_RAMPUP_PCENT / 100;
-			if (pnode->cmd_qdepth > LPFC_MAX_TGT_QDEPTH)
-				pnode->cmd_qdepth = LPFC_MAX_TGT_QDEPTH;
+			depth = pnode->cmd_qdepth * LPFC_TGTQ_RAMPUP_PCENT
+				/ 100;
+			depth = depth ? depth : 1;
+			pnode->cmd_qdepth += depth;
+			if (pnode->cmd_qdepth > vport->cfg_tgt_queue_depth)
+				pnode->cmd_qdepth = vport->cfg_tgt_queue_depth;
 			pnode->last_change_time = jiffies;
 			spin_unlock_irqrestore(shost->host_lock, flags);
 		}
@@ -2920,8 +2922,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 		cmnd->result = ScsiResult(DID_TRANSPORT_DISRUPTED, 0);
 		goto out_fail_command;
 	}
-	if (vport->cfg_max_scsicmpl_time &&
-		(atomic_read(&ndlp->cmd_pending) >= ndlp->cmd_qdepth))
+	if (atomic_read(&ndlp->cmd_pending) >= ndlp->cmd_qdepth)
 		goto out_host_busy;
 
 	lpfc_cmd = lpfc_get_scsi_buf(phba);


