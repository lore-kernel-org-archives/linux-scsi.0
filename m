Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794910518;
	b=4aJMeYOpcvDV/fJLDdcYVsf8wmgBWiCKN9/CBlmKzKysDjk+LJgeDKyOWrnXzEi/vQ6B
	 0KdUkpngYfuk6UDtDk40XxyKXE/Nx9Vtk39K7mU+B/4HTRk2VHdoMs90g8EMzdNrxWTmJ
	 wNfo8VzQFdnOEmMN26skog+cb8D7T989Js5ms/ZRF/RCzkqRUTr0j7HxJY5jL6E5y6V3l
	 QX52wVZJ8hayT8VbKAdDIScXyuQwgixxg2q1oB5tkjWgrNF+sPdck+0iOsdY2lQ0REDI6
	 FXl6K5gLRAhnuYjIK6m2zXaKp6fc4UNXD08/XAXxIf36Z5brITaFPoHw1M9KAqksUhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794910518;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7wgyd+hNV8/Ru7pi5eXli4D6H07KBeBVtWuBNWIAstI=;
	b=0fAExRxHIEjAq5id6m8KixvgC/sx2rPg4GYTFybBY5OVKJ4x6oK/7YvqlE0HhANHXsg0
	 yQxzc+F6kcVg0IfH0vbeJFhIIWMHeUomXqhp/w5mp+50oJ9VFNrtmrAFGp/BhjC2tMvtR
	 DeZcm79htlVuHwwEzB0+KHtSmzPCmdoB1MHh/5ZvIVng32zgCr6ZEyAZk3SGmjZFyEX2S
	 hy+HrHy0X7qYlaBckDTkcvqwY6cjZRBDPQLHZMj/vi3OhAVRY+dAsO9DSGaGgfxnS2y6b
	 0FuQLVBNFfyqfwmq2E4Jn+QOZVy8nrQGKKyjG/B3vYbRS9xRDXkW8oC45LXQlUmHjmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="He/K37Zm";
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A23606A8A0
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 10:15:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04A23606A8A0
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=He/K37Zm
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1a8cc11ac42so4675470c88.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 02:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794910517; x=1795515317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7wgyd+hNV8/Ru7pi5eXli4D6H07KBeBVtWuBNWIAstI=;
        b=He/K37Zmxavx0WKbUUUimGoftnGvaqp0w52aKHeF/VlkURFIkjPMbNsJg2HQhT/2uv
         7Ev8Th8wYoH/KOnS0wowehqImMSp2Fa01yxaSZMr2TooJajf6uu790GyZ4IcSOwQSMTM
         3dtFIqs8UehB2vQhOY/fjvp+TvYHzZjiU4vlIyV9VYttXNJrbAN9Q4c0r94hFgihk9X+
         niWRfyHHBff7XrxvSbuplWknen1IUyLo3ZxlI0MM9XNNTi+4HaP1SQXF7Sb5AhSHokPj
         F/6n3sgG5wvU97xLo1m9rGeVK6q6+CsUiMJ0TwMNlKTlYeKP4pZFQWVqn77KgU3n8tU0
         eavw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794910517; x=1795515317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7wgyd+hNV8/Ru7pi5eXli4D6H07KBeBVtWuBNWIAstI=;
        b=Lgh/vcQhM2rGJ8MiGF5UkcdrroQsrJwsK/clevrDUlG9YC3t7lVg3BnaJ2KDaqc3Xf
         LkB2YbZVBxFbltz1Iyg0hzuxjiccwsN4qfTxRCc7cgkIizKyIRpCQJEdwRG5ECNM2vXj
         jWRqW101rhqwC+MJp9cV+H9qDZB+KiK0S/trcDRkYCGoteZfNWoMmCLlvKwjOSrHGPez
         yO8F+5UiM+b20GvpgzW6YpoyTpPCIVJI8IF9MRu2gu1zaPSYTzZIVD9Y62iNnGW46crG
         IU15SnP3oREVcRNtiHpDo11NIwGW+Gq70BtsNHWs6DArLd6JYAzeXlG1stpoD+qfzCl/
         Q1tg==
