Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7520CC4332B
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B83E2072E
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EM3XBXok"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgCVSNZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 14:13:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45933 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgCVSNY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 14:13:24 -0400
Received: by mail-pg1-f196.google.com with SMTP id m15so5939885pgv.12
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 11:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m3GgwYvlkJtUPaCHPO6wSTXSd0GRHX6emkiKLLuoV3Q=;
        b=EM3XBXokj4uGE/MGo4hsBj8A3QyFBe5PKDhnpILq7C+1RWevtdnldgxHDawzGPPYvM
         iTcNLF4tf1L+l4QlhqFbsbO3sGRLHbUZLmo8W5ptIqsWM0PytIcRdXS08lHBJEp1fsy3
         KvaWXoYefs9Em5RlbBn1/c4qSeTjwq4awP93Ts+y62Dghfbve4ePb7AYMQUTfFtk7UKL
         rrPXV3pdiPFi8BwgLhAgTKpgcC/Cz2PilFLBTyi2O3nFsJBpUc8Rwnyx0VCVFbeA7j3P
         vGQ6Yb4fKJgnJr95R7gnth5xCqBHPQJOc87Xgtga/p0JHjsMyAwAHkNrLj9aTjfJQpDi
         rOYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=m3GgwYvlkJtUPaCHPO6wSTXSd0GRHX6emkiKLLuoV3Q=;
        b=RhGue4svWHFXV/eGhQndgAREKEsrjf4UFNncsGWGvVnCHjA6YQWQyGKLeGBGtFzPJ5
         HlrVI8BDyXJs5wVv3GkRiHswyWbhbIDYFP1LpGCg11FkHA6El4hCmyIl1tNsltE7H1NV
         x8+melXycMLSFiO2QrPw1514tUwXEdxRHJsDbpM/RFOGguostKvW5e86jduKvlGUYHtl
         4HrsVhiCxJKHxexzesvM9PZ+9ekqImbPLlXpGDt5Arlq6F8IjYvYG9o8BvQ+ql0xlllO
         bDPpAopZ/U7evwlG4VTXhb1xTN7ocucr3a+/NIozeH3ON1RRdY0FLrn+4sQmJMUi2YLD
         oKEA==
X-Gm-Message-State: ANhLgQ2jCRvCT6SP0UiHJ/VuIQGolmGm6RTEeucwKniaV8CtbQyo8Wat
        1bV2J+jsJgRbGlhHiu35RIiK7m5E
X-Google-Smtp-Source: ADFU+vuUlJ/vH4Ic/x3dIOi1g0HlYgQHOTva1GhuZP3oxdGvXEhotSi0Aqig+Eq6dMzOjs5KmAjv4Q==
X-Received: by 2002:aa7:9f11:: with SMTP id g17mr20793501pfr.224.1584900802445;
        Sun, 22 Mar 2020 11:13:22 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id bt19sm1331657pjb.3.2020.03.22.11.13.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:13:21 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 09/12] lpfc: Change default SCSI LUN QD to 64
Date:   Sun, 22 Mar 2020 11:13:01 -0700
Message-Id: <20200322181304.37655-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200322181304.37655-1-jsmart2021@gmail.com>
References: <20200322181304.37655-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The default lun queue depth by the driver has been 30 for many years.
However, this value, when used with more recent hardware, has actually
throttled some tests that concentrate io on a lun.

Increase the default lun queue depth to 64.

Queue full handling, reported by the target, remains in effect and
unchanged.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 4317c9ce7eca..ba786d08de01 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3870,7 +3870,7 @@ LPFC_VPORT_ATTR_R(enable_da_id, 1, 0, 1,
 # lun_queue_depth:  This parameter is used to limit the number of outstanding
 # commands per FCP LUN. Value range is [1,512]. Default value is 30.
 */
-LPFC_VPORT_ATTR_R(lun_queue_depth, 30, 1, 512,
+LPFC_VPORT_ATTR_R(lun_queue_depth, 64, 1, 512,
 		  "Max number of FCP commands we can queue to a specific LUN");
 
 /*
-- 
2.16.4

