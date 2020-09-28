Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A78C4727F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 10:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C43B206D4
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 10:28:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="H60AmnX5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgI1K2P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 06:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgI1K2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 06:28:15 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20582C061755
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2020 03:28:15 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t7so392454pjd.3
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2020 03:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=IytjbA/Gu1fX17Qs7VG7S2omMUSZgctkOvA1MDdO80E=;
        b=H60AmnX5bjo2Zfvw6RGRnAdZKrrt16oF5PdqfhAUZ+2CB62aTA2aegYcXQXOlYLlk+
         rnrjE5kP6XgwMiPI35osWtIbMhHeoaJeIh+uTozML8NjZ6YWzwd+ViFMszF+GxSGFaeA
         7beLdNU5gyV3GOHI0FoSS4H0D6nXw9O/dJiG0hWnMYZFAyl49TiR99jKx04KXFOYHQ/x
         enbV++3DXNonVLjKMBZ9rlwhby/2GNW0h9JFVx2MldTyjUmmLnQsN2TuzjS0gm0Yvh7b
         ORYYoLdk38eJhTv3AkZioVT+hIMurRWvy8XdxckVMppoSBQT++LZY2C0ycLoHOxdGURX
         m+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=IytjbA/Gu1fX17Qs7VG7S2omMUSZgctkOvA1MDdO80E=;
        b=QwHeta7G3YMHw8KOm66/CV3dZwM7x8yNLdBdcQeVNw5ogGT+9AHNRvrbGmWXnIGClN
         JnPhywwZuYXdyq16YFp+ImQJoASsk1LyYfRYr/f3Uk/w/h9iVTlgtJFGmd5h8LYlwXQW
         a7T8G9jhitiUc8ZY6tfWj5w7YJBwZ0VlBwz3dUjjMMjxyO/4RPuR5lxBMwbYNmHjY8/9
         I40hdv0X9xsDaJaqYolSuKBGcxF9HDGcc2UPUNC0b0cKeyPRH1sJFb5IyQMmE+ycgbhl
         ZqIbZX3ftUVYim1lOMHXmKEFbEHTXMrDKdTrDH0izpvilkhsheH1xqQ5XPDxa+jI5d7j
         q2VQ==
X-Gm-Message-State: AOAM530Diply092b/ttAAExjWJSGI8lx91U1qqYWeimgJ/VBAWEfNCeS
        eA/4iCIKSagOgY+8x+9azU0psA==
X-Google-Smtp-Source: ABdhPJzYEfMIBagz9pb3fVw3cExDIeEV0eGI0J0q5nGtQKc4q4BLd39RWbrAXcPT8qulhLpzCnuCYA==
X-Received: by 2002:a17:90a:e80f:: with SMTP id i15mr675312pjy.62.1601288894722;
        Mon, 28 Sep 2020 03:28:14 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id n67sm910506pgn.14.2020.09.28.03.28.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2020 03:28:14 -0700 (PDT)
Message-ID: <e9984f912deb3b163a377b194f76df984b1b43eb.camel@areca.com.tw>
Subject: [PATCH 1/4] scsi: arcmsr:
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     dan.carpenter@oracle.com, hch@infradead.org,
        Colin King <colin.king@canonical.com>
Date:   Mon, 28 Sep 2020 18:28:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

