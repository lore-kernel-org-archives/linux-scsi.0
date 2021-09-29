Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF6DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F02CE60FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347106AbhI2WIq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:46 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:36574 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347037AbhI2WIp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:45 -0400
Received: by mail-pl1-f177.google.com with SMTP id y5so2535549pll.3
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tXItPhYygfbXZfUW5oSUliK3HsJ0ISKB+b2fBzDUh7M=;
        b=MX9/sYjP5I3cSAJGxnsnnfBhRt9fUoIMkTTvCSRBRkRgzRHA/SZa/85g1A1+pgubKJ
         sSJnBml/f4Y5aDjlaG/2MJ1k9tBLjM1Vtqw8vGqR8mUici8gUjBzaJrWsTbNE/qL1eN9
         uGPppSW1cb3+YV4a8Yck2lHuGt5fFsi+F/rq7KeSXGjohLG+g2wuccAuIOuIzxSmRr3D
         E50za7kkcib73vNSLAWQrHvIVA3zoulafX240J2JGTBN3kP7HkELfZ4wSO4Vh9C0zY5U
         UmxDiUPbu+WDTN7htkiMavwJZMhgW5K1eVYMVesNBYhnBL5iVXoHFa1Tn87lZjyTaPM9
         RpFA==
X-Gm-Message-State: AOAM530AvJ816hmhK+OW05C0Fids3tD0YhlTtVI9ktHubSpG3BUt1o6V
        Zr62Di67ZezRqqgq0Le493U=
X-Google-Smtp-Source: ABdhPJxfqKTrBjw4Oa51RJzbmpUGHdE4cXNzLOxJ+6L2M85cwVORGU+05Fw1mpZ+uAZozf1amunXiA==
X-Received: by 2002:a17:90b:381:: with SMTP id ga1mr2370425pjb.5.1632953223860;
        Wed, 29 Sep 2021 15:07:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 28/84] dc395x: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:04 -0700
Message-Id: <20210929220600.3509089-29-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
index 1c79e6c27163..5adbc7f61c19 100644
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
