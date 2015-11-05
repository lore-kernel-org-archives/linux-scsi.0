From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH 4/4] scsi: mptxsas: offload IRQ execution
Date: Wed,  4 Nov 2015 23:46:29 -0500
Message-ID: <1446698789-19308-4-git-send-email-okaya@codeaurora.org>
References: <1446698789-19308-1-git-send-email-okaya@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446698789-19308-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com
Cc: Sinan Kaya <okaya@codeaurora.org>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, MPT-FusionLinux.pdl@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The mpt2sas and mpt3sas drivers are spinning
forever in their IRQ handlers if there is a lot
of job queued up by the PCIe card. This handler is
causing spikes for the rest of the system and
sluggish behavior.

Marking all MSI interrupts as non-shared and
moving the MSI interrupts to thread context.
This relexes the rest of the system execution.

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 13 +++++++++----
 drivers/scsi/mpt3sas/mpt3sas_base.c | 14 ++++++++++----
 2 files changed, 19 insertions(+), 8 deletions(-)
 mode change 100644 => 100755 drivers/scsi/mpt3sas/mpt3sas_base.c

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index c61c82a..ee2aead 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1359,14 +1359,19 @@ _base_request_irq(struct MPT2SAS_ADAPTER *ioc, u8 index, u32 vector)
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
+	}
+	else {
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
old mode 100644
new mode 100755
index 6dc391c..c29f359
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1661,14 +1661,20 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
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
+	}
+	else {
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
