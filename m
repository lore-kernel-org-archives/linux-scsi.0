Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38579C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1816D6143F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhENVh0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:26 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:40920 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbhENVhR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:37:17 -0400
Received: by mail-pg1-f181.google.com with SMTP id j12so251654pgh.7
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:36:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dM+WIxPnyXTYFBr8o0gTRnqx905xvNYXXAsx5ozXOmk=;
        b=oBw8bzD+SAUzrNFBSPoCv1imX2YnAbs6JUJjmOc7iRXyr3AjMwUJMo9bOIXOHr9W3c
         ChDJYyMrIRLAQNAAFiDxWmNB+M0dCQUeTZTOMi08hKaCqZGmVpO8/0EAJLOYKBwKrHOx
         Tn6T1RLsI7d03FBFZGnuP2AWKDZSOX7caUx0y5j2qRV+99OYNCm3BIbJLVkNqyzQHMZ3
         NDQ7I4p2SgOQ6HnBduE1c9SW7CAreYlE9lFS3vykLmAav8UE/BjKgL/3/w8tD2WHuQ+N
         eTaAOFA3yFtuUAxMnOMSP5MVqKoEXIJwR5pwMjetjfES8ni+ltXc4wTGtW7HBMX0afIF
         sLbQ==
X-Gm-Message-State: AOAM532zko3JzVKwd/JKo55QtfTX8VHFV6BFzDt8WtIj4xQ3MqCayAbF
        Bq1YwAUJGRP7dxs29w6flu4=
X-Google-Smtp-Source: ABdhPJz2ooIqu2qGR5F4WQ+tpGHQAroY1jBrvyz3a5hJTxTopvub4YI/CJffl416AOUBiygquBz0Ww==
X-Received: by 2002:a63:fb4c:: with SMTP id w12mr48962138pgj.337.1621028164606;
        Fri, 14 May 2021 14:36:04 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:36:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 18/50] dpt_i2o: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:24 -0700
Message-Id: <20210514213356.5264-70-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/dpt_i2o.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index a18a4a08f049..75fbbd939b4a 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -652,7 +652,7 @@ static int adpt_abort(struct scsi_cmnd * cmd)
 	msg[2] = 0;
 	msg[3]= 0;
 	/* Add 1 to avoid firmware treating it as invalid command */
-	msg[4] = cmd->request->tag + 1;
+	msg[4] = blk_req(cmd)->tag + 1;
 	if (pHba->host)
 		spin_lock_irq(pHba->host->host_lock);
 	rcode = adpt_i2o_post_wait(pHba, msg, sizeof(msg), FOREVER);
@@ -2236,7 +2236,7 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_d
 	msg[1] = ((0xff<<24)|(HOST_TID<<12)|d->tid);
 	msg[2] = 0;
 	/* Add 1 to avoid firmware treating it as invalid command */
-	msg[3] = cmd->request->tag + 1;
+	msg[3] = blk_req(cmd)->tag + 1;
 	// Our cards use the transaction context as the tag for queueing
 	// Adaptec/DPT Private stuff 
 	msg[4] = I2O_CMD_SCSI_EXEC|(DPT_ORGANIZATION_ID<<16);
