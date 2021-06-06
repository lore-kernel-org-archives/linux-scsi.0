Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21B7C47096
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Jun 2021 15:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABD7B61429
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Jun 2021 15:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhFFPvF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Jun 2021 11:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhFFPvE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2021 11:51:04 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BCCC061766;
        Sun,  6 Jun 2021 08:49:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id E4EA21280946;
        Sun,  6 Jun 2021 08:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1622994552;
        bh=FYl7mwu6LLvSpk3rnuHAfiCIgSiclVR/MbkXA3/WIEQ=;
        h=Message-ID:Subject:From:To:Date:From;
        b=W0bKIKp5rhOQNfnbJy8PsMAVgCrijhuZ2Yn3MPEarIeoDyjlkyq1/xjVs0vJ0BOYp
         G0keR26GLTFCWaM3Y4pbZyS9tJ8K6DsoiF0gts1C4TZ8xZCgGg2oc5kbzS2O9tBNIY
         We3o0RUjO3B8ZOpKk4XCzKEncJ7imvCuY8NOdFoA=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TTzNMhhgMJha; Sun,  6 Jun 2021 08:49:12 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 23526128093E;
        Sun,  6 Jun 2021 08:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1622994552;
        bh=FYl7mwu6LLvSpk3rnuHAfiCIgSiclVR/MbkXA3/WIEQ=;
        h=Message-ID:Subject:From:To:Date:From;
        b=W0bKIKp5rhOQNfnbJy8PsMAVgCrijhuZ2Yn3MPEarIeoDyjlkyq1/xjVs0vJ0BOYp
         G0keR26GLTFCWaM3Y4pbZyS9tJ8K6DsoiF0gts1C4TZ8xZCgGg2oc5kbzS2O9tBNIY
         We3o0RUjO3B8ZOpKk4XCzKEncJ7imvCuY8NOdFoA=
Message-ID: <22894c5d4fd4bcfa29bd945ce81112606d2fe5fc.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.13-rc4
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sun, 06 Jun 2021 08:49:10 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Five small and fairly minor fixes, all in drivers.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Daniel Wagner (1):
      scsi: qedf: Do not put host in qedf_vport_create() unconditionally

Ewan D. Milne (1):
      scsi: scsi_devinfo: Add blacklist entry for HPE OPEN-V

James Smart (1):
      scsi: lpfc: Fix failure to transmit ABTS on FC link

Maurizio Lombardi (1):
      scsi: target: core: Fix warning on realtime kernels

Stanley Chu (1):
      scsi: ufs: ufs-mediatek: Fix HCI version in some platforms

And the diffstat:

 drivers/scsi/lpfc/lpfc_sli.c           |  4 +---
 drivers/scsi/qedf/qedf_main.c          | 20 +++++++++-----------
 drivers/scsi/scsi_devinfo.c            |  1 +
 drivers/scsi/ufs/ufs-mediatek.c        | 15 ++++++++++++++-
 drivers/target/target_core_transport.c |  4 +---
 5 files changed, 26 insertions(+), 18 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 573c8599d71c..fc3682f15f50 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20589,10 +20589,8 @@ lpfc_sli4_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	abtswqe = &abtsiocb->wqe;
 	memset(abtswqe, 0, sizeof(*abtswqe));
 
-	if (lpfc_is_link_up(phba))
+	if (!lpfc_is_link_up(phba))
 		bf_set(abort_cmd_ia, &abtswqe->abort_cmd, 1);
-	else
-		bf_set(abort_cmd_ia, &abtswqe->abort_cmd, 0);
 	bf_set(abort_cmd_criteria, &abtswqe->abort_cmd, T_XRI_TAG);
 	abtswqe->abort_cmd.rsrvd5 = 0;
 	abtswqe->abort_cmd.wqe_com.abort_tag = xritag;
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 756231151882..b92570a7c309 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1827,22 +1827,20 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 		fcoe_wwn_to_str(vport->port_name, buf, sizeof(buf));
 		QEDF_WARN(&(base_qedf->dbg_ctx), "Failed to create vport, "
 			   "WWPN (0x%s) already exists.\n", buf);
