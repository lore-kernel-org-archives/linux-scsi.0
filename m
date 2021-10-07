Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2430C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFFF861074
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhJGUcU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:20 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:39843 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbhJGUcT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:19 -0400
Received: by mail-pf1-f173.google.com with SMTP id g2so6309260pfc.6
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tXItPhYygfbXZfUW5oSUliK3HsJ0ISKB+b2fBzDUh7M=;
        b=auRPCQRKXByqY6ePIXs3DU/5X5To3BGF+iwGdxYhv9T1pD9OJDkgFOr2jVZoaNQdM9
         Lh25tGqz8CMUDSYgL4CvGzQ4NeSdOv/3NmVtvbnwTt5hmn4fi4RhtczDOinjGtrJO/Vc
         DbrqrzH4YeofyNPjpMOqebbSUgTV6kLDzSfMGvhBkN8Fur58agd17O1xRn88TOYe2Y3x
         iBqYSc3zrjPkc8ew8XBU4eu77Fv7bbl8yyyg5YY+M8/H2vmAJFCO1PZgu9duFfr+ciAl
         dYnReWe65Km715l9kYFmrEFIvwdxbva3YgWZSbbasmit7cpffhdDs+p7rJcH7lxtKS4N
         dNbA==
X-Gm-Message-State: AOAM533UHpSLaa5DCBSq5yrLXZYhTT8MWnpx9OYS64IVdESqBwEnjG8V
        qJEiRdiGvoplSWzTNVUOm6zM5rjcOFQ=
X-Google-Smtp-Source: ABdhPJzmdD4L9Sqpz3lNI0ChIaTkN24VdxMqtazHIKud3bBVPx+cNnIUodU+KaCrrJ0lwRCmVRudzw==
X-Received: by 2002:a62:5bc1:0:b0:44c:7905:777e with SMTP id p184-20020a625bc1000000b0044c7905777emr6426063pfb.0.1633638624863;
        Thu, 07 Oct 2021 13:30:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 28/88] dc395x: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:23 -0700
Message-Id: <20211007202923.2174984-29-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
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
