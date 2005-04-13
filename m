From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [2/5]  qla2xxx: add remote port codes...
Date: Wed, 13 Apr 2005 12:18:24 -0700
Message-ID: <20050413191824.GK9703@plap.qlogic.org>
References: <20050413191548.GI9703@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:45678 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261193AbVDMTSZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 15:18:25 -0400
Content-Disposition: inline
In-Reply-To: <20050413191548.GI9703@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

  Add initial support for FC remote port infrastructure.

     o Use fc_remote_port...() registration and block/unlock
       functions.
     o Consolidate 'attribute' (fc-remote/sysfs) helpers into
       new qla_attr.c file.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/Makefile   |    2 
 drivers/scsi/qla2xxx/qla_attr.c |  323 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    3 
 drivers/scsi/qla2xxx/qla_gbl.h  |   12 +
 drivers/scsi/qla2xxx/qla_init.c |   31 +++
 drivers/scsi/qla2xxx/qla_os.c   |  302 ++++---------------------------------
 6 files changed, 403 insertions(+), 270 deletions(-)

--- a/drivers/scsi/qla2xxx/Makefile	2005-04-12 15:56:53.000000000 -0700
+++ b/drivers/scsi/qla2xxx/Makefile	2005-04-13 08:41:21.000000000 -0700
@@ -1,7 +1,7 @@
 EXTRA_CFLAGS += -DUNIQUE_FW_NAME
 
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
-		qla_dbg.o qla_sup.o qla_rscn.o
+		qla_dbg.o qla_sup.o qla_rscn.o qla_attr.o
 
 qla2100-y := ql2100.o ql2100_fw.o
 qla2200-y := ql2200.o ql2200_fw.o
