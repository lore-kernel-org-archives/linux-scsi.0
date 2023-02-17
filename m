Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66D5C05027
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Feb 2023 19:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjBQTp0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Feb 2023 14:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBQTpZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2023 14:45:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6844F5F269
        for <linux-scsi@vger.kernel.org>; Fri, 17 Feb 2023 11:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676663081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lwsNbLH52LEtkuVzLaB5Gtg76WY2cYHqNtqeTv+TF9c=;
        b=fK2YwICFfnte9BirU7FbmCYXrVmKFhvFc3RE7PRSZmudEawWtLrUqRrgbI04MAxhXm1lfT
        GSn7PXp/QYAL6pu3zqLjdp4IHnqZZtu1fxSaF3Fw2OhfAP3hfdjw4tKhTrQG7mleGSVDcd
        O7O2eMUxtwkSNtYPUoFz2WutofJgxf8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-272-diCJ6cqiPpG_WZ3VKiwX1g-1; Fri, 17 Feb 2023 14:44:38 -0500
X-MC-Unique: diCJ6cqiPpG_WZ3VKiwX1g-1
Received: by mail-qk1-f200.google.com with SMTP id bk26-20020a05620a1a1a00b0073b88cae2f5so708879qkb.8
        for <linux-scsi@vger.kernel.org>; Fri, 17 Feb 2023 11:44:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lwsNbLH52LEtkuVzLaB5Gtg76WY2cYHqNtqeTv+TF9c=;
        b=VjQ1P/4R/FhiOciO1IckhdRDUZ2GBs/UGhGIU3jLYVCHX7VKIbgXeitfKGvLcl4Cjd
         4DszF9sKOJxpIiPs61/LAjeR8ddEsaH/GcA61wMFhxEPmQeybXdzndNdkCrtQfn5npXJ
         pxp8LsakHLJrBy6lNemKdiE4S6pchL9EUIi+yyNddUPgGYB/qu8rWV+K5zP9VjveY4GY
         fl7qPSZrZFUZ9FBDY+bPRYMUEd33Nrlc2Z6KHsT1U4u49EqiOM+lvqFr+gP4YueRI8Tg
         EEL0YdCEcuz4kneYXdJtzhHJeM4LwVhno/OJoczi617wmiuc2aqN/jdmG6nxKOxCFLw+
         FMvA==
X-Gm-Message-State: AO0yUKU+evI1dRvntLvdE+iPRnzcV7tLGkKJevoWYP63Ks3YNXOnJXZP
        5WDi7ni2ojWzbBMzptbwia+1pF4Ik25/4dBTQwSeiWorFoVYoB9Zyl0BREcVXFBSnQUQp7Z2g/N
        28Psxotd+Lnhi7UcuW5q4Hw==
X-Received: by 2002:ac8:7c52:0:b0:3b8:6bf8:9584 with SMTP id o18-20020ac87c52000000b003b86bf89584mr4324310qtv.35.1676663078108;
        Fri, 17 Feb 2023 11:44:38 -0800 (PST)
X-Google-Smtp-Source: AK7set8muo9wotLEsrDwf3K3Jmy2o7BJNrj2+vMc8ZG2snzwGQ7SZVRSgK9i9kzUUeOA77zIk+5L+Q==
X-Received: by 2002:ac8:7c52:0:b0:3b8:6bf8:9584 with SMTP id o18-20020ac87c52000000b003b86bf89584mr4324289qtv.35.1676663077796;
        Fri, 17 Feb 2023 11:44:37 -0800 (PST)
Received: from fedora.redhat.com (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id i129-20020a37b887000000b007068b49b8absm3761272qkf.62.2023.02.17.11.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 11:44:36 -0800 (PST)
From:   Adrien Thierry <athierry@redhat.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Adrien Thierry <athierry@redhat.com>, linux-scsi@vger.kernel.org
Subject: [PATCH v3] scsi: ufs: initialize devfreq synchronously
Date:   Fri, 17 Feb 2023 14:44:22 -0500
Message-Id: <20230217194423.42553-1-athierry@redhat.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During ufs initialization, devfreq initialization is asynchronous:
ufshcd_async_scan() calls ufshcd_add_lus(), which in turn initializes
devfreq for ufs. The simple ondemand governor is then loaded. If it is
built as a module, request_module() is called and throws a warning:

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
v3: Addressed Bart's comments
v2: Addressed Bart's comments

 drivers/ufs/core/ufshcd.c | 47 ++++++++++++++++++++++++++-------------
 include/ufs/ufshcd.h      |  1 +
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3a1c4d31e010..2c22a1367440 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1357,6 +1357,13 @@ static int ufshcd_devfreq_target(struct device *dev,
 	struct ufs_clk_info *clki;
 	unsigned long irq_flags;
 
+	/*
+	 * Skip devfreq if ufs initialization is not finished.
+	 * Otherwise ufs could be in a inconsistent state.
+	 */
+	if (!smp_load_acquire(&hba->logical_unit_scan_finished))
+		return 0;
+
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return -EINVAL;
 
@@ -8136,22 +8143,6 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
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
@@ -8290,6 +8281,12 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	if (ret) {
 		pm_runtime_put_sync(hba->dev);
 		ufshcd_hba_exit(hba);
+	} else {
+		/*
+		 * Make sure that when reader code sees ufs initialization has finished,
+		 * all initialization steps have really been executed.
+		 */
+		smp_store_release(&hba->logical_unit_scan_finished, true);
 	}
 }
 
@@ -9896,12 +9893,30 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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
+			goto rpm_put_sync;
+
+		hba->clk_scaling.is_enabled = true;
+		ufshcd_init_clk_scaling_sysfs(hba);
+	}
+
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
 
 	device_enable_async_suspend(dev);
 	return 0;
 
+rpm_put_sync:
+	pm_runtime_put_sync(dev);
 free_tmf_queue:
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 727084cd79be..941ede501367 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -896,6 +896,7 @@ struct ufs_hba {
 	struct completion *uic_async_done;
 
 	enum ufshcd_state ufshcd_state;
+	bool logical_unit_scan_finished;
 	u32 eh_flags;
 	u32 intr_mask;
 	u16 ee_ctrl_mask;
-- 
2.39.1

