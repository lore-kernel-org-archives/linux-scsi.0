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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89D3C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 22:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96AFF64FEA
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 22:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhBEWyY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 17:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbhBEM4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 07:56:51 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6B2C06178A;
        Fri,  5 Feb 2021 04:56:05 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id n15so6685097qkh.8;
        Fri, 05 Feb 2021 04:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MCmKjFqSwv+F771D19x9HxFaY8G1DMaBhMHn/mZeuP8=;
        b=UkSsxPTliFfvfYGPJaBmwNnr3/8C81SIPyQLpfW3UPc/HuurcezIlIdAOfJzrlYLQH
         3m4s+wnpOXA52QDNFmSA0QdvFM6vcJLS477sRTToBujn2ISx3MGhUWfTL63dlTWPexBv
         9nh0XDkVxm+kZq5vDUZTh9DnJvYvHHFcluH6CBDsuxWTr2Dolgzuu/kwGv5aWQ5/WAv4
         dDZmXv0CAMRoAopyEEP+HFGhQFX43flvYYJlV6kMS2xpUIuZI4DtRfceqBkRqWoGYg/m
         v2inKbTrXNYSrFjlFlWALuFIACBEiJW73uLyUPmbjxvcnFOLb74+JGRJTjNB77hDBt8H
         wMOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MCmKjFqSwv+F771D19x9HxFaY8G1DMaBhMHn/mZeuP8=;
        b=BdP+z8NxRf02BjraaORQiLGxpUYREtGBH07om2M9I3ix6Tk+vYE93fl1N+P4GwX68+
         x8Q9RTMdAxxSkWoFvuo15XX2LlA3GNaaaT/Osh4K/QqkcBXw4n86XDYIyqPff58M4PX8
         aaQ8rOhjB5Kho9Jkn1OruhHDzXJTlCEHRqrAb92q2Su/CLQZjJrOLHRXV4eP7h/kyadp
         Q1U+hAmZaRlV7KrdzoauwScmTI4Vz8YGJfV1ve2nN1084exN0DH3P0eTR6hGcDk+tE8i
         635pvv60WzEVEJX9Yowxe2IQyfM6esUkrI9mzYwDDqkLQaXqDErdXNEc2OIVjA9JZ/UE
         TQVA==
X-Gm-Message-State: AOAM532vGO6Zc/7CJyNiEw8/S0ia8DF3RV7ZO5XSmpWYbHryPqEII2VP
        tVNzhnZlzcsClCDhqq71XOI=
X-Google-Smtp-Source: ABdhPJwFQWEtOxbCYaVlbFyNfWlIa+g9zEKX+LEPfZLNaLKf5E7PzbD8fA/vxAHRgaWzPNNJlEsDxw==
X-Received: by 2002:a37:ad1:: with SMTP id 200mr4249147qkk.195.1612529765280;
        Fri, 05 Feb 2021 04:56:05 -0800 (PST)
Received: from localhost.localdomain ([138.199.10.106])
        by smtp.gmail.com with ESMTPSA id s5sm8782679qke.71.2021.02.05.04.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 04:56:04 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: scsi: Describe and replace a word with better one in the file qlogicpti.h
Date:   Fri,  5 Feb 2021 18:25:52 +0530
Message-Id: <20210205125552.1417492-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



s/fucking/awful/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/scsi/qlogicpti.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.h b/drivers/scsi/qlogicpti.h
index 2b6374e08a7d..4a47631b22ea 100644
--- a/drivers/scsi/qlogicpti.h
+++ b/drivers/scsi/qlogicpti.h
@@ -62,7 +62,7 @@
 #define REQUEST_QUEUE_WAKEUP		0x8005
 #define EXECUTION_TIMEOUT_RESET		0x8006

-/* Am I fucking pedantic or what? */
+/* Am I awful pedantic or what? */
 struct Entry_header {
 #ifdef __BIG_ENDIAN
 	u8	entry_cnt;
--
2.30.0

