Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC94C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3900761164
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344026AbhIRAI0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:26 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:53952 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343701AbhIRAIZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:25 -0400
Received: by mail-pj1-f46.google.com with SMTP id j1so7997079pjv.3
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0xrYKlXXqZ43nTFeMXbGnx2HnZXNL43Vi79i7MYS3Ns=;
        b=1h77ERLH+TEM5n8r60PB0G1uLczAUBnbqbSDH6nujMSJavf9nTgggvigTmtT955QKZ
         ggdbCy3H2Kcry8QuB1X/GD1dVKEUoxwxFU/dqvl9qOiFJlAcd2rFxzgt6j4uZyCd6EBT
         3TukhmR5d6T1yByN1n3ORqD6XnmoZyUMOb4MmRyRQZLj2/6HJQnaMsbRWv1tnKTpzOq1
         +kpg2ay1md7LVgwf4ry2IhnaUAKBNmMoIGMt3HJ2gACJhtCXqaYeOq1q/l1DPEfuMhNr
         y/PEWGJQwq0x6XccoUvMxBPa6vR+WEAsgkgPxXzowSm5MKS38xzmS/nSOVkwrTWNG3ay
         M9Sw==
X-Gm-Message-State: AOAM531YirVRGEp4as/dChIgt1BFuuZ0sMnnMQZ4diQw5dCN/M0m/NC7
        b9yQdSPM4mBCn0Ea028/S2g=
X-Google-Smtp-Source: ABdhPJwx+VFyXT0Hkhw/K0qdrqtRYti/9dv8D3B3pz7Noyc5u4tGk82fULHMiHco269zPZTT5LWpxA==
X-Received: by 2002:a17:90a:4498:: with SMTP id t24mr15131345pjg.235.1631923622271;
        Fri, 17 Sep 2021 17:07:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH 27/84] csiostor: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:10 -0700
Message-Id: <20210918000607.450448-28-bvanassche@acm.org>
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
 drivers/scsi/csiostor/csio_scsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 3b2eb6ce1fcf..3978c3d7eed5 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1720,7 +1720,7 @@ csio_scsi_err_handler(struct csio_hw *hw, struct csio_ioreq *req)
 	}
 
 	cmnd->result = (((host_status) << 16) | scsi_status);
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 
 	/* Wake up waiting threads */
 	csio_scsi_cmnd(req) = NULL;
@@ -1748,7 +1748,7 @@ csio_scsi_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
 		}
 
 		cmnd->result = (((host_status) << 16) | scsi_status);
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 		csio_scsi_cmnd(req) = NULL;
 		CSIO_INC_STATS(csio_hw_to_scsim(hw), n_tot_success);
 	} else {
@@ -1876,7 +1876,7 @@ csio_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmnd)
 	return rv;
 
 err_done:
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 	return 0;
 }
 
@@ -1979,7 +1979,7 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 		spin_unlock_irq(&hw->lock);
 
 		cmnd->result = (DID_ERROR << 16);
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 
 		return FAILED;
 	}
