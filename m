Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED026C43381
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 22:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F1C22D06
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 22:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390248AbhAKWc4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 17:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390201AbhAKWcz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 17:32:55 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33913C061795;
        Mon, 11 Jan 2021 14:32:14 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id v26so130658eds.13;
        Mon, 11 Jan 2021 14:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TuL8hgFVL4I8OOHJFG5/ip2YEave37hlRfmsC8L9xeQ=;
        b=ARZeQxO585p6eFTlOJkem2p0CDAnMV89SwB9IH4vzv9uRq7tOWGzfRxCaQURTd6eUu
         iHp1Awnz8s2BXxwd72qvIq4CibjJ/e2SAypJKnXepuW7B1S9xaIrQ0G8frJNFB0/gE79
         /ZylNLRXTJapElyVqBHLv2MrynfBvpn9YTZZAyhBi8iWWDL5Ct9zoGju6d7jCO96Ztir
         ShZBd7unpwLmAPlc8o1HeKUeIuX3MX3GMe/6DEUDb05blRgMZNvsKq33KFWsK7eJ7hHF
         oEtJs/a/4RkiqiMn0lSZ22Q1438MgiJfyXQdUqtDcc/E/d9it70kkijzcNh+mpTDxiRQ
         7zQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TuL8hgFVL4I8OOHJFG5/ip2YEave37hlRfmsC8L9xeQ=;
        b=QOpcsQpztVOJH4r50fevlP90QFsNlxmLK62WMvPg6jHvN90gEH07QzXnGmtx15eT2D
         CWxEDXtCp0sFk+C1QXbKAnjpub7BLntjYhM2ene5RHNqghLzFeWT7mvfrZmgXeF9/ap0
         cKGqOg5d12eDHQ+AGGzi0EhLjubCbeSdnnPpaK0sXIBo+SXOy6CY5C9UFmTDL3a9pC0b
         fQFIIqDcLJ2GGkudiR9wYho6h06Jg8TlWdOxgxpRi7Cp4a61IVbs45RC61aow3BMjODW
         20s1f2ohUsgg3F5ldf41fySpPqDmAfrJRPgFNV+S+VIkPa0G+Fi7U6HHtL3gm/faAIng
         2c5Q==
X-Gm-Message-State: AOAM531LX+vwvLYMMmnhIn47JYveNwRHeCPfmPfV9EHrFC+HClwMDeJ3
        AxnM4lNeRdRzltvuy1vxwDQ=
X-Google-Smtp-Source: ABdhPJyjLjPCUkuAzkTbLHKpm55Gl4STlFHJ2WmUq0YkE0RuELiGvDYjDsbN3eEkRZ95DeZWXCIJDA==
X-Received: by 2002:a05:6402:2da:: with SMTP id b26mr1092722edx.350.1610404332915;
        Mon, 11 Jan 2021 14:32:12 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.gmail.com with ESMTPSA id r18sm550154edx.41.2021.01.11.14.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 14:32:12 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        john.garry@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, ebiggers@google.com, satyat@google.com,
        shipujin.t@gmail.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH 1/2] scsi: hisi_sas: Remove unnecessary devm_kfree
Date:   Mon, 11 Jan 2021 23:32:01 +0100
Message-Id: <20210111223202.26369-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111223202.26369-1-huobean@gmail.com>
References: <20210111223202.26369-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

The memory allocated with devm_kzalloc() is freed automatically
no need to explicitly call devm_kfree.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 91a7286e8102..9e590f5f1a6b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4172,30 +4172,6 @@ static void debugfs_work_handler_v3_hw(struct work_struct *work)
 	hisi_hba->debugfs_dump_index++;
 }
 
-static void debugfs_release_v3_hw(struct hisi_hba *hisi_hba, int dump_index)
-{
-	struct device *dev = hisi_hba->dev;
-	int i;
-
-	devm_kfree(dev, hisi_hba->debugfs_iost_cache[dump_index].cache);
-	devm_kfree(dev, hisi_hba->debugfs_itct_cache[dump_index].cache);
-	devm_kfree(dev, hisi_hba->debugfs_iost[dump_index].iost);
-	devm_kfree(dev, hisi_hba->debugfs_itct[dump_index].itct);
-
-	for (i = 0; i < hisi_hba->queue_count; i++)
-		devm_kfree(dev, hisi_hba->debugfs_dq[dump_index][i].hdr);
-
-	for (i = 0; i < hisi_hba->queue_count; i++)
-		devm_kfree(dev,
-			   hisi_hba->debugfs_cq[dump_index][i].complete_hdr);
-
-	for (i = 0; i < DEBUGFS_REGS_NUM; i++)
-		devm_kfree(dev, hisi_hba->debugfs_regs[dump_index][i].data);
-
-	for (i = 0; i < hisi_hba->n_phy; i++)
-		devm_kfree(dev, hisi_hba->debugfs_port_reg[dump_index][i].data);
-}
-
 static const struct hisi_sas_debugfs_reg *debugfs_reg_array_v3_hw[DEBUGFS_REGS_NUM] = {
 	[DEBUGFS_GLOBAL] = &debugfs_global_reg,
 	[DEBUGFS_AXI] = &debugfs_axi_reg,
@@ -4286,8 +4262,6 @@ static int debugfs_alloc_v3_hw(struct hisi_hba *hisi_hba, int dump_index)
 
 	return 0;
 fail:
-	for (i = 0; i < hisi_sas_debugfs_dump_count; i++)
-		debugfs_release_v3_hw(hisi_hba, i);
 	return -ENOMEM;
 }
 
-- 
2.17.1

