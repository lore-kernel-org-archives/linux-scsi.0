Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64598C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C07F610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345079AbhIRAKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:32 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:35652 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345117AbhIRAJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:36 -0400
Received: by mail-pl1-f176.google.com with SMTP id bb10so7240747plb.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2/QRLAju1rqA872cyW9wszu4gb+YXOXA8KDXBOy4pqg=;
        b=VpDmwaCO/0aC79GqCMTol3z6VgvkUzlVHgibcdCg1tUsA+sVnZIk8svI02X7F0mzf/
         agJlLsy4dqeg6MYCEw5b22nyGDlqwIqNqOHoOhcrgZxhLcYFaIwm3wjwacGOXCsesIzZ
         S0UPB8jwDK37UspWwKLBVm2SL7BtTm26u2vSgJyA6oJiRYq9A9LcC/RauhRupXLIxMSs
         BqA2SybdQQs58UMnOSmyOlwa/Z8Oo9Nm5nJsudQF6hC51WAYWB5+DlYZvPR4c8+eCRNj
         80wam+9udyLXm2VYHhI4S0rC0+lJMvy2nWVObrzJeJRvcoiq7krMvsqqTd4yDnJuToWF
         Mp4A==
X-Gm-Message-State: AOAM530/kJAcNLkZuAHG/5QMq7uySNEUOvM4UeB9WHxD42gt1kLNc1lF
        ku8SB7YECeax5m0SWrHLrVo=
X-Google-Smtp-Source: ABdhPJwbz9prtmvodIyoZacohJr1GQ2tsWPjA5GauXf7sLyiEhQbPgv/wp5o+UnYGjBJTW0IXDyifw==
X-Received: by 2002:a17:90a:301:: with SMTP id 1mr15490422pje.65.1631923693453;
        Fri, 17 Sep 2021 17:08:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 72/84] storvsc_drv: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:55 -0700
Message-Id: <20210918000607.450448-73-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/storvsc_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ebbbc1299c62..70d0b1dd0f75 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1154,7 +1154,7 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request,
 	scsi_set_resid(scmnd,
 		cmd_request->payload->range.len - data_transfer_length);
 
-	scmnd->scsi_done(scmnd);
+	scsi_done(scmnd);
 
 	if (payload_sz >
 		sizeof(struct vmbus_channel_packet_multipage_buffer))
@@ -1753,7 +1753,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 		 * future versions of the host.
 		 */
 		if (!storvsc_scsi_cmd_ok(scmnd)) {
-			scmnd->scsi_done(scmnd);
+			scsi_done(scmnd);
 			return 0;
 		}
 	}