X-Gm-Message-State: APuU4Z/cm+s6KVJCTgNMUge9ZP9/0sxOrlp2lzF+thQ6Ywp5uxIVAf91
	6lD5qMfUkfovjig/l6spDUA4o0xm10+p4w76y5d7/Wgcj+bYHfBViANNLGwnrmwN3m0=
X-Gm-Gg: AYBFou1cCZER2rK41674upANUfVlBIVcGiGX8a1MIG75O593y9mCTDPY29VC1zjKruu
	Z1YaOkBpUB4k37h71n52glXREvEhIq3psojGzvnbaqIWk4STM/US2kro2B2ddYP59b6CZ4KO9Gk
	FoDxnHPVgkMxhGQ45kDr2cJWnRIDKuvyIDxrM5Hjhacj22jE3mFuYCqVrEI9P6H+A8xVduglCUS
	T9FzoXUn/bM0DtLUO93v5beJnd0A1o9BIPl7sqy/JMEkerP1Lw8BvWtF0pW7LuPc6rK7njBQm5L
	n4Dld8EzpwG8UhWbNZpK2OIaUHrdRe2p3snMKvz7XmSZBNOYWhMveKaSL19+5mDnp1iXiH9q87k
	XGq/MH8kMTGSvyu+TrdYC8Ohvl82zxuOsHOmLuMgLr7vftMP0GiQv1b0qlTa4a7qnNTHTWpzbrf
	sHAzO0LWwHWYAfqfLrAw4XlbC8l4+awmlavnQm3l9up4F1MFaZo04JdLROQZcVMtwqWO+II2vP/
	zFHwvK1DFBNTfrf1NkVj5eIPiHdLI8V2D9A8REwZArF4cCldmHkLsCpx3zFrdL2VC05ZsBHh5HP
	oFOxlhZFfbFCiN0MWFJ4a3Fi469tJAVmhZ8oiG8aNz4xNH1KVQ3Z/0shmPgL4wMSBcCtorCOHse
	Z48FGUIibHgEnsVTzWYX9gFiurrY235LcBiDAIA==
X-Received: by 2002:a05:701b:2044:10b0:15b:7f7a:730d with SMTP id a92af1059eb24-1b5031152c3mr13257022c88.28.1794910516865;
        Tue, 17 Nov 2026 02:15:16 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:cd44:de10:449c:756c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50316e008sm39965539c88.6.2026.11.17.02.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 02:15:16 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/4] scsi: libiscsi: take a transmit reference before a task is published
Date: Tue, 17 Nov 2026 19:14:59 +0900
Message-ID: <20261117101500.1894608-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117101500.1894608-1-yhlee@isslab.korea.ac.kr>
References: <20261117101500.1894608-1-yhlee@isslab.korea.ac.kr>
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

A task becomes visible to the receive path when its state is stored as
ISCSI_TASK_RUNNING, and the receive path completes it under back_lock
while the transmit path works under frwd_lock.  The transmit path
publishes that state before it owns a reference of its own:

 - iscsi_prep_mgmt_task() and iscsi_prep_scsi_cmd_pdu() store the state
   and the reference is only taken later, in iscsi_xmit_task().  A
   response that lands in between drops the only reference, so the slot
   is back in the pool by the time iscsi_get_task() runs, which then
   warns and drops the PDU.

 - a transport without an xmit workqueue does not call iscsi_xmit_task()
   at all.  iscsi_send_mgmt_task() and iscsi_queuecommand() call
   session->tt->xmit_task() holding only the allocation reference, so
   the slot can be freed and handed out again while the transport is
   still sending from it, and the error path then puts a reference it no
   longer owns.  ihost->workq only exists when iscsi_host_alloc() is
   called with xmit_can_sleep set, which iscsi_tcp and cxgbi do and
   iser, bnx2i, qedi, be2iscsi and qla4xxx do not.

For a SCSI command there is no point publishing the state at all,
because iscsi_itt_to_ctask() does not read it: a task is reachable
through session->cmds[] as soon as iscsi_alloc_task() fills it in, so a
target that answers an ITT it has not been given yet reaches
iscsi_scsi_cmd_rsp() for a command that is still sitting on
conn->cmdqueue in ISCSI_TASK_PENDING.  That drops the only reference,
which returns the pool slot and calls scsi_done() with whatever the
buffer held, and leaves the task on the queue; iscsi_data_xmit() then
builds a PDU from a task whose ->sc has been cleared.

