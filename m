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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A72C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 20:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7F462250F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 20:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503056AbgLNUVQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502982AbgLNUVK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 15:21:10 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED92C061794;
        Mon, 14 Dec 2020 12:20:29 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id lt17so24392457ejb.3;
        Mon, 14 Dec 2020 12:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0mj6HJ/U8cQlVxyoI0eu4v6V/lqBUaLCPksFgUXLBPM=;
        b=ERiLNfFaD8NPJ4Nsrewmhy1nVxclhKqPQ2d1/5XF1EylrO7QQxp5eqgIjem1dEpB9p
         EGJRY7nUtLZ1hz9twlvX+LRJSiloMsc3Y8WLYh24jGld3ilsdDg3MtDm/IXq6pZaplCs
         xx/pk28QLKKIOGUjVegW+QQlQ3JAzesyhvMwE//WmPgmD3bwk43X0PAj0wPp+WbnJBAP
         Uh/n+MMZ8bXjnaXgNYk6R4AWC9UNgbFcmg0u0y+1gUWqS0poQsLyFZgK3e1ggivb2H9Y
         PAG1CUWaAa7Kg/lBmZYR0pTYc/VvoGa8Z3AgsrZ3QKA5Y2U3nFX8E2Q0pLrnOEb4Dzh6
         Rr8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0mj6HJ/U8cQlVxyoI0eu4v6V/lqBUaLCPksFgUXLBPM=;
        b=aRvninRhXG72XCeuhhbcAsqo/EKVkz48HNw9zUJrzm8QiTGwAHmpf9BfAQ8fe9Nvys
         Z8KP3szZZh1dg+BUG5ihikhry4nNALMGQIUOBTrVhHUTSovV/432ZQjq8cum+GlRQt1n
         7vRe1xSqyLx4JUf+PkYavS9UzV2ngTEPgAxMlhjBh5mfOqiKuFiXj2KHEIiOBvHqLuR8
         rNu2NCIa70lOg+qGPSLwbDdMLEzQPcLhsKs6o2j4FfJpAQL6MpD09SSFBosMGl+jle49
         bRunHkfAZCUZ1s82Z1YY8P6+3dXQlkQwd3NNIGZw8R7akd+oBKjv9rMzl7zvVXem6PVD
         hBVQ==
X-Gm-Message-State: AOAM533A74yIBncvtrfKpjvOEvCKFYFT97KcOhVyygexXd5aGpMf3szO
        vWKVsJ+gSs08D5LcInC8wU8=
X-Google-Smtp-Source: ABdhPJy+nmPUcxlyFimKxm1zZ9GbWpfyFV1mMgFefRcSpBw2kIo7jUwwAYyOnSGAM5X3Gfb9inrzUQ==
X-Received: by 2002:a17:906:3ad5:: with SMTP id z21mr23542843ejd.35.1607977228667;
        Mon, 14 Dec 2020 12:20:28 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id r7sm9334634edh.86.2020.12.14.12.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:20:28 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org, joe@perches.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/6] scsi: ufs: Don't call trace_ufshcd_upiu() in case trace poit is disabled
Date:   Mon, 14 Dec 2020 21:20:11 +0100
Message-Id: <20201214202014.13835-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214202014.13835-1-huobean@gmail.com>
References: <20201214202014.13835-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Don't call trace_ufshcd_upiu() in case ufshba_upiu trace poit is not enabled.

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 66babbd8bf32..f4a071d12542 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -309,6 +309,9 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 {
 	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
 
+	if (!trace_ufshcd_upiu_enabled())
+		return;
+
 	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq->header, &rq->sc.cdb);
 }
 
@@ -317,6 +320,9 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 {
 	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
 
+	if (!trace_ufshcd_upiu_enabled())
+		return;
+
 	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq->header, &rq->qr);
 }
 
@@ -326,6 +332,9 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 	int off = (int)tag - hba->nutrs;
 	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[off];
 
+	if (!trace_ufshcd_upiu_enabled())
+		return;
+
 	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->req_header,
 			&descp->input_param1);
 }
-- 
2.17.1

