Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 595E4FA372C
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 05:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 370AD2178F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 05:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfKGFWK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 00:22:10 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40476 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfKGFWJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 00:22:09 -0500
Received: by mail-pf1-f195.google.com with SMTP id r4so1550167pfl.7
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2019 21:22:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nQuBtEp0e3F6LUqQSPy0FyLSVooa6f2uGsbxgj7mvDw=;
        b=KAe/st2zcaHL6TtxCIr8X7D62MC1+CRj6Afnc7dFqQ7VonZ+H+VXBuQLBvUu5y6AtZ
         pPCU8MG7rE5mVsQu9bLD0Yu/46yBEC3JDuiI3rekgYOo24Hr4e0mYADiAMvl8fUIRqUh
         oG1BC6oljAqFZlPziSlPyLgKn2kOtxseQZI7zMuPHdlE2a6If7AHQSuvIuTS7k9VOQ9f
         yDfoveEnIyDvvhjPzQKGusYcoXsL0xJjZzWdwnuMtPv7Gk1ehmTTmnvVozJDc0vmZaRf
         a1HQUNuLv+QVO9K5s4i96CIqmiPPkyoQkWqTj9LnQRSEh7vg5vUjdc9a4Lrj9BtAE1cr
         cZeg==
X-Gm-Message-State: APjAAAXO1TWyT/78n0KQ2Rnmy7EcZtS2vI3UXdJ1mZx4WAmUmVZDeC35
        66PM/6eWLtvYR/CJZxnahbqM+mZ4
X-Google-Smtp-Source: APXvYqxTzBE5lyNVVxz2Zvc27oCdrKatR0DGx2fsP2fUVfcBB/fqxRs035f7ygzShQpEtlDCJqhvrw==
X-Received: by 2002:a63:e307:: with SMTP id f7mr2196548pgh.101.1573104129019;
        Wed, 06 Nov 2019 21:22:09 -0800 (PST)
Received: from localhost.net ([2601:647:4000:1075:7917:b099:7983:671c])
        by smtp.gmail.com with ESMTPSA id m13sm719961pga.70.2019.11.06.21.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 21:22:08 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/3] lpfc: Fix a kernel warning triggered by lpfc_get_sgl_per_hdwq()
Date:   Wed,  6 Nov 2019 21:21:54 -0800
Message-Id: <20191107052158.25788-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107052158.25788-1-bvanassche@acm.org>
References: <20191107052158.25788-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel bug report:

BUG: using smp_processor_id() in preemptible [00000000] code: systemd-udevd/954

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index fad890cea21a..613fbf4a7da9 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20668,7 +20668,7 @@ lpfc_get_sgl_per_hdwq(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_buf)
 		/* allocate more */
 		spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 		tmp = kmalloc_node(sizeof(*tmp), GFP_ATOMIC,
-				   cpu_to_node(smp_processor_id()));
+				   cpu_to_node(raw_smp_processor_id()));
 		if (!tmp) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 					"8353 error kmalloc memory for HDWQ "
@@ -20811,7 +20811,7 @@ lpfc_get_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 		/* allocate more */
 		spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 		tmp = kmalloc_node(sizeof(*tmp), GFP_ATOMIC,
-				   cpu_to_node(smp_processor_id()));
+				   cpu_to_node(raw_smp_processor_id()));
 		if (!tmp) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 					"8355 error kmalloc memory for HDWQ "
-- 
2.23.0

