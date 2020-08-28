Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB40C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 17:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5064820776
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 17:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="K1dsz6Hx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgH1Rxz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 13:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727910AbgH1Rxo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 13:53:44 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF384C06121B
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2020 10:53:44 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 17so1003869pfw.9
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2020 10:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9wM9AYIkjemrEBMgPi0DCNzmMOYzb0jwpAqK0jVf/lI=;
        b=K1dsz6HxGl4iF0vzCimuvcVn490fY0b58x2Uq0skDbKm7j8Yaiy09jMRri6AwrvXkL
         JDRVDC84KcQpsJVWG2ELF+/JViTLSlzOe24eEdVGCTccG0Ipl1S+h5vekBET0J2ROfmV
         +1AudsiUIzwR4M7ppNxilAZ5uolfv2DZagojY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9wM9AYIkjemrEBMgPi0DCNzmMOYzb0jwpAqK0jVf/lI=;
        b=azWEipHQjlUFVs07Psf4gt0Elo6wcEjwwxyfqyU+XYGg7ME+eDiQYvo9RoPMzLlOyc
         aaHrQ96U7pLigX8zcbViVwc+a65qFNNcLDfRxnFeOE24mIaO48BWhD/w2Og4QF2pLSkb
         h7QbTOB75aSVqWLxh9Fznb26zy9ObWE8mP6I1dZsxontioGIOpjGazyn4fjPf7Bs9o24
         ZJmN7DOJxSdskbRZHoS4HqqKWMPCo0+a2XXberU7wkhHqu9zbxxTzVBnmEV19bIacY4q
         rktztnORvHrFAk9dj5y/BLL8cZQ3tzPg/2VS0qvYb0TUinNj3bDcNeH7d1AsrDzYHI6H
         o28g==
X-Gm-Message-State: AOAM531a4OH1qIe9OWKV40V8U46PKjbC3lZ2hXzpdIRZsEkpHNzbkQJo
        w8eW48xaqeLcUoRuSgx6mNKKaSMVqqqVrV4orEfE9VMMAKZb6wZFwWacP/N7+SKW0HxDZGeEbfr
        QJ+isDF56gNoE7hUNFDnHRcSSX6UgaUxzFz4F72RD9lknxO/jl2Mto1KQUM2e7qdUCG/LIWrrQN
        nY+as=
X-Google-Smtp-Source: ABdhPJw8SQJyXkB8cm0iNNUtfxnzBKHh7DfVZ3vmxMcSzDLd0OqInrFYGfzzDkyH3oK/OUSKl0xOfg==
X-Received: by 2002:a62:5543:: with SMTP id j64mr135167pfb.45.1598637223741;
        Fri, 28 Aug 2020 10:53:43 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e65sm88734pjk.45.2020.08.28.10.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 10:53:42 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 4/4] lpfc: Update lpfc version to 12.8.0.4
Date:   Fri, 28 Aug 2020 10:53:32 -0700
Message-Id: <20200828175332.130300-5-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200828175332.130300-1-james.smart@broadcom.com>
References: <20200828175332.130300-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.8.0.4

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 20adec4387f0..c657abf22b75 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.8.0.3"
+#define LPFC_DRIVER_VERSION "12.8.0.4"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

