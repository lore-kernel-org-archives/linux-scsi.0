Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094241;
	b=pQpEcQ88QFDJ5F2OPE1vG2CQ8m8QU3zC6EciLu+3vSj2lV9cMxmABJvvyBnT58eeNDPv
	 wQJgwhuq5/eTSV9fPf7zLgZ6rNaDqJN3G8nB7zDBNe0NrD3IdyyC0BKZhYNORQNUF2U5T
	 lw9nx6OoRrbKabJ0wG5omHe4Q+7pt5FZis7p9MVysjW40dboXZy/VQhsSCwMsXagKaWeu
	 IT8zNFMBFtjW3LUiCviqTU5np1gANJlsvgGLgG3h7ORE1ygYUIs6kYYNIp5neepxIy/bT
	 st0XuoCLBJUSbosS1+ceOp5TY95Bi1aG9fZAtT0cjr0hh/t2IgWPefLpL7IT05RKuTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094241;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=35MopraF3C+XS9oIkKzwdK1L6EY4ZqyO/LOySOhAuGw=;
	b=Zn7yVYoLPYZLfJcUGIY2B7ND9iMjcSX35261Qk44CTwEIBwJWAZAKkrY+f6PSqdutjwP
	 Fv/Jafx6dgQOqdnuRWTQDtDCeL0cRjiMqCBFCF6u9ZJUi4R9K7A+daHEso4xAjaeArxlH
	 2lo4mFih56f2Xeq8yc3b1RAaEYN+aVllRoLSILp3U2+EnYfacQ8jUZdd+aGyBxnQOW7Zy
	 ntYJpMiXgXJketyvGBqU9aYmPyy1tevX0DwvAF6McS6wVz4oNcAMUbbWmijH2wIoJg01U
	 vVgD6rX7XNp04MPgW5E5KCJxYEYA6vSGiTX4XKJYEufn61kZdpGKgXjiMncVn5Rhzng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lKeV78Ik;
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480EA60A260D
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 13:17:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 480EA60A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lKeV78Ik
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8c5ebbc5150so1530420b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 05:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795094241; x=1795699041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=35MopraF3C+XS9oIkKzwdK1L6EY4ZqyO/LOySOhAuGw=;
        b=lKeV78IkpEm8XqBRcwuPYi/hj34OcG16laZ3F0AV33ZmYsJ5QG0EoCo0q2ybzeyI0F
         gyboZDW3iEWmhFU9IxSwcjRGZIfH3e3R9wdAok2qqgCiT+DKynwf+7owriGxQRlZmBJo
         3qBvBXz7BPyMfvjIra7sOXOh+LYXjuawhI7CyI0DBdX8AVyMfrONP7i4u0lBUb9kvynk
         sQPU+BOrVzEIhcUkktroX0sWuj/qH8gnoliRJKkpexHCZdJwcVCqixqWTlzTzlCfuPsQ
         s57Cb31qg7scMr2kJCnWKPdATIAzLPzpNE82LJCCdEmgOnihbD5iXGE64d7KODw5kS1h
         G4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795094241; x=1795699041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=35MopraF3C+XS9oIkKzwdK1L6EY4ZqyO/LOySOhAuGw=;
        b=RqrQi9tbrxqxX12z+48Yw1XJu7kbXuec7B5R7X8a88FVqesdJH3caUcLkTb3wx7F/z
         TqzHO3ODo4mza25YiU44Q2E9IIDxBKJ6d55S5cxwUlftb7riFeYYiAlTw0NNzzQnfipB
         PO8GG7NpZA+t3lpGAEuZTB6P6odCAucsSjeKO2j6DNmbHvlEKpkiG7y7TXAe2ueyNPmo
         N1UNdQbYvO+o/6lr8Q2L3hnA1Y2YCp0taXjx3SW9jnE5RuisO0tiWZe246cUTYrJ64gj
         rM32w/oQmIc9YVsE+q0gGuUzpDV9mwQKb+IhGguA3neLXXKyry8x4QksucfoIE9IpHDQ
         FtuA==
