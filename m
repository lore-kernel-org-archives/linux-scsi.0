Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70642C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354091AbiBKWdO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347225AbiBKWdK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:10 -0500
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AB8D4E
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:08 -0800 (PST)
Received: by mail-pf1-f174.google.com with SMTP id x15so16242538pfr.5
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WrNkLMSkXV+t7s5OlpvFHz2hhdrl7t6S2yxsu+gC31k=;
        b=LxE4TsR28ZrpbJog14KfNaK6OvDm1m1qfGEqARCDvNBFxNlrT3M2maNzC6wXZBJTf0
         JO5ZYa3UJv6StxI2JnSevNKpSqxTVFD3e9c06N97P+97LAUj/UAaUpRMAz2opxOCfUPH
         pjWzd7aqe9JKO6mO42rStZtBMVcvYQHVzGqu/jR69/znIrS5QPIL2EA3ZNPUrAwNyy1/
         qLDkyRs/Fs+tUsxC90WUukvr7qI35u8ONnIXk07GYk1AFhhcvULuvF2gwWiMfAaJ/WQz
         X9XV0lCNuOTR3MOelFeSjlKEy7xMkaH8UHn5q99PNRo3AVE8lBHDVR2/a4i1QvagFPju
         n/7Q==
X-Gm-Message-State: AOAM533A6hD8Bm58ZaEgF29IQCGn6+YBElSgfE/HwzykyAaiV8oUFd62
        nnZRNcH/VfMC62Anez+0qgo=
X-Google-Smtp-Source: ABdhPJzt8KoPKR0sjI0z7d5iuXEValW8gq0D1ksKIqIDqsES5vANF27XgC+OgxBrzJeYDvHLTycYSA==
X-Received: by 2002:a63:6a82:: with SMTP id f124mr3052174pgc.64.1644618788215;
        Fri, 11 Feb 2022 14:33:08 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:07 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 04/48] scsi: nsp_cs: Change the return type of two functions into 'void'
Date:   Fri, 11 Feb 2022 14:32:03 -0800
Message-Id: <20220211223247.14369-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

nsp_reselected() and nsphw_init() always return the same value (TRUE).
Hence change the return type of these functions into 'void'.

Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
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
