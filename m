Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19E8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3D8161378
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242970AbhI1Vnr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 17:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242945AbhI1Vnq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 17:43:46 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D50C06161C;
        Tue, 28 Sep 2021 14:42:06 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id k7so649566wrd.13;
        Tue, 28 Sep 2021 14:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cIAqha183XJhUndLlDnEYVA4b/zNRitkPjLaLE66530=;
        b=P4OhBCcsB6vF3b4hyoo+Z4h3RZ/9LGipsBzKj+viX2gw1OYspaJTIPlb4GLDk1DduN
         XJ0yzXapQO+RrgfnPKqtLs3NhyL1rqBrglVY+frNJQX+YFgtWFiW34FtcLbPX60hxGuk
         gmbZV/1t3NnEqrNjWiLI5qJsU8J3jv8IO+q4lmhjJsJJeZTm8uesIRp/j8XhqpYGHzRs
         ZRTa2kh5FyTVjkKbj+p6FLE+WV4qnX4yq11X4azUq9fgBJR9WOwu5hAHdi88FxFKz8EK
         8BaVbz4yIEVuu6kSCe8r7t5k80vrjbOWi0dJjnGMFC6w9/SLA77nbz+6bjbseH2EkSXC
         iiPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cIAqha183XJhUndLlDnEYVA4b/zNRitkPjLaLE66530=;
        b=cfPdOF8dMD7GN0zX0swUl8XAUsxBOLtnCyJpxb3P4MwkUi7DcMNf6wBoi2oPNYAYOq
         odj56CokTdkX+3pS73Y9ZJwcju1HBmDeSBLPzebZ8aBP623mUw7A0JrWuOX+QF7sE6LT
         NXwIis/UZ+vsw8NM4FKxJfVABB58+hpvVPFNcCPLJj2Jnd+l+de4297MmxT2Ccs0wDOH
         ATw8mGvkc/8w3HcDO55J38fC8Pi5V31+aP6wX+JP2odAHYvD2ariGLrCSy7ew0/tpPdq
         eL3HK+IQq5SotHSOPvbiJLwM5WaOqW89i4UP1ZNMx6ZDVmdbK09K0kLQrd7uM3wU10Tj
         B1rw==
X-Gm-Message-State: AOAM531ZvDpjFjeA0HWkQbLeoJaxMb/VUAw0Qe88SdoiengOPrYiXLQW
        7Nln1n7qvtK05DSdCz2m4EA=
X-Google-Smtp-Source: ABdhPJy1JrlwfR7hTybMyyIFSuwHp8jd5bg23rL5J7dVRk0lFyICibuBR2Fm6cYcsWnEY42oZ2AiKw==
X-Received: by 2002:a5d:6545:: with SMTP id z5mr2785066wrv.90.1632865325279;
        Tue, 28 Sep 2021 14:42:05 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94717cfe07139628ae9da1147.dip0.t-ipconnect.de. [2003:e9:4717:cfe0:7139:628a:e9da:1147])
        by smtp.gmail.com with ESMTPSA id m4sm314147wrx.81.2021.09.28.14.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 14:42:04 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] scsi: ufs: ufshpb: Fix NULL pointer dereference
Date:   Tue, 28 Sep 2021 23:41:49 +0200
Message-Id: <20210928214150.779202-2-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928214150.779202-1-huobean@gmail.com>
References: <20210928214150.779202-1-huobean@gmail.com>
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
{
 ufshcd_probe_hba(hba, true);
 ufshcd_device_params_init(hba);
 ufshpb_get_dev_info();
 ...
 pm_runtime_put_sync(hba->dev);
}

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

