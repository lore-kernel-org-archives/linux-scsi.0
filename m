Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA3BC4361A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BCBE64E33
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhCQI57 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhCQI5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:21 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A6DC06175F
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:12 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id e9so946413wrw.10
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bN4fpSzo8exezj3x7f+Hv5XSvvEKZvIRblLuzQg15wk=;
        b=xuGfcjmNoUNXdROabMzOnp0WZczjaQntC401d3z0wxWnRyuDoOC7cLATKwINdfklxQ
         ipodwjPR8/UKrJCUnSuLoBWX4J0+zkWPgZHwfVRFq/JCNTTTEKFlDd6wichhADg5l51h
         ow0XgtK2MhaMGdfWq2GJegVsAtdoTw2zrNGdL4x/VjKv6cFSUd3V3Nj5/ziTWD5p7mdx
         w3v/8Vp2sRo1m64T/B55BCiLrYVzuE3YIbmIEY85Y9uQjMwcTjyOrOV9mZOrXR8EBPwx
         EpgZzlvSTGDUvbcYNllIid91Jejxd9CJ8edLszNiRwbD5juw6PWeFdc3BPlBBmvL0dKg
         J5MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bN4fpSzo8exezj3x7f+Hv5XSvvEKZvIRblLuzQg15wk=;
        b=YvjLZY3Wu7HN0+6PxU/Whog9JnqpXahB6URvz7cjIwGgFiJLzHss0Ri8odva1rqC00
         mN/SAA0fnzuJ2iW1a5kibpEhzSFn7HBycHERbm1MEvFH+A3qRT9faJiV05N3QeBkEK31
         nfUIIR+0E/ZW2NImYRelWgyh5spUeKNuz3bLXkOrWc5MHxvFPXf/prZePwEsJFLcOT6X
         CXi7TnlzwXZPPEQfLFRAHuzrzE/wm6zdANMI9rHENi+ymDgqkZZnbRb5XdN++Kr99cXs
         7n/dKpLeUlILDHcFxXRtMFoANGTSkgHXPskQU1bk6fKi/ElvF79u2tcd5sFI+mfTRs+f
         +f/g==
X-Gm-Message-State: AOAM533ToWGfLWRTkf6jWol5jEkAE9/61ctwvrU5E0NYfp+9cqO7eg6b
        8YOj2dEcvW3q8rLSfKbgDqsyJQ==
X-Google-Smtp-Source: ABdhPJy5t8wI6UT8Xo/n7g49VzgKzqRcjwyHyXv4pFUXBOJOi2gYDFERdSuMSgbcsfCFzpwvQuN0ng==
X-Received: by 2002:a5d:6443:: with SMTP id d3mr3287356wrw.292.1615971430935;
        Wed, 17 Mar 2021 01:57:10 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:10 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 05/18] scsi: BusLogic: Supply __printf(x, y) formatting for blogic_msg()
Date:   Wed, 17 Mar 2021 08:56:48 +0000
Message-Id: <20210317085701.2891231-6-lee.jones@linaro.org>
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

 In file included from drivers/scsi/BusLogic.c:51:
 drivers/scsi/BusLogic.c: In function ‘blogic_msg’:
 drivers/scsi/BusLogic.c:3591:2: warning: function ‘blogic_msg’ might be a candidate for ‘gnu_printf’ format attribute [-Wsuggest-attribute=format]

Cc: Khalid Aziz <khalid@gonehiking.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Leonard N. Zubkoff" <lnz@dandelion.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/BusLogic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index ccb061ab0a0ad..0ac3f713fc212 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3578,7 +3578,7 @@ Target	Requested Completed  Requested Completed  Requested Completed\n\
 /*
   blogic_msg prints Driver Messages.
 */
-
+__printf(2, 4)
 static void blogic_msg(enum blogic_msglevel msglevel, char *fmt,
 			struct blogic_adapter *adapter, ...)
 {
-- 
2.27.0

