Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC81BC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D019F611AC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351246AbhERRqv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:51 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:36592 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351265AbhERRqn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:43 -0400
Received: by mail-pl1-f180.google.com with SMTP id a11so5524310plh.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q5il6nx3Gp1/6GeYsovY6bMg95WmmBnoyKcZpLwRi+Y=;
        b=eIH4F9r/LdFjj8g6Qx1XxpJk5Lf0B/DJj+8+w+J1XtomqMY6ZCzTcN14k1QPd2f3HN
         KbrHUjBUZT51xYqJjFYA53Q02oq4Znly0mfyEbAAB4C9FkYMJD72LE5ycQHOpunqaNSh
         6syxZr7IWs+RNQ8NSMhM0kZB5YwjfDHz05XfAa8W75hq+65hUg4ioSu0dR74TxZW/Xuk
         OIjC9JJ2jlO7HN6srtnJbr+Ya4zqT44Nv/muft/yR+CL+Lcsh1fGVUYpwVBK/tkdaM3r
         ZK/P84Fiuxa5PscrgYo2RhIMyHzQjirT9A5jC2zzl+CFW0ro1A2y1Pio+QZX/C8Ekk04
         S0aw==
X-Gm-Message-State: AOAM533LbgBzNmiyNbNCi3ft3RshQzVkzEMfO6CSiARTPuGQUNA73W5H
        z6nTJZDa8XaDCOCWn0WBPnc=
X-Google-Smtp-Source: ABdhPJz9cS9r5Y2cBw6fPsm153bwNGm8z4v46cggIoesudm3h3PfU/T3AVefj3obyYj2P1nayEB/Qg==
X-Received: by 2002:a17:903:187:b029:f1:faff:a111 with SMTP id z7-20020a1709030187b02900f1faffa111mr5875452plg.80.1621359924501;
        Tue, 18 May 2021 10:45:24 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 24/50] ips: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:24 -0700
Message-Id: <20210518174450.20664-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index bc33d54a4011..66152888ad8c 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3733,7 +3733,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 		scb->cmd.dcdb.segment_4G = 0;
 		scb->cmd.dcdb.enhanced_sg = 0;
 
-		TimeOut = scb->scsi_cmd->request->timeout;
+		TimeOut = scsi_cmd_to_rq(scb->scsi_cmd)->timeout;
 
 		if (ha->subsys->param[4] & 0x00100000) {	/* If NEW Tape DCDB is Supported */
 			if (!scb->sg_len) {
