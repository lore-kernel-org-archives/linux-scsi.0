Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 316B0C54FD0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09AE520700
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:36:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="nfzGQ2nj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgDXMgC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgDXMgC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 08:36:02 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEC7C09B045
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2020 05:36:02 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j7so4553713pgj.13
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2020 05:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qc9BPE38BhUs/Fq8Bh2I3ZLKRz3lKCzlkautN6jZlDA=;
        b=nfzGQ2njmXROz0DAp833ejOh0h8860/0oFep4+k4XiFQGeGALG1j76kKwC/qRsfTha
         eTrwfeNOPIK1GHe6O3BxSYy8bm4B3pUoVy1IeKJjVDa9Dn3HoCP+nyznX+v1iIrh1VVh
         U6oIe+Dzr5xaDnFA2k2nKwPxnRxjQBaO2uygsZauyaJye3Vpvle/hNaT7M+4uZfPDdsp
         rm1+okaAme7phtTYq/zP8kg4PO7YP58G/Y29/Z0a/ti5uFrdP4wV9J0bEEzVuP/NqME/
         rfPYUt+99+nhICsy1/LRjXt/PD6l/s+znZcvdinkfYHLy/eNiAWyvrCqO26sKLpWL8oh
         ygvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qc9BPE38BhUs/Fq8Bh2I3ZLKRz3lKCzlkautN6jZlDA=;
        b=bZapGlSQwH96+b7YpNNTZkANukbl7cd86uscl/72bGLPhBJpSMhfnB1B8wTgjy6klf
         YoBU4p40juteNMcxpc9ZOs1c05WB4kkg3OeVWHvk03eqKvZDonSMHz1ek7SLTznQUZS+
         AzQNAH8NsPcSj7XlT7Ls8mPhmcjaSpGjnd/hNAW5WK1dL+ye/IVh9YQ1AcOVpMJCwUZs
         iNf2b8TZkAhudbPyObMwZc2sCtDmv7Hx4C7179iF2y1ykQxpu8+oCPYIdnKqAfZSjfyc
         f/9gu7CD9OGLiPLjuIkbaWF1CrgWSD21uUYy+kYvVh1CVwSdbon6kSai2SqCBcJllAal
         uP6g==
X-Gm-Message-State: AGi0PuaJR6+mcZabkptH9TfwqdwoQZESX+V5bUCSSWKgtLRUwgc/027N
        jLxSByHJNqYLVLQmRg77erAAZambm2TXcgWt
X-Google-Smtp-Source: APiQypLAH2jr1WSQt8sGHPufGhwk/zTBg9OHh4dnwHUuazpDdwRl5IGDGoRiOK3axt1U7JQH75KG9A==
X-Received: by 2002:a63:1759:: with SMTP id 25mr9270767pgx.417.1587731761775;
        Fri, 24 Apr 2020 05:36:01 -0700 (PDT)
Received: from debian.bytedance.net ([61.120.150.75])
        by smtp.gmail.com with ESMTPSA id 128sm5510851pfy.5.2020.04.24.05.35.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 05:36:01 -0700 (PDT)
From:   Hou Pu <houpu@bytedance.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, Hou Pu <houpu@bytedance.com>
Subject: [PATCH v3 1/2] iscsi-target: fix login error when receiving is too fast
Date:   Fri, 24 Apr 2020 08:35:27 -0400
Message-Id: <20200424123528.17627-2-houpu@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200424123528.17627-1-houpu@bytedance.com>
References: <20200424123528.17627-1-houpu@bytedance.com>
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
 drivers/target/iscsi/iscsi_target_nego.c | 30 ++++++++++++++++++++++++++----
 include/target/iscsi/iscsi_target_core.h |  9 +++++----
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 685d771b51d4..4cfa742e61df 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -622,6 +622,26 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	if (rc < 0)
 		goto err;
 
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
+		clear_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags);
+		set_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags);
+		write_unlock_bh(&sk->sk_callback_lock);
+	}
+
 	pr_debug("iscsi_target_do_login_rx after rx_login_io, %p, %s:%d\n",
 			conn, current->comm, current->pid);
 
@@ -629,7 +649,8 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	if (rc < 0) {
 		goto err;
 	} else if (!rc) {
-		if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_READ_ACTIVE))
+		if (iscsi_target_sk_check_and_clear(conn,
+						    LOGIN_FLAGS_WRITE_ACTIVE))
 			goto err;
 	} else if (rc == 1) {
 		iscsi_target_nego_release(conn);
@@ -670,9 +691,10 @@ static void iscsi_target_sk_state_change(struct sock *sk)
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

