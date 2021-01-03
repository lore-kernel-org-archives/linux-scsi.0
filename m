Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC94C432C3
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78523207AA
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbhACAS0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jan 2021 19:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbhACASZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jan 2021 19:18:25 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B39C0617A6
        for <linux-scsi@vger.kernel.org>; Sat,  2 Jan 2021 16:17:28 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id h186so14153340pfe.0
        for <linux-scsi@vger.kernel.org>; Sat, 02 Jan 2021 16:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8aDJGHx9QEXfSvCoO2quKuCjJPe1pZ786HtRKBaNp+A=;
        b=pQ1RQhi3U7Xv8ekuTTXlKu9ZxXo1Mk9iZgcH6iYLLBkKoy1w25QASjmTwrRu6eW7VN
         bn/MUzl3h7wwianzjgCJu7Bys8kdTm2iYoCG9HhuqLsRmwWqSLGAQ581wFhEGXVGUrbe
         y6CA27Kofc81FiyAuEu2HqMoiX9FRxe1pL1RjqR3sm7wcTDRuBv/6DqVkbE3SNcXF7CP
         5JrGqa1L1kRSAR5nRIZT4TFkyvt3xe4/Gm1ouS2pm+edbmfhbRYReibr5ifqmOBNVOXo
         lfVGausHFE0FMcmxxZrHzKSEIZtj7Tm8hVHQcHetIqf0sP4sqpKc9nAsM/CmuFk36BX0
         uQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8aDJGHx9QEXfSvCoO2quKuCjJPe1pZ786HtRKBaNp+A=;
        b=YNMLYqYep6OCf2nhH5GkA/R7TaZCRjR9FamA7Z857tqKG62Ra9bHvsqA3VB6PsTSfM
         zXFmPYGMuVSniQWpqCuymSXw72kvvUlcTfmnxAj7S1WP74wWgod1A50nt+vPzlqRsvCj
         Tr5JjvnZHr4MysNu7S6Rz6fWTLaaDBJp72jHcrBWh3aLXja00azxyJADpEDlJ2MIwoQF
         +0353DU75jlXN4KJyQ8c255XBlF1lWUc43LjotK6pqBnnJby942TladgpSPjMIxJyZN+
         UBqHwoONsy4RXPR1zZENq92wn2orpehivPv1e4Gwndijkw26hcyUVf20CDEMiZxmZ5+j
         WGkA==
X-Gm-Message-State: AOAM533sMHtCwTayQhHIH0Iq3f5j690L4NSXZLJ6AHpjjgmUODBWnmCg
        7zND0FhJR5gqajuH59p+BcJo0q5v4M4=
X-Google-Smtp-Source: ABdhPJzL44i9dMZPJlGI3+0oLN9MPSNmbxYlpKBpxqt0CvLDZ6HZvWUjPDYanqJHNlbz6/XdmMMgww==
X-Received: by 2002:a63:101e:: with SMTP id f30mr66998412pgl.95.1609633047751;
        Sat, 02 Jan 2021 16:17:27 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm55671867pgj.24.2021.01.02.16.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 16:17:27 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 15/15] lpfc: Update lpfc version to 12.8.0.7
Date:   Sat,  2 Jan 2021 16:16:39 -0800
Message-Id: <20210103001639.1995-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103001639.1995-1-jsmart2021@gmail.com>
References: <20210103001639.1995-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.8.0.7

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 234dca60995b..fade044c8f15 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.8.0.6"
+#define LPFC_DRIVER_VERSION "12.8.0.7"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

