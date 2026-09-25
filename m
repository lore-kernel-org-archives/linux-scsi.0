Received: from mail-dl2-f42.google.com (mail-dl2-f42.google.com [74.125.229.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E387A4D7D35
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 19:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790366188; cv=none; b=EDKkTGIYaN4w522VUwMcOZcVgHs86oXA4Edv1TjVKycDCO2YmToK32fyHJyt3A7xJ2BMUNWUzaxJISyjmp6B9wfeS1pEHIIA/+7rgisdSOnTe/yjoFCohHT+P2+KmDrKuPr70oPTsqWaYfpecZFu6w2dSpUZyIHqMDugMI8Oah4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790366188; c=relaxed/simple;
	bh=88gHi5tt2vQJVNgwwlPqnU1wWyBlNFn3+png4x5rN/E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jL2O4pegdqZvxJao4cQ9G+Ho+/BmTrj5tjf7L6NqYQRDEPWf5PlFR4xfc0PLycFwIR3XkbOWbx4q+tZ9058wWv5uTepOnJ4x65VloW6jV1qX2PhFm+tgQT3xXcYTR9rWl8tDUPzICuze2Z813fO1Fhhrt6Qdn1peY/8EFtx3WdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=LJrzhEkT; arc=none smtp.client-ip=74.125.229.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="LJrzhEkT"
Received: by mail-dl2-f42.google.com with SMTP id a92af1059eb24-144f47a9b57so1007437c88.2
        for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 12:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1790366186; x=1790970986; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RsGc4QXOLttpcAW5RUpIRxgpzS034z18ViuTykInQ0Q=;
        b=LJrzhEkTE5in3Vpl6/NPTD8kX3B2kxldD+IwOcHMHvcCBMiIg1Mn3xXxcbOtJtTLsq
         D5EnCzK+LffjZBrq6OPO6A/l+aoB5gEP6AcnVxT9hB/Ag3kxhGhp/dKvXdKCxvF3l2by
         VaWKIOxFPU2Et2NmR4jRaanzf6x6VwUAvvbQK6x9cf4NU2jumaO3Qxbn8FV4hKe7vvwt
         XwM7lhx3h0766sURIIqTX2V7KTPdZtrV7x+1AGPE8lg6na9s4qaHMZOQQ5vO6I3xmlgq
         h9UAlZQuQNyBnaXcewmnQVE5xKxs8gKkF1LrU2rEblRNeKnaXu8aZ2pfer2dXSXbdnpU
         oGJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790366186; x=1790970986;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RsGc4QXOLttpcAW5RUpIRxgpzS034z18ViuTykInQ0Q=;
        b=nkA91+7qv/Z8oTzwoglNK7KgiAPfBGGcqTrJ5acGXvvHkuOnXiY/7IvZ/vPUlPW011
         SW5bFcxF89MJVomEMha/fDP9aunr8JMtbydCIgYeqqVaM2l8QoOefrINWtbk5UvcY1ni
         PmGJVxdgYmdYuwASFNNrBUBB4Hc2o+RPlWiCDaXsA2Se39npUbIb2vqsBDtitCeSSqV9
         GtKae5f18Aa9MgBG/ql5y7ql6kqaE+kM1yyrH75LKsI+wfv+vTNm9wmGwnmZAfyrSZOg
         fXfuWBMfjfKPUquz03GHQuJcusi/gNFoG/A5KdUdjyMd1C2LamO1Bf10Jz17yV8ta97V
         AU5g==
X-Forwarded-Encrypted: i=1; AKwUvBz0/mRVURPppekaZnmwvPWKfcjKsaiWDMhD1gNvoMxT+Lw/KRdvi3vcZa7qfSdSFS5lQ5Vt/IHDXGY8@vger.kernel.org
X-Gm-Message-State: AFuF++kdZbDOPT/nvcYATjd93UsuL/0dYVVzcqmrgelBo95Bg0TiOAZd
	7gkJq0smQj1+Xb40u3Jn2v4UQNL5DExYVCackHlQkgYnphf+0YfC7YX9eWMO/dIZmus=
X-Gm-Gg: AYBFou2ntZhKxRZ7TXcaAFT7jecziZXXbECtcZwiPu3qjunjvxZgULwyRg26mAVvAkD
	TZubp4nlq+4D6FRV3+kpJ5g7MnO3LPgEnRH8pfRLx6A3WKyzgygRmAA/+BSAXFpI2myQCoT6run
	+crEZJ5+LmxpZXjwV+M2dEnfQRwdqtBig6UE8EGXpYQlOD8ME8Nn+2rrarkymSdLQ1YUikNGtDA
	dIvvt14iblvuwFVEByMasCwXOWfR4piIe0Qtt48qkOaLzHUZZxT60GcfvS8hDHnpjgKL3hSeePW
	4w5lgjmVJrYX1aWe5cQ6t/UX09rSaTycnpsWjwhyTA7Xta3gBT0hLa+Dlx1YVQFy0rpSxVszwa5
	u0D3cu/ke5NnvA5G7/qiwD/OQrtEbtLIyjJbiaotNrT4+F8fqw2K+AqTCMi8amX8QEcMpkSY6h3
	GqgxD7BcqTf6+Os6yCi7SzLzGlrKaXt3iCjxKjMXJy/IIhKl1XYwvajqFlxEu0OIrfPA3lDEnPI
	5j8DU+Y30zXSB7LF3mJaYgw71E8+PTNDmudEZoYZj63SbIfGPdDDJiwSkB69CDxBOPscQ==
X-Received: by 2002:a05:701b:4247:10b0:143:3d94:501c with SMTP id a92af1059eb24-146d02aa1d5mr987473c88.38.1790366185873;
        Fri, 25 Sep 2026 12:56:25 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:c85b:dba:2dee:3972])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-146bb6551d9sm1852631c88.9.2026.09.25.12.56.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 25 Sep 2026 12:56:25 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Xingui Yang <yangxingui@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	Yihang Li <liyihang9@h-partners.com>,
	John Garry <john.garry@huawei.com>,
	"James E . J . Bottomley" <jejb@linux.ibm.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.1.y] scsi: hisi_sas: Grab sas_dev lock when traversing the members of sas_dev.list
