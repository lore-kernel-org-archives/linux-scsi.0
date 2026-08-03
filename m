Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FD1366055
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 10:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785753728; cv=none; b=CLkGgB+qvk2ZT7wG4htbBJ0PIs3c7T97icbqIcYSM5W7fiYhahxiTBZwSOicMJv/3aUFOvwqG7fKuZRn6OZUZVjyOMeb4ox1ptBtdj81KBPZTjt7+EUK5r58tyOLjr9fjrIkWn6xuEzvNsNHiwchcKlz736qR25lgh9HSh8xQQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785753728; c=relaxed/simple;
	bh=zhsvf8AUhSm/vPJMbWw29S95YWwHL0kAWxVcONvzQMg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eT0GbO8IbIB2Efu4kt98seArAX5C9D6Wk0hft2hKXgWbOqrtIphNfN/VGdhrolCjmchvxI4Fu1YA4g24tHY53XsFFO3yVQgRE46RvYAeqPBHc0f+G72YwlKFjXbkoWMCdSTLmNJu+uD97qAkP/uSAQ+mW6WOmKrpRRl4tbW0tnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=R8mjUVgg; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="R8mjUVgg"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8486ac3f347so3963327b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2026 03:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785753725; x=1786358525; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rcsAVzU3hfKQ9Mjr4UzblWsJSQEWKcZUw54vAPfxOFA=;
        b=R8mjUVggTgjHSdquSxKHxQfyPM867hm03H2eTRHGsZfXZnyctDUoRqsS3LDE7e3XxZ
         FfPkiFoJo54vJP0BUABBC/STcObfOM2cFj8hC+mo9ApGEOh58yV5CztzbYjpuva6VsF/
         sleM/qAYZafOT6rW5Pc2QWq35pKeHgEVC/4AA6Ri4CfkF8WGRSk/FiypaKXfPXH4SWV/
         X1iOr8EIHDuXbZjmOGIhYmu/cK9YIp7QtZeTOwmFI6dFD9YHQsnpIg9bLYrVuRTG+ERd
         o/LP4GihNGF2VRWcU7G666rxU6+3U7AEPtih5pgRe8/1a9Eeu3wTdJbhjhx7mJ0wCf95
         nEFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785753725; x=1786358525;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rcsAVzU3hfKQ9Mjr4UzblWsJSQEWKcZUw54vAPfxOFA=;
        b=RrNPvJ+1SO2twtU0/IIE5CIIoVuAs0ozgDO7xM0MPA/RJzrR3RmfiGeZn1Q438e/Mw
         fxnE5vaLE8I9LDqCPrXascccNIRgaUBvaONIq8tr3LhZeeDuwCVQ7Kjy9reH6Sv2JLRR
         L1KSu0RU4PT4mJTx3FswhF1wQfEGGWlDadAfuL4c61tVKpbJbfcAGECOziN9deF0l611
         a+3I2j77GNNPBpooDH7emfjgOJQ9vqJocizTbIjBV2dB8zIewu5SSCci1OP53gW0cZ5s
         hQUx6yhwgz1cXRp/kgtvBmeOi5DsDqj1QyFSH5BcA9zhQJbHDA524gwqNS2EJqQYvAlZ
         mk8Q==
X-Forwarded-Encrypted: i=1; AHgh+Rpql+3fV31UYR3uSuiT0LdByl4GUUAe2oSNmy28wG31fvWfzr2uEZwHm1QgtvHwKp7NXjJIGJZ3cVuy@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6R6Lt1YnqTao2s0gXkC4qc3yD4POTw2MtP14jtti/qRECfB4e
	4heNVrCrbM7TlYv8p26CHDgSEpiJ9WrhEIjYtz3CspUI9ZAN3vJ5ryfR9crlRfZKJQw=
X-Gm-Gg: AR+sD12WZF3JFAuGhF7LS5GFpvZBWp/l8SJgFYXjPgUJXjjl0EvVf0nyAuyttJODueP
	pfd2d52xEVig4kywy9QUUpmR1jyXMDoMgIYv8gEHkAfBN3DELN3fKO6yxuhO5YXuXwrwx0INN46
	LVy2TMuzZz8nfI3g594FYqv+XMWzqaZLGtTZSFSg5nBXC+s08o76Otx16C1H0ewE9Zle1WGmFQw
	dLDaDeoD5XDmW0j2X+nvp3J4rmMiClfxdbe6MOnBMqSeJbsO9e1bj0ZltR9r7IRxRkPJ1EIukyn
	fYFKXVGHhJ095pNpk+BpqxklCCsTDNQOKEGWi0OF2qTA5q49AzKKhk8MBDYFR1s5l6SNxWmOkz3
	LEHZFwZf7HniuWvukQ/HO1ib7PC4xkn053C1GoZipUKaNKeWC4alhwpnq7dJ3WPtznQLLS42w7R
	/XIJjAOKaMLY1S3PXP1EjZxxv4rg5q7qPMr9/Ng+jq4G2zopiBctOgqEUxouV4l6G1kw7B
