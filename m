Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E2FC4360C
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C2BD61074
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351322AbhERRrB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:01 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:34575 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351285AbhERRq6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:58 -0400
Received: by mail-pg1-f171.google.com with SMTP id l70so7552822pga.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c+J3FMBmkv9QBxtbKvY2a7P5tftYk6T/5jWRZacFAdY=;
        b=QvwzHYGQmvrnA4lLTF5pTe+5S+LKjU5LbWGxZqtzBVFWPHEuJ7ZBSoJ+o93YNmUB6z
         QmH6/038JCtTpI5/e3DrYDURvkbrFhbG3nLxDIE18j3LMszR9OOhM6AYsuJ461TfzPJo
         SmAMaKIeBHdLY8/6bDBYJHGIABoBAiAuhADd6e4QDaaNRcf3hxrWicUdqgFZ1GLD4EJE
         y7dVXqCRKRYnkzi3cDowxpsHcW+pYbCWK7PV0D9wYKV4N2iNgF0MEcFhnmYzm0yRHUxu
         S3Hx4oYM6gOrjoV6b/SIuATYJ0PJ9lOo7thO18R36M+AhLLG7CaUR0J6j/EMRwEwGUeu
         SNQw==
X-Gm-Message-State: AOAM532If4NfwfEBff038cr/+ddxmKYryxLWLtmrNzxiEMeI7SMo5n1F
        tzOAkR1/zb7b1xarXdBh400=
X-Google-Smtp-Source: ABdhPJwThUu0IG2/5fggtu7SMPiCyjnwa7qnuMRCvlJXZd+SvhAGXVsjkAL9r/78x3UQDWW7UqVEEA==
X-Received: by 2002:aa7:9252:0:b029:2ae:bde3:621f with SMTP id 18-20020aa792520000b02902aebde3621fmr6272719pfp.18.1621359940009;
        Tue, 18 May 2021 10:45:40 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Michael Reed <mdr@sgi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 35/50] qla1280: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:35 -0700
Message-Id: <20210518174450.20664-36-bvanassche@acm.org>
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
 drivers/scsi/qla1280.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 928da90b79be..15d564076707 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -490,7 +490,7 @@ __setup("qla1280=", qla1280_setup);
 #define	CMD_SNSLEN(Cmnd)	SCSI_SENSE_BUFFERSIZE
 #define	CMD_RESULT(Cmnd)	Cmnd->result
 #define	CMD_HANDLE(Cmnd)	Cmnd->host_scribble
-#define CMD_REQUEST(Cmnd)	Cmnd->request->cmd
+#define CMD_REQUEST(Cmnd)	scsi_cmd_to_rq(Cmnd)->cmd
 
 #define CMD_HOST(Cmnd)		Cmnd->device->host
 #define SCSI_BUS_32(Cmnd)	Cmnd->device->channel
@@ -2827,7 +2827,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	memset(((char *)pkt + 8), 0, (REQUEST_ENTRY_SIZE - 8));
 
 	/* Set ISP command timeout. */
-	pkt->timeout = cpu_to_le16(cmd->request->timeout/HZ);
+	pkt->timeout = cpu_to_le16(scsi_cmd_to_rq(cmd)->timeout / HZ);
 
 	/* Set device target ID and LUN */
 	pkt->lun = SCSI_LUN_32(cmd);
@@ -3082,7 +3082,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	memset(((char *)pkt + 8), 0, (REQUEST_ENTRY_SIZE - 8));
 
 	/* Set ISP command timeout. */
-	pkt->timeout = cpu_to_le16(cmd->request->timeout/HZ);
+	pkt->timeout = cpu_to_le16(scsi_cmd_to_rq(cmd)->timeout / HZ);
 
 	/* Set device target ID and LUN */
 	pkt->lun = SCSI_LUN_32(cmd);
