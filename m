Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78C0439F69
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 04:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816380; cv=none; b=gRJAPQWQZt9H58YbDrNkZBAr2b7fJa76wLPMIrDZ1tVdUk/0vDpnH148FZ0tXS6Otge9/6OY6+ACa3KykU95DNoGU3b5hZkPWSEYrWoSDvlyidI8u4R73sqTlfbYojxCxLBUQiYhSsvd+3srgPK7G0TPyWbZ/jDJYOQZpEKEjZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816380; c=relaxed/simple;
	bh=c8tpaQw6h+4PJrv3+oEbnYXEVyHOwxSI+jSTWfX3sdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S43kRCTu9VFKaLEsrSc9hFsfeFB+JA7e3vzMcPoC5jd9zRxdZeASzTmGXzCxrJ0FNhM28CIzXdEXcEoL+4Px7DSFC/3OCx0B1FX0RJT0QCkoHogWQApPkXR0w/scUcGK8oPm7NKMUKmTCJyg9wAuJHiAwmfppJupXFS0oWvK+W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=yx3rO7rN; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="yx3rO7rN"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2caf228a910so30398385ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2026 21:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785816378; x=1786421178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=95xetes3VqtMnIXr5wKpo+TbCiS/2h8e0gf4Of94Vw8=;
        b=yx3rO7rNhY4q6Ee0RL9HTrkpwC/4iMT9Q4sbYpEAjmyOf20YqSE/R/LgMmTN3o7yFo
         nVFPt2clTinIOUnfZQqlr1u8jnEUaYDykYaIdwqpRmxp5kkiO1nro0075EHr3IZOsslL
         DOGyUpE7gv8Ls4dAgG9mxXu7yl8T7DJ5CXXZqJab+X0i6BmR+G1YNbsannDN5nxo2A3V
         rwOik3ILZpgs9opj0zkUEF3bO25DSVy5QpE6RRp8i4tsmNr8x3gX3zbhXs4G3p/AeQXJ
         YbsIos/EDuRGVL2/UqYPQLFSiwHgEPMYP3/WXuPbfaceEi1Mos9uJFoGuoN8Zx+qyQ9A
         GqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785816378; x=1786421178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=95xetes3VqtMnIXr5wKpo+TbCiS/2h8e0gf4Of94Vw8=;
        b=FXk7fw4J6VhGZGmVlg5+ygUYRXaKyHBnS3WZJjQr4f2X0evCRETl/ZXlmoHCBOlpPP
         bpXclVNXR3738vUybYCbSkYoMjhVX6mviCfV/0YLJqTbsdgfnkPx23So4ZT1NORxAhEr
         N+nGhWoVklXYQS6iRzXelnJeqSw5XVVnevNTAUZzVSMIkenQGpFy6NlfXJ9i9PKO3rgz
         RfJDkhqO4FFqI3aLBk5OegGFWRWBP/QtL3zJXPbMWPOOWghagQa8QIgKnEj4dDO1Tfka
         M8y71+KIUhmXVt3v8znaBo5KeAw8LtoNfWeK6tzoVjEg0rXRvleeCrWp+nD9YHSFxchd
         fBCw==
X-Forwarded-Encrypted: i=1; AHgh+RoGPgVvmwEFFZAmsRmEKEuMbQ4X6t3gqcnSdIgna6BJtEd1V1sBbj6wKEmJ/Wl+OLMhG7UK9TUyGrHA@vger.kernel.org
X-Gm-Message-State: AOJu0YzTqFGD0n7ZbX3RysjSqWW3f0bDD/yh0mzB5fSdRCMAcC4ESm7N
	TgRl29dAV/H3u22lT+6IIdT+yDyq5cbFJVW5nf9ttpe8zpdMBBjqRYQcRft2tjZ5rPU=
X-Gm-Gg: AR+sD11XP8m2X4uTgwH/TMXoiAdDAigbysQiyh7Qi88eKOSSz8f8PDw3kAQEcOP/Zl9
	8L9MezBwgVHy6Mv8slNwzP0wNnn5cJTqRX1IV3K5OuikOrfUmBF2bPeQ6j8N4pfThd/BGCeOsoW
	jYUdBqEo+x5rt4Lm+v9ZhLK944ik4dORcfkBeIeJRF1tAeEBlUTsvCZBhAIFXS5UFzDVS5CoS9S
	YN7jgstXckueeMN1bBd0NQw7iqfMXv+M1ZpRkk8luBMFZ2pturs0iFnKQnvHGgUedtf4jAwO3q1
	LOgYxKhca05q0SIcT9WBntSc1VOSFyuyrp6XYGj84Kh0ay2X8KqOqE4exE41LOmO6Uc5kIqgkDA
	x1JDHKpgVsGAMlcbUuPwkiyTLit/KezC2MEqsswhA1fMv28yAjP0ZJef/j1un3B7jisWhVfQx8+
	jYb8f/b3HRDcmLXNGQuUh0gUfOyCjNydgmWms++POMZA8Q5i1Z+JeO2wHfNwy5ciGBPjEf
