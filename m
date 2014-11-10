From: Hiral Shah <hishah@cisco.com>
Subject: [PATCH 5/5] [SCSI] Fnic: Fnic Driver crashed with NULL pointer reference
Date: Mon, 10 Nov 2014 12:54:36 -0800
Message-ID: <1415652876-24570-5-git-send-email-hishah@cisco.com>
References: <1415652876-24570-1-git-send-email-hishah@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-8.cisco.com ([173.37.142.95]:20610 "EHLO
	alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaKJVCi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 16:02:38 -0500
In-Reply-To: <1415652876-24570-1-git-send-email-hishah@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hiral Shah <hishah@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Anil Chintalapati <achintal@cisco.com>

When issuing I/O request, if the I/O completes before returning from
fnic_queuecommand(), we may be referencing scsi_cmnd structure that may
be freed by interrupt handler. Acquring IO lock would synchronize
fnic_queuecommand and interrupt handler.

- Increment fnic version from 1.6.0.15 to 1.6.0.16

Signed-off-by: Hiral Shah <hishah@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Anil Chintalapati <achintal@cisco.com>
---
 drivers/scsi/fnic/fnic.h      |  2 +-
 drivers/scsi/fnic/fnic_scsi.c | 21 ++++++++++++++++++---
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 977960b..3b73b96 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.15"
+#define DRV_VERSION		"1.6.0.16"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index d59d4c1..1b8d5c2 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -428,9 +428,10 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	int ret;
 	u64 cmd_trace;
 	int sg_count = 0;
-	unsigned long flags;
+	unsigned long flags = 0;
 	unsigned long ptr;
 	struct fc_rport_priv *rdata;
+	spinlock_t *io_lock = NULL;
 
 	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_IO_BLOCKED)))
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -516,6 +517,13 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 		}
 	}
 
+	/*
+	* Will acquire lock defore setting to IO initialized.
+	*/
+
+	io_lock = fnic_io_lock_hash(fnic, sc);
+	spin_lock_irqsave(io_lock, flags);
+
 	/* initialize rest of io_req */
 	io_req->port_id = rport->port_id;
 	io_req->start_time = jiffies;
@@ -532,11 +540,9 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 		 * In case another thread cancelled the request,
 		 * refetch the pointer under the lock.
 		 */
-		spinlock_t *io_lock = fnic_io_lock_hash(fnic, sc);
 		FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
 			  sc->request->tag, sc, 0, 0, 0,
 			  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
-		spin_lock_irqsave(io_lock, flags);
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 		CMD_SP(sc) = NULL;
 		CMD_STATE(sc) = FNIC_IOREQ_CMD_COMPLETE;
@@ -545,6 +551,10 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 			fnic_release_ioreq_buf(fnic, io_req, sc);
 			mempool_free(io_req, fnic->io_req_pool);
 		}
+		atomic_dec(&fnic->in_flight);
+		/* acquire host lock before returning to SCSI */
+		spin_lock(lp->host->host_lock);
+		return ret;
 	} else {
 		atomic64_inc(&fnic_stats->io_stats.active_ios);
 		atomic64_inc(&fnic_stats->io_stats.num_ios);
@@ -566,6 +576,11 @@ out:
 		  sc->request->tag, sc, io_req,
 		  sg_count, cmd_trace,
 		  (((u64)CMD_FLAGS(sc) >> 32) | CMD_STATE(sc)));
+
+	/* if only we issued IO, will we have the io lock */
+	if (CMD_FLAGS(sc) & FNIC_IO_INITIALIZED)
+		spin_unlock_irqrestore(io_lock, flags);
+
 	atomic_dec(&fnic->in_flight);
 	/* acquire host lock before returning to SCSI */
 	spin_lock(lp->host->host_lock);
-- 
1.8.5.4

