Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D86C433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 01:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACA4861207
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 01:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhDRBrN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Apr 2021 21:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhDRBrM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Apr 2021 21:47:12 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE55C06174A;
        Sat, 17 Apr 2021 18:46:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 8954312805BB;
        Sat, 17 Apr 2021 18:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1618710404;
        bh=0Pro5mnYrUVbAfrYh4RETsh7mnMr2vN2yc7AS9Uv2p0=;
        h=Message-ID:Subject:From:To:Date:From;
        b=lwfmrHjczQ39fFJR5qJU0PR04acvvXzleGfqXRwmyAsePRHBCbAZLB4k4fv1Im+tz
         M2KB+AU334hzF8lJmEvpGUx5/E+aeBFxYc1uQIZawzIXEnQNtXPte7CioVQEGQtlig
         tvwqD8NKR2e+P794skaIBik60JK7KLKnLnqqHkUo=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hu8Mlw2kk8r0; Sat, 17 Apr 2021 18:46:44 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 1BB5F12805B8;
        Sat, 17 Apr 2021 18:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1618710404;
        bh=0Pro5mnYrUVbAfrYh4RETsh7mnMr2vN2yc7AS9Uv2p0=;
        h=Message-ID:Subject:From:To:Date:From;
        b=lwfmrHjczQ39fFJR5qJU0PR04acvvXzleGfqXRwmyAsePRHBCbAZLB4k4fv1Im+tz
         M2KB+AU334hzF8lJmEvpGUx5/E+aeBFxYc1uQIZawzIXEnQNtXPte7CioVQEGQtlig
         tvwqD8NKR2e+P794skaIBik60JK7KLKnLnqqHkUo=
Message-ID: <57deba188660d1a81c658f30befe8538dd7a625e.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.12-rc6
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 17 Apr 2021 18:46:43 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This libsas fix is for a problem that occurs when trying to change the
cache type of an ATA device and the libiscsi one is a regression fix
from this merge window.

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Jolly Shah (1):
      scsi: libsas: Reset num_scatter if libata marks qc as NODATA

Mike Christie (1):
      scsi: iscsi: Fix iSCSI cls conn state

And the diffstat:

 drivers/scsi/libiscsi.c             | 26 +++-----------------------
 drivers/scsi/libsas/sas_ata.c       |  9 ++++-----
 drivers/scsi/scsi_transport_iscsi.c | 18 +++++++++++++++---
 3 files changed, 22 insertions(+), 31 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7ad11e42306d..bfd2aaa9b66b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3179,9 +3179,10 @@ fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
 	}
 }
 
-static void iscsi_start_session_recovery(struct iscsi_session *session,
-					 struct iscsi_conn *conn, int flag)
+void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 {
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct iscsi_session *session = conn->session;
 	int old_stop_stage;
 
 	mutex_lock(&session->eh_mutex);
@@ -3239,27 +3240,6 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
 }
-
-void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
-{
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
-
-	switch (flag) {
-	case STOP_CONN_RECOVER:
-		cls_conn->state = ISCSI_CONN_FAILED;
-		break;
-	case STOP_CONN_TERM:
-		cls_conn->state = ISCSI_CONN_DOWN;
-		break;
-	default:
-		iscsi_conn_printk(KERN_ERR, conn,
-				  "invalid stop flag %d\n", flag);
-		return;
-	}
-
-	iscsi_start_session_recovery(session, conn, flag);
-}
 EXPORT_SYMBOL_GPL(iscsi_conn_stop);
 
 int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 024e5a550759..8b9a39077dba 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -201,18 +201,17 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
 		task->total_xfer_len = qc->nbytes;
 		task->num_scatter = qc->n_elem;
+		task->data_dir = qc->dma_dir;
+	} else if (qc->tf.protocol == ATA_PROT_NODATA) {
+		task->data_dir = DMA_NONE;
 	} else {
 		for_each_sg(qc->sg, sg, qc->n_elem, si)
 			xfer += sg_dma_len(sg);
 
 		task->total_xfer_len = xfer;
 		task->num_scatter = si;
-	}
-
-	if (qc->tf.protocol == ATA_PROT_NODATA)
-		task->data_dir = DMA_NONE;
-	else
 		task->data_dir = qc->dma_dir;
+	}
 	task->scatter = qc->sg;
 	task->ata_task.retry_count = 1;
 	task->task_state_flags = SAS_TASK_STATE_PENDING;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index bebfb355abdf..21a2d997a72e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2470,10 +2470,22 @@ static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 	 * it works.
 	 */
 	mutex_lock(&conn_mutex);
+	switch (flag) {
+	case STOP_CONN_RECOVER:
+		conn->state = ISCSI_CONN_FAILED;
+		break;
+	case STOP_CONN_TERM:
+		conn->state = ISCSI_CONN_DOWN;
+		break;
+	default:
+		iscsi_cls_conn_printk(KERN_ERR, conn,
+				      "invalid stop flag %d\n", flag);
+		goto unlock;
+	}
+
 	conn->transport->stop_conn(conn, flag);
-	conn->state = ISCSI_CONN_DOWN;
+unlock:
 	mutex_unlock(&conn_mutex);
-
 }
 
 static void stop_conn_work_fn(struct work_struct *work)
@@ -2961,7 +2973,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 		mutex_lock(&conn->ep_mutex);
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
-		conn->state = ISCSI_CONN_DOWN;
+		conn->state = ISCSI_CONN_FAILED;
 	}
 
 	transport->ep_disconnect(ep);

