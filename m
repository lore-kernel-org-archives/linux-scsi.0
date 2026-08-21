Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E260432BD9
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 09:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787304649; cv=none; b=NwHux5DC0gcAUWJUwBYyaXCufO+FVj/kd0jJL5OK44eYtx7OurX15TCTn1qt34gyJQCJhYik6yFIpQ2Pd8oHl5i6WDCRfnlESHQE5hpKcUQEp0s+3jplmZZzzwz4Mv9HjnnIBy0jNrTxK+mtRNaNqfqcr33xtAHQ6CaUm1W+nN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787304649; c=relaxed/simple;
	bh=Kv7v1ylWlxIz/9FEA/Ua+65esYoyA0f6yC9psHFt0KE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gq/Lq+o9wVcltQfYKIP8ZFgFhFY6WpqfQaXKwhnZVusFw67hrngE8mPAZdiiKNmMNWIPFcspQRYv5He7A6Bhe8UhunD2Pjpk3Oo9G77hoxt7d5IHhaYYDWCos9T3amSRQxPqi1XlDRgF8K53OvWPA7WO6OGK9ArXH1OvlP9U73Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hRFQd1FLWzYQv4J
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 17:30:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 65C4C4058F
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 17:30:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP2 (Coremail) with UTF8SMTPSA id Syh0CgA3o4q7GohqZuCMDA--.3625S5;
	Fri, 21 Aug 2026 17:30:37 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org
Cc: yebin10@huawei.com
Subject: [PATCH -next 1/2] scsi: iscsi: fix NULL pointer dereference in iscsi_sw_tcp_release_conn()
Date: Fri, 21 Aug 2026 17:24:34 +0800
Message-Id: <20260821092435.1632931-2-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260821092435.1632931-1-yebin@huaweicloud.com>
References: <20260821092435.1632931-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgA3o4q7GohqZuCMDA--.3625S5
X-Coremail-Antispam: 1UD129KBjvJXoW3JFyxZr1ftw4DJFW5tF4fZrb_yoW7Cw4xpr
	45W34UCrW8J3sY9F4DWrs0qr43tFZ5uFW2yF1xGrs5A3WUt343t3y8Jw1jgFWUKr4kXr17
	tr4jqwsY93WUA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Cb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jb8n5UUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

This's issue as follows:
 connection50052:0: detected conn error (1020)
BUG: kernel NULL pointer dereference, address: 0000000000000018
PGD 0 P4D 0
Oops: 0000 [#1] SMP NOPTI
CPU: 2 PID: 2696024 Comm: kworker/u8:0 Kdump: loaded Tainted: G        W  OE K   5.10.0-136.12.0.86.x86_64 #1
Workqueue: iscsi_conn_cleanup iscsi_cleanup_conn_work_fn [scsi_transport_iscsi]
RIP: 0010:iscsi_sw_tcp_release_conn+0x73/0x1d0
RAX: 0000000000000000 RBX: ffff9ae5ede7a4a0 RCX: 0000000000000002
RDX: 000000000027acac RSI: 0000000000000002 RDI: 0001ce6ceb593ebc
RBP: ffff9ae5c16c7400 R08: 0000000000000002 R09: 000000000027ac54
R10: ffffb8e4408ffc38 R11: ffffffffbb93b5c0 R12: ffff9ae5ede7a7d8
R13: ffff9ae5ede7a7d8 R14: ffff9ae5c3376c00 R15: ffff9ae5c3376c05
FS:  0000000000000000(0000) GS:ffff9ae5fad00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000018 CR3: 0000000131872003 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 iscsi_sw_tcp_release_conn+0x73/0x1d0
 iscsi_sw_tcp_conn_stop+0x5e/0x78 [iscsi_tcp]
 iscsi_stop_conn+0x5f/0xb0 [scsi_transport_iscsi]
 iscsi_cleanup_conn_work_fn+0x87/0x100
 process_one_work+0x1b2/0x350
 worker_thread+0x49/0x310
 kthread+0xfb/0x140
 ret_from_fork+0x1f/0x30

Above issue may happen as follows:
            user                            kernel
iscsi_if_recv_msg
  iscsi_if_transport_conn(transport, nlh, rlen);
   iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
    if (flag == STOP_CONN_TERM)
     cancel_work_sync(&conn->cleanup_work); // work not queue yet.

                     iscsi_conn_error_event
                      switch (state)
                       case ISCSI_CONN_UP:
                         if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP,
                                               &conn->flags);
                           //queue work
                           queue_work(iscsi_conn_cleanup_workq,
                                    &conn->cleanup_work);
                    ...
                     // run work
                     iscsi_cleanup_conn_work_fn
                       iscsi_stop_conn(conn, STOP_CONN_RECOVER);
                        conn->transport->stop_conn(conn, flag);
                         iscsi_sw_tcp_conn_stop(conn, flag);
                           struct socket *sock = tcp_sw_conn->sock;
                           if (!sock)  // pass
                             return;

    iscsi_stop_conn(conn, flag);
      conn->transport->stop_conn(conn, flag);
        iscsi_sw_tcp_conn_stop(conn, flag);
          struct socket *sock = tcp_sw_conn->sock;
          mutex_lock(&tcp_sw_conn->sock_lock);
          tcp_sw_conn->sock = NULL; // clear sock
          mutex_unlock(&tcp_sw_conn->sock_lock);

                          iscsi_sw_tcp_conn_restore_callbacks(conn);
                            struct sock *sk = tcp_sw_conn->sock->sk;
                            *** trigger null ptr dereference ***