Date: Fri, 25 Sep 2026 15:56:21 -0400
Message-ID: <20260925195622.31558-1-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 71fb36b5ff113a7674710b9d6063241eada84ff7 ]

When freeing slots in function slot_complete_v3_hw(), it is possible that
sas_dev.list is being traversed elsewhere, and it may trigger a NULL
pointer exception, such as follows:

==>cq thread                    ==>scsi_eh_6

                                ==>scsi_error_handler()
				  ==>sas_eh_handle_sas_errors()
				    ==>sas_scsi_find_task()
				      ==>lldd_abort_task()
==>slot_complete_v3_hw()              ==>hisi_sas_abort_task()
  ==>hisi_sas_slot_task_free()	        ==>dereg_device_v3_hw()
    ==>list_del_init()        		  ==>list_for_each_entry_safe()

[ 7165.434918] sas: Enter sas_scsi_recover_host busy: 32 failed: 32
[ 7165.434926] sas: trying to find task 0x00000000769b5ba5
[ 7165.434927] sas: sas_scsi_find_task: aborting task 0x00000000769b5ba5
[ 7165.434940] hisi_sas_v3_hw 0000:b4:02.0: slot complete: task(00000000769b5ba5) aborted
[ 7165.434964] hisi_sas_v3_hw 0000:b4:02.0: slot complete: task(00000000c9f7aa07) ignored
[ 7165.434965] hisi_sas_v3_hw 0000:b4:02.0: slot complete: task(00000000e2a1cf01) ignored
[ 7165.434968] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[ 7165.434972] hisi_sas_v3_hw 0000:b4:02.0: slot complete: task(0000000022d52d93) ignored
[ 7165.434975] hisi_sas_v3_hw 0000:b4:02.0: slot complete: task(0000000066a7516c) ignored
[ 7165.434976] Mem abort info:
[ 7165.434982]   ESR = 0x96000004
[ 7165.434991]   Exception class = DABT (current EL), IL = 32 bits
[ 7165.434992]   SET = 0, FnV = 0
[ 7165.434993]   EA = 0, S1PTW = 0
[ 7165.434994] Data abort info:
[ 7165.434994]   ISV = 0, ISS = 0x00000004
[ 7165.434995]   CM = 0, WnR = 0
[ 7165.434997] user pgtable: 4k pages, 48-bit VAs, pgdp = 00000000f29543f2
[ 7165.434998] [0000000000000000] pgd=0000000000000000
[ 7165.435003] Internal error: Oops: 96000004 [#1] SMP
[ 7165.439863] Process scsi_eh_6 (pid: 4109, stack limit = 0x00000000c43818d5)
[ 7165.468862] pstate: 00c00009 (nzcv daif +PAN +UAO)
[ 7165.473637] pc : dereg_device_v3_hw+0x68/0xa8 [hisi_sas_v3_hw]
[ 7165.479443] lr : dereg_device_v3_hw+0x2c/0xa8 [hisi_sas_v3_hw]
[ 7165.485247] sp : ffff00001d623bc0
[ 7165.488546] x29: ffff00001d623bc0 x28: ffffa027d03b9508
[ 7165.493835] x27: ffff80278ed50af0 x26: ffffa027dd31e0a8
[ 7165.499123] x25: ffffa027d9b27f88 x24: ffffa027d9b209f8
[ 7165.504411] x23: ffffa027c45b0d60 x22: ffff80278ec07c00
[ 7165.509700] x21: 0000000000000008 x20: ffffa027d9b209f8
[ 7165.514988] x19: ffffa027d9b27f88 x18: ffffffffffffffff
[ 7165.520276] x17: 0000000000000000 x16: 0000000000000000
[ 7165.525564] x15: ffff0000091d9708 x14: ffff0000093b7dc8
[ 7165.530852] x13: ffff0000093b7a23 x12: 6e7265746e692067
[ 7165.536140] x11: 0000000000000000 x10: 0000000000000bb0
[ 7165.541429] x9 : ffff00001d6238f0 x8 : ffffa027d877af00
[ 7165.546718] x7 : ffffa027d6329600 x6 : ffff7e809f58ca00
[ 7165.552006] x5 : 0000000000001f8a x4 : 000000000000088e
[ 7165.557295] x3 : ffffa027d9b27fa8 x2 : 0000000000000000
[ 7165.562583] x1 : 0000000000000000 x0 : 000000003000188e
[ 7165.567872] Call trace:
[ 7165.570309]  dereg_device_v3_hw+0x68/0xa8 [hisi_sas_v3_hw]
[ 7165.575775]  hisi_sas_abort_task+0x248/0x358 [hisi_sas_main]
[ 7165.581415]  sas_eh_handle_sas_errors+0x258/0x8e0 [libsas]
[ 7165.586876]  sas_scsi_recover_host+0x134/0x458 [libsas]
[ 7165.592082]  scsi_error_handler+0xb4/0x488
[ 7165.596163]  kthread+0x134/0x138
[ 7165.599380]  ret_from_fork+0x10/0x18
[ 7165.602940] Code: d5033e9f b9000040 aa0103e2 eb03003f (f9400021)
[ 7165.609004] kernel fault(0x1) notification starting on CPU 75
[ 7165.700728] ---[ end trace fc042cbbea224efc ]---
[ 7165.705326] Kernel panic - not syncing: Fatal exception

To fix the issue, grab sas_dev lock when traversing the members of
sas_dev.list in dereg_device_v3_hw() and hisi_sas_release_tasks() to avoid
concurrency of adding and deleting member. When function
hisi_sas_release_tasks() calls hisi_sas_do_release_task() to free slot, the
lock cannot be grabbed again in hisi_sas_slot_task_free(), then a bool
parameter need_lock is added.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1679283265-115066-2-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

[ Backport to 6.1.y: omit the SATA NCQ-error call-site update because that
  path does not call hisi_sas_do_release_task() in 6.1.y. The list locking
  change is otherwise identical to upstream. ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
Hi Greg, Sasha, and SCSI maintainers,

This is the 6.1.y backport of the fix for CVE-2023-53627. Linux 6.1
still has the unlocked sas_dev.list walkers described in the upstream
commit, while the same fix shipped in 6.3.4 as commit 6e2a40b3a332.

The fix is already present in every newer supported stable tree (6.6.y,
6.12.y, 6.18.y, and 7.2.y), satisfying the newer-trees requirement. For
context, it is still absent from 5.15.y and 5.10.y; this submission only
asks for 6.1.y.

The only omitted upstream edit updates a SATA NCQ-error call site that
does not exist in 6.1.y. Every hisi_sas_slot_task_free() caller present
in 6.1 is updated, and both existing sas_dev.list walkers are protected.

This is slightly larger than the nominal stable patch-size guideline.
The locking change remains atomic because 6.3.4 carried it as one patch,
and splitting the need_lock plumbing from the lock acquisition would
leave a behaviorless preparatory commit.

Could you please queue it for 6.1.y?

This was built on v6.1.188 using x86_64 allmodconfig and 
CONFIG_WERROR=y. The build produced no compiler warnings or errors in
the touched code.

CVE: CVE-2023-53627

AI assistance: An LLM helped identify, adapt, and validate this backport.

Thanks,
Artem Dinaburg

 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 23 +++++++++++++++--------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  4 +++-
 5 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 9aebf4a26b132d..2ecf97f7ae525e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -652,7 +652,8 @@ extern void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy,
 extern void hisi_sas_phy_bcast(struct hisi_sas_phy *phy);
 extern void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
 				    struct sas_task *task,
-				    struct hisi_sas_slot *slot);
+				    struct hisi_sas_slot *slot,
+				    bool need_lock);
 extern void hisi_sas_init_mem(struct hisi_hba *hisi_hba);
 extern void hisi_sas_rst_work_handler(struct work_struct *work);
 extern void hisi_sas_sync_rst_work_handler(struct work_struct *work);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 10ea1d434c48db..290c9915fb9b29 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -205,7 +205,7 @@ static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
 }
 
 void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
