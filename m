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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77F2C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 10:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80BEA60FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 10:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhEaKpO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 06:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbhEaKpF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 06:45:05 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E94C061574;
        Mon, 31 May 2021 03:43:24 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id jt22so16027853ejb.7;
        Mon, 31 May 2021 03:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J6H9WGXYQrem7icV2sz1sWQwyHLvRgt4yHtiTHtzZlc=;
        b=douWCSMM3wPLfJv+MkKPa/w46b9NcIaI+PtpQ3LwIQuwXxYa3Nw0m2QPXGzlU+Xzng
         zaMHfTSNVCpeT6gycmJUK2BJ82X8BkxxCzqvPyKp/IykX4qIq6bn/H2FCcM6pCB1JAd+
         XhbHGokcnzzdAtaPCBOjApbw598DdFzRRETW6tp6hKG74axhd4zCI06KJAh7uVJoY6y/
         v536iNw3MpkxpILuf+wdrQJeO/CNS8B6X45MHf4AJscqaXaJMYETSG+4147PjuV1LSHO
         9D72KVDobpLYlu/zB2JFB3KyGbumiqiEiTJsxy8M6XHh17OxXQj6Rvw6OlPlKIB8pFNy
         mCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J6H9WGXYQrem7icV2sz1sWQwyHLvRgt4yHtiTHtzZlc=;
        b=pOTT3fFNP7JlTdf4KpTm/5HjyW781GIxVTqS1a+Gc/Zy4MeRHvO9KQpQ0n+bKL/2kv
         HIrg97pufiGxQ2ORKysn6oaFV7InjbxfYfMQQmSggFY1G8Y7znODfrAdQAc1wtPqrBuR
         Lj/3/cnAlq8ABQ1+8qAn4+nmyvojNGiAhaVWeCg+sWYl/SzBWvT1fKEasSuNzN5XV0b3
         TaaI2mW7uh5JwpZiM+XfIMHq4/1lHC3eTXsrn+G/wu1XOuD19tTDvQnBhJ9ibnKPUDCA
         +wMJTglQkW2f3jc/bbXgLmiLhhij19iHYKTj+LCZhCd/9iznKPqGwthg8UE0TrQBw13V
         2K0g==
X-Gm-Message-State: AOAM531bAywraktat6nQOec4l95INKZ8xo7rL8YUNjpI2Gly2T1q2O0k
        6C31HOlkR3t53ebGH3zMjzw=
X-Google-Smtp-Source: ABdhPJzhUwzGZu153knctX6DiLSQRXDa4A+syM6Q2UYXJlYvj+cH6FasUGt+4SL/QBhG7QtsX2vvMw==
X-Received: by 2002:a17:906:1806:: with SMTP id v6mr21972016eje.454.1622457803215;
        Mon, 31 May 2021 03:43:23 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.gmail.com with ESMTPSA id dk9sm5741035ejb.91.2021.05.31.03.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 03:43:23 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] scsi: ufs: Let command trace only for the cmd != null case
Date:   Mon, 31 May 2021 12:43:07 +0200
Message-Id: <20210531104308.391842-4-huobean@gmail.com>
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

For the query request, we already have query_trace, but in
ufshcd_send_command (), there will add two more redundant
traces. Since lrbp->cmd is null in the query request, the
below these two trace events provide nothing except the tag
and DB. Instead of letting them take up the limited trace
ring buffer, it’s better not to print these traces in case
of cmd == null.

ufshcd_command: send_req: ff3b0000.ufs: tag: 28, DB: 0x0, size: -1, IS: 0, LBA: 18446744073709551615, opcode: 0x0 (0x0), group_id: 0x0
ufshcd_command: dev_complete: ff3b0000.ufs: tag: 28, DB: 0x0, size: -1, IS: 0, LBA: 18446744073709551615, opcode: 0x0 (0x0), group_id: 0x0

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 44 +++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c5754d5486c9..c84bd8e045f6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -378,35 +378,33 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	struct scsi_cmnd *cmd = lrbp->cmd;
 	int transfer_len = -1;
 
+	if (!cmd)
+		return;
+
 	if (!trace_ufshcd_command_enabled()) {
 		/* trace UPIU W/O tracing command */
-		if (cmd)
-			ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
+		ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
 		return;
 	}
 
-	if (cmd) { /* data phase exists */
-		/* trace UPIU also */
-		ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
-		opcode = cmd->cmnd[0];
-		lba = sectors_to_logical(cmd->device, blk_rq_pos(cmd->request));
+	/* trace UPIU also */
+	ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
+	opcode = cmd->cmnd[0];
+	lba = sectors_to_logical(cmd->device, blk_rq_pos(cmd->request));
 
-		if ((opcode == READ_10) || (opcode == WRITE_10)) {
-			/*
-			 * Currently we only fully trace read(10) and write(10)
-			 * commands
-			 */
-			transfer_len = be32_to_cpu(
-				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
-			if (opcode == WRITE_10)
-				group_id = lrbp->cmd->cmnd[6];
-		} else if (opcode == UNMAP) {
-			/*
-			 * The number of Bytes to be unmapped beginning with the
-			 * lba.
-			 */
-			transfer_len = blk_rq_bytes(cmd->request);
-		}
+	if (opcode == READ_10 || opcode == WRITE_10) {
+		/*
+		 * Currently we only fully trace read(10) and write(10) commands
+		 */
+		transfer_len =
+		       be32_to_cpu(lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
+		if (opcode == WRITE_10)
+			group_id = lrbp->cmd->cmnd[6];
+	} else if (opcode == UNMAP) {
+		/*
+		 * The number of Bytes to be unmapped beginning with the lba.
+		 */
+		transfer_len = blk_rq_bytes(cmd->request);
 	}
 
 	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
-- 
2.25.1

