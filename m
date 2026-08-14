Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EB622A7F6
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 01:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786669483; cv=none; b=rJCFY4eblO1WxNCopSeRKXF1qbDH8ssMsFIjFgxedlHjcnJTx2cxlAi9G9kei4SUmZYCNxCjNezl1XPEfz5GLZ7uYG18UV4Qan8vncc+QeI7jcLUSid/PPr5ArWu/DrQoTFf0amWx2TxQ5xMCvDPSWmy4dk1l892luI7P6l1uME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786669483; c=relaxed/simple;
	bh=V/3xDLaLwzdcZXn34oe0haRIUfaWGJH4BHB3KlOPQcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IGPqpg1Ya3xcwQpf5O7ViMu38CxDboPvp10BYeyHoGdGTWizkhc4MP6TJdCmPCHB6R4huGJR4fuWnlrOX1pExb7CnjT6ux6IVktobFXcKzpNEv/GkjW2s5JQUwJa3mZsR3tMeZ/7jPZBnzhDllmw3FatRSetRJiC4Q9fRvVOO7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=LGoWIOb8; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="LGoWIOb8"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-848643382fcso373362b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 18:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1786669480; x=1787274280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nrgIXEbocHkKTuRcGdQKDKsU+CB1qUGYqJ6bTE9/jVI=;
        b=LGoWIOb8uT663IvVloOHzYxJOIt/ybVb6vrLZV3PmM9c7l4DQUlAietfh7CDCONHRR
         kh1R1gvJivD9wVaHFltAGNrC3y50T/HKuoeX7hpIH5d9qeuvvkF6E7PsM6eByzZbP91a
         RhPlkrzP5wzxHKzDyw8KNCi9GVnKMwLuzVAi8qLOnWyrk9XD+67eh9vxLvsdcNT925sp
         FihBGsIFiQ4FI0OJ6e5P9omop/m7RRd/hHhPQmWkcXwHjRa3OlHN46/6e1dIoF6WBsYW
         oAz4tq+FYvKeGLEqUD8knH7MbFnbh5OO1bLBm+xZJ738b7SOFpxMaSHXqdz97ghHwUHG
         wKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786669480; x=1787274280;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nrgIXEbocHkKTuRcGdQKDKsU+CB1qUGYqJ6bTE9/jVI=;
        b=dEHdBtMh4nYq/44dsgqwLWuueDY7kyo/C9h1uPR+GcH5L8ET6lDJrfUGBBl/sgZREY
         frrGbAj6dwvbXSm2AsdSdr5b5nj2g851O6DKkn0Em71Ec36KQsPd05UCHehtH0on6ivE
         7OHZKQCNXiArpHm7PPgd07+4km9H9dlmnFf3W7XQVrw4y5Z77lxU267znVz88v02ijm6
         CWE8S+Dlg8NFHf0bS76cqNBrr3gxhoU854Q6HCljDCxEp7GM/yEIh9YE73lGfxdlImN/
         9YHxeRX1XwTCnR6cFBGMA0tvYoKVuOGBSc3b2GUPFb2eToV4FkYZNbUtkt+vnkSllxlb
         0Zlw==
X-Forwarded-Encrypted: i=1; AHgh+Rp0P4NrkQIqj6vUIe0l1wTGN/T4ePWLRg1T/lQrIbeiiq2Vkco8YvgozB+if8xdhmumc1jpnO+JEh6k@vger.kernel.org
X-Gm-Message-State: AOJu0YzppYbPO/NKjVi27wMeuJ5Gtud/V4LMojEhQRR5taTyeTQqQiRN
	12QWrh93GkPaYdKO90MRXyaGOOfK12JXRR9Tw0egkNSVp7RRmjirBcwa8810jykmSNk=
X-Gm-Gg: AR+sD11V/w/0sAHKgBx9H33uaT1voBfwg2E7sj/idjH53j7gDNuvnsdSsu/mOeJvc3y
	H9s9X+Avb0ltSZ15TGIGSOE1cU5ch/rbNzIijGymf1HXofIvv56LclLnp3N+VYTCw5qk+3kGI8z
	8SR4+bETvROISD85GKGQBA6AkBuMVlSjf234SwSZV413fk7kh1o+p1IOLrQnZRu0EF15AAq5iVF
	b0qfUKsZIUY5gfmDEoV8Zvhaa6liqAon+uwP7Z9Hioo7BPqK+axjTPm9iHp+GZeoNrUA7/lBJQe
	cUbFVCbA/cfUwX3czkHlugBmUs1zeUtw5IjiRvD4WVKQAOohhpazctMqJtdKftz9sU8mUGtpu/F
	3s32TM9mmYO8i6NcEcmjqJyh5yG84DTbYQC9gKbuOUMfW5sPirZiJgn5XaDXHkmNRXwxkhYKCmW
	fGhBellIfHA/WELPbDpJB23rWCYviAGL8dpj0+2NRtK0nvFozQNaqy4vKkhUjL6PpC5UTa
