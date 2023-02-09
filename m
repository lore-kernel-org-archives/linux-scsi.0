Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC4FC636D3
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Feb 2023 21:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjBIVYL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Feb 2023 16:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBIVYK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2023 16:24:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BFB28D28
        for <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2023 13:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675977800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pqefo/s+/M/ZRncl69T4Npv05d21nr88kMy7hmw1oz4=;
        b=Ecy/VeKEKGB9YD1biDLY3VxI8VFAQ+5Q6xZZwUi4pRjJxZXURmXXXnf1sAPTbyf5x7Nkq8
        xw97EtFb08eQJVu7FgagKQFhuR3mNUFbEq/DoqA7NRVSZLVd71N31hOqvw1aMWIoHd585n
        Qw0KkDymDHgw8tHfalAbRkkts/gYXjA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-54-IPItVxiGMIKW5-uKav9fUg-1; Thu, 09 Feb 2023 16:23:20 -0500
X-MC-Unique: IPItVxiGMIKW5-uKav9fUg-1
Received: by mail-qt1-f198.google.com with SMTP id g2-20020ac870c2000000b003b9c8ab53e9so1876779qtp.6
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2023 13:23:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pqefo/s+/M/ZRncl69T4Npv05d21nr88kMy7hmw1oz4=;
        b=wHX/FmwQL7grar2eNgyhXiooAMOJwQi8pizSQkyRKfCAe/DF2f+fM8VPM1bPOASk5R
         /VuGHO1bRGNUFmPmUKqabB1N2z8ZWKtyMnT5lxht1TLN6UurBgyZjp0b8hJHtFDRp3ta
         IXt9kBQgImMDpolcpRMjINIhcgpEUMyanU2FM6ax6jiQDLeWp+sJJ/KvXTgTz+8tPTtj
         W2gVOCEyJZdRjrcvazlFbiF72LCNAkmjhPd6m8cMlVTgK2b3WkFoUwKgzfCI+4VDijTk
         RDmTm0Qzyjx57mKYvlqgH4Adb8oVfuvgJwV5Gc3IY3RYn+6gndlF+0JtN+DkRO1W8n5e
         YIug==
X-Gm-Message-State: AO0yUKX4LoClxUQ0ni9WK220G63GunX3nUXMXsUIVwgjIsXEoCihWCMe
        Gfm5QbYJHUUg+KjiQ2jZgj2y7v2mgFSNTFRN/UtMKWDXhlxjd8PHnHWem7+Cet+TEy0cgBSf4sD
        Ag4VYTDhvA+ixsAnbfZJ3gw==
X-Received: by 2002:a05:622a:4cc:b0:3a9:818f:db3d with SMTP id q12-20020a05622a04cc00b003a9818fdb3dmr21081989qtx.53.1675977798575;
        Thu, 09 Feb 2023 13:23:18 -0800 (PST)
X-Google-Smtp-Source: AK7set/x/BM6IBfwUmAkt81ezeoQ9kM7BhGSjkd5MrsVYI8FRS7Nv34Df0OubfiTvsaZeGj1lsFWoQ==
X-Received: by 2002:a05:622a:4cc:b0:3a9:818f:db3d with SMTP id q12-20020a05622a04cc00b003a9818fdb3dmr21081969qtx.53.1675977798311;
        Thu, 09 Feb 2023 13:23:18 -0800 (PST)
Received: from fedora.redhat.com (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id b187-20020a3799c4000000b0071d57a0eb17sm2101204qke.136.2023.02.09.13.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 13:23:17 -0800 (PST)
From:   Adrien Thierry <athierry@redhat.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Adrien Thierry <athierry@redhat.com>, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: initialize devfreq synchronously
Date:   Thu,  9 Feb 2023 16:14:56 -0500
Message-Id: <20230209211456.54250-1-athierry@redhat.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During ufs initialization, devfreq initialization is asynchronous:
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

This patch fixes both the warning and the deadlock, by moving devfreq
initialization out of the async routine.

I tested this on the sa8540p-ride by using fio to put the UFS under
load, and printing the trace generated by
/sys/kernel/tracing/events/ufs/ufshcd_clk_scaling events. The trace
looks similar with and without the change.

Signed-off-by: Adrien Thierry <athierry@redhat.com>
---
 drivers/ufs/core/ufshcd.c | 40 ++++++++++++++++++++++-----------------
 include/ufs/ufshcd.h      |  1 +
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3a1c4d31e010..17189934d1ae 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1357,6 +1357,9 @@ static int ufshcd_devfreq_target(struct device *dev,
 	struct ufs_clk_info *clki;
 	unsigned long irq_flags;
 
+	if (!hba->is_initialized)
+		return 0;
+
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return -EINVAL;
 
@@ -8136,22 +8139,6 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
-	/* Initialize devfreq after UFS device is detected */
-	if (ufshcd_is_clkscaling_supported(hba)) {
-		memcpy(&hba->clk_scaling.saved_pwr_info.info,
-			&hba->pwr_info,
-			sizeof(struct ufs_pa_layer_attr));
-		hba->clk_scaling.saved_pwr_info.is_valid = true;
-		hba->clk_scaling.is_allowed = true;
-
-		ret = ufshcd_devfreq_init(hba);
-		if (ret)
-			goto out;
-
-		hba->clk_scaling.is_enabled = true;
-		ufshcd_init_clk_scaling_sysfs(hba);
-	}
-
 	ufs_bsg_probe(hba);
 	ufshpb_init(hba);
 	scsi_scan_host(hba->host);
@@ -8290,7 +8277,8 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	if (ret) {
 		pm_runtime_put_sync(hba->dev);
 		ufshcd_hba_exit(hba);
-	}
+	} else
+		hba->is_initialized = true;
 }
 
 static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
@@ -9896,12 +9884,30 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
 
+	/* Initialize devfreq */
+	if (ufshcd_is_clkscaling_supported(hba)) {
+		memcpy(&hba->clk_scaling.saved_pwr_info.info,
+			&hba->pwr_info,
+			sizeof(struct ufs_pa_layer_attr));
+		hba->clk_scaling.saved_pwr_info.is_valid = true;
+		hba->clk_scaling.is_allowed = true;
+
+		err = ufshcd_devfreq_init(hba);
+		if (err)
+			goto out_power_off;
+
+		hba->clk_scaling.is_enabled = true;
+		ufshcd_init_clk_scaling_sysfs(hba);
+	}
+
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
 
 	device_enable_async_suspend(dev);
 	return 0;
 
+out_power_off:
+	pm_runtime_put_sync(dev);
 free_tmf_queue:
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 727084cd79be..58a78dcd3472 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -896,6 +896,7 @@ struct ufs_hba {
 	struct completion *uic_async_done;
 
 	enum ufshcd_state ufshcd_state;
+	bool is_initialized;
 	u32 eh_flags;
 	u32 intr_mask;
 	u16 ee_ctrl_mask;
-- 
2.39.1

