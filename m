From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [12/18] qla2xxx: Extend firmware dump support
Date: Mon, 21 Jun 2004 22:57:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622055717.GA8469@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:16302 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266604AbUFVFxd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:53:33 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1848 04/06/16 14:28:08 andrew.vasquez@apc.qlogic.com +7 -0
  Add firmware dump support for ISPs with memory chips larger than
  128KB (512/1024KB).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_dbg.c  |   18 ++++++++++++------
 drivers/scsi/qla2xxx/qla_dbg.h  |    6 ++++--
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |   13 ++++++++-----
 drivers/scsi/qla2xxx/qla_mbx.c  |    8 ++++++--
 drivers/scsi/qla2xxx/qla_os.c   |   12 +++++++++---
 7 files changed, 41 insertions(+), 19 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
--- a/drivers/scsi/qla2xxx/qla_dbg.c	2004-06-21 15:39:15 -07:00
+++ b/drivers/scsi/qla2xxx/qla_dbg.c	2004-06-21 15:39:15 -07:00
@@ -40,9 +40,10 @@
 	uint16_t	*dmp_reg;
 	unsigned long	flags;
 	struct qla2300_fw_dump	*fw;
+	uint32_t	dump_size, data_ram_cnt;
 
 	reg = ha->iobase;
-	risc_address = 0;
+	risc_address = data_ram_cnt = 0;
 	mb0 = mb2 = 0;
 	flags = 0;
 
@@ -57,13 +58,15 @@
 	}
 
 	/* Allocate (large) dump buffer. */
-	ha->fw_dump_order = get_order(sizeof(struct qla2300_fw_dump));
+	dump_size = sizeof(struct qla2300_fw_dump);
+	dump_size += (ha->fw_memory_size - 0x11000) * sizeof(uint16_t);
+	ha->fw_dump_order = get_order(dump_size);
 	ha->fw_dump = (struct qla2300_fw_dump *) __get_free_pages(GFP_ATOMIC,
 	    ha->fw_dump_order);
 	if (ha->fw_dump == NULL) {
 		qla_printk(KERN_WARNING, ha,
-		    "Unable to allocated memory for firmware dump (%d/%Zd).\n",
-		    ha->fw_dump_order, sizeof(struct qla2300_fw_dump));
+		    "Unable to allocated memory for firmware dump (%d/%d).\n",
+		    ha->fw_dump_order, dump_size);
 		goto qla2300_fw_dump_failed;
 	}
 	fw = ha->fw_dump;
@@ -304,10 +307,11 @@
 	if (rval == QLA_SUCCESS) {
 		/* Get data SRAM. */
 		risc_address = 0x11000;
+		data_ram_cnt = ha->fw_memory_size - risc_address + 1;
  		WRT_MAILBOX_REG(ha, reg, 0, MBC_READ_RAM_EXTENDED);
 		clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 	}
