From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 7/24] advansys: Convert to EISA driver model
Date: Fri, 27 Jul 2007 07:42:16 -0600
Message-ID: <11855437533612-git-send-email-matthew@wil.cx>
References: <20070727134038.GC21219@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:35224 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934179AbXG0Nmi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 09:42:38 -0400
In-Reply-To: <20070727134038.GC21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

 - Switch EISA probing to the driver model
 - Remove some now-unused macros and functions
 - Update the FIXME now that we use the correct driver model probing API

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  168 ++++++++++++++++++++++++-----------------------
 1 files changed, 85 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 80e24f5..2246b69 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -769,6 +769,7 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
+#include <linux/eisa.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
@@ -783,13 +784,9 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 
-/* FIXME: (by jejb@steeleye.com) This warning is present for two
- * reasons:
+/* FIXME: (by jejb@steeleye.com)
  *
- * 1) This driver badly needs converting to the correct driver model
- *    probing API
- *
- * 2) Although all of the necessary command mapping places have the
+ * Although all of the necessary command mapping places have the
  * appropriate dma_map.. APIs, the driver still processes its internal
  * queue using bus_to_virt() and virt_to_bus() which are illegal under
  * the API.  The entire queue processing structure will need to be
@@ -1787,16 +1784,10 @@ typedef struct asceep_config {
 #define ASC_1000_ID0W      0x04C1
 #define ASC_1000_ID0W_FIX  0x00C1
 #define ASC_1000_ID1B      0x25
-#define ASC_EISA_BIG_IOP_GAP   (0x1C30-0x0C50)
-#define ASC_EISA_SMALL_IOP_GAP (0x0020)
-#define ASC_EISA_MIN_IOP_ADDR  (0x0C30)
-#define ASC_EISA_MAX_IOP_ADDR  (0xFC50)
 #define ASC_EISA_REV_IOP_MASK  (0x0C83)
 #define ASC_EISA_PID_IOP_MASK  (0x0C80)
 #define ASC_EISA_CFG_IOP_MASK  (0x0C86)
 #define ASC_GET_EISA_SLOT(iop)  (PortAddr)((iop) & 0xF000)
-#define ASC_EISA_ID_740    0x01745004UL
-#define ASC_EISA_ID_750    0x01755004UL
 #define INS_HALTINT        (ushort)0x6281
 #define INS_HALT           (ushort)0x6280
 #define INS_SINT           (ushort)0x6200
@@ -1943,8 +1934,6 @@ static int AscIsrQDone(ASC_DVC_VAR *);
 static int AscCompareString(uchar *, uchar *, int);
 #ifdef CONFIG_ISA
 static ushort AscGetEisaChipCfg(PortAddr);
-static ASC_DCNT AscGetEisaProductID(PortAddr);
-static PortAddr AscSearchIOPortAddrEISA(PortAddr);
 static PortAddr AscSearchIOPortAddr11(PortAddr);
 static PortAddr AscSearchIOPortAddr(PortAddr, ushort);
 static void AscSetISAPNPWaitForKey(void);
@@ -3418,7 +3407,7 @@ typedef struct {
 
 #define ASC_NUM_BOARD_SUPPORTED 16
 #define ASC_NUM_IOPORT_PROBE    4
-#define ASC_NUM_BUS             3
+#define ASC_NUM_BUS             2
 
 /* Reference Scsi_Host hostdata */
 #define ASC_BOARDP(host) ((asc_board_t *) &((host)->hostdata))
@@ -3869,7 +3858,6 @@ static ASC_SG_HEAD asc_sg_head = { 0 };
 static ushort asc_bus[ASC_NUM_BUS] __initdata = {
 	ASC_IS_ISA,
 	ASC_IS_VL,
-	ASC_IS_EISA,
 };
 
 static int asc_iopflag = ASC_FALSE;
@@ -3879,7 +3867,6 @@ static int asc_ioport[ASC_NUM_IOPORT_PROBE] = { 0, 0, 0, 0 };
 static char *asc_bus_name[ASC_NUM_BUS] = {
 	"ASC_IS_ISA",
 	"ASC_IS_VL",
-	"ASC_IS_EISA",
 };
 
 static int asc_dbglvl = 3;
@@ -8300,12 +8287,6 @@ static PortAddr __init AscSearchIOPortAddr(PortAddr iop_beg, ushort bus_type)
 		}
 		return (0);
 	}
-	if (bus_type & ASC_IS_EISA) {
-		if ((iop_beg = AscSearchIOPortAddrEISA(iop_beg)) != 0) {
-			return (iop_beg);
-		}
-		return (0);
-	}
 	return (0);
 }
 
@@ -10315,57 +10296,6 @@ static void DvcDelayNanoSecond(ASC_DVC_VAR *asc_dvc, ASC_DCNT nano_sec)
 	udelay((nano_sec + 999) / 1000);
 }
 
