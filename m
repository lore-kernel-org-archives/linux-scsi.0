Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 497BEC433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22D652086A
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cF/qDwLu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgGWMZi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729115AbgGWMZh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:37 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E1AC0619DC
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:36 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c80so4796473wme.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lILTThezBBjt1SaEOrJ5cCFNVhfL0JgzA9PlnOUOSZ0=;
        b=cF/qDwLuZ3kSlDgfOjMgsjZ/zgg8VcNgh/irkdLg65eI4YGX/EJnsb6zFuWrudDys/
         M+Qps5AKnfK3YYlKDNS+VwBMfIQr0SwE5OjAdl1Fql26eTQnrAJHSYv1V2OtKIMEvO4g
         q1p08Gl13ghVrzSOqppm1PkM0dWYOMdlvJyfaGZ7jobCoY7kFFT1Lxy2Jf7U/vmuB5Ge
         6KK19t9Lyk8EnqbB9JQbR0ttlRt/4cXQfQn0l3Nw9VhS8hrciqJCSsFxnnCyXVJehcU6
         Cez5bfFb7D8LD7OCQcmbjnMSqFcyHSczjFuITPE6ZISp99ig2Tcsug4kQ5rhA6Vp2Q8B
         7qjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lILTThezBBjt1SaEOrJ5cCFNVhfL0JgzA9PlnOUOSZ0=;
        b=IkK/PausApbTmt5RI9MvghrImTA99zTk8TVhJY4OAl4HQi0nWVTdoktQL8k5g77jGo
         g7Zu6kD6CqoIyKHLkW6Rjv6/fyYA9JwPm+yDZc8Q2h3PMI3Pu/AmR8x13eTUEnZmLFk/
         pFFxgbtCbHD+OuZK6UEmNempgTDVuqwMJofE7E1IsIyK8EkmQGD27Tdtf66zO3BlOZoK
         oh2+sChD9eJx5X4Fn6ob+UHzcEfPggaP16+e7Ne8fZoqADP8BLgGFCJa1ppY2r43JD0o
         lNaKOkiYip/MuqucbS78k89buDcSr21eEfHh5LKJBICVEDVPRJ2wRN/GvbctVg7GBciX
         Yxkw==
X-Gm-Message-State: AOAM533Dsw0wMwz1EmoXEW7zQM6tydSww4cAqBmUdB43aK0zRcynk5TN
        GDhaGwO2UR6A0TfakeOvrPLbfg==
X-Google-Smtp-Source: ABdhPJzgV5ygX039Y+Z439kdkBvpBcmVfcgyvPkdOSIQ9k2En1wPFl5q+32hVNnRToBdO79SrD6qVA==
X-Received: by 2002:a1c:750a:: with SMTP id o10mr4120800wmc.165.1595507135701;
        Thu, 23 Jul 2020 05:25:35 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:35 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@cavium.com
Subject: [PATCH 37/40] scsi: qedi: qedi_iscsi: Staticify non-external function 'qedi_get_iscsi_error'
Date:   Thu, 23 Jul 2020 13:24:43 +0100
Message-Id: <20200723122446.1329773-38-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qedi/qedi_iscsi.c:1549:7: warning: no previous prototype for ‘qedi_get_iscsi_error’ [-Wmissing-prototypes]

Cc: QLogic-Storage-Upstream@cavium.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qedi/qedi_iscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 425e665ec08b2..c14ac7882afac 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1546,7 +1546,7 @@ static const struct {
 	},
 };
 
-char *qedi_get_iscsi_error(enum iscsi_error_types err_code)
+static char *qedi_get_iscsi_error(enum iscsi_error_types err_code)
 {
 	int i;
 	char *msg = NULL;
-- 
2.25.1