--- a/drivers/scsi/qla2xxx/qla_attr.c	1969-12-31 16:00:00.000000000 -0800
+++ b/drivers/scsi/qla2xxx/qla_attr.c	2005-04-13 08:41:21.000000000 -0700
@@ -0,0 +1,323 @@
+/*
+ *                  QLOGIC LINUX SOFTWARE
+ *
+ * QLogic ISP2x00 device driver for Linux 2.6.x
+ * Copyright (C) 2003-2005 QLogic Corporation
+ * (www.qlogic.com)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+#include "qla_def.h"
+
+#include <linux/version.h>
+#include <scsi/scsi_transport_fc.h>
+
+/* SYSFS attributes --------------------------------------------------------- */
+
+static ssize_t
+qla2x00_sysfs_read_fw_dump(struct kobject *kobj, char *buf, loff_t off,
+    size_t count)
+{
+	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+
+	if (ha->fw_dump_reading == 0)
+		return 0;
+	if (off > ha->fw_dump_buffer_len)
+		return 0;
+	if (off + count > ha->fw_dump_buffer_len)
+		count = ha->fw_dump_buffer_len - off;
+
+	memcpy(buf, &ha->fw_dump_buffer[off], count);
+
+	return (count);
+}
+
+static ssize_t
+qla2x00_sysfs_write_fw_dump(struct kobject *kobj, char *buf, loff_t off,
+    size_t count)
+{
+	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+	int reading;
+	uint32_t dump_size;
+
+	if (off != 0)
+		return (0);
+
+	reading = simple_strtol(buf, NULL, 10);
+	switch (reading) {
+	case 0:
+		if (ha->fw_dump_reading == 1) {
+			qla_printk(KERN_INFO, ha,
+			    "Firmware dump cleared on (%ld).\n",
+			    ha->host_no);
+
+			vfree(ha->fw_dump_buffer);
+			free_pages((unsigned long)ha->fw_dump,
+			    ha->fw_dump_order);
+
+			ha->fw_dump_reading = 0;
+			ha->fw_dump_buffer = NULL;
+			ha->fw_dump = NULL;
+		}
+		break;
+	case 1:
+		if (ha->fw_dump != NULL && !ha->fw_dump_reading) {
+			ha->fw_dump_reading = 1;
+
+			dump_size = FW_DUMP_SIZE_1M;
+			if (ha->fw_memory_size < 0x20000) 
+				dump_size = FW_DUMP_SIZE_128K;
+			else if (ha->fw_memory_size < 0x80000) 
+				dump_size = FW_DUMP_SIZE_512K;
+			ha->fw_dump_buffer = (char *)vmalloc(dump_size);
+			if (ha->fw_dump_buffer == NULL) {
+				qla_printk(KERN_WARNING, ha,
+				    "Unable to allocate memory for firmware "
+				    "dump buffer (%d).\n", dump_size);
+
+				ha->fw_dump_reading = 0;
+				return (count);
+			}
+			qla_printk(KERN_INFO, ha,
+			    "Firmware dump ready for read on (%ld).\n",
+			    ha->host_no);
+			memset(ha->fw_dump_buffer, 0, dump_size);
+			if (IS_QLA2100(ha) || IS_QLA2200(ha))
+ 				qla2100_ascii_fw_dump(ha);
+ 			else
+ 				qla2300_ascii_fw_dump(ha);
+			ha->fw_dump_buffer_len = strlen(ha->fw_dump_buffer);
+		}
+		break;
+	}
+	return (count);
+}
+
+static struct bin_attribute sysfs_fw_dump_attr = {
+	.attr = {
+		.name = "fw_dump",
+		.mode = S_IRUSR | S_IWUSR,
+		.owner = THIS_MODULE,
+	},
+	.size = 0,
+	.read = qla2x00_sysfs_read_fw_dump,
+	.write = qla2x00_sysfs_write_fw_dump,
+};
+
+static ssize_t
+qla2x00_sysfs_read_nvram(struct kobject *kobj, char *buf, loff_t off,
+    size_t count)
+{
+	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+	uint16_t	*witer;
+	unsigned long	flags;
+	uint16_t	cnt;
+
+	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != sizeof(nvram_t))
+		return 0;
+
+	/* Read NVRAM. */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	qla2x00_lock_nvram_access(ha);
+ 	witer = (uint16_t *)buf;
+ 	for (cnt = 0; cnt < count / 2; cnt++) {
+		*witer = cpu_to_le16(qla2x00_get_nvram_word(ha,
+		    cnt+ha->nvram_base));
+		witer++;
+ 	}
+	qla2x00_unlock_nvram_access(ha);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return (count);
+}
+
+static ssize_t
+qla2x00_sysfs_write_nvram(struct kobject *kobj, char *buf, loff_t off,
+    size_t count)
+{
+	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+	uint8_t		*iter;
+	uint16_t	*witer;
+	unsigned long	flags;
+	uint16_t	cnt;
+	uint8_t		chksum;
+
+	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != sizeof(nvram_t))
+		return 0;
+
+	/* Checksum NVRAM. */
+	iter = (uint8_t *)buf;
+	chksum = 0;
+	for (cnt = 0; cnt < count - 1; cnt++)
+		chksum += *iter++;
+	chksum = ~chksum + 1;
+	*iter = chksum;
+
+	/* Write NVRAM. */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	qla2x00_lock_nvram_access(ha);
+	qla2x00_release_nvram_protection(ha);
+ 	witer = (uint16_t *)buf;
+	for (cnt = 0; cnt < count / 2; cnt++) {
+		qla2x00_write_nvram_word(ha, cnt+ha->nvram_base,
+		    cpu_to_le16(*witer));
+		witer++;
+	}
+	qla2x00_unlock_nvram_access(ha);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return (count);
+}
+
+static struct bin_attribute sysfs_nvram_attr = {
+	.attr = {
+		.name = "nvram",
+		.mode = S_IRUSR | S_IWUSR,
+		.owner = THIS_MODULE,
+	},
+	.size = sizeof(nvram_t),
+	.read = qla2x00_sysfs_read_nvram,
+	.write = qla2x00_sysfs_write_nvram,
+};
+
+void
+qla2x00_alloc_sysfs_attr(scsi_qla_host_t *ha)
+{
+	struct Scsi_Host *host = ha->host;
+
+	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_fw_dump_attr);
+	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_nvram_attr);
+}
+
+void
+qla2x00_free_sysfs_attr(scsi_qla_host_t *ha)
+{
+	struct Scsi_Host *host = ha->host;
+
+	sysfs_remove_bin_file(&host->shost_gendev.kobj, &sysfs_fw_dump_attr);
+	sysfs_remove_bin_file(&host->shost_gendev.kobj, &sysfs_nvram_attr);
+}
+
+/* Host attributes. */
+
+static void
+qla2x00_get_host_port_id(struct Scsi_Host *shost)
+{
+	scsi_qla_host_t *ha = to_qla_host(shost);
+
+	fc_host_port_id(shost) = ha->d_id.b.domain << 16 |
+	    ha->d_id.b.area << 8 | ha->d_id.b.al_pa;
+}
+
+static void
+qla2x00_get_starget_node_name(struct scsi_target *starget)
+{
+	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
+	scsi_qla_host_t *ha = to_qla_host(host);
+        os_tgt_t *tq = (os_tgt_t *) TGT_Q(ha, starget->id);
+	uint64_t node_name = 0;
+
+	if (tq->fcport)
+		node_name = be64_to_cpu(*(uint64_t *)tq->fcport->node_name);
+	fc_starget_node_name(starget) = node_name;
+}
+
+static void
+qla2x00_get_starget_port_name(struct scsi_target *starget)
+{
+	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
+	scsi_qla_host_t *ha = to_qla_host(host);
+        os_tgt_t *tq = (os_tgt_t *) TGT_Q(ha, starget->id);
+	uint64_t port_name = 0;
+
+	if (tq->fcport)
+		port_name = be64_to_cpu(*(uint64_t *)tq->fcport->port_name);
+	fc_starget_port_name(starget) = port_name;
+}
+
+static void
+qla2x00_get_starget_port_id(struct scsi_target *starget)
+{
+	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
+	scsi_qla_host_t *ha = to_qla_host(host);
+        os_tgt_t *tq = (os_tgt_t *) TGT_Q(ha, starget->id);
+	uint32_t port_id = 0;
+
+	if (tq->fcport)
+		port_id = tq->fcport->d_id.b.domain << 16 |
+		    tq->fcport->d_id.b.area << 8 | tq->fcport->d_id.b.al_pa;
+	fc_starget_port_id(starget) = port_id;
+}
+
+static void
+qla2x00_get_rport_loss_tmo(struct fc_rport *rport)
+{
+	os_tgt_t *tq = rport->dd_data;
+	scsi_qla_host_t *ha = tq->ha;
+
+	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
+}
+
+static void
+qla2x00_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
+{
+	os_tgt_t *tq = rport->dd_data;
+	scsi_qla_host_t *ha = tq->ha;
+
+	if (timeout)
+		ha->port_down_retry_count = timeout;
+	else
+		ha->port_down_retry_count = 1;
+
+	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
+}
+
+static struct fc_function_template qla2xxx_transport_functions = {
+
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.get_host_port_id = qla2x00_get_host_port_id,
+	.show_host_port_id = 1,
+
+	.dd_fcrport_size = sizeof(os_tgt_t *),
+
+	.get_starget_node_name = qla2x00_get_starget_node_name,
+	.show_starget_node_name = 1,
+	.get_starget_port_name = qla2x00_get_starget_port_name,
+	.show_starget_port_name = 1,
+	.get_starget_port_id  = qla2x00_get_starget_port_id,
+	.show_starget_port_id = 1,
+
+	.get_rport_dev_loss_tmo = qla2x00_get_rport_loss_tmo,
+	.set_rport_dev_loss_tmo = qla2x00_set_rport_loss_tmo,
+	.show_rport_dev_loss_tmo = 1,
+
+};
+
+struct scsi_transport_template *
+qla2x00_alloc_transport_tmpl(void)
+{
+	return (fc_attach_transport(&qla2xxx_transport_functions));
+}
+
+void
+qla2x00_init_host_attr(scsi_qla_host_t *ha)
+{
+	fc_host_node_name(ha->host) =
+	    be64_to_cpu(*(uint64_t *)ha->init_cb->node_name);
+	fc_host_port_name(ha->host) =
+	    be64_to_cpu(*(uint64_t *)ha->init_cb->port_name);
+}
--- a/drivers/scsi/qla2xxx/qla_def.h	2005-04-13 08:38:23.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_def.h	2005-04-13 08:41:21.000000000 -0700
@@ -219,7 +219,7 @@
 /*
  * Timeout timer counts in seconds
  */
