Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E6EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 04:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbiFGErB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 00:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiFGEqq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 00:46:46 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FF0D2457
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 21:46:44 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256JXd0W025485
        for <linux-scsi@vger.kernel.org>; Mon, 6 Jun 2022 21:46:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=q1sq983D/YM002uvVvdLjX+9q4AR0r51cPXjtdKHIno=;
 b=g7K2kgkOzfwBVUuWIpgVZg6bbilDFXkVl4fnPuY5FFqySdADH/Yqpl58N0Iyw3WUlQsN
 LvsVLUToduMp46LVnabaLEdCXPtrkqrv/NBmKLRlZp+EjRSyXO2RvV0lDLdGW/FgOOC0
 nmXmZ2oWvDmzWN5Zo2ccXAH6RcHKCgMvEKYk9HeECTfKXxLQ/GyHxH5iMibpdi5i6Ycj
 iXnngsrXjaNeOj0LPRwJmdjdVNiMm4Sa51v0mXtSF84LQLdjvKicqUrlnzmh4gVAsojT
 WFGv+QhmqHi+0bZNmC45RrEU8sz1A8Nkt+43g0cIqmvzRO0a5e3Mpi++uwh/bIUPy8vs 4Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gg6wq8q8g-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jun 2022 21:46:43 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 6 Jun
 2022 21:46:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 6 Jun 2022 21:46:41 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DFA8C3F7068;
        Mon,  6 Jun 2022 21:46:40 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 04/11] qla2xxx: edif: add bsg interface to read doorbell events
Date:   Mon, 6 Jun 2022 21:46:20 -0700
Message-ID: <20220607044627.19563-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220607044627.19563-1-njavali@marvell.com>
References: <20220607044627.19563-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: XPji_8x13q_CzBXPynlB6Wkn_YsSCcaj
X-Proofpoint-GUID: XPji_8x13q_CzBXPynlB6Wkn_YsSCcaj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_01,2022-06-03_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Add bsg interface for app to read doorbell events.
This interface let driver knows how much app can read based
on return buffer size. When the next event(s) occur driver
will return the bsg_job with the event(s) in the return buffer.

If there is no event to read, driver will hold on to the bsg_job
up to few seconds as a way to control the polling interval.

Fixes: dd30706e73b70 ("scsi: qla2xxx: edif: Add key update")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dbg.h      |   2 +-
 drivers/scsi/qla2xxx/qla_edif.c     | 249 ++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_edif.h     |   3 +-
 drivers/scsi/qla2xxx/qla_edif_bsg.h |  14 ++
 4 files changed, 195 insertions(+), 73 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index f1f6c740bdcd..feeb1666227f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -383,5 +383,5 @@ ql_mask_match(uint level)
 	if (ql2xextended_error_logging == 1)
 		ql2xextended_error_logging = QL_DBG_DEFAULT1_MASK;
 
-	return (level & ql2xextended_error_logging) == level;
+	return level && ((level & ql2xextended_error_logging) == level);
 }
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index fffdf87d823a..dca54ece4726 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -52,6 +52,31 @@ const char *sc_to_str(uint16_t cmd)
 	return "unknown";
 }
 