To solve above issue, when the user mode delivers the STOP_CONN_TERM,
the ISCSI_CLS_CONN_BIT_CLEANUP status needs to be set to prevent
concurrent invoking of iscsi_stop_conn().

Fixes: 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 43 +++++++++++++++--------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 8aa76f813bcd..aea319c1e72f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2266,6 +2266,8 @@ static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
 
 static int iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 {
+	bool cleanup;
+
 	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop.\n");
 	/*
 	 * For offload, iscsid may not know about the ep like when iscsid is
@@ -2278,35 +2280,36 @@ static int iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 	mutex_unlock(&conn->ep_mutex);
 
 	/*
-	 * If this is a termination we have to call stop_conn with that flag
-	 * so the correct states get set. If we haven't run the work yet try to
-	 * avoid the extra run.
+	 * Figure out if it was the kernel or userspace initiating this.
 	 */
-	if (flag == STOP_CONN_TERM) {
-		cancel_work_sync(&conn->cleanup_work);
-		iscsi_stop_conn(conn, flag);
-	} else {
+	spin_lock_irq(&conn->lock);
+	cleanup = test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
+	spin_unlock_irq(&conn->lock);
+
+	if (cleanup) {
 		/*
-		 * Figure out if it was the kernel or userspace initiating this.
+		 * If this is a termination we have to call stop_conn with
+		 * that flag so the correct states get set. If we haven't
+		 * run the work yet try to avoid the extra run.
 		 */
-		spin_lock_irq(&conn->lock);
-		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
-			spin_unlock_irq(&conn->lock);
+		if (flag == STOP_CONN_TERM) {
+			ISCSI_DBG_TRANS_CONN(conn,
+					"cancel kernel conn cleanup.\n");
+			cancel_work_sync(&conn->cleanup_work);
 			iscsi_stop_conn(conn, flag);
 		} else {
-			spin_unlock_irq(&conn->lock);
 			ISCSI_DBG_TRANS_CONN(conn,
-					     "flush kernel conn cleanup.\n");
+					"flush kernel conn cleanup.\n");
 			flush_work(&conn->cleanup_work);
 		}
-		/*
-		 * Only clear for recovery to avoid extra cleanup runs during
-		 * termination.
-		 */
-		spin_lock_irq(&conn->lock);
-		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
-		spin_unlock_irq(&conn->lock);
+	} else {
+		iscsi_stop_conn(conn, flag);
 	}
+
+	spin_lock_irq(&conn->lock);
+	clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
+	spin_unlock_irq(&conn->lock);
+
 	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop done.\n");
 	return 0;
 }
-- 
2.34.1

