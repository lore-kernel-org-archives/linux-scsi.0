Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F5CC4361A
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F24065089
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238478AbhCAR2Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238047AbhCARWE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:22:04 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A62BC0611C1
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:42 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o6so12323387pjf.5
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PP5qfphJSo2ohYrBq1IGAxXMaJIgoockdBFaDi4uDPA=;
        b=WzO0ic/vAYFhdMAbxEyyGQfDMYI45vlxhz+3bVJHVhnVN8KqHH/ouJT9SPpNB1DoPt
         Xedz9T2ctot7ZlEiBN7pA74yDZzmz2v7xge96njC/6ciCh81kfsRfZoL4ImBBqnLeMKb
         4DdGfQP0yRSQWg5GfvPDo754EQH376ZSNXQXvD7klYnrk2pIHCy9rXpkPtzTf3Pm/9e/
         Egd6vQJD/fhBjw527xCd2CbQdbZ//cJtYekplOij4zcairvy0PCLr8wjgFna4WTp1QxG
         q7nJ32fJ54nH863IJcuAg9nNbxGFHUkM8G/bCz0sdihH9qJniHNL9U4nI7nA8ITJ7Qkv
         8Asw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PP5qfphJSo2ohYrBq1IGAxXMaJIgoockdBFaDi4uDPA=;
        b=jJDiLfaeRuBzicVDWs4xRKJlfSTOD23OvTjSxa5XKf+n3tZJVRtU732aAsScJbM2Q/
         Ke9Uf331r1Gkx/tVmXrhC2QtBgfZni3xmZQIXnNerZLIkM+mZcMamhlXL8vkYpP7Zk/I
         c2QSbSSSezWCApF75K2E2bs00tgjSVqMf7LDObWAABJgCtD8yvGD+5G05X1Fi5ESujGH
         BA0EfvmwFFtxB9Hr6GPNmwJLQ96Ixm6tGHbMGuW+YUCUa6XjRKhTRz0B29Eij4OmAWVe
         xBpZIfO540Vceo4bbmz5xXdvbnQADKGNkpIeA30DasmIKBr7fs1R5p3THcw2S+tavxUA
         TgnA==
X-Gm-Message-State: AOAM530Je3CZfW68r6cBreIuWusc+WQ2FhSTfJflYBbre8db+XC+gubq
        XX64PrPkRNHIaBw5RwB1t9E4dTwwJ9c=
X-Google-Smtp-Source: ABdhPJx2AC7bpnRHt4cOHMxZcqxYGPJPsaGyaqLmXWjx8XDBLw0/zkn+zWcS+oN5UnhDaz4+CxMSXw==
X-Received: by 2002:a17:902:d64d:b029:de:8aaa:d6ba with SMTP id y13-20020a170902d64db02900de8aaad6bamr16577704plh.0.1614619122071;
        Mon, 01 Mar 2021 09:18:42 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:41 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 21/22] lpfc: Update lpfc version to 12.8.0.8
Date:   Mon,  1 Mar 2021 09:18:20 -0800
Message-Id: <20210301171821.3427-22-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
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