X-Forwarded-Encrypted: i=1; AL+hErGiPLv4DJEjGKsfzrrsyIm4TKdpH4HWV8twgo25GwEIOB5zVshN2YsSSQA5vwL7vT5tDJz1Ti9dXVm+@vger.kernel.org
X-Gm-Message-State: APuU4Z+NtbER7K8UaH3QnOAUH+BflaX4xdF4/dDBIGg2Y7sirYQ32Es+
	Vn/C303j8pNzj1E2nwQBjNPfGRhjz81aU2RqAicE1DlJHXul/NAhMXBerqUni21kMEY=
X-Gm-Gg: AYBFou2hl6UdhJTVb9bhv8ZZKJ8rW76+qV+5CZDtXjXO0AMDz88xuoQvkwQoKtVzz0E
	ZhUdm0j7FEHDkSx9HOf3KWuYwJ0/cpAHWQolW4tMOkDUqrGtJVQupJgUYpxjkbmj6Mk3HjCQ8n3
	BRRA9lGd13ypxZLzfhcGS9pzyWFM0pd1gjAJkMeub9N976IhnJpkzbkSPKPQt/sSIizYGoRqpZU
	9uf9kAux1f7whOKE1bpyfUHvYmlciz1ICkR9iffBmeWBEqaVRJbOWr1RZK8jtNgbKsNVg9rfRkT
	diIDfRmXZL//7KPLIusmpHmRF+OMqHlheF/dohEoH3zsxy9vu4ZOLOSLimmqjWrLtZTuFeQS7j/
	STjIPs2BGbFaAA4vkO5gF8SlAcLhPAuDBOcUEw3PFgh1nvGa19gMK8Nkyi9Ld4TEkKFZhJPAT+b
	1Nt8ZaXzCVPz1yTlrs9zy0nl7DPgof7bOO5XGIZXTgAefRaDHeXk39vqKrtfFU1NpySPoXf9I5U
	BkTYA9Er39oZHzFCe+/e2IVklkVCyVPY1faNno0DJYoOvSWjsYU7SBtegMM18NR4wLnuO+dHYw5
	QeQPA9CGIon+ReDEqaXGRFYVFTW0zTZi34wktgLqP9HXtQn2p3mTalax1RnuI9zq9MB3VG3TNFW
	GA4mbhTmf21g5r5HWpl9VVBWisvVxvJLQoGtRd8IT3SX96oK/dNWD3a/kIV0=
X-Received: by 2002:a05:6a00:440c:b0:883:71f6:5fb with SMTP id d2e1a72fcca58-8c5d2e5ea36mr5621115b3a.13.1795094240683;
        Thu, 19 Nov 2026 05:17:20 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:1076:1f1f:dde8:a816])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5c7f99f91sm2809467b3a.5.2026.11.19.05.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:17:20 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/4] IB/isert: finish a Reject the target core allocated itself
Date: Thu, 19 Nov 2026 22:16:59 +0900
Message-ID: <20261119131700.2722108-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
References: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iscsit_add_reject() builds the Reject from a command of its own, with
iscsit_allocate_cmd(), and iscsit_allocate_cmd() zeroes sizeof(struct
iscsit_cmd) plus the transport's priv_size.  For iSER that zeroes struct
isert_cmd too, so conn, iscsit_cmd and rx_desc are all NULL where
isert_allocate_cmd() would have filled them in.  The command then reaches
the tx thread like any other, and two things go wrong with it.

