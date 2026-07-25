Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7724908CA
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2026 08:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784969396; cv=none; b=AfMpO3HMFvZWnPS3Adym3Gg5UuyTPOQq0VS6exAmz7Lfg5ghNwNhWN59zX+wESSDCi0lLp5GUbZPVYHTK50nd6zSqe7ANB6Kxh7X4HAMLi1f3OhWxe3NBjFJlbo1L2rcnXgGjDdS/tG7jbL5wgJuVTLEwtX4b8e6qz0KJ1OmVCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784969396; c=relaxed/simple;
	bh=5wbCDtZrp3iGrV7cvqBSX5L1cMn6ozL59j7qNmbBlFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pBy7UAjAF+u/lC5ciNpspHWFzmRPOBKTh4uc2WiZTyBg7TCnF+5z+gufam19ahsE/ca97A/xxQ8DgZ2TOItaGet8B/17p0yfRfI1y/FD7GmiXdelWARDrrwuhWBvEdYCVwCoHvfhZuUziFMcEHiXsjKBlF430G9ROfNFdDcEUBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=ucIkn7pr; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="ucIkn7pr"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cf452def93so18642965ad.1
        for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2026 01:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1784969392; x=1785574192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hVrFE1uT0BINsDxyA59hgmjG595lAs1SmBDuzg2mqOY=;
        b=ucIkn7prAAphz5VvOCHw4BKchC8tQzIwlfgt6tl5Ze6rb/f/5QSfx0VcNM9osj8816
         HwtK67Lh/C5rh7WI+E7cVs3DosbI8gRBIgTS/Hg0NVj4MiAos9SO0IDCb64vZjxShxg0
         aQnHQu1bXZd3mQ8JsU1hcgAuQSKjkfO3Zon9UDfcnnoRf+hDomh1TvtzyiPtIjhaIJXA
         Yzq/vqCXLDonFudxkBJDhC41JQzfu4VzRctLvY0r3oKfHRJBPTb+CDRB4MNSs6v/6WYP
         a0F0TnUkB9Xq/Ogv2F2iUFjyl+5xS+aV+2CFQKW047v1VvwGNcWwqiV3xls1m+k6mmiO
         Qcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784969392; x=1785574192;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hVrFE1uT0BINsDxyA59hgmjG595lAs1SmBDuzg2mqOY=;
        b=YGZIn7yjArtVOVwLLDfIL2qSstcl1LIjU/BzjPXFpR6DWnu/89JZG9ZHQSXroVxTrt
         0BiBwBo6cB04utNeo2S4P4wt0X3q1y51yRkXbKz0+s8RB53tNYIbwK3J0QyxlL6268M4
         SKjcY0iu2EDwVpRE90heBPBMS6ntGgQTm4K4iJ1i3Qw4vMrkCk3OErdVIFYkouRGmZOY
         EXQ3+Xoy2wADML05WA6ULlNL6fLhAtA6NunPAHPWDsbn4MOXDghu32pBsGQdzVbOPyPY
         6K86dU5HlhyEgJtEdp0GWXGNuSQrxF2r9sTfdHQPjX37CRo+NAfk5ZsWfUDSO3TONC/o
         ziWg==
X-Forwarded-Encrypted: i=1; AHgh+RqjxgYpoH7yFHYbUUuFLxWMV/+sj6vuILBMZGfd5qGxr4SJmXZdKO+94F6xEC+0ukGoz3o+0qH3V/O8@vger.kernel.org
X-Gm-Message-State: AOJu0YwWHLqgd+EKemgG/RaM0ZOa6PezSdDbivPJ3lJim63brJXHggDD
	nAgQVJdDWWEeTugOZ1V4bXaW2fpivbIyZyXU0IQ82ah7PtJlk08RqfoNwA3d3Qq107Y=
X-Gm-Gg: AR+sD12T6jtcA6/6oOaNpQs78meg72wkhs50A3gXXrU/YY+4wCISHBgvvljdqUuZdFz
	IVI87Owja6fYkJGvID8lW4eNeXD2vn76wjCUPx4J5/8Ky1jqqcG0AkgBxVaGHCJPqHh+B/b/ra4
	JvFVOEGJC8yNcU6eU1apm+8NdfyjSJWCZI8SpICyGN/Ww/v8siB7L0UyHfcNLJlMCh7A7d18qxO
	VyoDxySy38PvkE3JC0GAizU53RcUKCjLSaNxkeQwQOYOHatj9CB9N2uR37FX+oEV6b0NONOhGAQ
	Isa9HNKwc85nYbN/0qWt1m2jz5+ZAn9FYJlcRRyzLGUWnk4KucyBE6T1IpSsWkac/pbpZdlzXXQ
	ZbQVWYbHga4KYsPq+UlL+ljrK/Rk4mBiUmVbOcZhXhrBbq5zhymmJBzqYd9p7NaqNIKQmgXQwxp
	jjN9BdCBtOPmGmyTc7QDr8566P
