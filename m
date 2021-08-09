Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1EAC432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84DAE60F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbhHIXFY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:24 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:52971 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237045AbhHIXFU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:20 -0400
Received: by mail-pj1-f47.google.com with SMTP id nt11so7149979pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y4ZY0he3Ub7V9kWp/mfBG6tcfkSMEe3662viUpbU8Pk=;
        b=GAXHTKqiKzOz6Q0wqN+GdIJqQiXLdxIwFA9sWL9usiSF6HyIms83aXLVFtHXQ3W4Xr
         6eCe1+2+H+mVXUcq+UDu11rJeuNp836vfWm+qabIqYpKAh1VrOa40uQ7jf+AJi/kvHqp
         iz71SxZwjiGEP0sUBf3PcMGqn6all75rDl3efnYp1SKQCGT41UIvHOPa+duKKjHjWw7x
         P052FOm4ZaXFmenlLY3m1SITD9mlin4TX798UK63rF6EeUIpny4hSapRFkHjjbtxLhu5
         HX/y5TtSpgVCEP6WhXfpHr4f9BsItfc+xtDuB0tJW4v1BE09yLcbhvyAbmUackPaQII4
         BmSw==
X-Gm-Message-State: AOAM530Sr1+59yVpsVFST6ySKXmHrPwSqFWK7yxqmoYMMsATKB02rOR5
        ESG0mxvNzlszLRgFwJmzudg=
X-Google-Smtp-Source: ABdhPJxnMK1Xh5nR27Y8njtv7N1zrk0uU7LuXzluYbx6vCYKrnIOHDIvhT5R8L69wF6HdQficR/Rxw==
X-Received: by 2002:a63:fe52:: with SMTP id x18mr920599pgj.84.1628550299411;
        Mon, 09 Aug 2021 16:04:59 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 36/52] qedi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:39 -0700
Message-Id: <20210809230355.8186-37-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedi/qedi_fw.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 71333d3c5c86..ac99e980bb31 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -609,14 +609,7 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 		goto error;
 	}
 
-	if (!sc_cmd->request) {
-		QEDI_WARN(&qedi->dbg_ctx,
-			  "sc_cmd->request is NULL, sc_cmd=%p.\n",
-			  sc_cmd);
-		goto error;
-	}
-
-	if (!sc_cmd->request->q) {
+	if (!scsi_cmd_to_rq(sc_cmd)->q) {
 		QEDI_WARN(&qedi->dbg_ctx,
 			  "request->q is NULL so request is not valid, sc_cmd=%p.\n",
 			  sc_cmd);
