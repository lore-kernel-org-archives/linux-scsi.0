Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E61C47080
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 10:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23C386124C
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 10:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhEaKpH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 06:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhEaKpE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 06:45:04 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6718C06174A;
        Mon, 31 May 2021 03:43:23 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id k7so6458216ejv.12;
        Mon, 31 May 2021 03:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tA6A2ohh4L8vBzT6/8t9tpUkgl45rDZLB/Lv05qFeiw=;
        b=kAfcQ/GGr5m+hwwczKIC6ejflav1uQUMGfO5AOqqv9OpJM9l5w44bw5NWNgDMp9zXL
         fDx7ar2wpcjlHbvEHxScCT6FJf6pFTGpMsx/RpIW3RDkRw91OMj2ItNl5Sp+FlBo2Z1f
         /KyndLMF+FFEfYgMwzpVKXvy94HsLbTCrLs297J7bsm7Cd9IWLh0hx5VV2NwqmuabVkK
         /qqzLCfr2vao3YvT30mWPRoWJvSTjq5h+rIyu2Af6uStJMoXOVgUy0jX6avYY4rhx+D+
         93vWMjM7sZCHu7ktRLUdx55RaxeSL0PIy5FiLi9sjOGHjhb87zII4QLRDB8eVu+ldKmr
         FIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tA6A2ohh4L8vBzT6/8t9tpUkgl45rDZLB/Lv05qFeiw=;
        b=drjt6IkTyMZNJqYdH4bm66ysMdckOrSwTxkeY5jzwBRuzgxfQZl4c8LgVT3dE2gD10
         UiNnFHuW+7XLctHCFRsqvL9OW72d8n0JHUt2II78koBA32S+8Et2jO3znIr12kWod62t
         WmxLLb6f47gbQpl2QRrqrGEUnbtYQa25+1pM3i04+H2Ph0jankTzVYPIH7bCE/ROBVUm
         lQ//CT3+MZrcytjbaaaPOAUSDo2OH22Hfumdt2YXhlq/4FQ0Nh6iKfTcwO53X8L+5AhM
         JGZ3hazU0I9VFDMP9lgkhzgUPbORMSMgF0dHMS5/1xHscW+hDktO6NNWbwuusIu9GUa6
         0Z0A==
X-Gm-Message-State: AOAM530WMYw88fBPtQFUxR5jVuXKtGHc4hgSUB8RMvscsisZzsTr/exy
        GtABr0rjJj3PUvUwHdZqgiM=
X-Google-Smtp-Source: ABdhPJwa7MnHJHeEjbiD02yy+8LFvhMpLVGXYyeU9KmVCI5OPQLFmaPwGaZqBBP8Rn3Sn2/XM/cNYQ==
X-Received: by 2002:a17:906:f6d7:: with SMTP id jo23mr3164770ejb.302.1622457802464;
        Mon, 31 May 2021 03:43:22 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.gmail.com with ESMTPSA id dk9sm5741035ejb.91.2021.05.31.03.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 03:43:22 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] scsi: ufs: Let UPIU completion trace print RSP UPIU header
Date:   Mon, 31 May 2021 12:43:06 +0200
Message-Id: <20210531104308.391842-3-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210531104308.391842-1-huobean@gmail.com>
References: <20210531104308.391842-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

The current UPIU completion event trace still prints the COMMAND UPIU
header, rather than the RSP UPIU header. This makes UPIU command trace
useless in problem shooting in case we receive a trace log from the
customer/field.

There are two important fields in RSP UPIU:
 1. The response field, which indicates the UFS defined overall success
    or failure of the series of Command, Data and RESPONSE UPIU’s that
    make up the execution of a task.
 2. The Status field, which contains the command set specific status for
    a specific command issued by the initiator device.

Before this patch, the UPIU paired trace events:

ufshcd_upiu: send_req: fe3b0000.ufs: HDR:01 20 00 1c 00 00 00 00 00 00 00 00, CDB:3b e1 00 00 00 00 00 00 30 00 00 00 00 00 00 00
ufshcd_upiu: complete_rsp: fe3b0000.ufs: HDR:01 20 00 1c 00 00 00 00 00 00 00 00, CDB:3b e1 00 00 00 00 00 00 30 00 00 00 00 00 00 00

After the patch:

ufshcd_upiu: send_req: fe3b0000.ufs: HDR:01 20 00 1c 00 00 00 00 00 00 00 00, CDB:3b e1 00 00 00 00 00 00 30 00 00 00 00 00 00 00
ufshcd_upiu: complete_rsp: fe3b0000.ufs: HDR:21 00 00 1c 00 00 00 00 00 00 00 00, CDB:3b e1 00 00 00 00 00 00 30 00 00 00 00 00 00 00

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 85590d3a719e..c5754d5486c9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -302,11 +302,17 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 				      enum ufs_trace_str_t str_t)
 {
 	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
+	struct utp_upiu_header *header;
 
 	if (!trace_ufshcd_upiu_enabled())
 		return;
 
-	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq->header, &rq->sc.cdb,
+	if (str_t == UFS_CMD_SEND)
+		header = &rq->header;
+	else
+		header = &hba->lrb[tag].ucd_rsp_ptr->header;
+
+	trace_ufshcd_upiu(dev_name(hba->dev), str_t, header, &rq->sc.cdb,
 			  UFS_TSF_CDB);
 }
 
-- 
2.25.1