+static struct edb_node *qla_edb_getnext(scsi_qla_host_t *vha)
+{
+	unsigned long   flags;
+	struct edb_node *edbnode = NULL;
+
+	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
+
+	/* db nodes are fifo - no qualifications done */
+	if (!list_empty(&vha->e_dbell.head)) {
+		edbnode = list_first_entry(&vha->e_dbell.head,
+					   struct edb_node, list);
+		list_del_init(&edbnode->list);
+	}
+
+	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
+
+	return edbnode;
+}
+
+static void qla_edb_node_free(scsi_qla_host_t *vha, struct edb_node *node)
+{
+	list_del_init(&node->list);
+	kfree(node);
+}
+
 static struct edif_list_entry *qla_edif_list_find_sa_index(fc_port_t *fcport,
 		uint16_t handle)
 {
@@ -1071,6 +1096,130 @@ qla_edif_ack(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	return 0;
 }
 
+static int qla_edif_consume_dbell(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
+	u32 sg_skip, reply_payload_len;
+	bool keep;
+	struct edb_node *dbnode = NULL;
+	struct edif_app_dbell ap;
+	int dat_size = 0;
+
+	sg_skip = 0;
+	reply_payload_len = bsg_job->reply_payload.payload_len;
+
+	while ((reply_payload_len - sg_skip) >= sizeof(struct edb_node)) {
+		dbnode = qla_edb_getnext(vha);
+		if (dbnode) {
+			keep = true;
+			dat_size = 0;
+			ap.event_code = dbnode->ntype;
+			switch (dbnode->ntype) {
+			case VND_CMD_AUTH_STATE_SESSION_SHUTDOWN:
+			case VND_CMD_AUTH_STATE_NEEDED:
+				ap.port_id = dbnode->u.plogi_did;
+				dat_size += sizeof(ap.port_id);
+				break;
+			case VND_CMD_AUTH_STATE_ELS_RCVD:
+				ap.port_id = dbnode->u.els_sid;
+				dat_size += sizeof(ap.port_id);
+				break;
+			case VND_CMD_AUTH_STATE_SAUPDATE_COMPL:
+				ap.port_id = dbnode->u.sa_aen.port_id;
+				memcpy(&ap.event_data, &dbnode->u,
+				    sizeof(struct edif_sa_update_aen));
+				dat_size += sizeof(struct edif_sa_update_aen);
+				break;
+			default:
+				keep = false;
+				ql_log(ql_log_warn, vha, 0x09102,
+					"%s unknown DB type=%d %p\n",
+					__func__, dbnode->ntype, dbnode);
+				break;
+			}
+			ap.event_data_size = dat_size;
+			/* 8 = sizeof(ap.event_code + ap.event_data_size)*/
+			dat_size += 8;
+			if (keep)
+				sg_skip += sg_copy_buffer(bsg_job->reply_payload.sg_list,
+						bsg_job->reply_payload.sg_cnt,
+						&ap, dat_size, sg_skip, false);
+
+			ql_dbg(ql_dbg_edif, vha, 0x09102,
+				"%s Doorbell consumed : type=%d %p\n",
+				__func__, dbnode->ntype, dbnode);
+
+			kfree(dbnode);
+		} else {
+			break;
+		}
+	}
+
+	SET_DID_STATUS(bsg_reply->result, DID_OK);
+	bsg_reply->reply_payload_rcv_len = sg_skip;
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+
+	return 0;
+}
+
+static void __qla_edif_dbell_bsg_done(scsi_qla_host_t *vha, struct bsg_job *bsg_job,
+	u32 delay)
+{
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+
+	/* small sleep for doorbell events to accumulate */
+	if (delay)
+		msleep(delay);
+
+	qla_edif_consume_dbell(vha, bsg_job);
+
+	bsg_job_done(bsg_job, bsg_reply->result, bsg_reply->reply_payload_rcv_len);
+}
+
+static void qla_edif_dbell_bsg_done(scsi_qla_host_t *vha)
+{
+	unsigned long flags;
+	struct bsg_job *prev_bsg_job = NULL;
+
+	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
+	if (vha->e_dbell.dbell_bsg_job) {
+		prev_bsg_job = vha->e_dbell.dbell_bsg_job;
+		vha->e_dbell.dbell_bsg_job = NULL;
+	}
+	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
+
+	if (prev_bsg_job)
+		__qla_edif_dbell_bsg_done(vha, prev_bsg_job, 0);
+}
+
+static int
+qla_edif_dbell_bsg(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	unsigned long flags;
+	bool return_bsg = false;
+
+	/* flush previous dbell bsg */
+	qla_edif_dbell_bsg_done(vha);
+
+	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
+	if (list_empty(&vha->e_dbell.head) && DBELL_ACTIVE(vha)) {
+		/*
+		 * when the next db event happens, bsg_job will return.
+		 * Otherwise, timer will return it.
+		 */
+		vha->e_dbell.dbell_bsg_job = bsg_job;
+		vha->e_dbell.bsg_expire = jiffies + 10 * HZ;
+	} else {
+		return_bsg = true;
+	}
+	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
+
+	if (return_bsg)
+		__qla_edif_dbell_bsg_done(vha, bsg_job, 1);
+
+	return 0;
+}
+
 int32_t
 qla_edif_app_mgmt(struct bsg_job *bsg_job)
 {
@@ -1082,8 +1231,13 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
 	bool done = true;
 	int32_t         rval = 0;
 	uint32_t	vnd_sc = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
+	u32 level = ql_dbg_edif;
 
-	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s vnd subcmd=%x\n",
+	/* doorbell is high traffic */
+	if (vnd_sc == QL_VND_SC_READ_DBELL)
+		level = 0;
+
+	ql_dbg(level, vha, 0x911d, "%s vnd subcmd=%x\n",
 	    __func__, vnd_sc);
 
 	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
@@ -1092,7 +1246,7 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
 
 	if (!vha->hw->flags.edif_enabled ||
 		test_bit(VPORT_DELETE, &vha->dpc_flags)) {
-		ql_dbg(ql_dbg_edif, vha, 0x911d,
+		ql_dbg(level, vha, 0x911d,
 		    "%s edif not enabled or vp delete. bsg ptr done %p. dpc_flags %lx\n",
 		    __func__, bsg_job, vha->dpc_flags);
 
@@ -1101,7 +1255,7 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
 	}
 
 	if (!qla_edif_app_check(vha, appcheck)) {
-		ql_dbg(ql_dbg_edif, vha, 0x911d,
+		ql_dbg(level, vha, 0x911d,
 		    "%s app checked failed.\n",
 		    __func__);
 
@@ -1136,6 +1290,10 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
 	case QL_VND_SC_AEN_COMPLETE:
 		rval = qla_edif_ack(vha, bsg_job);
 		break;
+	case QL_VND_SC_READ_DBELL:
+		rval = qla_edif_dbell_bsg(vha, bsg_job);
+		done = false;
+		break;
 	default:
 		ql_dbg(ql_dbg_edif, vha, 0x911d, "%s unknown cmd=%x\n",
 		    __func__,
@@ -1147,7 +1305,7 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
 
 done:
 	if (done) {
-		ql_dbg(ql_dbg_user, vha, 0x7009,
+		ql_dbg(level, vha, 0x7009,
 		    "%s: %d  bsg ptr done %p\n", __func__, __LINE__, bsg_job);
 		bsg_job_done(bsg_job, bsg_reply->result,
 		    bsg_reply->reply_payload_rcv_len);
@@ -1859,30 +2017,6 @@ qla_edb_init(scsi_qla_host_t *vha)
 	/* initialize lock which protects doorbell & init list */
 	spin_lock_init(&vha->e_dbell.db_lock);
 	INIT_LIST_HEAD(&vha->e_dbell.head);
-
-	/* create and initialize doorbell */
-	init_completion(&vha->e_dbell.dbell);
-}
-
-static void
-qla_edb_node_free(scsi_qla_host_t *vha, struct edb_node *node)
-{
-	/*
-	 * releases the space held by this edb node entry
-	 * this function does _not_ free the edb node itself
-	 * NB: the edb node entry passed should not be on any list
-	 *
-	 * currently for doorbell there's no additional cleanup
-	 * needed, but here as a placeholder for furture use.
-	 */
-
-	if (!node) {
-		ql_dbg(ql_dbg_edif, vha, 0x09122,
-		    "%s error - no valid node passed\n", __func__);
-		return;
-	}
-
-	node->ntype = N_UNDEF;
 }
 
 static void qla_edb_clear(scsi_qla_host_t *vha, port_id_t portid)
@@ -1929,11 +2063,8 @@ static void qla_edb_clear(scsi_qla_host_t *vha, port_id_t portid)
 	}
 	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
 
-	list_for_each_entry_safe(e, tmp, &edb_list, list) {
+	list_for_each_entry_safe(e, tmp, &edb_list, list)
 		qla_edb_node_free(vha, e);
-		list_del_init(&e->list);
-		kfree(e);
-	}
 }
 
 /* function called when app is stopping */
@@ -1961,14 +2092,10 @@ qla_edb_stop(scsi_qla_host_t *vha)
 		    "%s freeing edb_node type=%x\n",
 		    __func__, node->ntype);
 		qla_edb_node_free(vha, node);
-		list_del(&node->list);
-
-		kfree(node);
 	}
 	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
 
-	/* wake up doorbell waiters - they'll be dismissed with error code */
-	complete_all(&vha->e_dbell.dbell);
+	qla_edif_dbell_bsg_done(vha);
 }
 
 static struct edb_node *
@@ -2006,9 +2133,6 @@ qla_edb_node_add(scsi_qla_host_t *vha, struct edb_node *ptr)
 	list_add_tail(&ptr->list, &vha->e_dbell.head);
 	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
 
-	/* ring doorbell for waiters */
-	complete(&vha->e_dbell.dbell);
-
 	return true;
 }
 
@@ -2077,43 +2201,24 @@ qla_edb_eventcreate(scsi_qla_host_t *vha, uint32_t dbtype,
 	default:
 		ql_dbg(ql_dbg_edif, vha, 0x09102,
 			"%s unknown type: %x\n", __func__, dbtype);
-		qla_edb_node_free(vha, edbnode);
 		kfree(edbnode);
 		edbnode = NULL;
 		break;
 	}
 
-	if (edbnode && (!qla_edb_node_add(vha, edbnode))) {
+	if (edbnode) {
+		if (!qla_edb_node_add(vha, edbnode)) {
+			ql_dbg(ql_dbg_edif, vha, 0x09102,
+			    "%s unable to add dbnode\n", __func__);
+			kfree(edbnode);
+			return;
+		}
 		ql_dbg(ql_dbg_edif, vha, 0x09102,
-		    "%s unable to add dbnode\n", __func__);
-		qla_edb_node_free(vha, edbnode);
-		kfree(edbnode);
-		return;
-	}
-	if (edbnode && fcport)
-		fcport->edif.auth_state = dbtype;
-	ql_dbg(ql_dbg_edif, vha, 0x09102,
-	    "%s Doorbell produced : type=%d %p\n", __func__, dbtype, edbnode);
-}
-
-static struct edb_node *
-qla_edb_getnext(scsi_qla_host_t *vha)
-{
-	unsigned long	flags;
-	struct edb_node	*edbnode = NULL;
-
-	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
-
-	/* db nodes are fifo - no qualifications done */
-	if (!list_empty(&vha->e_dbell.head)) {
-		edbnode = list_first_entry(&vha->e_dbell.head,
-		    struct edb_node, list);
-		list_del(&edbnode->list);
+		    "%s Doorbell produced : type=%d %p\n", __func__, dbtype, edbnode);
+		qla_edif_dbell_bsg_done(vha);
+		if (fcport)
+			fcport->edif.auth_state = dbtype;
 	}
-
-	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
-
-	return edbnode;
 }
 
 void