-			     struct hisi_sas_slot *slot)
+			     struct hisi_sas_slot *slot, bool need_lock)
 {
 	int device_id = slot->device_id;
 	struct hisi_sas_device *sas_dev = &hisi_hba->devices[device_id];
@@ -239,9 +239,13 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 		}
 	}
 
-	spin_lock(&sas_dev->lock);
-	list_del_init(&slot->entry);
-	spin_unlock(&sas_dev->lock);
+	if (need_lock) {
+		spin_lock(&sas_dev->lock);
+		list_del_init(&slot->entry);
+		spin_unlock(&sas_dev->lock);
+	} else {
+		list_del_init(&slot->entry);
+	}
 
 	memset(slot, 0, offsetof(struct hisi_sas_slot, buf));
 
@@ -1059,7 +1063,7 @@ static void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy)
 }
 
 static void hisi_sas_do_release_task(struct hisi_hba *hisi_hba, struct sas_task *task,
-				     struct hisi_sas_slot *slot)
+				     struct hisi_sas_slot *slot, bool need_lock)
 {
 	if (task) {
 		unsigned long flags;
@@ -1076,7 +1080,7 @@ static void hisi_sas_do_release_task(struct hisi_hba *hisi_hba, struct sas_task
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 	}
 
-	hisi_sas_slot_task_free(hisi_hba, task, slot);
+	hisi_sas_slot_task_free(hisi_hba, task, slot, need_lock);
 }
 
 static void hisi_sas_release_task(struct hisi_hba *hisi_hba,
@@ -1085,8 +1089,11 @@ static void hisi_sas_release_task(struct hisi_hba *hisi_hba,
 	struct hisi_sas_slot *slot, *slot2;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 
+	spin_lock(&sas_dev->lock);
 	list_for_each_entry_safe(slot, slot2, &sas_dev->list, entry)
-		hisi_sas_do_release_task(hisi_hba, slot->task, slot);
+		hisi_sas_do_release_task(hisi_hba, slot->task, slot, false);
+
+	spin_unlock(&sas_dev->lock);
 }
 
 void hisi_sas_release_tasks(struct hisi_hba *hisi_hba)
@@ -1620,7 +1627,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		 */
 		if (rc == TMF_RESP_FUNC_COMPLETE && rc2 != TMF_RESP_FUNC_SUCC) {
 			if (task->lldd_task)
-				hisi_sas_do_release_task(hisi_hba, task, slot);
+				hisi_sas_do_release_task(hisi_hba, task, slot, true);
 		}
 	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
 		task->task_proto & SAS_PROTOCOL_STP) {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 70c24377c6a191..76176b1fc035dd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1310,7 +1310,7 @@ static void slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 	}
 
 out:
-	hisi_sas_slot_task_free(hisi_hba, task, slot);
+	hisi_sas_slot_task_free(hisi_hba, task, slot, true);
 
 	if (task->task_done)
 		task->task_done(task);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index ae39f6b5dc9a8c..1470d6bf3052bf 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2473,7 +2473,7 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
 	}
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
-	hisi_sas_slot_task_free(hisi_hba, task, slot);
+	hisi_sas_slot_task_free(hisi_hba, task, slot, true);
 
 	if (!is_internal && (task->task_proto != SAS_PROTOCOL_SMP)) {
 		spin_lock_irqsave(&device->done_lock, flags);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index ccd52fc7d34a2c..3db206c7438317 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -873,6 +873,7 @@ static void dereg_device_v3_hw(struct hisi_hba *hisi_hba,
 
 	cfg_abt_set_query_iptt = hisi_sas_read32(hisi_hba,
 		CFG_ABT_SET_QUERY_IPTT);
+	spin_lock(&sas_dev->lock);
 	list_for_each_entry_safe(slot, slot2, &sas_dev->list, entry) {
 		cfg_abt_set_query_iptt &= ~CFG_SET_ABORTED_IPTT_MSK;
 		cfg_abt_set_query_iptt |= (1 << CFG_SET_ABORTED_EN_OFF) |
@@ -880,6 +881,7 @@ static void dereg_device_v3_hw(struct hisi_hba *hisi_hba,
 		hisi_sas_write32(hisi_hba, CFG_ABT_SET_QUERY_IPTT,
 			cfg_abt_set_query_iptt);
 	}
+	spin_unlock(&sas_dev->lock);
 	cfg_abt_set_query_iptt &= ~(1 << CFG_SET_ABORTED_EN_OFF);
 	hisi_sas_write32(hisi_hba, CFG_ABT_SET_QUERY_IPTT,
 		cfg_abt_set_query_iptt);
@@ -2364,7 +2366,7 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 	}
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
-	hisi_sas_slot_task_free(hisi_hba, task, slot);
+	hisi_sas_slot_task_free(hisi_hba, task, slot, true);
 
 	if (!is_internal && (task->task_proto != SAS_PROTOCOL_SMP)) {
 		spin_lock_irqsave(&device->done_lock, flags);

base-commit: 1a8763b93150b2c8f3992c27a5ce7857fee4ab0f
-- 
2.39.5
