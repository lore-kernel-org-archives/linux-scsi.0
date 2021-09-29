Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE268C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 20:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A903617E1
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 20:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346344AbhI2UIg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 16:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346299AbhI2UIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 16:08:35 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F52C06161C;
        Wed, 29 Sep 2021 13:06:53 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id g19-20020a1c9d13000000b003075062d4daso2614856wme.0;
        Wed, 29 Sep 2021 13:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FuRM31Y4bq6o7rbsG6372Y73WTmoedFCgrX/ztAzv1A=;
        b=qYR2opfXcO/WFG17iPhnFfCWAZP+YhJ4VzKgq2TJMODP3aROIPPXwklqLrwjidycD5
         vUxTo/7NW2SETFT4fI8ANUVBNxASecFiUlXifFek55pO/qyjfLRssAjjr6NUlN5/MLq0
         J5WzGVUToeaX+Zv8u9SuVs9/GqAk+NaSCtkSul/nfiStKr+Of/yb9lp9BUWAejlariAR
         jLZSUw7v+zuZ6g/lx4aTQxC60HnGwf0zDDctg3EBKPs24Vj80ZxbU4OwUnLIJBrMf6Ro
         cY1tYAfO9R7fhY9dhR008SMGpygrHZXOXfUVvQYo0BXWB6D0OcCN8b2uVTHnvZL83kIL
         R7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FuRM31Y4bq6o7rbsG6372Y73WTmoedFCgrX/ztAzv1A=;
        b=ypKGvVB7wzKOjhbt0DFvCnpnSGsNlYiwMTUeLweOFsVB1TVC5FD98y4+zvNBzYGEpD
         nrjl+nTL/f6FtuBiroTKe/G5OBbbTD31B8fn6KyUra/FpknuUsFI9qiv0SkOdh3uQEJi
         67lpyWsqbZzKchkuq1/EEIx77t95gnNe8zJXODODV8KaQKBFnA6iSbNngUsZKeCeFsby
         zqaytEdOV21fAlt16PAdXIaOE9kJ8JLRyP95AWteLnkNKvNsCwDxEPC2Bk+yG5nYoDCw
         OLf9lhrobVf+Qbn5+3gb3GH/VIfgTrD9OqVbms/DOfTqgS6aafG5WXZSauMaT/hG3MjQ
         jsWg==
X-Gm-Message-State: AOAM533AG+rBT3GodId6ZTRTLLMQdHSNCGDy/X6jBOvZ1rO6+/NHYXHK
        thdIyDW67JgdcmaL7RJ2+zg=
X-Google-Smtp-Source: ABdhPJy98tW5mj9fxHZ/i3jm2JmvFOLFQlTxIvMv6CsXNpvFirTWZJ7ZmiVvJnyDAH8JPQkde6xRkA==
X-Received: by 2002:a1c:a70d:: with SMTP id q13mr1663799wme.148.1632946012074;
        Wed, 29 Sep 2021 13:06:52 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94717cf3fe089f40c55d147be.dip0.t-ipconnect.de. [2003:e9:4717:cf3f:e089:f40c:55d1:47be])
        by smtp.gmail.com with ESMTPSA id l17sm910405wrx.24.2021.09.29.13.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 13:06:51 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] scsi: ufs: ufshpb: Fix NULL pointer dereference
Date:   Wed, 29 Sep 2021 22:06:38 +0200
Message-Id: <20210929200640.828611-2-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210929200640.828611-1-huobean@gmail.com>
References: <20210929200640.828611-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Before ufshcd_scsi_add_wlus() is executed, call ufshcd_rpm_{get/put}_sync(),
"Null pointer dereference" issue will be triggered. Because hba->sdev_ufs_device
is initialized in ufshcd_scsi_add_wlus() later.

Unable to handle kernel NULL pointer dereference at virtual address
0000000000000348
Mem abort info:
  ESR = 0x96000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
[0000000000000348] user address but active_mm is swapper
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 91 Comm: kworker/u16:1 Not tainted 5.15.0-rc1-beanhuo-linaro-1423
Hardware name: MicronRB (DT)
Workqueue: events_unbound async_run_entry_fn
pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : pm_runtime_drop_link+0x128/0x338
lr : ufshpb_get_dev_info+0x8c/0x148
sp : ffff800012573c10
x29: ffff800012573c10 x28: 0000000000000000 x27: 0000000000000003
x26: ffff000001d21298 x25: 000000005abcea60 x24: ffff800011d89000
x23: 0000000000000001 x22: ffff000001d21880 x21: ffff000001ec9300
x20: 0000000000000004 x19: 0000000000000198 x18: ffffffffffffffff
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000041400
x14: 5eee00201100200a x13: 000000000000bb03 x12: 0000000000000000
x11: 0000000000000100 x10: 0200000000000000 x9 : bb0000021a162c01
x8 : 0302010021021003 x7 : 0000000000000000 x6 : ffff800012573af0
x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000200
x2 : 0000000000000348 x1 : 0000000000000348 x0 : ffff80001095308c
Call trace:
 pm_runtime_drop_link+0x128/0x338
 ufshpb_get_dev_info+0x8c/0x148
 ufshcd_probe_hba+0xda0/0x11b8
 ufshcd_async_scan+0x34/0x330
 async_run_entry_fn+0x38/0x180
 process_one_work+0x1f4/0x498
 worker_thread+0x48/0x480
 kthread+0x140/0x158
 ret_from_fork+0x10/0x20
Code: 88027c01 35ffffa2 17fff6c4 f9800051 (885f7c40)
---[ end trace 2ba541335f595c95 ]

Since ufshpb_get_dev_info() is only called in asynchronous execution
ufshcd_async_scan(), and before ufshpb_get_dev_info(), pm_runtime_get_sync()
has been called:

...
/* Hold auto suspend until async scan completes */
pm_runtime_get_sync(dev);
atomic_set(&hba->scsi_block_reqs_cnt, 0);
...
ufshcd_async_scan()
    ufshcd_probe_hba(hba, true);
        ufshcd_device_params_init(hba);
            ufshpb_get_dev_info();
 ...
    pm_runtime_put_sync(hba->dev);


Remove ufshcd_rpm_{get/put}_sync() from ufshpb_get_dev_info(), fix
this issue.

Fixes: 351b3a849ac7 ("scsi: ufs: ufshpb: Use proper power management API")
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshpb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 9ea639bf6a59..33a38c06a296 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2877,11 +2877,8 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	if (version == HPB_SUPPORT_LEGACY_VERSION)
 		hpb_dev_info->is_legacy = true;
 
-	ufshcd_rpm_get_sync(hba);
 	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 		QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0, &max_hpb_single_cmd);
-	ufshcd_rpm_put_sync(hba);
-
 	if (ret)
 		dev_err(hba->dev, "%s: idn: read max size of single hpb cmd query request failed",
 			__func__);
-- 
2.25.1

