Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74601C56202
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 260D4221F1
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="jNflzse8";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="rNAocpL+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390081AbgKZNag (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:30:36 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56528 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390063AbgKZNaf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 08:30:35 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606397434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3RCu427yktHSfqwVAeE87UO1kLLTnzKktm7HKtp31hM=;
        b=jNflzse8IiiPcnxdY8n1k1tscAktBDx92CUgeD8b+wdnm6pbaC416l7lsDxUtWBcroaE2k
        vb5jxKFradW0zwV4wH2B87YsR892OrV4NZsGPAXEI1sOm49vSTlfPd+vVOMHvYrMrqyxpC
        fvDwAry2W1okXy59wqEbq3gIUxo3RszOjttppL84Ys5Wd6twT2AgEewDIDd3/UbuwdFbKq
        eXfTWpo/J/u9Xs8qvOc0JD+oIWKb7byZIMHy+Nq7K2VQFwnmh+vrjPtAitKqUKdfygTTfY
        HcSB+qOYgAMNXgB35HPJ+0g1mAW9mRlbDg3zRRfV885gveJ6P8jO0jhDciYGPA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606397434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3RCu427yktHSfqwVAeE87UO1kLLTnzKktm7HKtp31hM=;
        b=rNAocpL+hIJB3jxaPSEo/Lii/VSXzFA6Wg7EXxLe2LipUdJrpcZyyE5UGtBNYR3oxcOIaR
        lI1wnVGeWj66cCBQ==
To:     linux-scsi@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>,
        linux-m68k@lists.linux-m68k.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 08/14] scsi: qla4xxx: qla4_82xx_rom_lock(): Remove in_interrupt().
Date:   Thu, 26 Nov 2020 14:29:46 +0100
Message-Id: <20201126132952.2287996-9-bigeasy@linutronix.de>
In-Reply-To: <20201126132952.2287996-1-bigeasy@linutronix.de>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

qla4_82xx_rom_lock() spins on a certain hardware state until it is
updated. At the end of each spin, if in_interrupt() is true, it does 20
loops of cpu_relax(). Otherwise, it yields the CPU.

While in_interrupt() is ill-defined and does not provide what the name
suggests, it is not needed here: qla4_82xx_rom_lock() is always called
from process context. Below is an analysis of its callers:

  - ql4_nx.c: qla4_82xx_rom_fast_read(), all process context callers:
    =3D> ql4_nx.c: qla4_82xx_pinit_from_rom(), GFP_KERNEL allocation
    =3D> ql4_nx.c: qla4_82xx_load_from_flash(), msleep() in a loop

  - ql4_nx.c: qla4_82xx_pinit_from_rom(), earlier discussed

  - ql4_nx.c: qla4_82xx_rom_lock_recovery(), bound to "isp_operations"
    ->rom_lock_recovery() hook, which has one process context caller,
    qla4_8xxx_device_bootstrap(), with callers:
      =3D> ql4_83xx.c: qla4_83xx_need_reset_handler(), process, msleep()
      =3D> ql4_nx.c: qla4_8xxx_device_state_handler(), multiple msleep()s

  - ql4_nx.c: qla4_82xx_read_flash_data(), has cond_resched()

Remove the in_interrupt() check. Mark, qla4_82xx_rom_lock(), and the
->rom_lock_recovery() hook, with "Context: task, can sleep".

Change qla4_82xx_rom_lock() implementation to sleep 20ms, instead of a
schedule(), for each spin. This is more deterministic, and it matches
the other implementations bound to ->rom_lock_recovery().

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: <GR-QLogic-Storage-Upstream@marvell.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |  2 +-
 drivers/scsi/qla4xxx/ql4_nx.c  | 16 ++++++----------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 9210547483886..031569c496e57 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -437,7 +437,7 @@ struct isp_operations {
 	int (*wr_reg_indirect) (struct scsi_qla_host *, uint32_t, uint32_t);
 	int (*idc_lock) (struct scsi_qla_host *); /* Context: task, can sleep */
 	void (*idc_unlock) (struct scsi_qla_host *);
-	void (*rom_lock_recovery) (struct scsi_qla_host *);
+	void (*rom_lock_recovery) (struct scsi_qla_host *); /* Context: task, can=
 sleep */
 	void (*queue_mailbox_command) (struct scsi_qla_host *, uint32_t *, int);
 	void (*process_mailbox_interrupt) (struct scsi_qla_host *, int);
 };
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 4362d0ebe0e15..fd30fbd0d33cb 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -871,15 +871,18 @@ qla4_82xx_decode_crb_addr(unsigned long addr)
 static long rom_max_timeout =3D 100;
 static long qla4_82xx_rom_lock_timeout =3D 100;
=20
+/*
+ * Context: task, can_sleep
+ */
 static int
 qla4_82xx_rom_lock(struct scsi_qla_host *ha)
 {
-	int i;
 	int done =3D 0, timeout =3D 0;
=20
+	might_sleep();
+
 	while (!done) {
 		/* acquire semaphore2 from PCI HW block */
-
 		done =3D qla4_82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_LOCK));
 		if (done =3D=3D 1)
 			break;
@@ -887,14 +890,7 @@ qla4_82xx_rom_lock(struct scsi_qla_host *ha)
 			return -1;
=20
 		timeout++;
-
-		/* Yield CPU */
-		if (!in_interrupt())
-			schedule();
-		else {
-			for (i =3D 0; i < 20; i++)
-				cpu_relax();    /*This a nop instr on i386*/
-		}
+		msleep(20);
 	}
 	qla4_82xx_wr_32(ha, QLA82XX_ROM_LOCK_ID, ROM_LOCK_DRIVER);
 	return 0;
--=20
2.29.2

