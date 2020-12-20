Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DD6C35296
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 20:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD25C23AC1
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 20:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgLTUhi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 15:37:38 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35040 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbgLTUhi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 15:37:38 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608496611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Nar8nTUQtP5/0fAlBqnn/4nL26kAXwaNThUNCyKfz4=;
        b=fp7wJLZBST481ADMuy1DcyzeVd2UsYAsKCRm9Fnr3ABjjP0InW26HbdxAqc8pYySaTrGcD
        kMdWM/I0Fbp6gCRyONK4bn017dHiyzzcQ3Aztm/xGh32W9XcrasdRwj+dkaXP6J6v0sJ1V
        8hSfgEZibnV71UzB2PeI1p1axnTKuRHOaOxCn2NeuTLorN/cGLtmeB36K/oRMdszvaCgBv
        lcdjGvckgQx1XE+7mDx8IEj/u1/HJabSh1BOwZJzzBLr1MGstvKzqSvSGUVs5KrSLC9Rio
        V/v6HdlS3WdCMNoE8EWLouAQY/ih5+Q7bKNDyPqnzUJtdipwNvGKYeyhmOgDBw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608496611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Nar8nTUQtP5/0fAlBqnn/4nL26kAXwaNThUNCyKfz4=;
        b=/gsqXaoYw+NZ3shVUrLQzRNgn8bCDfjX93ClCuePFqTt6+4vcNupYCE4o8uhcn+OBe4hie
        DEa5HHuI8GmBumCA==
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/6] scsi: target: iscsi: Avoid in_interrupt() usage in iscsit_check_session_usage_count().
Date:   Sun, 20 Dec 2020 21:36:34 +0100
Message-Id: <20201220203638.43615-3-bigeasy@linutronix.de>
In-Reply-To: <20201220203638.43615-1-bigeasy@linutronix.de>
References: <20201220203638.43615-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iscsit_check_session_usage_count() uses in_interrupt() to find out if it
is safe to invoke wait_for_completion().

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be separated or the context be conveyed in an argument passed by the
caller, which usually knows the context.

There is only one caller of iscsit_check_session_usage_count() which
already has an argument indicating if it is safe to sleep.

Extend iscsit_check_session_usage_count() by an argument indicating if
it may sleep.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/target/iscsi/iscsi_target.c      | 4 ++--
 drivers/target/iscsi/iscsi_target_util.c | 4 ++--
 drivers/target/iscsi/iscsi_target_util.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/isc=
si_target.c
index 5abf03125388a..13de37ff9dc9f 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4400,9 +4400,9 @@ int iscsit_close_session(struct iscsi_session *sess, =
bool can_sleep)
 	 * restart the timer and exit.
 	 */
 	if (can_sleep) {
-		iscsit_check_session_usage_count(sess);
+		iscsit_check_session_usage_count(sess, can_sleep);
 	} else {
-		if (iscsit_check_session_usage_count(sess) =3D=3D 2) {
+		if (iscsit_check_session_usage_count(sess, can_sleep) =3D=3D 2) {
 			atomic_set(&sess->session_logout, 0);
 			iscsit_start_time2retain_handler(sess);
 			return 0;
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscs=
i/iscsi_target_util.c
index 45ba07c6ec270..50028b1d3b849 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -779,13 +779,13 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shut=
down)
 }
 EXPORT_SYMBOL(iscsit_free_cmd);
=20
-int iscsit_check_session_usage_count(struct iscsi_session *sess)
+int iscsit_check_session_usage_count(struct iscsi_session *sess, bool can_=
sleep)
 {
 	spin_lock_bh(&sess->session_usage_lock);
 	if (sess->session_usage_count !=3D 0) {
 		sess->session_waiting_on_uc =3D 1;
 		spin_unlock_bh(&sess->session_usage_lock);
-		if (in_interrupt())
+		if (!can_sleep)
 			return 2;
=20
 		wait_for_completion(&sess->session_waiting_on_uc_comp);
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscs=
i/iscsi_target_util.h
index 68e84803b0a1a..a2c2401f29452 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -40,7 +40,7 @@ extern void iscsit_free_queue_reqs_for_conn(struct iscsi_=
conn *);
 extern void iscsit_release_cmd(struct iscsi_cmd *);
 extern void __iscsit_free_cmd(struct iscsi_cmd *, bool);
 extern void iscsit_free_cmd(struct iscsi_cmd *, bool);
-extern int iscsit_check_session_usage_count(struct iscsi_session *);
+extern int iscsit_check_session_usage_count(struct iscsi_session *sess, bo=
ol can_sleep);
 extern void iscsit_dec_session_usage_count(struct iscsi_session *);
 extern void iscsit_inc_session_usage_count(struct iscsi_session *);
 extern struct iscsi_conn *iscsit_get_conn_from_cid(struct iscsi_session *,=
 u16);
--=20
2.29.2

