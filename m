Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE5EC2BA19
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 08:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22D032078A
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 08:08:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="ylb7PeJB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635636AbgDOIIr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 04:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2635631AbgDOIIk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2020 04:08:40 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583B0C061A0F
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 01:08:39 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id a23so985780plm.1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 01:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J1KNQcrs+r+mnZk64I+SHchI9mC/y3tQBfBRhzGH08Q=;
        b=ylb7PeJBNyX27HueSsiGtbzDDBcU/RllNtSgxaFPLJGUAZcwxSNQmgDXpgh6UqCXiV
         gZG2iS8HitalmpN1xbbxEhI5TVWW2mqT7Clymxogs2qyM5izhMedjxE7Y/ZzXY9qOWoM
         9doDiQr2cpKwL0xD/Kx9qDOsVCwFxgtZIDtIzrghpC1/1z7rB23GGDQY5iDOB8099gk+
         1jFGGY9i/CYJ0NKbT8h+zX8oyZrr32bRUKGTLY4ZA79zCApUzmYsUYRKsh1+l+c6nh3Z
         POsjJLXsFapEtHDgTsicEAB4DJZ1h6IvrlXHSqm7LNJCu4fYENKT2kBDw08f8MMbsYqM
         93Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J1KNQcrs+r+mnZk64I+SHchI9mC/y3tQBfBRhzGH08Q=;
        b=gw7QMeKwi83kTcm74cMU034Y3DUtp/YWx4anY64criZ6kQvG8lFc5d3qhg0KoTi4+N
         S1bws00FCpHPqr3y18oORNbFEBS8ldf2gFF8Qma6ixau4iUttBb0wcdwSuRkoMh5OWs6
         IZ3i0LwqOcN/OJR994OG94D9PvSPFwEsc7lBXBcAo4/qRbkyy1ItflPwEtqLbsyCoaNb
         ETEBPHCN0ib0LJmVUC+ZzBT6SL/ymFelyUlmG+ovq2Ba47RPeKM6PI8mQ/WKE5ke5kYw
         WByIuD3Co5it4kHM7Jff5GM1ZTbai4lzJ4xASFV4tfYMl6+7PIGeKqfeNgA/9Opa3vmT
         cUiw==
X-Gm-Message-State: AGi0PubFzK3Cebj8Cs3SHFmEw7p97UoEZlImPUrzKrtQa8C3DRfVzq0z
        l5wRgwVuQrKFTGCbP1HzgonpdQ==
X-Google-Smtp-Source: APiQypJCwloBa6GBYdjzyEclkg33cepnJPT9pZgmxs4dUxdmzDcwPNg2lyy2cQvaRXm1RqVQXgT6bg==
X-Received: by 2002:a17:902:8bc7:: with SMTP id r7mr3882761plo.12.1586938118923;
        Wed, 15 Apr 2020 01:08:38 -0700 (PDT)
Received: from debian.bytedance.net ([61.120.150.75])
        by smtp.gmail.com with ESMTPSA id c10sm10020576pfc.23.2020.04.15.01.08.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2020 01:08:38 -0700 (PDT)
From:   Pu Hou <houpu@bytedance.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, Pu Hou <houpu@bytedance.com>
Subject: [PATCH 1/2] iscsi-target: fix login error when receiving is too fast
Date:   Wed, 15 Apr 2020 04:08:18 -0400
Message-Id: <20200415080819.27327-2-houpu@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200415080819.27327-1-houpu@bytedance.com>
References: <20200415080819.27327-1-houpu@bytedance.com>
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
pdu is successfully processed and reponsed.

So introduce another flag LOGIN_FLAGS_WRITE_ACTIVE to cover
the transmit part so that sk_state_change could work well
and clear LOGIN_FLAGS_READ_ACTIVE early so that sk_data_ready
could also work.

Signed-off-by: Pu Hou <houpu@bytedance.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 29 +++++++++++++++++++++++++----
 include/target/iscsi/iscsi_target_core.h |  1 +
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 685d771b51d4..950339655778 100644
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
+	 * processing a login pdu. So that sk_state_chage could do login
+	 * cleanup as need if the socket is closed. If a delay work is
+	 * ongoing LOGIN_FLAGS_WRITE_ACTIVE or LOGIN_FLAGS_READ_ACTIVE),
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
 
@@ -629,7 +649,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	if (rc < 0) {
 		goto err;
 	} else if (!rc) {
-		if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_READ_ACTIVE))
+		if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_WRITE_ACTIVE))
 			goto err;
 	} else if (rc == 1) {
 		iscsi_target_nego_release(conn);
@@ -670,9 +690,10 @@ static void iscsi_target_sk_state_change(struct sock *sk)
 	state = __iscsi_target_sk_check_close(sk);
 	pr_debug("__iscsi_target_sk_close_change: state: %d\n", state);
 
-	if (test_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags)) {
-		pr_debug("Got LOGIN_FLAGS_READ_ACTIVE=1 sk_state_change"
-			 " conn: %p\n", conn);
+	if (test_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags) ||
+	    test_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags)) {
+		pr_debug("Got LOGIN_FLAGS_{READ|WRITE}_ACTIVE=1"
+			 "sk_state_change conn: %p\n", conn);
 		if (state)
 			set_bit(LOGIN_FLAGS_CLOSED, &conn->login_flags);
 		write_unlock_bh(&sk->sk_callback_lock);
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 591cd9e4692c..0c2dfc81bf8b 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -570,6 +570,7 @@ struct iscsi_conn {
 #define LOGIN_FLAGS_CLOSED		2
 #define LOGIN_FLAGS_READY		4
 #define LOGIN_FLAGS_INITIAL_PDU		8
+#define LOGIN_FLAGS_WRITE_ACTIVE	12
 	unsigned long		login_flags;
 	struct delayed_work	login_work;
 	struct iscsi_login	*login;
-- 
2.11.0