-#define PORT_RETRY_TIME			2
+#define PORT_RETRY_TIME			1
 #define LOOP_DOWN_TIMEOUT		60
 #define LOOP_DOWN_TIME			255	/* 240 */
 #define	LOOP_DOWN_RESET			(LOOP_DOWN_TIME - 30)
@@ -1718,6 +1718,7 @@ typedef struct fc_port {
     	uint8_t cur_path;		/* current path id */
 
 	lun_bit_mask_t lun_mask;
+	struct fc_rport *rport;
 } fc_port_t;
 
 /*
--- a/drivers/scsi/qla2xxx/qla_gbl.h	2005-04-13 08:38:23.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	2005-04-13 08:42:33.000000000 -0700
@@ -24,6 +24,7 @@
 #define	__QLA_GBL_H
 
 #include <linux/interrupt.h>
+#include <scsi/scsi_transport.h>
 
 extern void qla2x00_remove_one(struct pci_dev *);
 extern int qla2x00_probe_one(struct pci_dev *, struct qla_board_info *);
@@ -48,6 +49,8 @@ extern void qla2x00_tgt_free(scsi_qla_ho
 
 extern int qla2x00_abort_isp(scsi_qla_host_t *);
 
+extern void qla2x00_reg_remote_port(scsi_qla_host_t *, fc_port_t *);
+
 /*
  * Global Data in qla_os.c source file.
  */
