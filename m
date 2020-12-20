Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0D5C35270
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 20:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 621A823AAA
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 20:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgLTUhi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 15:37:38 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35042 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbgLTUhi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 15:37:38 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608496610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nORQTpQodPfeTe8lJyiJShfHTTi5K70XuvveQ+buD5A=;
        b=DRfZ4BqMCMissNHgLCEX06AgTOneMmGDTo0j5i+aRdewCPlQeif4+gTikNgxN+BLxSCreu
        zFitA9IO8ljeD+TwT5TJBNTsFra6/WLJ1tfQP1/KAq4tvoPPbmedXtUlL+/IeEbH6lVZI/
        clzLOgtXjHx7rIQPleHKdqu8HoTyW+PMOv54bJZ9qlTbuxpkkhJy/kzlJS4RPJzedX8JNx
        GcSo/nD7pyC6VwKUm68qH4BEIdyStgWCe6NC0RDe0SeM6KcoyTuI0NEwUjAW5/s2G+9sO2
        /Z6+ZNifyXUV2cvzOjw8R0BznEmfvJ0dGA0hBgN49CZgvkPvFUd1HvkNe095Sg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608496610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nORQTpQodPfeTe8lJyiJShfHTTi5K70XuvveQ+buD5A=;
        b=yO+4q2YASYqA2jGOJnq/IRp/rTN0D/j0+E6sI67CZkNF7sFAqPQvgCOF9cp3AJJlIWCtOc
        aETdIqPiAw40+bAA==
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/6] scsi: target: iscsi: Avoid in_interrupt() usage in iscsit_close_session().
Date:   Sun, 20 Dec 2020 21:36:33 +0100
Message-Id: <20201220203638.43615-2-bigeasy@linutronix.de>
In-Reply-To: <20201220203638.43615-1-bigeasy@linutronix.de>
References: <20201220203638.43615-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iscsit_close_session() uses in_interrupt() to decide if it needs to
check the return value of iscsit_check_session_usage_count() if it was
not able to sleep.

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be separated or the context be conveyed in an argument passed by the
caller, which usually knows the context.

iscsit_close_session() has two callers:
- iscsit_handle_time2retain_timeout()
  A timer_list callback.

- iscsit_close_connection()
  Runs in preemptible context, acquires a mutex.

Add an argument to iscsit_close_session() indicating if sleeping is
possible.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/target/iscsi/iscsi_target.c      | 10 +++++-----
 drivers/target/iscsi/iscsi_target.h      |  2 +-
 drivers/target/iscsi/iscsi_target_erl0.c |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/isc=
si_target.c
index 518fac4864cfa..5abf03125388a 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4327,7 +4327,7 @@ int iscsit_close_connection(
 	     atomic_read(&sess->session_fall_back_to_erl0)) {
 		spin_unlock_bh(&sess->conn_lock);
 		complete_all(&sess->session_wait_comp);
-		iscsit_close_session(sess);
+		iscsit_close_session(sess, true);
=20
 		return 0;
 	} else if (atomic_read(&sess->session_logout)) {
@@ -4337,7 +4337,7 @@ int iscsit_close_connection(
 		if (atomic_read(&sess->session_close)) {
 			spin_unlock_bh(&sess->conn_lock);
 			complete_all(&sess->session_wait_comp);
-			iscsit_close_session(sess);
+			iscsit_close_session(sess, true);
 		} else {
 			spin_unlock_bh(&sess->conn_lock);
 		}
@@ -4353,7 +4353,7 @@ int iscsit_close_connection(
 		if (atomic_read(&sess->session_close)) {
 			spin_unlock_bh(&sess->conn_lock);
 			complete_all(&sess->session_wait_comp);
-			iscsit_close_session(sess);
+			iscsit_close_session(sess, true);
 		} else {
 			spin_unlock_bh(&sess->conn_lock);
 		}
@@ -4366,7 +4366,7 @@ int iscsit_close_connection(
  * If the iSCSI Session for the iSCSI Initiator Node exists,
  * forcefully shutdown the iSCSI NEXUS.
  */
-int iscsit_close_session(struct iscsi_session *sess)
+int iscsit_close_session(struct iscsi_session *sess, bool can_sleep)
 {
 	struct iscsi_portal_group *tpg =3D sess->tpg;
 	struct se_portal_group *se_tpg =3D &tpg->tpg_se_tpg;
@@ -4399,7 +4399,7 @@ int iscsit_close_session(struct iscsi_session *sess)
 	 * time2retain handler) and contain and active session usage count we
 	 * restart the timer and exit.
 	 */
-	if (!in_interrupt()) {
+	if (can_sleep) {
 		iscsit_check_session_usage_count(sess);
 	} else {
 		if (iscsit_check_session_usage_count(sess) =3D=3D 2) {
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/isc=
si_target.h
index 7409ce2a66078..b35a96ded9c19 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -41,7 +41,7 @@ extern void iscsit_thread_get_cpumask(struct iscsi_conn *=
);
 extern int iscsi_target_tx_thread(void *);
 extern int iscsi_target_rx_thread(void *);
 extern int iscsit_close_connection(struct iscsi_conn *);
-extern int iscsit_close_session(struct iscsi_session *);
+extern int iscsit_close_session(struct iscsi_session *, bool can_sleep);
 extern void iscsit_fail_session(struct iscsi_session *);
 extern void iscsit_stop_session(struct iscsi_session *, int, int);
 extern int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *, in=
t);
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscs=
i/iscsi_target_erl0.c
index b4abd7b68e6da..102c9cbf59f38 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -765,7 +765,7 @@ void iscsit_handle_time2retain_timeout(struct timer_lis=
t *t)
=20
 	iscsit_fill_cxn_timeout_err_stats(sess);
 	spin_unlock_bh(&se_tpg->session_lock);
-	iscsit_close_session(sess);
+	iscsit_close_session(sess, false);
 }
=20
 void iscsit_start_time2retain_handler(struct iscsi_session *sess)
--=20
2.29.2

