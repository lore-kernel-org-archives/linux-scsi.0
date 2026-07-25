Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528D23F23BB
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2026 16:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784998727; cv=none; b=qNLU5n1Zp288oGdVhww4Dt+rEf5KvdiRZvSQt+qqLm7l7rUwrcRt6ofr+LFZiIxKYfXwnBu/Y1fovoL1B1OpAkc4qoDzKViq9hOTKECo8GM9YUMci5H7xp02ttR/AwiG3fC5+diJPuT4MrKm8RLdiJfDxEZ9YhQDzk8cc0Zcg3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784998727; c=relaxed/simple;
	bh=LWPaSRdTaK/zLOcQpiD2kptFzcCjeBzXpfz1b58ofxg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r53XwHABkGRP5KSWJVMV+IVoNW6P2U1jfOfIFtMzxnjdljT0rieRP7Nt5MB2MKAsilxKksnv0iD8xmswrAYsNjA7F3Hx8F7bNhvDqAiUY0XilQSszt5z9AgMVc5fcnWc7nnlCYEtawvvK4qrYHjqd74II8rMkrDby/cRCWsiLmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=CKj8sXzn; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="CKj8sXzn"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so1119525a91.2
        for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2026 09:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1784998723; x=1785603523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0t/YY47ENH5SCQReYb/C+fGrbKDzqPxbSclegiFo9uY=;
        b=CKj8sXznyw8csB0bbGHMa32FEnwmZmrUsgIXovVOsyxxDsjEA+vE0nCXQJrX7+qg+X
         a2xYk99PJ7XVdvFLcMRw34qIkvgq3hCbYD0vWCrUP7fFQWIAnG2EPUMHWwnPY3zTBIYu
         r10/iMxxEQ1gLjB3Uw+dzbFkP4wGHLdei8Mjz/iWGvylywFg2z8DBXyXpIsi4iSsHiTn
         VERZKQyPjEWcx93WAVEsjw9Mkmz/zEdeo7kgdwEdpVBJzddaBANlHcQsNTBwgTucMp32
         05PieZM8oLimYO5VRLYVeklzcMUGNdS519JES89yhhA0NHTfuF5zWkcSUQVUoB8rgOjU
         8OAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784998723; x=1785603523;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0t/YY47ENH5SCQReYb/C+fGrbKDzqPxbSclegiFo9uY=;
        b=BiZdJcWjInEgd0OYFaNy8PP3uZk+N+gGqvyq9anhxNvIf7N619caPiV+yfrFbWJhZI
         LXVzUxrHQ/ziOQ4mZVypZGT9kleXThmNIUQcO99vyYx4uxLg/x2WlHCq+aEeEW2empbd
         KaPiGJAE1GRAsMKoSv5gI51A/Exl8o71ubMmbyiGHUblJEErP2IXFkIMqtQA+0kmy9xC
         IO1nvmCeVVpM5U0OulWvdf5infhMbHVrxZ9iszLy2mJU/GrV2Hu1Ip+Una2LGnMR+qqW
         jJhE1GdslTKRV5vVcVieYdgfTV/gf0RcVmeRFJJDoQLcI/MsY1xOfxaIsi/vo9zvxTq3
         2rjg==
X-Forwarded-Encrypted: i=1; AHgh+Rp116MlAz2HCVfvCXHm83ajQVya/6Y1VT3iDsCGnnt3xJdxTVhN68UoK/h2LwHs/2Qlq/T+Wx8JwPC8@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/Lbuv4UB0DZ3jgLjcV51xsbIX5p8Zu+TLRcA1jMnyIZ5bSbS0
	Fo7bYs5b1PGQLT+ocoML1RsihU2iwX13JnP8L5FwfgxbekYtd35tj4yXaQ9/+7hzTb8=
