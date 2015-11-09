From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH V2 3/3] scsi: mptxsas: offload IRQ execution
Date: Sun,  8 Nov 2015 20:57:46 -0500
Message-ID: <1447034266-28003-4-git-send-email-okaya@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34488 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbbKIB6I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2015 20:58:08 -0500
In-Reply-To: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com
Cc: agross@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, MPT-FusionLinux.pdl@avagotech.com, linux-kernel@vger.kernel.org

The mpt2sas and mpt3sas drivers are spinning forever in
their IRQ handlers if there are a lot of jobs queued up
by the PCIe card. This handler is causing spikes for
the rest of the system and sluggish behavior.

Marking all MSI interrupts as non-shared and moving the
MSI interrupts to thread context. This relexes the rest
of the system execution.

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 12 ++++++++----
 drivers/scsi/mpt3sas/mpt3sas_base.c | 13 +++++++++----
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index c61c82a..b619a0e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1359,14 +1359,18 @@ _base_request_irq(struct MPT2SAS_ADAPTER *ioc, u8 index, u32 vector)
 	cpumask_clear(reply_q->affinity_hint);
 
 	atomic_set(&reply_q->busy, 0);
-	if (ioc->msix_enable)
+	if (ioc->msix_enable) {
 		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-msix%d",
 		    MPT2SAS_DRIVER_NAME, ioc->id, index);
-	else
+		r = request_threaded_irq(vector, NULL, _base_interrupt,
+					 IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					 reply_q->name, reply_q);
+	} else {
 		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d",
 		    MPT2SAS_DRIVER_NAME, ioc->id);
-	r = request_irq(vector, _base_interrupt, IRQF_SHARED, reply_q->name,
-	    reply_q);
+		r = request_irq(vector, _base_interrupt, IRQF_SHARED,
+				reply_q->name, reply_q);
+	}
 	if (r) {
 		printk(MPT2SAS_ERR_FMT "unable to allocate interrupt %d!\n",
 		    reply_q->name, vector);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 6dc391c..62bee43 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1661,14 +1661,19 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
 	cpumask_clear(reply_q->affinity_hint);
 
 	atomic_set(&reply_q->busy, 0);
-	if (ioc->msix_enable)
+	if (ioc->msix_enable) {
 		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-msix%d",
 		    MPT3SAS_DRIVER_NAME, ioc->id, index);
-	else
+
+		r = request_threaded_irq(vector, NULL, _base_interrupt,
+					 IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					 reply_q->name, reply_q);
+	} else {
 		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d",
 		    MPT3SAS_DRIVER_NAME, ioc->id);
-	r = request_irq(vector, _base_interrupt, IRQF_SHARED, reply_q->name,
-	    reply_q);
+		r = request_irq(vector, _base_interrupt, IRQF_SHARED,
+				reply_q->name, reply_q);
+	}
 	if (r) {
 		pr_err(MPT3SAS_FMT "unable to allocate interrupt %d!\n",
 		    reply_q->name, vector);
-- 
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project