@@ -250,4 +253,13 @@ extern void qla2x00_cancel_io_descriptor
 #define qla2x00_alloc_ioctl_mem(ha)		(0)
 #define qla2x00_free_ioctl_mem(ha)		do { } while (0)
 
+/*
+ * Global Function Prototypes in qla_attr.c source file.
+ */
+extern void qla2x00_alloc_sysfs_attr(scsi_qla_host_t *);
+extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
+extern struct scsi_transport_template *qla2x00_alloc_transport_tmpl(void);
+extern void qla2x00_init_host_attr(scsi_qla_host_t *);
+extern void qla2x00_alloc_sysfs_attr(scsi_qla_host_t *);
+extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
 #endif /* _QLA_GBL_H */
--- a/drivers/scsi/qla2xxx/qla_init.c	2005-04-13 08:38:23.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_init.c	2005-04-13 08:43:25.000000000 -0700
@@ -19,6 +19,7 @@
 #include "qla_def.h"
 
 #include <linux/delay.h>
+#include <scsi/scsi_transport_fc.h>
 
 #include "qla_devtbl.h"
 
@@ -1927,8 +1928,35 @@ qla2x00_update_fcport(scsi_qla_host_t *h
 		qla2x00_lun_discovery(ha, fcport);
 	}
 	atomic_set(&fcport->state, FCS_ONLINE);
+	if (ha->flags.init_done)
+		qla2x00_reg_remote_port(ha, fcport);
 }
 
