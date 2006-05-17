From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 13/15] qla2xxx: Consolidate firmware-dump handling across ISPs.
Date: Wed, 17 May 2006 15:09:50 -0700
Message-ID: <11479037852454-git-send-email-andrew.vasquez@qlogic.com>
References: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:40123 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1751227AbWEQWJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:09:52 -0400
In-Reply-To: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Simplify and centralise buffer allocation/deallocation, as
there's no point in having two memory request methods.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

e8b7ef5e7732611f4a9750baa3add3b98e6dface
 drivers/scsi/qla2xxx/qla_attr.c |   12 ++-------
 drivers/scsi/qla2xxx/qla_dbg.c  |   53 +++++++++++++++------------------------
 drivers/scsi/qla2xxx/qla_def.h  |    6 +---
 drivers/scsi/qla2xxx/qla_init.c |   27 +++++++++++++-------
 drivers/scsi/qla2xxx/qla_os.c   |    7 +----
 5 files changed, 43 insertions(+), 62 deletions(-)

e8b7ef5e7732611f4a9750baa3add3b98e6dface
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index fee0c49..e96d58d 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -46,22 +46,16 @@ qla2x00_sysfs_write_fw_dump(struct kobje
 	case 0:
 		if (ha->fw_dump_reading == 1) {
 			qla_printk(KERN_INFO, ha,
-			    "Firmware dump cleared on (%ld).\n",
-			    ha->host_no);
+			    "Firmware dump cleared on (%ld).\n", ha->host_no);
 
 			vfree(ha->fw_dump_buffer);
-			if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
-				free_pages((unsigned long)ha->fw_dump,
-				    ha->fw_dump_order);
-
-			ha->fw_dump_reading = 0;
 			ha->fw_dump_buffer = NULL;
-			ha->fw_dump = NULL;
+			ha->fw_dump_reading = 0;
 			ha->fw_dumped = 0;
 		}
 		break;
 	case 1:
-		if ((ha->fw_dump || ha->fw_dumped) && !ha->fw_dump_reading) {
+		if (ha->fw_dumped && !ha->fw_dump_reading) {
 			ha->fw_dump_reading = 1;
 
 			if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index e8120fb..74e5471 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -28,7 +28,7 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int
 	uint16_t __iomem *dmp_reg;
 	unsigned long	flags;
 	struct qla2300_fw_dump	*fw;
-	uint32_t	dump_size, data_ram_cnt;
+	uint32_t	data_ram_cnt;
 
 	risc_address = data_ram_cnt = 0;
 	mb0 = mb2 = 0;
@@ -37,23 +37,16 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int
 	if (!hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	if (ha->fw_dump != NULL) {
+	if (!ha->fw_dump) {
 		qla_printk(KERN_WARNING, ha,
-		    "Firmware has been previously dumped (%p) -- ignoring "
-		    "request...\n", ha->fw_dump);
+		    "No buffer available for dump!!!\n");
 		goto qla2300_fw_dump_failed;
 	}
 
-	/* Allocate (large) dump buffer. */
-	dump_size = sizeof(struct qla2300_fw_dump);
-	dump_size += (ha->fw_memory_size - 0x11000) * sizeof(uint16_t);
-	ha->fw_dump_order = get_order(dump_size);
-	ha->fw_dump = (struct qla2300_fw_dump *) __get_free_pages(GFP_ATOMIC,
-	    ha->fw_dump_order);
-	if (ha->fw_dump == NULL) {
+	if (ha->fw_dumped) {
 		qla_printk(KERN_WARNING, ha,
-		    "Unable to allocated memory for firmware dump (%d/%d).\n",
-		    ha->fw_dump_order, dump_size);
+		    "Firmware has been previously dumped (%p) -- ignoring "
+		    "request...\n", ha->fw_dump);
 		goto qla2300_fw_dump_failed;
 	}
 	fw = ha->fw_dump;
@@ -358,17 +351,16 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int
 		}
 	}
 
-
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to dump firmware (%x)!!!\n", rval);
+		ha->fw_dumped = 0;
 
-		free_pages((unsigned long)ha->fw_dump, ha->fw_dump_order);
-		ha->fw_dump = NULL;
 	} else {
 		qla_printk(KERN_INFO, ha,
 		    "Firmware dump saved to temp buffer (%ld/%p).\n",
 		    ha->host_no, ha->fw_dump);
+		ha->fw_dumped = 1;
 	}
 
 qla2300_fw_dump_failed:
