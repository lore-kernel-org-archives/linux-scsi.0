Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEAC6C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 22:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387808AbiEBWEo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 18:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383542AbiEBWDd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 18:03:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546E460E2
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 15:00:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A0D2D1F74B;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651528800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gp1sTnpdEMPcdbQQrGqi+QDdXS8aROeziBusgCgr98c=;
        b=n6G+739ijUQiKfeHiRI4CrTCM6pNjhIeUX7pdqUzWO3yBivSD3mAJ5Liw193ue0jeGc4x1
        K9qi86E/HYtrB3CQkjRkoH0duZcxy54/TiSVElrhn5KvYSFPmF6M6ONXn+OArKM+LaBiyp
        ewblrIVOTmiOxktZ8+Tj/fGqd650Ifk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651528800;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gp1sTnpdEMPcdbQQrGqi+QDdXS8aROeziBusgCgr98c=;
        b=SFqmlUi263zkr5KTQX6Yx5t9q/KKMICDvASkdH0DtYrABbzx+k/BSesAIvLohRajbgL2rz
        fC/l0IhtnBpSjaDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9A7142C14B;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 970F2519414A; Tue,  3 May 2022 00:00:00 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 03/11] libiscsi: use cls_session as argument for target and session reset
Date:   Mon,  2 May 2022 23:59:40 +0200
Message-Id: <20220502215953.5463-6-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502215953.5463-1-hare@suse.de>
References: <20220502215953.5463-1-hare@suse.de>
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
index 3bb0adefbe06..55addd7f5c81 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -370,6 +370,14 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
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
@@ -393,7 +401,7 @@ static struct scsi_host_template beiscsi_sht = {
 	.eh_timed_out = iscsi_eh_cmd_timed_out,
 	.eh_abort_handler = beiscsi_eh_abort,
 	.eh_device_reset_handler = beiscsi_eh_device_reset,
-	.eh_target_reset_handler = iscsi_eh_session_reset,
+	.eh_target_reset_handler = beiscsi_eh_session_reset,
 	.shost_groups = beiscsi_groups,
 	.sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
 	.can_queue = BE2_IO_DEPTH,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 797abf4f5399..30f7737928bb 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2494,13 +2494,11 @@ EXPORT_SYMBOL_GPL(iscsi_session_recovery_timedout);
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
@@ -2547,7 +2545,7 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 }
 EXPORT_SYMBOL_GPL(iscsi_eh_session_reset);
 
-static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
+static void iscsi_prep_tgt_reset_pdu(struct iscsi_tm *hdr)
 {
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
@@ -2562,19 +2560,16 @@ static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
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
@@ -2592,7 +2587,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	session->tmf_state = TMF_QUEUED;
 
 	hdr = &session->tmhdr;
-	iscsi_prep_tgt_reset_pdu(sc, hdr);
+	iscsi_prep_tgt_reset_pdu(hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
 				    session->tgt_reset_timeout)) {
@@ -2644,11 +2639,13 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
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
index d0a24779c52d..ce8d5b5dc0d3 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -391,7 +391,7 @@ struct iscsi_host {
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

