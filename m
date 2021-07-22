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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFEAC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 22:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E454C60EB0
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 22:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhGVVhC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 17:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbhGVVhC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 17:37:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B281CC061575
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2021 15:17:35 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id my10so8085677pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2021 15:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hDBLbjxBw3+7kz6M7LSxt076h4A7GGsCWQYPA0ZiLzA=;
        b=s+SxZCW6z9MD3mKh2+Dz+weOyP+icL8ZjPKwwVz61tmNKO5+vMjwUUwhm6SnLBkfZM
         Vfp2JYd1nYEN3uQWzJ7kO8Ba4+FLpvuiCYfdsV3gVP1gdbWKSVhvzzVgAZg8OPD8aueT
         PY9U2E50kvNkYzlhSI4jgsYd6LGyBnTL3W18OyIoK2aVA2MW+8sgCKqXE0H6TE7DOZ48
         nAUXz6c57ca0xPGfaCvu98GLutlFNUheujOeaEbCoxHHXgifA4NEtP11jDTGf18YkKw2
         Z2s037ZolIXWBDmq+K34asIeCbZ3mtJ3aeYjzSdWVIS8Wmx9JmM6bVT0t/5itrcrFwHM
         szHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hDBLbjxBw3+7kz6M7LSxt076h4A7GGsCWQYPA0ZiLzA=;
        b=ZY/tNCKnMRX3UPwOoIo2AtNCxz8VZoM64I8EoLYOPcysgkvHMByPMw8TnF8v6m/WMt
         6X4ifrSJgCR4B+1mYgdVacQMn4QnDLsculBK6LFrO3JuNnzJisYEFwR/qm3wUrEFmIld
         xwsve3mkZvzgAUphHVHe1p9ldxMOU68rnSaazhC20Zvex8XUJpX68Q1nfLCn+YdUDFLZ
         FpPHoY5/LVAVC+rTuNxtF4l8FT0FQ91RVYRCXjeBUi4UL4BPC3zcL2e0Uh5U/+jOzGSO
         39/32yVNE7+WNEiY0pxxMtY7KSrKvm36uXvwi+my6Vfin64zgKX0c7jQK5MXOiFydS4Y
         Zzzw==
X-Gm-Message-State: AOAM5331x07WUctPQYiQK+L4zJ644U6Ix9OAjFpjVCzD5IBNdMGzI9ZJ
        3Zyf0fFS3hWQW0ZdoV81pkOOiUdkQRw=
X-Google-Smtp-Source: ABdhPJz338o8WBt/piOJWbGgg3m0s9TqOVkg8jgEWTAtiASRAulqFZ8tJTpiMj3E8j0gD1hr7kw5Mw==
X-Received: by 2002:a17:90b:1484:: with SMTP id js4mr1767548pjb.155.1626992255261;
        Thu, 22 Jul 2021 15:17:35 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a18sm31374460pfi.6.2021.07.22.15.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 15:17:35 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 2/6] lpfc: Fix cq_id truncation in rq create
Date:   Thu, 22 Jul 2021 15:17:17 -0700
Message-Id: <20210722221721.74388-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210722221721.74388-1-jsmart2021@gmail.com>
References: <20210722221721.74388-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On the newer hw, CQ_ID values can be larger than seen on previous
hardware. This exposed an issue in the driver where its definition of
cq_id in the RQ Create mailbox cmd was too small, thus the cq_id was
truncated, causing the command to fail.

Revise the RQ_CREATE CQ_ID field to it's proper size (16bits).

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 4d9233de9ead..c31a0cbcc208 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1561,7 +1561,7 @@ struct rq_context {
 #define lpfc_rq_context_hdr_size_WORD	word1
 	uint32_t word2;
 #define lpfc_rq_context_cq_id_SHIFT	16
-#define lpfc_rq_context_cq_id_MASK	0x000003FF
+#define lpfc_rq_context_cq_id_MASK	0x0000FFFF
 #define lpfc_rq_context_cq_id_WORD	word2
 #define lpfc_rq_context_buf_size_SHIFT	0
 #define lpfc_rq_context_buf_size_MASK	0x0000FFFF
-- 
2.26.2

