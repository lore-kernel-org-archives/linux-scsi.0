Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDE523ABB9;
	Thu, 11 Jun 2026 05:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781156493; cv=none; b=mNYAxvyCy72ngmFt4sShpINB4T0B79JGG+I4j21rnNiFAULLmyUebVm9k3HektTOwM/R4+On7BHyy9TF5z8noiaOcHIq5YIHwAZEo2KroOllp3w6Xe/jjeW6m7u+RNieIIJHgxUAyMSjZEWxj9c20RhsJrltz08VBvjmRqdZh/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781156493; c=relaxed/simple;
	bh=pTpu5XFQpelgw4k+UN+3Zof3bpfuaNRmvg+ifwuojcs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=He9M6VrSgSuHk8GRWNIpkvgea8hO3LS1TkXsXa4z8sYM/aU/gpM1jVAI/sGOMoROOy6iicPgDBPwTbBQt15fWMX4lLYYpSPBZJKakQ3DhJF2XNllgRYvlPe3ubF59EkE9MQUxxR2GofI+N4HxDRc/xDDBkdXDqqWJU1J11rnIWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=SXPEaUkT; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="SXPEaUkT"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 41f34cc06;
	Thu, 11 Jun 2026 13:36:13 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: open-iscsi@googlegroups.com,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	runyu.xiao@seu.edu.cn
Subject: [PATCH] scsi: iscsi_tcp: use WRITE_ONCE() for shared socket callbacks
Date: Thu, 11 Jun 2026 13:36:10 +0800
Message-Id: <20260611053610.2435548-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9eb52e585903a1kunme2f62dd7151683
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDTU0YVkIaTk1LTR9MTEpLGVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=SXPEaUkTu9LULhIM0EM9ck7kQ/j/XBxo556qoycFx9GG/+Z5mFt5XZJ4kqeaqYVvTpqhlCQC57ireXjMbtYLBDm+qHa6uzjcd4b4IjUQ34FzwtH3pYEb7vuqrm8XUueDqVpEz1ci0LK0/ODK1Z6Ta+KxuZatb4vIJJfDXHndEAU=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=CwNuDXeIvT8BWfXDicqZLqpiuN5Iwkvqkv4hiZaEdSc=;
	h=date:mime-version:subject:message-id:from;

iscsi_sw_tcp_conn_set_callbacks() and
iscsi_sw_tcp_conn_restore_callbacks() replace and restore
sk->sk_data_ready and sk->sk_write_space on a live TCP socket with
plain stores. These callback pointers are shared with generic socket
and TCP paths that may read or invoke them concurrently, so the write
side needs the same WRITE_ONCE() contract that commit 2ef2b20cf4e0
("net: annotate data-races around sk->sk_{data_ready,write_space}")
applied elsewhere.

If another CPU has taken an earlier callback snapshot, the plain
replace and restore leave the same visibility hole as the validated
4022 family. A stale snapshot can then still call
iscsi_sw_tcp_data_ready() or iscsi_sw_tcp_write_space() after the live
socket has already been restored to sock_def_readable() or
sk_stream_write_space(), with sk_user_data cleared.

Use WRITE_ONCE() for the shared sk_data_ready and sk_write_space
stores in both the callback-install and callback-restore paths. This
matches the required socket callback visibility contract while keeping
the existing locking and sk_state_change handling unchanged.

Fixes: 38e1a8f5479d ("[SCSI] iscsi_tcp: hook iscsi_tcp into new libiscsi_tcp module")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/scsi/iscsi_tcp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 7b4fe0e6afb2..5dabda97043d 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -254,9 +254,9 @@ static void iscsi_sw_tcp_conn_set_callbacks(struct iscsi_conn *conn)
 	tcp_sw_conn->old_data_ready = sk->sk_data_ready;
 	tcp_sw_conn->old_state_change = sk->sk_state_change;
 	tcp_sw_conn->old_write_space = sk->sk_write_space;
-	sk->sk_data_ready = iscsi_sw_tcp_data_ready;
+	WRITE_ONCE(sk->sk_data_ready, iscsi_sw_tcp_data_ready);
 	sk->sk_state_change = iscsi_sw_tcp_state_change;
-	sk->sk_write_space = iscsi_sw_tcp_write_space;
+	WRITE_ONCE(sk->sk_write_space, iscsi_sw_tcp_write_space);
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
@@ -270,9 +270,9 @@ iscsi_sw_tcp_conn_restore_callbacks(struct iscsi_conn *conn)
 	/* restore socket callbacks, see also: iscsi_conn_set_callbacks() */
 	write_lock_bh(&sk->sk_callback_lock);
 	sk->sk_user_data    = NULL;
-	sk->sk_data_ready   = tcp_sw_conn->old_data_ready;
+	WRITE_ONCE(sk->sk_data_ready, tcp_sw_conn->old_data_ready);
 	sk->sk_state_change = tcp_sw_conn->old_state_change;
-	sk->sk_write_space  = tcp_sw_conn->old_write_space;
+	WRITE_ONCE(sk->sk_write_space, tcp_sw_conn->old_write_space);
 	sk->sk_no_check_tx = 0;
 	write_unlock_bh(&sk->sk_callback_lock);
 }
-- 
2.34.1
