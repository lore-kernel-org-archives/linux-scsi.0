From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 04/14] cxlflash: Avoid command room violation
Date: Mon, 28 Nov 2016 18:41:45 -0600
Message-ID: <1480380105-60310-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43754 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753935AbcK2AmA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Nov 2016 19:42:00 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAT0cWVD131605
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2016 19:41:59 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 270w686e96-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2016 19:41:59 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Mon, 28 Nov 2016 17:41:58 -0700
In-Reply-To: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

During test, a command room violation interrupt is occasionally seen
for the master context when the CXL flash devices are stressed.

After studying the code, there could be gaps in the way command room
value is being cached in cxlflash. When the cached command room is zero
the thread attempting to send becomes burdened with updating the cached
value with the actual value from the AFU. Today, this is handled with an
atomic set operation of the raw value read. Following the atomic update,
the thread proceeds to send.

This behavior is incorrect on two counts:

   - The update fails to take into account the current thread and its
     consumption of one of the hardware commands.

   - The update does not take into account other threads also atomically
     updating. Per design, a worker thread updates the cached value when a
     send thread times out. By not protecting the update with a lock, the
     cached value can be incorrectly clobbered.

To correct these issues, the update of the cached command room has been
simplified and also protected using a spin lock which is held until the
MMIO is complete. This ensures the command room is properly consumed by
the same thread. Update of cached value also takes into account the
current thread consuming a hardware command.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  4 +--
 drivers/scsi/cxlflash/main.c   | 66 ++++++++++++------------------------------
 2 files changed, 20 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 6e68155..ef2943d 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -173,8 +173,8 @@ struct afu {
 	u64 *hrrq_end;
 	u64 *hrrq_curr;
 	bool toggle;
-	bool read_room;
-	atomic64_t room;
+	s64 room;
+	spinlock_t rrin_slock; /* Lock to rrin queuing and cmd_room updates */
 	u64 hb;
 	u32 cmd_couts;		/* Number of command checkouts */
 	u32 internal_lun;	/* User-desired LUN mode for this AFU */
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 6d33d8c..1292a74 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -306,59 +306,34 @@ static int send_cmd(struct afu *afu, struct afu_cmd *cmd)
 {
 	struct cxlflash_cfg *cfg = afu->parent;
 	struct device *dev = &cfg->dev->dev;
-	int nretry = 0;
 	int rc = 0;
-	u64 room;
-	long newval;
+	s64 room;
+	ulong lock_flags;
 
 	/*
-	 * This routine is used by critical users such an AFU sync and to
-	 * send a task management function (TMF). Thus we want to retry a
-	 * bit before returning an error. To avoid the performance penalty
-	 * of MMIO, we spread the update of 'room' over multiple commands.
+	 * To avoid the performance penalty of MMIO, spread the update of
+	 * 'room' over multiple commands.
 	 */
-retry:
-	newval = atomic64_dec_if_positive(&afu->room);
-	if (!newval) {
-		do {
-			room = readq_be(&afu->host_map->cmd_room);
-			atomic64_set(&afu->room, room);
-			if (room)
-				goto write_ioarrin;
-			udelay(1 << nretry);
-		} while (nretry++ < MC_ROOM_RETRY_CNT);
-
-		dev_err(dev, "%s: no cmd_room to send 0x%X\n",
-		       __func__, cmd->rcb.cdb[0]);
-
-		goto no_room;
-	} else if (unlikely(newval < 0)) {
-		/* This should be rare. i.e. Only if two threads race and
-		 * decrement before the MMIO read is done. In this case
-		 * just benefit from the other thread having updated
-		 * afu->room.
-		 */
-		if (nretry++ < MC_ROOM_RETRY_CNT) {
-			udelay(1 << nretry);
-			goto retry;
+	spin_lock_irqsave(&afu->rrin_slock, lock_flags);
+	if (--afu->room < 0) {
+		room = readq_be(&afu->host_map->cmd_room);
+		if (room <= 0) {
+			dev_dbg_ratelimited(dev, "%s: no cmd_room to send "
+					    "0x%02X, room=0x%016llX\n",
+					    __func__, cmd->rcb.cdb[0], room);
+			afu->room = 0;
+			rc = SCSI_MLQUEUE_HOST_BUSY;
+			goto out;
 		}
-
-		goto no_room;
+		afu->room = room - 1;
 	}
 
-write_ioarrin:
 	writeq_be((u64)&cmd->rcb, &afu->host_map->ioarrin);
 out:
+	spin_unlock_irqrestore(&afu->rrin_slock, lock_flags);
 	pr_devel("%s: cmd=%p len=%d ea=%p rc=%d\n", __func__, cmd,
 		 cmd->rcb.data_len, (void *)cmd->rcb.data_ea, rc);
 	return rc;
-
-no_room:
-	afu->read_room = true;
-	kref_get(&cfg->afu->mapcount);
-	schedule_work(&cfg->work_q);
-	rc = SCSI_MLQUEUE_HOST_BUSY;
-	goto out;
 }
 
 /**
@@ -1827,7 +1802,8 @@ static int init_afu(struct cxlflash_cfg *cfg)
 	}
 
 	afu_err_intr_init(cfg->afu);
-	atomic64_set(&afu->room, readq_be(&afu->host_map->cmd_room));
+	spin_lock_init(&afu->rrin_slock);
+	afu->room = readq_be(&afu->host_map->cmd_room);
 
 	/* Restore the LUN mappings */
 	cxlflash_restore_luntable(cfg);
@@ -2399,7 +2375,6 @@ MODULE_DEVICE_TABLE(pci, cxlflash_pci_table);
  * Handles the following events:
  * - Link reset which cannot be performed on interrupt context due to
  * blocking up to a few seconds
- * - Read AFU command room
  * - Rescan the host
  */
 static void cxlflash_worker_thread(struct work_struct *work)
@@ -2436,11 +2411,6 @@ static void cxlflash_worker_thread(struct work_struct *work)
 		cfg->lr_state = LINK_RESET_COMPLETE;
 	}
 
-	if (afu->read_room) {
-		atomic64_set(&afu->room, readq_be(&afu->host_map->cmd_room));
-		afu->read_room = false;
-	}
-
 	spin_unlock_irqrestore(cfg->host->host_lock, lock_flags);
 
 	if (atomic_dec_if_positive(&cfg->scan_host_needed) >= 0)
-- 
2.1.0

