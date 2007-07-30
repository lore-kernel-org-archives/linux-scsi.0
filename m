From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 9/23] advansys: Convert to ISA driver model
Date: Mon, 30 Jul 2007 10:56:54 -0600
Message-ID: <11858146281137-git-send-email-matthew@wil.cx>
References: <20070730165508.GH21219@parisc-linux.org> <11858146283240-git-send-email-matthew@wil.cx> <1185814628978-git-send-email-matthew@wil.cx> <11858146282602-git-send-email-matthew@wil.cx> <11858146283106-git-send-email-matthew@wil.cx> <11858146282252-git-send-email-matthew@wil.cx> <11858146281790-git-send-email-matthew@wil.cx> <11858146281215-git-send-email-matthew@wil.cx> <11858146282469-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:35769 "EHLO
	smtp-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936907AbXG3Q5L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:57:11 -0400
In-Reply-To: <11858146282469-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Register two isa_drivers, one for ISA and one for VLB, in order to
preserve detection order.  When deleting advansys_detect, we lose the
last vestiges of the code that limited IO port scanning.  This code
has been effectively disabled for many years anyway; I'll restore it
in a module_param later.  We also lose the code that placed all ISA PnP
cards into WaitForKey state -- drivers shouldn't be doing this anyway.
The asc_host array goes away too.  Also remove some IOADR and other
definitions, such as ASC_NUM_BOARD_SUPPORTED.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  412 +++++++++++++----------------------------------
 1 files changed, 113 insertions(+), 299 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index e096f19..eda41f2 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -280,7 +280,7 @@
 
         AdvanSys SCSI adapter files have the following path name format:
 
-           /proc/scsi/advansys/[0-(ASC_NUM_BOARD_SUPPORTED-1)]
+           /proc/scsi/advansys/{0,1,2,3,...}
 
         This information can be displayed with cat. For example:
 
@@ -769,6 +769,7 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
+#include <linux/isa.h>
 #include <linux/eisa.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