-	for (cnt = 0; cnt < sizeof(fw->data_ram) / 2 && rval == QLA_SUCCESS;
+	for (cnt = 0; cnt < data_ram_cnt && rval == QLA_SUCCESS;
 	    cnt++, risc_address++) {
  		WRT_MAILBOX_REG(ha, reg, 1, LSW(risc_address));
  		WRT_MAILBOX_REG(ha, reg, 8, MSW(risc_address));
@@ -386,6 +390,7 @@
 	char *uiter;
 	char fw_info[30];
 	struct qla2300_fw_dump *fw;
+	uint32_t data_ram_cnt;
 
 	uiter = ha->fw_dump_buffer;
 	fw = ha->fw_dump;
@@ -550,7 +555,8 @@
 	}
 
 	qla_uprintf(&uiter, "\n\nData RAM Dump:");
-	for (cnt = 0; cnt < sizeof (fw->data_ram) / 2; cnt++) {
+	data_ram_cnt = ha->fw_memory_size - 0x11000 + 1;
+	for (cnt = 0; cnt < data_ram_cnt; cnt++) {
 		if (cnt % 8 == 0) {
 			qla_uprintf(&uiter, "\n%05x: ", cnt + 0x11000);
 		}
diff -Nru a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
--- a/drivers/scsi/qla2xxx/qla_dbg.h	2004-06-21 15:39:15 -07:00
+++ b/drivers/scsi/qla2xxx/qla_dbg.h	2004-06-21 15:39:15 -07:00
@@ -182,7 +182,9 @@
 /*
  * Firmware Dump structure definition
  */
-#define FW_DUMP_SIZE	0xBC000		/* bytes */
+#define FW_DUMP_SIZE_128K	0xBC000
+#define FW_DUMP_SIZE_512K	0x2FC000
+#define FW_DUMP_SIZE_1M		0x5FC000
 
 struct qla2300_fw_dump {
 	uint16_t hccr;
@@ -205,7 +207,7 @@
 	uint16_t fpm_b1_reg[64];
 	uint16_t risc_ram[0xf800];
 	uint16_t stack_ram[0x1000];
-	uint16_t data_ram[0xF000];
+	uint16_t data_ram[1];
 };
 
 struct qla2100_fw_dump {
diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	2004-06-21 15:39:15 -07:00
+++ b/drivers/scsi/qla2xxx/qla_def.h	2004-06-21 15:39:15 -07:00
@@ -2303,6 +2303,7 @@
 	uint16_t	fw_minor_version;
 	uint16_t	fw_subminor_version;
 	uint16_t	fw_attributes;
+	uint32_t	fw_memory_size;
 	uint32_t	fw_transfer_size;
 
 	uint16_t	fw_options[16];		/* slots: 1,2,3,10,11 */
diff -Nru a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h	2004-06-21 15:39:15 -07:00
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	2004-06-21 15:39:15 -07:00
@@ -139,7 +139,7 @@
 
 extern void
 qla2x00_get_fw_version(scsi_qla_host_t *, uint16_t *,
-    uint16_t *, uint16_t *, uint16_t *);
+    uint16_t *, uint16_t *, uint16_t *, uint32_t *);
 
 extern int
 qla2x00_get_fw_options(scsi_qla_host_t *, uint16_t *);
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-06-21 15:39:15 -07:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-06-21 15:39:15 -07:00
@@ -220,11 +220,6 @@
 	} while (restart_risc && retry--);
 
 	if (rval == QLA_SUCCESS) {
-		/* Retrieve firmware information */
-		qla2x00_get_fw_version(ha, &ha->fw_major_version,
-		    &ha->fw_minor_version, &ha->fw_subminor_version,
-		    &ha->fw_attributes);
-
 		clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
 		ha->marker_needed = 1;
 		qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
@@ -730,6 +725,14 @@
 			    "firmware.\n", ha->host_no));
 
 			rval = qla2x00_execute_fw(ha);
+			/* Retrieve firmware information. */
+			if (rval == QLA_SUCCESS && ha->fw_major_version == 0) {
+				qla2x00_get_fw_version(ha,
+				    &ha->fw_major_version,
+				    &ha->fw_minor_version,
+				    &ha->fw_subminor_version,
+				    &ha->fw_attributes, &ha->fw_memory_size);
+			}
 		}
 		else {
 			DEBUG2(printk(KERN_INFO
diff -Nru a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c	2004-06-21 15:39:15 -07:00
+++ b/drivers/scsi/qla2xxx/qla_mbx.c	2004-06-21 15:39:15 -07:00
@@ -546,7 +546,7 @@
  */
 void
 qla2x00_get_fw_version(scsi_qla_host_t *ha, uint16_t *major, uint16_t *minor,
-    uint16_t *subminor, uint16_t *attributes)
+    uint16_t *subminor, uint16_t *attributes, uint32_t *memory)
 {
 	int		rval;
 	mbx_cmd_t	mc;
@@ -556,7 +556,7 @@
 
 	mcp->mb[0] = MBC_GET_FIRMWARE_VERSION;
 	mcp->out_mb = MBX_0;
-	mcp->in_mb = MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->flags = 0;
 	mcp->tov = 30;
 	rval = qla2x00_mailbox_command(ha, mcp);
@@ -566,6 +566,10 @@
 	*minor = mcp->mb[2];
 	*subminor = mcp->mb[3];
 	*attributes = mcp->mb[6];
+	if (IS_QLA2100(ha) || IS_QLA2200(ha))
+		*memory = 0x1FFFF;			/* Defaults to 128KB. */
+	else
+		*memory = (mcp->mb[5] << 16) | mcp->mb[4];
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:39:15 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:39:15 -07:00
@@ -455,6 +455,7 @@
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
 	int reading;
+	uint32_t dump_size;
 
 	if (off != 0)
 		return (0);
@@ -480,11 +481,16 @@
 		if (ha->fw_dump != NULL && !ha->fw_dump_reading) {
 			ha->fw_dump_reading = 1;
 
-			ha->fw_dump_buffer = (char *)vmalloc(FW_DUMP_SIZE);
+			dump_size = FW_DUMP_SIZE_1M;
+			if (ha->fw_memory_size < 0x20000) 
+				dump_size = FW_DUMP_SIZE_128K;
+			else if (ha->fw_memory_size < 0x80000) 
+				dump_size = FW_DUMP_SIZE_512K;
+			ha->fw_dump_buffer = (char *)vmalloc(dump_size);
 			if (ha->fw_dump_buffer == NULL) {
 				qla_printk(KERN_WARNING, ha,
 				    "Unable to allocate memory for firmware "
-				    "dump buffer (%d).\n", FW_DUMP_SIZE);
+				    "dump buffer (%d).\n", dump_size);
 
 				ha->fw_dump_reading = 0;
 				return (count);
@@ -492,7 +498,7 @@
 			qla_printk(KERN_INFO, ha,
 			    "Firmware dump ready for read on (%ld).\n",
 			    ha->host_no);
-			memset(ha->fw_dump_buffer, 0, FW_DUMP_SIZE);
+			memset(ha->fw_dump_buffer, 0, dump_size);
 			if (IS_QLA2100(ha) || IS_QLA2200(ha))
  				qla2100_ascii_fw_dump(ha);
  			else
