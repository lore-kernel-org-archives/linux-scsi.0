From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 03/11] scsi: Add IRQ_DISABLE_SCSI_QCMD wrapper
Date: Thu, 11 Nov 2010 16:13:46 -0800
Message-ID: <1289520826-16478-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm27-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.63]:25570 "HELO
	nm27-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751505Ab0KLAUb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 19:20:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a IRQ_DISABLE_SCSI_QCMD() wrapper macro used by LLDs
that can now run in host_lock less mode, but still need interrupts disabled
using local_irq_save() before calling their lld_queuecommand() dispatcher.

jgarzik says this method is in fact slower than doing a spin_lock_irqsave() on
internal lib_lld_queuecommand() callers (as is done in libiscsi and libata)
but is still needed by the majority of lock_less LLDs.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 include/scsi/scsi_host.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 6909038..ddb0622 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -523,6 +523,21 @@ struct scsi_host_template {
 		return rc;						\
 	}
 
+/*
+ * Used for LLDs running in lock-less mode, but that still require having
+ * interrupts disable during their lld_queuecommand() dispatch.
+ */
+#define IRQ_DISABLE_SCSI_QCMD(func_name)				\
+	int func_name(struct scsi_cmnd *cmd,				\
+		 void (*done)(struct scsi_cmnd *))			\
+	{								\
+		unsigned long irq_flags;				\
+		int rc;							\
+		local_irq_save(irq_flags);				\
+		rc = func_name##_irq_disable (cmd, done);		\
+		local_irq_restore(irq_flags);				\
+		return rc;						\
+	}	
 
 /*
  * shost state: If you alter this, you also need to alter scsi_sysfs.c
-- 
1.7.2.3