X-Received: by 2002:a17:902:e549:b0:2c9:d8c5:d55d with SMTP id d9443c01a7336-2cfdf41daa3mr13200785ad.16.1784969392582;
        Sat, 25 Jul 2026 01:49:52 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:27f4:9b8e:6315:1280])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde5e2b8esm7168165ad.31.2026.07.25.01.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 01:49:52 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: martin.petersen@oracle.com,
	michael.christie@oracle.com,
	himanshu.madhani@oracle.com
Cc: ddiss@suse.de,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: Fix NULL se_tpg dereference in target_complete()
Date: Sat, 25 Jul 2026 17:49:39 +0900
Message-ID: <20260725084939.694403-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit a47fa41381a0 ("scsi: target: Fix NULL dereference on XCOPY
completion") guarded target_complete() against a NULL se_tpg_wwn, which the
EXTENDED COPY worker hits because its global xcopy_pt_tpg carries no
se_tpg_wwn.  target_complete() dereferences
cmd->se_sess->se_tpg->se_tpg_wwn; that fix handled the innermost pointer.

The same statement can fault one level earlier: se_sess->se_tpg itself may
be NULL.  After a session is deregistered, transport_deregister_session()
clears se_sess->se_tpg, yet the isert receive path can still submit and
complete a command that references that session, so the backend completion
runs target_complete() with se_tpg == NULL and dereferences it:

  Oops: general protection fault, probably for non-canonical address ...
  KASAN: null-ptr-deref in range [0x0000000000000080-0x0000000000000087]
  Workqueue: ib-comp-wq ib_cq_poll_work
  RIP: 0010:target_complete_cmd_with_sense.part.0+0x17d/0xc90
  Call Trace:
   fd_execute_rw
   __target_execute_cmd
   iscsit_execute_cmd
   iscsit_sequence_cmd
   isert_recv_done
   __ib_process_cq
   ib_cq_poll_work

The exact window in which an isert completion outlives the session
deregistration has not been pinned down; the guard defends the dereference
regardless of how the command reaches this point.

Load se_tpg first and fall back to a NULL wwn when it is absent.  The
existing "if (!wwn)" path already queues the completion on cmd->cpuid,
so no new branch is needed; this extends that guard by one pointer.

target_submit() reads the same chain (se_sess->se_tpg->se_tpg_tfo) and is
exposed to the identical NULL.  That path has not been reproduced here and
is left for a separate change.

Reproduced with soft-RoCE (rdma_rxe) and KASAN under iSCSI connection
churn; no kernel-side test hooks were needed.

Fixes: 39ae3edda325 ("scsi: target: core: Make completion affinity configurable")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
Tested on 7.2.0-rc4 with soft-RoCE (rdma_rxe) + KASAN under iSCSI/iSER
connection churn.  Without this patch the target crashes in 2 of 3 runs;
with it, 10 consecutive runs are clean and complete the full workload
(160 of 160 cycles, matching the unpatched baseline).

To confirm that the guard - and not an incidental timing change - is what
prevents the crash, a build carrying an additional print inside the new
NULL branch was run 10 more times: a NULL se_tpg was observed 13 times
across 7 of those runs and was handled every time, with no oops and no
change in I/O counts.

 drivers/target/target_core_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fad03a15c969..ee5781d89433 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -904,7 +904,8 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 
 static void target_complete(struct se_cmd *cmd, int success)
 {
-	struct se_wwn *wwn = cmd->se_sess->se_tpg->se_tpg_wwn;
+	struct se_portal_group *se_tpg = cmd->se_sess->se_tpg;
+	struct se_wwn *wwn = se_tpg ? se_tpg->se_tpg_wwn : NULL;
 	struct se_dev_attrib *da;
 	u8 compl_type;
 	int cpu;

base-commit: 248951ddc14de84de3910f9b13f51491a8cd91df
-- 
2.43.0

