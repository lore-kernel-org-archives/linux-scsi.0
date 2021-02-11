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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0DDBC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD1F964E44
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhBKXrX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhBKXqc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:32 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F09AC06121F
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:05 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id t25so5071075pga.2
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PP5qfphJSo2ohYrBq1IGAxXMaJIgoockdBFaDi4uDPA=;
        b=lRiYi51mpaWHZRT67Wi1UO8j4a8mQkh0NaqCQYJzHN6rnueqiBw0NrZmqx+Rra+KFp
         Hibb3YfwWMvMTUTD3SrCVUZROhNVM825lv5oTotBnPn1j/6Ye51ft2NGbGdlrFR79FQ3
         9EQ98hn8YCYoruI5JcKwkt6eCDTZxlFBaRdei8nK5uHEA+Dl6y7OOnVIiekm/J65Kv8T
         DhE9r/juUoBXwjl4j1mSmvXd9cbW0ejHgUdACUvsqywNkkrikGmcJoduNgCLdmE07OlI
         2MTQxp6tbHSBYjW8eEqbG3bTfE6Q1eorhnzMOdEwGw+tFltJCvvQ+egPkyWsLugsfAaz
         yUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PP5qfphJSo2ohYrBq1IGAxXMaJIgoockdBFaDi4uDPA=;
        b=bTejT89ZB4yz7RwrmiPoQ/KNGbNwUSzBQIRFnim8+GQgjs1IU0xugZJCyhDInuGvHS
         DuN2BHtZATABcu1KkbV70ZXBCgUVQqNQkHOoAsKpiUHhm21HILJVwaRyiBNyYSduuOap
         9VmdZZlSeOFphOafBmYgoYJBfKKA8EoQ7HyQL/hGzOHqIhHUZ0o30+hO1cqd+QZZG5Jn
         ZZqpg+oak5uMiUZJCOc1uACzahCM3BJQsAI5W16Py41kUdi7fXNg8hUogE6WlsA8YHKb
         QHOMDvy5iLUUfMhKsYlEAEtSdQpFxLS/4FxNnYX7ymwqz+hBeo0YIL2nmSn3LRRWKedq
         /HhA==
X-Gm-Message-State: AOAM5320Nz5BUAyiwtFByoaCugDLPfdoc6pQ1uGcmPgr6oxVvnQS0oPx
        SQz1OMiyXnQfzLujj0mZvXs8SiGKYOU=
X-Google-Smtp-Source: ABdhPJyuwtwrOpJmGy2/iBZuNQwpiEQx1cwbaKMFPsGtQM71BFt3zZo41/317k4kdyyoZg8/V3ktQg==
X-Received: by 2002:a62:191:0:b029:1dd:3b65:c91d with SMTP id 139-20020a6201910000b02901dd3b65c91dmr452953pfb.14.1613087105121;
        Thu, 11 Feb 2021 15:45:05 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:45:04 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 21/22] lpfc: Update lpfc version to 12.8.0.8
Date:   Thu, 11 Feb 2021 15:44:42 -0800
Message-Id: <20210211234443.3107-22-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.8.0.8

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index fade044c8f15..6360aa95c6b2 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.8.0.7"
+#define LPFC_DRIVER_VERSION "12.8.0.8"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
@@ -32,6 +32,6 @@
 
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
-#define LPFC_COPYRIGHT "Copyright (C) 2017-2020 Broadcom. All Rights " \
+#define LPFC_COPYRIGHT "Copyright (C) 2017-2021 Broadcom. All Rights " \
 		"Reserved. The term \"Broadcom\" refers to Broadcom Inc. " \
 		"and/or its subsidiaries."
-- 
2.26.2

