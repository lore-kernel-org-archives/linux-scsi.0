Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598EEC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 19:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 453C3619E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 19:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347727AbhI3Ty2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 15:54:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:32846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347693AbhI3Ty1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 15:54:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0404C61528;
        Thu, 30 Sep 2021 19:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633031564;
        bh=GA+Bt6Ll0ftBs+symFc3pp2Z1viCG3DDQvC1yjRiCTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLnLNvif/vR0p4GvtIFsPMM34IR+7yyTuWFiZo4efNpepL1FC2twcQcb/+KOcHGCD
         foV5fouiOkzrnM6T2tD2Nh0w6yJ83e3tHJs7/7tkgaBPhYFCL3N0ukPUVidWmz8SZV
         Rtg2W/n3xN5upMHkwewpLHJSdDJcJk6U1LR/4TbM4mq4s9L9KzDunZ6lLJSEjhgT09
         2MqL3nu7oIgxhayO/v+EeN5DOOXWm1jP8Qzg02G1cZ53lDTCxo7v7So+idRfYifQGe
         sfnUfHYzozvgEpw0ch6ddvII8WVXoaTHMPlGuXzrRYDz1VtcJpTYjKYRd4B1+G/PD0
         /Gq5ZxEzmBsLg==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, bvanassche@acm.org
Cc:     Bart Van Assche <bvanassche@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/2] scsi: ufs: Stop clearing unit attentions
Date:   Thu, 30 Sep 2021 12:52:37 -0700
Message-Id: <20210930195237.1521436-2-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
In-Reply-To: <20210930195237.1521436-1-jaegeuk@kernel.org>
References: <20210930195237.1521436-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@google.com>

Commit aa53f580e67b ("scsi: ufs: Minor adjustments to error handling")
introduced a ufshcd_clear_ua_wluns() call in
ufshcd_err_handling_unprepare(). As explained in detail by Adrian Hunter,
this can trigger a deadlock. Avoid that deadlock by removing the code that
clears the unit attention. This is safe because the only software that
relies on clearing unit attentions is the Android Trusty software and
because support for handling unit attentions has been added in the Trusty software.

See also https://lore.kernel.org/linux-scsi/20210930124224.114031-2-adrian.hunter@intel.com/

Cc: Adrian Hunter <adrian.hunter@intel.com>
Fixes: aa53f580e67b ("scsi: ufs: Minor adjustments to error handling")
Signed-off-by: Bart Van Assche <bvanassche@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 176 +-------------------------------------
 drivers/scsi/ufs/ufshcd.h |   3 -
 2 files changed, 1 insertion(+), 178 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1f21d371e231..4add5e990de9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -224,7 +224,6 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
-static int ufshcd_clear_ua_wluns(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
@@ -4109,8 +4108,6 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 	if (ret)
 		dev_err(hba->dev, "%s: link recovery failed, err %d",
 			__func__, ret);
-	else
-		ufshcd_clear_ua_wluns(hba);
 
 	return ret;
 }
@@ -5974,7 +5971,6 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 	ufshcd_release(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
-	ufshcd_clear_ua_wluns(hba);
 	ufshcd_rpm_put(hba);
 }
 
@@ -7907,8 +7903,6 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
-	ufshcd_clear_ua_wluns(hba);
-
 	/* Initialize devfreq after UFS device is detected */
 	if (ufshcd_is_clkscaling_supported(hba)) {
 		memcpy(&hba->clk_scaling.saved_pwr_info.info,
@@ -7934,116 +7928,6 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	return ret;
 }
 
-static void ufshcd_request_sense_done(struct request *rq, blk_status_t error)
-{
-	if (error != BLK_STS_OK)
-		pr_err("%s: REQUEST SENSE failed (%d)\n", __func__, error);
-	kfree(rq->end_io_data);
-	blk_put_request(rq);
-}
-
-static int
-ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
-{
-	/*
-	 * Some UFS devices clear unit attention condition only if the sense
-	 * size used (UFS_SENSE_SIZE in this case) is non-zero.
-	 */
-	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, UFS_SENSE_SIZE, 0};
-	struct scsi_request *rq;
-	struct request *req;
-	char *buffer;
-	int ret;
-
-	buffer = kzalloc(UFS_SENSE_SIZE, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-
-	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN,
-			      /*flags=*/BLK_MQ_REQ_PM);
-	if (IS_ERR(req)) {
-		ret = PTR_ERR(req);
-		goto out_free;
-	}
-
-	ret = blk_rq_map_kern(sdev->request_queue, req,
-			      buffer, UFS_SENSE_SIZE, GFP_NOIO);
-	if (ret)
-		goto out_put;
-
-	rq = scsi_req(req);
-	rq->cmd_len = ARRAY_SIZE(cmd);
-	memcpy(rq->cmd, cmd, rq->cmd_len);
-	rq->retries = 3;
-	req->timeout = 1 * HZ;
-	req->rq_flags |= RQF_PM | RQF_QUIET;
-	req->end_io_data = buffer;
-
-	blk_execute_rq_nowait(/*bd_disk=*/NULL, req, /*at_head=*/true,
-			      ufshcd_request_sense_done);
-	return 0;
-
-out_put:
-	blk_put_request(req);
-out_free:
-	kfree(buffer);
-	return ret;
-}
-
-static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
-{
-	struct scsi_device *sdp;
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (wlun == UFS_UPIU_UFS_DEVICE_WLUN)
-		sdp = hba->sdev_ufs_device;
-	else if (wlun == UFS_UPIU_RPMB_WLUN)
-		sdp = hba->sdev_rpmb;
-	else
-		BUG();
-	if (sdp) {
-		ret = scsi_device_get(sdp);
-		if (!ret && !scsi_device_online(sdp)) {
-			ret = -ENODEV;
-			scsi_device_put(sdp);
-		}
-	} else {
-		ret = -ENODEV;
-	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	if (ret)
-		goto out_err;
-
-	ret = ufshcd_request_sense_async(hba, sdp);
-	scsi_device_put(sdp);
-out_err:
-	if (ret)
-		dev_err(hba->dev, "%s: UAC clear LU=%x ret = %d\n",
-				__func__, wlun, ret);
-	return ret;
-}
-
-static int ufshcd_clear_ua_wluns(struct ufs_hba *hba)
-{
-	int ret = 0;
-
-	if (!hba->wlun_dev_clr_ua)
-		goto out;
-
-	ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_UFS_DEVICE_WLUN);
-	if (!ret)
-		ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_RPMB_WLUN);
-	if (!ret)
-		hba->wlun_dev_clr_ua = false;
-out:
-	if (ret)
-		dev_err(hba->dev, "%s: Failed to clear UAC WLUNS ret = %d\n",
-				__func__, ret);
-	return ret;
-}
-
 /**
  * ufshcd_probe_hba - probe hba to detect device and initialize it
  * @hba: per-adapter instance
@@ -8094,8 +7978,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 	/* UFS device is also active now */
 	ufshcd_set_ufs_dev_active(hba);
 	ufshcd_force_reset_auto_bkops(hba);
