Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE43C4360C
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03FD264F72
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhCQI6B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhCQI5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:22 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E98C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:22 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id b9so950165wrt.8
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tIEkLMKAtbUUByHxgsDytjqimEjUNe0j+Mn0l5iX50M=;
        b=a+DMI4iVTnhLsQaNH5HsLRD0p4jmOwH4c+OdsIB5mhlSZImVjQj67NzOFVCvxEZiEz
         qf3nxfzbCn1cPpyn2nBZt1S/puwJcu3eV83BgIHeszYCACXSaS9Xm/rCAUSS3wbVSTee
         ggp2QrfifWznoxjMwD8BRF6HCnYJUvIJmT3GGE8GCwgFXhkpD657Iqe0qoqmXx0dFnpv
         X9pBn5+2cc8mMirWmY0lRKr7DehTGXhNAVJfcDLknUxKRYg/vJZkIhtqLKfgKxOmGOcs
         lKOa9zBBQMjwcDgfz4yQMmpgoKoHMjJJVmV3Whx0vt/OPJACLEY8ZMF0eqhq1s9fXr6L
         Z0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tIEkLMKAtbUUByHxgsDytjqimEjUNe0j+Mn0l5iX50M=;
        b=ZvQjVnxBoJOcbzblUw3zE0BEXAD6SzzScwQYdVma2ncNsO9/zxoaXdX4tTMufKOarz
         l/AM4M4sYHYAVHMmtZxmiXs9jyqDmbh6+8IqjrxpXSJ0W3whgySUxIsZlUsOn2QR3lGX
         LUrMOdgvobYULhXmUtSWVJz6ST43fWSK42cPrH+tLPTkqK73+gPER73AiKoH95Re4j+F
         VooqA+y0Dx0EGcmvypjkTMyalqYI7h2Hgm8VLkmXTsI6xcIOax4I4F7QV4ukbf+x9rQx
         zUdRuSDS/tem0ZjZTeMJAs90AasCDS387khR/lCdn4bJsBexMdF4QlOb2KD5e2cSTBKT
         XSdA==
X-Gm-Message-State: AOAM532SXYyuL7rOmEAc33A4jgq8V29xgCKmPXfXnw6ux2fDFq2OuL8v
        yHEYTSnLNO11Ecq9XjyGRZ7pSA==
X-Google-Smtp-Source: ABdhPJzu9vdM0OUd6qmkmrhg8ngUL9mmunRKcl7uLbkfhxy5NL5s2Jl0Y/e3r3KTbRZAar9WWWzy/Q==
X-Received: by 2002:adf:f4ce:: with SMTP id h14mr3204003wrp.257.1615971441165;
        Wed, 17 Mar 2021 01:57:21 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:20 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 16/18] scsi: isci: port: Make local function 'port_state_name()' static
Date:   Wed, 17 Mar 2021 08:56:59 +0000
Message-Id: <20210317085701.2891231-17-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317085701.2891231-1-lee.jones@linaro.org>
References: <20210317085701.2891231-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/isci/port.c:65:13: warning: no previous prototype for ‘port_state_name’ [-Wmissing-prototypes]

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/isci/port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 448a8c31ba359..5a362ba76d63f 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -62,7 +62,7 @@
 
 #undef C
 #define C(a) (#a)
-const char *port_state_name(enum sci_port_states state)
+static const char *port_state_name(enum sci_port_states state)
 {
 	static const char * const strings[] = PORT_STATES;
 
-- 
2.27.0

