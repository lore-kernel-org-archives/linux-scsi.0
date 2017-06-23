From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 28/35] libiscsi: use cls_session as argument for target and session reset
Date: Fri, 23 Jun 2017 15:02:48 +0200
Message-ID: <1498222975-71858-29-git-send-email-hare@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32897 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754233AbdFWNDg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:36 -0400
In-Reply-To: <1498222975-71858-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

iscsi_eh_target_reset() and iscsi_eh_session_reset() only depend
on the cls_session, so use that as an argument.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/be2iscsi/be_main.c | 10 +++++++++-
 drivers/scsi/libiscsi.c         | 21 +++++++++------------
 include/scsi/libiscsi.h         |  2 +-
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f862332..b5a88ce 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -363,6 +363,14 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	return rc;
 }
 
+static int beiscsi_eh_session_reset(struct scsi_cmnd *sc)
+{
+	struct iscsi_cls_session *cls_session;
+
+	cls_session = starget_to_session(scsi_target(sc->device));
+	return iscsi_eh_session_reset(cls_session);
+}
+
 /*------------------- PCI Driver operations and data ----------------- */
 static const struct pci_device_id beiscsi_pci_id_table[] = {
 	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
@@ -387,7 +395,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	.eh_timed_out = iscsi_eh_cmd_timed_out,
 	.eh_abort_handler = beiscsi_eh_abort,
 	.eh_device_reset_handler = beiscsi_eh_device_reset,
-	.eh_target_reset_handler = iscsi_eh_session_reset,
+	.eh_target_reset_handler = beiscsi_eh_session_reset,
 	.shost_attrs = beiscsi_attrs,
 	.sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
 	.can_queue = BE2_IO_DEPTH,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 42381ad..5bc685c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2378,13 +2378,11 @@ void iscsi_session_recovery_timedout(struct iscsi_cls_session *cls_session)
  * This function will wait for a relogin, session termination from
  * userspace, or a recovery/replacement timeout.
  */
-int iscsi_eh_session_reset(struct scsi_cmnd *sc)
+int iscsi_eh_session_reset(struct iscsi_cls_session *cls_session)
 {
-	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 
-	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 	conn = session->leadconn;
 
@@ -2431,7 +2429,7 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 }
 EXPORT_SYMBOL_GPL(iscsi_eh_session_reset);
 
-static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
+static void iscsi_prep_tgt_reset_pdu(struct iscsi_tm *hdr)
 {
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
@@ -2446,19 +2444,16 @@ static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
  *
  * This will attempt to send a warm target reset.
  */
-static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
+static int iscsi_eh_target_reset(struct iscsi_cls_session *cls_session)
 {
-	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	struct iscsi_tm *hdr;
 	int rc = FAILED;
 
-	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 
-	ISCSI_DBG_EH(session, "tgt Reset [sc %p tgt %s]\n", sc,
-		     session->targetname);
+	ISCSI_DBG_EH(session, "tgt Reset [tgt %s]\n", session->targetname);
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
@@ -2476,7 +2471,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	conn->tmf_state = TMF_QUEUED;
 
 	hdr = &conn->tmhdr;
-	iscsi_prep_tgt_reset_pdu(sc, hdr);
+	iscsi_prep_tgt_reset_pdu(hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
 				    session->tgt_reset_timeout)) {
@@ -2528,11 +2523,13 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
  */
 int iscsi_eh_recover_target(struct scsi_cmnd *sc)
 {
+	struct iscsi_cls_session *cls_session;
 	int rc;
 
-	rc = iscsi_eh_target_reset(sc);
+	cls_session = starget_to_session(scsi_target(sc->device));
+	rc = iscsi_eh_target_reset(cls_session);
 	if (rc == FAILED)
-		rc = iscsi_eh_session_reset(sc);
+		rc = iscsi_eh_session_reset(cls_session);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(iscsi_eh_recover_target);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index c9bd935..d34daf8 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -382,7 +382,7 @@ struct iscsi_host {
  */
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
 extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
-extern int iscsi_eh_session_reset(struct scsi_cmnd *sc);
+extern int iscsi_eh_session_reset(struct iscsi_cls_session *cls_session);
 extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
 extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc);
 extern enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc);
-- 
1.8.5.6