X-Gm-Gg: AR+sD12BC+iu8RhlgfQq3JIC/ft4CLoMOtrekVXLNHWHKPFgn1W3GGj+4MT/cFIClHN
	q3QINeTJw9hDHhrsvBXX8KFoGVEGjQiIF5qgtoYh4pqZ4eiITGtDErfHAFqqSR+mfLj84giT6yZ
	+t/WCmg5OuTq1vnJCDyH2df1xmHSBz9yggMkqRoF7fTmvDOhlX0PWGBD5j91nGW7YVFwICBtofR
	vmlonhGB+fdt1JRNuG6z7mNtyuvnWUAcLZJ4kT1Oaz64nAndYvf8NnrLGCSLivbbwuQuIe139eS
	PKDI1mbjaqUCc4K5RtcJEl/M15cEyqYpGK1sSh7uAI8175lBnSx7VQeLOYZoS6mlQ0olM37xn/i
	WFTP8r3B6FO+/BFC0sXFKVDjSzf9VZ0qiuxA5BBvSy6VXzPRutcXmJy3cGsMYmOQEY9lI/MAGRL
	dKNwirGHRN486bC1vxWRA4EYQRwHjKIb1AM2A=
X-Received: by 2002:a17:90b:4b8e:b0:38e:2a4:cffc with SMTP id 98e67ed59e1d1-38f2961561dmr3186543a91.25.1784998722983;
        Sat, 25 Jul 2026 09:58:42 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:27f4:9b8e:6315:1280])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f058118f2sm1814967a91.1.2026.07.25.09.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 09:58:42 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: martin.petersen@oracle.com,
	michael.christie@oracle.com
Cc: ddiss@suse.de,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v2] scsi: target: Fix NULL se_tpg dereference in target_complete()
Date: Sun, 26 Jul 2026 01:58:18 +0900
Message-ID: <20260725165818.769963-1-yhlee@isslab.korea.ac.kr>
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
read is lockless - transport_deregister_session() clears the field under
se_tpg->session_lock, which target_complete() does not hold - so use
READ_ONCE() to keep the compiler from re-fetching se_sess->se_tpg after
the NULL test.  The existing "if (!wwn)" path already queues the
completion on cmd->cpuid, so no new branch is needed; this extends that
guard by one pointer.

target_submit() reads the same chain (se_sess->se_tpg->se_tpg_tfo) and is
exposed to the identical NULL.  That path has not been reproduced here and
is left for a separate change.

Reproduced with soft-RoCE (rdma_rxe) and KASAN under iSCSI connection
churn; no kernel-side test hooks were needed.

Fixes: 39ae3edda325 ("scsi: target: core: Make completion affinity configurable")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---

v2:
- Use READ_ONCE() for the lockless read of se_sess->se_tpg.  The field is
  cleared concurrently by transport_deregister_session(), so nothing
  prevents the compiler from re-fetching it after the NULL test.  The
  store side is a plain aligned pointer write under se_tpg->session_lock
  and is left unannotated; happy to add WRITE_ONCE() there as well if
  preferred.
- Retested from scratch; every number below is from the v2 build.

Tested on 7.2.0-rc4 with soft-RoCE (rdma_rxe) + KASAN under iSCSI/iSER
connection churn.  Unpatched, 5 of 10 runs oops with the same RIP
(target_complete_cmd_with_sense.part.0+0x17d).  With this patch, 20
consecutive runs show no oops.

To confirm that the guard - and not an incidental timing change - is what
prevents the crash, a build carrying an additional print inside the new
NULL branch was run 10 more times: a NULL se_tpg was observed 9 times
across 7 of those runs and was handled every time, with no oops.

Some runs end early with an initiator-side login timeout from the
soft-RoCE rig instead of completing the full 160-cycle workload: 4 of the
20 patched runs, and 2 of the 5 unpatched runs that did not oops (the
other 5 unpatched runs time out after the oops).  The rig behaves the
same way with and without the patch.

The BUG_ON(!se_tpg) in target_init_cmd() and target_submit_tmr() can be
reached by the same teardown race on fabrics that use those helpers.
iscsit does not - it calls __target_init_cmd() directly and has its own
TMF path - so those paths could not be reproduced or tested here, and
converting a deliberate assertion into graceful failure looked like a
decision for the maintainers rather than something to fold into this fix.

 drivers/target/target_core_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fad03a15c969..0b292e386691 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -904,7 +904,8 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 
 static void target_complete(struct se_cmd *cmd, int success)
 {
-	struct se_wwn *wwn = cmd->se_sess->se_tpg->se_tpg_wwn;
+	struct se_portal_group *se_tpg = READ_ONCE(cmd->se_sess->se_tpg);
+	struct se_wwn *wwn = se_tpg ? se_tpg->se_tpg_wwn : NULL;
 	struct se_dev_attrib *da;
 	u8 compl_type;
 	int cpu;
-- 
2.43.0

