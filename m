Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2743C11F6A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC59961410
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhGAVPM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:15:12 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:46999 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbhGAVPL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:15:11 -0400
Received: by mail-pg1-f180.google.com with SMTP id w15so7342579pgk.13
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:12:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tvy4oyg81mRNZ/70SX4cfmRXeU6IQli/ctKCwyLrD7A=;
        b=bLtc4V1r1i/Z764x2OtGj11ZA97K+1QjOlUKv2/xsKT4oyaVVX0yEQDOeV2QyNlEs4
         Tv/pn+LiN6JtAf80WgLyllUPJfi06iQ1/eA45QmSTyQJCiEi4VKVnL4mRb6wzYLmOpV+
         +jUscnTpd/MHLCD28GszJBIQ5FzURrsOJi1kn3u9GKLG7D5CyYoSACp+EXqupz9CtQ4r
         b1k86bqv5qfl9xWMu9vouyF4Bm23GTy7GnWSoDcYS9yP1QkxOXxgg6Og8FbAENQmkjZ1
         tak4uxGQnaBfvzYhdfkazncOnmnQEhfsJTXjPGxHOMPDQh6ynUIhyWRMEVYH481T+MZo
         tVbQ==
X-Gm-Message-State: AOAM5319P4GBy33G+cK4g5/ydy+6yok7vf4gRDlcJ+Pll+qGHrM+++y7
        1LvZH8HtVyj9e3TVn2rnxjE=
X-Google-Smtp-Source: ABdhPJynkHAGRxmbzGGOcIzqO/y3A/xVVosoQVYc0xi0V5aaABK0nlvJ5P3TLVsD4ls+sRoEQk93+w==
X-Received: by 2002:aa7:8f28:0:b029:312:3176:13fa with SMTP id y8-20020aa78f280000b0290312317613famr1910377pfr.53.1625173960350;
        Thu, 01 Jul 2021 14:12:40 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:12:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 03/21] Clear host_eh_scheduled from inside the SCSI error handler
Date:   Thu,  1 Jul 2021 14:12:06 -0700
Message-Id: <20210701211224.17070-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current protocol for scheduling the SCSI error handler explicitly
is as follows:
1. The LLD registers a transport layer that defines a eh_strategy_handler.
2. The LLD observes an error, sets variables that indicate the nature of the
   error and calls scsi_schedule_eh(). Currently only the ATA core and libsas
   use scsi_schedule_eh().
3. scsi_schedule_eh() increments host_eh_scheduled.
4. The SCSI error handling thread wakes up and invokes eh_strategy_handler.
5. After all errors have been handled and before the eh_strategy_handler
   implementation returns, host_eh_scheduled is cleared. This must be done
   in such a way that all errors that happened while the error handler was
   running are either handled or result in rerunning the error handler.

Making LLDs responsible for clearing host_eh_scheduled is error prone.
Hence clear host_eh_scheduled from inside the SCSI error handler. A side
effect of this patch is that if scsi_schedule_eh() is called while the
SCSI error handler is active that it will be reactivated immediately.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c6cd5a8e5c85..665cc44d8877 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2242,6 +2242,13 @@ int scsi_error_handler(void *data)
 			continue;
 		}
 
+		/*
+		 * Clear host_eh_scheduled before handling any errors such that
+		 * calling scsi_schedule_eh() while errors are being handled
+		 * causes the error handler to be rerun.
+		 */
+		shost->host_eh_scheduled = 0;
+
 		if (shost->transportt->eh_strategy_handler)
 			shost->transportt->eh_strategy_handler(shost);
 		else
