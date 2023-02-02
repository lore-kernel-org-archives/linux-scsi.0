Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73321C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 18:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjBBSWg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 13:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjBBSWf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 13:22:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7546D5D7
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 10:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675362107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5NFeslmHx87tHm5RdGZpARVYzApbUzar6uFR4EWFxsU=;
        b=eEKsE/8zSPZ5qRBFAh0z5jooorZnPypiIDQCb5/ZsM8EX2dQ9NA9wPovuYaZGc4E9+1AFH
        VezQ0f0DxXeuXrQsoyJ8g90/IhStgS+NQj1K6TCea6raTnX41/uYc/s4fGJ/6RFbu4Cr4q
        ZoOl5vVEX3PqzW5SotYq9ReyOXfNpk8=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-498-aG0SER3JO_Kq0lR1oYjJtw-1; Thu, 02 Feb 2023 13:21:38 -0500
X-MC-Unique: aG0SER3JO_Kq0lR1oYjJtw-1
Received: by mail-qt1-f199.google.com with SMTP id o16-20020ac841d0000000b003b689580725so1365114qtm.22
        for <linux-scsi@vger.kernel.org>; Thu, 02 Feb 2023 10:21:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5NFeslmHx87tHm5RdGZpARVYzApbUzar6uFR4EWFxsU=;
        b=tDBkdUNVPGMyg1cfkZ7FY3hDSJjWUsxhYnI/5FOvTBPk5UXY6xSJHOWBIlXzZPTlCz
         LI5SFCwUC4aqQghwzmKitu0Vu33JGXoRaXubVOMFyvV95umQmpg6LvCK/hFCIU/+U5YV
         Q48+Xks6nhx+PeiS7v2cPWLcMew+w+Nw6X/FHlMrczK47tVcsDU77tT46/du8ZUNoL6r
         02XU6jGBwn13V9aiu1VWaEdzFw/Ga1oLLv/8LKxtGt9Byqcy7VxXE/MefiodWaWTVrPj
         5nzl1whyMax77wTzt7n09UkOkRQ868AO6ZZ823WLV37/kKG67oe/OVoAowqAiKQdD7ZC
         zw4w==
X-Gm-Message-State: AO0yUKU9ifyJsxZ+V3AXkaZwnErpLxAzVzouI43Povk2SJbrvU1OFDcj
        AQNtR8dkdldCLypMCq3ROR1EwRz0H3UhaDWk7M2LJBlNPKzMe5bweBSQgPHmBVcvxYWO1PlYON+
        gCkO5clkgsCJ0QGZHaomXQA==
X-Received: by 2002:ac8:5f48:0:b0:3b9:2dd7:d341 with SMTP id y8-20020ac85f48000000b003b92dd7d341mr12570571qta.57.1675362098269;
        Thu, 02 Feb 2023 10:21:38 -0800 (PST)
X-Google-Smtp-Source: AK7set+ei5W10Ha6gbQkx9m+1VKi0nRpdriIiyQSQj9fWxW6kK7+QU5u+Pc8bMswWIYASOKE2E0hDQ==
X-Received: by 2002:ac8:5f48:0:b0:3b9:2dd7:d341 with SMTP id y8-20020ac85f48000000b003b92dd7d341mr12570547qta.57.1675362098026;
        Thu, 02 Feb 2023 10:21:38 -0800 (PST)
