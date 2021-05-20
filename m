Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2ECEC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 22:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8D4D61073
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 22:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhETWCx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 18:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhETWCx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 18:02:53 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0D1C061574;
        Thu, 20 May 2021 15:01:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id D3C4E1280AFB;
        Thu, 20 May 2021 15:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1621548089;
        bh=6B36EHNlOMF+m6qguQbqNXb4TpgIJjDrp1/nC1OLWrU=;
        h=Message-ID:Subject:From:To:Date:From;
        b=K+K0BwIkdD/XqLAaIVIL9SkMjxyIQNtWzhibsqmYgXMxgMuWW/WWeTNGQOxuP0C3L
         788TXogTBNpvc1haAliWYXrN+TcN53QAcZVGkmSDJAmEW41iKRzB7ZbVvhveZdm9zG
         O3GM1G+8ibyzzVzQLoCoQvhr6HApyP36elp9pJCY=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sZEBQ-8w3_SY; Thu, 20 May 2021 15:01:29 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 6F8BF1280AF0;
        Thu, 20 May 2021 15:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1621548089;
        bh=6B36EHNlOMF+m6qguQbqNXb4TpgIJjDrp1/nC1OLWrU=;
        h=Message-ID:Subject:From:To:Date:From;
        b=K+K0BwIkdD/XqLAaIVIL9SkMjxyIQNtWzhibsqmYgXMxgMuWW/WWeTNGQOxuP0C3L
         788TXogTBNpvc1haAliWYXrN+TcN53QAcZVGkmSDJAmEW41iKRzB7ZbVvhveZdm9zG
         O3GM1G+8ibyzzVzQLoCoQvhr6HApyP36elp9pJCY=
Message-ID: <376a0bde564e90d69378434a402eace5a298d6c4.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.13-rc2
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Thu, 20 May 2021 15:01:28 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

8 small fixes, all in drivers.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Ajish Koshy (1):
      scsi: pm80xx: Fix drives missing during rmmod/insmod loop

Bart Van Assche (1):
      scsi: ufs: core: Increase the usable queue depth

Javed Hasan (1):
      scsi: qedf: Add pointer checks in qedf_update_link_speed()

Matt Wang (1):
      scsi: BusLogic: Fix 64-bit system enumeration error for Buslogic

Peter Wang (1):
      scsi: ufs: ufs-mediatek: Fix power down spec violation

Zhen Lei (1):
      scsi: qla2xxx: Fix error return code in qla82xx_write_flash_dword()

And the diffstat:

 drivers/scsi/BusLogic.c           |  6 +++---
 drivers/scsi/BusLogic.h           |  2 +-
 drivers/scsi/pm8001/pm8001_hwi.c  | 10 ++++++----
 drivers/scsi/pm8001/pm8001_init.c |  2 +-
 drivers/scsi/pm8001/pm8001_sas.c  |  7 ++++++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 12 ++++++------
 drivers/scsi/qedf/qedf_main.c     |  4 +++-
 drivers/scsi/qla2xxx/qla_nx.c     |  3 ++-
 drivers/scsi/ufs/ufs-mediatek.c   |  4 ++++
 drivers/scsi/ufs/ufshcd.c         |  5 ++++-
 10 files changed, 36 insertions(+), 19 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 3ee46a843cb5..adddcd589941 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2926,11 +2926,11 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 		ccb->opcode = BLOGIC_INITIATOR_CCB_SG;
 		ccb->datalen = count * sizeof(struct blogic_sg_seg);
 		if (blogic_multimaster_type(adapter))
-			ccb->data = (void *)((unsigned int) ccb->dma_handle +
+			ccb->data = (unsigned int) ccb->dma_handle +
 					((unsigned long) &ccb->sglist -
-					(unsigned long) ccb));
+					(unsigned long) ccb);
 		else
