Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D68C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F038F2074D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bZ4Jejbf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgF3Vub (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729914AbgF3Vu2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 17:50:28 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F41FC061755
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:28 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so18627531wrw.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eHX7qYrcNuOdmodMO/gCPV7uB9xnHZph3PQlC3Pv9y0=;
        b=bZ4Jejbf35kGY7tn1O2X5Z9cuS09cbDm5aEJji4awEcfzrWNX8SzBYYRNwPrfOip7L
         mICE/ZL3/txw9b/6yvWUhmxsIxRcryElzpA5tyaer3jY3YTTOKXQ27d+6g9Lqp3r3Q52
         RvDoYmApVS8Ll6RXqPZIxDY9NsLmsfkG9kLccP8aS4ReQHbF95TVSMP3KvNd/UkUKk26
         4VZXRWjf51PpaLXHVowyEMnW7WdRUEQAJgO6mkedB7asyjTbQkI4xyJlgxm6Z+7eDMs4
         +F1E7VmHTY9Y+q7W08AQX4Vhz50cgjL42t5xGSAFSSOo2T2Ghj38XsMPwQ/fwJ60hWOI
         r9mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eHX7qYrcNuOdmodMO/gCPV7uB9xnHZph3PQlC3Pv9y0=;
        b=pPg10e+FW2tyo2jY2ZGzdFDXKcFrKlEpXB2+CLGeYgoMs/mdXgI746rgtRdvxrRxJk
         pBYo+plwzE1PS4f5jlEkz0pJukvZ+O42MT7Cqoiii4lJ58xPO9JOLBwEHWgrSSySJXbJ
         53/9gAnQ8hEKmovDdol3dHmwM/OC/vsaym42NCxmbYz/c8qHG3Y4iebY7SnTNdTLcZLw
         kaPrZjzKgmRV88hNN5WmrSj3dke4HVA2iMRXsXI21OzicWGTxv8/YD+M4jumBRdyuJKJ
         Ke28xL/6dxMY8OWE+j+56PpUIDaZAet+GQcOXlZTHM5wXrOKdv640zpagn5SaPpIPEDM
         wkhg==
X-Gm-Message-State: AOAM532nLfqeCbyJtH6hgucaMsDFCS8RqM2w6WYyYQczATA8IIyQ5Koc
        77cHWWBRztvKfAPhQPXxrwiAbbft
X-Google-Smtp-Source: ABdhPJySXjM6nw4OdteEDEgbhd1ka8j8O2mW2QgK5Gm2INxB2jLNLW1s/GpBgHuNmOy9uyWOpiHMTg==
X-Received: by 2002:a5d:4283:: with SMTP id k3mr23072990wrq.322.1593553826091;
        Tue, 30 Jun 2020 14:50:26 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f14sm5518551wro.90.2020.06.30.14.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 14:50:25 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 09/14] lpfc: Fix language in 0373 message to reflect non-error message
Date:   Tue, 30 Jun 2020 14:49:56 -0700
Message-Id: <20200630215001.70793-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200630215001.70793-1-jsmart2021@gmail.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change vocabulary of 0373 log msg from "error" to "cmpl"
The current language of the 0373 message contains the word "error"
which caused a number of customers to inquire about the "error" and if
it should be a concern. It isn't an error, it's simply an io completion
status.

Revise the message to replace the word "error" with "compl" for completion.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 2fc8a1db81a4..271ba82f5d85 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13968,9 +13968,9 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 		     IOERR_NO_RESOURCES))
 			phba->lpfc_rampdown_queue_depth(phba);
 
-		/* Log the error status */
+		/* Log the cmpl status */
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-				"0373 FCP CQE error: status=x%x: "
+				"0373 FCP CQE cmpl: status=x%x: "
 				"CQE: %08x %08x %08x %08x\n",
 				bf_get(lpfc_wcqe_c_status, wcqe),
 				wcqe->word0, wcqe->total_data_placed,
-- 
2.25.0

