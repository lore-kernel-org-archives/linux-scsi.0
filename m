Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D807C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jan 2021 20:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 181DC2245C
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jan 2021 20:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbhAPUWD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Jan 2021 15:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbhAPUWB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Jan 2021 15:22:01 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFFCC061573;
        Sat, 16 Jan 2021 12:21:21 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id CAEF612804DA;
        Sat, 16 Jan 2021 12:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1610828478;
        bh=nj2sm4qBvZLlJrize0jHP39kOza/vpXLicMWy7FpLkk=;
        h=Message-ID:Subject:From:To:Date:From;
        b=NPj4mDw5MdPkuJWVoVex4dyu/bExbjNoyOblxOEQAf6pm4cCgbt0mlpkgGBMBE5Gz
         KofxWFT8BF3Svgrzo833sAHc5c2QkRGy2mi0/bxFcVIWwSt3jkLyNJdtkQZAeeV9EU
         bcgTOEUl+xXdj5s10zU0QFa+Ua4CiEwUUNSYFT+g=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7Le7QVNuI8fg; Sat, 16 Jan 2021 12:21:18 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 67C8F12804AB;
        Sat, 16 Jan 2021 12:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1610828478;
        bh=nj2sm4qBvZLlJrize0jHP39kOza/vpXLicMWy7FpLkk=;
        h=Message-ID:Subject:From:To:Date:From;
        b=NPj4mDw5MdPkuJWVoVex4dyu/bExbjNoyOblxOEQAf6pm4cCgbt0mlpkgGBMBE5Gz
         KofxWFT8BF3Svgrzo833sAHc5c2QkRGy2mi0/bxFcVIWwSt3jkLyNJdtkQZAeeV9EU
         bcgTOEUl+xXdj5s10zU0QFa+Ua4CiEwUUNSYFT+g=
Message-ID: <1aef3ddd04fcbfe8259f21d7c8a80404770b8af6.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.11-rc3
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 16 Jan 2021 12:21:17 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Nine minor fixes, 7 in drivers and 2 in the core SCSI disk driver (sd)
which should be harmless involving removing an unused variable and
quietening a spurious warning.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Can Guo (1):
      scsi: ufs: Correct the LUN used in eh_device_reset_handler() callback

Colin Ian King (1):
      scsi: mpt3sas: Fix spelling mistake in Kconfig "compatiblity" -> "compatibility"

Dinghao Liu (1):
      scsi: scsi_debug: Fix memleak in scsi_debug_init()

Ewan D. Milne (1):
      scsi: sd: Suppress spurious errors when WRITE SAME is being disabled

Kiwoong Kim (1):
      scsi: ufs: Relocate flush of exceptional event

Lukas Bulwahn (1):
      scsi: sd: Remove obsolete variable in sd_remove()

Nilesh Javali (1):
      scsi: qedi: Correct max length of CHAP secret

Stanley Chu (2):
      scsi: ufs: Relax the condition of UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
      scsi: ufs: Fix possible power drain during system suspend


And the diffstat:

 drivers/scsi/mpt3sas/Kconfig  |  2 +-
 drivers/scsi/qedi/qedi_main.c |  4 ++--
 drivers/scsi/scsi_debug.c     |  5 +++--
 drivers/scsi/sd.c             |  6 +++---
 drivers/scsi/ufs/ufshcd.c     | 24 ++++++++++--------------
 5 files changed, 19 insertions(+), 22 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/mpt3sas/Kconfig b/drivers/scsi/mpt3sas/Kconfig
index 86209455172d..c299f7e078fb 100644
--- a/drivers/scsi/mpt3sas/Kconfig
+++ b/drivers/scsi/mpt3sas/Kconfig
@@ -79,5 +79,5 @@ config SCSI_MPT2SAS
 	select SCSI_MPT3SAS
 	depends on PCI && SCSI
 	help
-	Dummy config option for backwards compatiblity: configure the MPT3SAS
+	Dummy config option for backwards compatibility: configure the MPT3SAS
 	driver instead.
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index f5fc7f518f8a..47ad64b06623 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2245,7 +2245,7 @@ qedi_show_boot_tgt_info(struct qedi_ctx *qedi, int type,
 			     chap_name);
 		break;
 	case ISCSI_BOOT_TGT_CHAP_SECRET:
-		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
+		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN,
 			     chap_secret);
 		break;
 	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
