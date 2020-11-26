Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5695C64E8A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78352221E2
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="F1hEmG2p";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="kNZaTeKs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390078AbgKZNaf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:30:35 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56550 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390051AbgKZNaf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 08:30:35 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606397433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eq8zX1hG/IVKLKYDpk4avTvLjQi6a7SB9a8YWbl+fNg=;
        b=F1hEmG2pDyoBl1o+RDcGhJFdbY3FdBMLCOYEsMc/YQmVK/lC5EsLJdlR/66cXZiTj0zdUs
        coCH94z+zjEk/sAFy/YmsbWzStZbhdKTI8YmfotJ3udVzUcv03+pNpmBvRVjjT7Si4GkHl
        kB4X/6A5ZN8RjJh+y7rkyTzBehTl88fKCmteK/SccJZUeptpucF75CzqN6cQ7A6aOqoEUb
        sUYuFgoYEaueclQbz3OmqlZyN+o8DZSZOSJNAJJDhWm94wxchp5UgiMXLY3R9wtZszn7QO
        KGqRDbbq6LXEpc09h9Vc5qL02VYlf01xNWyu5hF4ivNdQpDmCTfBYI1cOgah6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606397433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eq8zX1hG/IVKLKYDpk4avTvLjQi6a7SB9a8YWbl+fNg=;
        b=kNZaTeKsHj3jVY2UY3u55E+u+BRRThXEEuNpdZJBq99VPCJj1DRVQJTOLlWw5mGNf18DNJ
        Tp4J/bzWNgyEdlCw==
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
Subject: [PATCH 06/14] scsi: qla2xxx: init/os: Remove in_interrupt().
Date:   Thu, 26 Nov 2020 14:29:44 +0100
Message-Id: <20201126132952.2287996-7-bigeasy@linutronix.de>
In-Reply-To: <20201126132952.2287996-1-bigeasy@linutronix.de>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

qla83xx_wait_logic() is used to control the frequency of device IDC lock
retries. If in_interrupt() is true, it does 20 loops of cpu_relax().
Otherwise, it sleeps for 100ms and yields the CPU.

While in_interrupt() is ill-defined and does not provide what the name
suggests, it is not needed here: that qla83xx_wait_logic() is exclusively
called by qla83xx_idc_lock() / unlock(), and they always run from
process context. Below is an analysis of all the idc lock/unlock callers,
in order of appearance:

  - qla_os.c:
      qla83xx_nic_core_unrecoverable_work(),
      qla83xx_idc_state_handler_work(),
      qla83xx_nic_core_reset_work(),
      qla83xx_service_idc_aen(), all workqueue context

  - qla_os.c: qla83xx_check_nic_core_fw_alive(), has msleep()

  - qla_os.c: qla83xx_set_drv_presence(), called once from
    qla2x00_abort_isp(), which is bound to process-context ->abort_isp()
    hook. It also invokes wait_for_completion_timeout() through the
    chain qla2x00_configure_hba() =3D> qla24xx_link_initialize() =3D>
    qla2x00_mailbox_command().

  - qla_os.c: qla83xx_clear_drv_presence(), which is called from
    qla2x00_abort_isp() discussed above, and from qla2x00_remove_one()
    which is PCI process-context ->remove() hook.

  - qla_os.c: qla83xx_need_reset_handler(), has a one second msleep() in
    a loop.

  - qla_os.c: qla83xx_device_bootstrap(), called only by
    qla83xx_idc_state_handler(), which has multiple msleep()
    invocations.

  - qla_os.c: qla83xx_idc_state_handler(), multiple msleep()
    invocations.

  - qla_attr.c: qla2x00_sysfs_write_reset(), sysfs bin_attribute
    ->write() hook, process context

  - qla_init.c: qla83xx_nic_core_fw_load()
      =3D> qla_init.c: qla2x00_initialize_adapter()
        =3D> bound to isp_operations ->initialize_adapter() hook
        ** =3D> qla_os.c: qla2x00_probe_one(), PCI ->probe() process ctx

  - qla_init.c: qla83xx_initiating_reset(), msleep() in a loop.

  - qla_init.c: qla83xx_nic_core_reset(), called by
    qla83xx_nic_core_reset_work(), workqueue context.

Remove the in_interrupt() check, and thus replace the entirety of
qla83xx_wait_logic() with an msleep(QLA83XX_WAIT_LOGIC_MS).

Mark qla83xx_idc_lock() / unlock() with "Context: task, can sleep".

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
---
 drivers/scsi/qla2xxx/qla_os.c | 43 ++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f9c8ae9d669ef..2a8e065b192c3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5619,25 +5619,10 @@ qla83xx_service_idc_aen(struct work_struct *work)
 	}
 }
