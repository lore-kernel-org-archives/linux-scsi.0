Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C5F9C433EC
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5497320842
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:47:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RKFBANQv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbgGMHrO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729351AbgGMHrM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:47:12 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A30C061794
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:12 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g75so12302140wme.5
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hh5XWPq04WZIcyTw2TRmdhHW7NgKe3Z7t0gHGNMmsgU=;
        b=RKFBANQvoTjQ/t+AHxR5P3h6u+vmKHBdNnULJmvs5kpn7o9j1EQGTYCQmhuwavoGbw
         JhByLFw8T+odavhbCVMR1O/9QwvWn085I0wZCafa8scqcQbGup4CvCsM3eje/Cei2GuR
         QaNAMtbY4Se/Dhr4ohtzDm5rklNtqKEFpjhzaupSGkGLhoWjBLSx0Ubbm3k7ChJy39bJ
         C6Ux8Skgy5q7od4v0lfpAiSwac8iTowa50exTc0pNrN8k07WErMGnMB+HIkK+8grJ3Cb
         TGmCgIRsq5qxwKShLHZGdhRdNoeThgLtl2aBns5hkwsxPcDsIqBLW+hXoy2fVhsAePEE
         R0Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hh5XWPq04WZIcyTw2TRmdhHW7NgKe3Z7t0gHGNMmsgU=;
        b=Q5Jyraxnwmay3CO+wLhMQGCPQcQACrS1yVrWETOfClloAuHzDjdQX7YiYcSUBXhWsI
         +QrX740BrGuoosSdqjAOWdfNyCqaI1F08Ncq50R9C8dCANVNkY46FjjFmSsUjlQ/DPO8
         RpJXH3S3yD4+zNs19HUPTk9S7hjHi4f+9Jg0kM6iJBNSUCnvM68neiR0icJnFOURNghj
         nwMi11y8Rpw7s51OBDe9Dwh3XZvw9rEgc8mBKepP0VyuJm3Oc1UVCaNkk053OrIWSkC1
         Ww6cYZtLtKZpWPALPlLMG510gb3bplFb2P6S/+9IzjCGZx6oyMQJ3kNvUCFTLAvQAtIO
         CGIQ==
X-Gm-Message-State: AOAM530YTINtpbWodmcYTwGO03vnSMYbZtolw1nflMQT11vjaUIubcCJ
        wtJOtEsO2JUZRFzRwYMed7c2Ag==
X-Google-Smtp-Source: ABdhPJwf9PWvvGs+A/PgQ5tR/9IvAux0qkcW/lSe5b92rqm5dNrCqSONb8frXjDOLDTiClHjOylnEA==
X-Received: by 2002:a05:600c:2154:: with SMTP id v20mr18918204wml.185.1594626431357;
        Mon, 13 Jul 2020 00:47:11 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:47:10 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@cavium.com
Subject: [PATCH v2 22/29] scsi: qedf: qedf_debugfs: Demote obvious misuse of kerneldoc to standard comment blocks
Date:   Mon, 13 Jul 2020 08:46:38 +0100
Message-Id: <20200713074645.126138-23-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No attempt has been made to document any of the demoted functions here.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qedf/qedf_debugfs.c:25: warning: Function parameter or member 'qedf' not described in 'qedf_dbg_host_init'
 drivers/scsi/qedf/qedf_debugfs.c:25: warning: Function parameter or member 'dops' not described in 'qedf_dbg_host_init'
 drivers/scsi/qedf/qedf_debugfs.c:25: warning: Function parameter or member 'fops' not described in 'qedf_dbg_host_init'
 drivers/scsi/qedf/qedf_debugfs.c:25: warning: Excess function parameter 'pf' description in 'qedf_dbg_host_init'
 drivers/scsi/qedf/qedf_debugfs.c:51: warning: Function parameter or member 'qedf_dbg' not described in 'qedf_dbg_host_exit'
 drivers/scsi/qedf/qedf_debugfs.c:51: warning: Excess function parameter 'pf' description in 'qedf_dbg_host_exit'
 drivers/scsi/qedf/qedf_debugfs.c:64: warning: Function parameter or member 'drv_name' not described in 'qedf_dbg_init'

Cc: QLogic-Storage-Upstream@cavium.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qedf/qedf_debugfs.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_debugfs.c b/drivers/scsi/qedf/qedf_debugfs.c
index b88bed9bb1338..a3ed681c8ce3f 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -14,10 +14,9 @@
 
 static struct dentry *qedf_dbg_root;
 
-/**
+/*
  * qedf_dbg_host_init - setup the debugfs file for the pf
- * @pf: the pf that is starting up
- **/
+ */
 void
 qedf_dbg_host_init(struct qedf_dbg_ctx *qedf,
 		    const struct qedf_debugfs_ops *dops,
@@ -42,10 +41,9 @@ qedf_dbg_host_init(struct qedf_dbg_ctx *qedf,
 	}
 }
 
-/**
+/*
  * qedf_dbg_host_exit - clear out the pf's debugfs entries
- * @pf: the pf that is stopping
- **/
+ */
 void
 qedf_dbg_host_exit(struct qedf_dbg_ctx *qedf_dbg)
 {
@@ -56,9 +54,9 @@ qedf_dbg_host_exit(struct qedf_dbg_ctx *qedf_dbg)
 	qedf_dbg->bdf_dentry = NULL;
 }
 
-/**
+/*
  * qedf_dbg_init - start up debugfs for the driver
- **/
+ */
 void
 qedf_dbg_init(char *drv_name)
 {
@@ -68,9 +66,9 @@ qedf_dbg_init(char *drv_name)
 	qedf_dbg_root = debugfs_create_dir(drv_name, NULL);
 }
 
-/**
+/*
  * qedf_dbg_exit - clean out the driver's debugfs entries
- **/
+ */
 void
 qedf_dbg_exit(void)
 {
-- 
2.25.1

