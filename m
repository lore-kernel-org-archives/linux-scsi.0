Return-Path: <SRS0=GUYw=3P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E89C35246
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jan 2020 18:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60D01206F0
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jan 2020 18:30:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="XrwL1fQS";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="XrwL1fQS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbgAZSax (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jan 2020 13:30:53 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60940 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727233AbgAZSax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jan 2020 13:30:53 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 2F9FC8EE10C;
        Sun, 26 Jan 2020 10:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1580063453;
        bh=Nkor5nw66uPQqiX5z4iOUItqu9cuju7UWep1S1p1JB4=;
        h=Subject:From:To:Cc:Date:From;
        b=XrwL1fQS5PehyYjrGJ3i5LMoVi6Vnw1KdWstZ481bSDxUQBPCTdspiNH4TwRf/q3w
         ax7u6yurlYOvzKGisvLDzLGc9xhPlwVer/Qg3QQQhg28W+H41jqxsQbRTWgocceuvI
         Tk0CIHkRa0g8V39S2ATSNI3v6iI2z+wIiXdlMJP4=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MgA5hM1b31zW; Sun, 26 Jan 2020 10:30:53 -0800 (PST)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id B9F4E8EE0C9;
        Sun, 26 Jan 2020 10:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1580063453;
        bh=Nkor5nw66uPQqiX5z4iOUItqu9cuju7UWep1S1p1JB4=;
        h=Subject:From:To:Cc:Date:From;
        b=XrwL1fQS5PehyYjrGJ3i5LMoVi6Vnw1KdWstZ481bSDxUQBPCTdspiNH4TwRf/q3w
         ax7u6yurlYOvzKGisvLDzLGc9xhPlwVer/Qg3QQQhg28W+H41jqxsQbRTWgocceuvI
         Tk0CIHkRa0g8V39S2ATSNI3v6iI2z+wIiXdlMJP4=
Message-ID: <1580063451.4964.17.camel@HansenPartnership.com>
Subject: [GIT PULL] more SCSI fixes for 5.5-rc7
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sun, 26 Jan 2020 10:30:51 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Two last minute fixes, both in drivers.  The fnic one is a highly
unlikely condition, but the RDMA one is a recently introduced
regression that causes a kernel warning to trigger in every RDMA logon,
which would be unsightly if it got into the final release.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: RDMA/isert: Fix a recently introduced regression related to logout

Hannes Reinecke (1):
      scsi: fnic: do not queue commands during fwreset

And the diffstat:

 drivers/infiniband/ulp/isert/ib_isert.c | 12 ------------
 drivers/scsi/fnic/fnic_scsi.c           |  3 +++
 drivers/target/iscsi/iscsi_target.c     |  6 +++---
 3 files changed, 6 insertions(+), 15 deletions(-)

With full diff below.

James

---

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index a1a035270cab..b273e421e910 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2575,17 +2575,6 @@ isert_wait4logout(struct isert_conn *isert_conn)
 	}
 }
 
-static void
-isert_wait4cmds(struct iscsi_conn *conn)
-{
-	isert_info("iscsi_conn %p\n", conn);
-
-	if (conn->sess) {
-		target_sess_cmd_list_set_waiting(conn->sess->se_sess);
-		target_wait_for_sess_cmds(conn->sess->se_sess);
-	}
-}
-
 /**
  * isert_put_unsol_pending_cmds() - Drop commands waiting for
  *     unsolicitate dataout
@@ -2633,7 +2622,6 @@ static void isert_wait_conn(struct iscsi_conn *conn)
 
 	ib_drain_qp(isert_conn->qp);
 	isert_put_unsol_pending_cmds(conn);
-	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
 
 	queue_work(isert_release_wq, &isert_conn->release_work);
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 8ef150dfb6f7..b60795893994 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -439,6 +439,9 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_IO_BLOCKED)))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
+	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_FWRESET)))
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	rport = starget_to_rport(scsi_target(sc->device));
 	if (!rport) {
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 7251a87bb576..b94ed4e30770 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4149,9 +4149,6 @@ int iscsit_close_connection(
 	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
 
-	if (conn->conn_transport->iscsit_wait_conn)
-		conn->conn_transport->iscsit_wait_conn(conn);
-
 	/*
 	 * During Connection recovery drop unacknowledged out of order
 	 * commands for this connection, and prepare the other commands
@@ -4237,6 +4234,9 @@ int iscsit_close_connection(
 	target_sess_cmd_list_set_waiting(sess->se_sess);
 	target_wait_for_sess_cmds(sess->se_sess);
 
+	if (conn->conn_transport->iscsit_wait_conn)
+		conn->conn_transport->iscsit_wait_conn(conn);
+
 	ahash_request_free(conn->conn_tx_hash);
 	if (conn->conn_rx_hash) {
 		struct crypto_ahash *tfm;
