Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E62CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 10:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B07B20842
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 10:02:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="xxZtrvwP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgGPKCy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 06:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgGPKCx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2020 06:02:53 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE79C08C5C0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2020 03:02:52 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gc15so2811981pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2020 03:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eZ7Ie7Pzshq3rg5eCb9AzgAsUX5k0M+860E+N34fP/o=;
        b=xxZtrvwPHqWYHHkyvvWLK+M1vaM/JpHpkMfqguLK9WkLT5CGTkPuAJQTxv+e9uxKIn
         zMZBbq4Hcht51A8Zz9no9RzQAZlvrkj8of02TxVxJy46MdywprFi0IRUuT0GjOvb+Sfa
         16Ahy3UWxc8xEZKvsRVcOqI0CYdfROy4ZgvZY+MiOHDvAIgxZulOU05x65yt+VxZ/xi+
         APyumUdDLswkdN0KpyAfRtrNE35wTKvkCSe9pxfpzfvAgtcah9yzRpoH/AmNrlBij60r
         A4r1SYbd2pBuddf9Qz0gnxznKrPmH0hvCFcU1+Sf4NIyHlkcAguVwHyeS+2535VOz7DM
         VDOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eZ7Ie7Pzshq3rg5eCb9AzgAsUX5k0M+860E+N34fP/o=;
        b=rZ38ZQBZHgzw4B0rwS2oTzQ4q5sGkPEOqMHbH6E2ULXkEClUNXx/lLXB2N18T0BiF+
         FyjKKYrRSfyPlTDTM6+AvHojfyk41iSDH0m/T1NpTg8xjrzekFm55IORKvcPPaii33zY
         6/ueznPdGt2RoRF9GSmHcX2RaE/VDGC5D6s1ub00jSFqwQcqG92bx6qVFCfzSeREMRxn
         lAu2XoOeyhZ6NmLwEE/xwS3ItJ8ouV507nqYtNHnSoIvGqBl/3Bq+O5yAc7WICUMm1yd
         mXODfZNlyDFT8Bmsu6kbq/UzPNN1B0Wi94/4qctcMgNYYPYcR+63WfSZFfUyevBTADly
         l9PQ==
X-Gm-Message-State: AOAM532xF04WK3t4OLLfMOc3SLteXS/VaR94omTLOCnBYzrYbnu7Banr
        iuyvDwtsUhqfhMHl4H7t8xbTNQ==
X-Google-Smtp-Source: ABdhPJwcbVZ8MV10vSa6FMvg/1mLmBVnY2s+e5WnELvu0CCKHVDxHLViNtH8HTNsY+ygkX3mh5LW6Q==
X-Received: by 2002:a17:90a:3002:: with SMTP id g2mr4142770pjb.68.1594893772444;
        Thu, 16 Jul 2020 03:02:52 -0700 (PDT)
Received: from debian.bytedance.net ([61.120.150.75])
        by smtp.gmail.com with ESMTPSA id f29sm4602477pga.59.2020.07.16.03.02.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 03:02:51 -0700 (PDT)
From:   Hou Pu <houpu@bytedance.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, Hou Pu <houpu@bytedance.com>
Subject: [PATCH v4 1/2] iscsi-target: fix login error when receiving is too fast
Date:   Thu, 16 Jul 2020 06:02:11 -0400
Message-Id: <20200716100212.4237-2-houpu@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200716100212.4237-1-houpu@bytedance.com>
References: <20200716100212.4237-1-houpu@bytedance.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iscsi_target_sk_data_ready() could be invoked indirectly
by iscsi_target_do_login_rx() from workqueue like following:

iscsi_target_do_login_rx()
  iscsi_target_do_login()
    iscsi_target_do_tx_login_io()
      iscsit_put_login_tx()
        iscsi_login_tx_data()
          tx_data()
            sock_sendmsg_nosec()
              tcp_sendmsg()
                release_sock()
                  sk_backlog_rcv()
                    tcp_v4_do_rcv()
                      tcp_data_ready()
                        iscsi_target_sk_data_ready()

At that time LOGIN_FLAGS_READ_ACTIVE is not cleared.
and iscsi_target_sk_data_ready will not read data
from the socket. And some iscsi initiator(i.e. libiscsi)
will wait forever for a reply.

LOGIN_FLAGS_READ_ACTIVE should be cleared early just after
doing the receive and before writing to the socket in
iscsi_target_do_login_rx.