+void
+qla2x00_reg_remote_port(scsi_qla_host_t *ha, fc_port_t *fcport)
+{
+	struct fc_rport_identifiers rport_ids;
+
+	if (fcport->rport) {
+		fc_remote_port_unblock(fcport->rport);
+		return;
+	}
+
+	rport_ids.node_name = be64_to_cpu(*(uint64_t *)fcport->node_name);
+	rport_ids.port_name = be64_to_cpu(*(uint64_t *)fcport->port_name);
+	rport_ids.port_id = fcport->d_id.b.domain << 16 |
+	    fcport->d_id.b.area << 8 | fcport->d_id.b.al_pa;
+	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
+	if (fcport->port_type == FCT_INITIATOR)
+		rport_ids.roles |= FC_RPORT_ROLE_FCP_INITIATOR;
+	if (fcport->port_type == FCT_TARGET)
+		rport_ids.roles |= FC_RPORT_ROLE_FCP_TARGET;
+
+	fcport->rport = fc_remote_port_add(ha->host, 0, &rport_ids);
+	if (!fcport->rport)
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to allocate fc remote port!\n");
+}
 /*
  * qla2x00_lun_discovery
  *	Issue SCSI inquiry command for LUN discovery.
@@ -2895,8 +2923,7 @@ qla2x00_device_resync(scsi_qla_host_t *h
 			if (atomic_read(&fcport->state) == FCS_ONLINE) {
 				if (format != 3 ||
 				    fcport->port_type != FCT_INITIATOR) {
-					atomic_set(&fcport->state,
-					    FCS_DEVICE_LOST);
+					qla2x00_mark_device_lost(ha, fcport, 0);
 				}
 			}
 			fcport->flags &= ~FCF_FARP_DONE;
--- a/drivers/scsi/qla2xxx/qla_os.c	2005-04-13 08:38:23.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_os.c	2005-04-13 08:44:32.000000000 -0700
@@ -63,7 +63,7 @@ module_param(ql2xlogintimeout, int, S_IR
 MODULE_PARM_DESC(ql2xlogintimeout,
 		"Login timeout value in seconds.");
 
-int qlport_down_retry;
+int qlport_down_retry = 30;
 module_param(qlport_down_retry, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(qlport_down_retry,
 		"Maximum number of command retries to a port that returns"
@@ -246,184 +246,8 @@ static srb_t *qla2x00_get_new_sp(scsi_ql
 static void qla2x00_sp_free_dma(scsi_qla_host_t *, srb_t *);
 void qla2x00_sp_compl(scsi_qla_host_t *ha, srb_t *);
 
-static ssize_t qla2x00_sysfs_read_fw_dump(struct kobject *, char *, loff_t,
-    size_t);
-static ssize_t qla2x00_sysfs_write_fw_dump(struct kobject *, char *, loff_t,
-    size_t);
-static struct bin_attribute sysfs_fw_dump_attr = {
-	.attr = {
-		.name = "fw_dump",
-		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
-	},
-	.size = 0,
-	.read = qla2x00_sysfs_read_fw_dump,
-	.write = qla2x00_sysfs_write_fw_dump,
-};
-static ssize_t qla2x00_sysfs_read_nvram(struct kobject *, char *, loff_t,
-    size_t);
-static ssize_t qla2x00_sysfs_write_nvram(struct kobject *, char *, loff_t,
-    size_t);
-static struct bin_attribute sysfs_nvram_attr = {
-	.attr = {
-		.name = "nvram",
-		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
-	},
-	.size = sizeof(nvram_t),
-	.read = qla2x00_sysfs_read_nvram,
-	.write = qla2x00_sysfs_write_nvram,
-};
-
 /* -------------------------------------------------------------------------- */
 
