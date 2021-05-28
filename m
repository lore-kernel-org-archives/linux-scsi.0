Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FBCC47087
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 23:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F33A26135C
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 23:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbhE1Xoe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 May 2021 19:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhE1Xoe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2021 19:44:34 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE850C061574;
        Fri, 28 May 2021 16:42:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 722E0128031E;
        Fri, 28 May 2021 16:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1622245378;
        bh=gq8FfEXJg7EJ+NuAngyXAoCosv1fKt/Rn6GxmetO9qs=;
        h=Message-ID:Subject:From:To:Date:From;
        b=hkKhrpOTgDWSXeIZ92SXk6BsEWxjDV+lGJr441pPGNY0upBnPjABHJTRAaB/+pjyJ
         WyiQ3xaA6v32ITzWg+bB0BguqglnrWkWF4/OZ5k17euc8U+Qkl/7DrASWDCaqg6Z2/
         +ouPcAM9tAiyQNczRKPqMzjyCeLomec/MRwf8hRw=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id abaeoOe8Xa7F; Fri, 28 May 2021 16:42:58 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 00E6A128026A;
        Fri, 28 May 2021 16:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1622245378;
        bh=gq8FfEXJg7EJ+NuAngyXAoCosv1fKt/Rn6GxmetO9qs=;
        h=Message-ID:Subject:From:To:Date:From;
        b=hkKhrpOTgDWSXeIZ92SXk6BsEWxjDV+lGJr441pPGNY0upBnPjABHJTRAaB/+pjyJ
         WyiQ3xaA6v32ITzWg+bB0BguqglnrWkWF4/OZ5k17euc8U+Qkl/7DrASWDCaqg6Z2/
         +ouPcAM9tAiyQNczRKPqMzjyCeLomec/MRwf8hRw=
Message-ID: <153a81f4d08a49071194ce7d626a8fe8e71f17b5.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.13-rc3
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 28 May 2021 16:42:57 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

10 small fixes, all in drivers.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bodo Stroesser (1):
      scsi: target: tcmu: Fix xarray RCU warning

Dan Carpenter (1):
      scsi: libsas: Use _safe() loop in sas_resume_port()

Dmitry Bogdanov (1):
      scsi: target: qla2xxx: Wait for stop_phase1 at WWN removal

Javed Hasan (1):
      scsi: bnx2fc: Return failure if io_req is already in ABTS processing

Matt Wang (1):
      scsi: vmw_pvscsi: Set correct residual data length

Mike Christie (1):
      scsi: target: iblock: Fix smp_processor_id() BUG messages

Shin'ichiro Kawasaki (1):
      scsi: target: core: Avoid smp_processor_id() in preemptible code

Tom Rix (2):
      scsi: aic7xxx: Remove multiple definition of globals
      scsi: aic7xxx: Restore several defines for aic7xxx firmware build

Yang Yingliang (1):
      scsi: hisi_sas: Drop free_irq() of devm_request_irq() allocated irq

And the diffstat:

 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y   |  1 -
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h |  2 +-
 drivers/scsi/aic7xxx/scsi_message.h         | 11 +++++++++++
 drivers/scsi/bnx2fc/bnx2fc_io.c             |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |  8 ++++----
 drivers/scsi/libsas/sas_port.c              |  4 ++--
 drivers/scsi/qla2xxx/qla_target.c           |  2 ++
 drivers/scsi/vmw_pvscsi.c                   |  8 +++++++-
 drivers/target/target_core_iblock.c         |  4 ++--
 drivers/target/target_core_transport.c      |  2 +-
 drivers/target/target_core_user.c           | 12 +++++++-----
 11 files changed, 38 insertions(+), 17 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
index 924d55a8acbf..65182ad9cdf8 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -58,7 +58,6 @@
 #include "aicasm_symbol.h"
 #include "aicasm_insformat.h"
 
-int yylineno;
 char *yyfilename;
 char stock_prefix[] = "aic_";
 char *prefix = stock_prefix;
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
index 7bf7fd5953ac..ed3bdd43c297 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
@@ -108,7 +108,7 @@ struct macro_arg {
 	regex_t	arg_regex;
 	char   *replacement_text;
 };
