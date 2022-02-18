Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 102C1C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238821AbiBRTxk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:53:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238704AbiBRTxZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:53:25 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074E3291F9E
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:53:03 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id h125so8750897pgc.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:53:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cxknL8rORaVxDDihqRXFx1elb8NLsNOt5DCGPmZQq24=;
        b=E86pVnOaG4g9GJdovMkgDJzUdc/P0rec18SXrXQoafUDSBDF5K2Wixoe+AYc0gGToe
         kk7qLtwM9EvsZCaxrjZARcWS1TvHMApY3H1yc/0wZaVkvi3B7J+MKzZzS0L69MLlT7eT
         9CQ3diKUFjz6O+SVdevW+rU1ceivqrMFrHn+qLgekpSfJKaYLAez1o8qhmaSIjcbFl8u
         kA1oyJ4FACPMaMmlZrGwp8mOhnfK/PZ9F52kPIyETiFaH2G/78HBU/SxAE6aVgSOZSvb
         rhk11FyeVOjM/EGzgyd5t+fpOPgzW3rGEwacoEe54e6ACG9nuTh0rgn4SEBlzCMSYThC
         GV2w==
X-Gm-Message-State: AOAM533SKEdaMzvW7VjLOxO+AU8KtctqFqyM6biPFojAJSMdnO92uh1/
        CM9KbOCyOs/+cGUtaZaDfkg=
X-Google-Smtp-Source: ABdhPJzWluGw/JgZx0RPREWfcl8437/dkFtUEHzeVnS+lk+SsatlZ+lwyzNp36FWlDbGuBsgKGVMVg==
X-Received: by 2002:a62:e112:0:b0:4e1:301e:9faa with SMTP id q18-20020a62e112000000b004e1301e9faamr9205187pfh.56.1645213983273;
        Fri, 18 Feb 2022 11:53:03 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:53:02 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 41/49] scsi: qla1280: Move the SCSI pointer to private command data
Date:   Fri, 18 Feb 2022 11:51:09 -0800
Message-Id: <20220218195117.25689-42-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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
