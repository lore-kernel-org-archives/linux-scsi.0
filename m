From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [3/11]   qla2xxx: NVRAM updates
Date: Wed, 8 Dec 2004 23:34:38 -0800
Message-ID: <20041209073438.GA22078@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:40691 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261474AbULIHez (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 02:34:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ChangeSet
  1.2237 04/12/08 14:24:05 andrew.vasquez@qlogic.com +4 -0
  Address several NVRAM access issues:
     o Add support for write-protected NVRAM chips used with
       ISP2322 and ISP6322.
     o Correct code to not perform an erase data during NVRAM
       update.
     o Correct issuance of NVRAM delay after PCI posting call.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_def.h |    2 
 drivers/scsi/qla2xxx/qla_gbl.h |    1 
 drivers/scsi/qla2xxx/qla_os.c  |    1 
 drivers/scsi/qla2xxx/qla_sup.c |   93 ++++++++++++++++++++++++++---------------
 4 files changed, 64 insertions(+), 33 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	2004-12-08 22:13:14 -08:00
+++ b/drivers/scsi/qla2xxx/qla_def.h	2004-12-08 22:13:14 -08:00
@@ -346,6 +346,8 @@
 	volatile uint16_t nvram;	/* NVRAM register. */
 #define NVR_DESELECT		0
 #define NVR_BUSY		BIT_15
+#define NVR_WRT_ENABLE		BIT_14	/* Write enable */
+#define NVR_PR_ENABLE		BIT_13	/* Protection register enable */
 #define NVR_DATA_IN		BIT_3
 #define NVR_DATA_OUT		BIT_2
 #define NVR_SELECT		BIT_1
diff -Nru a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h	2004-12-08 22:13:14 -08:00
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	2004-12-08 22:13:14 -08:00
@@ -212,6 +212,7 @@
  */
 extern void qla2x00_lock_nvram_access(scsi_qla_host_t *);
 extern void qla2x00_unlock_nvram_access(scsi_qla_host_t *);
+extern void qla2x00_release_nvram_protection(scsi_qla_host_t *);
 extern uint16_t qla2x00_get_nvram_word(scsi_qla_host_t *, uint32_t);
 extern void qla2x00_write_nvram_word(scsi_qla_host_t *, uint32_t, uint16_t);
 /*
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-12-08 22:13:14 -08:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-12-08 22:13:14 -08:00
@@ -566,6 +566,7 @@
 	/* Write NVRAM. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qla2x00_lock_nvram_access(ha);
+	qla2x00_release_nvram_protection(ha);
  	witer = (uint16_t *)buf;
 	for (cnt = 0; cnt < count / 2; cnt++) {
 		qla2x00_write_nvram_word(ha, cnt+ha->nvram_base,
diff -Nru a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
--- a/drivers/scsi/qla2xxx/qla_sup.c	2004-12-08 22:13:14 -08:00
+++ b/drivers/scsi/qla2xxx/qla_sup.c	2004-12-08 22:13:14 -08:00
@@ -26,7 +26,6 @@
 static void qla2x00_nv_deselect(scsi_qla_host_t *);
 static void qla2x00_nv_write(scsi_qla_host_t *, uint16_t);
 
-
 /*
  * NVRAM support routines
  */
@@ -80,6 +79,56 @@
 }
 
 /**
+ * qla2x00_release_nvram_protection() - 
+ * @ha: HA context
+ */
+void
+qla2x00_release_nvram_protection(scsi_qla_host_t *ha)
+{
+	device_reg_t *reg;
+	uint32_t word;
+
+	reg = ha->iobase;
+
+	/* Release NVRAM write protection. */
+	if (IS_QLA2322(ha) || IS_QLA6322(ha)) {
+		/* Write enable. */
+		qla2x00_nv_write(ha, NVR_DATA_OUT);
+		qla2x00_nv_write(ha, 0);
+		qla2x00_nv_write(ha, 0);
+		for (word = 0; word < 8; word++)
+			qla2x00_nv_write(ha, NVR_DATA_OUT);
+
+		qla2x00_nv_deselect(ha);
+
+		/* Enable protection register. */
+		qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
+		qla2x00_nv_write(ha, NVR_PR_ENABLE);
+		qla2x00_nv_write(ha, NVR_PR_ENABLE);
+		for (word = 0; word < 8; word++)
+			qla2x00_nv_write(ha, NVR_DATA_OUT | NVR_PR_ENABLE);
+
+		qla2x00_nv_deselect(ha);
+
+		/* Clear protection register (ffff is cleared). */
+		qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
+		qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
+		qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
+		for (word = 0; word < 8; word++)
+			qla2x00_nv_write(ha, NVR_DATA_OUT | NVR_PR_ENABLE);
+
+		qla2x00_nv_deselect(ha);
+
+		/* Wait for NVRAM to become ready. */
+		WRT_REG_WORD(&reg->nvram, NVR_SELECT);
+		do {
+			NVRAM_DELAY();
+			word = RD_REG_WORD(&reg->nvram);
+		} while ((word & NVR_DATA_IN) == 0);
+	}
+}
+
+/**
  * qla2x00_get_nvram_word() - Calculates word position in NVRAM and calls the
  *	request routine to get the word from NVRAM.
  * @ha: HA context
@@ -123,29 +172,6 @@
 
 	qla2x00_nv_deselect(ha);
 
-	/* Erase Location */
-	nv_cmd = (addr << 16) | NV_ERASE_OP;
-	nv_cmd <<= 5;
-	for (count = 0; count < 11; count++) {
-		if (nv_cmd & BIT_31)
-			qla2x00_nv_write(ha, NVR_DATA_OUT);
-		else
-			qla2x00_nv_write(ha, 0);
-
-		nv_cmd <<= 1;
-	}
-
-	qla2x00_nv_deselect(ha);
-
-	/* Wait for Erase to Finish */
-	WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-	do {
-		NVRAM_DELAY();
-		word = RD_REG_WORD(&reg->nvram);
-	} while ((word & NVR_DATA_IN) == 0);
-
-	qla2x00_nv_deselect(ha);
-
 	/* Write data */
 	nv_cmd = (addr << 16) | NV_WRITE_OP;
 	nv_cmd |= data;