X-Received: by 2002:a05:6a00:92a7:b0:848:8445:695d with SMTP id d2e1a72fcca58-84fde32aedfmr2025720b3a.27.1786669479682;
        Thu, 13 Aug 2026 18:04:39 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84fc5a7d57esm1474044b3a.55.2026.08.13.18.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 18:04:39 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: check that the tag map is still there in scsi_host_find_tag()
Date: Fri, 14 Aug 2026 10:04:22 +0900
Message-ID: <20260814010423.205976-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

scsi_host_find_tag() bounds the hardware queue index against
tag_set.nr_hw_queues and then dereferences tag_set.tags[hwq].
blk_mq_free_tag_set() clears the tags - __blk_mq_free_map_and_rqs()
sets each tags[i] to NULL and the array itself is freed afterwards -
but it never reduces nr_hw_queues, so the bound still passes and the
dereference is on NULL.

A driver that looks a tag up while its host is being removed therefore
faults.  ib_srp does: srp_remove_target() calls scsi_remove_host()
before it disconnects the target and destroys the queue pair, so an
SRP_RSP the initiator did not ask for reaches srp_process_rsp() after
the tag map is gone.

  [    8.800679] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
  [    8.802155] KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
  [    8.803134] CPU: 1 UID: 0 PID: 31 Comm: kworker/u8:1 Not tainted 7.2.0-rc5-PRIST2B-gf5098b6bae76-dirty #21 PREEMPT(lazy)
  [    8.804503] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  [    8.805965] Workqueue: rxe_wq do_work
  [    8.806548] RIP: 0010:srp_recv_done+0x618/0x1aa0
  [    8.807184] Code: c1 e8 03 41 80 3c 30 00 0f 85 20 10 00 00 48 8b b0 38 01 00 00 48 8d 14 d6 48 be 00 00 00 00 00 fc ff df 48 89 d7 48 c1 ef 03 <80> 3c 37 00 0f 85 bb 0f 00 00 48 be 00 00 00 00 00 fc ff df 48 8b
  [    8.807759] ib_srpt DIAG2B: RDMA_CM_EVENT_DISCONNECTED posts=2693 ok=2689 flush=0 other=0
  [    8.809474] RSP: 0018:ffff88811b108d10 EFLAGS: 00010202
  [    8.809481] RAX: ffff888106098000 RBX: ffff88810603a180 RCX: 0000000000010006
  [    8.809484] RDX: 0000000000000008 RSI: dffffc0000000000 RDI: 0000000000000001
  [    8.809488] RBP: ffff888103baf360 R08: 1ffff11020c13027 R09: ffff888107598008
  [    8.809491] R10: ffff888106036048 R11: ffff888107598000 R12: ffff88810485c000
  [    8.809494] R13: ffff88810603a1ec R14: ffff8881060988a8 R15: 0000000000000006
  [    8.810670] ib_srpt DIAG2B: replay stopped posts=2693 ok=2689 flush=0 other=0
  [    8.811241] FS:  0000000000000000(0000) GS:ffff8881673a5000(0000) knlGS:0000000000000000
  [    8.811250] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [    8.812342] ib_srpt receiving failed for ioctx 0000000023edb106 with status 5
  [    8.813141] CR2: 000000000fcc7151 CR3: 0000000102313001 CR4: 0000000000770ef0
  [    8.813153] PKRU: 55555554
  [    8.813155] Call Trace:
  [    8.813159]  <IRQ>
  [    8.813163]  ? net_rx_action+0x349/0xfb0
  [    8.814224] ib_srpt receiving failed for ioctx 000000005729ebde with status 5
  [    8.815119]  ? __pfx_srp_recv_done+0x10/0x10
  [    8.815153]  ? rxe_poll_cq+0x253/0x3d0
  [    8.815161]  ? enqueue_task_fair+0x70f/0x2b60
  [    8.816188] ib_srpt receiving failed for ioctx 00000000a48ac180 with status 5
  [    8.816997]  __ib_process_cq+0xe1/0x390
  [    8.818042] ib_srpt receiving failed for ioctx 00000000e493e48a with status 5
  [    8.818769]  ib_poll_handler+0x6e/0x200
  [    8.819685] ib_srpt receiving failed for ioctx 00000000596851d8 with status 5
  [    8.820594]  irq_poll_softirq+0x1df/0x480
  [    8.820968] ib_srpt receiving failed for ioctx 00000000acb38618 with status 5
  [    8.821300]  ? __pfx_irq_poll_softirq+0x10/0x10
  [    8.821582] ib_srpt receiving failed for ioctx 00000000d2f29888 with status 5
  [    8.822094]  ? __pfx_sched_ttwu_pending+0x10/0x10
  [    8.823079] ib_srpt receiving failed for ioctx 00000000cd218270 with status 5
  [    8.823632]  handle_softirqs+0x18e/0x590
  [    8.824134] ib_srpt receiving failed for ioctx 00000000c49ed88c with status 5
  [    8.824694]  ? __pfx_handle_softirqs+0x10/0x10
  [    8.825607] ib_srpt receiving failed for ioctx 000000004d7feb6d with status 5
  [    8.826105]  do_softirq+0x3b/0x60
  [    8.826110]  </IRQ>
  [    8.827053] ib_srpt DIAG2B: RDMA_CM_EVENT_DISCONNECTED posts=2693 ok=2689 flush=0 other=0
  [    8.827515]  <TASK>
  [    8.838045]  __local_bh_enable_ip+0x61/0x70
  [    8.838594]  __alloc_skb+0x732/0x890
  [    8.839093]  ? _raw_spin_lock_irqsave+0x85/0xe0
  [    8.839790]  ? __pfx___alloc_skb+0x10/0x10
  [    8.840341]  ? _raw_read_unlock_irqrestore+0x16/0x50
  [    8.841007]  rxe_init_packet+0x16b/0x4f0
  [    8.841544]  prepare_ack_packet+0xb8/0x830
  [    8.842088]  rxe_receiver+0x499/0x9980
  [    8.842590]  ? __pfx_rxe_receiver+0x10/0x10
  [    8.843140]  ? rxe_completer+0x29e5/0x38c0
  [    8.843679]  ? pick_task_fair+0xbfc/0x19b0
  [    8.844226]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
  [    8.844884]  ? __pfx_rxe_receiver+0x10/0x10
  [    8.845440]  do_work+0x144/0x470
  [    8.845875]  process_one_work+0x633/0x1030
  [    8.846447]  ? assign_work+0x11d/0x370
  [    8.846972]  worker_thread+0x45b/0xd10
  [    8.847521]  ? __pfx_worker_thread+0x10/0x10
  [    8.848126]  kthread+0x2c6/0x3b0
  [    8.848592]  ? recalc_sigpending+0x15c/0x1e0
  [    8.849213]  ? __pfx_kthread+0x10/0x10
  [    8.849737]  ret_from_fork+0x36e/0x5a0
  [    8.850289]  ? __pfx_ret_from_fork+0x10/0x10
  [    8.850884]  ? __switch_to+0x572/0xdd0
  [    8.851430]  ? __pfx_kthread+0x10/0x10
  [    8.851962]  ret_from_fork_asm+0x1a/0x30
  [    8.852548]  </TASK>
  [    8.852872] Modules linked in: ib_srpt
  [    8.853455] ---[ end trace 0000000000000000 ]---

