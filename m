Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3C8C07E9B
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4473061CD2
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhGGSqw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbhGGSqr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:47 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9ADC061762
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:44:05 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y2so3021377pff.11
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yy/iYGV/KYaKOPynXND+If3cD1nTCvpSDTASDS9fR08=;
        b=Kw3M8QpXwGW5sOrDM70pLQ90n1B2eoC55DjzVVgZj0nRnZti9ZefEhaB+rr9RASCZO
         wmwKEkQTQQrQZ/T8HhPiCRSQprrIWUJ5KPXOD8Dcjics+R+IcMgOXo1XBgbGJvkFxkoZ
         71b25wcPGtSUbB1SCTjrXeVfJW9dta8BnwCqXi2alT8PCsjsrqGFgCUYtpIO5TUsJ9Bk
         PU/bG1aBUKx9ig6kChWfE+pi3+st676KBDxUdHXvYqMBIi1BBKWCpzSbgriykws3gAZV
         I1ypULnDN8qngyYfmzWTf8Myi+YU2VfHqVk82SdujZrfnS74b6Q+NFdJ8PrAH2vzTUMh
         2Z5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yy/iYGV/KYaKOPynXND+If3cD1nTCvpSDTASDS9fR08=;
        b=P6WqTwkKMuIIDF/M4ncmSbVEGPchiyqr8dKGAaLPsgL8M4jPDv4Cntq2d/+SMgB7TG
         Elr5tw3SSdUCbzsyioEepRR9vtBVr7xihJWm3XxIdCdnjTvSnjwVafyAEGzRYPR9+vaS
         B11k1Mk36r4GEf7mt1SCZE8+fdwtxnjIt9yMKr1cJ9+RRaHmE/tmwTjt0VbA6cn5wsLQ
         IRE1lMgm+ga6Z4IA9VAuMrjjJe0SrflKP9boHNDJDDl8TyhEZqXO4se7ltU/gD0rHGVw
         iqY8aMch9gxl2Va0GxnZYf8Dsn+3/aCAiA16W+SUtvxQ16qIds3pBEYf19WjWnXFOElY
         H5Pw==
X-Gm-Message-State: AOAM5323jbxI4CWKTQuYD5VrZrLdZqfzXAslaXVuYY2c95L6FNGV8AKA
        RglfPZXC5BcoGZ9gfkiuwHhe2GccwBE=
X-Google-Smtp-Source: ABdhPJwGuNUDLNPMQgSwFKZD6BVWG1Wcn9/5XfA6anSd1vcHKzVekCJ9ehmTo7P6aH1g+HJbWdmRIQ==
X-Received: by 2002:a63:e316:: with SMTP id f22mr27357487pgh.100.1625683444621;
        Wed, 07 Jul 2021 11:44:04 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:44:04 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 14/20] lpfc: Enable adisc discovery after RSCN by default
Date:   Wed,  7 Jul 2021 11:43:45 -0700
Message-Id: <20210707184351.67872-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Assign a default value of 1 to driver module parameter lpfc_use_adisc

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index eb88aaaf36eb..457989cfc0b7 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5412,9 +5412,9 @@ LPFC_VPORT_ATTR_R(fcp_class, 3, 2, 3,
 
 /*
 # lpfc_use_adisc: Use ADISC for FCP rediscovery instead of PLOGI. Value range
-# is [0,1]. Default value is 0.
+# is [0,1]. Default value is 1.
 */
-LPFC_VPORT_ATTR_RW(use_adisc, 0, 0, 1,
+LPFC_VPORT_ATTR_RW(use_adisc, 1, 0, 1,
 		   "Use ADISC on rediscovery to authenticate FCP devices");
 
 /*
-- 
2.26.2