Remove unnecessary syntax.

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index fa562a0..5076480 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -317,20 +317,16 @@ static bool arcmsr_remap_pciregion(struct AdapterControlBlock *acb)
 static void arcmsr_unmap_pciregion(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
-	case ACB_ADAPTER_TYPE_A:{
+	case ACB_ADAPTER_TYPE_A:
 		iounmap(acb->pmuA);
-	}
-	break;
-	case ACB_ADAPTER_TYPE_B:{
+		break;
+	case ACB_ADAPTER_TYPE_B:
 		iounmap(acb->mem_base0);
 		iounmap(acb->mem_base1);
-	}
-
-	break;
-	case ACB_ADAPTER_TYPE_C:{
+		break;
+	case ACB_ADAPTER_TYPE_C:
 		iounmap(acb->pmuC);
-	}
-	break;
+		break;
 	case ACB_ADAPTER_TYPE_D:
 		iounmap(acb->mem_base0);
 		break;
@@ -552,18 +548,14 @@ static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
 
-	case ACB_ADAPTER_TYPE_A: {
+	case ACB_ADAPTER_TYPE_A:
 		arcmsr_hbaA_flush_cache(acb);
-		}
 		break;
-
-	case ACB_ADAPTER_TYPE_B: {
+	case ACB_ADAPTER_TYPE_B:
 		arcmsr_hbaB_flush_cache(acb);
-		}
 		break;
-	case ACB_ADAPTER_TYPE_C: {
+	case ACB_ADAPTER_TYPE_C:
 		arcmsr_hbaC_flush_cache(acb);
-		}
 		break;
 	case ACB_ADAPTER_TYPE_D:
 		arcmsr_hbaD_flush_cache(acb);
@@ -1213,21 +1205,15 @@ static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
 {
 	uint8_t rtnval = 0;
 	switch (acb->adapter_type) {
-	case ACB_ADAPTER_TYPE_A: {
+	case ACB_ADAPTER_TYPE_A:
 		rtnval = arcmsr_hbaA_abort_allcmd(acb);
-		}
 		break;
-
-	case ACB_ADAPTER_TYPE_B: {
+	case ACB_ADAPTER_TYPE_B:
 		rtnval = arcmsr_hbaB_abort_allcmd(acb);
-		}
 		break;
-
-	case ACB_ADAPTER_TYPE_C: {
+	case ACB_ADAPTER_TYPE_C:
 		rtnval = arcmsr_hbaC_abort_allcmd(acb);
-		}
 		break;
-
 	case ACB_ADAPTER_TYPE_D:
 		rtnval = arcmsr_hbaD_abort_allcmd(acb);
 		break;
@@ -1916,18 +1902,14 @@ static void arcmsr_hbaE_stop_bgrb(struct AdapterControlBlock *pACB)
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
-	case ACB_ADAPTER_TYPE_A: {
+	case ACB_ADAPTER_TYPE_A:
 		arcmsr_hbaA_stop_bgrb(acb);
-		}
 		break;
-
-	case ACB_ADAPTER_TYPE_B: {
+	case ACB_ADAPTER_TYPE_B:
 		arcmsr_hbaB_stop_bgrb(acb);
-		}
 		break;
-	case ACB_ADAPTER_TYPE_C: {
+	case ACB_ADAPTER_TYPE_C:
 		arcmsr_hbaC_stop_bgrb(acb);
-		}
 		break;
 	case ACB_ADAPTER_TYPE_D:
 		arcmsr_hbaD_stop_bgrb(acb);
@@ -1951,7 +1933,6 @@ static void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
 		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);
 		}
 		break;
-
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
 		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);
@@ -2034,7 +2015,6 @@ struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *acb)
 		qbuffer = (struct QBUFFER __iomem *)&reg->message_rbuffer;
 		}
 		break;
-
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
 		qbuffer = (struct QBUFFER __iomem *)reg->message_rbuffer;
@@ -2069,7 +2049,6 @@ static struct QBUFFER __iomem *arcmsr_get_iop_wqbuffer(struct AdapterControlBloc
 		pqbuffer = (struct QBUFFER __iomem *) &reg->message_wbuffer;
 		}
 		break;
-
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B  *reg = acb->pmuB;
 		pqbuffer = (struct QBUFFER __iomem *)reg->message_wbuffer;
@@ -2699,10 +2678,8 @@ static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A:
 		return arcmsr_hbaA_handle_isr(acb);
-		break;
 	case ACB_ADAPTER_TYPE_B:
 		return arcmsr_hbaB_handle_isr(acb);
-		break;
 	case ACB_ADAPTER_TYPE_C:
 		return arcmsr_hbaC_handle_isr(acb);
 	case ACB_ADAPTER_TYPE_D:
@@ -3634,18 +3611,14 @@ static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
 	int rtn = 0;
 	switch (acb->adapter_type) {
 
-	case ACB_ADAPTER_TYPE_A: {
+	case ACB_ADAPTER_TYPE_A:
 		rtn = arcmsr_hbaA_polling_ccbdone(acb, poll_ccb);
-		}
 		break;
-
-	case ACB_ADAPTER_TYPE_B: {
+	case ACB_ADAPTER_TYPE_B:
 		rtn = arcmsr_hbaB_polling_ccbdone(acb, poll_ccb);
-		}
 		break;
-	case ACB_ADAPTER_TYPE_C: {
+	case ACB_ADAPTER_TYPE_C:
 		rtn = arcmsr_hbaC_polling_ccbdone(acb, poll_ccb);
-		}
 		break;
 	case ACB_ADAPTER_TYPE_D:
 		rtn = arcmsr_hbaD_polling_ccbdone(acb, poll_ccb);