-STAILQ_HEAD(macro_arg_list, macro_arg) args;
+STAILQ_HEAD(macro_arg_list, macro_arg);
 
 struct macro_info {
 	struct macro_arg_list args;
diff --git a/drivers/scsi/aic7xxx/scsi_message.h b/drivers/scsi/aic7xxx/scsi_message.h
index a7515c3039ed..53343a6d8ae1 100644
--- a/drivers/scsi/aic7xxx/scsi_message.h
+++ b/drivers/scsi/aic7xxx/scsi_message.h
@@ -3,6 +3,17 @@
  * $FreeBSD: src/sys/cam/scsi/scsi_message.h,v 1.2 2000/05/01 20:21:29 peter Exp $
  */
 
+/* Messages (1 byte) */		     /* I/T (M)andatory or (O)ptional */
+#define MSG_SAVEDATAPOINTER	0x02 /* O/O */
+#define MSG_RESTOREPOINTERS	0x03 /* O/O */
+#define MSG_DISCONNECT		0x04 /* O/O */
+#define MSG_MESSAGE_REJECT	0x07 /* M/M */
+#define MSG_NOOP		0x08 /* M/M */
+
+/* Messages (2 byte) */
+#define MSG_SIMPLE_Q_TAG	0x20 /* O/O */
+#define MSG_IGN_WIDE_RESIDUE	0x23 /* O/O */
+
 /* Identify message */		     /* M/M */	
 #define MSG_IDENTIFYFLAG	0x80 
 #define MSG_IDENTIFY_DISCFLAG	0x40 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 1a0dc18d6915..ed300a279a38 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1220,6 +1220,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		   was a result from the ABTS request rather than the CLEANUP
 		   request */
 		set_bit(BNX2FC_FLAG_IO_CLEANUP,	&io_req->req_flags);
+		rc = FAILED;
 		goto done;
 	}
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 499c770d405c..e95408314078 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4811,14 +4811,14 @@ hisi_sas_v3_destroy_irqs(struct pci_dev *pdev, struct hisi_hba *hisi_hba)
 {
 	int i;
 
-	free_irq(pci_irq_vector(pdev, 1), hisi_hba);
-	free_irq(pci_irq_vector(pdev, 2), hisi_hba);
-	free_irq(pci_irq_vector(pdev, 11), hisi_hba);
+	devm_free_irq(&pdev->dev, pci_irq_vector(pdev, 1), hisi_hba);
+	devm_free_irq(&pdev->dev, pci_irq_vector(pdev, 2), hisi_hba);
+	devm_free_irq(&pdev->dev, pci_irq_vector(pdev, 11), hisi_hba);
 	for (i = 0; i < hisi_hba->cq_nvecs; i++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
 		int nr = hisi_sas_intr_conv ? 16 : 16 + i;
 
-		free_irq(pci_irq_vector(pdev, nr), cq);
+		devm_free_irq(&pdev->dev, pci_irq_vector(pdev, nr), cq);
 	}
 	pci_free_irq_vectors(pdev);
 }
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 19cf418928fa..e3d03d744713 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -25,7 +25,7 @@ static bool phy_is_wideport_member(struct asd_sas_port *port, struct asd_sas_phy
 
 static void sas_resume_port(struct asd_sas_phy *phy)
 {
-	struct domain_device *dev;
+	struct domain_device *dev, *n;
 	struct asd_sas_port *port = phy->port;
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct sas_internal *si = to_sas_internal(sas_ha->core.shost->transportt);
@@ -44,7 +44,7 @@ static void sas_resume_port(struct asd_sas_phy *phy)
 	 * 1/ presume every device came back
 	 * 2/ force the next revalidation to check all expander phys
 	 */
-	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
+	list_for_each_entry_safe(dev, n, &port->dev_list, dev_list_node) {
 		int i, rc;
 
 		rc = sas_notify_lldd_dev_found(dev);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b2008fb1dd38..12a6848ade43 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1563,10 +1563,12 @@ void qlt_stop_phase2(struct qla_tgt *tgt)
 		return;
 	}
 
+	mutex_lock(&tgt->ha->optrom_mutex);
 	mutex_lock(&vha->vha_tgt.tgt_mutex);
 	tgt->tgt_stop = 0;
 	tgt->tgt_stopped = 1;
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
+	mutex_unlock(&tgt->ha->optrom_mutex);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00c, "Stop of tgt %p finished\n",
 	    tgt);
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 8a79605d9652..b9969fce6b4d 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -585,7 +585,13 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 		case BTSTAT_SUCCESS:
 		case BTSTAT_LINKED_COMMAND_COMPLETED:
 		case BTSTAT_LINKED_COMMAND_COMPLETED_WITH_FLAG:
-			/* If everything went fine, let's move on..  */
+			/*
+			 * Commands like INQUIRY may transfer less data than
+			 * requested by the initiator via bufflen. Set residual
+			 * count to make upper layer aware of the actual amount
+			 * of data returned.
+			 */
+			scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
 			cmd->result = (DID_OK << 16);
 			break;
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d6fdd1c61f90..a526f9678c34 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -204,11 +204,11 @@ static struct se_dev_plug *iblock_plug_device(struct se_device *se_dev)
 	struct iblock_dev_plug *ib_dev_plug;
 
 	/*
-	 * Each se_device has a per cpu work this can be run from. Wwe
+	 * Each se_device has a per cpu work this can be run from. We
 	 * shouldn't have multiple threads on the same cpu calling this
 	 * at the same time.
 	 */
-	ib_dev_plug = &ib_dev->ibd_plug[smp_processor_id()];
+	ib_dev_plug = &ib_dev->ibd_plug[raw_smp_processor_id()];
 	if (test_and_set_bit(IBD_PLUGF_PLUGGED, &ib_dev_plug->flags))
 		return NULL;
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8fbfe75c5744..05d7ffd59df6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1416,7 +1416,7 @@ void __target_init_cmd(
 	cmd->orig_fe_lun = unpacked_lun;
 
 	if (!(cmd->se_cmd_flags & SCF_USE_CPUID))
-		cmd->cpuid = smp_processor_id();
+		cmd->cpuid = raw_smp_processor_id();
 
 	cmd->state_active = false;
 }
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 198d25ae482a..4bba10e7755a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -516,8 +516,10 @@ static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
 	dpi = dbi * udev->data_pages_per_blk;
 	/* Count the number of already allocated pages */
 	xas_set(&xas, dpi);
+	rcu_read_lock();
 	for (cnt = 0; xas_next(&xas) && cnt < page_cnt;)
 		cnt++;
+	rcu_read_unlock();
 
 	for (i = cnt; i < page_cnt; i++) {
 		/* try to get new page from the mm */
@@ -699,11 +701,10 @@ static inline void tcmu_copy_data(struct tcmu_dev *udev,
 				  struct scatterlist *sg, unsigned int sg_nents,
 				  struct iovec **iov, size_t data_len)
 {
-	XA_STATE(xas, &udev->data_pages, 0);
 	/* start value of dbi + 1 must not be a valid dbi */
 	int dbi = -2;
 	size_t page_remaining, cp_len;
-	int page_cnt, page_inx;
+	int page_cnt, page_inx, dpi;
 	struct sg_mapping_iter sg_iter;
 	unsigned int sg_flags;
 	struct page *page;
@@ -726,9 +727,10 @@ static inline void tcmu_copy_data(struct tcmu_dev *udev,
 		if (page_cnt > udev->data_pages_per_blk)
 			page_cnt = udev->data_pages_per_blk;
 
-		xas_set(&xas, dbi * udev->data_pages_per_blk);
-		for (page_inx = 0; page_inx < page_cnt && data_len; page_inx++) {
-			page = xas_next(&xas);
+		dpi = dbi * udev->data_pages_per_blk;
+		for (page_inx = 0; page_inx < page_cnt && data_len;
+		     page_inx++, dpi++) {
+			page = xa_load(&udev->data_pages, dpi);
 
 			if (direction == TCMU_DATA_AREA_TO_SG)
 				flush_dcache_page(page);

