From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/2] Add asynchronous scsi scanning support.
Date: Wed, 22 Nov 2006 08:24:48 -0800
Message-ID: <20061122162448.GE1538@andrew-vasquezs-computer.local>
References: <20061113152605.GZ16952@parisc-linux.org> <20061120192140.GE11420@andrew-vasquezs-computer.local> <20061120201143.GN18567@parisc-linux.org> <20061122161926.GC1538@andrew-vasquezs-computer.local> <20061122162219.GD1538@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:25518 "EHLO
	avexch1.qlogic.com") by vger.kernel.org with ESMTP id S1755331AbWKVQYu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Nov 2006 11:24:50 -0500
Content-Disposition: inline
In-Reply-To: <20061122162219.GD1538@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, james.smart@emulex.com

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 47868b0..636e494 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -95,6 +95,8 @@ MODULE_PARM_DESC(ql2xqfullrampup,
  */
 static int qla2xxx_slave_configure(struct scsi_device * device);
 static int qla2xxx_slave_alloc(struct scsi_device *);
+static int qla2xxx_scan_finished(struct Scsi_Host *, unsigned long time);
+static void qla2xxx_scan_start(struct Scsi_Host *);
 static void qla2xxx_slave_destroy(struct scsi_device *);
 static int qla2x00_queuecommand(struct scsi_cmnd *cmd,
 		void (*fn)(struct scsi_cmnd *));
@@ -124,6 +126,8 @@ static struct scsi_host_template qla2x00
 
 	.slave_alloc		= qla2xxx_slave_alloc,
 	.slave_destroy		= qla2xxx_slave_destroy,
+	.scan_finished		= qla2xxx_scan_finished,
+	.scan_start		= qla2xxx_scan_start,
 	.change_queue_depth	= qla2x00_change_queue_depth,
 	.change_queue_type	= qla2x00_change_queue_type,
 	.this_id		= -1,
@@ -1366,6 +1370,29 @@ qla24xx_disable_intrs(scsi_qla_host_t *h
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
+static void
+qla2xxx_scan_start(struct Scsi_Host *shost)
+{
+	scsi_qla_host_t *ha = (scsi_qla_host_t *)shost->hostdata;
+
+	set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
+	set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
+	set_bit(RSCN_UPDATE, &ha->dpc_flags);
+}
+
+static int
+qla2xxx_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	scsi_qla_host_t *ha = (scsi_qla_host_t *)shost->hostdata;
+
+	if (!ha->host)
+		return 1;
+	if (time > ha->loop_reset_delay * HZ)
+		return 1;
+
+	return atomic_read(&ha->loop_state) == LOOP_READY;
+}
+
 /*
  * PCI driver interface
  */
@@ -1631,10 +1658,6 @@ qla2x00_probe_one(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, ha);
 
-	/* Start link scan. */
-	set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
-	set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
-	set_bit(RSCN_UPDATE, &ha->dpc_flags);
 	ha->flags.init_done = 1;
 	ha->flags.online = 1;
 
@@ -1644,6 +1667,8 @@ qla2x00_probe_one(struct pci_dev *pdev,
 	if (ret)
 		goto probe_failed;
 
+	scsi_scan_host(host);
+
 	qla2x00_alloc_sysfs_attr(ha);
 
 	qla2x00_init_host_attr(ha);
