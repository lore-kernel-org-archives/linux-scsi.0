Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA63C3526D
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 20:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 286B923AC1
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 20:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgLTUhi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 15:37:38 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35044 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgLTUhi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 15:37:38 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608496611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zibiflgoABDQGFRLKGg4iGri3wabbL89Q1mDTS5SIqI=;
        b=ndVr9p9nW3E+m18AbhRg3SHMvL6DyylmXgoLbR8pNr9hiPKHfIivkmVaiLb4tJWyEanaZQ
        rYzF63aeuNTKIwaC/s9M7gOUhMtMUHNXYM3q4+7MXlz25HfEt7T+S1oXrg5RkxHhOKksWc
        0VQmGoM8xYDRD2gCZG0wpueSZK80bG3AbFriqueOKhD7pZ2HCFHksBk95YEwhy6hbVHkqa
        f1/4gSpsdkzRYiCcFIjslmtvhbrYRnshyYDnDUQaA3ZEi+kdLYfxIVUmCC2xLYmdvAAIAM
        Hyf8btZLBcK6iiGr0MSxmYEKlVk5MoynSmV0fOPyy2wnQ//qr9y2T5m5LrggsA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608496611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zibiflgoABDQGFRLKGg4iGri3wabbL89Q1mDTS5SIqI=;
        b=D3btzimxY51lUzuLDpwSZA9XyG1ooEZfnfYgh3JpCsN3J2y2uOkr2JCqzWzpv4SIbr/p1R
        0jQvtKIxKaFThMDw==
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 3/6] scsi: target: iscsi: Redo iscsit_check_session_usage_count() return code.
Date:   Sun, 20 Dec 2020 21:36:35 +0100
Message-Id: <20201220203638.43615-4-bigeasy@linutronix.de>
In-Reply-To: <20201220203638.43615-1-bigeasy@linutronix.de>
References: <20201220203638.43615-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The return value of iscsit_check_session_usage_count() is only checked
if it was not allowed to sleep. If it returns `2' then a timer is
prepared. If it returns something else or if it was allowed to sleep
then it is ignored.

Let iscsit_check_session_usage_count() return true if it needs to arm
the timer - otherwise false. This simplifies the code flow of the only
caller.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/target/iscsi/iscsi_target.c      | 12 ++++--------
 drivers/target/iscsi/iscsi_target_util.c |  9 +++++----
 drivers/target/iscsi/iscsi_target_util.h |  2 +-
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/isc=
si_target.c
index 13de37ff9dc9f..d0e7ed8f28cc8 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4399,14 +4399,10 @@ int iscsit_close_session(struct iscsi_session *sess=
, bool can_sleep)
 	 * time2retain handler) and contain and active session usage count we
 	 * restart the timer and exit.
 	 */
-	if (can_sleep) {
-		iscsit_check_session_usage_count(sess, can_sleep);
-	} else {
-		if (iscsit_check_session_usage_count(sess, can_sleep) =3D=3D 2) {
-			atomic_set(&sess->session_logout, 0);
-			iscsit_start_time2retain_handler(sess);
-			return 0;
-		}
+	if (iscsit_check_session_usage_count(sess, can_sleep)) {
+		atomic_set(&sess->session_logout, 0);
+		iscsit_start_time2retain_handler(sess);
+		return 0;
 	}
=20
 	transport_deregister_session(sess->se_sess);
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscs=
i/iscsi_target_util.c
index 50028b1d3b849..9468b017b4a73 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -779,21 +779,22 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shut=
down)
 }
 EXPORT_SYMBOL(iscsit_free_cmd);
=20
-int iscsit_check_session_usage_count(struct iscsi_session *sess, bool can_=
sleep)
+bool iscsit_check_session_usage_count(struct iscsi_session *sess,
+				      bool can_sleep)
 {
 	spin_lock_bh(&sess->session_usage_lock);
 	if (sess->session_usage_count !=3D 0) {
 		sess->session_waiting_on_uc =3D 1;
 		spin_unlock_bh(&sess->session_usage_lock);
 		if (!can_sleep)
-			return 2;
+			return true;
=20
 		wait_for_completion(&sess->session_waiting_on_uc_comp);
-		return 1;
+		return false;
 	}
 	spin_unlock_bh(&sess->session_usage_lock);
=20
-	return 0;
+	return false;
 }
=20
 void iscsit_dec_session_usage_count(struct iscsi_session *sess)
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscs=
i/iscsi_target_util.h
index a2c2401f29452..8ee1c133a9b7b 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -40,7 +40,7 @@ extern void iscsit_free_queue_reqs_for_conn(struct iscsi_=
conn *);
 extern void iscsit_release_cmd(struct iscsi_cmd *);
 extern void __iscsit_free_cmd(struct iscsi_cmd *, bool);
 extern void iscsit_free_cmd(struct iscsi_cmd *, bool);
-extern int iscsit_check_session_usage_count(struct iscsi_session *sess, bo=
ol can_sleep);
+extern bool iscsit_check_session_usage_count(struct iscsi_session *sess, b=
ool can_sleep);
 extern void iscsit_dec_session_usage_count(struct iscsi_session *);
 extern void iscsit_inc_session_usage_count(struct iscsi_session *);
 extern struct iscsi_conn *iscsit_get_conn_from_cid(struct iscsi_session *,=
 u16);
--=20
2.29.2