@@ -587,21 +579,16 @@ qla2100_fw_dump(scsi_qla_host_t *ha, int
 	if (!hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	if (ha->fw_dump != NULL) {
+	if (!ha->fw_dump) {
 		qla_printk(KERN_WARNING, ha,
-		    "Firmware has been previously dumped (%p) -- ignoring "
-		    "request...\n", ha->fw_dump);
+		    "No buffer available for dump!!!\n");
 		goto qla2100_fw_dump_failed;
 	}
 
-	/* Allocate (large) dump buffer. */
-	ha->fw_dump_order = get_order(sizeof(struct qla2100_fw_dump));
-	ha->fw_dump = (struct qla2100_fw_dump *) __get_free_pages(GFP_ATOMIC,
-	    ha->fw_dump_order);
-	if (ha->fw_dump == NULL) {
+	if (ha->fw_dumped) {
 		qla_printk(KERN_WARNING, ha,
-		    "Unable to allocated memory for firmware dump (%d/%Zd).\n",
-		    ha->fw_dump_order, sizeof(struct qla2100_fw_dump));
+		    "Firmware has been previously dumped (%p) -- ignoring "
+		    "request...\n", ha->fw_dump);
 		goto qla2100_fw_dump_failed;
 	}
 	fw = ha->fw_dump;
@@ -777,13 +764,13 @@ qla2100_fw_dump(scsi_qla_host_t *ha, int
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to dump firmware (%x)!!!\n", rval);
+		ha->fw_dumped = 0;
 
-		free_pages((unsigned long)ha->fw_dump, ha->fw_dump_order);
-		ha->fw_dump = NULL;
 	} else {
 		qla_printk(KERN_INFO, ha,
 		    "Firmware dump saved to temp buffer (%ld/%p).\n",
 		    ha->host_no, ha->fw_dump);
+		ha->fw_dumped = 1;
 	}
 
 qla2100_fw_dump_failed:
@@ -988,7 +975,7 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 	if (!hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	if (!ha->fw_dump24) {
+	if (!ha->fw_dump) {
 		qla_printk(KERN_WARNING, ha,
 		    "No buffer available for dump!!!\n");
 		goto qla24xx_fw_dump_failed;
@@ -997,10 +984,10 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 	if (ha->fw_dumped) {
 		qla_printk(KERN_WARNING, ha,
 		    "Firmware has been previously dumped (%p) -- ignoring "
-		    "request...\n", ha->fw_dump24);
+		    "request...\n", ha->fw_dump);
 		goto qla24xx_fw_dump_failed;
 	}
-	fw = (struct qla24xx_fw_dump *) ha->fw_dump24;
+	fw = ha->fw_dump;
 
 	rval = QLA_SUCCESS;
 	fw->host_status = RD_REG_DWORD(&reg->host_status);
@@ -1654,7 +1641,7 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 	} else {
 		qla_printk(KERN_INFO, ha,
 		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    ha->host_no, ha->fw_dump24);
+		    ha->host_no, ha->fw_dump);
 		ha->fw_dumped = 1;
 	}
 
@@ -1672,7 +1659,7 @@ qla24xx_ascii_fw_dump(scsi_qla_host_t *h
 	uint32_t ext_mem_cnt;
 
 	uiter = ha->fw_dump_buffer;
-	fw = ha->fw_dump24;
+	fw = ha->fw_dump;
 
 	qla_uprintf(&uiter, "ISP FW Version %d.%02d.%02d Attributes %04x\n",
 	    ha->fw_major_version, ha->fw_minor_version,
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 30a9319..d6f6579 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2304,15 +2304,11 @@ #define RISC_START_ADDRESS_2400 0x100000
 
 	/* Firmware dump information. */
 	void		*fw_dump;
-	int		fw_dump_order;
+	int		fw_dumped;
 	int		fw_dump_reading;
 	char		*fw_dump_buffer;
 	int		fw_dump_buffer_len;
 
-	int		fw_dumped;
-	void		*fw_dump24;
-	int		fw_dump24_len;
-
 	uint8_t		host_str[16];
 	uint32_t	pci_attr;
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 748be95..011e879 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -773,16 +773,26 @@ qla24xx_chip_diag(scsi_qla_host_t *ha)
 static void
 qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 {
+	uint32_t dump_size = 0;
+
 	ha->fw_dumped = 0;
-	ha->fw_dump24_len = sizeof(struct qla24xx_fw_dump);
-	ha->fw_dump24_len += (ha->fw_memory_size - 0x100000) * sizeof(uint32_t);
-	ha->fw_dump24 = vmalloc(ha->fw_dump24_len);
-	if (ha->fw_dump24)
+	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
+		dump_size = sizeof(struct qla2100_fw_dump);
+	} else if (IS_QLA23XX(ha)) {
+		dump_size = sizeof(struct qla2300_fw_dump);
+		dump_size += (ha->fw_memory_size - 0x11000) * sizeof(uint16_t);
+        } else if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+		dump_size = sizeof(struct qla24xx_fw_dump);
+		dump_size += (ha->fw_memory_size - 0x100000) * sizeof(uint32_t);
+	}
+
+	ha->fw_dump = vmalloc(dump_size);
+	if (ha->fw_dump)
 		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for firmware "
-		    "dump...\n", ha->fw_dump24_len / 1024);
+		    "dump...\n", dump_size / 1024);
 	else
 		qla_printk(KERN_WARNING, ha, "Unable to allocate (%d KB) for "
-		    "firmware dump!!!\n", ha->fw_dump24_len / 1024);
+		    "firmware dump!!!\n", dump_size / 1024);
 }
 
 /**
@@ -800,13 +810,12 @@ qla2x00_resize_request_q(scsi_qla_host_t
 	dma_addr_t request_dma;
 	request_t *request_ring;
 
+	qla2x00_alloc_fw_dump(ha);
+
 	/* Valid only on recent ISPs. */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return;
 
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
-		qla2x00_alloc_fw_dump(ha);
-
 	/* Retrieve IOCB counts available to the firmware. */
 	rval = qla2x00_get_resource_cnts(ha, NULL, NULL, NULL, &fw_iocb_cnt);
 	if (rval)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 56e09fc..ccaad0b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2071,15 +2071,10 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	}
 	INIT_LIST_HEAD(&ha->fcports);
 
-	if (ha->fw_dump)
-		free_pages((unsigned long)ha->fw_dump, ha->fw_dump_order);
-
-	vfree(ha->fw_dump24);
-
+	vfree(ha->fw_dump);
 	vfree(ha->fw_dump_buffer);
 
 	ha->fw_dump = NULL;
-	ha->fw_dump24 = NULL;
 	ha->fw_dumped = 0;
 	ha->fw_dump_reading = 0;
 	ha->fw_dump_buffer = NULL;
-- 
1.3.3.g63df