-#ifdef CONFIG_ISA
-static ASC_DCNT __init AscGetEisaProductID(PortAddr iop_base)
-{
-	PortAddr eisa_iop;
-	ushort product_id_high, product_id_low;
-	ASC_DCNT product_id;
-
-	eisa_iop = ASC_GET_EISA_SLOT(iop_base) | ASC_EISA_PID_IOP_MASK;
-	product_id_low = inpw(eisa_iop);
-	product_id_high = inpw(eisa_iop + 2);
-	product_id = ((ASC_DCNT) product_id_high << 16) |
-	    (ASC_DCNT) product_id_low;
-	return (product_id);
-}
-
-static PortAddr __init AscSearchIOPortAddrEISA(PortAddr iop_base)
-{
-	ASC_DCNT eisa_product_id;
-
-	if (iop_base == 0) {
-		iop_base = ASC_EISA_MIN_IOP_ADDR;
-	} else {
-		if (iop_base == ASC_EISA_MAX_IOP_ADDR)
-			return (0);
-		if ((iop_base & 0x0050) == 0x0050) {
-			iop_base += ASC_EISA_BIG_IOP_GAP;
-		} else {
-			iop_base += ASC_EISA_SMALL_IOP_GAP;
-		}
-	}
-	while (iop_base <= ASC_EISA_MAX_IOP_ADDR) {
-		eisa_product_id = AscGetEisaProductID(iop_base);
-		if ((eisa_product_id == ASC_EISA_ID_740) ||
-		    (eisa_product_id == ASC_EISA_ID_750)) {
-			if (AscFindSignature(iop_base)) {
-				inpw(iop_base + 4);
-				return (iop_base);
-			}
-		}
-		if (iop_base == ASC_EISA_MAX_IOP_ADDR)
-			return (0);
-		if ((iop_base & 0x0050) == 0x0050) {
-			iop_base += ASC_EISA_BIG_IOP_GAP;
-		} else {
-			iop_base += ASC_EISA_SMALL_IOP_GAP;
-		}
-	}
-	return (0);
-}
-#endif /* CONFIG_ISA */
-
 static int AscStartChip(PortAddr iop_base)
 {
 	AscSetChipControl(iop_base, 0);
@@ -18673,12 +18603,6 @@ static int __init advansys_detect(void)
 #endif /* CONFIG_ISA */
 				break;
 
-			case ASC_IS_EISA:
-#ifdef CONFIG_ISA
-				iop = AscSearchIOPortAddr(iop, asc_bus[bus]);
-#endif /* CONFIG_ISA */
-				break;
-
 			default:
 				ASC_PRINT1
 				    ("advansys_detect: unknown bus type: %d\n",
@@ -18758,6 +18682,81 @@ static void __devexit advansys_remove(struct Scsi_Host *shost)
 	}
 }
 
+static struct eisa_device_id advansys_eisa_table[] __devinitdata = {
+	{ "ABP7401" },
+	{ "ABP7501" },
+	{ "" }
+};
+
+MODULE_DEVICE_TABLE(eisa, advansys_eisa_table);
+
+/*
+ * EISA is a little more tricky than PCI; each EISA device may have two
+ * channels, and this driver is written to make each channel its own Scsi_Host
+ */
+struct eisa_scsi_data {
+	struct Scsi_Host *host[2];
+};
+
+static int __devinit advansys_eisa_probe(struct device *dev)
+{
+	int i, ioport;
+	int err;
+	struct eisa_device *edev = to_eisa_device(dev);
+	struct eisa_scsi_data *data;
+
+	err = -ENOMEM;
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		goto fail;
+	ioport = edev->base_addr + 0xc30;
+
+	err = -ENODEV;
+	for (i = 0; i < 2; i++, ioport += 0x20) {
+		if (!AscFindSignature(ioport))
+			continue;
+		inw(ioport + 4);
+		data->host[i] = advansys_board_found(ioport, dev, ASC_IS_EISA);
+		if (data->host[i])
+			err = 0;
+	}
+
+	if (err) {
+		kfree(data);
+	} else {
+		dev_set_drvdata(dev, data);
+	}
+
+ fail:
+	return err;
+}
+
+static __devexit int advansys_eisa_remove(struct device *dev)
+{
+	int i, ioport;
+	struct eisa_scsi_data *data = dev_get_drvdata(dev);
+
+	for (i = 0; i < 2; i++) {
+		struct Scsi_Host *shost = data->host[i];
+		if (!shost)
+			continue;
+		ioport = shost->io_port;
+		advansys_remove(data->host[i]);
+	}
+
+	kfree(data);
+	return 0;
+}
+
+static struct eisa_driver advansys_eisa_driver = {
+	.id_table =		advansys_eisa_table,
+	.driver = {
+		.name =		"advansys",
+		.probe =	advansys_eisa_probe,
+		.remove =	__devexit_p(advansys_eisa_remove),
+	}
+};
+
 /* PCI Devices supported by this driver */
 static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
 	{PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_1200A,
@@ -18818,11 +18817,13 @@ static int __init advansys_init(void)
 {
 	int count, error;
 	count = advansys_detect();
-	error = pci_register_driver(&advansys_pci_driver);
+	error = eisa_driver_register(&advansys_eisa_driver);
+	if (!error)
+		error = pci_register_driver(&advansys_pci_driver);
 
 	/*
-	 * If we found some ISA, EISA or VLB devices, we must not fail.
-	 * We may not drive any PCI devices, but it's better to drive
+	 * If we found some ISA or VLB devices, we must not fail.
+	 * We may not drive any EISA or PCI devices, but it's better to drive
 	 * the cards that we successfully discovered than none at all.
 	 */
 	if (count > 0)
@@ -18835,6 +18836,7 @@ static void __exit advansys_exit(void)
 	int i;
 
 	pci_unregister_driver(&advansys_pci_driver);
+	eisa_driver_unregister(&advansys_eisa_driver);
 
 	for (i = 0; i < asc_board_count; i++) {
 		struct Scsi_Host *host = asc_host[i];
-- 
1.4.4.4