@@ -2141,6 +2246,9 @@ qla_edif_timer(scsi_qla_host_t *vha)
 			ha->edif_post_stop_cnt_down = 60;
 		}
 	}
+
+	if (vha->e_dbell.dbell_bsg_job && time_after_eq(jiffies, vha->e_dbell.bsg_expire))
+		qla_edif_dbell_bsg_done(vha);
 }
 
 /*
@@ -2208,7 +2316,6 @@ edif_doorbell_show(struct device *dev, struct device_attribute *attr,
 				"%s Doorbell consumed : type=%d %p\n",
 				__func__, dbnode->ntype, dbnode);
 			/* we're done with the db node, so free it up */
-			qla_edb_node_free(vha, dbnode);
 			kfree(dbnode);
 		} else {
 			break;
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
index a965ca8e47ce..3561e22b8f0f 100644
--- a/drivers/scsi/qla2xxx/qla_edif.h
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -51,7 +51,8 @@ struct edif_dbell {
 	enum db_flags_t		db_flags;
 	spinlock_t		db_lock;
 	struct  list_head	head;
-	struct	completion	dbell;
+	struct bsg_job *dbell_bsg_job;
+	unsigned long bsg_expire;
 };
 
 #define SA_UPDATE_IOCB_TYPE            0x71    /* Security Association Update IOCB entry */
diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
index 301523e4f483..110843b13767 100644
--- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
@@ -183,6 +183,20 @@ struct qla_sa_update_frame {
 #define	QL_VND_SC_GET_FCINFO	7
 #define	QL_VND_SC_GET_STATS	8
 #define QL_VND_SC_AEN_COMPLETE  9
+#define QL_VND_SC_READ_DBELL	10
+
+/*
+ * bsg caller to provide empty buffer for doorbell events.
+ *
+ * sg_io_v4.din_xferp  = empty buffer for door bell events
+ * sg_io_v4.dout_xferp = struct edif_read_dbell *buf
+ */
+struct edif_read_dbell {
+	struct app_id app_info;
+	uint8_t version;
+	uint8_t pad[VND_CMD_PAD_SIZE];
+	uint8_t reserved[VND_CMD_APP_RESERVED_SIZE];
+};
 
 
 /* Application interface data structure for rtn data */
-- 
2.19.0.rc0

