Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DC9C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A16E64F4D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhCQI5U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhCQI5L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:11 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7C4C061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:11 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x16so960047wrn.4
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KspmBqbjk4SwVrkpMki278CpteugIPA4FRqHSDe0Ld8=;
        b=f0wMl7PPI9GyJQ54AsUw33UqcpCkutaW99aa+jPQ9689zDYUS3KVhJe4WI5qMqNIMx
         T0XQXz/xhmwwte8hcpnLMQZ+oKFfRkIzVEL8FEwBnOEdKMnGJfJvnBWyH0gg+QjzGKkP
         ouulMB01hntTnTyV5ZPGOSVNs5eq3hLvrbWC0pIbQi1k8XrTnDPLHxWf5T910lB7U7+J
         KDirvMUvLbDFUbILI65/V2KTy4LFIZRwRoJ7tDVGrrcL/py9f30rUdnozR3ZWli9q2QY
         ECsn1RWJYUel/qmol5Q8F6YE9PAMhJib289eXCSDAUuSngGXnCzyFVB7uRcmtsNVfe2I
         i23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KspmBqbjk4SwVrkpMki278CpteugIPA4FRqHSDe0Ld8=;
        b=saVyB8aVdB+sB0TOxuoiaw87ADSHchQkPMuwF+kQd5yneToXojVJEos99kmhUBDLbV
         M4AUCelAcLHZm2T5an00HVVHh0KnpbAlEn9awzSbJNY1mS1lbF7rACWpNM6A9U9kF48s
         aaM/NLxWLDxrmXhv1076fCFVEGbLoMhfKqiucyondNMt7LT0ww70xoxtkIt8tfLhLKod
         usIlKyAP8ACTtvkkp9bbZFfBtiyk8cZZQBv1tiDf8Yd/ndn9K+nLyCYgmcoxz6fhIwi8
         2+qE2T+F12AQdn5Y37rkZfnZViI6V2GNC3l5oDDiGQ5ebdu55ptlJwo1ITmEWe/qK3XJ
         BtbA==
X-Gm-Message-State: AOAM533EPWOkLItpgeEvkBULMhr/skeaBfZY+ccH0BgMy5UM+7meghcy
        2b2jPHU6m0ZapSrxmLaXTbOzMg==
X-Google-Smtp-Source: ABdhPJxiWEKbcNLmng1Gyv4HVIliU9TYFHWiylRwsZe31cecjp+u+ZiyKznNHkHuce3wCKPgTS/0Iw==
X-Received: by 2002:a5d:528f:: with SMTP id c15mr3252496wrv.142.1615971429964;
        Wed, 17 Mar 2021 01:57:09 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:09 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 04/18] scsi: esas2r: esas2r_log: Supply __printf(x, y) formatting for esas2r_log_master()
Date:   Wed, 17 Mar 2021 08:56:47 +0000
Message-Id: <20210317085701.2891231-5-lee.jones@linaro.org>
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

