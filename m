Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05551C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243785AbiA1WUg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:20:36 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:36664 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiA1WUe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:20:34 -0500
Received: by mail-pf1-f181.google.com with SMTP id 192so7451312pfz.3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:20:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TM1x+UgfB7ACGhJaCA8AjG4P3hq12NIPDvGrkrQcN5M=;
        b=0PGW3CEIWHjFqiMwgslFGf+cg8d3VvKphlRe5/h7odIPs4LWYSvL92SzeI95IxRTak
         OSGz8Gb0MwDQvLGGkJlODMnxHjLJxk4n/nFoDDdD8sb12LSo+gBmbjxqneE7h6+zFlTT
         GDgnpgbdMYBz15Z17AQhH7qzj1FCym1XtM4+eldevx12mlWSqhnpxf/2gUfi8cagvc6w
         UfDgJ1XIsDY1FcZ/3vaIlOaiy9JpvcM/q2ivF4yP/HPJGUXzNAHhAeaScZa4web9gxth
         9yiN1LGuhOisXd/nTPSZN1K6GQToWPIYaf6I6gdgf3ksQirzrKUuXf32JWh9bIt6lSAO
         awYA==
X-Gm-Message-State: AOAM531Yz3SlYR3mh0JSKuxSR3ahcN8IlRKaq4f8RLFjMmx6KJtChj+G
        pKEqjK3Z0ot1quZgc8b6YP8=
X-Google-Smtp-Source: ABdhPJw1ENRjH8svyp/bDGaSw46c1GOuEalrwDj6LP6Xm+/q0t9YUUYc2zuXZSSNq1bL++0OdQGvag==
X-Received: by 2002:a63:8849:: with SMTP id l70mr8143318pgd.321.1643408434028;
        Fri, 28 Jan 2022 14:20:34 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:20:33 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 01/44] ips: Use true and false instead of TRUE and FALSE
Date:   Fri, 28 Jan 2022 14:18:26 -0800
Message-Id: <20220128221909.8141-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch prepares for removal of the drivers/scsi/scsi.h header file.
That header file defines the 'TRUE' and 'FALSE' constants.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ips.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 498bf04499ce..b3532d290848 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -655,13 +655,13 @@ ips_release(struct Scsi_Host *sh)
 		printk(KERN_WARNING
 		       "(%s) release, invalid Scsi_Host pointer.\n", ips_name);
 		BUG();
-		return (FALSE);
+		return false;
 	}
 
 	ha = IPS_HA(sh);
 
 	if (!ha)
-		return (FALSE);
+		return false;
 
 	/* flush the cache on the controller */
 	scb = &ha->scbs[ha->max_cmds - 1];
@@ -700,7 +700,7 @@ ips_release(struct Scsi_Host *sh)
 
 	ips_released_controllers++;
 
-	return (FALSE);
+	return false;
 }
 
 /****************************************************************************/
@@ -949,7 +949,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 			scsi_done(scsi_cmd);
 		}
 
-		ha->active = FALSE;
+		ha->active = false;
 		return (FAILED);
 	}
 
@@ -978,7 +978,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 			scsi_done(scsi_cmd);
 		}
 
-		ha->active = FALSE;
+		ha->active = false;
 		return (FAILED);
 	}
 
@@ -1291,7 +1291,7 @@ ips_intr_copperhead(ips_ha_t * ha)
 		return 0;
 	}
 
-	while (TRUE) {
+	while (true) {
 		sp = &ha->sp;
 
 		intrstatus = (*ha->func.isintr) (ha);
@@ -1355,7 +1355,7 @@ ips_intr_morpheus(ips_ha_t * ha)
 		return 0;
 	}
 
-	while (TRUE) {
+	while (true) {
 		sp = &ha->sp;
 
 		intrstatus = (*ha->func.isintr) (ha);
@@ -3090,8 +3090,8 @@ ipsintr_blocking(ips_ha_t * ha, ips_scb_t * scb)
 	METHOD_TRACE("ipsintr_blocking", 2);
 
 	ips_freescb(ha, scb);
-	if ((ha->waitflag == TRUE) && (ha->cmd_in_progress == scb->cdb[0])) {
-		ha->waitflag = FALSE;
+	if (ha->waitflag && ha->cmd_in_progress == scb->cdb[0]) {
+		ha->waitflag = false;
 
 		return;
 	}
@@ -3391,7 +3391,7 @@ ips_send_wait(ips_ha_t * ha, ips_scb_t * scb, int timeout, int intr)
 	METHOD_TRACE("ips_send_wait", 1);
 
 	if (intr != IPS_FFDC) {	/* Won't be Waiting if this is a Time Stamp */
-		ha->waitflag = TRUE;
+		ha->waitflag = true;
 		ha->cmd_in_progress = scb->cdb[0];
 	}
 	scb->callback = ipsintr_blocking;
@@ -3468,10 +3468,8 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
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
@@ -4619,7 +4617,7 @@ ips_poll_for_flush_complete(ips_ha_t * ha)
 {
 	IPS_STATUS cstatus;
 
-	while (TRUE) {
+	while (true) {
 	    cstatus.value = (*ha->func.statupd) (ha);
 
 	    if (cstatus.value == 0xffffffff)      /* If No Interrupt to process */
@@ -5542,26 +5540,26 @@ ips_wait(ips_ha_t * ha, int time, int intr)
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
 
@@ -5596,7 +5594,7 @@ ips_write_driver_status(ips_ha_t * ha, int intr)
 {
 	METHOD_TRACE("ips_write_driver_status", 1);
 
-	if (!ips_readwrite_page5(ha, FALSE, intr)) {
+	if (!ips_readwrite_page5(ha, false, intr)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "unable to read NVRAM page 5.\n");
 
@@ -5634,7 +5632,7 @@ ips_write_driver_status(ips_ha_t * ha, int intr)
 	ha->nvram->versioning = 0;	/* Indicate the Driver Does Not Support Versioning */
 
 	/* now update the page */
-	if (!ips_readwrite_page5(ha, TRUE, intr)) {
+	if (!ips_readwrite_page5(ha, true, intr)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "unable to write NVRAM page 5.\n");
 
