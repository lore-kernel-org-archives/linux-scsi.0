Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE3B25E448;
	Wed, 11 Jun 2025 09:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749635897; cv=none; b=ThDUDh+97NxpF0/4GXc5q0LezdnaSK85Ke4WjjT2FmO1KIaYvJnVX522ZqOMH4e8wvbE935UL7YkKaObxB2aoGFFwE6J8oncnQDiMh5KFjdRn4XB/ty2XOMkCjrbFbksZSO95r5yk7YgJeTFSaV0z9xLxD7hTu7P/QT/cw5j80g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749635897; c=relaxed/simple;
	bh=5+i2/EWNbViCkVPeiMzFU7Jv1LYkaYEDVa3rG730Qxk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Dbx8t49nX+s/sz6woC0YX7K7HR75u8qF9UtgJAxqJcSZcNRLyXMcdywr/sB77lGA7R5ZdjWlTA8tzgtb2PkYqT3/QMz0CB8xK9G9ySW7XJSX1M61ls24eR1T2jzEDMDqckTmwwcUP/tDpjeZU7jysPVOrMPbp8mw2YvUq7vQb3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=pt38+DWz; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=4LZzS5CJ; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="pt38+DWz";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="4LZzS5CJ"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1749635893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mI4PIE4Rl9su7skrrttHJtvy1Xt8OOdFRmXaVBqjK3U=;
	b=pt38+DWz4B4xlQ1Vb0DLz4c9IKSFP4YODMRN0skRDaGRdPNrj45n0Q0gfYYeh5YonOWtu0
	s8CA2scyqiy3Z4wqPm+tr5QDPCw3TkseH1ZRfu+a/NXx/B7ikLzBY5vAWTa2l1EqbPJMWh
	JYp5hXsxFrDGTilJEfTJHS+ZeZVSN0CO50oMWu3NPF34KCPSYHxipZwpKvQpJJK4Wos9iZ
	t+hwpjAPBiCx3sXGyMuhse241P9xSP33aOhJCGbohMeCnWjp3fh0TShveq32mBXf2Zk5XW
	AxHFhVWQ3gq6ouL+X6DVdcFOutRigPETTOLZ86OXcjKoCuQ1nmEv4jGtNMNBLA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1749635893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mI4PIE4Rl9su7skrrttHJtvy1Xt8OOdFRmXaVBqjK3U=;
	b=4LZzS5CJdHwsF65Xups3ByBOAlF6JwEtIjPtG/2nTTiTsYmGlVosUZDge4BOvf2DbBeFEl
	CJt997vFSksPT5Bw==
Date: Wed, 11 Jun 2025 11:58:06 +0200
Subject: [PATCH] scsi: Don't use %pK through printk
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250611-restricted-pointers-scsi-v1-1-fe31bfbc4910@linutronix.de>
X-B4-Tracking: v=1; b=H4sIAC1TSWgC/x3MMQqAMAxA0atIZgO1thS8ijhojZqllaSIIN7d4
 viG/x9QEiaFoXlA6GLlnCq6toF4zGkn5LUarLHeOONQSItwLLTimTkVEkWNyhj8Fnxnl7k3Dmp
 +Cm18/+txet8PM3Bu8WoAAAA=
X-Change-ID: 20250404-restricted-pointers-scsi-75f7512ba304
To: Yihang Li <liyihang9@huawei.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1749635893; l=4899;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=5+i2/EWNbViCkVPeiMzFU7Jv1LYkaYEDVa3rG730Qxk=;
 b=3O0gnk2DQ38Rhu5KLB4YN45ir/OvuO/JvzTKhBr++7do1l1EdP8UIQkZyCzXlsKb+0PdocM4c
 hQRq9XUNx/dDLhUmMx/IkOBFcaV0ezqJ74tMqmiyQHQL+FYHe9rfe3x
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

In the past %pK was preferable to %p as it would not leak raw pointer
values into the kernel log.
Since commit ad67b74d2469 ("printk: hash addresses printed with %p")
the regular %p has been improved to avoid this issue.
Furthermore, restricted pointers ("%pK") were never meant to be used
through printk(). They can still unintentionally leak raw pointers or
acquire sleeping locks in atomic contexts.

