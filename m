Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC71C433E4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6108206D7
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qGEL1ZmY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgGWM0O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729036AbgGWMZ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:27 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5ABC0619E2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:27 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id y24so831018wma.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dtzC5u0r7cORZLMw7eZngfMR6JkHvPGqNAQq20+N2tc=;
        b=qGEL1ZmYUfBiDZiWxlZxuB6qr6hQsxzYePUc+b8Gsvv87mWcVlT/clhtFrFRAOGujY
         VOgLg2Gtt7uLYioLPcdY2grEozYSe83Qysang7VzaNzaOD73ywv+4Fbpl9ouAxJhrVVt
         GHw31Ugsmn6ZOfHBQ2dT4Uumnn1dCvu6/K6TCq531Mw2aGelLDZDey1D2xeqjcIf1tx1
         9GH1MgO79f/Vf9qN4Bmczgaf7aI66cZpEg0rl5Ku77vWoy68vJ4U6IgKIaDHzGT1LSoA
         jkBcxZXFYa0Qjlc5h2VxOuZeqaAsXfFlEy2cKRDK6mFO46KMdYXsjuDPYGjThoO4fDhO
         4BqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dtzC5u0r7cORZLMw7eZngfMR6JkHvPGqNAQq20+N2tc=;
        b=hCvQi6XJA+PIryoseNsGQN2LUUn/eK9OtlDY7l4pVncrpDOodSqGT2S7DB7HbSFN5j
         ziEMaCMKS/Uvnudxh8V01im1EOZ02dJttZ53tz9q1hClXEgB0IfhqreFg8SlmC6FYkf0
         6gRqP/vO9P7it76lDuIY2EdL3MOfyxnis0CXlzoRRExXkja5DSL/dcHE901nHK17cBnz
         cm1Iw/X2LibfDTRJ3CBrR/vwaeE6VoWjcrgbYqpMvQRs5C97YHAvrtJGAGGkIZO7Ks2u
         1BqjQR3hSz5VcNev95exRg8S3ZhBfxFABRGRY3+3Bu/eJ2700oKM103Gvp1fuxwec/Kh
         4DDw==
X-Gm-Message-State: AOAM532aekRylHgudWP2xFrMhYEZJPznK9jtXZI5cr1woL3+eUvG0nep
        OiVk1aMj6lqnc9XurW6MqK2qWQ==
X-Google-Smtp-Source: ABdhPJxlMYmTDD3cQQm650BaKwiiTRBZG+rIvReTeprEqxejxDZtonFFvCoZY7pci/I27R9z9gBvyw==
X-Received: by 2002:a7b:cd90:: with SMTP id y16mr3954567wmj.20.1595507126399;
        Thu, 23 Jul 2020 05:25:26 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:25 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        linux-drivers@broadcom.com
Subject: [PATCH 30/40] scsi: be2iscsi: be_iscsi: Correct misdocumentation of function param 'ep'
Date:   Thu, 23 Jul 2020 13:24:36 +0100
Message-Id: <20200723122446.1329773-31-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/be2iscsi/be_iscsi.c:1042: warning: Function parameter or member 'ep' not described in 'beiscsi_open_conn'
 drivers/scsi/be2iscsi/be_iscsi.c:1042: warning: Excess function parameter 'beiscsi_ep' description in 'beiscsi_open_conn'

Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: linux-drivers@broadcom.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index fe10575bce7f0..93da6344424dd 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1029,7 +1029,7 @@ static void beiscsi_free_ep(struct beiscsi_endpoint *beiscsi_ep)
 
 /**
  * beiscsi_open_conn - Ask FW to open a TCP connection
- * @beiscsi_ep: pointer to device endpoint struct
+ * @ep: pointer to device endpoint struct
  * @src_addr: The source IP address
  * @dst_addr: The Destination  IP address
  * @non_blocking: blocking or non-blocking call
-- 
2.25.1

