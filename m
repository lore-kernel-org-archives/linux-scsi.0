Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075E2C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238126AbiBRTvy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:51:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238084AbiBRTvs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:51:48 -0500
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212F5D7E
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:31 -0800 (PST)
Received: by mail-pg1-f178.google.com with SMTP id h125so8747767pgc.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KnYVhSEwp8HZrTUijCkGbfKURzm28Jjo+1PjtXRA8Y8=;
        b=BHyfku+kHD6dFxjplTQf1Sit1O9zdtYR/eTnQPoyToqieUUAbhQIuKDX0nayuXLjpi
         9xq6PnQSG4L2j3tpoSrbIOf4Oa/GBQggYFiKtRw938my5NtXahdhipIjEWO8C/m5H/IJ
         ruLzfvuh8S3DEroRDr6Mfe/I0fLHzwrvXxV93h0TPHVTICmqnTnSji8PvBf7BZE6qIKc
         wczhGhKPBbgBJVzjMSqS7Ex7EjsEZ5pwYfvnoRVicVMxPF2tJjh/rewmQVLmorwjIkIJ
         Y0NqHWNclA6i1zvWAzu61Pa3Zsgy/t+cc2TgkYGoQBmmkXiOg7Je/zVMWIrXw+XAP3Rf
         UmuQ==
X-Gm-Message-State: AOAM532W7ve2Fgi5GScVGHiqI6zAEKrEiC1nOxbKG5qlzMETdGDMcJaU
        ybP/Rpe5O0OfuovhI48nwoxaskykhg/0vw==
X-Google-Smtp-Source: ABdhPJxBPwuoZAX9Ze0c8xa5QVMHDp2PGmlE1wyqM1b1yV7UFZG5Lroa1+S1/qxQq3T9kAbUHllvHA==
X-Received: by 2002:a05:6a00:815:b0:4c0:2388:73c6 with SMTP id m21-20020a056a00081500b004c0238873c6mr9149899pfk.69.1645213890543;
        Fri, 18 Feb 2022 11:51:30 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:51:29 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 04/49] scsi: nsp_cs: Change the return type of two functions into 'void'
Date:   Fri, 18 Feb 2022 11:50:32 -0800
Message-Id: <20220218195117.25689-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

nsp_reselected() and nsphw_init() always return TRUE. Change the return type
of these functions into 'void'.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pcmcia/nsp_cs.c | 17 +++++------------
 drivers/scsi/pcmcia/nsp_cs.h |  4 ++--
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 92c818a8a84a..a5c2dd7ebc16 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -298,7 +298,7 @@ static void nsphw_init_sync(nsp_hw_data *data)
 /*
  * Initialize Ninja hardware
  */
-static int nsphw_init(nsp_hw_data *data)
+static void nsphw_init(nsp_hw_data *data)
 {
 	unsigned int base     = data->BaseAddress;
 
@@ -349,8 +349,6 @@ static int nsphw_init(nsp_hw_data *data)
 	nsp_write(base,	      IRQCONTROL,   IRQCONTROL_ALLCLEAR);
 
 	nsp_setup_fifo(data, FALSE);
-
-	return TRUE;
 }
 
 /*
@@ -643,7 +641,7 @@ static int nsp_dataphase_bypass(struct scsi_cmnd *SCpnt)
 /*
  * accept reselection
  */
-static int nsp_reselected(struct scsi_cmnd *SCpnt)
+static void nsp_reselected(struct scsi_cmnd *SCpnt)
 {
 	unsigned int  base    = SCpnt->device->host->io_port;
 	unsigned int  host_id = SCpnt->device->host->this_id;
@@ -675,8 +673,6 @@ static int nsp_reselected(struct scsi_cmnd *SCpnt)
 	bus_reg = nsp_index_read(base, SCSIBUSCTRL) & ~(SCSI_BSY | SCSI_ATN);
 	nsp_index_write(base, SCSIBUSCTRL, bus_reg);
 	nsp_index_write(base, SCSIBUSCTRL, bus_reg | AUTODIRECTION | ACKENB);
-
-	return TRUE;
 }
 
 /*
@@ -1057,9 +1053,8 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 		if (irq_phase & RESELECT_IRQ) {
 			nsp_dbg(NSP_DEBUG_INTR, "reselect");
 			nsp_write(base, IRQCONTROL, IRQCONTROL_RESELECT_CLEAR);
-			if (nsp_reselected(tmpSC) != FALSE) {
-				return IRQ_HANDLED;
-			}
+			nsp_reselected(tmpSC);
+			return IRQ_HANDLED;
 		}
 
 		if ((irq_phase & (PHASE_CHANGE_IRQ | LATCHED_BUS_FREE)) == 0) {
@@ -1614,9 +1609,7 @@ static int nsp_cs_config(struct pcmcia_device *link)
 	nsp_dbg(NSP_DEBUG_INIT, "I/O[0x%x+0x%x] IRQ %d",
 		data->BaseAddress, data->NumAddress, data->IrqNumber);
 
-	if(nsphw_init(data) == FALSE) {
-		goto cs_failed;
-	}
+	nsphw_init(data);
 
 	host = nsp_detect(&nsp_driver_template);
 
diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index 665bf8d0faf7..94c1f6c7c601 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -304,7 +304,7 @@ static int nsp_eh_host_reset   (struct scsi_cmnd *SCpnt);
 static int nsp_bus_reset       (nsp_hw_data *data);
 
 /* */
-static int  nsphw_init           (nsp_hw_data *data);
+static void nsphw_init           (nsp_hw_data *data);
 static int  nsphw_start_selection(struct scsi_cmnd *SCpnt);
 static void nsp_start_timer      (struct scsi_cmnd *SCpnt, int time);
 static int  nsp_fifo_count       (struct scsi_cmnd *SCpnt);
@@ -320,7 +320,7 @@ static int  nsp_expect_signal    (struct scsi_cmnd *SCpnt,
 				  unsigned char  mask);
 static int  nsp_xfer             (struct scsi_cmnd *SCpnt, int phase);
 static int  nsp_dataphase_bypass (struct scsi_cmnd *SCpnt);
-static int  nsp_reselected       (struct scsi_cmnd *SCpnt);
+static void nsp_reselected       (struct scsi_cmnd *SCpnt);
 static struct Scsi_Host *nsp_detect(struct scsi_host_template *sht);
 
 /* Interrupt handler */