So: take the transmit reference before the state is stored, in
iscsi_xmit_task() and in the two callers that send a task themselves;
make the SCSI lookup skip a task that has not been sent; and finish
with a failed send inside the same back_lock section that tests for it.

That lookup has to refuse ISCSI_TASK_FREE as well as ISCSI_TASK_PENDING.
iscsi_alloc_task() stores the state before ->sc, and under frwd_lock,
while the FREE the slot's last life ended with was stored under the
back_lock the lookup holds.  So the one thing the receive path can see
out of order is the new ->sc together with that FREE; both values mean
the same thing, and a slot that really is free has a NULL ->sc, which
the line above already rejects.

Two choices in there are not arbitrary.  The SCSI lookup rejects the
two states that mean "not sent yet" rather than everything that is not
ISCSI_TASK_RUNNING, because iscsi_eh_abort() deliberately leaves the
receive side running after a successful abort TMF and says so, and
because iscsi_tcp_r2t_rsp() looks a task up in order to see that it has
already been completed and ignore the R2T, instead of failing the
connection.  And iscsi_send_mgmt_task(), whose caller frees the task,
parks a failed send in ISCSI_TASK_COMPLETED rather than
ISCSI_TASK_PENDING, because bnx2i_cleanup_task() and qedi_cleanup_task()
read ISCSI_TASK_PENDING as "never sent to us" and skip their cleanup,
and both of those are no-workqueue transports.

All three were reproduced with test-only delays that hold each window
open, in a QEMU guest with KASAN against a userspace target reached
through a proxy that can inject a PDU of its own, and on iSER over
soft-RoCE against an in-guest LIO target.  Every cell is a fresh boot
and each arm was measured five times, with any cell where the window
closed before the response had been processed counted separately.

For the SCSI window the proxy sends a SCSI Response naming a pool index
it has never seen go out, while the command is still on conn->cmdqueue.
Without this patch the slot went back to the pool inside the window in
5 of 5 attempts and the read returned success on a buffer nobody had
written; with it, 0 of 5, because iscsi_itt_to_ctask() refuses the
response and the connection is dropped with ISCSI_ERR_BAD_ITT, which is
what the driver already does with every other unusable ITT.  What the
transmit thread does next with the slot it has lost:

[   14.300338] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
[   14.302897] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[   14.303981] CPU: 3 UID: 0 PID: 52 Comm: kworker/u16:2 Not tainted 7.4.0-rc2-00473-g7baa29cbc558-dirty #2 PREEMPT(lazy)
[   14.305403] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   14.306889] Workqueue: iscsi_q_2 iscsi_xmitworker
[   14.307549] RIP: 0010:iscsi_prep_scsi_cmd_pdu+0x2ef/0x2220
[   14.308284] Code: b6 04 02 40 38 f0 7f 08 84 c0 0f 85 c5 0f 00 00 4c 89 e1 41 c6 43 01 01 49 8d 53 08 48 b8 00 00 00 00 00 fc ff df 48 c1 e9 03 <80> 3c 01 00 0f 85 09 17 00 00 48 b9 00 00 00 00 00 fc ff df 49 8b
[   14.310690] RSP: 0018:ffffc90000397b18 EFLAGS: 00010246
[   14.311388] RAX: dffffc0000000000 RBX: ffff88800cfc1800 RCX: 0000000000000000
[   14.312326] RDX: ffff88800cfc1900 RSI: 0000000000000001 RDI: ffff88800cfc1808
[   14.313265] RBP: ffff88800ce40378 R08: 0000000000000001 R09: ffff88800cfc18f8
[   14.314202] R10: 0000000000000000 R11: ffff88800cfc18f8 R12: 0000000000000000
[   14.315139] R13: ffff88800ce42440 R14: ffff88800cfc1858 R15: ffff88800ce40388
[   14.316077] FS:  0000000000000000(0000) GS:ffff8880e5728000(0000) knlGS:0000000000000000
[   14.317135] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   14.317904] CR2: 00000000005a46e2 CR3: 0000000005672006 CR4: 0000000000770ef0
[   14.318844] PKRU: 55555554
[   14.319217] Call Trace:
[   14.319564]  <TASK>
[   14.319872]  iscsi_xmitworker+0x56b/0xf20
[   14.320417]  process_one_work+0x697/0x1060
[   14.320979]  ? __pfx___schedule+0x10/0x10
[   14.321522]  ? __pfx_process_one_work+0x10/0x10
[   14.322136]  ? _raw_spin_lock_irq+0x81/0xe0
[   14.322699]  ? __pfx_iscsi_xmitworker+0x10/0x10
[   14.323313]  ? assign_work+0x11d/0x370
[   14.323830]  worker_thread+0x45b/0xd10
[   14.324341]  ? __pfx_worker_thread+0x10/0x10
[   14.324923]  kthread+0x2c8/0x3b0
[   14.325369]  ? recalc_sigpending+0x15c/0x1e0
[   14.325953]  ? __pfx_kthread+0x10/0x10
[   14.326461]  ret_from_fork+0x36e/0x5a0
[   14.326979]  ? __pfx_ret_from_fork+0x10/0x10
[   14.327556]  ? __switch_to+0x572/0xdc0
[   14.328073]  ? __pfx_kthread+0x10/0x10
[   14.328582]  ret_from_fork_asm+0x1a/0x30
[   14.329119]  </TASK>
[   14.329429] Modules linked in:
[   14.329880] ---[ end trace 0000000000000000 ]---

