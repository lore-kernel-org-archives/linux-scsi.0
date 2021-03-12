Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEF3C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1BF264F00
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbhCLJsj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbhCLJsG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:06 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121F4C061765
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:06 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id 7so4443978wrz.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eMNrAANtdSm/KApZn99Iy+ukBxQxfETDJsJVLnxM0ss=;
        b=spXmC2/JKBd/fcKoBaLN9rUOh2lrc8tlt/Qu9hmPrnaeLvL63dpxTr1rk3azNkhEJp
         llosrA2xyN1pBe3gTj9enA2OyaeYkUPSOl12KZuF7jtIIvQImi/x2W6oFgn9LXvkuF4u
         82utRDsAJEKoRbxoQxP7mNunsoW+/4xMr6xo3QnXC9Wp5pQbqj4dCD9ENN2J6lhyXr4p
         9CVAGqSGvuP1Nj3MDNGt218pVtsI0f+zbDmiHSR6Xu5zkt7oMDTUI/qu4wlh2k7Rivl5
         w3ZCdNiaeo1iCB2fNiYzA6WQXnXxRfmMwJ9J65DSZnq6+LBbBu7472RsKhT30KGSxzjq
         zU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eMNrAANtdSm/KApZn99Iy+ukBxQxfETDJsJVLnxM0ss=;
        b=gWSQNIC1IVe/fOllv/RESQO8ZVpL8uV4P4ek8ViKZe0JE+pUcRr4+KnQgfCEIPDIE9
         pBinVhgQVGFr9JNzq8A7t/56SONEO+mQdR/7dTV7tYWgcyDC2jljDDwI0kit1hhZrbku
         MQ9klOIghyI0hYBi/kyANKPzWFx5hcioWKYWNRoCzob00dCSbAPWDpPYBGS03DTPNxnr
         8+zEfuBpFdhAMAFEVozciLvAU6TqFNpZPjypiP9yB1OEQr4Am+aOSJed32Hg956PxlrY
         d4kMnlp0toycpLoyM/Wm/ciSrGisjNFkEWk0oMhvoEkVyXDzAATtZ5RYr+pl0GTqN9w0
         bZ1g==
X-Gm-Message-State: AOAM532jI8sLhBWIUdEqaK1LyFyYHJNUTwcZWRGWyR4VPt/S1ytSpSn7
        3uYrcg0jfJv0BauXIT3ujTS/PQ==
X-Google-Smtp-Source: ABdhPJz+tnrsV1zdhCqwNcgmv8npJAuDGV5x5Q9B4Ny0XY8vHHMg9Ea6dY2WeSjB6/3frN5TEVKzBw==
X-Received: by 2002:a5d:4521:: with SMTP id j1mr12820216wra.354.1615542484778;
        Fri, 12 Mar 2021 01:48:04 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:48:04 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 15/30] scsi: lpfc: lpfc_nvme: Fix kernel-doc formatting issue
Date:   Fri, 12 Mar 2021 09:47:23 +0000
Message-Id: <20210312094738.2207817-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_nvme.c:2021: warning: Function parameter or member 'vport' not described in 'lpfc_nvme_create_localport'

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 5fe4e93fe984e..4d78eadb65c0a 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2002,7 +2002,7 @@ lpfc_release_nvme_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_ncmd)
 
 /**
  * lpfc_nvme_create_localport - Create/Bind an nvme localport instance.
- * @vport - the lpfc_vport instance requesting a localport.
+ * @vport: the lpfc_vport instance requesting a localport.
  *
  * This routine is invoked to create an nvme localport instance to bind
  * to the nvme_fc_transport.  It is called once during driver load
-- 
2.27.0

