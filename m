Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A4AC43446
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 286992072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="baJtv+z+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgGMIBF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729353AbgGMIA3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:29 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD78C08C5DB
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:28 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a6so14743700wrm.4
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9ZgkQ7bdc1wuAXRYHhS8n4ys9/FLwMulTL97bGrK6Pg=;
        b=baJtv+z+i4BdwY1fkELNipK3Dnb5fnGWphS0Xgl7xgPQoanLW/l0N/wuHE0Ktb2aC8
         oZG/F0tbD7fS7sCeVK6xguclTpNWCxHyxsh/29qRaCm9jld5xT4LT3B4riMznNeH7+q9
         VWEN0Arkpaw8BzFJ01UWbsK19U67y4UkEkcvByynvlIKeUuQaRC49nKAHicBCCTkaa2b
         NT7zn2rMDd5xXHZVLzMJjji4yQSvW03xcLrfm/WV5q3Rs4V4eoyvBPRhrUGl/Ju/FNhF
         VCFPOda9DRUnL7uqPv/r9binxhL1Dt1CBLVgtho/8Ce/yI+ZRNNpbkcGTf7QEdE/J8Ms
         IKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9ZgkQ7bdc1wuAXRYHhS8n4ys9/FLwMulTL97bGrK6Pg=;
        b=e7QUAf8Wtv2eS2GofkiVLMd9WvsPYZ+IWq5gqIZ8l8iPeJlQr4wL+yPgaGod2lJ5RT
         m9ZklYc1++opJAXmNdfPjdBYmikVHZxZQgY/r6a3Xi5KyyBURJTqI+CtFH7HUNAA5MvX
         KAk3WonVvpeSrjH5wSrNzRHyMvB9MqZuoTJIaYxgAi/E/g2ov+tB1OFWOqBrFkmHREvQ
         /43ADBHPmzjec0WrtwM9WKR4ot64t2tuVRQHF6xcfmLj91637HI18XgcYr52I9JLHxub
         iKTXpu8jQeK9vP99EmzSjNLlfaaVN700JMEMKQdGsOKYzsWk9/Rqk1q8a8+d9cZOenK5
         N1QQ==
X-Gm-Message-State: AOAM532YtjBwBPTkSlnSWe+n5iZosM7vC47y62qcMiz33UpW+fY0XjPg
        oS7xvYov9GS/t16BGJPLTX2fRw==
X-Google-Smtp-Source: ABdhPJxd3p7O61j7UOZQOlPtiEVXjyxjCLg/KpD1jSQ/g2VyxYglRfGMmYsYvWB1ofWoVaYUwh3q7w==
X-Received: by 2002:a5d:6288:: with SMTP id k8mr76209953wru.373.1594627227678;
        Mon, 13 Jul 2020 01:00:27 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:27 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        linux-drivers@broadcom.com
Subject: [PATCH v2 18/24] scsi: be2iscsi: be_main: Fix misdocumentation of 'pcontext'
Date:   Mon, 13 Jul 2020 08:59:55 +0100
Message-Id: <20200713080001.128044-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Also demote unintentional kerneldoc header.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/be2iscsi/be_main.c:986: warning: Function parameter or member 'pcontext' not described in 'alloc_wrb_handle'
 drivers/scsi/be2iscsi/be_main.c:986: warning: Excess function parameter 'pwrb_context' description in 'alloc_wrb_handle'
 drivers/scsi/be2iscsi/be_main.c:1409: warning: Function parameter or member 'beiscsi_conn' not described in 'beiscsi_complete_pdu'
 drivers/scsi/be2iscsi/be_main.c:1409: warning: Function parameter or member 'phdr' not described in 'beiscsi_complete_pdu'
 drivers/scsi/be2iscsi/be_main.c:1409: warning: Function parameter or member 'pdata' not described in 'beiscsi_complete_pdu'
 drivers/scsi/be2iscsi/be_main.c:1409: warning: Function parameter or member 'dlen' not described in 'beiscsi_complete_pdu'

Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: linux-drivers@broadcom.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/be2iscsi/be_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 9b81cfbbc5c53..8dc2e0824ad78 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -977,7 +977,7 @@ beiscsi_get_wrb_handle(struct hwi_wrb_context *pwrb_context,
  * alloc_wrb_handle - To allocate a wrb handle
  * @phba: The hba pointer
  * @cid: The cid to use for allocation
- * @pwrb_context: ptr to ptr to wrb context
+ * @pcontext: ptr to ptr to wrb context
  *
  * This happens under session_lock until submission to chip
  */
@@ -1394,7 +1394,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	spin_unlock_bh(&session->back_lock);
 }
 
-/**
+/*
  * ASYNC PDUs include
  * a. Unsolicited NOP-In (target initiated NOP-In)
  * b. ASYNC Messages
-- 
2.25.1

