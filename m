Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD265C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 23:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242895AbiE3XPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 19:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbiE3XPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 19:15:41 -0400
Received: from beige.elm.relay.mailchannels.net (beige.elm.relay.mailchannels.net [23.83.212.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4027D712D4
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 16:15:40 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 7EF6E80E74;
        Mon, 30 May 2022 23:15:39 +0000 (UTC)
Received: from pdx1-sub0-mail-a312.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 09E9080A06;
        Mon, 30 May 2022 23:15:39 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1653952539; a=rsa-sha256;
        cv=none;
        b=aeaKGl0p8sDV/pu5RnXSQY/XDg6OBP8YIrVOZblRmTaGU1eZXDCFM0rZTxA8KsEyqcmhT1
        ZuSeDdLNMj4x2bJrNgBRPi2FxCSdzZChl0c7HvkgqMdBvIbWJwcrhIE5K5YyYwmyzRSsgY
        YqhZ3ZcTbuMnkPnJdSd3lr7xFpQG9lhQywzeSdi9v9PKpJ78IXfqVfY0RA7iFiGEQ9Fog8
        Mj5DuQoEFTEpi+u3X4cD6LgTUZHFg0X9fZ5t09II128aRTJo9t89Z4Icj4X+C29A/SbHN6
        yv5l78f/884uA5FHQMu84oPbAAL6XO5/Hix7eKSj7Yy5OiC+8jS17fMxZCGsGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1653952539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=bQ6k9kiUELBB1Kp/cDFLF7qdjydfeS7cxzEv4FKKf8I=;
        b=11gmE+WO/CCQH61K7GYe9F+rMSptRboGX8k2NRE2iKvcoimSCiwZASesyNuLNDHZdOMuj4
        zdAD+8mI0niNHzVI3SnTGZWLqwfLYgPbB++7+FzZkGi6NXmOOjd+SWehxT+lHa6wzOXcp+
        geV19Z2Jkc266n6QWVjqPEBiPkANQUeNyva4uWPx+gNHz0ojb5PIrJwmR9Sxb/gV3UqC5W
        V8dHvqJlgwF80H24z73zpMFp/Q1Q0ZucDeUX1mMOutiKulVf4biGuRwlTYF5YjcG0+jeUo
        cXPIqW7WfAwyoda2drFVDSjT8G+12h/KrFy/yZwpWafkbUJm61gc995cVHXt0Q==
ARC-Authentication-Results: i=1;
        rspamd-54ff499d4f-ghvh7;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Name-Troubled: 2bccc9d417a11ae9_1653952539330_4039614720
X-MC-Loop-Signature: 1653952539330:802792812
X-MC-Ingress-Time: 1653952539330
Received: from pdx1-sub0-mail-a312.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.98.242.203 (trex/6.7.1);
        Mon, 30 May 2022 23:15:39 +0000
Received: from localhost.localdomain (unknown [104.36.31.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a312.dreamhost.com (Postfix) with ESMTPSA id 4LBrqZ2PK8z2g;
        Mon, 30 May 2022 16:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1653952538;
        bh=bQ6k9kiUELBB1Kp/cDFLF7qdjydfeS7cxzEv4FKKf8I=;
        h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
        b=B5IOebZKm5neGc5dXQ7R5YF9L32ezs5+rfRPgSfpGdHqselzgvbD3MQZ+RpchKE4Q
         75T1mEBaQODZRF5Ga53x5CqTdqDcDgMRhNdKbCDC40BpA+xPu/tlkH5faPxLexI9wR
         dCeKvYgjnP+06R2cWqouWXutNWzwCcI8M7qqXuuQIUSRBRzZHXs+XgpDIAXGgcofZh
         8U27aLiPvQX2KuFEvl8pbNaW8SfbG99LlTvBYhWz+FN5SM8Y1y2y15nk/VYjdUWTxW
         6SMsE9XhwyRXLMBWDjZMC5gl2yuPHIwBLw13fd91BkoOlUs0AeGwfMZCcHATgo+RvE
         XnWIzmYUQf7Xg==
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, ejb@linux.ibm.com,
        bigeasy@linutronix.de, tglx@linutronix.de, dave@stgolabs.net,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 05/10] scsi/isci: Replace completion_tasklet with threaded irq
Date:   Mon, 30 May 2022 16:15:07 -0700
Message-Id: <20220530231512.9729-6-dave@stgolabs.net>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530231512.9729-1-dave@stgolabs.net>
References: <20220530231512.9729-1-dave@stgolabs.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tasklets have long been deprecated as being too heavy on the system
by running in irq context - and this is not a performance critical
path. If a higher priority process wants to run, it must wait for
the tasklet to finish before doing so. A more suitable equivalent
is to converted to threaded irq instead and run in regular task
context.

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 drivers/scsi/isci/host.c | 12 ++++++------
 drivers/scsi/isci/host.h |  3 +--
 drivers/scsi/isci/init.c | 17 ++++++++++-------
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 35589b6af90d..b2445782979d 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -220,7 +220,7 @@ irqreturn_t isci_msix_isr(int vec, void *data)
 	struct isci_host *ihost = data;
 
 	if (sci_controller_isr(ihost))
-		tasklet_schedule(&ihost->completion_tasklet);
+		return IRQ_WAKE_THREAD;
 
 	return IRQ_HANDLED;
 }
@@ -610,8 +610,7 @@ irqreturn_t isci_intx_isr(int vec, void *data)
 
 	if (sci_controller_isr(ihost)) {
 		writel(SMU_ISR_COMPLETION, &ihost->smu_registers->interrupt_status);
-		tasklet_schedule(&ihost->completion_tasklet);
-		ret = IRQ_HANDLED;
+	        ret = IRQ_WAKE_THREAD;
 	} else if (sci_controller_error_isr(ihost)) {
 		spin_lock(&ihost->scic_lock);
 		sci_controller_error_handler(ihost);
@@ -1106,12 +1105,11 @@ void ireq_done(struct isci_host *ihost, struct isci_request *ireq, struct sas_ta
 /**
  * isci_host_completion_routine() - This function is the delayed service
  *    routine that calls the sci core library's completion handler. It's
- *    scheduled as a tasklet from the interrupt service routine when interrupts
+ *    scheduled as a task from the interrupt service routine when interrupts
  *    in use, or set as the timeout function in polled mode.
  * @data: This parameter specifies the ISCI host object
- *
  */
-void isci_host_completion_routine(unsigned long data)
+irqreturn_t isci_host_completion_routine(int vector, void *data)
 {
 	struct isci_host *ihost = (struct isci_host *)data;
 	u16 active;
@@ -1133,6 +1131,8 @@ void isci_host_completion_routine(unsigned long data)
 	writel(SMU_ICC_GEN_VAL(NUMBER, active) |
 	       SMU_ICC_GEN_VAL(TIMER, ISCI_COALESCE_BASE + ilog2(active)),
 	       &ihost->smu_registers->interrupt_coalesce_control);
+
+	return IRQ_HANDLED;
 }
 
 /**
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 6bc3f022630a..f3c9ddc0ce5c 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -203,7 +203,6 @@ struct isci_host {
 	#define IHOST_IRQ_ENABLED 2
 	unsigned long flags;
 	wait_queue_head_t eventq;
-	struct tasklet_struct completion_tasklet;
 	spinlock_t scic_lock;
 	struct isci_request *reqs[SCI_MAX_IO_REQUESTS];
 	struct isci_remote_device devices[SCI_MAX_REMOTE_DEVICES];
@@ -478,7 +477,7 @@ void isci_tci_free(struct isci_host *ihost, u16 tci);
 void ireq_done(struct isci_host *ihost, struct isci_request *ireq, struct sas_task *task);
 
 int isci_host_init(struct isci_host *);
-void isci_host_completion_routine(unsigned long data);
+irqreturn_t isci_host_completion_routine(int vec, void *data);
 void isci_host_deinit(struct isci_host *);
 void sci_controller_disable_interrupts(struct isci_host *ihost);
 bool sci_controller_has_remote_devices_stopping(struct isci_host *ihost);
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index e294d5d961eb..d3ec9423d2b1 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -358,8 +358,10 @@ static int isci_setup_interrupts(struct pci_dev *pdev)
 		else
 			isr = isci_msix_isr;
 
-		err = devm_request_irq(&pdev->dev, pci_irq_vector(pdev, i),
-				isr, 0, DRV_NAME"-msix", ihost);
+		err = devm_request_threaded_irq(&pdev->dev,
+						pci_irq_vector(pdev, i), isr,
+						isci_host_completion_routine,
+						0, DRV_NAME"-msix", ihost);
 		if (!err)
 			continue;
 
@@ -377,9 +379,12 @@ static int isci_setup_interrupts(struct pci_dev *pdev)
 
  intx:
 	for_each_isci_host(i, ihost, pdev) {
-		err = devm_request_irq(&pdev->dev, pci_irq_vector(pdev, 0),
-				isci_intx_isr, IRQF_SHARED, DRV_NAME"-intx",
-				ihost);
+		err = devm_request_threaded_irq(&pdev->dev,
+						pci_irq_vector(pdev, 0),
+						isci_intx_isr,
+						isci_host_completion_routine,
+						IRQF_SHARED, DRV_NAME"-intx",
+						ihost);
 		if (err)
 			break;
 	}
@@ -513,8 +518,6 @@ static struct isci_host *isci_host_alloc(struct pci_dev *pdev, int id)
 	init_waitqueue_head(&ihost->eventq);
 	ihost->sas_ha.dev = &ihost->pdev->dev;
 	ihost->sas_ha.lldd_ha = ihost;
-	tasklet_init(&ihost->completion_tasklet,
-		     isci_host_completion_routine, (unsigned long)ihost);
 
 	/* validate module parameters */
 	/* TODO: kill struct sci_user_parameters and reference directly */
-- 
2.36.1

