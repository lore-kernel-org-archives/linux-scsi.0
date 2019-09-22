Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6EADC3A5A6
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C46C20820
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uXdJdDzx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfIVD7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:37 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:44523 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727507AbfIVD7g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:36 -0400
Received: by mail-oi1-f193.google.com with SMTP id w6so4977231oie.11
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pP6X7HhOkL/7T56luGU90DfrPanvWh/Hx11DKJn/5QQ=;
        b=uXdJdDzxUORDvDf9C/JkYIQ4/oqTi1+noNgqrqZpAP0prdFXlunk561QeucxRpgp5H
         8PD0CJT1GKA6AqCxI0KAJODESmfVdgn7FYCAMl+wBsZ5Ol7AZhEMQSH9STdLTBEUj1zU
         ADbB2um0lUMYS74kEj0PaOfpXxr62BfNZMhHo6FA4H+DHETUH5TJlvEchrfPNXiHJtPv
         pMsjAfBEs4NGG1VWftFz5Okh3LL2UuftogwyjeDD7kVHuFMUN0SoTxObUXqN5xcDSu4E
         0SCcpHY+xgDdf7xXto82hTlKe4vW4nzsYp0hWQWP1TytC5qAHXzivY+oW1FXwVP0Ls29
         LfJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pP6X7HhOkL/7T56luGU90DfrPanvWh/Hx11DKJn/5QQ=;
        b=OXLvKyakN9B9MONoiNu/yuDyj48s61OunHzOjPX/fk8UO8w3X2kkK3sDsq3brpRHhP
         fNmVbBiVwQMVw49T73697J6KKmRPD+o2vOljSGvlENu6XYSsxumGAwfl/5wqBRbRpayZ
         0fHFOByetK63Q8YaL2Gv7i2rQYxN+36jlzR1LGdOcoOxN2YSbjhaCknUSNKwaVJyPudg
         teDbInMSurXJnzrcnGFzq3FCBFMvt/sZLK3pPOHIvw48GLiFySI3HdhXt4JpVoN3zQOl
         pL686rtEYjUSp4zgz6odg1gzAUNnVpJWyrUvutB8QU5FGzcQXAQAh4HZ6Ogj9hFBRXS9
         9Jhw==
X-Gm-Message-State: APjAAAXy081uqy61/CtSqyonbKB9gx71CVxsDbzdSnVzZh4F7h/igIPL
        reDysxGktc9BVp58314dXceJFdBU
X-Google-Smtp-Source: APXvYqy6b6hRR6y2MF2AbTNQScsTFkW06pRqn6DIUbRfuwgWw8Ec1XDaeBheFnlTsM1urEU/rttdaQ==
X-Received: by 2002:aca:d60c:: with SMTP id n12mr8760924oig.149.1569124775763;
        Sat, 21 Sep 2019 20:59:35 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:35 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 19/20] lpfc: cleanup: remove unused fcp_txcmlpq_cnt
Date:   Sat, 21 Sep 2019 20:59:05 -0700
Message-Id: <20190922035906.10977-20-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Local variable fcp_txcmplq_cnt is initialized to 0 and then displayed
in lpfc driver message 0387.

Presumed residual (or unused) code from previous commit.

Removed fcp_txcmplq_cnt.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 09e275e3bcd8..379c37451645 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13260,7 +13260,6 @@ lpfc_sli4_sp_handle_els_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	struct lpfc_sli_ring *pring = cq->pring;
 	int txq_cnt = 0;
 	int txcmplq_cnt = 0;
-	int fcp_txcmplq_cnt = 0;
 
 	/* Check for response status */
 	if (unlikely(bf_get(lpfc_wcqe_c_status, wcqe))) {
@@ -13282,9 +13281,8 @@ lpfc_sli4_sp_handle_els_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 			txcmplq_cnt++;
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 			"0387 NO IOCBQ data: txq_cnt=%d iocb_cnt=%d "
-			"fcp_txcmplq_cnt=%d, els_txcmplq_cnt=%d\n",
+			"els_txcmplq_cnt=%d\n",
 			txq_cnt, phba->iocb_cnt,
-			fcp_txcmplq_cnt,
 			txcmplq_cnt);
 		return false;
 	}
-- 
2.13.7

