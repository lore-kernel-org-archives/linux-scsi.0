Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED83E3A1D14
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 09:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790500422; cv=none; b=hzw8OArYcuw6s4gyJ28WtYVxiJRKFsvoSoPwljGtCr9PL/EetxQicKwJvEfroMKDr4QUC4szsB8AigEe5t+BTWGz399hYKkdK3AlguAY3Z0miy8+hksmvMhLXisW9FJ4pRiPRgAPV/fFnwj3ILVdXIKyB4MU2cHw9aAXabGtiwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790500422; c=relaxed/simple;
	bh=mYK3aTJFBHM6xRB867W9xv3//FgmlLtPjoZruC0BXSo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VPdtSr9sRmPamPvGwvsAhxHBS+Bxr8kmhtKk8/G81za0v50pZd+2XrFDArSsv/xlG23dCkXkJvpQPWFal9DPxekXVh4t1Wa1tw1AOzlhs1j7lk30hbzokhSWDwEg1Rap3/6B6tMP2BlRiuhgWrrD20GxtICL4OMq7vUJTcX7qIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pNl2Hieg; arc=none smtp.client-ip=74.125.228.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pNl2Hieg"
Received: by mail-pz2-f39.google.com with SMTP id 41be03b00d2f7-cc79223bcfbso1028554a12.1
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 02:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790500420; x=1791105220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NTbM9diThuu6Z5mJhXi7/OrqdMjxxh1T13jqFXBOHu4=;
        b=pNl2Hiegx3x8xpwOJmuMVARNI4aRu10sR1BkTobfzt6zTBOinGACmXmIU8sZXZGAA9
         H2gIlN0lkRxKFq+gnluHADM0valR/2mpczF1OEOK3TPjwbA/AvhMJI5UPm4E3R+c21gu
         xChRAXd8Fwr8PSjod2o12wEG+OjBB0te2L3pc4wd4PRybRVam1xt7ycvnXnUBjDRcSJ0
         2NMm4/KEF+gRUnOkZMopiSEMD9fdVWKlTGahb20W3Ic4wLrLfyPm3hLyRWVUtZ2b7uak
         Ezq6JdUuhtFyJUQgvh50jRhITsESnHdUgiYou55YAgHZWn29m1h6ujUGMz1izYtBO6UG
         Zi1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790500420; x=1791105220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NTbM9diThuu6Z5mJhXi7/OrqdMjxxh1T13jqFXBOHu4=;
        b=kc3bIynrulbPkj3c5VxD2+v+psjENnlf5qBcqU4LdueMCTLfP31mJb2DACQVpKztrb
         TPwqZmJ0/nW9bPjkPANqF4I8HCDc/+01A/LRubVYx43fH6wEg3vn69C4/rv0X4jPyqcD
         IJULGfC/OEJRf/w2EFsUN/VqH5fvPLCiPdqFsfSWY9jRtqlVH9+EwVPus5lfwxFOBk5O
         LQGoZk3xQXuqE35EvAI9qgcYViu7RlqAQVoHeC0VYZgW0cpMQIhxJPgiB6A9EshcEFwX
         B0+dzwJU7cYhvoZzQ464aJZ+16hbPCnm7rLY8bsaX1H6J0MBs2uvemXxI2bOY2rsKmoh
         pbQQ==
X-Forwarded-Encrypted: i=1; AKwUvByjCyJTuXcysmGo8AR8QHMMfEPY0mHNB+EVfG3oAhItGowAaslAZKp4lXANFZNltVijGVSEMtHd3Tt/@vger.kernel.org
X-Gm-Message-State: AFq9FYJe+jAyp2Aze2ZcssKmyu7pK3pajTyX6T4UyBKOa2z34N93Zloe
	w4snTBocj4o1qntjOaqICuJpA9dEsUxPs0A1lmDDzsrF1GZQMfgbuEb2
X-Gm-Gg: AYBFou3Ct4Y1FHI7iGvMh2N1SkeyR5y95tvD2MES1uMrC3qclIP6JGwYrg4h0iOCWR1
	2OTcUGSvYS413KQTzifKaldEnzQlaE/wXaQmMUIvlRix9ytb79NU0yb7Ut54w3+TBbJxhLyJKTZ
	whLuSuM3EqzES5Z2STrjlpUn0HqtijonjTkoqr1inJpDIrYDqeirlrZIQin89m8WB715mbXu6JN
	8t0Y7l5RE3bkYR5dVJiYGS8UdaHK8oWImSghhWp0uRb+++FXuBhoAJPlOrzEAsYezPJjkhPnhwU
	tBEMoQjJFDeW2ayLbLkT+PL3S2ecIp0SZBPDA1ns42WdzYsx2meDp/8M43vb/6KPmCc6bRWUk8c
	dGWAA0eH2lgJ0VnuWPowaQqFG2U6z1sJ6+CAqQCaaCdC5PdsXnzq6EuHTTkw135RFxVMwM4pRyj
	mI/k0BHQ1LwV45qpY2KLqkeU7iLGr1FNZk7BfXcjCpab5N6ZrokqB5Ftjyc6UsEA5LNIRkJj00w
	0ijm6JGnp5UlzKvy0A8I4vncj3lapc2Ngwv9Fh7iGMD1w9m0WivO6X/cidVhxVFhcsNAbAH/RyW
	TN3ctQx/HB1rx1MMVwLE3P0SG1FUGW4dpr3KebAWXmP9mdhr
