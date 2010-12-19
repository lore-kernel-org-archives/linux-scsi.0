From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 01/12] libiscsi: Convert to host_lock less w/ interrupts disabled internally
Date: Sun, 19 Dec 2010 13:21:56 -0800
Message-ID: <1292793727-31957-2-git-send-email-nab@linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm26-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.242]:42972 "HELO
	nm26-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757194Ab0LSVWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Dec 2010 16:22:21 -0500
In-Reply-To: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Douglas Gilbert <dgilbert@interlog.com>, adam radford <aradford@gmail.com>, Kashyap Desai <Kashyap.Desai@lsi.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes iscsi_queuecommand_lck() to a host_lock less
iscsi_queuecommand() that will internally disable interrupts using
session->lock and drop the now legacy host_lock unlock.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libiscsi.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c15fde8..5535782 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1599,7 +1599,7 @@ enum {
 	FAILURE_SESSION_NOT_READY,
 };
 
-static int iscsi_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
+int iscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *cls_session;
 	struct Scsi_Host *host;
@@ -1609,13 +1609,11 @@ static int iscsi_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi
 	struct iscsi_conn *conn;
 	struct iscsi_task *task = NULL;
 
-	sc->scsi_done = done;
 	sc->result = 0;
 	sc->SCp.ptr = NULL;
 
 	host = sc->device->host;
 	ihost = shost_priv(host);
-	spin_unlock(host->host_lock);
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
@@ -1706,7 +1704,6 @@ static int iscsi_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi
 
 	session->queued_cmdsn++;
 	spin_unlock(&session->lock);
-	spin_lock(host->host_lock);
 	return 0;
 
 prepd_reject:
@@ -1716,7 +1713,6 @@ reject:
 	spin_unlock(&session->lock);
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
 			  sc->cmnd[0], reason);
-	spin_lock(host->host_lock);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 prepd_fault:
@@ -1732,12 +1728,10 @@ fault:
 		scsi_out(sc)->resid = scsi_out(sc)->length;
 		scsi_in(sc)->resid = scsi_in(sc)->length;
 	}
-	done(sc);
-	spin_lock(host->host_lock);
+	sc->scsi_done(sc);
 	return 0;
 }
 
-DEF_SCSI_QCMD(iscsi_queuecommand)
 EXPORT_SYMBOL_GPL(iscsi_queuecommand);
 
 int iscsi_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
-- 
1.7.3.4

