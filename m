Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B15C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354095AbiBKWdM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354085AbiBKWdI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:08 -0500
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2E4D53
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:07 -0800 (PST)
Received: by mail-pf1-f173.google.com with SMTP id i21so17181054pfd.13
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E963z4MSOb8b/PDvjjuYl5v9glEe4XjOfUpSpCCC8xw=;
        b=xj/aXdVpLUfqZP4OWTMsvyKzRAPkDeRZZCP3DAtj+/08qgnZz3NPgJqWFS1i/3CQfR
         ep8d0J8eFsDuJ+Ygu6AZ9mkZHTcxyI1nISDv8lINdJDhjpL5eRcLABwMFubcKL+NtfVG
         4GvcnxTpY0DbLPma1X9P7Y2VHtzmzLkp8+SAZoCQOhX1kq4hCzaONtOVG4Ke8hPgQXKv
         tQ6kH8Q6OtQ33Fj/IfIK1EhyE3ug9tY4pfIGXDWH+Frk08OGQuZtaPhMzT9g4rFx3BUz
         35KZ+TZpgVCYSn6RsnDn+EF/KS3G3c0INRkeElhd9VhQHZxlhEkzjck2G3G5s9P/5/De
         yOhw==
X-Gm-Message-State: AOAM531bkBMBSVwi61G/e3sakRN+CLnAnjYPGwdDfN8iblCN4mLaSPgL
        1lQZpvPEKDE7crERehjAC22svUoKId3s6Q==
X-Google-Smtp-Source: ABdhPJwJCDAEWsq5f8d2iC3fdu2+gZNystuDU45gaIiamwh7HjBLZwgGG62TMqy9Fywez7vbIAQUog==
X-Received: by 2002:a63:1ca:: with SMTP id 193mr3123388pgb.20.1644618786452;
        Fri, 11 Feb 2022 14:33:06 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:05 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 03/48] scsi: ips: Use true and false instead of TRUE and FALSE
Date:   Fri, 11 Feb 2022 14:32:02 -0800
Message-Id: <20220211223247.14369-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch prepares for removal of the drivers/scsi/scsi.h header file.
That header file defines the 'TRUE' and 'FALSE' constants.

Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
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
 
