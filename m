From: Ying Xue <ying.xue@windriver.com>
Subject: [PATCH] iscsi: Don't disable BH on BH context
Date: Tue, 21 Aug 2012 09:28:27 +0800
Message-ID: <1345512507-8257-1-git-send-email-ying.xue@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:35579 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2HUBYU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2012 21:24:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

Since we have already in BH context when iscsi_sw_tcp_write_space()
is called, it's unnecessary to disable BH.

Signed-off-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Michael Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9220861..d763857 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -194,7 +194,7 @@ static void iscsi_sw_tcp_write_space(struct sock *sk)
 	struct iscsi_sw_tcp_conn *tcp_sw_conn;
 	void (*old_write_space)(struct sock *);
 
-	read_lock_bh(&sk->sk_callback_lock);
+	read_lock(&sk->sk_callback_lock);
 	conn = sk->sk_user_data;
 	if (!conn) {
 		read_unlock_bh(&sk->sk_callback_lock);
@@ -204,7 +204,7 @@ static void iscsi_sw_tcp_write_space(struct sock *sk)
 	tcp_conn = conn->dd_data;
 	tcp_sw_conn = tcp_conn->dd_data;
 	old_write_space = tcp_sw_conn->old_write_space;
-	read_unlock_bh(&sk->sk_callback_lock);
+	read_unlock(&sk->sk_callback_lock);
 
 	old_write_space(sk);
 
-- 
1.7.11

