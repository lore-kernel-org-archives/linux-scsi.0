Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233DDC71155
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBEE8221E9
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="IRCzus7G";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="y1ZmSnJb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390100AbgKZNah (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:30:37 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56576 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390067AbgKZNag (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 08:30:36 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606397433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qrQH7xIDzf20GII/6KAvMh6TDcdBZRtUy7TTmRCIPTU=;
        b=IRCzus7GCSHg4/0BNYEGF0nlYHnXxAbunWrghpvrKt413OjNH9K+Kr03xDPVdutfJ1ibk9
        u7aNoErqz9qI2ODI+toKoP+on89iNuXgD0V6RVuZ1/sP2+ZZ8j1+/HcNsJ/rnzWkx8pvqc
        o6jHvetZCCTpxosc6fEdaLXKg7vkHWdNbwVQAEFUTwV9LndHcwF+oaTzS7fC2n1iM8x2lX
        KK/IzDsIAwy4Lc1Ha9YcZmPPB/UduOrs9wW0uBcPSVKbVGdb3mU0N6PuqytTxkviIqfCx0
        TdWy+forr/6KIGf7wyCVXfwjq8IS6AsFU+ygmX8fUQ5y7+oOL5ZpmOJjVbgovg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606397433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qrQH7xIDzf20GII/6KAvMh6TDcdBZRtUy7TTmRCIPTU=;
        b=y1ZmSnJbXqVnwIkJoNUYZg8/VEeX8tu+Y3EBrmnoZiATjFWMCUJXgy0nP9uQSS5i0YLbsw
        reKqvi/RrSuyJlDA==
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
Subject: [PATCH 07/14] scsi: qla4xxx: qla4_82xx_idc_lock(): Remove in_interrupt().
Date:   Thu, 26 Nov 2020 14:29:45 +0100
Message-Id: <20201126132952.2287996-8-bigeasy@linutronix.de>
In-Reply-To: <20201126132952.2287996-1-bigeasy@linutronix.de>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

qla4_82xx_idc_lock() spins on a certain hardware state until it is
updated. At the end of each spin, if in_interrupt() is true, it does 20
loops of cpu_relax(). Otherwise, it yields the CPU.

While in_interrupt() is ill-defined and does not provide what the name
suggests, it is not needed here: qla4_82xx_idc_lock() is always called
from process context. Below is an analysis of its callers:

  - ql4_nx.c: qla4_82xx_need_reset_handler(), 1-second msleep() in a
    loop.

  - ql4_nx.c: qla4_82xx_isp_reset(), calls
    qla4_8xxx_device_state_handler(), which has multiple msleep()s.

Beside direct calls, qla4_82xx_idc_lock() is also bound to
isp_operations ->idc_lock() hook. Other functions which are bound to the
same hook, e.g. qla4_83xx_drv_lock(), also have an msleep(). For
completeness, below is an analysis of all callers of that hook:

  - ql4_83xx.c: qla4_83xx_need_reset_handler(), has an msleep()

  - ql4_83xx.c: qla4_83xx_isp_reset(), calls
    qla4_8xxx_device_state_handler(), which has multiple msleep()s.

  - ql4_83xx.c: qla4_83xx_disable_pause(), all process context callers:
    =3D> ql4_mbx.c: qla4xxx_mailbox_command(), msleep(), mutex_lock()
    =3D> ql4_os.c: qla4xxx_recover_adapter(), schedule_timeout() in loop
    =3D> ql4_os.c: qla4xxx_do_dpc(), workqueue context

  - ql4_attr.c: qla4_8xxx_sysfs_write_fw_dump(), sysfs bin_attribute
    ->write() hook, process context

  - ql4_mbx.c: qla4xxx_mailbox_command(), earlier discussed

  - ql4_nx.c: qla4_8xxx_device_bootstrap(), callers:
    =3D> ql4_83xx.c: qla4_83xx_need_reset_handler(), process, msleep()
    =3D> ql4_nx.c: qla4_8xxx_device_state_handler(), earlier discussed

  - ql4_nx.c: qla4_8xxx_need_qsnt_handler(), callers:
    =3D> ql4_nx.c: qla4_8xxx_device_state_handler(), multipe msleep()s
    =3D> ql4_os.c: qla4xxx_do_dpc(), workqueue context

  - ql4_nx.c: qla4_8xxx_update_idc_reg(), callers:
    =3D> ql4_nx.c: qla4_8xxx_device_state_handler(), earlier discussed
    =3D> ql4_os.c: qla4_8xxx_error_recovery(), only called by
    qla4xxx_pci_slot_reset(), which is bound to PCI ->slot_reset()
    process-context hook

  - ql4_nx.c: qla4_8xxx_device_state_handler(), earlier discussed

  - ql4_os.c: qla4xxx_recover_adapter(), earlier discussed

  - ql4_os.c: qla4xxx_do_dpc(), earlier discussed

Remove the in_interrupt() check. Mark, qla4_82xx_idc_lock(), and the
->idc_lock() hook itself, with "Context: task, can sleep".

Change qla4_82xx_idc_lock() implementation to sleep 100ms, instead of a
schedule(), for each spin. This is more deterministic, and it matches
other PCI HW locking functions in the driver.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: <GR-QLogic-Storage-Upstream@marvell.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/qla4xxx/ql4_def.h |  2 +-
 drivers/scsi/qla4xxx/ql4_nx.c  | 14 +++++---------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index f5b382ed0a1b2..9210547483886 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -435,7 +435,7 @@ struct isp_operations {
 	void (*wr_reg_direct) (struct scsi_qla_host *, ulong, uint32_t);
 	int (*rd_reg_indirect) (struct scsi_qla_host *, uint32_t, uint32_t *);
 	int (*wr_reg_indirect) (struct scsi_qla_host *, uint32_t, uint32_t);
-	int (*idc_lock) (struct scsi_qla_host *);
+	int (*idc_lock) (struct scsi_qla_host *); /* Context: task, can sleep */
 	void (*idc_unlock) (struct scsi_qla_host *);
 	void (*rom_lock_recovery) (struct scsi_qla_host *);
 	void (*queue_mailbox_command) (struct scsi_qla_host *, uint32_t *, int);
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index da903a545b2c0..4362d0ebe0e15 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -512,12 +512,15 @@ int qla4_82xx_md_wr_32(struct scsi_qla_host *ha, uint=
32_t off, uint32_t data)
  *
  * General purpose lock used to synchronize access to
  * CRB_DEV_STATE, CRB_DEV_REF_COUNT, etc.
+ *
+ * Context: task, can sleep
  **/
 int qla4_82xx_idc_lock(struct scsi_qla_host *ha)
 {
-	int i;
 	int done =3D 0, timeout =3D 0;
=20
+	might_sleep();
+
 	while (!done) {
 		/* acquire semaphore5 from PCI HW block */
 		done =3D qla4_82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM5_LOCK));
@@ -527,14 +530,7 @@ int qla4_82xx_idc_lock(struct scsi_qla_host *ha)
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
+		msleep(100);
 	}
 	return 0;
 }
--=20
2.29.2

