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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698EEC47083
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 21:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A47611ED
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 21:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhEWVP6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 17:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbhEWVP4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 17:15:56 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC35DC061756;
        Sun, 23 May 2021 14:14:25 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id k14so35139483eji.2;
        Sun, 23 May 2021 14:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C/2CGtVUgkNHUKn8feRs8brY9+vXSWlUJgFt66SIrUY=;
        b=ShUfGkRA0BFzdEJyKzmFycpfCT2c/23QIVrNhbiTD0sNxCLy/W4yFI15ypJXOhsnhA
         S5l3y02L5IxSlqCChahKKkhcNHKszcmUzHvAr6xpqi68z+lT/BT1M//ZR9R5jHLu4lUy
         J7HrPOeYbi7U1YQsbHPK3C9ZrH9gVeOn/qm60kEHI1T5KPrlDs5laNNgV6TMqZVdF5Pp
         OMYCXkMT+tRfaX+AYX5sdnoUQiYB8W3QPOh/mQ7GB8Vr53YuVDC9P98oDgbB5HsM91wl
         49/Wy9/MVJzCSx1LkSr7Cfb4gmYgaEE0Pyjq4tBmlj5h7A7ix8I1ncp2Uc2Y51nzz4qM
         YTEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C/2CGtVUgkNHUKn8feRs8brY9+vXSWlUJgFt66SIrUY=;
        b=MuvlUfOQdYvFbK6czgPdkNmy6t6bvy8O26qqp4uvm/gyx/D6WxDUJft+zz3TBhSdJR
         WrKaSvBZysVK8POVMuj7XNqLZOnZa4hUK6VKFecy0bOh7WxhUkWAe32vDj6HuMJCyzRI
         rvXWTWprF1Kupu7DZ4KPFV8K/HvVdzT1rtXD4+aCq3qORnXW0Ln5G3qhIufTiLMFOuk2
         atOarUL18/R++Y1k3bxVGhHdcMHXtJwT/xV+DyDC67jcgWbp3C/5ne9+Lx8Vu3wMwhIy
         6dhamxb/F1TTz2iSG6d/xUljjkKG+Wgs46PNo6nSnTlZn0yqeg13EHsiPEzqLLBYiBgv
         Fv9w==
X-Gm-Message-State: AOAM531Xj8sR6lQ7Vf0uBv2Y9UW8xLC6Uxt7YRchZIA7yaRB3qgL8ydi
        D5Gg9T2BW0ctfIFsyZeJkuE=
X-Google-Smtp-Source: ABdhPJwqv+o5JITd/AXk5aV9BiIW7ZPlabUlGzg1CDlYCqsWa7KKuZF43UobN4Fp4IJFY6G7S1uwlg==
X-Received: by 2002:a17:907:768c:: with SMTP id jv12mr19368022ejc.215.1621804464327;
        Sun, 23 May 2021 14:14:24 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.gmail.com with ESMTPSA id t6sm2444ejd.123.2021.05.23.14.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 14:14:24 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/3] scsi: ufs: Let command trace only for the cmd != null case
Date:   Sun, 23 May 2021 23:14:08 +0200
Message-Id: <20210523211409.210304-3-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523211409.210304-1-huobean@gmail.com>
References: <20210523211409.210304-1-huobean@gmail.com>
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
 drivers/scsi/ufs/ufshcd.c | 49 ++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dc5f13ccf176..ed9059b3e63d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -376,33 +376,31 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	struct scsi_cmnd *cmd = lrbp->cmd;
 	int transfer_len = -1;
 
-	if (!trace_ufshcd_command_enabled()) {
-		/* trace UPIU W/O tracing command */
-		if (cmd)
-			ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
+	if (!cmd)
 		return;
-	}
 
-	if (cmd) { /* data phase exists */
-		/* trace UPIU also */
-		ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
-		opcode = cmd->cmnd[0];
-		if ((opcode == READ_10) || (opcode == WRITE_10)) {
-			/*
-			 * Currently we only fully trace read(10) and write(10)
-			 * commands
-			 */
-			if (cmd->request && cmd->request->bio)
-				lba = cmd->request->bio->bi_iter.bi_sector;
-			transfer_len = be32_to_cpu(
+	/* trace UPIU W/O tracing command */
+	ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
+
+	if (!trace_ufshcd_command_enabled())
+		return;
+
+	opcode = cmd->cmnd[0];
+	if ((opcode == READ_10) || (opcode == WRITE_10)) {
+		/*
+		 * Currently we only fully trace read(10) and write(10)
+		 * commands
+		 */
+		if (cmd->request && cmd->request->bio)
+			lba = cmd->request->bio->bi_iter.bi_sector;
+		transfer_len = be32_to_cpu(
 				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
-			if (opcode == WRITE_10)
-				group_id = lrbp->cmd->cmnd[6];
-		} else if (opcode == UNMAP) {
-			if (cmd->request) {
-				lba = scsi_get_lba(cmd);
-				transfer_len = blk_rq_bytes(cmd->request);
-			}
+		if (opcode == WRITE_10)
+			group_id = lrbp->cmd->cmnd[6];
+	} else if (opcode == UNMAP) {
+		if (cmd->request) {
+			lba = scsi_get_lba(cmd);
+			transfer_len = blk_rq_bytes(cmd->request);
 		}
 	}
 
@@ -9774,8 +9772,7 @@ static const struct dev_pm_ops ufs_rpmb_pm_ops = {
 };
 
 /**
- * Describes the ufs rpmb wlun.
- * Used only to send uac.
+ * Describes the ufs rpmb wlun. Used only to send uac.
  */
 static struct scsi_driver ufs_rpmb_wlun_template = {
 	.gendrv = {
-- 
2.25.1

