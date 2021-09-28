Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613A8C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 476D561361
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242906AbhI1Vj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 17:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242974AbhI1Vj2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 17:39:28 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51248C06161C;
        Tue, 28 Sep 2021 14:37:48 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d21so677200wra.12;
        Tue, 28 Sep 2021 14:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=62o8qvDbaebUTEL6gImiSJov6SHsQsiLfGIVSMMiXeg=;
        b=cQkWff+x4nQZu5EJveWO2qKWQkphTBwCvH+wHxhJN7yGSANVLsQa8BEQDyu2AlbqXf
         YK9kRSS9YmbTSa8G5doAGvjg7Yu86wez2JzV5UYnrZKefU8kjToB+gYOtFLQBHaKL+OU
         BJ84JbrpBC00U7qGnbXiKPvAuNuRJL02Yy/45a0kENf2Twop0TB6xoa6n1TzhRO0qjYS
         Iylw2k7418P7aYrRq8cwqoLzvEVEjqvpHQ1FuOTK5dxi7twTvAQmzmkZKRZ/Tpad4Qnw
         kjElwX8iM3Zo7xbwQvx3suxwUzQpVEhUxfvWNnHTpEW7BIP4bGNTY9a5JGsahSX4L2J7
         c2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=62o8qvDbaebUTEL6gImiSJov6SHsQsiLfGIVSMMiXeg=;
        b=MPPK6mwtFqgWVXszTW6fjdLrKOCWADpds30/3uLRvyimnjY/RCNBhus+6VpYMi7cxM
         melvSu2acjBLKOcZ+KJwMbQh+jpiMNF4S6DsFMSPyLHrB+UYgAbbNxNq0ek90KQlDs6g
         fN0CnkiRkRIsudoTX1DH/Y6oh3yxI32Lp/tWlJ3jvJg79rXRVXi6EeWQnvsMElfHlycu
         DbHo5C8Sv/YePCqEXzFWrzlUYqr4WdHmFJdf18aeiM40mgpEjeNLpwi6sBeEczqHmIIP
         MK+9iP9PhYgMyIzsUcXQncuB4Qj4mvkbu6cjMY/H+5wk7gEXqxc3N1mZ/vnh2tTqiuZu
         gP5Q==
X-Gm-Message-State: AOAM533JK6fv3KG0oxPSMs0Ll7FKtq+PqoiSwYGl7KwdX+znSNcyn0V3
        T0Xd3yUJEgmIYpURHKqkPKQ=
X-Google-Smtp-Source: ABdhPJw9xkl2gYIzouvFl+fZcy6oP3fHtMUpxbQLmCEu1jCXbGHhKN+zAUu+CtVBISA8oIERvUtlKw==
X-Received: by 2002:a05:6000:11c6:: with SMTP id i6mr2702896wrx.177.1632865066953;
        Tue, 28 Sep 2021 14:37:46 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94717cfe07139628ae9da1147.dip0.t-ipconnect.de. [2003:e9:4717:cfe0:7139:628a:e9da:1147])
        by smtp.gmail.com with ESMTPSA id l18sm270461wrp.56.2021.09.28.14.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 14:37:46 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] scsi: ufs: ufshpb: Fix NULL pointer dereference
Date:   Tue, 28 Sep 2021 23:37:33 +0200
Message-Id: <20210928213734.778908-2-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928213734.778908-1-huobean@gmail.com>
References: <20210928213734.778908-1-huobean@gmail.com>
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

Remove ufshcd_rpmb_rpm_{get/put}_sync() from ufshpb_get_dev_info(), fix
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

