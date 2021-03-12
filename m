Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0DCC4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFA536502A
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhCLJsn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbhCLJsJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:09 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB113C061765
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:08 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id g8so3402961wmd.4
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KspmBqbjk4SwVrkpMki278CpteugIPA4FRqHSDe0Ld8=;
        b=PfGNhCuiylvRyEiNZbO3LIdrXW/jc8eL59kkSyl0fViEKSTvsMn788NKa9LkvSHVLH
         4FoPEU09JiF2MA2h1DJYFfxnkP1qKskNvqzfBDULEjOXaBiPIAbd9KAsZYtf50acv42U
         KQO2+3lXXPHEQOnxhf8KMTySQQKLrWDgGjUc2wVPvb6+oFWCSXYxn39ljfOAxVyKSyXE
         LPG2cZ+0LPQPtEkZAB8jrfbqi3I59gQw1yI1y/8C4evLcB/FPOGPGcLIOA7ncUlrILxv
         K4hRklub2FTrgHEVXdYEhqHkl7q6ZVG2D/lAw2qpgNCXd8AZaE3yHfvnWwiPUMof3izN
         Sstg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KspmBqbjk4SwVrkpMki278CpteugIPA4FRqHSDe0Ld8=;
        b=Q55d1bCM1fXlLK8DB8Yf5BXmXCV/DcNeh0yA2CjB8a31dDJGtYjSmy2/GpouUKH69g
         CvMZiYKCYZuElU9D5h+tjObWUlNS11mD5W25xzOML4t3YupSPG3RWzgiOr3TeI/akikF
         tfx+ZaaEOe83+7V44JsQx4fNO69t+U5QRwFTLLL48OGrm0SHpRpXr/UTCwT1oLXf8PiA
         pnxZB9+udodvrx8CJosjg0eYt92ulB8xnM5LPg34l9L5Mo8I1TtRycL2JjCLx4oBAXbE
         voJTo1ESCiXKeeipNkQSKfpILquJx84DlLM3rIB8HwyDrqPUFoMnW1bmuiFaxRPRitrH
         xYmw==
X-Gm-Message-State: AOAM533xHst8JVojkKb16B8qTubU5Pvdy7u79JfCqLwmXeEUlJjrgqYS
        x0b7MmtdZwmXkC6WMIXMu46fh/USNG1FSw==
X-Google-Smtp-Source: ABdhPJxEJ4kH9AI7TGyWx1qdbaHektoIOh8enAFviuPK++9j/6n683lyESUY0h4BrPuidfioDst4XQ==
X-Received: by 2002:a7b:c209:: with SMTP id x9mr12178799wmi.92.1615542487458;
        Fri, 12 Mar 2021 01:48:07 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:48:07 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 18/30] scsi: esas2r: esas2r_log: Supply __printf(x, y) formatting for esas2r_log_master()
Date:   Fri, 12 Mar 2021 09:47:26 +0000
Message-Id: <20210312094738.2207817-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/esas2r/esas2r_log.c: In function ‘esas2r_log_master’:
 drivers/scsi/esas2r/esas2r_log.c:155:3: warning: function ‘esas2r_log_master’ might be a candidate for ‘gnu_printf’ format attribute [-Wsuggest-attribute=format]

Cc: Bradley Grove <linuxdrivers@attotech.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/esas2r/esas2r_log.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/esas2r/esas2r_log.c b/drivers/scsi/esas2r/esas2r_log.c
index b545798e400c4..d6c87a0bae098 100644
--- a/drivers/scsi/esas2r/esas2r_log.c
+++ b/drivers/scsi/esas2r/esas2r_log.c
@@ -101,6 +101,11 @@ static const char *translate_esas2r_event_level_to_kernel(const long level)
 	}
 }
 
+#pragma GCC diagnostic push
+#ifndef __clang__
+#pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
+#endif
+
 /*
  * the master logging function.  this function will format the message as
  * outlined by the formatting string, the input device information and the
@@ -170,6 +175,8 @@ static int esas2r_log_master(const long level,
 	return 0;
 }
 
+#pragma GCC diagnostic pop
+
 /*
  * formats and logs a message to the system log.
  *
-- 
2.27.0