X-Received: by 2002:a17:90b:2604:b0:3a0:d9ee:a2e9 with SMTP id 98e67ed59e1d1-3a0d9eeb955mr3228998a91.45.1790500420124;
        Sun, 27 Sep 2026 02:13:40 -0700 (PDT)
Received: from EAIT-H54D9Q2FJQ.eait.uq.edu.au ([130.102.10.103])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df91475206sm26986425ad.82.2026.09.27.02.13.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 27 Sep 2026 02:13:39 -0700 (PDT)
From: Yu Zhang <yuz08559@gmail.com>
To: mkp@kernel.org
Cc: michael.christie@oracle.com,
	d.bogdanov@yadro.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yu Zhang <yuz08559@gmail.com>
Subject: [PATCH] scsi: target: Disable interrupts while holding delayed_cmd_lock
Date: Sun, 27 Sep 2026 19:13:29 +1000
Message-ID: <20260927091329.13482-1-yuz08559@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

target_do_delayed_work() takes dev->delayed_cmd_lock with a plain
spin_lock(). It runs from system_percpu_wq, so interrupts stay enabled
while the lock is held. Every other acquisition of that lock uses
spin_lock_irqsave(): target_handle_task_attr() and
transport_complete_ordered_sync() in target_core_transport.c, and
target_non_ordered_release() in target_core_device.c.

That was safe while every caller of transport_complete_task_attr() ran
in process context: target_complete_ok_work() from
target_completion_wq, transport_complete_qf() from dev->qf_work_queue,
and transport_generic_request_failure() from the submit and execute
paths.

Since commit 06933066d88a ("scsi: target: Add support for completing
commands from backend context") that is no longer true. With
complete_type=1 on a fabric that sets direct_compl_supp,
target_complete() runs target_complete_ok_work() inline in the
backend's completion context, which target_complete_cmd_with_sense()
documents as "May be called from interrupt context". For iblock that
is the bio end_io.

target_complete_ok_work() starts with transport_complete_task_attr(),
which takes delayed_cmd_lock in two ways:

 - Every ORDERED command is put on dev->delayed_cmd_list by
   target_handle_task_attr() and dispatched from there by
   target_do_delayed_work(), which marks it SCF_TASK_ORDERED_SYNC.
   Its completion therefore goes through
   transport_complete_ordered_sync().

 - A SIMPLE command that completes while an ORDERED command is pending
   drops the last reference to the killed dev->non_ordered, and
   percpu_ref_put() then runs target_non_ordered_release() in the
   completing context.

Both take the lock and, if commands are waiting, call
schedule_work(&dev->delayed_cmd_work), which queues on
system_percpu_wq, i.e. on the CPU that took the completion. Further
completions for the same queue are typically delivered there too, so
one arriving while the work holds the lock spins on it forever.

Reaching this needs complete_type=1, which is not the default
(vhost-scsi, the only fabric with direct_compl_supp, defaults to
TARGET_QUEUE_COMPL), a backend whose I/O completes from interrupt
context, and ORDERED commands from the initiator. Linux virtio_scsi
guests send only VIRTIO_SCSI_S_SIMPLE and never take the ordered path;
any guest that uses the ORDERED task attribute, which vhost-scsi
accepts, does.

target_do_delayed_work() is a work item and always runs in process
context, so spin_lock_irq() is sufficient.

Found by inspection; no runtime report. A single ORDERED command goes
through both acquisitions, so with CONFIG_PROVE_LOCKING the first one
completed through direct completion should produce an inconsistent
lock state report on delayed_cmd_lock (hardirq or softirq, depending on
where the backend completes).

Fixes: 06933066d88a ("scsi: target: Add support for completing commands from backend context")
Signed-off-by: Yu Zhang <yuz08559@gmail.com>
---
 drivers/target/target_core_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index dcfe945..67c0465 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2359,7 +2359,7 @@ void target_do_delayed_work(struct work_struct *work)
 	struct se_device *dev = container_of(work, struct se_device,
 					     delayed_cmd_work);
 
-	spin_lock(&dev->delayed_cmd_lock);
+	spin_lock_irq(&dev->delayed_cmd_lock);
 	while (!dev->ordered_sync_in_progress) {
 		struct se_cmd *cmd;
 
@@ -2380,12 +2380,12 @@ void target_do_delayed_work(struct work_struct *work)
 		dev->ordered_sync_in_progress = true;
 
 		list_del(&cmd->se_delayed_node);
-		spin_unlock(&dev->delayed_cmd_lock);
+		spin_unlock_irq(&dev->delayed_cmd_lock);
 
 		__target_execute_cmd(cmd, true);
-		spin_lock(&dev->delayed_cmd_lock);
+		spin_lock_irq(&dev->delayed_cmd_lock);
 	}
-	spin_unlock(&dev->delayed_cmd_lock);
+	spin_unlock_irq(&dev->delayed_cmd_lock);
 }
 
 static void transport_complete_ordered_sync(struct se_cmd *cmd)
-- 
2.43.0

