From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.19-rc5
Date: Sat, 24 Jan 2015 10:26:03 -0800
Message-ID: <1422123963.2079.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch consists of four real fixes and three MAINTAINER updates.
Three of the fixes are obvious (the DIX and atomic allocation are bug on
and warn on fixes and the other is just trivial) and the ipr one is a
bit more involved but is required because without it, the card double
completes aborted commands and causes a kernel oops.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Brian King (1):
      ipr: wait for aborted command responses

Colin Ian King (1):
      scsi_debug: test always evaluates to false, || should be used instead

Dave Jiang (1):
      MAINTAINERS: Remove self as isci maintainer

Ewan D. Milne (1):
      scsi: Avoid crashing if device uses DIX but adapter does not support it

Sasha Levin (1):
      scsi_debug: use atomic allocation in resp_rsup_opcodes

Tyrel Datwyler (2):
      MAINTAINERS: ibmvscsi driver maintainer change
      MAINTAINERS: ibmvfc driver maintainer change

and the diffstat:

 MAINTAINERS               |  5 ++-
 drivers/scsi/ipr.c        | 92 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ipr.h        |  1 +
 drivers/scsi/scsi_debug.c |  4 +--
 drivers/scsi/scsi_lib.c   | 12 ++++++-
 5 files changed, 108 insertions(+), 6 deletions(-)

With full diff below.

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index f6dee56..2a97e05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4754,14 +4754,14 @@ S:	Supported
 F:	drivers/net/ethernet/ibm/ibmveth.*
 
 IBM Power Virtual SCSI Device Drivers
-M:	Nathan Fontenot <nfont@linux.vnet.ibm.com>
+M:	Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/ibmvscsi/ibmvscsi*
 F:	drivers/scsi/ibmvscsi/viosrp.h
 
 IBM Power Virtual FC Device Drivers
-M:	Brian King <brking@linux.vnet.ibm.com>
+M:	Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/ibmvscsi/ibmvfc*
@@ -4951,7 +4951,6 @@ K:	\b(ABS|SYN)_MT_
 INTEL C600 SERIES SAS CONTROLLER DRIVER
 M:	Intel SCU Linux support <intel-linux-scu@intel.com>
 M:	Artur Paszkiewicz <artur.paszkiewicz@intel.com>
-M:	Dave Jiang <dave.jiang@intel.com>
 L:	linux-scsi@vger.kernel.org
 T:	git git://git.code.sf.net/p/intel-sas/isci
 S:	Supported
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index df4e27c..9219953 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -683,6 +683,7 @@ static void ipr_init_ipr_cmnd(struct ipr_cmnd *ipr_cmd,
 	ipr_reinit_ipr_cmnd(ipr_cmd);
 	ipr_cmd->u.scratch = 0;
 	ipr_cmd->sibling = NULL;
+	ipr_cmd->eh_comp = NULL;
 	ipr_cmd->fast_done = fast_done;
 	init_timer(&ipr_cmd->timer);
 }
@@ -848,6 +849,8 @@ static void ipr_scsi_eh_done(struct ipr_cmnd *ipr_cmd)
 
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
 	scsi_cmd->scsi_done(scsi_cmd);
+	if (ipr_cmd->eh_comp)
+		complete(ipr_cmd->eh_comp);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 }
 
@@ -4811,6 +4814,84 @@ static int ipr_slave_alloc(struct scsi_device *sdev)
 	return rc;
 }
 