Switch to the regular pointer formatting which is safer and
easier to reason about.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 6 +++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 6 +++---
 drivers/scsi/scsi_debug.c              | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 24cd172905f337896219efa3415a88ac871cd95c..4431698a5d78c2431fb967d8ef71c18be5e8a9be 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2401,7 +2401,7 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
 			slot_err_v2_hw(hisi_hba, task, slot, 2);
 
 		if (ts->stat != SAS_DATA_UNDERRUN)
-			dev_info(dev, "erroneous completion iptt=%d task=%pK dev id=%d CQ hdr: 0x%x 0x%x 0x%x 0x%x Error info: 0x%x 0x%x 0x%x 0x%x\n",
+			dev_info(dev, "erroneous completion iptt=%d task=%p dev id=%d CQ hdr: 0x%x 0x%x 0x%x 0x%x Error info: 0x%x 0x%x 0x%x 0x%x\n",
 				 slot->idx, task, sas_dev->device_id,
 				 complete_hdr->dw0, complete_hdr->dw1,
 				 complete_hdr->act, complete_hdr->dw3,
@@ -2467,7 +2467,7 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		dev_info(dev, "slot complete: task(%pK) aborted\n", task);
+		dev_info(dev, "slot complete: task(%p) aborted\n", task);
 		return;
 	}
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
@@ -2478,7 +2478,7 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
 		spin_lock_irqsave(&device->done_lock, flags);
 		if (test_bit(SAS_HA_FROZEN, &ha->state)) {
 			spin_unlock_irqrestore(&device->done_lock, flags);
-			dev_info(dev, "slot complete: task(%pK) ignored\n",
+			dev_info(dev, "slot complete: task(%p) ignored\n",
 				 task);
 			return;
 		}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index bc5d5356dd00710277e4b8877798f64c9674d5de..2f3d61abab3a66bf0b40a27b9411dc2cab1c44fc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2409,7 +2409,7 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 
 		if (slot_err_v3_hw(hisi_hba, task, slot)) {
 			if (ts->stat != SAS_DATA_UNDERRUN)
-				dev_info(dev, "erroneous completion iptt=%d task=%pK dev id=%d addr=%016llx CQ hdr: 0x%x 0x%x 0x%x 0x%x Error info: 0x%x 0x%x 0x%x 0x%x\n",
+				dev_info(dev, "erroneous completion iptt=%d task=%p dev id=%d addr=%016llx CQ hdr: 0x%x 0x%x 0x%x 0x%x Error info: 0x%x 0x%x 0x%x 0x%x\n",
 					slot->idx, task, sas_dev->device_id,
 					SAS_ADDR(device->sas_addr),
 					dw0, dw1, complete_hdr->act, dw3,
@@ -2470,7 +2470,7 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		dev_info(dev, "slot complete: task(%pK) aborted\n", task);
+		dev_info(dev, "slot complete: task(%p) aborted\n", task);
 		return;
 	}
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
@@ -2481,7 +2481,7 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 		spin_lock_irqsave(&device->done_lock, flags);
 		if (test_bit(SAS_HA_FROZEN, &ha->state)) {
 			spin_unlock_irqrestore(&device->done_lock, flags);
-			dev_info(dev, "slot complete: task(%pK) ignored\n",
+			dev_info(dev, "slot complete: task(%p) ignored\n",
 				 task);
 			return;
 		}
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index aef33d1e346ab9ebf914effc7f94af22cada99ba..0847767d4d4361bf8ab27026aa2149b555e8ea4d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8770,7 +8770,7 @@ static int sdebug_add_store(void)
 		dif_size = sdebug_store_sectors * sizeof(struct t10_pi_tuple);
 		sip->dif_storep = vmalloc(dif_size);
 
-		pr_info("dif_storep %u bytes @ %pK\n", dif_size,
+		pr_info("dif_storep %u bytes @ %p\n", dif_size,
 			sip->dif_storep);
 
 		if (!sip->dif_storep) {

---
base-commit: f09079bd04a924c72d555cd97942d5f8d7eca98c
change-id: 20250404-restricted-pointers-scsi-75f7512ba304

Best regards,
-- 
Thomas Weißschuh <thomas.weissschuh@linutronix.de>