-			ccb->data = ccb->sglist;
+			ccb->data = virt_to_32bit_virt(ccb->sglist);
 
 		scsi_for_each_sg(command, sg, count, i) {
 			ccb->sglist[i].segbytes = sg_dma_len(sg);
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index a8e4a19788a7..7d1ec10f2430 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -806,7 +806,7 @@ struct blogic_ccb {
 	unsigned char cdblen;				/* Byte 2 */
 	unsigned char sense_datalen;			/* Byte 3 */
 	u32 datalen;					/* Bytes 4-7 */
-	void *data;					/* Bytes 8-11 */
+	u32 data;					/* Bytes 8-11 */
 	unsigned char:8;				/* Byte 12 */
 	unsigned char:8;				/* Byte 13 */
 	enum blogic_adapter_status adapter_status;	/* Byte 14 */
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index ecd06d2d7e81..71aa6af08340 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3765,11 +3765,13 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case HW_EVENT_PHY_START_STATUS:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_START_STATUS status = %x\n",
 			   status);
-		if (status == 0) {
+		if (status == 0)
 			phy->phy_state = 1;
-			if (pm8001_ha->flags == PM8001F_RUN_TIME &&
-					phy->enable_completion != NULL)
-				complete(phy->enable_completion);
+
+		if (pm8001_ha->flags == PM8001F_RUN_TIME &&
+				phy->enable_completion != NULL) {
+			complete(phy->enable_completion);
+			phy->enable_completion = NULL;
 		}
 		break;
 	case HW_EVENT_SAS_PHY_UP:
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 390c33df0357..af09bd282cb9 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1151,8 +1151,8 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 		goto err_out_shost;
 	}
 	list_add_tail(&pm8001_ha->list, &hba_list);
-	scsi_scan_host(pm8001_ha->shost);
 	pm8001_ha->flags = PM8001F_RUN_TIME;
+	scsi_scan_host(pm8001_ha->shost);
 	return 0;
 
 err_out_shost:
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index d28af413b93a..335cf37e6cb9 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -264,12 +264,17 @@ void pm8001_scan_start(struct Scsi_Host *shost)
 	int i;
 	struct pm8001_hba_info *pm8001_ha;
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	DECLARE_COMPLETION_ONSTACK(completion);
 	pm8001_ha = sha->lldd_ha;
 	/* SAS_RE_INITIALIZATION not available in SPCv/ve */
 	if (pm8001_ha->chip_id == chip_8001)
 		PM8001_CHIP_DISP->sas_re_init_req(pm8001_ha);
-	for (i = 0; i < pm8001_ha->chip->n_phy; ++i)
+	for (i = 0; i < pm8001_ha->chip->n_phy; ++i) {
+		pm8001_ha->phy[i].enable_completion = &completion;
 		PM8001_CHIP_DISP->phy_start_req(pm8001_ha, i);
+		wait_for_completion(&completion);
+		msleep(300);
+	}
 }
 
 int pm8001_scan_finished(struct Scsi_Host *shost, unsigned long time)
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 4e980830f9f5..700530e969ac 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3487,13 +3487,13 @@ static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	pm8001_dbg(pm8001_ha, INIT,
 		   "phy start resp status:0x%x, phyid:0x%x\n",
 		   status, phy_id);
-	if (status == 0) {
+	if (status == 0)
 		phy->phy_state = PHY_LINK_DOWN;
-		if (pm8001_ha->flags == PM8001F_RUN_TIME &&
-				phy->enable_completion != NULL) {
-			complete(phy->enable_completion);
-			phy->enable_completion = NULL;
-		}
+
+	if (pm8001_ha->flags == PM8001F_RUN_TIME &&
+			phy->enable_completion != NULL) {
+		complete(phy->enable_completion);
+		phy->enable_completion = NULL;
 	}
 	return 0;
 
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 69f7784233f9..756231151882 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -536,7 +536,9 @@ static void qedf_update_link_speed(struct qedf_ctx *qedf,
 	if (linkmode_intersects(link->supported_caps, sup_caps))
 		lport->link_supported_speeds |= FC_PORTSPEED_20GBIT;
 
-	fc_host_supported_speeds(lport->host) = lport->link_supported_speeds;
+	if (lport->host && lport->host->shost_data)
+		fc_host_supported_speeds(lport->host) =
+			lport->link_supported_speeds;
 }
 
 static void qedf_bw_update(void *dev)
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 0677295957bc..615e44af1ca6 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1063,7 +1063,8 @@ qla82xx_write_flash_dword(struct qla_hw_data *ha, uint32_t flashaddr,
 		return ret;
 	}
 
-	if (qla82xx_flash_set_write_enable(ha))
+	ret = qla82xx_flash_set_write_enable(ha);
+	if (ret < 0)
 		goto done_write;
 
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_WDATA, data);
diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index a981f261b304..aee3cfc7142a 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -922,6 +922,7 @@ static void ufs_mtk_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	int err;
+	struct arm_smccc_res res;
 
 	if (ufshcd_is_link_hibern8(hba)) {
 		err = ufs_mtk_link_set_lpm(hba);
@@ -941,6 +942,9 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			goto fail;
 	}
 
+	if (ufshcd_is_link_off(hba))
+		ufs_mtk_device_reset_ctrl(0, res);
+
 	return 0;
 fail:
 	/*
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3eb54937f1d8..72fd41bfbd54 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2842,7 +2842,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
  * ufshcd_exec_dev_cmd - API for sending device management requests
  * @hba: UFS hba
  * @cmd_type: specifies the type (NOP, Query...)
- * @timeout: time in seconds
+ * @timeout: timeout in milliseconds
  *
  * NOTE: Since there is only one available tag for device management commands,
  * it is expected you hold the hba->dev_cmd.lock mutex.
@@ -2872,6 +2872,9 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	}
 	tag = req->tag;
 	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
+	/* Set the timeout such that the SCSI error handler is not activated. */
+	req->timeout = msecs_to_jiffies(2 * timeout);
+	blk_mq_start_request(req);
 
 	init_completion(&wait);
 	lrbp = &hba->lrb[tag];

