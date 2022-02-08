Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA9FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384213AbiBHRZg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240314AbiBHRZf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:25:35 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE46AC061578
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:25:34 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id k17so14453619plk.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:25:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1cmIiqN2sFpyXxPO+3p79vBVjABAvYNA8QKCxyrtXMY=;
        b=EQ+GRM8rimMIGaJg2/x1AP2mIEmX5oA5QoaxE46r40n0fVqBFdGQ8nrH4v9fJwXh7s
         UGnCQXJstqVi9dOJoCkFKYfOrmLjIeBfeI5uxjg4YvlHQR8D8ubuSAm3jBaOvqUxi2fg
         hRnSi8iEcEx2N6iiBPYV/OJ1/BzWY84bK6uRhnGOlBvZB4j3Rx3sD/rcehIAJZG2Cgsg
         TNVYpJpgePhOaELQq3egre8yKDTtJMymFOzIFsvZ/vr1Eh0Xhyyx8NjFlCmsYAVeFf9b
         LE1JqTCYYWclNjETWrkPSSt7kr+59ps0i1V/WobzTyvvkY+4lVAf1DX5kOW2SzYvE2WS
         pUEg==
X-Gm-Message-State: AOAM532AK1+d3pN26ddM0VmQT7xNxfJF7LdPmY/HJxfwoWCIMIuY0Q/H
        cnmxz5hqFTkMMRAENFEPjzw=
X-Google-Smtp-Source: ABdhPJx+K1Zj0qottUIEdkyTyRuF/46SSPCrBx0InxjUo7VT9/m7hnBOq908qDE6zU8RF1swdSROiA==
X-Received: by 2002:a17:902:d2ca:: with SMTP id n10mr5554890plc.88.1644341134015;
        Tue, 08 Feb 2022 09:25:34 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:25:33 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 01/44] ips: Use true and false instead of TRUE and FALSE
Date:   Tue,  8 Feb 2022 09:24:31 -0800
Message-Id: <20220208172514.3481-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch prepares for removal of the drivers/scsi/scsi.h header file.
That header file defines the 'TRUE' and 'FALSE' constants.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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
 
