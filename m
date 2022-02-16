Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46322C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbiBPVDE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:03:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiBPVDB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:03:01 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B01B207FEF
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:02:49 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id w20so2940537plq.12
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:02:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F6hcTPTAbcTrOtT8jY+FWg4iCNywlNyNbCJma56j84E=;
        b=ogNEjq/3WCWifbo94M7gUPBZqDs7p0+DHoRhQu8+y1qwycBQxnqLnvjIOMuVhu6Q6Q
         mjlSN3PdgC1CC2ZpXRt2pWDOEhbmtdLe/uocrZNezS7o/T6WB9ddweC7XhORyLRp+sV9
         oV5aGmLtG1a+FHIzQsa9J77QAC29JuiCFD69oU9D1322AtU3IoBO6u317wcaNnGYMN8g
         NtjX9Xx8I+OGaCFHHgwW2rF0vcJvjhZrJ4cL5T6dPhy+VV5ulW+kCeYAtjcRGOkvo3PH
         V0NrOhj6Gw4vY6iwgFqUZ+jQvEcwJyPAKNwfs8hFuQbaUkjrNZa1paSwybfcQFJaYGFT
         qxcA==
X-Gm-Message-State: AOAM5328vsD9EHwa3Woyyn8NbHe1ciu+9+bBayzUsM2E6y96gvLEbsD+
        n/8tQWGY+EbUXvl1V7Sr+6U=
X-Google-Smtp-Source: ABdhPJz1XAqFaQl3wKxmcIHPUqUgY15/T7Cb/3SSI4F+/KRC8jhwHt3RTZpPmO+koWPjee3bogWZOg==
X-Received: by 2002:a17:902:b410:b0:14b:e53:7aa0 with SMTP id x16-20020a170902b41000b0014b0e537aa0mr4307249plr.101.1645045368468;
        Wed, 16 Feb 2022 13:02:48 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:02:47 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 03/50] scsi: ips: Use true and false instead of TRUE and FALSE
Date:   Wed, 16 Feb 2022 13:01:46 -0800
Message-Id: <20220216210233.28774-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch prepares for removal of the drivers/scsi/scsi.h header file.
That header file defines the 'TRUE' and 'FALSE' constants.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ips.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 59664e92ec8a..d22ba53d6028 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -945,7 +945,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 			scsi_done(scsi_cmd);
 		}
 
-		ha->active = FALSE;
+		ha->active = false;
 		return (FAILED);
 	}
 
@@ -974,7 +974,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 			scsi_done(scsi_cmd);
 		}
 
-		ha->active = FALSE;
+		ha->active = false;
 		return (FAILED);
 	}
 
@@ -1287,7 +1287,7 @@ ips_intr_copperhead(ips_ha_t * ha)
 		return 0;
 	}
 
-	while (TRUE) {
+	while (true) {
 		sp = &ha->sp;
 
 		intrstatus = (*ha->func.isintr) (ha);
@@ -1351,7 +1351,7 @@ ips_intr_morpheus(ips_ha_t * ha)
 		return 0;
 	}
 
-	while (TRUE) {
+	while (true) {
 		sp = &ha->sp;
 
 		intrstatus = (*ha->func.isintr) (ha);
@@ -3086,8 +3086,8 @@ ipsintr_blocking(ips_ha_t * ha, ips_scb_t * scb)
 	METHOD_TRACE("ipsintr_blocking", 2);
 
 	ips_freescb(ha, scb);
-	if ((ha->waitflag == TRUE) && (ha->cmd_in_progress == scb->cdb[0])) {
-		ha->waitflag = FALSE;
+	if (ha->waitflag && ha->cmd_in_progress == scb->cdb[0]) {
+		ha->waitflag = false;
 
 		return;
 	}
@@ -3387,7 +3387,7 @@ ips_send_wait(ips_ha_t * ha, ips_scb_t * scb, int timeout, int intr)
 	METHOD_TRACE("ips_send_wait", 1);
 
 	if (intr != IPS_FFDC) {	/* Won't be Waiting if this is a Time Stamp */
-		ha->waitflag = TRUE;
+		ha->waitflag = true;
 		ha->cmd_in_progress = scb->cdb[0];
 	}
 	scb->callback = ipsintr_blocking;
@@ -3464,10 +3464,8 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 		if (scb->bus > 0) {
 			/* Controller commands can't be issued */
 			/* to real devices -- fail them        */
-			if ((ha->waitflag == TRUE) &&
-			    (ha->cmd_in_progress == scb->cdb[0])) {
-				ha->waitflag = FALSE;
-			}
+			if (ha->waitflag && ha->cmd_in_progress == scb->cdb[0])
+				ha->waitflag = false;
 
 			return (1);
 		}
@@ -4615,7 +4613,7 @@ ips_poll_for_flush_complete(ips_ha_t * ha)
 {
 	IPS_STATUS cstatus;
 
-	while (TRUE) {
+	while (true) {
 	    cstatus.value = (*ha->func.statupd) (ha);
 
 	    if (cstatus.value == 0xffffffff)      /* If No Interrupt to process */
@@ -5538,26 +5536,26 @@ ips_wait(ips_ha_t * ha, int time, int intr)
 	METHOD_TRACE("ips_wait", 1);
 
 	ret = IPS_FAILURE;
-	done = FALSE;
+	done = false;
 
 	time *= IPS_ONE_SEC;	/* convert seconds */
 
 	while ((time > 0) && (!done)) {
 		if (intr == IPS_INTR_ON) {
-			if (ha->waitflag == FALSE) {
+			if (!ha->waitflag) {
 				ret = IPS_SUCCESS;
-				done = TRUE;
+				done = true;
 				break;
 			}
 		} else if (intr == IPS_INTR_IORL) {
-			if (ha->waitflag == FALSE) {
+			if (!ha->waitflag) {
 				/*
 				 * controller generated an interrupt to
 				 * acknowledge completion of the command
 				 * and ips_intr() has serviced the interrupt.
 				 */
 				ret = IPS_SUCCESS;
-				done = TRUE;
+				done = true;
 				break;
 			}
 
@@ -5592,7 +5590,7 @@ ips_write_driver_status(ips_ha_t * ha, int intr)
 {
 	METHOD_TRACE("ips_write_driver_status", 1);
 
-	if (!ips_readwrite_page5(ha, FALSE, intr)) {
+	if (!ips_readwrite_page5(ha, false, intr)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "unable to read NVRAM page 5.\n");
 
@@ -5630,7 +5628,7 @@ ips_write_driver_status(ips_ha_t * ha, int intr)
 	ha->nvram->versioning = 0;	/* Indicate the Driver Does Not Support Versioning */
 
 	/* now update the page */
-	if (!ips_readwrite_page5(ha, TRUE, intr)) {
+	if (!ips_readwrite_page5(ha, true, intr)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "unable to write NVRAM page 5.\n");
 
