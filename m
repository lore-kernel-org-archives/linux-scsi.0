Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7481FC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 584F864E4A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhBKXpj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhBKXpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:45:32 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB5DC0613D6
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:52 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id a24so2268538plm.11
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4p43K1HN6fO81bEyQcwOb3iUbzlwS3ZUXijLBb/8iZ4=;
        b=PYlMxFVIIPx9GyLvSate47iROO4Y/a/DFhib2VSt5ANtFpgQF6TWyVlSW2rjVEWGky
         frQRtTUTQ4K3UV0lSCjHiclKgoCqfwg90Fup1yuHbYviD+6UXNuyV3QuIVOFSDLJ+xvN
         874MmxCStOJ9iRj3pBF/Mzk2myNrEzyem54LALl1Guoz1Pb5ZYOZDE0BXzy3tB1UNVeL
         Le14K980Rs91iGHZMcPm6sRkRMYPiYXBirECLBFnPpCXwwL7R9Fa9VGtnn0zuMWGDqu6
         ib5KyonZl8asEAYWTBQXnGj4UKmZ9PkPI2cY1HjFQiq/o7s7j+Pu6VqFcsQepdkKMC5B
         31OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4p43K1HN6fO81bEyQcwOb3iUbzlwS3ZUXijLBb/8iZ4=;
        b=GkCjxS0EAIrq8TIB+E+WeEhDnFI710DT76kbawWjg88GoEKvpxNRSyjU01SEeLOn3w
         bVp9e2S/wfLCw89oaF92Yd6S0VyS9WSE086hCKp4TvbTAm+zRBOjB1n3GBaQIMe5gx+w
         DpGSuJA4ONoGpJJ/S+aL93LFEKsjpg1pLM0F3pr1x2S9o79qBeeL3DV34M5uVvcV5p4/
         aD53NUC6pEZ9VgXpExT4V6FoIdqZGTyuIL7YGntEzh7MIHq2XUs3o7jR7rHN61rGY8dz
         BsGL+jQY+XQTsPver4fkJlIvbXph00zDTScI5UE7mVway/dhsjEFPLyg5hEdR2LtIQ3c
         7HTA==
X-Gm-Message-State: AOAM532pZUbx1G/o5snT9J0nJgze7x3Z9GGunb7H2c+Ug1rDKq3OeJXQ
        Hs0OuKJDz5DBFRABqKEFEQsZtfG+wIM=
X-Google-Smtp-Source: ABdhPJyWasemNsxmuk/pWZ0khktvk8xsTIemxI+6YE8krQ8xOR3Pd+7wDijS693/POXeSMXP3WBmJA==
X-Received: by 2002:a17:902:8501:b029:e2:d953:212c with SMTP id bj1-20020a1709028501b02900e2d953212cmr454366plb.49.1613087091889;
        Thu, 11 Feb 2021 15:44:51 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:44:51 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 02/22] lpfc: Fix vport indices in lpfc_find_vport_by_vpid()
Date:   Thu, 11 Feb 2021 15:44:23 -0800
Message-Id: <20210211234443.3107-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calls to lpfc_find_vport_by_vpid() for the highest indexed vport fails
with error, "2936 Could not find Vport mapped to vpi XXX".  Our vport
indices in the loop and if-clauses were off by one.

Correct the vpid range used for vpi lookup to include the
highest possible vpid.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 48ca4a612f80..a60fa3f67076 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -6081,12 +6081,12 @@ lpfc_find_vport_by_vpid(struct lpfc_hba *phba, uint16_t vpi)
 		 * Translate the physical vpi to the logical vpi.  The
 		 * vport stores the logical vpi.
 		 */
-		for (i = 0; i < phba->max_vpi; i++) {
+		for (i = 0; i <= phba->max_vpi; i++) {
 			if (vpi == phba->vpi_ids[i])
 				break;
 		}
 
-		if (i >= phba->max_vpi) {
+		if (i > phba->max_vpi) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 					"2936 Could not find Vport mapped "
 					"to vpi %d\n", vpi);
-- 
2.26.2

