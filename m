From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 7/9] fnic: fnic Driver Tuneables Exposed through CLI
Date: Mon,  9 Sep 2013 13:31:51 -0700
Message-ID: <1378758713-22443-7-git-send-email-hiralpat@cisco.com>
References: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:22291 "EHLO
	rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab3IIUgU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2013 16:36:20 -0400
In-Reply-To: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Hiral Patel <hiralpat@cisco.com>

Introduced module params to provide dynamic way of configuring
queue depth.

Added support to get max io throttle count through UCSM to
configure maximum outstanding IOs supported by fnic and push
that value to scsi mid-layer.

  Supported IO throttle values:

  UCSM IO THROTTLE VALUE        FNIC MAX OUTSTANDING IOS
  ------------------------------------------------------
        16 (Default)                    2048
        <= 256                          256
        > 256                           <ucsm value>

Signed-off-by: Hiral Patel <hiralpat@cisco.com>
---
 drivers/scsi/fnic/fnic.h      |    3 +++
 drivers/scsi/fnic/fnic_main.c |   29 +++++++++++++++++++++--------
 drivers/scsi/fnic/fnic_scsi.c |   16 ++++++++--------
 drivers/scsi/fnic/vnic_scsi.h |    4 ++--
 4 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index d276aaf..e4dd3d7 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -43,6 +43,8 @@
 #define DFX                     DRV_NAME "%d: "
 
 #define DESC_CLEAN_LOW_WATERMARK 8
+#define FNIC_UCSM_DFLT_THROTTLE_CNT_BLD	16 /* UCSM default throttle count */
+#define FNIC_MIN_IO_REQ			256 /* Min IO throttle count */
 #define FNIC_MAX_IO_REQ		2048 /* scsi_cmnd tag map entries */
 #define	FNIC_IO_LOCKS		64 /* IO locks: power of 2 */
 #define FNIC_DFLT_QUEUE_DEPTH	32
@@ -223,6 +225,7 @@ struct fnic {
 	char name[IFNAMSIZ];
 	struct timer_list notify_timer; /* used for MSI interrupts */
 
+	unsigned int fnic_max_tag_id;
 	unsigned int err_intr_offset;
 	unsigned int link_intr_offset;
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 835a9cd..bbf81ea 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -74,6 +74,10 @@ module_param(fnic_trace_max_pages, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(fnic_trace_max_pages, "Total allocated memory pages "
 					"for fnic trace buffer");
 
+static unsigned int fnic_max_qdepth = FNIC_DFLT_QUEUE_DEPTH;
+module_param(fnic_max_qdepth, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(fnic_max_qdepth, "Queue depth to report for each LUN");
+
 static struct libfc_function_template fnic_transport_template = {
 	.frame_send = fnic_send,
 	.lport_set_port_id = fnic_set_port_id,
@@ -91,7 +95,7 @@ static int fnic_slave_alloc(struct scsi_device *sdev)
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
-	scsi_activate_tcq(sdev, FNIC_DFLT_QUEUE_DEPTH);
+	scsi_activate_tcq(sdev, fnic_max_qdepth);
 	return 0;
 }
 
@@ -552,13 +556,6 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	host->transportt = fnic_fc_transport;
 
-	err = scsi_init_shared_tag_map(host, FNIC_MAX_IO_REQ);
-	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Unable to alloc shared tag map\n");
-		goto err_out_free_hba;
-	}
-
 	/* Setup PCI resources */
 	pci_set_drvdata(pdev, fnic);
 
@@ -671,6 +668,22 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			     "aborting.\n");
 		goto err_out_dev_close;
 	}
+
+	/* Configure Maximum Outstanding IO reqs*/
+	if (fnic->config.io_throttle_count != FNIC_UCSM_DFLT_THROTTLE_CNT_BLD) {
+		host->can_queue = min_t(u32, FNIC_MAX_IO_REQ,
+					max_t(u32, FNIC_MIN_IO_REQ,
+					fnic->config.io_throttle_count));
+	}
+	fnic->fnic_max_tag_id = host->can_queue;
+
+	err = scsi_init_shared_tag_map(host, fnic->fnic_max_tag_id);
+	if (err) {
+		shost_printk(KERN_ERR, fnic->lport->host,
+			  "Unable to alloc shared tag map\n");
+		goto err_out_dev_close;
+	}
+
 	host->max_lun = fnic->config.luns_per_tgt;
 	host->max_id = FNIC_MAX_FCP_TARGET;
 	host->max_cmd_len = FCOE_MAX_CMD_LEN;
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index b1d1921..fdb2b8b 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -736,7 +736,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	fcpio_tag_id_dec(&tag, &id);
 	icmnd_cmpl = &desc->u.icmnd_cmpl;
 
