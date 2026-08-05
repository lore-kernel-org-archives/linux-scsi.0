Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD253DD532
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 06:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785912850; cv=none; b=b2L4T7fpX0Cd+epWAtwo3emEQ7X/FJH2AAEOJYmS7oiix3DS6A0A94NP4YI7RRCEg9uJd5HH7eppi39BuaIyRk8eTIXBOpp+K//vUX1HQ+1wmKH6fEgmCti4u7bqsO8QG43Wi3YALK9tRyqv8OzxcPk1t768+3z3SRKgVmdBygg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785912850; c=relaxed/simple;
	bh=HqgE/iW+eE/eiPaxSt8xbys7nNXqvy8TA9ls2Ynusyg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L7thUmZ9whOKPNIN5CaZq1T0HKNp+fpAmAGjengl2odQFOhEyJEz1ShAm96rBNOK4PRU5QzRVGkE9dk6L8+wMZTHY2VNUr1yYdG6qvl3qsySmOqE9vqcrRGE0IhVxZRySxg0uNEbXbAcPfK02mobrtcqTjUhmfemCwTvkkC8yJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VMRWuyKJ; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VMRWuyKJ"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38dfe7eb825so525772a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2026 23:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785912838; x=1786517638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1hVVe+2SEo04ryaB7GG9pOTNlQvAC9QD/BxdsX78cJA=;
        b=VMRWuyKJNCny3SCr5e7qviCaSpHTIlQrbC8cpJ1Eb9WQB0gAkLP+jPI2gRU+oeBR9S
         j+Yv2n1adAzvAxajivOyDp02W5VpkxQYiiR5whghefli8AS98e9Y3dmd8ogdpeTUgJHe
         CSkvqqY0oMPf9oPw0v0+Pmjcb6jlzDqpYp+5/oWyp9MR6mlybw3+FE0ggciiQlsNV2j6
         6sL4DWOa6burtskTr46wZ3erRkieRLN6inz0YI6jH5o3vTmQgsivr2ThkEFwhLevKhgu
         mWJQX50YX+IJd6CSAiQrP2vuHja5xAQF8f3Ice+oMJAGYgkl1FDguAoOi6s478sGLpiV
         LkxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785912838; x=1786517638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1hVVe+2SEo04ryaB7GG9pOTNlQvAC9QD/BxdsX78cJA=;
        b=fNbFl8SaU+sV8RTg/dqY4dTtQsh/9u6ExikemOb+P+0MDd/XY7F3So40sXQI9raYFV
         k3Oh698i88HlDCL3pN5Wuhe+j5+knQR2SwuvWrdOg1m+SwOeLmwLqwpPW/Z7PYj0ejhb
         JGjvVqN8xzRtYSTdGdFPmZTD0wSWDPEq+sDOav8SqVLTo/LZz5/jPFAVfz4ksb7Gf9Ie
         kI9TSSLe3CZz5D/bMuuIndqkPXV5ULjWcjqcetxqa0tzkM3XnuzL5h/ATciVuc9oWw/s
         nVeM+zVzvxD11Ed2E1sy36BQqfPVhe7+IsION3DPM/f7tDSW+bg11RlRV34JFye7fvAR
         JvEg==
X-Forwarded-Encrypted: i=1; AHgh+RocspbzEzIBBoFHusc+K0tn8rNoy8FO9H4UkdAfhOE3yj4ToGpCUoMxxPF5CTVzzdIoZkQnqJmA4d+i@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf4xwh8qwxEyqvubLdaRachcoT1Lq980ubOgm6CeupWTf2L0xy
	ZQtcinHAHcZX2KS+P9k31PS7aHEjKauJ9rKBgEEAMRiYxSxLUpRj+Yk7z5rRO+FSi0U=
X-Gm-Gg: AR+sD10cT3UolL9blP9ICqCgLFelPPc+DVyzk0h4n6iozHGjFyAehrtUaRfXtIqB8hl
	gHNyZz+s6nMxdzcmLN1pPlFLTRylxbXo5IK5DaTCIJ9e4O0xvgKe+VclOCgyiXD7TXKyNMvuC/f
	B+SkHLcoplU6+TCZtruKT2cUHz3rmnUp/4m6eRnXXDuIMr85nZ59Y7ilz4zogiN3g2bqXu8a9F0
	YtkwPDNiHuhVc5PkX2jmkIBXQn6MULcUCt34NazmZ3OU8mUBVXVdsu2d5K/6jx8LNNw65ef1/oU
	TILyIO7mE3iW0UPx2wMTAAeuS9xY0TBC43eh+Ko3LhTuBvakUO/tWPuAhl824PyqmnYn3XNXBid
	cmLYWQxvfm1ZkIOQGYBFdOkiMcSwGbmeSAdeY1JjFVcHl5KN/pealAx2gaTuU37qXR/vq1RKb1e
	4BP80WwaddkQ/OWQlXakMF4CBPbVoH0vJV+p5kL8bqG2nnTK9rr2RsfZU8ViHOz7aBa9Bikr8i6
	8d84bormN4vV0rSJzgMLwQ=
