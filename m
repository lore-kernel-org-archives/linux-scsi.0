Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF930C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD80A60F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344244AbhIRAIb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:31 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:45765 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344119AbhIRAI2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:28 -0400
Received: by mail-pj1-f52.google.com with SMTP id mv7-20020a17090b198700b0019c843e7233so4799272pjb.4
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kJSUw2lvJufU1ix23vmc2iRNis/6Dw+0Z7wNZu0jRmo=;
        b=hVY1Ul8IAg9SPDCNvmBmE6xwtZPnE9ISCMaYNiFU294ziAPRrnVEw9f7v1Vd6MWRtA
         JMp1O8BOUsh9m+xjOMSffkUKLpXEr9SsdZRSU1KC6jWN9xNqnASvjQDVIg0DkOw8bEK8
         ecET4hPV9ExwpOqpoxaL0HeCRE7YRJAQbhrTth/msHBbEcpOjyRzghYMuqja42JD2EoA
         QNivUFbe3fAgOzE+hUEsSxVymttVf49Cn8aRaItcbCqKI50R+RTfmA2zPw5u1aiIrvl4
         ZGnlG7sw6G9GClYtbd5iB4HvhMqOCj3bj5auPiblWLibG0x1Gz8EgjUS6AEUoJxWdEAJ
         PU9g==
X-Gm-Message-State: AOAM533HtwNoKCj9QFAu2o6Xdku8NobJxNnQ2IpgyqBraLfxiZMqRGBo
        HuJQPQMjrc1GZW3AZJD2EFk=
X-Google-Smtp-Source: ABdhPJzUhGpXdJNvl1R876uldS9MCX2reWzuaMcZMFjsYv3DEVKGoeBeliR355O8VQqJXfJwHNSuIQ==
X-Received: by 2002:a17:90a:bb0b:: with SMTP id u11mr23703482pjr.18.1631923625333;
        Fri, 17 Sep 2021 17:07:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 29/84] dc395x: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:12 -0700
Message-Id: <20210918000607.450448-30-bvanassche@acm.org>
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
 drivers/scsi/dc395x.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 24c7cefb0b78..7d6f2b3c7fd5 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -995,8 +995,6 @@ static int dc395x_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct s
 		goto complete;
 	}
 
-	/* set callback and clear result in the command */
-	cmd->scsi_done = done;
 	set_host_byte(cmd, DID_OK);
 	set_status_byte(cmd, SAM_STAT_GOOD);
 
@@ -3336,7 +3334,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		dprintkl(KERN_ERR, "srb_done: ERROR! Completed cmd with tmp_srb\n");
 	}
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	waiting_process_next(acb);
 }
 
@@ -3367,7 +3365,7 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 			if (force) {
 				/* For new EH, we normally don't need to give commands back,
 				 * as they all complete or all time out */
-				p->scsi_done(p);
+				scsi_done(p);
 			}
 		}
 		if (!list_empty(&dcb->srb_going_list))
@@ -3394,7 +3392,7 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 			if (force) {
 				/* For new EH, we normally don't need to give commands back,
 				 * as they all complete or all time out */
-				cmd->scsi_done(cmd);
+				scsi_done(cmd);
 			}
 		}
 		if (!list_empty(&dcb->srb_waiting_list))
