From: Hiral Shah <hishah@cisco.com>
Subject: [PATCH 1/1] Using the local variable instead of I/O flag to acquire io_req_lock in fnic_queuecommand() to avoid deadloack
Date: Tue, 14 Jul 2015 07:08:57 -0700
Message-ID: <1436882937-11741-1-git-send-email-hishah@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-5.cisco.com ([173.37.142.92]:20188 "EHLO
	alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbbGNOYt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2015 10:24:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hiral Shah <hishah@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Anil Chintalapati <achintal@cisco.com>

We added changes in fnic driver patch 1.6.0.16 to acquire
 io_req_lock in fnic_queuecommand() before issuing I/O so that io completion
 is serialized. But when releasing the lock we check for the I/O flag and
 this could be modified if IO abort occurs before I/O completion. In this case
 we wont release the lock and causes deadlock in some scenerios. Using the
 local variable to check the IO lock status will resolve the problem.

Signed-off-by: Hiral Shah <hishah@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Anil Chintalapati <achintal@cisco.com>
---
 drivers/scsi/fnic/fnic.h      | 2 +-
 drivers/scsi/fnic/fnic_scsi.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 26270c3..ce129e5 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.17"
+#define DRV_VERSION		"1.6.0.17a"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 155b286..25436cd 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -425,6 +425,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	unsigned long ptr;
 	struct fc_rport_priv *rdata;
 	spinlock_t *io_lock = NULL;
+	int io_lock_acquired = 0;
 
 	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_IO_BLOCKED)))
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -518,6 +519,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	spin_lock_irqsave(io_lock, flags);
 
 	/* initialize rest of io_req */
+	io_lock_acquired = 1;
 	io_req->port_id = rport->port_id;
 	io_req->start_time = jiffies;
 	CMD_STATE(sc) = FNIC_IOREQ_CMD_PENDING;
@@ -571,7 +573,7 @@ out:
 		  (((u64)CMD_FLAGS(sc) >> 32) | CMD_STATE(sc)));
 
 	/* if only we issued IO, will we have the io lock */
-	if (CMD_FLAGS(sc) & FNIC_IO_INITIALIZED)
+	if (io_lock_acquired)
 		spin_unlock_irqrestore(io_lock, flags);
 
 	atomic_dec(&fnic->in_flight);
-- 
1.8.5.4

