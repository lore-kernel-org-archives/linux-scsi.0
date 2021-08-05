Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E8AEC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2752560BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242940AbhHETUH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:07 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:43712 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242739AbhHETUC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:02 -0400
Received: by mail-pj1-f49.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so12006602pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JorMQxvc2PQQrm+eUziWvkx8Qny3CaDye/YTkcv0gKU=;
        b=Om6aLBpSYR89cMq1GqRhyYnE1Kc5e9wqU6vCKdXFAm/uUUysTseAP9w+wnNY/2fPrF
         Y9D6ahFAbUoIqmFpbQuwE4N7my84D/tIgtDCTiRy1PjV51qAkpRKqTFadSQodgUWHKNG
         on/NYs4BUDM9Aduy1g7S6o1OgS7ZkdAj/WwBl9fma/kjl1rIWbJ+stH2vc4XwjNayZbh
         DbllaE0V9Yuk0yQ+PDaSFDbJZZfgWgziF8SHxKxAxj8iRadcgs/SY+TjFV4M+Nd3neUJ
         Oh2bR1ApVnyMIh8LK5NX5JEmMZfaGfwSrwUowmX+qJhgnr6PZ4hGMuwmp5uiMdyh+Cwk
         ZpTw==
X-Gm-Message-State: AOAM5338Qjye2jRGh5dkMUP08IOqK6NaYoOI0LKRstxZFOug3Bo7D6Vj
        s4HVIOipoCCnyvcR7GbfSx0=
X-Google-Smtp-Source: ABdhPJyF+/7Jp+d8nV4auNdm3/6c86IRMH40NlxneUCiTvUF5BrwY+bIsiv44516Oh6bSStAo0Wq3g==
X-Received: by 2002:a63:4206:: with SMTP id p6mr627902pga.285.1628191188243;
        Thu, 05 Aug 2021 12:19:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Michael Reed <mdr@sgi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 37/52] qla1280: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:13 -0700
Message-Id: <20210805191828.3559897-38-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla1280.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 928da90b79be..9f9b4900c3ab 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -490,7 +490,6 @@ __setup("qla1280=", qla1280_setup);
 #define	CMD_SNSLEN(Cmnd)	SCSI_SENSE_BUFFERSIZE
 #define	CMD_RESULT(Cmnd)	Cmnd->result
 #define	CMD_HANDLE(Cmnd)	Cmnd->host_scribble
-#define CMD_REQUEST(Cmnd)	Cmnd->request->cmd
 
 #define CMD_HOST(Cmnd)		Cmnd->device->host
 #define SCSI_BUS_32(Cmnd)	Cmnd->device->channel
@@ -2827,7 +2826,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	memset(((char *)pkt + 8), 0, (REQUEST_ENTRY_SIZE - 8));
 
 	/* Set ISP command timeout. */
-	pkt->timeout = cpu_to_le16(cmd->request->timeout/HZ);
+	pkt->timeout = cpu_to_le16(scsi_cmd_to_rq(cmd)->timeout / HZ);
 
 	/* Set device target ID and LUN */
 	pkt->lun = SCSI_LUN_32(cmd);
@@ -3082,7 +3081,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	memset(((char *)pkt + 8), 0, (REQUEST_ENTRY_SIZE - 8));
 
 	/* Set ISP command timeout. */
-	pkt->timeout = cpu_to_le16(cmd->request->timeout/HZ);
+	pkt->timeout = cpu_to_le16(scsi_cmd_to_rq(cmd)->timeout / HZ);
 
 	/* Set device target ID and LUN */
 	pkt->lun = SCSI_LUN_32(cmd);
