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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9F5C47082
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 21:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63ED661166
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 21:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhEWVP5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 17:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbhEWVPx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 17:15:53 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D2DC061574;
        Sun, 23 May 2021 14:14:24 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b17so29607953ede.0;
        Sun, 23 May 2021 14:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yfFmMK8z30MY8L2YVUkiaNovEksZpBQmtsz1iXNsSr8=;
        b=Z1Aj7aki7HrYhdiCfDVEMo0hUb2XHn/NWkeoJEuoFtM3cPT26bE++asZwN74K0rFGW
         pBMK41npyf3JvDMHiILmVdE0j+cRQo3ZDjEwhkyX2E+ReXMRIgbLiMoqj7wUbUpRD7td
         WcM0wk8AWkQodBVvJxjQl4kO+OUHNAjpYbSgf+cyYBIfEslA7F2spFf49BkZUscXReGy
         PNy6I4i0Sdi4hEHTwQ3YSJ3Ub/rCZ7TZuRKbbFuXq/Tx1wBbqoMjkYVwfpWYN2tQLEBK
         Aze1LySx1FfK4x6HgEU3JrdvYwqwS3+ynsditPbnbhcbTwYbQfTYjUlgQ2cKBPKw5GRY
         Bo9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yfFmMK8z30MY8L2YVUkiaNovEksZpBQmtsz1iXNsSr8=;
        b=DOicSc3tQ5dAkMpfs2CJg9ZixlJHCwqMCmyfZUGuZMA65ndU0xuEmgbrY2iKSw7yqy
         KUsZZTBxnp2lzlM4Xz89reUmBfwPQGqJ4QMH3GQz4rfXxO7e/8rRQJak3oay7HbRcQ7W
         /jJdgLWrD4QpSQiPYvGw/1WUAYCzp7WPt/RJH9of1Zs3/WFLVY9rZ+OAdzTwGMFKQTgv
         gtQVz+H0fAkxtYgbu0G+zklDFylPp1X1DJprTUVQ1M/r7/41c1KCtYi+wuiiqg5OjOg0
         F1DYRJpZkJGoDtKZ0R0+of3Gwd7CPl2ZzxV6nzsY+XjuKMAh5Cl6qkPVeHsk9a5Kfe3h
         DZtw==
X-Gm-Message-State: AOAM5339+ZA3aGV+lZZOFO1eRp0aHpqvp8xQc+wFA8xoCDvFWAh3uvei
        cnsk+vbnTUS6YjguRe0XYp8=
X-Google-Smtp-Source: ABdhPJzUzzVffiCeZ2dr3HH6vLZH95w/lrZmsxGrikBttTkASk4Hi51GYrIouJ1NGv6aR04/CkHvKg==
X-Received: by 2002:a05:6402:1548:: with SMTP id p8mr22127171edx.261.1621804463557;
        Sun, 23 May 2021 14:14:23 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.gmail.com with ESMTPSA id t6sm2444ejd.123.2021.05.23.14.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 14:14:23 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/3] scsi: ufs: Let UPIU completion trace print RSP UPIU
Date:   Sun, 23 May 2021 23:14:07 +0200
Message-Id: <20210523211409.210304-2-huobean@gmail.com>
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
ufshcd_upiu: complete_rsp: fe3b0000.ufs: HDR:01 20 00 1c 00 00 00 00 00 00 00 00, CDB:00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

After the patch:

ufshcd_upiu: send_req: fe3b0000.ufs: HDR:01 20 00 1c 00 00 00 00 00 00 00 00, CDB:3b e1 00 00 00 00 00 00 30 00 00 00 00 00 00 00
ufshcd_upiu: complete_rsp: fe3b0000.ufs: HDR:21 00 00 1c 00 00 00 00 00 00 00 00, CDB:00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c382260e0cf7..dc5f13ccf176 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -300,13 +300,18 @@ static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
 static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 				      enum ufs_trace_str_t str_t)
 {
-	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
+	struct utp_upiu_req *rq_rsp;
 
 	if (!trace_ufshcd_upiu_enabled())
 		return;
 
-	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq->header, &rq->sc.cdb,
-			  UFS_TSF_CDB);
+	if (str_t == UFS_CMD_SEND)
+		rq_rsp = hba->lrb[tag].ucd_req_ptr;
+	else
+		rq_rsp = (struct utp_upiu_req *)hba->lrb[tag].ucd_rsp_ptr;
+
+	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq_rsp->header,
+			  &rq_rsp->sc.cdb, UFS_TSF_CDB);
 }
 
 static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
-- 
2.25.1

