Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B3AC00454
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 17:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AB2420836
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 17:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfLIRmL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 12:42:11 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39844 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfLIRmL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 12:42:11 -0500
Received: by mail-pf1-f193.google.com with SMTP id 2so7589492pfx.6
        for <linux-scsi@vger.kernel.org>; Mon, 09 Dec 2019 09:42:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tOmo7e/2PpNd6IgXTBtTPlk0fWbokb3VydNBX4t+YY4=;
        b=tOiQHhnVyyK1QKHPoN1/fTksdf7tkfV/u1r6vusi+lrQDKJ5HmU/Cbd0V1rCYRDOAv
         t0PFOdiws+PRUIwRnAiLzjx1Qa1n73CF+WUaa4NwYki/Bl2kGow8zcvcLYu+blxazHop
         Vt2ctrRBZWz4jE6bfIm8foeWHkjwSoVb1EsbPgQP+4507o+WmG05yI5Mj9rMUquo5ouk
         a8LJRdeRKWOO378AOGWK+dpwkbOAr4vDHw5B4CejMZuCvylSonK7CghMNMfiHto8aPz+
         kryuI7h1r02Gp4AgHlu7K3W6uieuKPFF4XDltP7cVegWZsxGJ0oYaiD//eDXwOJsguOQ
         iPRQ==
X-Gm-Message-State: APjAAAW2IZMJdQ+xjEafuzO/3tMGWKHN56Z/JV7EoQMn2vFu8pedbfvH
        NNhABDjl13j9rI7tIBd2txw=
X-Google-Smtp-Source: APXvYqxsPhTYgT0RYr4mXtUAWIi3hHsB7e5UzL5z5e+QKxZlrf77jDW4pcWaj6SZv09zghFnMDW0IQ==
X-Received: by 2002:a63:f70b:: with SMTP id x11mr489797pgh.80.1575913330963;
        Mon, 09 Dec 2019 09:42:10 -0800 (PST)
Received: from bvanassche-glaptop.roam.corp.google.com ([216.9.110.14])
        by smtp.gmail.com with ESMTPSA id b129sm80515pfb.147.2019.12.09.09.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 09:42:10 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] Fix a compiler warning triggered by the SCSI logging code
Date:   Mon,  9 Dec 2019 09:42:05 -0800
Message-Id: <20191209174205.190025-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following compiler warning:

In file included from drivers/scsi/scsi_error.c:46:
drivers/scsi/scsi_error.c: In function 'scsi_eh_target_reset':
drivers/scsi/scsi_logging.h:65:81: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
   65 | LOGGING(SCSI_LOG_ERROR_SHIFT, SCSI_LOG_ERROR_BITS, LEVEL,CMD);
      |                                                              ^

drivers/scsi/scsi_error.c:1562:4: note: in expansion of macro 'SCSI_LOG_ERROR_RECOVERY'
 1562 |    SCSI_LOG_ERROR_RECOVERY(3,
      |    ^~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_logging.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_logging.h b/drivers/scsi/scsi_logging.h
index 836185de28c4..3df877886119 100644
--- a/drivers/scsi/scsi_logging.h
+++ b/drivers/scsi/scsi_logging.h
@@ -53,7 +53,7 @@ do {								\
 } while (0)
 #else
 #define SCSI_LOG_LEVEL(SHIFT, BITS) 0
-#define SCSI_CHECK_LOGGING(SHIFT, BITS, LEVEL, CMD)
+#define SCSI_CHECK_LOGGING(SHIFT, BITS, LEVEL, CMD) do { } while (0)
 #endif /* CONFIG_SCSI_LOGGING */
 
 /*
