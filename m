Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B84C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiA1WWW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:22 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:52046 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351672AbiA1WV5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:57 -0500
Received: by mail-pj1-f52.google.com with SMTP id q63so7804387pja.1
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vHK7VwO4kjcTLuSabb8KiRdPcNVKGbI4IAkKNxC+Zu8=;
        b=Ii62/QbqnCKOYH3HYpmvgh/8YkDxxOBBavRX1ur+Ml2wy0oCWCL8fRoRjvmnEt3TZQ
         BUbha8QnBVNI0h7yC1ihVZmc+vXNWllOPf7mEhJb2iV2hsQnFtJbdpfqJOi0J9EpkCDF
         vxP6TUBai1nDYTOjVKBlFWAcB5kuy7oWUN9uBZe+K9Xt8MZO++V/N9pNO0HabXKAOH/c
         LU+CzxxHqfjcKOcUueSG+ijFoUOMpE7SSsqi8CipKYuq49f0VD+eYkXa/D5ovUP2oqaA
         TjjIZEojFhK0fZOeexJMkOYwikprBtXOrPJqVsn9TAaMLTmRbVThm1/3KSRNDZl3Wtwc
         PmNA==
X-Gm-Message-State: AOAM531tSKXqydZjqgdfeKT+bHzT/WgYe34eY6sCaTTcIh551bFRCV22
        zlyqJUYOKIYtjLS4zOKCO20=
X-Google-Smtp-Source: ABdhPJwtKvLJpBr9C+yRFivoNCXJ+cTGj/57fx7mDATtmwkZV7fvX2N2/66yk1MRSvf92z0ooWKHBw==
X-Received: by 2002:a17:903:18c:: with SMTP id z12mr10533029plg.119.1643408507970;
        Fri, 28 Jan 2022 14:21:47 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:47 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 36/44] qla1280: Move the SCSI pointer to private command data
Date:   Fri, 28 Jan 2022 14:19:01 -0800
Message-Id: <20220128221909.8141-37-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla1280.c | 15 ++++-----------
 drivers/scsi/qla1280.h |  3 +--
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 1dc56f4c89d8..c50e134a9407 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -477,13 +477,6 @@ __setup("qla1280=", qla1280_setup);
 #endif
 
 
-/*
- * We use the scsi_pointer structure that's included with each scsi_command
- * to overlay our struct srb over it. qla1280_init() checks that a srb is not
- * bigger than a scsi_pointer.
- */
-
-#define	CMD_SP(Cmnd)		&Cmnd->SCp
 #define	CMD_CDBLEN(Cmnd)	Cmnd->cmd_len
 #define	CMD_CDBP(Cmnd)		Cmnd->cmnd
 #define	CMD_SNSP(Cmnd)		Cmnd->sense_buffer
@@ -693,7 +686,7 @@ static int qla1280_queuecommand_lck(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_qla_host *ha = (struct scsi_qla_host *)host->hostdata;
-	struct srb *sp = (struct srb *)CMD_SP(cmd);
+	struct srb *sp = scsi_cmd_priv(cmd);
 	int status;
 
 	sp->cmd = cmd;
@@ -828,7 +821,7 @@ qla1280_error_action(struct scsi_cmnd *cmd, enum action action)
 	ENTER("qla1280_error_action");
 
 	ha = (struct scsi_qla_host *)(CMD_HOST(cmd)->hostdata);
-	sp = (struct srb *)CMD_SP(cmd);
+	sp = scsi_cmd_priv(cmd);
 	bus = SCSI_BUS_32(cmd);
 	target = SCSI_TCN_32(cmd);
 	lun = SCSI_LUN_32(cmd);
@@ -3959,7 +3952,7 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
 	int i;
 	ha = (struct scsi_qla_host *)host->hostdata;
 
-	sp = (struct srb *)CMD_SP(cmd);
+	sp = scsi_cmd_priv(cmd);
 	printk("SCSI Command @= 0x%p, Handle=0x%p\n", cmd, CMD_HANDLE(cmd));
 	printk("  chan=%d, target = 0x%02x, lun = 0x%02x, cmd_len = 0x%02x\n",
 	       SCSI_BUS_32(cmd), SCSI_TCN_32(cmd), SCSI_LUN_32(cmd),
@@ -3979,7 +3972,6 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
 	   } */
 	printk("  tag=%d, transfersize=0x%x \n",
 	       scsi_cmd_to_rq(cmd)->tag, cmd->transfersize);
-	printk("  SP=0x%p\n", CMD_SP(cmd));
 	printk(" underflow size = 0x%x, direction=0x%x\n",
 	       cmd->underflow, cmd->sc_data_direction);
 }
@@ -4139,6 +4131,7 @@ static struct scsi_host_template qla1280_driver_template = {
 	.can_queue		= MAX_OUTSTANDING_COMMANDS,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
+	.cmd_size		= sizeof(struct srb),
 };
 
 
diff --git a/drivers/scsi/qla1280.h b/drivers/scsi/qla1280.h
index e7820b5bca38..d309e2ca14de 100644
--- a/drivers/scsi/qla1280.h
+++ b/drivers/scsi/qla1280.h
@@ -87,8 +87,7 @@
 #define RESPONSE_ENTRY_CNT		63  /* Number of response entries. */
 
 /*
- * SCSI Request Block structure  (sp)  that is placed
- * on cmd->SCp location of every I/O
+ * SCSI Request Block structure (sp) that occurs after each struct scsi_cmnd.
  */
 struct srb {
 	struct list_head list;		/* (8/16) LU queue */
