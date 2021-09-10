Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01931C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9B2C61206
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbhIJXdY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 19:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbhIJXdV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 19:33:21 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C4DC061574
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:10 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id bg1so2110067plb.13
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uEVsuIX/m/sL25A3lEyvCf2DS8cjQrVPW94B/QPsGw8=;
        b=TcXSeEizhUwBrV/v/MyqUWkN3uLoH2O6ksyxa8wc+3ZL0sFWY7YAglBsrVwv9Wevpo
         U+P1/RrrzhagYVk1ageIPoYqRzwIesD5mORuO4+XRoxHviMkQPbfeWfDDXx1IJ7n2E1o
         rVp5TsVtUE0tTz0UsfIbUwXJRh2u0UOGKZci3+VKJsBHORkbUW79l4reyWsNM5RA+ISY
         1D4ocqV++XtGpawCLyqLx3qJpHLfADf7uDKVsINwCFigyhxoGFAFcQuWOx4xtHZQtFZE
         cjGQ+YqULwyro06vrCY/WcjpCzbkjdgbsrwmRDlvNhNZ4Mkwjcdfs0Aigm6itc4pIxQ9
         8WIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uEVsuIX/m/sL25A3lEyvCf2DS8cjQrVPW94B/QPsGw8=;
        b=a/uS511lIndsH9kfIdhX+tazguvzqQf3pWbdVDTfWYbWVaBhNalxieQC/RAsdXlYxg
         0KddjRqzDSF3FKyvHH6ugFqwKsbE09yprt/qlXowo7uG11/FsJZf6Uy2xVmtgT2hf3ea
         c/NikAaJ+1Jk8wjvU+5dFdtkV5k/4mWU+dRUqpa03l1/ZQUpCJRPzXJq0eY9q+KD4utO
         vGBvUPLzmWPaZ3Hl3xHKeCc27Bu6MejidoFcx4lr9jpK6bS8cTD23QrjAARXohOccgQj
         fBHwdRn4UTQS5F8FQHMuRKYCBHHlfMhGyT+8wpiAK+/21bXQv+p9CuU6Z7o62b0M5K9n
         UnDQ==
X-Gm-Message-State: AOAM531JLhUwYtQ+FjwfVtjt+BNHSplHev841eHRVvChxIPlwBHoOErE
        4ZtqMpaG17ahIdFFvbpD4XT8NpUQlFUYIqtM
X-Google-Smtp-Source: ABdhPJzwo70Ts39NKgnRy9thg+0Y1hj3jtQz3s+7tBqgOT2l2PIboqXhd6r8XdHQKrNTHtTc6gHzFw==
X-Received: by 2002:a17:90a:990b:: with SMTP id b11mr83375pjp.182.1631316729700;
        Fri, 10 Sep 2021 16:32:09 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:09 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 03/14] lpfc: Fix premature rpi release for unsolicited TPLS and LS_RJT
Date:   Fri, 10 Sep 2021 16:31:48 -0700
Message-Id: <20210910233159.115896-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A test scenario has a target issuing a TPLS after accepting the
driver's PRLI.  TPLS is not supported by the driver so it rejects
the ELS.  However, the reject was only happening on the primary N_Port.
If the TPLS was to a NPIV vport, not only would it reject the ELS, but
it would act on the TPLS, starting devloss, then unregister from the
SCSI transport and release the node. When devloss expired, it would
access the node again and cause a page faul.

Fix by altering the NPIV code to recognize that a correctly registered
node can reject unsolicited ELS IO and to not unregister with the SCSI
transport and tear the node down.  Add a check of the fc4_xpt_flags so
that only a zero value allows the unreg and teardown.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index df5fc223ddb2..262101e172ad 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5295,6 +5295,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 */
 	if (phba->sli_rev == LPFC_SLI_REV4 &&
 	    (vport && vport->port_type == LPFC_NPIV_PORT) &&
+	    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD) &&
 	    ndlp->nlp_flag & NLP_RELEASE_RPI) {
 		lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
 		spin_lock_irq(&ndlp->lock);
@@ -5598,11 +5599,12 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 	}
 
 	/* The NPIV instance is rejecting this unsolicited ELS. Make sure the
-	 * node's assigned RPI needs to be released as this node will get
-	 * freed.
+	 * node's assigned RPI gets released provided this node is not already
+	 * registered with the transport.
 	 */
 	if (phba->sli_rev == LPFC_SLI_REV4 &&
-	    vport->port_type == LPFC_NPIV_PORT) {
+	    vport->port_type == LPFC_NPIV_PORT &&
+	    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
 		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_RELEASE_RPI;
 		spin_unlock_irq(&ndlp->lock);
-- 
2.26.2

