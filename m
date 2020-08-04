Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B894C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DE4922B45
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:07:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="XdKKdxmi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbgHDJHQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 05:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgHDJHP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 05:07:15 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76760C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2020 02:07:14 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id r19so10159690qvw.11
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 02:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QQ5SWJbXNQxm9XdpbHedBI4tomXq7IgJ5hXPLUA4gnk=;
        b=XdKKdxmi4CeJxMFtqCyOGx687HcP7gqA2YosCNiQqgmLuSQz+3M1lDbEA1UFQYiN6B
         /flf3Uy3rANVRZE4eRpArw2c2C1Sva0T2XzcxZym5IJ/sC7isx4YKbhOrTaXOI7nrkie
         FaVbOeNodHGf9RM08NDKYQwLPkkEoeDqQmW/M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QQ5SWJbXNQxm9XdpbHedBI4tomXq7IgJ5hXPLUA4gnk=;
        b=PTqTBfy9a+6VWiIfG9vpm3PcBcPSKLwVxOnKWZSiFbDNOyG5ymutTa4aOMFHWHRiua
         fZnA5BJKaRCE++PU1P4k5/pQRkGoamJtjKH1YPWiGj9yt+aGr6mDNwajps8eIfa+7Amj
         B3/J3DDdHinrUAFVdYsXv7omsRA05kKL0IHxPbrMZcwtNoh2jkm+yFFTsgL9aYjeT8Hi
         ZX4QeXXMQXifcPnXwK7aoLKZyUWD36EODNt4byHCsb3csZtAAoQXQWxJ1U6kgrDc340c
         dFklAIpRpqXJKoF1q+Fztl+YWdL+YsS8deFDlcsFdMFiKnqeLRCDsDTTEX2VvEAMbGAj
         1P1A==
X-Gm-Message-State: AOAM532PjmHnQEqNdYjtIYf9BkAHzPgyUwmbK9jKZ9FwyhOUJDwWBs6Z
        d3mVwRSQHCtfYBZk2m/l8MjpSu9qy1U=
X-Google-Smtp-Source: ABdhPJxzTwtI4/EtEsPogoTFux2DkrCKTIJSa+agw5CO+iGLn1CTdIL5eu2ZQYRmZ5Dw4RSajWt+Tw==
X-Received: by 2002:a0c:9b89:: with SMTP id o9mr9460302qve.77.1596532033660;
        Tue, 04 Aug 2020 02:07:13 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 65sm19989407qkn.103.2020.08.04.02.07.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Aug 2020 02:07:13 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     pbonzini@redhat.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [RFC 03/16] lpfc: vmid: API to check if VMID is enabled.
Date:   Tue,  4 Aug 2020 07:43:03 +0530
Message-Id: <1596507196-27417-4-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

This API will determine if VMID is enabled by the user or not.

Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 4258d05a7032..1b950d6641a2 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1507,3 +1507,27 @@ static const char *routine(enum enum_name table_key)			\
 	}								\
 	return name;							\
 }
+
+/**
+ * lpfc_is_vmid_enabled - returns if VMID is enabled for either switch types
+ * @phba: Pointer to HBA context object.
+ *
+ * Relationship between the enable, target support and if vmid tag is required
+ * for the particular combination
+ * ---------------------------------------------------
+ * Switch    Enable Flag  Target Support  VMID Needed
+ * ---------------------------------------------------
+ * App Id     0              NA              N
+ * App Id     1               0              N
+ * App Id     1               1              Y
+ * Pr Tag     0              NA              N
+ * Pr Tag     1               0              N
+ * Pr Tag     1               1              Y
+ * Pr Tag     2               *              Y
+ ---------------------------------------------------
+ *
+ **/
+static inline int lpfc_is_vmid_enabled(struct lpfc_hba *phba)
+{
+	return phba->cfg_vmid_app_header || phba->cfg_vmid_priority_tagging;
+}
-- 
2.18.2

