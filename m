Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F96352026
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 01:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338347; cv=none; b=GIeqLJ9TNHxS6mkjMjpf9nNrBjxatVZn1OPszt65qc/Tlblfo/MIE1RKWlh4xcs2S0B1MV67y0sXXse70uM+J97HUFi9NvlMwwztsHVmnEjYvsOMcszksGugAVK505dC2epABYJZxRNAx40gVPn/RgSqt6dE2TKiA+RqYR1yUJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338347; c=relaxed/simple;
	bh=WxdKPypUaRieyj81DYxQFBrmO3Cd5T0ZK7qJBtHKNBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+THmpxnpUgT4LTJwUUWn3D8k7Y44kG/RBjfuX2uBudpq6wO1sZ4VX45rvykKxurgKaFzZ5FSclPQ+vhY4IerIfsZHuKB6cp/0gotouac9JyV5YXEJwyMtJp2Bv7f+rgKQ2YI+rnVLgGtQljzZQDbJTSnVwJSkmECc4vL8KjA1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=fSfUr3OW; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="fSfUr3OW"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3a8af3a704fso29649a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 18:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791338344; x=1791943144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rQnEF2nHQ0UCD8b2T2H7caZsC3LTz3c9bxdEiiwFl5M=;
        b=fSfUr3OWpVaGke3nHoOoujAFo9nyxrFyeHvy31UBp27zs1Jni+aOe9hrWYHvm2LJem
         KBqiv4QC2Q3d6zvsIY8bGHRhbv+dPUr6KA+L4c8r6DmPfvvbCf0ApKDSdz5nGYpOzZVq
         8qebYASvUsR+5P+LevAr4nOvJZTHi9KWq1rTYPLJ07oNqlnIp6XXp+SU+7/PNmZJ5AbO
         o7MWG0hzTn+MPy5hV278eJ+YktZhNwtO8HrX4Jymd6DHAsIikYntjZ46Fq1XZ7xF56xD
         71nNt/Qmv+yJ9ZlUnAG9EP1Ss3orXtI6/XOwtk8V28gBMYWQgQWlGRMEXO4TQn2+cwBL
         gGqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791338344; x=1791943144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rQnEF2nHQ0UCD8b2T2H7caZsC3LTz3c9bxdEiiwFl5M=;
        b=KWaeMrXp3uhRtzxh+K0fNYGWCY74jy3rWAMWwrA6TRswHr/YarhVe9ZB0bKfPxfj1F
         N347AlUbFkZrW91gK3AKFMCnSf8ReGlGkLG6OX3gxnN3L6K0BQwRrFdlqVsxV2QCUok9
         Yx+Pejnj6vn6SbfGl9saDxzxZBUic9QEgHZfgI/EARkz8A+yNpCn7Ne7fefh4jY6xbHh
         yHgnAeUsRKF1/vBfDbygAhL1YoRHqO2fXfiq1H28N92ALAsT6+XXzNlxCIYbD1IfoxTp
         GKqgzmgtb3krLAf/WhXwG/GFGZS6goLn8xvTpVNicoZxP3CFdYrhR0+orr3lnLONre12
         eVng==
X-Gm-Message-State: AFq9FYJgW928IsPH2a9rh9eYiFaw90cGpOzCRj7wTEMzwQRBMsZOrhK4
	j3/3baOkCItNKy7hPorWYDQehOSqCBF5cjbvi5XIOufbBdmf4/azKPIOlmmVaoLFkms=
X-Gm-Gg: AYBFou0h4uTH7oNpy2zXTKQWXoLUBByKMksalHYJCQGAFOPSQimUcD1tMYwpkWzuy2F
	je959cAOvg60f4YT8boAkOU5J5vJ+Ckb22IN4U3PshEUB3LPwalnhFGZ5FSeEloMyhb+Y2BTvH3
	espjGGeg4X4lUblFNA2neaxTApsgnJmpYgufygisoskocK8Y8wzdxT0BTVRBi8Oep3lK+k9gSCh
	fYxKCAWvZOCKbQCY8YIfsMs1BZDMxrPywnOEBzUJlJvvEpQ8eZmvMw/K8R2xA/g6Lah8cV1neTg
	r93vdnnhIKe3Y1YGWEHHHMJSPuFYb89qfaiUTS18k7fpiEKv59/Q8bhCZRmnqWA+gNNBmeCCSQI
	gB0f7T5bTqqA7axF8e3v7EnDkBNAFoJuvIF5YN6ldfsp2BydgFr2FaISAq3xycPPHi0zAtUPlq7
	75KqAaLN7Jv1sfnMN8UureEvkr7+2nK8+mlahQ3obkwnugZfHhvmg/pAJecTkgEof7fukK44BKK
	sTebQ==
X-Received: by 2002:a17:90b:4cd0:b0:3a6:f1d2:57f8 with SMTP id 98e67ed59e1d1-3a8a08354bbmr728097a91.2.1791338344515;
        Tue, 06 Oct 2026 18:59:04 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543e8478sm8777205a91.17.2026.10.06.18.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:59:04 -0700 (PDT)
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
Subject: [PATCH v3 2/3] scsi: libiscsi: validate the ITT reflected in a Reject PDU
Date: Wed,  7 Oct 2026 10:58:41 +0900
Message-ID: <20261007015842.634893-3-yhlee@isslab.korea.ac.kr>
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
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/libiscsi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7a74bc697d23b..ffd6446d07b28 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1142,13 +1142,15 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			spin_unlock(&conn->session->frwd_lock);
 			spin_lock(&conn->session->back_lock);
 		} else {
-			struct iscsi_task *task;
+			struct iscsi_task *task = NULL;
 			/*
 			 * Our nop as ping got dropped. We know the target
 			 * and transport are ok so just clean up
 			 */
-			task = iscsi_itt_to_task(conn, rejected_pdu.itt);
-			if (!task) {
+			if (!iscsi_verify_itt(conn, rejected_pdu.itt))
+				task = iscsi_itt_to_task(conn, rejected_pdu.itt);
+			if (!task || task->state == ISCSI_TASK_FREE ||
+			    task->sc) {
 				iscsi_conn_printk(KERN_ERR, conn,
 						 "Invalid pdu reject. Could "
 						 "not lookup rejected task.\n");
-- 
2.43.0

