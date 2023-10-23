Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D70C25B41
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 09:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbjJWJPZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 05:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjJWJPR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 05:15:17 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0454BF5
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 02:15:12 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3EFE121ACB;
        Mon, 23 Oct 2023 09:15:11 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 03BF42CF51;
        Mon, 23 Oct 2023 09:15:11 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 26E4B51EC32F; Mon, 23 Oct 2023 11:15:11 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/16] libiscsi: use cls_session as argument for target and session reset
Date:   Mon, 23 Oct 2023 11:14:59 +0200
Message-Id: <20231023091507.120828-9-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231023091507.120828-1-hare@suse.de>
References: <20231023091507.120828-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++
Authentication-Results: smtp-out1.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out1.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [2.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[6];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-3.00)[100.00%]
X-Rspamd-Queue-Id: 3EFE121ACB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iscsi_eh_target_reset() and iscsi_eh_session_reset() only depend
on the cls_session, so use that as an argument.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c | 10 +++++++++-
 drivers/scsi/libiscsi.c         | 25 +++++++++++--------------
 include/scsi/libiscsi.h         |  2 +-
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index e48f14ad6dfd..441ad2ebc5d5 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -385,6 +385,14 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
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
@@ -408,7 +416,7 @@ static const struct scsi_host_template beiscsi_sht = {
 	.eh_timed_out = iscsi_eh_cmd_timed_out,
 	.eh_abort_handler = beiscsi_eh_abort,
 	.eh_device_reset_handler = beiscsi_eh_device_reset,
-	.eh_target_reset_handler = iscsi_eh_session_reset,
+	.eh_target_reset_handler = beiscsi_eh_session_reset,
 	.shost_groups = beiscsi_groups,
 	.sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
 	.can_queue = BE2_IO_DEPTH,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0fda8905eabd..3b9e1c35936e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2595,18 +2595,16 @@ EXPORT_SYMBOL_GPL(iscsi_session_recovery_timedout);
 
 /**
  * iscsi_eh_session_reset - drop session and attempt relogin
- * @sc: scsi command
+ * @cls_session: class session to reset
  *
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
 
 	mutex_lock(&session->eh_mutex);
@@ -2653,7 +2651,7 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 }
 EXPORT_SYMBOL_GPL(iscsi_eh_session_reset);
 
-static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
+static void iscsi_prep_tgt_reset_pdu(struct iscsi_tm *hdr)
 {
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
@@ -2664,23 +2662,20 @@ static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
 
 /**
  * iscsi_eh_target_reset - reset target
- * @sc: scsi command
+ * @cls_session: class session to reset
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
@@ -2698,7 +2693,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	session->tmf_state = TMF_QUEUED;
 
 	hdr = &session->tmhdr;
-	iscsi_prep_tgt_reset_pdu(sc, hdr);
+	iscsi_prep_tgt_reset_pdu(hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
 				    session->tgt_reset_timeout)) {
@@ -2750,11 +2745,13 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
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
index 7282555adfd5..7dddf785edd0 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -390,7 +390,7 @@ struct iscsi_host {
  */
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
 extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
-extern int iscsi_eh_session_reset(struct scsi_cmnd *sc);
+extern int iscsi_eh_session_reset(struct iscsi_cls_session *cls_session);
 extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
 extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc);
 extern enum scsi_timeout_action iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc);
-- 
2.35.3

