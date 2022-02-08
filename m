Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC71C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384343AbiBHR1B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384348AbiBHR0x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:53 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B70C0612BD
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:50 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id c8-20020a17090a674800b001b91184b732so163373pjm.5
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FUMSmSTNBldH6X0/8F9TF0vr2H7VNYIzoorHpNaVeYA=;
        b=RYHgau7HLlQL80lt8k0ict+s/A8s3zRpDef/I3SIaZ8wjEOXSDuLh5yyeUKDqGE7J/
         Zzxy6TsEzE3dFNgD+dlRjsIBqVQU5urbIvS0wt8vRrPw2LO875t8NxpGIxa11IlMZTAB
         bzgFTrTsKmA9WujQh/EkGs2ZdUFMB4Qnz588oe4ixYkPlb1HwLKijwG88UqRvjvtOvgm
         oKmsD1CwEMcvmx4Oi5iYRSB7qj0YR+ZLqkxymeLTcZ9y2uF2puRbonWOG7aHC2sRH903
         eRgu95k+lUXRyGDKhVxH2F4oSEeV9pY9V0DFpcxrcS74HAaM/ku9D+jj/fw+Wptmvgrn
         I9xw==
X-Gm-Message-State: AOAM531/CGsxwIy5ddH3+N5/bbMH6ixfHI0J5ULsOgbGquJWwKuvCd4R
        FFTzTUjjndV4QWHaXOdTkTo=
X-Google-Smtp-Source: ABdhPJysi3COA1AsoV5q+vIW3i/TIWFAblUHPiw5QMIaNRj7LZ7FPBdSW32AONYwL05BEWpHp5CBPg==
X-Received: by 2002:a17:90b:1c81:: with SMTP id oo1mr2464953pjb.192.1644341209544;
        Tue, 08 Feb 2022 09:26:49 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:48 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 36/44] qla1280: Move the SCSI pointer to private command data
Date:   Tue,  8 Feb 2022 09:25:06 -0800
Message-Id: <20220208172514.3481-37-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla1280.c | 21 ++++-----------------
 drivers/scsi/qla1280.h |  3 +--
 2 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 1dc56f4c89d8..0ab595c0870a 100644
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
 
 
@@ -4351,12 +4344,6 @@ static struct pci_driver qla1280_pci_driver = {
 static int __init
 qla1280_init(void)
 {
-	if (sizeof(struct srb) > sizeof(struct scsi_pointer)) {
-		printk(KERN_WARNING
-		       "qla1280: struct srb too big, aborting\n");
-		return -EINVAL;
-	}
-
 #ifdef MODULE
 	/*
 	 * If we are called as a module, the qla1280 pointer may not be null
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