=20
-static void
-qla83xx_wait_logic(void)
-{
-	int i;
-
-	/* Yield CPU */
-	if (!in_interrupt()) {
-		/*
-		 * Wait about 200ms before retrying again.
-		 * This controls the number of retries for single
-		 * lock operation.
-		 */
-		msleep(100);
-		schedule();
-	} else {
-		for (i =3D 0; i < 20; i++)
-			cpu_relax(); /* This a nop instr on i386 */
-	}
-}
+/*
+ * Control the frequency of IDC lock retries
+ */
+#define QLA83XX_WAIT_LOGIC_MS	100
=20
 static int
 qla83xx_force_lock_recovery(scsi_qla_host_t *base_vha)
@@ -5727,7 +5712,7 @@ qla83xx_idc_lock_recovery(scsi_qla_host_t *base_vha)
 		goto exit;
=20
 	if (o_drv_lockid =3D=3D n_drv_lockid) {
-		qla83xx_wait_logic();
+		msleep(QLA83XX_WAIT_LOGIC_MS);
 		goto retry_lockid;
 	} else
 		return QLA_SUCCESS;
@@ -5736,6 +5721,9 @@ qla83xx_idc_lock_recovery(scsi_qla_host_t *base_vha)
 	return rval;
 }
=20
+/*
+ * Context: task, can sleep
+ */
 void
 qla83xx_idc_lock(scsi_qla_host_t *base_vha, uint16_t requester_id)
 {
@@ -5743,6 +5731,8 @@ qla83xx_idc_lock(scsi_qla_host_t *base_vha, uint16_t =
requester_id)
 	uint32_t lock_owner;
 	struct qla_hw_data *ha =3D base_vha->hw;
=20
+	might_sleep();
+
 	/* IDC-lock implementation using driver-lock/lock-id remote registers */
 retry_lock:
 	if (qla83xx_rd_reg(base_vha, QLA83XX_DRIVER_LOCK, &data)
@@ -5761,7 +5751,7 @@ qla83xx_idc_lock(scsi_qla_host_t *base_vha, uint16_t =
requester_id)
 			/* Retry/Perform IDC-Lock recovery */
 			if (qla83xx_idc_lock_recovery(base_vha)
 			    =3D=3D QLA_SUCCESS) {
-				qla83xx_wait_logic();
+				msleep(QLA83XX_WAIT_LOGIC_MS);
 				goto retry_lock;
 			} else
 				ql_log(ql_log_warn, base_vha, 0xb075,
@@ -6259,6 +6249,9 @@ void qla24xx_process_purex_list(struct purex_list *li=
st)
 	}
 }
=20
+/*
+ * Context: task, can sleep
+ */
 void
 qla83xx_idc_unlock(scsi_qla_host_t *base_vha, uint16_t requester_id)
 {
@@ -6269,6 +6262,8 @@ qla83xx_idc_unlock(scsi_qla_host_t *base_vha, uint16_=
t requester_id)
 	uint32_t data;
 	struct qla_hw_data *ha =3D base_vha->hw;
=20
+	might_sleep();
+
 	/* IDC-unlock implementation using driver-unlock/lock-id
 	 * remote registers
 	 */
@@ -6284,7 +6279,7 @@ qla83xx_idc_unlock(scsi_qla_host_t *base_vha, uint16_=
t requester_id)
 			/* SV: XXX: IDC unlock retrying needed here? */
=20
 			/* Retry for IDC-unlock */
-			qla83xx_wait_logic();
+			msleep(QLA83XX_WAIT_LOGIC_MS);
 			retry++;
 			ql_dbg(ql_dbg_p3p, base_vha, 0xb064,
 			    "Failed to release IDC lock, retrying=3D%d\n", retry);
@@ -6292,7 +6287,7 @@ qla83xx_idc_unlock(scsi_qla_host_t *base_vha, uint16_=
t requester_id)
 		}
 	} else if (retry < 10) {
 		/* Retry for IDC-unlock */
-		qla83xx_wait_logic();
+		msleep(QLA83XX_WAIT_LOGIC_MS);
 		retry++;
 		ql_dbg(ql_dbg_p3p, base_vha, 0xb065,
 		    "Failed to read drv-lockid, retrying=3D%d\n", retry);
@@ -6308,7 +6303,7 @@ qla83xx_idc_unlock(scsi_qla_host_t *base_vha, uint16_=
t requester_id)
 	if (qla83xx_access_control(base_vha, options, 0, 0, NULL)) {
 		if (retry < 10) {
 			/* Retry for IDC-unlock */
-			qla83xx_wait_logic();
+			msleep(QLA83XX_WAIT_LOGIC_MS);
 			retry++;
 			ql_dbg(ql_dbg_p3p, base_vha, 0xb066,
 			    "Failed to release IDC lock, retrying=3D%d\n", retry);
--=20
2.29.2

