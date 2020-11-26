Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B261C64E7D
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C503021D40
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="buBUq5lH";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="/2A0sdDG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390070AbgKZNae (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:30:34 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56502 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389957AbgKZNad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 08:30:33 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606397432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ISkd7gV5GLtaW758unEPO6qObTdATD8RZJ4kXQk49Fg=;
        b=buBUq5lH2wBNsm0mh1CFOY5ICwo+EUCNEo2vPfCMW0mlGdTRZGabaFEyI9Wy7jq7Wi5a88
        h1MWgmQyVPQnhOy+JIAUBwTQ9rKUiq83sizFhTcLXkaK+F0m+z78cc4XjWzVLc4n1QkuMg
        NbHCVsF3wk4xJQfJeb3hF7tah+I6PyIH0pclW164Fy1COrklcZTHrD9uvVppNWt0EbNVuW
        y3/iAXTWxT8UeO6yv26oolpLx3cvzzkomqq6RkZmGMrkOKjiP9F2RWsb/WhabJS2z4Uuum
        P2k/7HE4LA4xBpjSmuP2s8+M0pXVg+HUnNtIDpL0SYD9cIgcF5HiB4Xn7JHoTw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606397432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ISkd7gV5GLtaW758unEPO6qObTdATD8RZJ4kXQk49Fg=;
        b=/2A0sdDG3ovvGVDOLX1NfOS7ZR747K6YIFIMFSrFK4ZC3DK9qHK8t2L4vZsEO0kHzkSuG3
        SvyerGNClnjeOHAQ==
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
Subject: [PATCH 04/14] scsi: qla2xxx: qla82xx: Remove in_interrupt().
Date:   Thu, 26 Nov 2020 14:29:42 +0100
Message-Id: <20201126132952.2287996-5-bigeasy@linutronix.de>
In-Reply-To: <20201126132952.2287996-1-bigeasy@linutronix.de>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

qla82xx_idc_lock() spins on a certain hardware state until it's updated. At
the end of each spin, if in_interrupt() is true, it does 20 loops of
cpu_relax(). Otherwise, it yields the CPU.

While in_interrupt() is ill-defined and does not provide what the name
suggests, it is not needed here: qla82xx_idc_lock() is always called
from process context. Below is an analysis of its callers, in order of
appearance:

  - qla_nx.c: qla82xx_device_bootstrap(), only called by
    qla82xx_device_state_handler(), has multiple msleep()s.

  - qla_nx.c: qla82xx_need_qsnt_handler(), has one second msleep()

  - qla_nx.c: qla82xx_wait_for_state_change(), one second msleep()

  - qla_nx.c: qla82xx_need_reset_handler(), can sleep up to 10 seconds

  - qla_nx.c: qla82xx_device_state_handler(), has multiple msleep()s

  - qla_nx.c: qla82xx_abort_isp(), if it's a qla82xx controller, calls
    qla82xx_device_state_handler(), which sleeps. It's also bound to
    isp_operations ->abort_isp() hook, where all the callers are in
    process context.

  - qla_nx.c: qla82xx_beacon_on(), bound to isp_operations ->beacon_on()
    hook.  That hook is only called once, in a mutex locked context,
    from qla2x00_beacon_store().

  - qla_nx.c: qla82xx_beacon_off(), bound to isp_operations
    ->beacon_off() hook.  Like ->beacon_on(), it's only called once, in
    a mutex locked context, from qla2x00_beacon_store().

  - qla_nx.c: qla82xx_fw_dump(), calls qla2x00_wait_for_chip_reset(),
    which has msleep() in a loop. It is bound to isp_operations
    ->fw_dump() hook. That hook *is* called from atomic context at
    qla_isr.c by multiple interrupt handlers. Nonetheless, it's other
    controllers interrupt handlers, and not the qla82xx.

  - qla_attr.c: qla2x00_sysfs_write_fw_dump(), and
    qla2x00_sysfs_write_reset(), process-context sysfs ->write() hooks.

  - qla_os.c: qla2x00_probe_one(). PCI ->probe(), process context.

  - qla_os.c: qla2x00_clear_drv_active(), called solely from
    qla2x00_remove_one(), which is PCI ->remove() hook, process context.

  - qla_os.c: qla2x00_do_dpc(), kthread function, process context.

Remove the in_interrupt() check. Change qla82xx_idc_lock() specification
to a purely process-context function. Mark it with "Context: task, might
sleep".

Change qla82xx_idc_lock() implementation to sleep 100ms, instead of a
schedule(), for each spin. This is more deterministic, and it matches
the other qla models idc_lock() functions.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: <GR-QLogic-Storage-Upstream@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  5 +++++
 drivers/scsi/qla2xxx/qla_nx.c  | 25 +++++++++++--------------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ed9b10f8537d6..fe3c0e2f1ce88 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3296,8 +3296,10 @@ struct isp_operations {
 	void (*fw_dump)(struct scsi_qla_host *vha);
 	void (*mpi_fw_dump)(struct scsi_qla_host *, int);
=20
+	/* Context: task, might sleep */
 	int (*beacon_on) (struct scsi_qla_host *);
 	int (*beacon_off) (struct scsi_qla_host *);
+
 	void (*beacon_blink) (struct scsi_qla_host *);
=20
 	void *(*read_optrom)(struct scsi_qla_host *, void *,
@@ -3308,7 +3310,10 @@ struct isp_operations {
 	int (*get_flash_version) (struct scsi_qla_host *, void *);
 	int (*start_scsi) (srb_t *);
 	int (*start_scsi_mq) (srb_t *);
+
+	/* Context: task, might sleep */
 	int (*abort_isp) (struct scsi_qla_host *);
+
 	int (*iospace_config)(struct qla_hw_data *);
 	int (*initialize_adapter)(struct scsi_qla_host *);
 };
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index b3ba0de5d4fb8..b2017f1c35044 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -489,29 +489,26 @@ qla82xx_rd_32(struct qla_hw_data *ha, ulong off_in)
 	return data;
 }
=20
-#define IDC_LOCK_TIMEOUT 100000000
+/*
+ * Context: task, might sleep
+ */
 int qla82xx_idc_lock(struct qla_hw_data *ha)
 {
-	int i;
-	int done =3D 0, timeout =3D 0;
+	const int delay_ms =3D 100, timeout_ms =3D 2000;
+	int done, total =3D 0;
=20
-	while (!done) {
+	might_sleep();
+
+	while (true) {
 		/* acquire semaphore5 from PCI HW block */
 		done =3D qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM5_LOCK));
 		if (done =3D=3D 1)
 			break;
-		if (timeout >=3D IDC_LOCK_TIMEOUT)
+		if (WARN_ON_ONCE(total >=3D timeout_ms))
 			return -1;
=20
-		timeout++;
-
-		/* Yield CPU */
-		if (!in_interrupt())
-			schedule();
-		else {
-			for (i =3D 0; i < 20; i++)
-				cpu_relax();
-		}
+		total +=3D delay_ms;
+		msleep(delay_ms);
 	}
=20
 	return 0;
--=20
2.29.2