@@ -2253,7 +2253,7 @@ qedi_show_boot_tgt_info(struct qedi_ctx *qedi, int type,
 			     mchap_name);
 		break;
 	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
-		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
+		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN,
 			     mchap_secret);
 		break;
 	case ISCSI_BOOT_TGT_FLAGS:
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 24c0f7ec0351..4a08c450b756 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6740,7 +6740,7 @@ static int __init scsi_debug_init(void)
 		k = sdeb_zbc_model_str(sdeb_zbc_model_s);
 		if (k < 0) {
 			ret = k;
-			goto free_vm;
+			goto free_q_arr;
 		}
 		sdeb_zbc_model = k;
 		switch (sdeb_zbc_model) {
@@ -6753,7 +6753,8 @@ static int __init scsi_debug_init(void)
 			break;
 		default:
 			pr_err("Invalid ZBC model\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_q_arr;
 		}
 	}
 	if (sdeb_zbc_model != BLK_ZONED_NONE) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 679c2c025047..a3d2d4bc4a3d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -984,8 +984,10 @@ static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 		}
 	}
 
-	if (sdp->no_write_same)
+	if (sdp->no_write_same) {
+		rq->rq_flags |= RQF_QUIET;
 		return BLK_STS_TARGET;
+	}
 
 	if (sdkp->ws16 || lba > 0xffffffff || nr_blocks > 0xffff)
 		return sd_setup_write_same16_cmnd(cmd, false);
@@ -3510,10 +3512,8 @@ static int sd_probe(struct device *dev)
 static int sd_remove(struct device *dev)
 {
 	struct scsi_disk *sdkp;
-	dev_t devt;
 
 	sdkp = dev_get_drvdata(dev);
-	devt = disk_devt(sdkp->disk);
 	scsi_autopm_get_device(sdkp->device);
 
 	async_synchronize_full_domain(&scsi_sd_pm_domain);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 82ad31781bc9..e31d2c5c7b23 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -289,7 +289,8 @@ static inline void ufshcd_wb_config(struct ufs_hba *hba)
 	if (ret)
 		dev_err(hba->dev, "%s: En WB flush during H8: failed: %d\n",
 			__func__, ret);
-	ufshcd_wb_toggle_flush(hba, true);
+	if (!(hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL))
+		ufshcd_wb_toggle_flush(hba, true);
 }
 
 static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
@@ -5436,9 +5437,6 @@ static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
 
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
 {
-	if (hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL)
-		return;
-
 	if (enable)
 		ufshcd_wb_buf_flush_enable(hba);
 	else
@@ -6661,19 +6659,16 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
-	unsigned int tag;
 	u32 pos;
 	int err;
-	u8 resp = 0xF;
-	struct ufshcd_lrb *lrbp;
+	u8 resp = 0xF, lun;
 	unsigned long flags;
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
-	tag = cmd->request->tag;
 
-	lrbp = &hba->lrb[tag];
-	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, 0, UFS_LOGICAL_RESET, &resp);
+	lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
+	err = ufshcd_issue_tm_cmd(hba, lun, 0, UFS_LOGICAL_RESET, &resp);
 	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
 		if (!err)
 			err = resp;
@@ -6682,7 +6677,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 
 	/* clear the commands that were pending for corresponding LUN */
 	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
-		if (hba->lrb[pos].lun == lrbp->lun) {
+		if (hba->lrb[pos].lun == lun) {
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
@@ -8698,6 +8693,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			ufshcd_wb_need_flush(hba));
 	}
 
+	flush_work(&hba->eeh_work);
+
 	if (req_dev_pwr_mode != hba->curr_dev_pwr_mode) {
 		if (!ufshcd_is_runtime_pm(pm_op))
 			/* ensure that bkops is disabled */
@@ -8710,8 +8707,6 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		}
 	}
 
-	flush_work(&hba->eeh_work);
-
 	/*
 	 * In the case of DeepSleep, the device is expected to remain powered
 	 * with the link off, so do not check for bkops.
@@ -8938,7 +8933,8 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
 	     hba->curr_dev_pwr_mode) &&
 	    (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
-	     hba->uic_link_state))
+	     hba->uic_link_state) &&
+	     !hba->dev_info.b_rpm_dev_flush_capable)
 		goto out;
 
 	if (pm_runtime_suspended(hba->dev)) {


