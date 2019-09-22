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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6EEC4740C
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F62E20820
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WEzIkT8g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfIVD7U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:20 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38390 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbfIVD7U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:20 -0400
Received: by mail-ot1-f67.google.com with SMTP id e11so9399287otl.5
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LQ/Y7ijba5zO87lFE9w3reibn/wA/vxCOWp30Txdj6M=;
        b=WEzIkT8gpguRNj76a/5OICG5dnbCdWd7q6DZatPsprpXT8/wPIxtuQ/GaPTWs+3tO/
         BHCN12TIExff7MMCTEZctnKxqhxz+KqtPjA+OTdPxchVxKkDeOaRFlUaVuhFqe+f3Wqi
         rfpavgL39iv/FH6XqTaNBpLfuzp76BileB6pIvdDgvvZmYwfWRYfvTsTcPCc2BddcRT/
         RXhBRPQzknkfwoW8cooik5XHt7ITylWT48mRG+5yH6dzR791YVOnEB6XO4igK56VXv7Q
         NZxpBjyJxHSujDfcs7Ch4Wab0e9Q6pCEnV6i4ZufZ7we+6J6VNEttO0JSCf4TcjjzML9
         p1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LQ/Y7ijba5zO87lFE9w3reibn/wA/vxCOWp30Txdj6M=;
        b=se02ZoU0uVF+r2x1bFb0Hc8og5OIc0Gj8+evzw0in+WvNJBNMp8geHOf5kyuMp2AlC
         kxXYXo32z+IauJzeD65auVp8dM8XwBWflLv29Y/zpzh515pUeXs+y0Z1fIdfj/7H8TKa
         y139WTVLpm6QNsevnF+hhhUyr+i5yMqGXvALVFIMHmUF7k9ea+QuMR8y1BEaK8UN+hON
         1gNX7QY6IrBKPPxWL1z0YOgRO6ajUPtggtyGPEpqQY0AdmM+Z7Hp0xnjgpKRVLbrhysV
         LXECv/X0op4OM5/0CIwjhl8K/IdYy3CcKVPwbuXbDzXhZeCFoho8ck7Zsg09gXbSqD9m
         Zl9A==
X-Gm-Message-State: APjAAAXVSgOPeMfoXpV7ll1whCspxnJcEGmbHxf7psjFB9/emJUp5K0R
        tevh7Hxeix4GYMvdbB9D9lEPK+y8
X-Google-Smtp-Source: APXvYqzmFzc4bI4hUmTbBy41+PKauEZL9bgpmbUwRB3BzC59KmAIWSDlvIBMuATiSSnIv+H+QgGrZQ==
X-Received: by 2002:a9d:a06:: with SMTP id 6mr17517868otg.69.1569124757608;
        Sat, 21 Sep 2019 20:59:17 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:17 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 03/20] lpfc: Fix miss of register read failure check
Date:   Sat, 21 Sep 2019 20:58:49 -0700
Message-Id: <20190922035906.10977-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Coverity flagged missing status check on register read that
flags a poisoned data return value.

Add checking of register read status.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 25aa7a53d255..41cc91d3c77e 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1475,8 +1475,9 @@ lpfc_sli4_pdev_status_reg_wait(struct lpfc_hba *phba)
 	int i;
 
 	msleep(100);
-	lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
-		   &portstat_reg.word0);
+	if (lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
+		       &portstat_reg.word0))
+		return -EIO;
 
 	/* verify if privileged for the request operation */
 	if (!bf_get(lpfc_sliport_status_rn, &portstat_reg) &&
@@ -1486,8 +1487,9 @@ lpfc_sli4_pdev_status_reg_wait(struct lpfc_hba *phba)
 	/* wait for the SLI port firmware ready after firmware reset */
 	for (i = 0; i < LPFC_FW_RESET_MAXIMUM_WAIT_10MS_CNT; i++) {
 		msleep(10);
-		lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
-			   &portstat_reg.word0);
+		if (lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
+			       &portstat_reg.word0))
+			continue;
 		if (!bf_get(lpfc_sliport_status_err, &portstat_reg))
 			continue;
 		if (!bf_get(lpfc_sliport_status_rn, &portstat_reg))
-- 
2.13.7