@@ -1362,18 +1363,6 @@ typedef struct asc_risc_sg_list_q {
 #define ASC_MAX_INRAM_TAG_QNG   16
 #define ASC_IOADR_TABLE_MAX_IX  11
 #define ASC_IOADR_GAP   0x10
-#define ASC_SEARCH_IOP_GAP 0x10
-#define ASC_MIN_IOP_ADDR   (PortAddr)0x0100
-#define ASC_MAX_IOP_ADDR   (PortAddr)0x3F0
-#define ASC_IOADR_1     (PortAddr)0x0110
-#define ASC_IOADR_2     (PortAddr)0x0130
-#define ASC_IOADR_3     (PortAddr)0x0150
-#define ASC_IOADR_4     (PortAddr)0x0190
-#define ASC_IOADR_5     (PortAddr)0x0210
-#define ASC_IOADR_6     (PortAddr)0x0230
-#define ASC_IOADR_7     (PortAddr)0x0250
-#define ASC_IOADR_8     (PortAddr)0x0330
-#define ASC_IOADR_DEF   ASC_IOADR_8
 #define ASC_LIB_SCSIQ_WK_SP        256
 #define ASC_MAX_SYN_XFER_NO        16
 #define ASC_SYN_MAX_OFFSET         0x0F
@@ -1934,9 +1923,6 @@ static int AscIsrQDone(ASC_DVC_VAR *);
 static int AscCompareString(uchar *, uchar *, int);
 #ifdef CONFIG_ISA
 static ushort AscGetEisaChipCfg(PortAddr);
-static PortAddr AscSearchIOPortAddr11(PortAddr);
-static PortAddr AscSearchIOPortAddr(PortAddr, ushort);
-static void AscSetISAPNPWaitForKey(void);
 #endif /* CONFIG_ISA */
 static uchar AscGetChipScsiCtrl(PortAddr);
 static uchar AscSetChipScsiID(PortAddr, uchar);
@@ -3405,10 +3391,6 @@ typedef struct {
  * --- Driver Constants and Macros
  */
 
-#define ASC_NUM_BOARD_SUPPORTED 16
-#define ASC_NUM_IOPORT_PROBE    4
-#define ASC_NUM_BUS             2
-
 /* Reference Scsi_Host hostdata */
 #define ASC_BOARDP(host) ((asc_board_t *) &((host)->hostdata))
 
@@ -3836,10 +3818,6 @@ typedef struct asc_board {
 /* Number of boards detected in system. */
 static int asc_board_count;
 
-/* Number of boards detected by advansys_detect */
-static int asc_legacy_count;
-static struct Scsi_Host *asc_host[ASC_NUM_BOARD_SUPPORTED] = { NULL };
-
 /* Overrun buffer used by all narrow boards. */
 static uchar overrun_buf[ASC_OVERRUN_BSIZE] = { 0 };
 
@@ -3849,27 +3827,10 @@ static uchar overrun_buf[ASC_OVERRUN_BSIZE] = { 0 };
 static ASC_SCSI_Q asc_scsi_q = { {0} };
 static ASC_SG_HEAD asc_sg_head = { 0 };
 
-/* List of bus types probed in advansys_detect. */
-static ushort asc_bus[ASC_NUM_BUS] __initdata = {
-	ASC_IS_ISA,
-	ASC_IS_VL,
-};
-
-static int asc_iopflag = ASC_FALSE;
-static int asc_ioport[ASC_NUM_IOPORT_PROBE] = { 0, 0, 0, 0 };
-
 #ifdef ADVANSYS_DEBUG
-static char *asc_bus_name[ASC_NUM_BUS] = {
-	"ASC_IS_ISA",
-	"ASC_IS_VL",
-};
-
 static int asc_dbglvl = 3;
 #endif /* ADVANSYS_DEBUG */
 
-/* Declaration for Asc Library internal data referenced by driver. */
-static PortAddr _asc_def_iop_base[];
-
 /*
  * --- Driver Function Prototypes
  *
@@ -3932,7 +3893,7 @@ static void asc_prt_hex(char *f, uchar *, int);
 
 #ifdef CONFIG_PROC_FS
 /*
- * advansys_proc_info() - /proc/scsi/advansys/[0-(ASC_NUM_BOARD_SUPPORTED-1)]
+ * advansys_proc_info() - /proc/scsi/advansys/{0,1,2,3,...}
  *
  * *buffer: I/O buffer
  * **start: if inout == FALSE pointer into buffer where user read should start
@@ -8196,77 +8157,6 @@ static int AscFindSignature(PortAddr iop_base)
 	return (0);
 }
 
-static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] __initdata = {
-	0x100, ASC_IOADR_1, 0x120, ASC_IOADR_2, 0x140, ASC_IOADR_3, ASC_IOADR_4,
-	ASC_IOADR_5, ASC_IOADR_6, ASC_IOADR_7, ASC_IOADR_8
-};
-
-#ifdef CONFIG_ISA
-static uchar _isa_pnp_inited __initdata = 0;
-
-static PortAddr __init AscSearchIOPortAddr(PortAddr iop_beg, ushort bus_type)
-{
-	if (bus_type & ASC_IS_VL) {
-		while ((iop_beg = AscSearchIOPortAddr11(iop_beg)) != 0) {
-			if (AscGetChipVersion(iop_beg, bus_type) <=
-			    ASC_CHIP_MAX_VER_VL) {
-				return (iop_beg);
-			}
-		}
-		return (0);
-	}
-	if (bus_type & ASC_IS_ISA) {
-		if (_isa_pnp_inited == 0) {
-			AscSetISAPNPWaitForKey();
-			_isa_pnp_inited++;
-		}
-		while ((iop_beg = AscSearchIOPortAddr11(iop_beg)) != 0) {
-			if ((AscGetChipVersion(iop_beg, bus_type) &
-			     ASC_CHIP_VER_ISA_BIT) != 0) {
-				return (iop_beg);
-			}
-		}
-		return (0);
-	}
-	return (0);
-}
-
-static PortAddr __init AscSearchIOPortAddr11(PortAddr s_addr)
-{
-	int i;
-	PortAddr iop_base;
-
-	for (i = 0; i < ASC_IOADR_TABLE_MAX_IX; i++) {
-		if (_asc_def_iop_base[i] > s_addr) {
-			break;
-		}
-	}
-	for (; i < ASC_IOADR_TABLE_MAX_IX; i++) {
-		iop_base = _asc_def_iop_base[i];
-		if (!request_region(iop_base, ASC_IOADR_GAP, "advansys")) {
-			ASC_DBG1(1,
-				 "AscSearchIOPortAddr11: check_region() failed I/O port 0x%x\n",
-				 iop_base);
-			continue;
-		}
-		ASC_DBG1(1, "AscSearchIOPortAddr11: probing I/O port 0x%x\n",
-			 iop_base);
-		release_region(iop_base, ASC_IOADR_GAP);
-		if (AscFindSignature(iop_base)) {
-			return (iop_base);
-		}
-	}
-	return (0);
-}
-
-static void __init AscSetISAPNPWaitForKey(void)
-{
-	outp(ASC_ISA_PNP_PORT_ADDR, 0x02);
-	outp(ASC_ISA_PNP_PORT_WRITE, 0x02);
-	return;
-}
-#endif /* CONFIG_ISA */
-
 static void __devinit AscToggleIRQAct(PortAddr iop_base)
 {
 	AscSetChipStatus(iop_base, CIW_IRQ_ACT);
@@ -18389,181 +18279,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 }
 
 /*
- * advansys_detect()
- *
- * Detect function for AdvanSys adapters.
- *
- * Argument is a pointer to the host driver's scsi_hosts entry.
- *
- * Return number of adapters found.
- *
- * Note: Because this function is called during system initialization
- * it must not call SCSI mid-level functions including scsi_malloc()
- * and scsi_free().
- */
-static int __init advansys_detect(void)
-{
-	int iop;
-	int bus;
-	int ioport = 0;
-	struct Scsi_Host *shost;
-
-	ASC_DBG(1, "advansys_detect: begin\n");
-
-	asc_legacy_count = 0;
-
-	/*
-	 * If I/O port probing has been modified, then verify and
-	 * clean-up the 'asc_ioport' list.
-	 */
-	if (asc_iopflag == ASC_TRUE) {
-		for (ioport = 0; ioport < ASC_NUM_IOPORT_PROBE; ioport++) {
-			ASC_DBG2(1, "advansys_detect: asc_ioport[%d] 0x%x\n",
-				 ioport, asc_ioport[ioport]);
-			if (asc_ioport[ioport] != 0) {
-				for (iop = 0; iop < ASC_IOADR_TABLE_MAX_IX;
-				     iop++) {
-					if (_asc_def_iop_base[iop] ==
-					    asc_ioport[ioport]) {
-						break;
-					}
-				}
-				if (iop == ASC_IOADR_TABLE_MAX_IX) {
-					printk
-					    ("AdvanSys SCSI: specified I/O Port 0x%X is invalid\n",
-					     asc_ioport[ioport]);
-					asc_ioport[ioport] = 0;
-				}
-			}
-		}
-		ioport = 0;
-	}
-
-	for (bus = 0; bus < ASC_NUM_BUS; bus++) {
-
-		ASC_DBG2(1, "advansys_detect: bus search type %d (%s)\n",
-			 bus, asc_bus_name[bus]);
-		iop = 0;
-
-		while (asc_legacy_count < ASC_NUM_BOARD_SUPPORTED) {
-
-			ASC_DBG1(2, "advansys_detect: asc_legacy_count %d\n",
-				 asc_legacy_count);
-
-			switch (asc_bus[bus]) {
-			case ASC_IS_ISA:
-			case ASC_IS_VL:
-#ifdef CONFIG_ISA
-				if (asc_iopflag == ASC_FALSE) {
-					iop =
-					    AscSearchIOPortAddr(iop,
-								asc_bus[bus]);
-				} else {
-					/*
-					 * ISA and VL I/O port scanning has either been
-					 * eliminated or limited to selected ports on
-					 * the LILO command line, /etc/lilo.conf, or
-					 * by setting variables when the module was loaded.
-					 */
-					ASC_DBG(1,
-						"advansys_detect: I/O port scanning modified\n");
- ioport_try_again:
-					iop = 0;
-					for (; ioport < ASC_NUM_IOPORT_PROBE;
-					     ioport++) {
-						if ((iop =
-						     asc_ioport[ioport]) != 0) {
-							break;
-						}
-					}
-					if (iop) {
-						ASC_DBG1(1,
-							 "advansys_detect: probing I/O port 0x%x...\n",
-							 iop);
-						if (!request_region
-						    (iop, ASC_IOADR_GAP,
-						     "advansys")) {
-							printk
-							    ("AdvanSys SCSI: specified I/O Port 0x%X is busy\n",
-							     iop);
-							/* Don't try this I/O port twice. */
-							asc_ioport[ioport] = 0;
-							goto ioport_try_again;
-						} else if (AscFindSignature(iop)
-							   == ASC_FALSE) {
-							printk
-							    ("AdvanSys SCSI: specified I/O Port 0x%X has no adapter\n",
-							     iop);
-							/* Don't try this I/O port twice. */
-							release_region(iop,
-								       ASC_IOADR_GAP);
-							asc_ioport[ioport] = 0;
-							goto ioport_try_again;
-						} else {
-							/*
-							 * If this isn't an ISA board, then it must be
-							 * a VL board. If currently looking an ISA
-							 * board is being looked for then try for
-							 * another ISA board in 'asc_ioport'.
-							 */
-							if (asc_bus[bus] ==
-							    ASC_IS_ISA
-							    &&
-							    (AscGetChipVersion
-							     (iop,
-							      ASC_IS_ISA) &
-							     ASC_CHIP_VER_ISA_BIT)
-							    == 0) {
-								/*
-								 * Don't clear 'asc_ioport[ioport]'. Try
-								 * this board again for VL. Increment
-								 * 'ioport' past this board.
-								 */
-								ioport++;
-								release_region
-								    (iop,
-								     ASC_IOADR_GAP);
-								goto ioport_try_again;
-							}
-						}
-						/*
-						 * This board appears good, don't try the I/O port
-						 * again by clearing its value. Increment 'ioport'
-						 * for the next iteration.
-						 */
-						asc_ioport[ioport++] = 0;
-					}
-				}
-#endif /* CONFIG_ISA */
-				break;
-
-			default:
-				ASC_PRINT1
-				    ("advansys_detect: unknown bus type: %d\n",
-				     asc_bus[bus]);
-				break;
-			}
-			ASC_DBG1(1, "advansys_detect: iop 0x%x\n", iop);
-
-			/*
-			 * Adapter not found, try next bus type.
-			 */
-			if (iop == 0)
-				break;
-
-			shost = advansys_board_found(iop, NULL, asc_bus[bus]);
-			if (shost) {
-				asc_host[asc_legacy_count++] = shost;
-			}
-		}
-	}
-
-	ASC_DBG1(1, "advansys_detect: done: asc_legacy_count %d\n",
-		 asc_legacy_count);
-	return asc_legacy_count;
-}
-
-/*
  * advansys_release()
  *
  * Release resources allocated for a single AdvanSys adapter.
@@ -18591,6 +18306,98 @@ static int advansys_release(struct Scsi_Host *shost)
 	return 0;
 }
 
+static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] __devinitdata = {
+	0x100, 0x0110, 0x120, 0x0130, 0x140, 0x0150, 0x0190,
+	0x0210, 0x0230, 0x0250, 0x0330
+};
+
+static int __devinit advansys_isa_probe(struct device *dev, unsigned int id)
+{
+	PortAddr iop_base = _asc_def_iop_base[id];
+	struct Scsi_Host *shost;
+
+	if (!request_region(iop_base, ASC_IOADR_GAP, "advansys")) {
+		ASC_DBG1(1, "advansys_isa_match: check_region() failed "
+			 "I/O port 0x%x\n", iop_base);
+		return -ENODEV;
+	}
+	ASC_DBG1(1, "advansys_isa_match: probing I/O port 0x%x\n", iop_base);
+	release_region(iop_base, ASC_IOADR_GAP);
+	if (!AscFindSignature(iop_base))
+		goto nodev;
+	if (!(AscGetChipVersion(iop_base, ASC_IS_ISA) & ASC_CHIP_VER_ISA_BIT))
+		goto nodev;
+
+	shost = advansys_board_found(iop_base, dev, ASC_IS_ISA);
+
+	if (!shost)
+		goto nodev;
+
+	dev_set_drvdata(dev, shost);
+	return 0;
+
+ nodev:
+	return -ENODEV;
+}
+
+static int __devexit advansys_isa_remove(struct device *dev, unsigned int id)
+{
+	advansys_release(dev_get_drvdata(dev));
+	return 0;
+}
+
+static struct isa_driver advansys_isa_driver = {
+	.probe		= advansys_isa_probe,
+	.remove		= __devexit_p(advansys_isa_remove),
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "advansys",
+	},
+};
+
+static int __devinit advansys_vlb_probe(struct device *dev, unsigned int id)
+{
+	PortAddr iop_base = _asc_def_iop_base[id];
+	struct Scsi_Host *shost;
+
+	if (!request_region(iop_base, ASC_IOADR_GAP, "advansys")) {
+		ASC_DBG1(1, "advansys_vlb_match: check_region() failed "
+			 "I/O port 0x%x\n", iop_base);
+		return -ENODEV;
+	}
+	ASC_DBG1(1, "advansys_vlb_match: probing I/O port 0x%x\n", iop_base);
+	release_region(iop_base, ASC_IOADR_GAP);
+	if (!AscFindSignature(iop_base))
+		goto nodev;
+	/*
+	 * I don't think this condition can actually happen, but the old
+	 * driver did it, and the chances of finding a VLB setup in 2007
+	 * to do testing with is slight to none.
+	 */
+	if (AscGetChipVersion(iop_base, ASC_IS_VL) > ASC_CHIP_MAX_VER_VL)
+		goto nodev;
+
+	shost = advansys_board_found(iop_base, dev, ASC_IS_VL);
+
+	if (!shost)
+		goto nodev;
+
+	dev_set_drvdata(dev, shost);
+	return 0;
+
+ nodev:
+	return -ENODEV;
+}
+
+static struct isa_driver advansys_vlb_driver = {
+	.probe		= advansys_vlb_probe,
+	.remove		= __devexit_p(advansys_isa_remove),
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "advansys",
+	},
+};
+
 static struct eisa_device_id advansys_eisa_table[] __devinitdata = {
 	{ "ABP7401" },
 	{ "ABP7501" },
@@ -18735,13 +18542,22 @@ static struct pci_driver advansys_pci_driver = {
 
 static int __init advansys_init(void)
 {
-	int i, error;
-	advansys_detect();
+	int error;
 
-	error = eisa_driver_register(&advansys_eisa_driver);
+	error = isa_register_driver(&advansys_isa_driver,
+				    ASC_IOADR_TABLE_MAX_IX);
 	if (error)
 		goto fail;
 
+	error = isa_register_driver(&advansys_vlb_driver,
+				    ASC_IOADR_TABLE_MAX_IX);
+	if (error)
+		goto unregister_isa;
+
+	error = eisa_driver_register(&advansys_eisa_driver);
+	if (error)
+		goto unregister_vlb;
+
 	error = pci_register_driver(&advansys_pci_driver);
 	if (error)
 		goto unregister_eisa;
@@ -18750,22 +18566,20 @@ static int __init advansys_init(void)
 
  unregister_eisa:
 	eisa_driver_unregister(&advansys_eisa_driver);
+ unregister_vlb:
+	isa_unregister_driver(&advansys_vlb_driver);
+ unregister_isa:
+	isa_unregister_driver(&advansys_isa_driver);
  fail:
-	for (i = 0; i < asc_legacy_count; i++)
-		advansys_release(asc_host[i]);
-
 	return error;
 }
 
 static void __exit advansys_exit(void)
 {
-	int i;
-
 	pci_unregister_driver(&advansys_pci_driver);
 	eisa_driver_unregister(&advansys_eisa_driver);
-
-	for (i = 0; i < asc_legacy_count; i++)
-		advansys_release(asc_host[i]);
+	isa_unregister_driver(&advansys_vlb_driver);
+	isa_unregister_driver(&advansys_isa_driver);
 }
 
 module_init(advansys_init);
-- 
1.4.4.4