For the state publication, a NOP-Out answered by the target inside the
window, the slot went back to the pool in 5 of 5 attempts without this
patch and in none of the attempts with it, and the xmit worker hit this
on the iscsi_get_task() that then fails:

  WARNING: drivers/scsi/libiscsi.c:1598 at iscsi_xmit_task+0x6e0/0x920

For the no-workqueue path the
reference was put twice in 5 of 5 attempts without the patch and 0 of 5
with it, as "refcount_t: underflow; use-after-free." from
iscsi_send_nopout().

Baseline behaviour is unchanged: discovery, login, write, read-back
compare, a 1 MiB O_DIRECT read, NOP pings and logout pass on iscsi_tcp
and on iSER, and so does an abort TMF driven by swallowing a response -
the path that leaves a task in ISCSI_TASK_ABRT_TMF with the receive
side still up.  cxgbi, bnx2i, qedi, be2iscsi and qla4xxx need vendor
hardware and were not run; their paths were followed in the source
only.

Fixes: 659743b02c41 ("[SCSI] libiscsi: Reduce locking contention in fast path")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/libiscsi.c | 49 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 220e89d541af68..af454454c08699 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -429,8 +429,6 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	if (session->tt->init_task && session->tt->init_task(task))
 		return -EIO;
 
-	/* Pairs with the acquire in the RX task lookups. */
-	smp_store_release(&task->state, ISCSI_TASK_RUNNING);
 	session->cmdsn++;
 
 	conn->scsicmd_pdus_cnt++;
