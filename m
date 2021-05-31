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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459B9C47083
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 10:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C946611CB
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 10:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhEaKpE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 06:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbhEaKpD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 06:45:03 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3F1C061761;
        Mon, 31 May 2021 03:43:23 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id t15so3021211eju.3;
        Mon, 31 May 2021 03:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=buWoO5ZNQLGx/bpd8SgWHa31Z/TjhX1VqfvpZfL27+A=;
        b=ftYkK6IdrhPv8PoBQkWjiWlRqsej4QgNg9C6vj9w4v9dHOu1bfwA5AKnW+4prEB0ju
         F3pSXz6qg819wouB6BYiG0PLiucvKVh6V4QztNiKvgUqU8VDp1WoXylWAoXXJzV3fjpP
         Y5LCe0rzzgG0i0EaXUqXklVkn+pURvJnA+6bE5ZYTtLWb52xl3YPuUvo70T8NHNGt81D
         e3t71kPwENuZCq4m9R2utyOVg8pGTYu3k8OttnUHb/adIgMNmRWJaodOx3BMbqmznWpK
         lfRGK7dqWJ6SyzCy5ZrG30R5y080/kp5x+HZG4r33EaS3i65k+8MYtb7p6rfMNhvkuF3
         vFbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=buWoO5ZNQLGx/bpd8SgWHa31Z/TjhX1VqfvpZfL27+A=;
        b=HYV80MypB8yUKhtyeZXS9HF1S2cxPtwfrm+1hmIb5L1/S8Wjx2VCDAM+EidJfLjrYk
         B7GRkvCXK1u73fud+36+1/29D6BV93mgbu/22DkljFaZGdAvW4cYifs2KzhdSom3x0c7
         +XDQWzh2gnJeLhM6n3nW0cKtNqnFttI6WBBtAhC6Ms2k7lCl4MnAdYR9w/JX40h55YA3
         fGxoHyAOYTS3HP3+avKyp7MdBX9ikyhdRPCKozGYVuVyJ1jF7vWXLWW+ErqW8xVWWrXa
         ISZ9SPG5S+hnaMnCbZ2wFqnxC/UT4zKW2PHTFJ2APYJrkx71wfqsnSauKxZMCgXrayVm
         V00g==
X-Gm-Message-State: AOAM533nxiui1/cWCVDquQDeChjZKx5QaxVJQwe251m9KQS5uSxXZ2k6
        vh79Zsx8NoMS+YKOYj0Se2s=
X-Google-Smtp-Source: ABdhPJwr1ta6+/ucUtEz/UcXAF9XbbtgNYhYFyblxxwFSpENS8ii/eMIXxevkiHCI7mGLj8i5xaOVg==
X-Received: by 2002:a17:906:2bd0:: with SMTP id n16mr22513527ejg.110.1622457801696;
        Mon, 31 May 2021 03:43:21 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.gmail.com with ESMTPSA id dk9sm5741035ejb.91.2021.05.31.03.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 03:43:21 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] scsi: ufs: Cleanup ufshcd_add_command_trace()
Date:   Mon, 31 May 2021 12:43:05 +0200
Message-Id: <20210531104308.391842-2-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210531104308.391842-1-huobean@gmail.com>
References: <20210531104308.391842-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

To consistent with trace event print, convert the value of the
variable 'lba' in the unit of LBA (logical block address).

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 02267b090729..85590d3a719e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -25,6 +25,7 @@
 #include "ufs_bsg.h"
 #include "ufshcd-crypto.h"
 #include <asm/unaligned.h>
+#include "../sd.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ufs.h>
@@ -364,7 +365,7 @@ static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
 static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 				     enum ufs_trace_str_t str_t)
 {
-	sector_t lba = -1;
+	u64 lba = -1;
 	u8 opcode = 0, group_id = 0;
 	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
@@ -382,22 +383,23 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 		/* trace UPIU also */
 		ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
 		opcode = cmd->cmnd[0];
+		lba = sectors_to_logical(cmd->device, blk_rq_pos(cmd->request));
+
 		if ((opcode == READ_10) || (opcode == WRITE_10)) {
 			/*
 			 * Currently we only fully trace read(10) and write(10)
 			 * commands
 			 */
-			if (cmd->request && cmd->request->bio)
-				lba = cmd->request->bio->bi_iter.bi_sector;
 			transfer_len = be32_to_cpu(
 				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
 			if (opcode == WRITE_10)
 				group_id = lrbp->cmd->cmnd[6];
 		} else if (opcode == UNMAP) {
-			if (cmd->request) {
-				lba = scsi_get_lba(cmd);
-				transfer_len = blk_rq_bytes(cmd->request);
-			}
+			/*
+			 * The number of Bytes to be unmapped beginning with the
+			 * lba.
+			 */
+			transfer_len = blk_rq_bytes(cmd->request);
 		}
 	}
 
-- 
2.25.1