blk_mq_tagset_busy_iter() reads the same array and tests both the array
and the element before using them.  Do the same here.  Its SRCU section
covers the tags being freed; the tests cover them being cleared, which
is what faults above.

Fixes: 1ee8e889d946 ("scsi: add support for multiple hardware queues in scsi_(host_)find_tag")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
Measured over rxe with KASAN, with an SRP target that reposts an SRP_RSP
for a command it has already answered while I/O runs and the target is
deleted through sysfs: the report above appeared in 5 of 5 runs without
this patch and in none of 3 with it, on 7.2-rc5 with no other change.  A
conforming target is unaffected - the same 3 runs show no aborts and no
error completions, matching an unpatched kernel.
 include/scsi/scsi_tcq.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index ea7848e74d257..d62bae05d4e7d 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -29,7 +29,8 @@ static inline struct scsi_cmnd *scsi_host_find_tag(struct Scsi_Host *shost,
 		return NULL;
 
 	hwq = blk_mq_unique_tag_to_hwq(tag);
-	if (hwq < shost->tag_set.nr_hw_queues) {
+	if (hwq < shost->tag_set.nr_hw_queues && shost->tag_set.tags &&
+	    shost->tag_set.tags[hwq]) {
 		req = blk_mq_tag_to_rq(shost->tag_set.tags[hwq],
 					blk_mq_unique_tag_to_tag(tag));
 	}
-- 
2.43.0