-	if (id >= FNIC_MAX_IO_REQ) {
+	if (id >= fnic->fnic_max_tag_id) {
 		shost_printk(KERN_ERR, fnic->lport->host,
 			"Tag out of range tag %x hdr status = %s\n",
 			     id, fnic_fcpio_status_to_str(hdr_status));
@@ -913,7 +913,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 	fcpio_header_dec(&desc->hdr, &type, &hdr_status, &tag);
 	fcpio_tag_id_dec(&tag, &id);
 
-	if ((id & FNIC_TAG_MASK) >= FNIC_MAX_IO_REQ) {
+	if ((id & FNIC_TAG_MASK) >= fnic->fnic_max_tag_id) {
 		shost_printk(KERN_ERR, fnic->lport->host,
 		"Tag out of range tag %x hdr status = %s\n",
 		id, fnic_fcpio_status_to_str(hdr_status));
@@ -1127,7 +1127,7 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 	spinlock_t *io_lock;
 	unsigned long start_time = 0;
 
-	for (i = 0; i < FNIC_MAX_IO_REQ; i++) {
+	for (i = 0; i < fnic->fnic_max_tag_id; i++) {
 		if (i == exclude_id)
 			continue;
 
@@ -1210,7 +1210,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 	fcpio_tag_id_dec(&desc->hdr.tag, &id);
 	id &= FNIC_TAG_MASK;
 
-	if (id >= FNIC_MAX_IO_REQ)
+	if (id >= fnic->fnic_max_tag_id)
 		return;
 
 	sc = scsi_host_find_tag(fnic->lport->host, id);
@@ -1314,7 +1314,7 @@ static void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 	if (fnic->in_remove)
 		return;
 
-	for (tag = 0; tag < FNIC_MAX_IO_REQ; tag++) {
+	for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
 		abt_tag = tag;
 		io_lock = fnic_io_lock_tag(fnic, tag);
 		spin_lock_irqsave(io_lock, flags);
@@ -1448,7 +1448,7 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 	if (fnic->in_remove)
 		return;
 
-	for (tag = 0; tag < FNIC_MAX_IO_REQ; tag++) {
+	for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
 		abt_tag = tag;
 		io_lock = fnic_io_lock_tag(fnic, tag);
 		spin_lock_irqsave(io_lock, flags);
@@ -1781,7 +1781,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 	enum fnic_ioreq_state old_ioreq_state;
 
-	for (tag = 0; tag < FNIC_MAX_IO_REQ; tag++) {
+	for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
 		io_lock = fnic_io_lock_tag(fnic, tag);
 		spin_lock_irqsave(io_lock, flags);
 		sc = scsi_host_find_tag(fnic->lport->host, tag);
@@ -2404,7 +2404,7 @@ int fnic_is_abts_pending(struct fnic *fnic, struct scsi_cmnd *lr_sc)
 		lun_dev = lr_sc->device;
 
 	/* walk again to check, if IOs are still pending in fw */
-	for (tag = 0; tag < FNIC_MAX_IO_REQ; tag++) {
+	for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
 		sc = scsi_host_find_tag(fnic->lport->host, tag);
 		/*
 		 * ignore this lun reset cmd or cmds that do not belong to
diff --git a/drivers/scsi/fnic/vnic_scsi.h b/drivers/scsi/fnic/vnic_scsi.h
index fbb5536..e343e1d 100644
--- a/drivers/scsi/fnic/vnic_scsi.h
+++ b/drivers/scsi/fnic/vnic_scsi.h
@@ -54,8 +54,8 @@
 #define VNIC_FNIC_PLOGI_TIMEOUT_MIN         1000
 #define VNIC_FNIC_PLOGI_TIMEOUT_MAX         255000
 
-#define VNIC_FNIC_IO_THROTTLE_COUNT_MIN     256
-#define VNIC_FNIC_IO_THROTTLE_COUNT_MAX     4096
+#define VNIC_FNIC_IO_THROTTLE_COUNT_MIN     1
+#define VNIC_FNIC_IO_THROTTLE_COUNT_MAX     2048
 
 #define VNIC_FNIC_LINK_DOWN_TIMEOUT_MIN     0
 #define VNIC_FNIC_LINK_DOWN_TIMEOUT_MAX     240000
-- 
1.7.10.4

