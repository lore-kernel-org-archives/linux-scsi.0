Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5B2C433F4
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DDA922CA1
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j3PDCXOl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgHCVCv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 17:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729009AbgHCVCu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 17:02:50 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D847C06174A
        for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2020 14:02:50 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g8so799199wmk.3
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2020 14:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u55z9bcq+J6rq7uqGinlGbUrA/EMY41lFFoVd349Cn0=;
        b=j3PDCXOl0scRLh0fhSeBi8Dzhp5xi13a3xCUJUBKVKhvoDJ4JlFOZ9G7OThWwmx4mb
         C8TByN3azLKdV4Ep3erGMR1p3G12k00MF9gpvw3e0beTPbled9L/jI3DAoir+Dyhmh9T
         SB/BEMfA9wLCC59bZpwGj9dbiVusdM8sai8zwOhtnO/ma1Xofxq+ArBDShg3Xftk6864
         lmI27J1SUuIccBKhTv9dUnb01pL7uT1wOCPoaxp9c83/HiWvQ7FnCx5EwPXxGD2FEObx
         gD6c3c1ftqBeDCQ1dWX/CzTOs4dMNeCQFNdXC8ikOFncLIK8MqH5FrGSXvaq9/d4BnrR
         A/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u55z9bcq+J6rq7uqGinlGbUrA/EMY41lFFoVd349Cn0=;
        b=VtEyCxL0+yUAVVDwDYJz8Q4f3C1R8kRdVgRvndcq15SeS44BC1U13xlRy4kfxJGH5a
         OxLuX9htghqf4JoP51LIN47Fu+dvVQehbZWa95oQfS3VfV03Jd8TT+Py99TW+zn0wu1a
         536wAt9rVdsKk3S8gagym3DwZ4bD/z+eWgWz6sTJF9/nVKg5/hu5pH4rrRBO0tnf2S+O
         pnHnW8NW70wS8IoEwGaJjUQnLHg4A5dZMaHAWSrtX9snepqlqKQVtT+gZ71kphiU3tj1
         gafZbDaZwE9MvwaX9bpXgd2ep8hr/jx5ynBAPQn0hh3ZF/9QVz/z2EiG0we9a17GZW/e
         4wfw==
X-Gm-Message-State: AOAM533eFT8hgjlMPfLY7eOk+4nyJvAd3vZwuiePig4/94WKEGWeaCJP
        XGHP9+8cObgDNu/Zg8ZZ5/rTUh3j
X-Google-Smtp-Source: ABdhPJzFq/UMls9soQo037wHbONW4LUSklK/pxeSWXjfJwcUr6wPu+rOoSZfJ+hnMQ14t2+fEnFFjA==
X-Received: by 2002:a7b:c084:: with SMTP id r4mr888485wmh.23.1596488568630;
        Mon, 03 Aug 2020 14:02:48 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm26649040wrm.23.2020.08.03.14.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 14:02:48 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 6/8] lpfc: Fix validation of bsg reply lengths
Date:   Mon,  3 Aug 2020 14:02:27 -0700
Message-Id: <20200803210229.23063-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803210229.23063-1-jsmart2021@gmail.com>
References: <20200803210229.23063-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are a couple of code areas which validate sufficient reply buffer
length, but the checks are using the request elements rather than
the reply elements.

Rework to validate using the reply structures.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 1d88fedaf3f0..6f9d648a9b9c 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2494,13 +2494,12 @@ lpfc_sli4_bsg_link_diag_test(struct bsg_job *job)
 	diag_status_reply = (struct diag_status *)
 			    bsg_reply->reply_data.vendor_reply.vendor_rsp;
 
-	if (job->reply_len <
-	    sizeof(struct fc_bsg_request) + sizeof(struct diag_status)) {
+	if (job->reply_len < sizeof(*bsg_reply) + sizeof(*diag_status_reply)) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
 				"3012 Received Run link diag test reply "
 				"below minimum size (%d): reply_len:%d\n",
-				(int)(sizeof(struct fc_bsg_request) +
-				sizeof(struct diag_status)),
+				(int)(sizeof(*bsg_reply) +
+				sizeof(*diag_status_reply)),
 				job->reply_len);
 		rc = -EINVAL;
 		goto job_error;
@@ -3418,8 +3417,7 @@ lpfc_bsg_get_dfc_rev(struct bsg_job *job)
 	event_reply = (struct get_mgmt_rev_reply *)
 		bsg_reply->reply_data.vendor_reply.vendor_rsp;
 
-	if (job->reply_len <
-	    sizeof(struct fc_bsg_request) + sizeof(struct get_mgmt_rev_reply)) {
+	if (job->reply_len < sizeof(*bsg_reply) + sizeof(*event_reply)) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
 				"2741 Received GET_DFC_REV reply below "
 				"minimum size\n");
@@ -5202,8 +5200,8 @@ lpfc_menlo_cmd(struct bsg_job *job)
 		goto no_dd_data;
 	}
 
-	if (job->reply_len <
-	    sizeof(struct fc_bsg_request) + sizeof(struct menlo_response)) {
+	if (job->reply_len < sizeof(*bsg_reply) +
+				sizeof(struct menlo_response)) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
 				"2785 Received MENLO_CMD reply below "
 				"minimum size\n");
@@ -5359,9 +5357,7 @@ lpfc_forced_link_speed(struct bsg_job *job)
 	forced_reply = (struct forced_link_speed_support_reply *)
 		bsg_reply->reply_data.vendor_reply.vendor_rsp;
 
-	if (job->reply_len <
-	    sizeof(struct fc_bsg_request) +
-	    sizeof(struct forced_link_speed_support_reply)) {
+	if (job->reply_len < sizeof(*bsg_reply) + sizeof(*forced_reply)) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
 				"0049 Received FORCED_LINK_SPEED reply below "
 				"minimum size\n");
@@ -5715,8 +5711,7 @@ lpfc_get_trunk_info(struct bsg_job *job)
 	event_reply = (struct lpfc_trunk_info *)
 		bsg_reply->reply_data.vendor_reply.vendor_rsp;
 
-	if (job->reply_len <
-	    sizeof(struct fc_bsg_request) + sizeof(struct lpfc_trunk_info)) {
+	if (job->reply_len < sizeof(*bsg_reply) + sizeof(*event_reply)) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
 				"2728 Received GET TRUNK _INFO reply below "
 				"minimum size\n");
-- 
2.26.2

