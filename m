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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E61C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95A062255F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501949AbgLNQQQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 11:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501922AbgLNQQN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 11:16:13 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE6DC061793;
        Mon, 14 Dec 2020 08:15:32 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id cm17so17748479edb.4;
        Mon, 14 Dec 2020 08:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pssBiZ+i5NOdAX9lGslxXKq3u2xR17gyBk7cjo0G3yY=;
        b=fAhy+zGWu6Qd3GD3TjZZFl+FRUn9zsDLMulT30zRMz7+Sn6CsCWtHAiSKpNkGxngFu
         zzpbZyj2ricDnEzWZSPTnTxYpR6GNC42Nx87vvdpv9n7tUuCaYT6Ca7AhHj8Sm54x4Jr
         UrQipWNwmQmVy+bQHVfP4XMNJb3P0+QD/l/5Ncx8qpjRY7PXKUGWnDQYSaT5drc/kFUi
         EUlVpLdgLXO+VscgqQfPr91m9bRjKjV+FiUP5EvYIwUd2MLfeTjTaPsNj3d+0b0WVQok
         EMbf7m7ITsfqY1Eilj44tKfqZnYB7LMgVy9gyUXE0MCI77XKoTomvmLflQM3EPj5OmTB
         SXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pssBiZ+i5NOdAX9lGslxXKq3u2xR17gyBk7cjo0G3yY=;
        b=jfXVY/f6fCEa7cLpf2Yu82gjiYhfzZn2bInHCdEHXDfqQpKcxMr7xItQcLWEVCADiA
         3k47urVjKY4uv1BI9XToXhjylwgM1zT2SXPs2fn2avtqGTjGgiE0gnGtbb4Kl2Fz69V7
         eqVhF/SaaOEqde05w/yfMBnxcyJWOhz/Xkhx2oFVeEmeW9/kUnlrn2NP/itf6pUJmBQS
         7XY97bfkIxcCX8zpARjcaV9ut/D69YUkXkVcCwiCV0ysQbZeulCGfnYIgWB7vkwqhbSB
         LW/5JACm8ow5+oZm0ScCmQ9b27kBVUMl0PfwrJqYDSa8ILXfMMtKM5usgK6lmbnHwb4f
         Zs8A==
X-Gm-Message-State: AOAM531wWbv71rDmrasax2ZCHKQzbDHvdcL/X+t3jUTBn4tqWjCtzOIz
        MRc7zHf2b6TxPFVGDeyxQaY=
X-Google-Smtp-Source: ABdhPJyjltDihBrv6CoX7YkfwSKdO8FAs8GanM0TVaX2pqDbBpsP34UXxlUdZEqp6rNSXlbFEPntcw==
X-Received: by 2002:aa7:c64e:: with SMTP id z14mr25850759edr.69.1607962531622;
        Mon, 14 Dec 2020 08:15:31 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id i13sm6646056edu.22.2020.12.14.08.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 08:15:30 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] scsi: ufs: Don't call trace_ufshcd_upiu() in case trace poit is disabled
Date:   Mon, 14 Dec 2020 17:14:59 +0100
Message-Id: <20201214161502.13440-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214161502.13440-1-huobean@gmail.com>
References: <20201214161502.13440-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Don't call trace_ufshcd_upiu() in case ufshba_upiu trace poit is not enabled.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f7ebecb4af1a..da677147755d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -312,6 +312,9 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 {
 	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
 
+	if (!trace_ufshcd_upiu_enabled())
+		return;
+
 	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq->header, &rq->sc.cdb);
 }
 
@@ -320,6 +323,9 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 {
 	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
 
+	if (!trace_ufshcd_upiu_enabled())
+		return;
+
 	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq->header, &rq->qr);
 }
 
@@ -329,6 +335,9 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
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

