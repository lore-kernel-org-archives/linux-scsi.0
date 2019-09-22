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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAF5C3A5A6
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F02120B7C
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CvlhPXSo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfIVD7g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:36 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34163 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727507AbfIVD7f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:35 -0400
Received: by mail-oi1-f193.google.com with SMTP id 83so5020207oii.1
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oE2JYBGf1mtJ/lU1wpxt0+8lKO3AfmVlBAc2nIOYMU0=;
        b=CvlhPXSoqmLJCoDK4nlumud9XkR5A1YrwdQLFUg/JzDYKwPtNB5fL3b50zR1glkDHR
         Oo9QePVDlveC64ABf0Yupket9RhfCcEBElzaj5TSP6PVV6EChRjTYyhBpKghGZgemQFR
         xMRT4LkE5gJ3TwaGHw49TLDEAlWUq6WO/0TpRzkYSjsFwF3JFS5qYRQzIHrm7xPpRpZH
         1kI5WIdTSxuyaDDeZvxF+/zkzn0UJ2GHAaUKRBOOTnz6HydkSSZmKyJJuFvwt/F2CcCL
         UiQE1tl5K6iuOmRY8RRL7BYVCbzFAkCFOs/qT4YtwW3u6AEoB4ffM9YmL/BwRWFkfoum
         eLqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oE2JYBGf1mtJ/lU1wpxt0+8lKO3AfmVlBAc2nIOYMU0=;
        b=FXnmi6NXIPMRLhDiYWJ33CrOtC6qDIvWSieAop8WoQPZ/b5tYM4PFV6Olu/mQwJuz+
         trbACbmt4gI05tBphKJzzJj2/pQyWBP4BOsdwZcA4AnHpgOaCCjyBT0VZYA60cBCRhZj
         2ghdpdRebk6gK5iKU2IUfUjU7y3+qj+kA6APZKoHLOlN9/WkyNVxEWbYx6+brJLClyi2
         HZLCqbthyqOI7w1sTv4pslTG0geV820Z+QaEucN6jIOtDjKmT1pTq0dlSCaP2elrepZO
         NnJm4+Wdy8ORgB4DLKMSkbpUVCX6b4hTK6bl92If2zEihXVk/0fmGmZao6hsHct/lrWW
         IK/A==
X-Gm-Message-State: APjAAAVkkis2CYiGqBTKx/2mGTzQH8GZOEPXQGOO57mbUEH3+H05jdKb
        ASON0Zn/U39KRENJnjr6Up6fUWbo
X-Google-Smtp-Source: APXvYqws6jJ4u3VtBDQWxbTOV6RL0BhHRuW2b69Fq4gtCnq7QH+sz29A+79jIOLJaid3GUCOoMFQsg==
X-Received: by 2002:aca:2118:: with SMTP id 24mr9138468oiz.95.1569124774821;
        Sat, 21 Sep 2019 20:59:34 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:34 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 18/20] lpfc: Complete removal of FCoE T10diff support on SLI-4 adapters
Date:   Sat, 21 Sep 2019 20:59:04 -0700
Message-Id: <20190922035906.10977-19-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T10DIF support on SLI-4-based FCoE adapters is not supported.
A prior commit in the 12.4.0.0 stream added device recognition
that would prevent T10diff enablement. However, it didn't contain
a complete device list. Thus some SLI-4 FCoE adapters still had
T10DIF enabled.

Fix by expanding the device list that identifies FCoE devices.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 79a192479755..e4c89e56c632 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -7083,11 +7083,22 @@ struct fc_function_template lpfc_vport_transport_functions = {
 static void
 lpfc_get_hba_function_mode(struct lpfc_hba *phba)
 {
-	/* If it's a SkyHawk FCoE adapter */
-	if (phba->pcidev->device == PCI_DEVICE_ID_SKYHAWK)
+	/* If the adapter supports FCoE mode */
+	switch (phba->pcidev->device) {
+	case PCI_DEVICE_ID_SKYHAWK:
+	case PCI_DEVICE_ID_SKYHAWK_VF:
+	case PCI_DEVICE_ID_LANCER_FCOE:
+	case PCI_DEVICE_ID_LANCER_FCOE_VF:
+	case PCI_DEVICE_ID_ZEPHYR_DCSP:
+	case PCI_DEVICE_ID_HORNET:
+	case PCI_DEVICE_ID_TIGERSHARK:
+	case PCI_DEVICE_ID_TOMCAT:
 		phba->hba_flag |= HBA_FCOE_MODE;
-	else
+		break;
+	default:
+	/* for others, clear the flag */
 		phba->hba_flag &= ~HBA_FCOE_MODE;
+	}
 }
 
 /**
-- 
2.13.7