X-Received: by 2002:a17:902:ecd1:b0:2cf:b69a:8f58 with SMTP id d9443c01a7336-2d0523e7d92mr114058285ad.37.1785816377839;
        Mon, 03 Aug 2026 21:06:17 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b11f9a9sm46075465ad.57.2026.08.03.21.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:06:16 -0700 (PDT)
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
	stable@vger.kernel.org
Subject: [PATCH v2 3/3] scsi: libiscsi: validate the task named by a management response
Date: Tue,  4 Aug 2026 13:05:46 +0900
Message-ID: <20260804040546.2264137-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
References: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__iscsi_complete_pdu() fetches the task for five response types from one
place and checks only that the index resolved:

      case ISCSI_OP_LOGOUT_RSP:
      case ISCSI_OP_LOGIN_RSP:
      case ISCSI_OP_TEXT_RSP:
      case ISCSI_OP_SCSI_TMFUNC_RSP:
      case ISCSI_OP_NOOP_IN:
              task = iscsi_itt_to_task(conn, hdr->itt);
              if (!task)
                      return ISCSI_ERR_BAD_ITT;

iscsi_itt_to_task() bounds the index against cmds_max and looks at
nothing else, so a target can name any slot in the pool, including one
that has never been used. task->conn is then NULL, and both
iscsi_nop_out_rsp() and iscsi_complete_task() dereference it. One
unsolicited NOP-In is enough; a Text Response carrying the same ITT
crashes in iscsi_complete_task() instead.

Require the task to be in flight and not a SCSI command, the way
iscsi_itt_to_ctask() does for the command opcodes.

[    6.298634] Oops: general protection fault, probably for non-canonical address 0xdffffc000000000c: 0000 [#1] SMP KASAN NOPTI
[    6.298642] KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
[    6.298652] CPU: 1 UID: 0 PID: 111 Comm: iscsistart Not tainted 7.2.0-rc5-ISCSI1-gf5098b6bae76 #1 PREEMPT(lazy)
[    6.298654] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    6.298656] RIP: 0010:iscsi_nop_out_rsp.constprop.0+0x46/0x160
[    6.298691] Code: c1 ea 03 48 83 ec 08 80 3c 02 00 0f 85 f5 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 58 48 8d 7d 60 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c0 00 00 00 48 8b 45 60 48 39 c3 74 50 48 b8 00
[    6.298698] RSP: 0018:ffff88806c907be8 EFLAGS: 00010206
[    6.298701] RAX: dffffc0000000000 RBX: ffff888006116800 RCX: 0000000000000020
[    6.298702] RDX: 000000000000000c RSI: ffff88800525d578 RDI: 0000000000000060
[    6.298703] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[    6.298706] R10: 0000000000000020 R11: 0000000000000000 R12: 0000000000000000
[    6.298706] R13: 000000000000002e R14: ffff8880056eb440 R15: ffff888006116800
[    6.298707] FS:  00007fc02d1c2740(0000) GS:ffff8880b29bc000(0000) knlGS:0000000000000000
[    6.298710] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.298711] CR2: 000055fe3b56ddf8 CR3: 00000000053b9004 CR4: 0000000000770ef0
[    6.298712] PKRU: 55555554
[    6.298713] Call Trace:
[    6.298714]  <IRQ>
[    6.298714]  __iscsi_complete_pdu+0x13a8/0x22a0
[    6.298758]  iscsi_complete_pdu+0x54/0xa0
[    6.298759]  iscsi_tcp_hdr_recv_done+0x870/0x2c80
[    6.298778]  iscsi_tcp_recv_skb+0x31e/0xec0
[    6.298800]  iscsi_sw_tcp_recv+0x12f/0x390
[    6.298804]  __tcp_read_sock+0x1ab/0x810
[    6.298812]  iscsi_sw_tcp_data_ready+0x18b/0x510
[    6.298814]  tcp_rcv_established+0x1f56/0x3a00
[    6.298842]  tcp_v4_do_rcv+0x449/0x960
[    6.298847]  tcp_v4_rcv+0x2245/0x3bc0

Fixes: 7996a778ff8c ("[SCSI] iscsi: add libiscsi")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
Measured on 7.2-rc5 with KASAN over a proxy that injects one PDU. An
unsolicited NOP-In naming an unused index oopses in 5 of 5 runs and none
of 5 with the patch; a Text Response carrying the same ITT oopses in 5
of 5 and none of 5. A Reject reflecting the ITT of an in-flight abort
TMF warns and underflows the refcount unpatched and does neither with
the series. Normal I/O and a NOP-Out ping rejected by the target are
unchanged.
 drivers/scsi/libiscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 774ed4739891..d62d6c5ef8d6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1287,7 +1287,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	case ISCSI_OP_SCSI_TMFUNC_RSP:
 	case ISCSI_OP_NOOP_IN:
 		task = iscsi_itt_to_task(conn, hdr->itt);
-		if (!task)
+		if (!task || task->state == ISCSI_TASK_FREE || task->sc)
 			return ISCSI_ERR_BAD_ITT;
 		break;
 	default:
-- 
2.43.0