-	hba->wlun_dev_clr_ua = true;
-	hba->wlun_rpmb_clr_ua = true;
 
 	/* Gear up to HS gear if supported */
 	if (hba->max_pwr_info.is_valid) {
@@ -8655,8 +8537,6 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * handling context.
 	 */
 	hba->host->eh_noresume = 1;
-	if (hba->wlun_dev_clr_ua)
-		ufshcd_clear_ua_wlun(hba, UFS_UPIU_UFS_DEVICE_WLUN);
 
 	cmd[4] = pwr_mode << 4;
 
@@ -9819,49 +9699,6 @@ static struct scsi_driver ufs_dev_wlun_template = {
 	},
 };
 
-static int ufshcd_rpmb_probe(struct device *dev)
-{
-	return is_rpmb_wlun(to_scsi_device(dev)) ? 0 : -ENODEV;
-}
-
-static inline int ufshcd_clear_rpmb_uac(struct ufs_hba *hba)
-{
-	int ret = 0;
-
-	if (!hba->wlun_rpmb_clr_ua)
-		return 0;
-	ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_RPMB_WLUN);
-	if (!ret)
-		hba->wlun_rpmb_clr_ua = 0;
-	return ret;
-}
-
-#ifdef CONFIG_PM
-static int ufshcd_rpmb_resume(struct device *dev)
-{
-	struct ufs_hba *hba = wlun_dev_to_hba(dev);
-
-	if (hba->sdev_rpmb)
-		ufshcd_clear_rpmb_uac(hba);
-	return 0;
-}
-#endif
-
-static const struct dev_pm_ops ufs_rpmb_pm_ops = {
-	SET_RUNTIME_PM_OPS(NULL, ufshcd_rpmb_resume, NULL)
-	SET_SYSTEM_SLEEP_PM_OPS(NULL, ufshcd_rpmb_resume)
-};
-
-/* ufs_rpmb_wlun_template - Describes UFS RPMB WLUN. Used only to send UAC. */
-static struct scsi_driver ufs_rpmb_wlun_template = {
-	.gendrv = {
-		.name = "ufs_rpmb_wlun",
-		.owner = THIS_MODULE,
-		.probe = ufshcd_rpmb_probe,
-		.pm = &ufs_rpmb_pm_ops,
-	},
-};
-
 static int __init ufshcd_core_init(void)
 {
 	int ret;
@@ -9870,24 +9707,13 @@ static int __init ufshcd_core_init(void)
 
 	ret = scsi_register_driver(&ufs_dev_wlun_template.gendrv);
 	if (ret)
-		goto debugfs_exit;
-
-	ret = scsi_register_driver(&ufs_rpmb_wlun_template.gendrv);
-	if (ret)
-		goto unregister;
-
-	return ret;
-unregister:
-	scsi_unregister_driver(&ufs_dev_wlun_template.gendrv);
-debugfs_exit:
-	ufs_debugfs_exit();
+		ufs_debugfs_exit();
 	return ret;
 }
 
 static void __exit ufshcd_core_exit(void)
 {
 	ufs_debugfs_exit();
-	scsi_unregister_driver(&ufs_rpmb_wlun_template.gendrv);
 	scsi_unregister_driver(&ufs_dev_wlun_template.gendrv);
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 52ea6f350b18..b414491a8240 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -865,9 +865,6 @@ struct ufs_hba {
 	struct ufs_vreg_info vreg_info;
 	struct list_head clk_list_head;
 
-	bool wlun_dev_clr_ua;
-	bool wlun_rpmb_clr_ua;
-
 	/* Number of requests aborts */
 	int req_abort_count;
 
-- 
2.33.0.800.g4c38ced690-goog

