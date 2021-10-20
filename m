Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3481C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A768611ED
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhJTVQx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbhJTVQp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:16:45 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CE8C061753
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:30 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso3366187pjb.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0260eTtRLt2mt0F000DRQ8xDB09XLz0Zy3FRehQG09s=;
        b=e+4a53C2/HwJYGIOpYoq7uW8SEpngZZAbUe9zPNmogZhHSn1ZcMM9BJc8zu3uf3nnW
         KpSqRpqAe6YK4ndb7J5rqyG0xE10x0VOqpvvr6W9OkeRVPmlVvXg0H/2byiq4JViw6Jp
         B3vzhcfkpU3wXN5nlRVshfIjIqyddxJzJYhAH6FaqqXSJOxrJNQFcsX628n0wydlZQfE
         lThFUHc2mn6/Z8529qyFR+Cmj322tukUg8fQ35nVzcF9/BiqKjvubm8PAth3e5eenOcB
         tIX1oUE75hkzHeM8hAnuCZwFYQKrc5kIaBcNJ+8tUEIex356rfsL6Wq5bgkboNArOaYP
         bE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0260eTtRLt2mt0F000DRQ8xDB09XLz0Zy3FRehQG09s=;
        b=ls/mBDF4SUFdJzJb21nCIhepj5MD3GDCb85DUrYfoThkhbsv7g+tXpqVUBb6KJqDlV
         XHc+KseAdiBOUHJtHADvCzCTyQoGGm+eG/e/l9Zkld4oLVhcnADHRYz25+ekTSocFaYr
         kV996CaC/efPRP4ZCDGDRXwjmOjR+jjdn8MzTT/J2IbKrQDF9WQpIsBpT3LZF6wOm9cC
         OY0z36Zc09J7xmYDTfdsb69nuHb8PhfdJoS7Qx3F4Tg2BQzTX4QLE7/SLYBpFxw6eUhu
         UcFVdjn38qh3PA2lXBTszAPR7OsBAL43SJcSCSOgf1lF5+hWJ+7HjJZVryNxRhyuFBdG
         8yNQ==
X-Gm-Message-State: AOAM532H192CD3Becm6/X0A2ecUZ9SdH4J/9E1qnIa7ge+PZBHLMCehm
        iAFprklvkJ+W9hVDoFRAfrJB1O747yU=
X-Google-Smtp-Source: ABdhPJz7PD/kRCggKSFpvx8n/N5xYr3bX8+Z+M0PGPMj7/cqJwwW6nKV3kRvDnbyxoTyGiiRp8Gy/g==
X-Received: by 2002:a17:902:ab17:b0:13e:b2e0:58b with SMTP id ik23-20020a170902ab1700b0013eb2e0058bmr1371920plb.9.1634764469732;
        Wed, 20 Oct 2021 14:14:29 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id pi9sm3700689pjb.31.2021.10.20.14.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:14:29 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 8/8] lpfc: Update lpfc version to 14.0.0.3
Date:   Wed, 20 Oct 2021 14:14:17 -0700
Message-Id: <20211020211417.88754-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211020211417.88754-1-jsmart2021@gmail.com>
References: <20211020211417.88754-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.0.0.3

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index dec71775f677..5a4d3b24fbce 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.0.0.2"
+#define LPFC_DRIVER_VERSION "14.0.0.3"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