-
-/* SysFS attributes. */
-static ssize_t qla2x00_sysfs_read_fw_dump(struct kobject *kobj, char *buf,
-    loff_t off, size_t count)
-{
-	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
-
-	if (ha->fw_dump_reading == 0)
-		return 0;
-	if (off > ha->fw_dump_buffer_len)
-		return 0;
-	if (off + count > ha->fw_dump_buffer_len)
-		count = ha->fw_dump_buffer_len - off;
-
-	memcpy(buf, &ha->fw_dump_buffer[off], count);
-
-	return (count);
-}
-
-static ssize_t qla2x00_sysfs_write_fw_dump(struct kobject *kobj, char *buf,
-    loff_t off, size_t count)
-{
-	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
-	int reading;
-	uint32_t dump_size;
-
-	if (off != 0)
-		return (0);
-
-	reading = simple_strtol(buf, NULL, 10);
-	switch (reading) {
-	case 0:
-		if (ha->fw_dump_reading == 1) {
-			qla_printk(KERN_INFO, ha,
-			    "Firmware dump cleared on (%ld).\n",
-			    ha->host_no);
-
-			vfree(ha->fw_dump_buffer);
-			free_pages((unsigned long)ha->fw_dump,
-			    ha->fw_dump_order);
-
-			ha->fw_dump_reading = 0;
-			ha->fw_dump_buffer = NULL;
-			ha->fw_dump = NULL;
-		}
-		break;
-	case 1:
-		if (ha->fw_dump != NULL && !ha->fw_dump_reading) {
-			ha->fw_dump_reading = 1;
-
-			dump_size = FW_DUMP_SIZE_1M;
-			if (ha->fw_memory_size < 0x20000) 
-				dump_size = FW_DUMP_SIZE_128K;
-			else if (ha->fw_memory_size < 0x80000) 
-				dump_size = FW_DUMP_SIZE_512K;
-			ha->fw_dump_buffer = (char *)vmalloc(dump_size);
-			if (ha->fw_dump_buffer == NULL) {
-				qla_printk(KERN_WARNING, ha,
-				    "Unable to allocate memory for firmware "
-				    "dump buffer (%d).\n", dump_size);
-
-				ha->fw_dump_reading = 0;
-				return (count);
-			}
-			qla_printk(KERN_INFO, ha,
-			    "Firmware dump ready for read on (%ld).\n",
-			    ha->host_no);
-			memset(ha->fw_dump_buffer, 0, dump_size);
-			if (IS_QLA2100(ha) || IS_QLA2200(ha))
- 				qla2100_ascii_fw_dump(ha);
- 			else
- 				qla2300_ascii_fw_dump(ha);
-			ha->fw_dump_buffer_len = strlen(ha->fw_dump_buffer);
-		}
-		break;
-	}
-	return (count);
-}
-
-static ssize_t qla2x00_sysfs_read_nvram(struct kobject *kobj, char *buf,
-    loff_t off, size_t count)
-{
-	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
-	uint16_t	*witer;
-	unsigned long	flags;
-	uint16_t	cnt;
-
-	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != sizeof(nvram_t))
-		return 0;
-
-	/* Read NVRAM. */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	qla2x00_lock_nvram_access(ha);
- 	witer = (uint16_t *)buf;
- 	for (cnt = 0; cnt < count / 2; cnt++) {
-		*witer = cpu_to_le16(qla2x00_get_nvram_word(ha,
-		    cnt+ha->nvram_base));
-		witer++;
- 	}
-	qla2x00_unlock_nvram_access(ha);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	return (count);
-}
-
-static ssize_t qla2x00_sysfs_write_nvram(struct kobject *kobj, char *buf,
-    loff_t off, size_t count)
-{
-	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
-	uint8_t		*iter;
-	uint16_t	*witer;
-	unsigned long	flags;
-	uint16_t	cnt;
-	uint8_t		chksum;
-
-	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != sizeof(nvram_t))
-		return 0;
-
-	/* Checksum NVRAM. */
-	iter = (uint8_t *)buf;
-	chksum = 0;
-	for (cnt = 0; cnt < count - 1; cnt++)
-		chksum += *iter++;
-	chksum = ~chksum + 1;
-	*iter = chksum;
-
-	/* Write NVRAM. */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	qla2x00_lock_nvram_access(ha);
-	qla2x00_release_nvram_protection(ha);
- 	witer = (uint16_t *)buf;
-	for (cnt = 0; cnt < count / 2; cnt++) {
-		qla2x00_write_nvram_word(ha, cnt+ha->nvram_base,
-		    cpu_to_le16(*witer));
-		witer++;
-	}
-	qla2x00_unlock_nvram_access(ha);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	return (count);
-}
-
-/* -------------------------------------------------------------------------- */
 static char *
 qla2x00_get_pci_info_str(struct scsi_qla_host *ha, char *str)
 {
@@ -1233,11 +1057,16 @@ qla2xxx_slave_alloc(struct scsi_device *
 static int
 qla2xxx_slave_configure(struct scsi_device *sdev)
 {
+	scsi_qla_host_t *ha = to_qla_host(sdev->host);
+	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
+
 	if (sdev->tagged_supported)
 		scsi_activate_tcq(sdev, 32);
 	else
 		scsi_deactivate_tcq(sdev, 32);
 
+	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
+
 	return 0;
 }
 
@@ -1370,6 +1199,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 	unsigned long	wait_switch = 0;
 	char pci_info[20];
 	char fw_str[30];
+	fc_port_t *fcport;
 
 	if (pci_enable_device(pdev))
 		return -1;
@@ -1395,7 +1225,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 	/* Configure PCI I/O space */
 	ret = qla2x00_iospace_config(ha);
 	if (ret != 0) {
-		goto probe_failed;
+		goto probe_alloc_failed;
 	}
 
 	/* Sanitize the information from PCI BIOS. */
@@ -1469,9 +1299,23 @@ int qla2x00_probe_one(struct pci_dev *pd
 		qla_printk(KERN_WARNING, ha,
 		    "[ERROR] Failed to allocate memory for adapter\n");
 
-		goto probe_failed;
+		goto probe_alloc_failed;
 	}
 
+	pci_set_drvdata(pdev, ha);
+	host->this_id = 255;
+	host->cmd_per_lun = 3;
+	host->unique_id = ha->instance;
+	host->max_cmd_len = MAX_CMDSZ;
+	host->max_channel = ha->ports - 1;
+	host->max_id = ha->max_targets;
+	host->max_lun = ha->max_luns;
+	host->transportt = qla2xxx_transport_template;
+	if (scsi_add_host(host, &pdev->dev))
+		goto probe_alloc_failed;
+
+	qla2x00_alloc_sysfs_attr(ha);
+
 	if (qla2x00_initialize_adapter(ha) &&
 	    !(ha->device_flags & DFLG_NO_CABLE)) {
 
@@ -1485,6 +1329,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 		goto probe_failed;
 	}
 
+	qla2x00_init_host_attr(ha);
 	/*
 	 * Startup the kernel thread for this host adapter
 	 */
@@ -1498,16 +1343,6 @@ int qla2x00_probe_one(struct pci_dev *pd
 	}
 	wait_for_completion(&ha->dpc_inited);
 
-	host->this_id = 255;
-	host->cmd_per_lun = 3;
-	host->max_cmd_len = MAX_CMDSZ;
-	host->max_channel = ha->ports - 1;
-	host->max_lun = ha->max_luns;
-	BUG_ON(qla2xxx_transport_template == NULL);
-	host->transportt = qla2xxx_transport_template;
-	host->unique_id = ha->instance;
-	host->max_id = ha->max_targets;
-
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		ret = request_irq(host->irq, qla2100_intr_handler,
 		    SA_INTERRUPT|SA_SHIRQ, ha->brd_info->drv_name, ha);
@@ -1568,7 +1403,6 @@ int qla2x00_probe_one(struct pci_dev *pd
 		msleep(10);
 	}
 
-	pci_set_drvdata(pdev, ha);
 	ha->flags.init_done = 1;
 	num_hosts++;
 
@@ -1577,12 +1411,6 @@ int qla2x00_probe_one(struct pci_dev *pd
 		qla2x00_display_fc_names(ha);
 	}
 
-	if (scsi_add_host(host, &pdev->dev))
-		goto probe_failed;
-
-	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_fw_dump_attr);
-	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_nvram_attr);
-
 	qla_printk(KERN_INFO, ha, "\n"
 	    " QLogic Fibre Channel HBA Driver: %s\n"
 	    "  QLogic %s - %s\n"
@@ -1592,12 +1420,16 @@ int qla2x00_probe_one(struct pci_dev *pd
 	    pci_name(ha->pdev), ha->flags.enable_64bit_addressing ? '+': '-',
 	    ha->host_no, qla2x00_get_fw_version_str(ha, fw_str));
 
-	if (ql2xdoinitscan)
-		scsi_scan_host(host);
+	/* Go with fc_rport registration. */
+	list_for_each_entry(fcport, &ha->fcports, list)
+		qla2x00_reg_remote_port(ha, fcport);
 
 	return 0;
 
 probe_failed:
+	scsi_remove_host(host);
+
+probe_alloc_failed:
 	qla2x00_free_device(ha);
 
 	scsi_host_put(host);
@@ -1615,9 +1447,7 @@ void qla2x00_remove_one(struct pci_dev *
 
 	ha = pci_get_drvdata(pdev);
 
-	sysfs_remove_bin_file(&ha->host->shost_gendev.kobj,
-	    &sysfs_fw_dump_attr);
-	sysfs_remove_bin_file(&ha->host->shost_gendev.kobj, &sysfs_nvram_attr);
+	qla2x00_free_sysfs_attr(ha);
 
 	scsi_remove_host(ha->host);
 
@@ -2090,6 +1920,8 @@ qla2x00_display_fc_names(scsi_qla_host_t
 void qla2x00_mark_device_lost(scsi_qla_host_t *ha, fc_port_t *fcport,
     int do_login)
 {
+	if (atomic_read(&fcport->state) == FCS_ONLINE && fcport->rport)
+		fc_remote_port_block(fcport->rport);
 	/* 
 	 * We may need to retry the login, so don't change the state of the
 	 * port but do the retries.
@@ -2149,7 +1981,8 @@ qla2x00_mark_all_devices_lost(scsi_qla_h
 		 */
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
 			continue;
-
+		if (atomic_read(&fcport->state) == FCS_ONLINE && fcport->rport)
+			fc_remote_port_block(fcport->rport);
 		atomic_set(&fcport->state, FCS_DEVICE_LOST);
 	}
 }
@@ -2815,7 +2648,6 @@ qla2x00_sp_compl(scsi_qla_host_t *ha, sr
 
 	cmd->scsi_done(cmd);
 }
-
 /**************************************************************************
 *   qla2x00_timer
 *
@@ -2953,67 +2785,6 @@ qla2x00_down_timeout(struct semaphore *s
 	return -ETIMEDOUT;
 }
 
-static void
-qla2xxx_get_port_id(struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	scsi_qla_host_t *ha = to_qla_host(shost);
-	struct fc_port *fc;
-
-	list_for_each_entry(fc, &ha->fcports, list) {
-		if (fc->os_target_id == starget->id) {
-			fc_starget_port_id(starget) = fc->d_id.b.domain << 16 |
-				fc->d_id.b.area << 8 | 
-				fc->d_id.b.al_pa;
-			return;
-		}
-	}
-	fc_starget_port_id(starget) = -1;
-}
-
-static void
-qla2xxx_get_port_name(struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	scsi_qla_host_t *ha = to_qla_host(shost);
-	struct fc_port *fc;
-
-	list_for_each_entry(fc, &ha->fcports, list) {
-		if (fc->os_target_id == starget->id) {
-			fc_starget_port_name(starget) =
-				__be64_to_cpu(*(uint64_t *)fc->port_name);
-			return;
-		}
-	}
-	fc_starget_port_name(starget) = -1;
-}
-
-static void
-qla2xxx_get_node_name(struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	scsi_qla_host_t *ha = to_qla_host(shost);
-	struct fc_port *fc;
-
-	list_for_each_entry(fc, &ha->fcports, list) {
-		if (fc->os_target_id == starget->id) {
-			fc_starget_node_name(starget) =
-				__be64_to_cpu(*(uint64_t *)fc->node_name);
-			return;
-		}
-	}
-	fc_starget_node_name(starget) = -1;
-}
-
-static struct fc_function_template qla2xxx_transport_functions = {
-	.get_starget_port_id = qla2xxx_get_port_id,
-	.show_starget_port_id = 1,
-	.get_starget_port_name = qla2xxx_get_port_name,
-	.show_starget_port_name = 1,
-	.get_starget_node_name = qla2xxx_get_node_name,
-	.show_starget_node_name = 1,
-};
-
 /**
  * qla2x00_module_init - Module initialization.
  **/
@@ -3035,8 +2806,7 @@ qla2x00_module_init(void)
 #if DEBUG_QLA2100
 	strcat(qla2x00_version_str, "-debug");
 #endif
-
-	qla2xxx_transport_template = fc_attach_transport(&qla2xxx_transport_functions);
+	qla2xxx_transport_template = qla2x00_alloc_transport_tmpl();
 	if (!qla2xxx_transport_template)
 		return -ENODEV;
 
-- 
Andrew Vasquez