+/**
+ * ipr_match_lun - Match function for specified LUN
+ * @ipr_cmd:	ipr command struct
+ * @device:		device to match (sdev)
+ *
+ * Returns:
+ *	1 if command matches sdev / 0 if command does not match sdev
+ **/
+static int ipr_match_lun(struct ipr_cmnd *ipr_cmd, void *device)
+{
+	if (ipr_cmd->scsi_cmd && ipr_cmd->scsi_cmd->device == device)
+		return 1;
+	return 0;
+}
+
+/**
+ * ipr_wait_for_ops - Wait for matching commands to complete
+ * @ipr_cmd:	ipr command struct
+ * @device:		device to match (sdev)
+ * @match:		match function to use
+ *
+ * Returns:
+ *	SUCCESS / FAILED
+ **/
+static int ipr_wait_for_ops(struct ipr_ioa_cfg *ioa_cfg, void *device,
+			    int (*match)(struct ipr_cmnd *, void *))
+{
+	struct ipr_cmnd *ipr_cmd;
+	int wait;
+	unsigned long flags;
+	struct ipr_hrr_queue *hrrq;
+	signed long timeout = IPR_ABORT_TASK_TIMEOUT;
+	DECLARE_COMPLETION_ONSTACK(comp);
+
+	ENTER;
+	do {
+		wait = 0;
+
+		for_each_hrrq(hrrq, ioa_cfg) {
+			spin_lock_irqsave(hrrq->lock, flags);
+			list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
+				if (match(ipr_cmd, device)) {
+					ipr_cmd->eh_comp = &comp;
+					wait++;
+				}
+			}
+			spin_unlock_irqrestore(hrrq->lock, flags);
+		}
+
+		if (wait) {
+			timeout = wait_for_completion_timeout(&comp, timeout);
+
+			if (!timeout) {
+				wait = 0;
+
+				for_each_hrrq(hrrq, ioa_cfg) {
+					spin_lock_irqsave(hrrq->lock, flags);
+					list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
+						if (match(ipr_cmd, device)) {
+							ipr_cmd->eh_comp = NULL;
+							wait++;
+						}
+					}
+					spin_unlock_irqrestore(hrrq->lock, flags);
+				}
+
+				if (wait)
+					dev_err(&ioa_cfg->pdev->dev, "Timed out waiting for aborted commands\n");
+				LEAVE;
+				return wait ? FAILED : SUCCESS;
+			}
+		}
+	} while (wait);
+
+	LEAVE;
+	return SUCCESS;
+}
+
 static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
@@ -5030,11 +5111,17 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 static int ipr_eh_dev_reset(struct scsi_cmnd *cmd)
 {
 	int rc;
+	struct ipr_ioa_cfg *ioa_cfg;
+
+	ioa_cfg = (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
 
 	spin_lock_irq(cmd->device->host->host_lock);
 	rc = __ipr_eh_dev_reset(cmd);
 	spin_unlock_irq(cmd->device->host->host_lock);
 
+	if (rc == SUCCESS)
+		rc = ipr_wait_for_ops(ioa_cfg, cmd->device, ipr_match_lun);
+
 	return rc;
 }
 
@@ -5234,13 +5321,18 @@ static int ipr_eh_abort(struct scsi_cmnd *scsi_cmd)
 {
 	unsigned long flags;
 	int rc;
+	struct ipr_ioa_cfg *ioa_cfg;
 
 	ENTER;
 
+	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
+
 	spin_lock_irqsave(scsi_cmd->device->host->host_lock, flags);
 	rc = ipr_cancel_op(scsi_cmd);
 	spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, flags);
 
+	if (rc == SUCCESS)
+		rc = ipr_wait_for_ops(ioa_cfg, scsi_cmd->device, ipr_match_lun);
 	LEAVE;
 	return rc;
 }
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index b4f3eec..ec03b42 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1606,6 +1606,7 @@ struct ipr_cmnd {
 		struct scsi_device *sdev;
 	} u;
 
+	struct completion *eh_comp;
 	struct ipr_hrr_queue *hrrq;
 	struct ipr_ioa_cfg *ioa_cfg;
 };
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 7b8b51b..4aca1b0 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1623,7 +1623,7 @@ resp_rsup_opcodes(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	req_opcode = cmd[3];
 	req_sa = get_unaligned_be16(cmd + 4);
 	alloc_len = get_unaligned_be32(cmd + 6);
-	if (alloc_len < 4 && alloc_len > 0xffff) {
+	if (alloc_len < 4 || alloc_len > 0xffff) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 6, -1);
 		return check_condition_result;
 	}
@@ -1631,7 +1631,7 @@ resp_rsup_opcodes(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		a_len = 8192;
 	else
 		a_len = alloc_len;
-	arr = kzalloc((a_len < 256) ? 320 : a_len + 64, GFP_KERNEL);
+	arr = kzalloc((a_len < 256) ? 320 : a_len + 64, GFP_ATOMIC);
 	if (NULL == arr) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6d5c0b8..17bb541 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1143,7 +1143,17 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 		struct scsi_data_buffer *prot_sdb = cmd->prot_sdb;
 		int ivecs, count;
 
-		BUG_ON(prot_sdb == NULL);
+		if (prot_sdb == NULL) {
+			/*
+			 * This can happen if someone (e.g. multipath)
+			 * queues a command to a device on an adapter
+			 * that does not support DIX.
+			 */
+			WARN_ON_ONCE(1);
+			error = BLKPREP_KILL;
+			goto err_exit;
+		}
+
 		ivecs = blk_rq_count_integrity_sg(rq->q, rq->bio);
 
 		if (scsi_alloc_sgtable(prot_sdb, ivecs, is_mq)) {
