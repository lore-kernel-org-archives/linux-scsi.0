Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEA7C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3609821582
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMt+26XW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfLRX6c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:58:32 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51745 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfLRX6b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 18:58:31 -0500
Received: by mail-wm1-f65.google.com with SMTP id d73so3652798wmd.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 15:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5yOUiAdfGCzDfQkiqJsNYF8xa1i2MT8Bhv7OHRnaL/U=;
        b=bMt+26XWU6wvdwTJ+ma2gsJ7QofXNf/+L8PTGSXDE2cSlnbZNuKWeplCZdgqmEC9kh
         sq8CNqFOsHsPqxfwsDD/Tj+HZpiAFFj6177hAqcQZjFI1YMzXGlHAkPkUnz+rs38Wkn1
         89RFo1pHzOGJBy9FUFOPCAfIaTNqR1chS0tM8t95j/KgQKkYciiIrpi1gSTmsS8WRcPQ
         Fy0UBtZS1/RGBczo5mvVFfEysgKNWA9UP0OLZef1+/4M6ZtT4I7b0/vqiTZsXGpqTAd6
         zcBJL1MuxOCqEAzRU3hxSDIwg5Ocms8yBUgTNLjRFtDZML9rg/n5mq1ERCjadFb0Qzy/
         G6nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5yOUiAdfGCzDfQkiqJsNYF8xa1i2MT8Bhv7OHRnaL/U=;
        b=A+4oQKlPpy6sNEmsyAJ+FCPQlwYhNk0Kw2pCDpHcobHixxPrrhzIlSUvjgTsS9UBn5
         wC5w/cT7g/M5CVwE9YKSO7o+viBOiWevetqjfS38CNIFGS/+AOuoHkeE2lKGUAtlPMyP
         zpx4SXgyK+1ramIPK50Bl7wAf5USFKCteIsre0zpBp8iCctLUUMFlQltVrXRV9Pd0pO2
         tHpS70W8FElT1PNnjo2nAinZHStZCTPGYb3ucMd2/7lz/lJ6JlaEI7SqZcTnNJvTlqia
         ml/d/e9SQTytL9io5ua88l9n0CtISrw0bp/VSnmaDhft1fqO4MsGG2pAVAPjUzXAKpZ7
         jCYA==
X-Gm-Message-State: APjAAAUQqardDylhYdQ1khg8HN9umTJmiWF+GHHioJXXu5RJesbFids2
        5HESePk7eoW1j3oXU2YpDlgKsCfZ
X-Google-Smtp-Source: APXvYqx8SlLQMS9ZPpxzRXThbNEEkBGMkAKmQO7bsqee0v8Wt87cd/4Ma9FZXSjY+EhpHhR+XeZjGA==
X-Received: by 2002:a1c:dcd5:: with SMTP id t204mr6655403wmg.34.1576713509512;
        Wed, 18 Dec 2019 15:58:29 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x11sm4240731wmg.46.2019.12.18.15.58.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Dec 2019 15:58:29 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 07/10] lpfc: Fix unmap of dpp bars affecting next driver load
Date:   Wed, 18 Dec 2019 15:58:05 -0800
Message-Id: <20191218235808.31922-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191218235808.31922-1-jsmart2021@gmail.com>
References: <20191218235808.31922-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When unattaching, the driver did not unmap the DPP bar. This caused the
next load of the driver, which attempts to enable wc, to not work correctly
and wc to be disabled due to an address mapping overlap.

Fix by unmapping on unattach.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 3defada2602f..4685745aa6ed 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10441,6 +10441,8 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
 	case LPFC_SLI_INTF_IF_TYPE_6:
 		iounmap(phba->sli4_hba.drbl_regs_memmap_p);
 		iounmap(phba->sli4_hba.conf_regs_memmap_p);
+		if (phba->sli4_hba.dpp_regs_memmap_p)
+			iounmap(phba->sli4_hba.dpp_regs_memmap_p);
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 	default:
-- 
2.13.7

