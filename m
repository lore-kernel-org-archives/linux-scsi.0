From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v8 05/11] libata-eh: allow defer in ata_exec_internal
Date: Mon, 29 Oct 2012 17:01:32 +0800
Message-ID: <1351501298-3716-6-git-send-email-aaron.lu@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ata_exec_internal will preempt the ata link's active_tag and ata port's
qc_active flags, this is OK for error recovery, but if normal code path
wants to use ata_exec_internal, there is a problem: we need to check if
it is OK to issue a new command with the help of port_ops->defer.

In ZPODD, I'll need to find out the loading mechanism of the ODD by
issuing a GET_CONFIGURATION command. And this command may very well
race with commands issued from SCSI layer. So instead of preempt the
current command, defer the new command if it's not OK to issue it, as
it is always wrong to issue a non-NCQ command when there is command(s)
in processing.

So ata_exec_internal is modified to check if it is in eh recovery
environment, and if yes, act as before; if not, check if this command
should be defered with the help of port_ops->defer.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-core.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 611050d..95fb7b8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1557,6 +1557,7 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	unsigned long flags;
 	unsigned int err_mask;
 	int rc;
+	bool eh_in_recover;
 
 	spin_lock_irqsave(ap->lock, flags);
 
@@ -1588,14 +1589,21 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	qc->dev = dev;
 	ata_qc_reinit(qc);
 
-	preempted_tag = link->active_tag;
-	preempted_sactive = link->sactive;
-	preempted_qc_active = ap->qc_active;
-	preempted_nr_active_links = ap->nr_active_links;
-	link->active_tag = ATA_TAG_POISON;
-	link->sactive = 0;
-	ap->qc_active = 0;
-	ap->nr_active_links = 0;
+	eh_in_recover = ap->pflags & ATA_PFLAG_EH_IN_PROGRESS;
+	if (eh_in_recover) {
+		preempted_tag = link->active_tag;
+		preempted_sactive = link->sactive;
+		preempted_qc_active = ap->qc_active;
+		preempted_nr_active_links = ap->nr_active_links;
+		link->active_tag = ATA_TAG_POISON;
+		link->sactive = 0;
+		ap->qc_active = 0;
+		ap->nr_active_links = 0;
+	} else if (ap->ops->qc_defer && ap->ops->qc_defer(qc)) {
+		ata_qc_free(qc);
+		spin_unlock_irqrestore(ap->lock, flags);
+		return -EBUSY;
+	}
 
 	/* prepare & issue qc */
 	qc->tf = *tf;
@@ -1687,10 +1695,12 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	err_mask = qc->err_mask;
 
 	ata_qc_free(qc);
-	link->active_tag = preempted_tag;
-	link->sactive = preempted_sactive;
-	ap->qc_active = preempted_qc_active;
-	ap->nr_active_links = preempted_nr_active_links;
+	if (eh_in_recover) {
+		link->active_tag = preempted_tag;
+		link->sactive = preempted_sactive;
+		ap->qc_active = preempted_qc_active;
+		ap->nr_active_links = preempted_nr_active_links;
+	}
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-- 
1.7.12.4

