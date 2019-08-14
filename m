Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33DBC433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B818220866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K+lcWIO9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbfHNX5u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:50 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46602 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729797AbfHNX5s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:48 -0400
Received: by mail-pg1-f193.google.com with SMTP id w3so401616pgt.13
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v+CBQFopkTfzWzwUxBq+otaYK5YWiABl5s28tvV4Hzo=;
        b=K+lcWIO9ZS3ItRbN6V5vyWOn+wBh0BUMgagKvkRAKKmcJZzN5Jqx48VVibI46hQ5UB
         djXV3G7kQ/5rGsLsilZVLhj1+2+ZCJmd0agmOJRNfAzAb1FjwBMYxHPsS8+8638doVvZ
         6rlOXwpO+XPEsZECmL/ZvtcYpeh5jBws+D0cXi9cJsVxC9fShBgwjawFIC5NGVrlIjro
         i3bi9PEx9b+MutBI0KS94oIyJDLeYn91WapScNVA0R6daFA/WOCEfIHU/lZwqOsY1sEH
         kq7mH+St5d4hlS8TnNXIdBCeT3E0/4xye+Y6SV7JSpvEnS3JcZKpXXJVpYwSuwHjRARg
         AHow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=v+CBQFopkTfzWzwUxBq+otaYK5YWiABl5s28tvV4Hzo=;
        b=QKUxp0KrPV4V1y9vbF9MGeFrnL6PymzqyJzf6HFW5kWBC+mXyxpGYmTSVQuPsdW7sh
         lZC85Xxfmasy4dM0LyN4oHJROKRL9i6Y/6EYyJcNdWwSTk4CXtURgDTr+gICYNO6e73o
         USUSTX+vk3dw5x4TNLmTNHlKurxNgzZqgTtz6Wo6ndP1nunuhGf8l1fnYmrLGmS2JjZO
         Gv3vNQm1/H6yEyvsCOCcFpiEhoNrFvPd/w+Nd/8zBYgJKKmpUMEA0IAo5PiV7vWpCrhj
         7eh2b9T1mjb6GlaQn5E7hqX7xudlracfallzKsyFuIq5/Jt6sNc87eOJTGPof2BDVh8e
         TcQA==
X-Gm-Message-State: APjAAAVnPde9c3Ccq3TPd1hid41y08kJ33+965d6ulPLqKnJBtyDfZdF
        HYOhVR5/X5TTfGqZQXXB0QhlCaVw
X-Google-Smtp-Source: APXvYqzVK9Df8Qbl48Zw8vamgComPe09vzUNUCO/iM9/1FLlo2qmscSR391sLiQTZt4D6vOPpU1Zhw==
X-Received: by 2002:a17:90a:db06:: with SMTP id g6mr448209pjv.60.1565827067469;
        Wed, 14 Aug 2019 16:57:47 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:46 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 32/42] lpfc: Fix BlockGuard enablement on FCoE adapters
Date:   Wed, 14 Aug 2019 16:57:02 -0700
Message-Id: <20190814235712.4487-33-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver is allowing the user to change lpfc_enable_bg while
loading the driver against a FCoE adapter. This is not supported.

No check is made for the adapter type when applying the blockguard
enablement value.

Fix by verifying the adapter type before setting the enablement flag.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 7ac6508b7ed8..63e631f116e4 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -7080,6 +7080,21 @@ struct fc_function_template lpfc_vport_transport_functions = {
 };
 
 /**
+ * lpfc_get_hba_function_mode - Used to determine the HBA function in FCoE
+ * Mode
+ * @phba: lpfc_hba pointer.
+ **/
+static void
+lpfc_get_hba_function_mode(struct lpfc_hba *phba)
+{
+	/* If it's a SkyHawk FCoE adapter */
+	if (phba->pcidev->device == PCI_DEVICE_ID_SKYHAWK)
+		phba->hba_flag |= HBA_FCOE_MODE;
+	else
+		phba->hba_flag &= ~HBA_FCOE_MODE;
+}
+
+/**
  * lpfc_get_cfgparam - Used during probe_one to init the adapter structure
  * @phba: lpfc_hba pointer.
  **/
@@ -7135,8 +7150,18 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	else
 		phba->cfg_poll = lpfc_poll;
 
-	if (phba->cfg_enable_bg)
+	/* Get the function mode */
+	lpfc_get_hba_function_mode(phba);
+
+	/* BlockGuard allowed for FC only. */
+	if (phba->cfg_enable_bg && phba->hba_flag & HBA_FCOE_MODE) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0581 BlockGuard feature not supported\n");
+		/* If set, clear the BlockGuard support param */
+		phba->cfg_enable_bg = 0;
+	} else if (phba->cfg_enable_bg) {
 		phba->sli3_options |= LPFC_SLI3_BG_ENABLED;
+	}
 
 	lpfc_suppress_rsp_init(phba, lpfc_suppress_rsp);
 
-- 
2.13.7