@@ -220,14 +246,14 @@
 		if (reg_data & NVR_DATA_IN)
 			data |= BIT_0;
 		WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-		NVRAM_DELAY();
 		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
+		NVRAM_DELAY();
 	}
 
 	/* Deselect chip. */
 	WRT_REG_WORD(&reg->nvram, NVR_DESELECT);
-	NVRAM_DELAY();
 	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	NVRAM_DELAY();
 
 	return (data);
 }
@@ -236,14 +262,14 @@
  * qla2x00_nv_write() - Clean NVRAM operations.
  * @ha: HA context
  */
-void
+static void
 qla2x00_nv_deselect(scsi_qla_host_t *ha)
 {
 	device_reg_t __iomem *reg = ha->iobase;
 
 	WRT_REG_WORD(&reg->nvram, NVR_DESELECT);
-	NVRAM_DELAY();
 	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	NVRAM_DELAY();
 }
 
 /**
@@ -251,19 +277,20 @@
  * @ha: HA context
  * @data: Serial interface selector
  */
-void
+static void
 qla2x00_nv_write(scsi_qla_host_t *ha, uint16_t data)
 {
 	device_reg_t __iomem *reg = ha->iobase;
 
-	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT);
-	NVRAM_DELAY();
+	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
 	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
-	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_CLOCK);
 	NVRAM_DELAY();
+	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT| NVR_CLOCK |
+	    NVR_WRT_ENABLE);
 	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
-	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT);
 	NVRAM_DELAY();
+	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
 	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	NVRAM_DELAY();
 }
 
