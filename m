From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 01/11] libiscsi: Convert to host_lock less w/ interrupts disabled internally
Date: Thu, 11 Nov 2010 16:13:28 -0800
Message-ID: <1289520808-16438-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm27.bullet.mail.ac4.yahoo.com ([98.139.52.224]:46085 "HELO
	nm27.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755156Ab0KLANd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 19:13:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes iscsi_queuecommand_lck() to a host_lock less
iscsi_queuecommand() that will internally disable interrupts using
session->lock and drop the now legacy host_lock unlock.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libiscsi.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c15fde8..8880e7e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1599,7 +1599,7 @@ enum {
 	FAILURE_SESSION_NOT_READY,
 };
 
-static int iscsi_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
+int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 {
 	struct iscsi_cls_session *cls_session;
 	struct Scsi_Host *host;
@@ -1608,6 +1608,7 @@ static int iscsi_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi
 	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	struct iscsi_task *task = NULL;
+	unsigned long irq_flags;
 
 	sc->scsi_done = done;
 	sc->result = 0;
@@ -1615,11 +1616,10 @@ static int iscsi_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi
 
 	host = sc->device->host;
 	ihost = shost_priv(host);
-	spin_unlock(host->host_lock);
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
-	spin_lock(&session->lock);
+	spin_lock_irqsave(&session->lock, irq_flags);
 
 	reason = iscsi_session_chkready(cls_session);
 	if (reason) {
@@ -1705,25 +1705,23 @@ static int iscsi_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi
 	}
 
 	session->queued_cmdsn++;
-	spin_unlock(&session->lock);
-	spin_lock(host->host_lock);
+	spin_unlock_irqrestore(&session->lock, irq_flags);
 	return 0;
 
 prepd_reject:
 	sc->scsi_done = NULL;
 	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 reject:
-	spin_unlock(&session->lock);
+	spin_unlock_irqrestore(&session->lock, irq_flags);
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
 			  sc->cmnd[0], reason);
-	spin_lock(host->host_lock);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 prepd_fault:
 	sc->scsi_done = NULL;
 	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 fault:
-	spin_unlock(&session->lock);
+	spin_unlock_irqrestore(&session->lock, irq_flags);
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
 			  sc->cmnd[0], reason);
 	if (!scsi_bidi_cmnd(sc))
@@ -1733,11 +1731,8 @@ fault:
 		scsi_in(sc)->resid = scsi_in(sc)->length;
 	}
 	done(sc);
-	spin_lock(host->host_lock);
 	return 0;
 }
-
-DEF_SCSI_QCMD(iscsi_queuecommand)
 EXPORT_SYMBOL_GPL(iscsi_queuecommand);
 
 int iscsi_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
-- 
1.7.2.3