X-Received: by 2002:a17:90b:3d81:b0:380:f85c:94b4 with SMTP id 98e67ed59e1d1-3903c543020mr4931768a91.7.1785912838292;
        Tue, 04 Aug 2026 23:53:58 -0700 (PDT)
Received: from localhost.localdomain ([118.112.74.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fee06b438sm3604910a91.16.2026.08.04.23.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 23:53:57 -0700 (PDT)
From: Jiayuan Liang <ljykernel@gmail.com>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiayuan Liang <ljykernel@gmail.com>
Subject: [PATCH] scsi: iscsi_tcp: Fix null-pointer dereference in iscsi_sw_tcp_conn_restore_callbacks
Date: Wed,  5 Aug 2026 14:53:26 +0800
Message-ID: <20260805065326.1952-1-ljykernel@gmail.com>
X-Mailer: git-send-email 2.47.0.windows.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A null-pointer dereference can occur in
iscsi_sw_tcp_conn_restore_callbacks() due to a race condition
leading to concurrent/re-entrant invocations of
iscsi_sw_tcp_release_conn().

Specifically, the re-entrancy can be triggered under the
following scenario:

1. The iSCSI client initiates a logout, actively stopping the
   connection via:
   iscsi_if_stop_conn()
     -> iscsi_stop_conn(..., STOP_CONN_TERM)
          -> cancel_work_sync(&conn->cleanup_work)
          -> iscsi_sw_tcp_release_conn()

2. Simultaneously, a server disconnect triggers a heartbeat
   timeout on the client side, executing the timeout path:
   iscsi_check_transport_timeouts()
     -> iscsi_conn_failure()
          -> iscsi_conn_error_event()
               -> queue_work(..., &conn->cleanup_work)

   This schedules iscsi_cleanup_conn_work_fn(), which calls:
   iscsi_cleanup_conn_work_fn()
     -> iscsi_stop_conn(..., STOP_CONN_RECOVER)
          -> iscsi_sw_tcp_release_conn()

If these two paths execute concurrently, iscsi_sw_tcp_release_conn()
is re-entered. Since the first invocation releases the socket and
sets tcp_sw_conn->sock to NULL, the subsequent re-entrant
invocation in iscsi_sw_tcp_conn_restore_callbacks() attempts to
dereference the NULL pointer at `tcp_sw_conn->sock->sk`, resulting
in a kernel panic (Oops):

BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
Oops: 0000 [#1] SMP PTI
Workqueue: iscsi_conn_cleanup iscsi_cleanup_conn_work_fn [scsi_transport_iscsi]
RIP: 0010:iscsi_sw_tcp_release_conn+0x54/0x110 [iscsi_tcp]
Call Trace:
 iscsi_sw_tcp_conn_stop+0x5d/0x80 [iscsi_tcp]
 iscsi_stop_conn+0x66/0xc0 [scsi_transport_iscsi]
 iscsi_cleanup_conn_work_fn+0x6e/0xb0 [scsi_transport_iscsi]
 process_one_work+0x1a7/0x360
 worker_thread+0x30/0x390
 kthread+0x10a/0x120
 ret_from_fork+0x35/0x40

Fix this by adding a NULL check for `tcp_sw_conn->sock` in
iscsi_sw_tcp_conn_restore_callbacks() before attempting to access
the socket's internal fields.

Signed-off-by: Jiayuan Liang <ljykernel@gmail.com>
---
 drivers/scsi/iscsi_tcp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9260b1c9b0e0..0eabb8b59f46 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -265,8 +265,12 @@ iscsi_sw_tcp_conn_restore_callbacks(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
-	struct sock *sk = tcp_sw_conn->sock->sk;
+	struct sock *sk;
 
+	if (!tcp_sw_conn->sock)
+		return;
+
+	sk = tcp_sw_conn->sock->sk;
 	/* restore socket callbacks, see also: iscsi_sw_tcp_conn_set_callbacks() */
 	write_lock_bh(&sk->sk_callback_lock);
 	sk->sk_user_data    = NULL;
@@ -277,6 +281,7 @@ iscsi_sw_tcp_conn_restore_callbacks(struct iscsi_conn *conn)
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
+
 /**
  * iscsi_sw_tcp_xmit_segment - transmit segment
  * @tcp_conn: the iSCSI TCP connection
-- 
2.43.0

