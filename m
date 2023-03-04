Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7225C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCDAdt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjCDAdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:33:19 -0500
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780276A1E4
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:06 -0800 (PST)
Received: by mail-pj1-f46.google.com with SMTP id y2so4351032pjg.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=07ZQaPfc2uMfGLVpQX+PlaqpVOWVCeYsM+H7InAN6kE=;
        b=hzJic7o51SmoNNS5ZjI/NGrCL35KnFphRiZx9YofM3GSFLiWV037h9Ev4fhBalxMsx
         u2Pnps43SsypkLInF7KQV6g3fxM+X9qxtDb1ZTCAhdDZ1JW6pRA2tle3MQ4m6zkV0ok1
         0/bjBxX+TFA4jfAvLhQmwu94zQtSCtW/pBw8raN0F031ELbn8nlzFq7Ovk3OMgxIeyEf
         T+VMuf065sOz1jnuoZN+pEageoJwr09aHhqPekwwxEW6XGZCs7qQgwuZRYWXn5kVrqqN
         W5OcJnGgDOZrC1qhzXvdR70uF85fgJ3ULBP3ZQ7mDF3ljyWJZ3HPck6Cd2k9wG5lz+dU
         /38A==
X-Gm-Message-State: AO0yUKVKdixv46K7mcme6L9Ej6oF4bixifl+HRTQ5tFsKXrCTz6Bb3sl
        7eWnYv83RCfH+sDKPU05F6VW1pIVAmpywA==
X-Google-Smtp-Source: AK7set+ATmrpr/akOqJU2naAiRfygqH2+sxbCYI2xMJBlls8OoOv98pXEq/cLi+0IxvoKhhrXfDSrA==
X-Received: by 2002:a17:903:22ca:b0:19e:685f:484a with SMTP id y10-20020a17090322ca00b0019e685f484amr4401584plg.62.1677889985752;
        Fri, 03 Mar 2023 16:33:05 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:05 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 38/81] scsi: fdomain: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:20 -0800
Message-Id: <20230304003103.2572793-39-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 444eac9b2466..504c4e0c5d17 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -496,7 +496,7 @@ static int fdomain_biosparam(struct scsi_device *sdev,
 	return 0;
 }
 
-static struct scsi_host_template fdomain_template = {
+static const struct scsi_host_template fdomain_template = {
 	.module			= THIS_MODULE,
 	.name			= "Future Domain TMC-16x0",
 	.proc_name		= "fdomain",
