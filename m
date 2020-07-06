Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCCFC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 09:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D9B620773
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 09:19:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X6nGjErv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgGFJTX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 05:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbgGFJTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 05:19:22 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34800C061794;
        Mon,  6 Jul 2020 02:19:22 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id dg28so34130898edb.3;
        Mon, 06 Jul 2020 02:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rxNKX4qgET6W7+Q6DfO+W4zdUlMjHSivwGjx5M+xeHE=;
        b=X6nGjErv9Sb3srFr77TdMGs/RZ6JCT9nI+dkekYyyUtv0SEoG2Ms7KnFGEIEABYtD4
         C1HzQnEQd9a570yIJec7glblPfQ3/V4Nli76Ge8gGIKt9ZMhGlDYvGrJ7pVh1d5KDKdn
         twrzqh29SHIk9GFfgvcfXG6JznwOAitbxlFdRnXpsnYzOmGkqLymaVY8mpba7TmI/ZOA
         UvBd4xw+B0hzA1sLGfR7G4pQmtaXDxhXjqgDpfTOVUTsU1jYzqRvwpdrbV+fS+g0Ohfq
         ZRupWV9xPIfFC8y9Sjkqz5q5tC+8hmjdaJvcLsDPQ90O0eFozi/acwQAbnvtkIQMXJNO
         Y58Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rxNKX4qgET6W7+Q6DfO+W4zdUlMjHSivwGjx5M+xeHE=;
        b=dZcCAbEkxmIVfbeR36lXBRjMrtSYQieFbKaho1M3RB4q1diG3+Me3T8Hj/8pCJ9pxC
         MT2c49qygnyHkKIF/SMf3VqC/uqvAaNjmojD1+V9DXPhE2D3/znYHjQCTlx3Z3QG9OIm
         98MnjyBosNZDm7DsBrV95uO+yxpq/zYzHIzp1vL0ndZbeT/QlcvWYnVgJyK1A5/28KLn
         zb/Mh4ZR1oAtDmWv0vD5gN6GE8OLihfCNWOF+OvWCk9x4W2GIY1EWMVTa7Q2xfYvtaxV
         9j2dW63B7NIh4vZK37oTf8gpPyAurrZNaIZkwyuEqzQ3K6RwJY1xYfB+vA7eQJH+wF3c
         Qm6w==
X-Gm-Message-State: AOAM532aOIdvhBIaiDzDwzzYhHwWh8TnGW+Xxvn+LlRfNCfnPUDkPb7J
        zmQ2h0WZk7+AackFGnPO8+w=
X-Google-Smtp-Source: ABdhPJxAvlbDd0vBwz968MQk0IsSJI2V6HTcdem236VsSWmyaeKpkWNjjcajQynEC3yOUHezWnjQNw==
X-Received: by 2002:aa7:dd14:: with SMTP id i20mr11807283edv.41.1594027161019;
        Mon, 06 Jul 2020 02:19:21 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id d23sm15975386eja.27.2020.07.06.02.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 02:19:20 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] scsi: ufs: differentiate dev_cmd trace message
Date:   Mon,  6 Jul 2020 11:19:04 +0200
Message-Id: <20200706091905.12885-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200706091905.12885-1-huobean@gmail.com>
References: <20200706091905.12885-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

fshcd_exec_dev_cmd() can send query request and NOP request, and it is
confusing that ufshcd_add_query_upiu_trace() prints us the "query_send"
string in the trace log. Change it and add NOP key message in the trace
print according to the dev_cmd type.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 59358bb75014..173deee37e26 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2727,7 +2727,9 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 	hba->dev_cmd.complete = &wait;
 
-	ufshcd_add_query_upiu_trace(hba, tag, "query_send");
+	ufshcd_add_query_upiu_trace(hba, tag,
+				    cmd_type == DEV_CMD_TYPE_QUERY ?
+				    "send QUERY" : "send NOP");
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -2738,7 +2740,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
 
 	ufshcd_add_query_upiu_trace(hba, tag,
-			err ? "query_complete_err" : "query_complete");
+			err ? "dev_cmd err" : "dev_cmd complete");
 
 out_put_tag:
 	blk_put_request(req);
-- 
2.17.1

