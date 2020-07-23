Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB32C433FC
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 053A520792
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:27:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WJkfBBhh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbgGWM1T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728909AbgGWMZE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:04 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F54C0619DC
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:04 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 9so4773072wmj.5
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7GXuG63I+zXiW2iHeDq1l75A8cqfuCvVf5oH88+KFWQ=;
        b=WJkfBBhhXpIiweagpu7YHnZJQkDUqh5Kgxr7h0JfR09J0THKrxTwLrDPG3qNeBF5+H
         IaYyNQ+m00fhuxZF5R+FcPBCB3ZWObUSnW1x2IULVBmAVFECIsnDSGhXgbhmeFicpqtj
         98A2/p6zqBusuPVpMN9EC4INcbiKmdJ47v2tSIcD5J6CG6zypzMfufnW5GyLfasRvmD7
         NTUHAV7TswgxUNokIWKvumdbieEcOx+3b2DVzGxhsFaVzu4l3ZSBqzJeKjnVcAl6Spjc
         JRaSp8E7RRxrEfLZYQ71AYXu6ZDcZNGloGlVcQI85RQ36CByWCmWbnBjZZ6obrfSJZK6
         6Ang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7GXuG63I+zXiW2iHeDq1l75A8cqfuCvVf5oH88+KFWQ=;
        b=PshFnbDL0uOxjqcsmoKP+TFl94pnELo6DdFKhXDCe+WImqB66Mu5awypt0Arf6/l2M
         CeVilshi759WJy6iAkOJdkf04e/Shqibijbxt1oTC89xs7v8t0ng63MuenE8agOgFJqb
         N39qDq4Zodx/eb7zsspMbw0VLmyjnAHlDIoNfi4ivua38sXMhtihARddx9BSig5v+gu4
         ezRmT1Wmgb2VBjQVin5uUNCioh759IpUZJSHuCI714TNshZZhuJsIr8zCHcIgv9ebE39
         Qyy+DthEnkkrCz7qQllZHo6X6yUxaUyfD4k7+pCxT3b9VkxhRHnOCu/jEAli4T9IOToE
         2BIg==
X-Gm-Message-State: AOAM530rQjMAONIU4c3/02es5QMIz9lP5+zk75QzagPkWrn54n60mneG
        +q+mw3juSB2IRiZXuijvu1hxF5RfmH8=
X-Google-Smtp-Source: ABdhPJxU96+k6AAXNc4TzOnx/0IOTErBWda93TNlxgsOHGe2FcOFrrlYZvW48DUn0NkMAUlVtbl3AQ==
X-Received: by 2002:a1c:2041:: with SMTP id g62mr3919099wmg.172.1595507102891;
        Thu, 23 Jul 2020 05:25:02 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:02 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@cavium.com
Subject: [PATCH 11/40] scsi: qedi: qedi_main: Remove 2 set but unused variables
Date:   Thu, 23 Jul 2020 13:24:17 +0100
Message-Id: <20200723122446.1329773-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qedi/qedi_main.c: In function ‘qedi_queue_cqe’:
 drivers/scsi/qedi/qedi_main.c:1158:21: warning: variable ‘conn’ set but not used [-Wunused-but-set-variable]
 1158 | struct iscsi_conn *conn;
 | ^~~~
 drivers/scsi/qedi/qedi_main.c: In function ‘__qedi_probe’:
 drivers/scsi/qedi/qedi_main.c:2432:6: warning: variable ‘tmp’ set but not used [-Wunused-but-set-variable]
 2432 | u16 tmp;
 | ^~~

Cc: QLogic-Storage-Upstream@cavium.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qedi/qedi_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 81a307695cc91..1a7791164de8c 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1155,7 +1155,6 @@ static int qedi_queue_cqe(struct qedi_ctx *qedi, union iscsi_cqe *cqe,
 {
 	struct qedi_work *qedi_work;
 	struct qedi_conn *q_conn;
-	struct iscsi_conn *conn;
 	struct qedi_cmd *qedi_cmd;
 	u32 iscsi_cid;
 	int rc = 0;
@@ -1168,7 +1167,6 @@ static int qedi_queue_cqe(struct qedi_ctx *qedi, union iscsi_cqe *cqe,
 			  iscsi_cid);
 		return -1;
 	}
-	conn = q_conn->cls_conn->dd_data;
 
 	switch (cqe->cqe_common.cqe_type) {
 	case ISCSI_CQE_TYPE_SOLICITED:
@@ -2429,7 +2427,6 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 	struct qed_probe_params qed_params;
 	void *task_start, *task_end;
 	int rc;
-	u16 tmp;
 
 	if (mode != QEDI_MODE_RECOVERY) {
 		qedi = qedi_host_alloc(pdev);
@@ -2528,9 +2525,9 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 		  "Writing %d to primary and secondary BDQ doorbell registers.\n",
 		  qedi->bdq_prod_idx);
 	writew(qedi->bdq_prod_idx, qedi->bdq_primary_prod);
-	tmp = readw(qedi->bdq_primary_prod);
+	readw(qedi->bdq_primary_prod);
 	writew(qedi->bdq_prod_idx, qedi->bdq_secondary_prod);
-	tmp = readw(qedi->bdq_secondary_prod);
+	readw(qedi->bdq_secondary_prod);
 
 	ether_addr_copy(qedi->mac, qedi->dev_info.common.hw_mac);
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_DISC, "MAC address is %pM.\n",
-- 
2.25.1