Received: from fedora.redhat.com (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id e7-20020ac85dc7000000b003b68d445654sm5651893qtx.91.2023.02.02.10.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 10:21:37 -0800 (PST)
From:   Adrien Thierry <athierry@redhat.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Adrien Thierry <athierry@redhat.com>, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: probe hba and add lus synchronously
Date:   Thu,  2 Feb 2023 13:21:16 -0500
Message-Id: <20230202182116.38334-1-athierry@redhat.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During ufs initialization, hba and lus probing are asynchronous.
ufshcd_async_scan() calls ufshcd_add_lus(), which in turn initializes
devfreq for ufs. The simple ondemand governor is then loaded. If it is
build as a module, request_module() is called and throws a warning:

WARNING: CPU: 7 PID: 167 at kernel/kmod.c:136 __request_module+0x1e0/0x460
Modules linked in: crct10dif_ce llcc_qcom phy_qcom_qmp_usb ufs_qcom phy_qcom_snps_femto_v2 ufshcd_pltfrm phy_qcom_qmp_combo ufshcd_core phy_qcom_qmp_ufs qcom_wdt socinfo fuse ipv6
CPU: 7 PID: 167 Comm: kworker/u16:3 Not tainted 6.2.0-rc6-00009-g58706f7fb045 #1
Hardware name: Qualcomm SA8540P Ride (DT)
Workqueue: events_unbound async_run_entry_fn
pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __request_module+0x1e0/0x460
lr : __request_module+0x1d8/0x460
sp : ffff800009323b90
x29: ffff800009323b90 x28: 0000000000000000 x27: 0000000000000000
x26: ffff800009323d50 x25: ffff7b9045f57810 x24: ffff7b9045f57830
x23: ffffdc5a83e426e8 x22: ffffdc5ae80a9818 x21: 0000000000000001
x20: ffffdc5ae7502f98 x19: ffff7b9045f57800 x18: ffffffffffffffff
x17: 312f716572667665 x16: 642f7366752e3030 x15: 0000000000000000
x14: 000000000000021c x13: 0000000000005400 x12: ffff7b9042ed7614
x11: ffff7b9042ed7600 x10: 00000000636c0890 x9 : 0000000000000038
x8 : ffff7b9045f2c880 x7 : ffff7b9045f57c68 x6 : 0000000000000080
x5 : 0000000000000000 x4 : 8000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : ffffdc5ae5d382f0 x0 : 0000000000000001
Call trace:
 __request_module+0x1e0/0x460
 try_then_request_governor+0x7c/0x100
 devfreq_add_device+0x4b0/0x5fc
 ufshcd_async_scan+0x1d4/0x310 [ufshcd_core]
 async_run_entry_fn+0x34/0xe0
 process_one_work+0x1d0/0x320
 worker_thread+0x14c/0x444
 kthread+0x10c/0x110
 ret_from_fork+0x10/0x20

This occurs because synchronous module loading from async is not
allowed. According to __request_module():

/*
 * We don't allow synchronous module loading from async.  Module
 * init may invoke async_synchronize_full() which will end up
 * waiting for this task which already is waiting for the module
 * loading to complete, leading to a deadlock.
 */

I experienced such a deadlock on the Qualcomm QDrive3/sa8540p-ride. With
DEVFREQ_GOV_SIMPLE_ONDEMAND=m, the boot hangs after the warning.

This patch fixes both the warning and the deadlock, by probing hba and
lus synchronously during ufs initialization.

Signed-off-by: Adrien Thierry <athierry@redhat.com>
---
 drivers/ufs/core/ufshcd.c | 44 +++++++++++----------------------------
 1 file changed, 12 insertions(+), 32 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3a1c4d31e010..2cf8e09b1a9d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -245,7 +245,6 @@ static const struct ufs_dev_quirk ufs_fixups[] = {
 };
 
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba);
-static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
@@ -8263,36 +8262,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 	return ret;
 }
 
-/**
- * ufshcd_async_scan - asynchronous execution for probing hba
- * @data: data pointer to pass to this function
- * @cookie: cookie data
- */
-static void ufshcd_async_scan(void *data, async_cookie_t cookie)
-{
-	struct ufs_hba *hba = (struct ufs_hba *)data;
-	int ret;
-
-	down(&hba->host_sem);
-	/* Initialize hba, detect and initialize UFS device */
-	ret = ufshcd_probe_hba(hba, true);
-	up(&hba->host_sem);
-	if (ret)
-		goto out;
-
-	/* Probe and add UFS logical units  */
-	ret = ufshcd_add_lus(hba);
-out:
-	/*
-	 * If we failed to initialize the device or the device is not
-	 * present, turn off the power/clocks etc.
-	 */
-	if (ret) {
-		pm_runtime_put_sync(hba->dev);
-		ufshcd_hba_exit(hba);
-	}
-}
-
 static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 {
 	struct ufs_hba *hba = shost_priv(scmd->device->host);
@@ -9896,12 +9865,23 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
 
-	async_schedule(ufshcd_async_scan, hba);
+	/* Initialize hba, detect and initialize UFS device */
+	err = ufshcd_probe_hba(hba, true);
+	if (err)
+		goto out_power_off;
+
+	/* Probe and add UFS logical units  */
+	err = ufshcd_add_lus(hba);
+	if (err)
+		goto out_power_off;
+
 	ufs_sysfs_add_nodes(hba->dev);
 
 	device_enable_async_suspend(dev);
 	return 0;
 
+out_power_off:
+	pm_runtime_put_sync(hba->dev);
 free_tmf_queue:
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
-- 
2.39.1