-		goto err1;
+		return rc;
 	}
 
 	if (atomic_read(&base_qedf->link_state) != QEDF_LINK_UP) {
 		QEDF_WARN(&(base_qedf->dbg_ctx), "Cannot create vport "
 			   "because link is not up.\n");
-		rc = -EIO;
-		goto err1;
+		return -EIO;
 	}
 
 	vn_port = libfc_vport_create(vport, sizeof(struct qedf_ctx));
 	if (!vn_port) {
 		QEDF_WARN(&(base_qedf->dbg_ctx), "Could not create lport "
 			   "for vport.\n");
-		rc = -ENOMEM;
-		goto err1;
+		return -ENOMEM;
 	}
 
 	fcoe_wwn_to_str(vport->port_name, buf, sizeof(buf));
@@ -1866,7 +1864,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	if (rc) {
 		QEDF_ERR(&(base_qedf->dbg_ctx), "Could not allocate memory "
 		    "for lport stats.\n");
-		goto err2;
+		goto err;
 	}
 
 	fc_set_wwnn(vn_port, vport->node_name);
@@ -1884,7 +1882,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	if (rc) {
 		QEDF_WARN(&base_qedf->dbg_ctx,
 			  "Error adding Scsi_Host rc=0x%x.\n", rc);
-		goto err2;
+		goto err;
 	}
 
 	/* Set default dev_loss_tmo based on module parameter */
@@ -1925,9 +1923,10 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	vport_qedf->dbg_ctx.host_no = vn_port->host->host_no;
 	vport_qedf->dbg_ctx.pdev = base_qedf->pdev;
 
-err2:
+	return 0;
+
+err:
 	scsi_host_put(vn_port->host);
-err1:
 	return rc;
 }
 
@@ -1968,8 +1967,7 @@ static int qedf_vport_destroy(struct fc_vport *vport)
 	fc_lport_free_stats(vn_port);
 
 	/* Release Scsi_Host */
-	if (vn_port->host)
-		scsi_host_put(vn_port->host);
+	scsi_host_put(vn_port->host);
 
 out:
 	return 0;
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index d92cec12454c..d33355ab6e14 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -184,6 +184,7 @@ static struct {
 	{"HP", "C3323-300", "4269", BLIST_NOTQ},
 	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN},
 	{"HP", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
+	{"HPE", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index aee3cfc7142a..0a84ec9e7cea 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -603,11 +603,23 @@ static void ufs_mtk_get_controller_version(struct ufs_hba *hba)
 
 	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_LOCALVERINFO), &ver);
 	if (!ret) {
-		if (ver >= UFS_UNIPRO_VER_1_8)
+		if (ver >= UFS_UNIPRO_VER_1_8) {
 			host->hw_ver.major = 3;
+			/*
+			 * Fix HCI version for some platforms with
+			 * incorrect version
+			 */
+			if (hba->ufs_version < ufshci_version(3, 0))
+				hba->ufs_version = ufshci_version(3, 0);
+		}
 	}
 }
 
+static u32 ufs_mtk_get_ufs_hci_version(struct ufs_hba *hba)
+{
+	return hba->ufs_version;
+}
+
 /**
  * ufs_mtk_init - find other essential mmio bases
  * @hba: host controller instance
@@ -1048,6 +1060,7 @@ static void ufs_mtk_event_notify(struct ufs_hba *hba,
 static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.name                = "mediatek.ufshci",
 	.init                = ufs_mtk_init,
+	.get_ufs_hci_version = ufs_mtk_get_ufs_hci_version,
 	.setup_clocks        = ufs_mtk_setup_clocks,
 	.hce_enable_notify   = ufs_mtk_hce_enable_notify,
 	.link_startup_notify = ufs_mtk_link_startup_notify,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 05d7ffd59df6..7e35eddd9eb7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3121,9 +3121,7 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
 	__releases(&cmd->t_state_lock)
 	__acquires(&cmd->t_state_lock)
 {
-
-	assert_spin_locked(&cmd->t_state_lock);
-	WARN_ON_ONCE(!irqs_disabled());
+	lockdep_assert_held(&cmd->t_state_lock);
 
 	if (fabric_stop)
 		cmd->transport_state |= CMD_T_FABRIC_STOP;

