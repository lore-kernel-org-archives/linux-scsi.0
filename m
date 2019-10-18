Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89BECA9EAB
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DF482089C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="scvg2qPX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506109AbfJRVTZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:19:25 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46632 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502466AbfJRVTZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:19:25 -0400
Received: by mail-pf1-f193.google.com with SMTP id q5so4598039pfg.13
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CS9A8rUwvvgVeZj1GO0xohNWoszuak1rblbsTP9Hk1g=;
        b=scvg2qPXro8BjUz3lIZCZcFB1GLGIBa8FyIi2Xlb63Lv26oE5sCEfbqS5rVa/65bT0
         YWjEPzVLQYtM7T/D5dta/B9PU6yaK8eAO5jQDiPAmlJNbWFSENLvYl79xs1HNi1ULrf7
         Lo/38/FZ8PFrhHT5oCdyHlqSHAxnOzuwmmA1xqvekb3a7OmsVsQP0JHAJCvSYCHxDRDK
         RqrNqavT+rS59ocZUIr9zOM85cWxSHhrBr8OA2Lk0MIJEgPH0/7dv1X8/ORnX1kl755x
         sWH2c0oBs2FHAbXvy0eGcDY3EIe1Z/YB0kIFN0+ZaEO+ICviClcjSaNWjtRzYRjQF5l2
         4E3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CS9A8rUwvvgVeZj1GO0xohNWoszuak1rblbsTP9Hk1g=;
        b=U5UOrzPgeyZQcsWeQtmT5QT2bmg62RC6nOoH7g+HqjPHjHSkxfca+GCeSnCyZoFeFi
         BkLyVQtTF2h5IaPxzUQHgSHm0XKj2+phW5S7msfv40mjxES9LLcYHlonqX8/dCxt92+P
         Bo/3EcILt+vUJULBe7Epc/uVqXoc7pPEh7Bo+b20HNQjbVNrKQPa/zCxEVmGZHTo6ZhB
         6TOX73428rMEoBFnD5q2WfpmeIyu2iandaO4TgGgDHII87UeFykIdT8VVv9MeJS9vhDw
         K5wsYXEBol7h4RQAzmUrqH3vglXDquD53KITp+7uqaPlKMLQXBF1PnTxAJWizyPBdsja
         8rjA==
X-Gm-Message-State: APjAAAUAcs+dHAKeuWf02pdTjVdqJPzPgldeYedo7pt1OZMB8ch5uPXT
        776aeADSIRWpu79rmNXMqGvURFO0
X-Google-Smtp-Source: APXvYqz/qqz0V3ftvYBUOJePoyJwvdY6rS5Q11Nd8+gSYmJrXfJXef9hMjGXQ/LZgiCMX9lv9rQ18g==
X-Received: by 2002:a17:90a:c38b:: with SMTP id h11mr12941418pjt.112.1571433564222;
        Fri, 18 Oct 2019 14:19:24 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.19.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:19:23 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 16/16] lpfc: Update lpfc version to 12.6.0.0
Date:   Fri, 18 Oct 2019 14:18:32 -0700
Message-Id: <20191018211832.7917-17-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.6.0.0

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index d8839d95f7fe..ed1b10b0161e 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.4.0.1"
+#define LPFC_DRIVER_VERSION "12.6.0.0"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.13.7