@@ -703,8 +701,6 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	if ((hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT)
 		session->state = ISCSI_STATE_LOGGING_OUT;
 
-	/* Pairs with the acquire in the RX task lookups. */
-	smp_store_release(&task->state, ISCSI_TASK_RUNNING);
 	ISCSI_DBG_SESSION(session, "mgmtpdu [op 0x%x hdr->itt 0x%x "
 			  "datalen %d]\n", hdr->opcode & ISCSI_OPCODE_MASK,
 			  hdr->itt, task->data_count);
@@ -829,7 +825,20 @@ static int iscsi_send_mgmt_task(struct iscsi_task *task)
 		if (rc)
 			return rc;
 
+		iscsi_get_task(task);
+		/* Pairs with the acquire in the RX task lookups. */
+		smp_store_release(&task->state, ISCSI_TASK_RUNNING);
 		rc = session->tt->xmit_task(task);
+		/* regular RX path uses back_lock */
+		spin_lock_bh(&session->back_lock);
+		/* The RX path completing the task is also a successful send. */
+		if (rc && task->state != ISCSI_TASK_RUNNING)
+			rc = 0;
+		else if (rc)
+			/* Keep the RX path off it; the caller still owns the ref. */
+			task->state = ISCSI_TASK_COMPLETED;
+		__iscsi_put_task(session, task);
+		spin_unlock_bh(&session->back_lock);
 		if (rc)
 			return rc;
 	} else {
@@ -1176,7 +1185,7 @@ static int iscsi_handle_reject(struct iscsi_session *session,
 			if (!iscsi_verify_itt(conn, rejected_pdu.itt))
 				task = iscsi_itt_to_task(session, conn,
 							 rejected_pdu.itt);
-			/* Pairs with the release when the task is prepared. */
+			/* Pairs with the release in the transmit path. */
 			/* A reserved ITT means the transport owns the task. */
 			if (!task || smp_load_acquire(&task->state) != ISCSI_TASK_RUNNING ||
 			    task->sc || task->hdr->itt == RESERVED_ITT) {
@@ -1318,7 +1327,7 @@ int __iscsi_complete_pdu(struct iscsi_session *session, struct iscsi_conn *conn,
 	case ISCSI_OP_SCSI_TMFUNC_RSP:
 	case ISCSI_OP_NOOP_IN:
 		task = iscsi_itt_to_task(session, conn, hdr->itt);
-		/* Pairs with the release when the task is prepared. */
+		/* Pairs with the release in the transmit path. */
 		/* A reserved ITT means the transport owns the task. */
 		if (!task || smp_load_acquire(&task->state) != ISCSI_TASK_RUNNING ||
 		    task->sc || task->hdr->itt == RESERVED_ITT)
@@ -1447,6 +1456,7 @@ struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_session *session,
 	__must_hold(&session->back_lock)
 {
 	struct iscsi_task *task;
+	int state;
 
 	if (iscsi_verify_itt(conn, itt))
 		return NULL;
@@ -1455,6 +1465,11 @@ struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_session *session,
 	if (!task || !task->sc)
 		return NULL;
 
+	/* Pairs with the transmit path's release; a new slot is FREE too. */
+	state = smp_load_acquire(&task->state);
+	if (state == ISCSI_TASK_PENDING || state == ISCSI_TASK_FREE)
+		return NULL;
+
 	if (iscsi_cmd(task->sc)->age != session->age) {
 		iscsi_session_printk(KERN_ERR, session,
 				  "task's session age %d, expected %d\n",
@@ -1556,6 +1571,9 @@ static int iscsi_xmit_task(struct iscsi_session *session, struct iscsi_conn *con
 			WARN_ON_ONCE(1);
 			return 0;
 		}
+		if (!was_requeue)
+			/* Pairs with the acquire in the RX task lookups. */
+			smp_store_release(&task->state, ISCSI_TASK_RUNNING);
 	} else {
 		/* Already have a ref from when we failed to send it last call */
 		conn->task = NULL;
@@ -1892,10 +1910,25 @@ enum scsi_qc_status iscsi_queuecommand(struct Scsi_Host *host,
 				goto prepd_fault;
 			}
 		}
-		if (session->tt->xmit_task(task)) {
+		iscsi_get_task(task);
+		/* Pairs with the acquire in the RX task lookups. */
+		smp_store_release(&task->state, ISCSI_TASK_RUNNING);
+		reason = session->tt->xmit_task(task);
+		/* regular RX path uses back_lock */
+		spin_lock_bh(&session->back_lock);
+		/* The RX path completing the task is also a successful send. */
+		if (reason && task->state != ISCSI_TASK_RUNNING)
+			reason = 0;
+		else if (reason)
+			/* Give the command back inside the lock, not after it. */
+			iscsi_complete_task(session, task,
+					    ISCSI_TASK_REQUEUE_SCSIQ);
+		__iscsi_put_task(session, task);
+		spin_unlock_bh(&session->back_lock);
+		if (reason) {
 			session->cmdsn--;
 			reason = FAILURE_SESSION_NOT_READY;
-			goto prepd_reject;
+			goto reject;
 		}
 	} else {
 		list_add_tail(&task->running, &conn->cmdqueue);
-- 
2.43.0

