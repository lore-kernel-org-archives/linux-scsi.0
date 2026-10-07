Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAE63546F9
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 01:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338350; cv=none; b=Q96SoL2IjiD+3ExR+nhemYQguVTVX/GoP9h61kTaTR7fw3Hkn8dnjVF/mqoAhfsJqYMS0xsq3FkSV8gEIu6U3BUzVYCpiukTlliv3ibwlzDynH++0pTzb+gZ6LpLJ5zBSBSYXxvR9ZEbZ/3yhqKkm2a2PK6L5mEtRhGIE/ltQJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338350; c=relaxed/simple;
	bh=qTKByd1vWdrJGNeeslO9ljOrv92dZ2glM57yuTTXxyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mx6Ep4H24o1kxVMolLrDkzcUTKoGZ5xyD/ddCNi2Un0GKSAXja3N14TmOc0DV7YLndB2JZGRQ+A2eY1veP5wqzvaJzrCm+ZkGZAmh6bYz3Q+jszXL8x9+e6LRa+vJi5/CO2pITpy3J8Ayhut+WN8X7LrPLAzrRmX9cJM4iC9JR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=JdV6yjR1; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="JdV6yjR1"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3a4d455ace3so1516399a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 18:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791338347; x=1791943147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eAPhRug7ualEFnerrqb4OcmNo+qmeY+luBFsoL8P7nA=;
        b=JdV6yjR14bCGgXCc0S0T+9ocFfux8B7XsVPnUr2KDbxcqSiv8RC1TnyMMSTT7fp3z8
         TDe6DsH/g9T9U8mA0uNQugwrsFHFg8tZWVft7KuqzL3CoPqMMnEcKfu0SY2SqPmgVxvQ
         084cHR5t1H02N/T4MCbmpwGT1zRYcCyyHeWTogyrfsJFxmukSAiXuOCWqJFHN462QDTT
         sh8zwKsxOb4nsUA+at6lwY6vQTgEHrRX/vto9IIcivNKVcU7OJTp4/vWeUOWgd6Q9FjP
         eQLPjlvX2IWcA8jHvav9B/UXLiyDfzP+YEQ1MtpCXTfNgEoWj3lOc8jQEEmv7x6FZDjv
         zIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791338347; x=1791943147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eAPhRug7ualEFnerrqb4OcmNo+qmeY+luBFsoL8P7nA=;
        b=x2asv3okHZ5GHPE9QMePn36+tMbbuxNnyaShsYZ2AkxXJtCP+8qPHxootNLwTjxX4A
         El4v7Uby1vhLjBG1YAE50mrqwBN99DxyXu/iYcTtug5JiqWjk+GWDII/FUn6M7cSEfjK
         n/M6v7E1p4MMSo4PsYWd0Ua2nkfxA8yCwYtl2ySBcY5HQ3VTjEpzPb3sXMxPWfn3opl4
         dtSOSMFFHvRFaLKiZbYWplfH8X7U1PaoUkuh3QFWN6FdIfXtUrbs5R6wkSUVtlGl7Uin
         +oI+s1sSb79uIF3ySInc1pf5Xkpw9jTys392b6HzL6lpadFxiYo3QviKC23EPnOgE8Ga
         wLCQ==
X-Gm-Message-State: AFq9FYJFALtIa8jT6o+tfKJEybCyyDpFUXOq/sTHCB/fXcGS1NP1cJ9J
	zHz1TGX8+fD/wJrPx2KwNFSr5wmUND35IuPJaCTCHmQxN4I2a0gtonAf+OxQ8opYe7U=
X-Gm-Gg: AYBFou2C2xYM+cQb6MveLZPdhWx0Z/SQuYpSKX6yPPPnE15sYRtGdXv/kBzOyjs57iM
	b+RsKyGwELdaX2YQoA2xmr6mE6oCKoCfBd6rX7gPb5v4ikpW6Zj/iw5XyNJ/VP7hu0X5+cW1ccp
	l4s6YCi2HEsm3nYfp7ysZMGkA/sjldBVtq3CJVsjzkTmRaxDv0AOSlAWLB6ZXn4sNoCvBVzR2qJ
	GwgX1QP/HKh5emJ6IbOQR5/So0r3yOPnEC6hjuyE28wN4ECCs2mmBH4uLaoNefTxb+8s4JtqzHH
	PxweuDF+M9F5G5EYvmD2h03LYACTDMR9BzDbO3S0ptv64F6UYq0eKaO7yGS6BIezZ9/SxdEsxNi
	eSwoifhYwi8QDTs7zvg9hJ26PVo6he5iuc3fY5uSu7Keh/jmRk47Aq56Lk82dg7IxWOiEpm9gFr
	O2D9KcVmwQEIEsjz1DkhFH89aM6+d3qTJEe1RRabnm/MtNWPZvqg2OIm15bwUWNqGYEQR4/GLVu
	P/g41U=
X-Received: by 2002:a17:90b:3c04:b0:3a0:a83d:dd0c with SMTP id 98e67ed59e1d1-3a8a08514e6mr714442a91.17.1791338347423;
        Tue, 06 Oct 2026 18:59:07 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543e8478sm8777205a91.17.2026.10.06.18.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:59:07 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 3/3] scsi: libiscsi: validate the task named by a management response
Date: Wed,  7 Oct 2026 10:58:42 +0900
Message-ID: <20261007015842.634893-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007015842.634893-1-yhlee@isslab.korea.ac.kr>
References: <20261007015842.634893-1-yhlee@isslab.korea.ac.kr>
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
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/libiscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ffd6446d07b28..4329967b54260 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1286,7 +1286,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
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