But sad news is that LOGIN_FLAGS_READ_ACTIVE is also used
by sk_state_change to do login cleanup if a socket was closed
at login time. It is supposed to be cleared after the login
pdu is successfully processed and replied.

So introduce another flag LOGIN_FLAGS_WRITE_ACTIVE to cover
the transmit part so that sk_state_change could work well
and clear LOGIN_FLAGS_READ_ACTIVE early so that sk_data_ready
could also work.

While at here, use login_flags more efficient.

Signed-off-by: Hou Pu <houpu@bytedance.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 34 ++++++++++++++++++++++++++++----
 include/target/iscsi/iscsi_target_core.h |  9 +++++----
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 685d771b51d4..10477e44d17b 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -625,13 +625,37 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	pr_debug("iscsi_target_do_login_rx after rx_login_io, %p, %s:%d\n",
 			conn, current->comm, current->pid);
 
+	/*
+	 * LOGIN_FLAGS_READ_ACTIVE is cleared so that sk_data_ready
+	 * could be trigger again after this.
+	 *
+	 * LOGIN_FLAGS_WRITE_ACTIVE is cleared after we successfully
+	 * process a login pdu, so that sk_state_chage could do login
+	 * cleanup as needed if the socket is closed. If a delayed work is
+	 * ongoing (LOGIN_FLAGS_WRITE_ACTIVE or LOGIN_FLAGS_READ_ACTIVE),
+	 * sk_state_change will leave the cleanup to the delayed work or
+	 * it will schedule a delayed work to do cleanup.
+	 */
+	if (conn->sock) {
+		struct sock *sk = conn->sock->sk;
+
+		write_lock_bh(&sk->sk_callback_lock);
+		if (!test_bit(LOGIN_FLAGS_INITIAL_PDU, &conn->login_flags)) {
+			clear_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags);
+			set_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags);
+		}
+		write_unlock_bh(&sk->sk_callback_lock);
+	}
+
 	rc = iscsi_target_do_login(conn, login);
 	if (rc < 0) {
 		goto err;
 	} else if (!rc) {
-		if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_READ_ACTIVE))
+		if (iscsi_target_sk_check_and_clear(conn,
+						    LOGIN_FLAGS_WRITE_ACTIVE))
 			goto err;
 	} else if (rc == 1) {
+		cancel_delayed_work(&conn->login_work);
 		iscsi_target_nego_release(conn);
 		iscsi_post_login_handler(np, conn, zero_tsih);
 		iscsit_deaccess_np(np, tpg, tpg_np);
@@ -640,6 +664,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 
 err:
 	iscsi_target_restore_sock_callbacks(conn);
+	cancel_delayed_work(&conn->login_work);
 	iscsi_target_login_drop(conn, login);
 	iscsit_deaccess_np(np, tpg, tpg_np);
 }
@@ -670,9 +695,10 @@ static void iscsi_target_sk_state_change(struct sock *sk)
 	state = __iscsi_target_sk_check_close(sk);
 	pr_debug("__iscsi_target_sk_close_change: state: %d\n", state);
 
-	if (test_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags)) {
-		pr_debug("Got LOGIN_FLAGS_READ_ACTIVE=1 sk_state_change"
-			 " conn: %p\n", conn);
+	if (test_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags) ||
+	    test_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags)) {
+		pr_debug("Got LOGIN_FLAGS_{READ|WRITE}_ACTIVE=1"
+			 " sk_state_change conn: %p\n", conn);
 		if (state)
 			set_bit(LOGIN_FLAGS_CLOSED, &conn->login_flags);
 		write_unlock_bh(&sk->sk_callback_lock);
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 591cd9e4692c..844bef255e89 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -566,10 +566,11 @@ struct iscsi_conn {
 	struct socket		*sock;
 	void			(*orig_data_ready)(struct sock *);
 	void			(*orig_state_change)(struct sock *);
-#define LOGIN_FLAGS_READ_ACTIVE		1
-#define LOGIN_FLAGS_CLOSED		2
-#define LOGIN_FLAGS_READY		4
-#define LOGIN_FLAGS_INITIAL_PDU		8
+#define LOGIN_FLAGS_READY		0
+#define LOGIN_FLAGS_INITIAL_PDU		1
+#define LOGIN_FLAGS_READ_ACTIVE		2
+#define LOGIN_FLAGS_WRITE_ACTIVE	3
+#define LOGIN_FLAGS_CLOSED		4
 	unsigned long		login_flags;
 	struct delayed_work	login_work;
 	struct iscsi_login	*login;
-- 
2.11.0