X-Received: by 2002:aa7:888b:0:b0:846:a04:acdc with SMTP id d2e1a72fcca58-84ed74bde0amr10673990b3a.26.1785753724933;
        Mon, 03 Aug 2026 03:42:04 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edbe791dfsm3596878b3a.23.2026.08.03.03.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 03:42:04 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org,
	James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH] scsi: libiscsi: validate the ITT reflected in a Reject PDU
Date: Mon,  3 Aug 2026 19:41:48 +0900
Message-ID: <20260803104149.2114414-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A Reject PDU carries a copy of the header it rejects, and
iscsi_handle_reject() takes the ITT out of that copy to find the task to
clean up:

      memcpy(&rejected_pdu, data, sizeof(struct iscsi_hdr));
      ...
      task = iscsi_itt_to_task(conn, rejected_pdu.itt);

That value is whatever the target put there. iscsi_itt_to_task() bounds
the index against cmds_max and checks nothing else, so any task in the
pool can be named, and iscsi_nop_out_rsp() then completes it.

An index that has never been used gives a NULL task->conn: the pool is
zeroed at session setup and conn is assigned only when a task is
allocated. If the task was used and returned, iscsi_complete_task()
hits its WARN_ON_ONCE(task->state == ISCSI_TASK_FREE) and the refcount
underflows. An in-flight SCSI command is completed as successful - a
1 MiB read returned 1048576 with none of its buffer written and no
warning.

Validate the reflected ITT the way iscsi_itt_to_ctask() validates a
command ITT, and require the task to be in flight and not a SCSI
command.

[    6.248477] Oops: general protection fault, probably for non-canonical address 0xdffffc000000000c: 0000 [#1] SMP KASAN NOPTI
[    6.249357] KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
[    6.249951] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted 7.2.0-rc5-ISCSI1-gf5098b6bae76 #1 PREEMPT(lazy)
[    6.250718] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    6.251616] RIP: 0010:iscsi_nop_out_rsp.constprop.0+0x46/0x160
[    6.252043] Code: c1 ea 03 48 83 ec 08 80 3c 02 00 0f 85 f5 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 58 48 8d 7d 60 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c0 00 00 00 48 8b 45 60 48 39 c3 74 50 48 b8 00
[    6.252813] RSP: 0018:ffff88806c907b80 EFLAGS: 00010206
[    6.253042] RAX: dffffc0000000000 RBX: ffff88800607e000 RCX: ffffffff8d571a25
[    6.253345] RDX: 000000000000000c RSI: ffff88806c907c38 RDI: 0000000000000060
[    6.253642] RBP: 0000000000000000 R08: 0000000000000000 R09: fffffbfff235a504
[    6.253947] R10: 0000000000000003 R11: 7463656e6e6f6320 R12: 0000000000000000
[    6.254251] R13: 0000000000000000 R14: ffff88806c907c38 R15: 0000000000000000
[    6.254549] FS:  0000000000000000(0000) GS:ffff8880d95bc000(0000) knlGS:0000000000000000
[    6.254887] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.255140] CR2: 00007fc393e8ffc0 CR3: 0000000005252006 CR4: 0000000000770ef0
[    6.255439] PKRU: 55555554
[    6.255564] Call Trace:
[    6.255674]  <IRQ>
[    6.255768]  __iscsi_complete_pdu+0x18bf/0x22a0
[    6.256733]  iscsi_complete_pdu+0x54/0xa0
[    6.256905]  iscsi_tcp_data_recv_done+0xf4/0x250
[    6.257103]  iscsi_tcp_recv_skb+0x31e/0xec0
[    6.257680]  iscsi_sw_tcp_recv+0x12f/0x390
[    6.258061]  __tcp_read_sock+0x1ab/0x810
[    6.258853]  iscsi_sw_tcp_data_ready+0x18b/0x510
[    6.259808]  tcp_data_queue+0x1f13/0x4cd0
[    6.260567]  tcp_rcv_established+0x8a5/0x3a00
[    6.261931]  tcp_v4_do_rcv+0x449/0x960
[    6.262269]  tcp_v4_rcv+0x2245/0x3bc0

Fixes: 8afa1439fcff ("[SCSI] libiscsi: handle immediate command rejections")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
Measured on 7.2-rc5 with KASAN over a proxy that injects one Reject PDU.
Unpatched: the unused index oopses, the returned index warns and
underflows the refcount, and the in-flight read returns 1048576 with 0
bytes filled. With the patch the reject is refused in all three cases
and the connection is failed the way an unknown ITT already is. A
NOP-Out ping reflected in a Reject - the case this branch exists for -
completes normally on both kernels.
 drivers/scsi/libiscsi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 160f02f2f51d..d881f4dc47b4 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1147,8 +1147,11 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			 * Our nop as ping got dropped. We know the target
 			 * and transport are ok so just clean up
 			 */
-			task = iscsi_itt_to_task(conn, rejected_pdu.itt);
-			if (!task) {
+			task = NULL;
+			if (!iscsi_verify_itt(conn, rejected_pdu.itt))
+				task = iscsi_itt_to_task(conn, rejected_pdu.itt);
+			if (!task || task->state == ISCSI_TASK_FREE ||
+			    task->sc) {
 				iscsi_conn_printk(KERN_ERR, conn,
 						 "Invalid pdu reject. Could "
 						 "not lookup rejected task.\n");
-- 
2.43.0

