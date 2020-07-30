Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D46C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFAAC20672
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:04:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Hv8GypTt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgG3IEa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 04:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbgG3IE1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 04:04:27 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25135C061794
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:27 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p3so16093083pgh.3
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HFqgcgpCP70hjCa2Bm/0W74s9wd8zwUqXfHJo02G2Dw=;
        b=Hv8GypTtPguzphI+ZM4SHyF2xhZZmn6CaRsOL5EEB5EN+dGfMHhHeWsHox99+pB768
         tXsxWpaI44mziuMQKt5bWYMrsQ2V27gxVpT151TZOSS9eXW9omohVqBlzY8jJcS05V5v
         mGsJA9zBIbz6Kmf/rds7pPhoYGWp8l/dylhEc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HFqgcgpCP70hjCa2Bm/0W74s9wd8zwUqXfHJo02G2Dw=;
        b=UnXaAAX31LQjpO/nLFT9rNW61wcAQnHssj+ijN9y4/2YMijIyt2ao0XKL3aaxpc1mf
         hJD4AYMM4H5bbLnhNL6LM1t6xovt0chHG+AD/WLBdYsI3CeuTiYbtTT6s0S5Rc7fnk/m
         JfKTZT95ulOQo+7icxyFqx23KFPbNG/Z4JWFBBfF46EP+DvjLdfm5tDpoSSboUtNDX6b
         OGIUcBNTGsfEnqm8I2qm2CutbSvSd0JczfoJrI7zey8i6oRXEEu7ZXGwmxE2yexVl4Rr
         bPFj1BZmrneXjdHUMJWhplaSb6O8o+YrriBj1nhePM/o8FlWVx9AqOWCGbzsytOrVrrd
         Gsug==
X-Gm-Message-State: AOAM532npRU1VnGmo3pMA8WvoR3cfnCBoKGxS1AAbB+bM+ZTZVhIMzeI
        8SLDWPKm+9/MAtJZxQtofttFTg==
X-Google-Smtp-Source: ABdhPJztdNkLl/pbeLee7JUY+VRAg4bgQObQy02pkx9a9UpVicCJC38z8miRjZwmUwmfbjifIA5A7g==
X-Received: by 2002:a63:4f05:: with SMTP id d5mr31555890pgb.298.1596096266533;
        Thu, 30 Jul 2020 01:04:26 -0700 (PDT)
Received: from localhost.localdomain ([192.19.212.250])
        by smtp.gmail.com with ESMTPSA id d13sm5051412pfq.118.2020.07.30.01.04.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 01:04:25 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        sathya.prakash@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 3/7] mpt3sas: Cancel the running work during host reset.
Date:   Thu, 30 Jul 2020 13:33:45 +0530
Message-Id: <1596096229-3341-4-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently during host reset time driver is cancelling only those Firmware
event works which are pending in Firmware event workqueue. It is not
cancelling the work which is running. With this patch driver cancels the
running work also.

Issue Description:

Even though it is not recommended to issue back to back host reset without
any delay, but if someone issues back to back host reset then we observe
that target devices gets unregistered and re-register with SML.
And if OS drive is behind the HBA then when it get unregistered, than
file-system goes into read-only mode. Normally during host reset driver
marks the target device as responding (if they are accessible) and add the
event 'MPT3SAS_REMOVE_UNRESPONDING_DEVICES' to remove the non-responding
devices through FW worker thread. while processing this event driver
unregistered the non-responding devices and clears the responding flag for
all the devices.

The reason why target devices are getting unregistered during successive host
resets is that during the host reset driver has to cleanup all the
outstanding FW event work (both queued one and the currently processing one)
but actually driver is cleaning only the queued events. So if
MPT3SAS_REMOVE_UNRESPONDING_DEVICES event is currently under process then
this event is not getting cleaned up, so at end of all successive host
reset this same event is getting processed more than once. And after the
event got processed for the first time, all the target devices responding
flag is cleared, so when the same is processed for the second time it see
that responding flag is zero, so driver unregistered all the target drives
even-though drives are responding. If driver cleanups the current running
work along with pending work, this type of behavior won't be observed.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  4 ++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 17 ++++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 4fca393..4ed704c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1036,6 +1036,8 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @firmware_event_thread: ""
  * @fw_event_lock:
  * @fw_event_list: list of fw events
+ * @current_evet: current processing firmware event
+ * @fw_event_cleanup: set to one while cleaning up the fw events
  * @aen_event_read_flag: event log was read
  * @broadcast_aen_busy: broadcast aen waiting to be serviced
  * @shost_recovery: host reset in progress
@@ -1217,6 +1219,8 @@ struct MPT3SAS_ADAPTER {
 	struct workqueue_struct	*firmware_event_thread;
 	spinlock_t	fw_event_lock;
 	struct list_head fw_event_list;
+	struct fw_event_work	*current_event;
+	u8		fw_events_cleanup;
 
 	 /* misc flags */
 	int		aen_event_read_flag;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 08fc4b3..66b29d4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3323,11 +3323,13 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct fw_event_work *fw_event;
 
-	if (list_empty(&ioc->fw_event_list) ||
+	if ((list_empty(&ioc->fw_event_list) && !ioc->current_event) ||
 	     !ioc->firmware_event_thread || in_interrupt())
 		return;
 
-	while ((fw_event = dequeue_next_fw_event(ioc))) {
+	ioc->fw_events_cleanup = 1;
+	while ((fw_event = dequeue_next_fw_event(ioc)) ||
+	     (fw_event = ioc->current_event)) {
 		/*
 		 * Wait on the fw_event to complete. If this returns 1, then
 		 * the event was never executed, and we need a put for the
@@ -3341,6 +3343,7 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 
 		fw_event_work_put(fw_event);
 	}
+	ioc->fw_events_cleanup = 0;
 }
 
 /**
@@ -9421,11 +9424,13 @@ mpt3sas_scsih_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 static void
 _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 {
+	ioc->current_event = fw_event;
 	_scsih_fw_event_del_from_list(ioc, fw_event);
 
 	/* the queue is being flushed so ignore this event */
 	if (ioc->remove_host || ioc->pci_error_recovery) {
 		fw_event_work_put(fw_event);
+		ioc->current_event = NULL;
 		return;
 	}
 
@@ -9439,10 +9444,10 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		while (scsi_host_in_recovery(ioc->shost) ||
 					 ioc->shost_recovery) {
 			/*
-			 * If we're unloading, bail. Otherwise, this can become
-			 * an infinite loop.
+			 * If we're unloading or cancelling the work, bail.
+			 * Otherwise, this can become an infinite loop.
 			 */
-			if (ioc->remove_host)
+			if (ioc->remove_host || ioc->fw_events_cleanup)
 				goto out;
 			ssleep(1);
 		}
@@ -9503,11 +9508,13 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		break;
 	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
 		_scsih_pcie_topology_change_event(ioc, fw_event);
+		ioc->current_event = NULL;
 			return;
 	break;
 	}
 out:
 	fw_event_work_put(fw_event);
+	ioc->current_event = NULL;
 }
 
 /**
-- 
2.26.2

