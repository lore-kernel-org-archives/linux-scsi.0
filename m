Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0900CC4332B
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 11:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA8DC229C5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 11:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbhAELfz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 06:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729532AbhAELfn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 06:35:43 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9245C061795;
        Tue,  5 Jan 2021 03:35:02 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ce23so40766539ejb.8;
        Tue, 05 Jan 2021 03:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=72/SUuPCsj8H8A1VQ0sHfajSA3j22KjHCSI0xajxEC8=;
        b=T/iSwKwf5Rsq3kG0XzsG9jF7/kRGXWpvkNRy0O/WFR9a+JkhgyewpXf0B4C3XDmFW6
         tPaDZbHzSxis+tyH6HnI2kkIrf8bHmX5M9+zOTd7n8VIs5Nt9Z9+lgm73H4tbeQ4GXMl
         hu+rU2zum6mPwFYHfJbYNpigiww1lseeXW/U/uhSgKL6uGmtfLX1CIPH3ErGAkPLZYHO
         HBLAStUUGYPLAh2eJQuX9W0wWC0BVqCq6vShF6vuwpP/wVob9uKBlJJzBLQWjg4hRv+Z
         iKclDnTxctb11/RGBaEhLRbGxaKGN86lOX/qjiNQVK+sX0aFcTVf0O70hqfuHHxb1Yhn
         YKHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=72/SUuPCsj8H8A1VQ0sHfajSA3j22KjHCSI0xajxEC8=;
        b=Brve7OOkc2/IchVZsdQWR795mv3ly7NilHuR/0Pn9Dn17Jj3tgaNya+D7Is+4pL0Kj
         rvgvG98/mHrJqqDpgGXJb/RWoJClSF8yeC4jkXVBHQB0PBlJrpCs64x3FuN5crCQiDM0
         33dEWW1KpLKpty8vALAOAHaAKEuJt3sWqnDUzrVLaeyCDxaM6w9z9KsmcupMI2f5v9qo
         /KaKwUMVzjeDDlCzfPFXnOptjIHIl6dEyLmlf/5EjcIQH9RNQsVk9ModCaAQQ73W2pN/
         tD/zJqm+6oK+qji1dPqC4Hg1EyLw2HVYBVw2JbaAZB6RNatGCXo2qGn64k5jnFAXUhDJ
         Gt+A==
X-Gm-Message-State: AOAM530oSn8kY4pwGv3cRbTs1fNX2BUi6dNE7g8JgRGfwd8HdyizRPcp
        SBVMMz7Tq6IcnRSdmLhuyFk=
X-Google-Smtp-Source: ABdhPJzJtKx8xWuLHa9qzmW27/6opAvOMragY7S0irVgEtw3m2YrTqZF+YeX1iaF4cLtP7iajACNtQ==
X-Received: by 2002:a17:907:6e6:: with SMTP id yh6mr71655965ejb.512.1609846501772;
        Tue, 05 Jan 2021 03:35:01 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.gmail.com with ESMTPSA id n17sm24640772ejh.49.2021.01.05.03.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 03:35:01 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/6] scsi: ufs: Don't call trace_ufshcd_upiu() in case trace poit is disabled
Date:   Tue,  5 Jan 2021 12:34:43 +0100
Message-Id: <20210105113446.16027-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105113446.16027-1-huobean@gmail.com>
References: <20210105113446.16027-1-huobean@gmail.com>
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
index c68afd356abb..9c8fc46183c4 100644
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

