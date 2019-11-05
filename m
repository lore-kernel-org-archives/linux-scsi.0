Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8AB4CA9ED3
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FEBC20717
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="foD/8/CQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbfKEA5c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:57:32 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40949 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729524AbfKEA5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 19:57:32 -0500
Received: by mail-wr1-f67.google.com with SMTP id o28so19267788wro.7
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 16:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m/5kiWDbP9kpdxmOHcEboaZfh1ThCThcktQy0QZbf80=;
        b=foD/8/CQ1debfbXF1H6AeNQoFtQuHJnPftLEtvcs018hT7++um1Vom9zl2tZY88ucl
         Opzb789TZ+gSfXON1HJMYXMSShVugOfIez5N1ObP8sqTzoRUMi29SCdCOhx3X8M8MGkR
         j84ZJmGOjynIXSMJ2SPJW/MZxrWkMVd+lfnzzvpJxk/Y31t2TKUOICgULHaD2PpHkYmO
         xJg5Sdn7ks1ksMTclIwgFyhJPV3NvKIeQMXzpGJVfp+zoo7jNwk57slNZl3eDzpiPom7
         9IMZTE2qe/2Sg+fyWXSgwvHMzuI+tqb0EPBrrelUQa19+bJbNhvQPykZUpO50tynwFMd
         T4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=m/5kiWDbP9kpdxmOHcEboaZfh1ThCThcktQy0QZbf80=;
        b=ElR1RbvRINFMX14oKUm1YVlaxIOyz498ma1ouRhyhvgrDd9HSnLKRfusQMs2SfwxPd
         tBM3SKBGsM9ECcerNyfpJI80hIQEMG3nAXGsZx+g3g5tzjKE7TcPs/oUPuMBIgF0BGH8
         UiYuhCJ8ElMZKIPJj2CRKsHFi6jBNbDt4d3IKcaEA2NiVAJW21Y1ZbrKncRzwJLgUiim
         f9hb1GsBkGLn9lEULDawAvNTeIS/D4kQhze753JD8+uOsiezakjS6NhYWbAFQiFXOf8W
         1SLTuGQzA9VgYF/rbsHY6oRuqdvDCx1XwgBuAE6AOE2NYp6XIuXyFiwJi4hc8WXirmP2
         WlDg==
X-Gm-Message-State: APjAAAVX0BWIyh8oIl7OpiU+M4if3CohTQZezEdvQNorDRH2WcBHF6Zq
        sbxqViC2ZTi6fBfasHWE0MXplzyeQgI=
X-Google-Smtp-Source: APXvYqxo5AzwxOrFnq/e/CD0qTeE2DW/77sd9kdwZkxEqtNAbTJw8z5E/uIiP9e2goizMp7HCPkXNg==
X-Received: by 2002:adf:ee84:: with SMTP id b4mr23908404wro.31.1572915449076;
        Mon, 04 Nov 2019 16:57:29 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id g5sm16920991wma.43.2019.11.04.16.57.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Nov 2019 16:57:28 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 05/11] lpfc: Fix dynamic fw log enablement check
Date:   Mon,  4 Nov 2019 16:57:02 -0800
Message-Id: <20191105005708.7399-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191105005708.7399-1-jsmart2021@gmail.com>
References: <20191105005708.7399-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The recently posted patch had a typo that incorrectly tested the receiving
function.

Fix the typo (change == to !=)

Fixes: 95bfc6d8ad86 ("scsi: lpfc: Make FW logging dynamically configurable")
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
Prior patch is in the 12.6.0.0 patch set and is only in 5.5/scsi-queue git branch
---
 drivers/scsi/lpfc/lpfc_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 3f30bc02da9e..e7f6581935bf 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5981,7 +5981,7 @@ lpfc_ras_fwlog_buffsize_set(struct lpfc_hba  *phba, uint val)
 	if (phba->cfg_ras_fwlog_buffsize == val)
 		return 0;
 
-	if (phba->cfg_ras_fwlog_func == PCI_FUNC(phba->pcidev->devfn))
+	if (phba->cfg_ras_fwlog_func != PCI_FUNC(phba->pcidev->devfn))
 		return -EINVAL;
 
 	spin_lock_irq(&phba->hbalock);
-- 
2.13.7