isert_put_reject() hands the NULL descriptor to isert_post_recv(), which
dereferences it.  One PDU after login is enough:
iscsit_check_dataout_hdr() answers a Data-Out whose DataSegmentLength
exceeds conn_ops->MaxXmitDataSegmentLength that way, and it does so
before it looks the ITT up, so there is no SCSI command involved.  With
TargetRecvDataSegmentLength negotiated down to 512 and one Data-Out
declaring and carrying 1024 bytes, 5 boots out of 5:

  [    3.657391] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000484: 0000 [#1] SMP KASAN NOPTI
  [    3.660192] KASAN: probably user-memory-access in range [0x0000000000002420-0x0000000000002427]
  [    3.661302] CPU: 0 UID: 0 PID: 168 Comm: iscsi_ttx Not tainted 7.4.0-rc2-RJ7A-00716-g23c62304dde2 #15 PREEMPT(lazy)
  [    3.662601] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  [    3.664015] RIP: 0010:isert_post_recv+0x98/0x210
  [    3.664623] Code: 89 f8 48 c7 44 24 48 00 00 00 00 48 c7 44 24 50 00 00 00 00 48 c1 e8 03 48 c7 44 24 58 00 00 00 00 48 c7 44 24 60 00 00 00 00 <0f> b6 04 10 84 c0 74 06 0f 8e 2c 01 00 00 31 ed 80 be 20 24 00 00
  [    3.666840] RSP: 0018:ffff888109437c10 EFLAGS: 00010206
  [    3.667470] RAX: 0000000000000484 RBX: 1ffff11021286f83 RCX: 0000000000000001
  [    3.668323] RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000002420
  [    3.669134] RBP: ffff888109440480 R08: 00000000000002ac R09: 0000000000000001
  [    3.669943] R10: ffff888104f99447 R11: 00000000a4c8e811 R12: ffff888109404000
  [    3.670752] R13: ffff888109404000 R14: ffff888104d8e000 R15: ffff888109440000
  [    3.671552] FS:  0000000000000000(0000) GS:ffff88817605d000(0000) knlGS:0000000000000000
  [    3.672458] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [    3.673086] CR2: 00007fe324237000 CR3: 0000000104f45002 CR4: 0000000000770ef0
  [    3.673857] PKRU: 55555554
  [    3.674160] Call Trace:
  [    3.674442]  <TASK>
  [    3.674686]  ? __pfx_isert_post_recv+0x10/0x10
  [    3.675178]  isert_post_response+0x85/0x1b0
  [    3.675632]  ? __pfx_isert_post_response+0x10/0x10
  [    3.676163]  ? isert_response_queue+0x91d/0x19a0
  [    3.676664]  iscsi_target_tx_thread+0x3de/0x6f0
  [    3.677163]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [    3.677694]  ? _raw_spin_lock_irq+0x10/0xe0
  [    3.678155]  ? __pfx_autoremove_wake_function+0x10/0x10
  [    3.678697]  ? __pfx_kthread_affine_node+0x10/0x10
  [    3.679195]  ? __kthread_parkme+0x88/0x170
  [    3.679617]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [    3.680142]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [    3.680663]  kthread+0x2c8/0x3b0
  [    3.681011]  ? recalc_sigpending+0x15c/0x1e0
  [    3.681457]  ? __pfx_kthread+0x10/0x10
  [    3.681851]  ret_from_fork+0x36e/0x5a0
  [    3.682244]  ? __pfx_ret_from_fork+0x10/0x10
  [    3.682687]  ? __switch_to+0x572/0xdc0
  [    3.683085]  ? __pfx_kthread+0x10/0x10
  [    3.683481]  ret_from_fork_asm+0x1a/0x30
  [    3.683900]  </TASK>
  [    3.684139] Modules linked in:
  [    3.684552] ---[ end trace 0000000000000000 ]---

The tx thread dies there, and the teardown that follows walks into the
connection it was using: a KASAN slab-use-after-free in do_send_sig_info()
from iscsit_cause_connection_reinstatement(), a refcount warning in
iscsit_close_connection() and a second Oops in kthread_stop().

The Reject also stays on conn->conn_cmd_list until it is sent, so the core
can hand it to isert_immediate_queue() with ISTATE_REMOVE instead, where
isert_put_cmd() reads isert_cmd->iscsit_cmd and isert_cmd->conn and finds
the same two NULL pointers.  Before the first patch of this series that
happened on these very two PDUs, because a NOP-Out with a reserved ITT and
TTT 0 matched the Reject on its tag alone.

So fill the two back pointers in where the core hands a command over -
isert_immediate_queue() and isert_response_queue(), which covers every
state including ISTATE_REMOVE - and let isert_post_recv() accept a
command that has no receive descriptor, beside the already-reposted case
it tolerates today.  For a command isert allocated the stores write back
what isert_allocate_cmd() already put there; rx_desc is not touched, so a
command that owns a descriptor keeps it.  isert_put_cmd()'s
ISCSI_OP_REJECT arm is already written for a command whose se_cmd was
never set up - it releases one through iscsit_release_cmd() - it was
simply never reached.

The unsolicited NOP-In is the same shape, from iscsit_add_nopin(), and is
kept off iSER by the previous patch.

Filling the back pointers in for a command that did not come through
isert_allocate_cmd() is David Jeffery's idea, from a 2022 series that was
not applied; it did it in isert_put_nopin().

Link: https://lore.kernel.org/all/20220311175713.2344960-2-djeffery@redhat.com/
Fixes: 4366b19ca5eb ("iser-target: Change the recv buffers posting logic")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index efa8d7b7844c97..b7dcfc5f88b916 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -758,7 +758,8 @@ isert_post_recv(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc)
 	struct ib_recv_wr rx_wr;
 	int ret;
 
-	if (!rx_desc->in_use) {
+	/* A command the target core allocated itself has no descriptor. */
+	if (!rx_desc || !rx_desc->in_use) {
 		/*
 		 * if the descriptor is not in-use we already reposted it
 		 * for recv, so just silently return
@@ -1028,6 +1029,18 @@ isert_rx_login_req(struct isert_conn *isert_conn)
 	queue_delayed_work(isert_login_wq, &conn->login_work, 0);
 }
 
+/*
+ * A command the target core allocated itself does not come through
+ * isert_allocate_cmd(), so the tx path has to fill these in.
+ */
+static void
+isert_init_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn,
+	       struct iscsit_cmd *cmd)
+{
+	isert_cmd->conn = isert_conn;
+	isert_cmd->iscsit_cmd = cmd;
+}
+
 static struct iscsit_cmd
 *isert_allocate_cmd(struct iscsit_conn *conn, struct iser_rx_desc *rx_desc)
 {
@@ -1041,8 +1054,7 @@ static struct iscsit_cmd
 		return NULL;
 	}
 	isert_cmd = iscsit_priv_cmd(cmd);
-	isert_cmd->conn = isert_conn;
-	isert_cmd->iscsit_cmd = cmd;
+	isert_init_cmd(isert_cmd, isert_conn, cmd);
 	isert_cmd->rx_desc = rx_desc;
 
 	return cmd;
@@ -2201,6 +2213,8 @@ isert_immediate_queue(struct iscsit_conn *conn, struct iscsit_cmd *cmd, int stat
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	int ret = 0;
 
+	isert_init_cmd(isert_cmd, conn->context, cmd);
+
 	switch (state) {
 	case ISTATE_REMOVE:
 		spin_lock_bh(&conn->cmd_lock);
@@ -2226,6 +2240,8 @@ isert_response_queue(struct iscsit_conn *conn, struct iscsit_cmd *cmd, int state
 	struct isert_conn *isert_conn = conn->context;
 	int ret;
 
+	isert_init_cmd(iscsit_priv_cmd(cmd), isert_conn, cmd);
+
 	switch (state) {
 	case ISTATE_SEND_LOGOUTRSP:
 		ret = isert_put_logout_rsp(cmd, conn);
-- 
2.43.0

