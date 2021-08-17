Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BC9C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA1BA600CC
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239569AbhHQJRa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:30 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33308 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239294AbhHQJRQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:16 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 344AE21D3D;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M021yZTyA7R+S7ex7SM+pePBigXQFhOuMlMB00LdKPQ=;
        b=WT58ZYf0LDN1RBOI/BpU56bodQdA0l3yjEqslt9x8kqQ//Q6Gbph+0s7zKlzoRIoi9XpXj
        wZHNAVt4x/Xs+ccA8iGer1ERQPx2ZsIHbW6gYU4th0pKAFl+JmMsDC4B1eUp0Q/Ct1cHlv
        HUkwHBLfJvaDD1PyuC+AV6HY85an9tk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M021yZTyA7R+S7ex7SM+pePBigXQFhOuMlMB00LdKPQ=;
        b=CBp3+dVBQ74GcWSlwhOvhnZqHERbq/FIsPhRrF26QW4qZUrDE7t+lvdYiF/z1XuxAjPDbZ
        7TFmT+fSsfotgRBw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 2E6A7A3BA6;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 2B351518CE8B; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 22/51] libiscsi: use cls_session as argument for target and session reset
Date:   Tue, 17 Aug 2021 11:14:27 +0200
Message-Id: <20210817091456.73342-23-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iscsi_eh_target_reset() and iscsi_eh_session_reset() only depend
on the cls_session, so use that as an argument.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/be2iscsi/be_main.c | 10 +++++++++-
 drivers/scsi/libiscsi.c         | 21 +++++++++------------
 include/scsi/libiscsi.h         |  2 +-
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index e70f69f791db..d76902c4128c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -367,6 +367,14 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
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
@@ -390,7 +398,7 @@ static struct scsi_host_template beiscsi_sht = {
 	.eh_timed_out = iscsi_eh_cmd_timed_out,
 	.eh_abort_handler = beiscsi_eh_abort,
 	.eh_device_reset_handler = beiscsi_eh_device_reset,
-	.eh_target_reset_handler = iscsi_eh_session_reset,
+	.eh_target_reset_handler = beiscsi_eh_session_reset,
 	.shost_attrs = beiscsi_attrs,
 	.sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
 	.can_queue = BE2_IO_DEPTH,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4683c183e9d4..0006a3692c9a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2488,13 +2488,11 @@ EXPORT_SYMBOL_GPL(iscsi_session_recovery_timedout);
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
@@ -2541,7 +2539,7 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 }
 EXPORT_SYMBOL_GPL(iscsi_eh_session_reset);
 
-static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
+static void iscsi_prep_tgt_reset_pdu(struct iscsi_tm *hdr)
 {
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
@@ -2556,19 +2554,16 @@ static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
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
@@ -2586,7 +2581,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	session->tmf_state = TMF_QUEUED;
 
 	hdr = &session->tmhdr;
-	iscsi_prep_tgt_reset_pdu(sc, hdr);
+	iscsi_prep_tgt_reset_pdu(hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
 				    session->tgt_reset_timeout)) {
@@ -2638,11 +2633,13 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
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
index 4ee233e5a6ff..3401feb088df 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -379,7 +379,7 @@ struct iscsi_host {
  */
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
 extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
-extern int iscsi_eh_session_reset(struct scsi_cmnd *sc);
+extern int iscsi_eh_session_reset(struct iscsi_cls_session *cls_session);
 extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
 extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc);
 extern enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc);
-- 
2.29.2

