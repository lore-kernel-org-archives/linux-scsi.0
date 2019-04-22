From: Ondrej Zary <linux@zary.sk>
Subject: [RFC PATCH 3/4] fdomain: Resurrect driver (ISA support)
Date: Mon, 22 Apr 2019 19:33:22 +0200
Message-ID: <20190422173323.15365-4-linux@zary.sk>
References: <20190422173323.15365-1-linux@zary.sk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190422173323.15365-1-linux@zary.sk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rik Faith <faith@cs.unc.edu>, "David A . Hinds" <dahinds@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Future Domain 16xx ISA SCSI support card support.

Currently untested.

Signed-off-by: Ondrej Zary <linux@zary.sk>
---
 drivers/scsi/Kconfig       |  14 +++
 drivers/scsi/Makefile      |   1 +
 drivers/scsi/fdomain_isa.c | 227 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 242 insertions(+)
 create mode 100644 drivers/scsi/fdomain_isa.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index f9d058a07e2a..2ea77dafbc00 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -684,6 +684,20 @@ config SCSI_FDOMAIN_PCI
 	  To compile this driver as a module, choose M here: the
 	  module will be called fdomain_pci.
 
+config SCSI_FDOMAIN_ISA
+	tristate "Future Domain 16xx ISA SCSI support"
+	depends on ISA && SCSI
+	select CHECK_SIGNATURE
+	select SCSI_FDOMAIN
+	help
+	  This is support for Future Domain's 16-bit SCSI host adapters
+	  (TMC-1660/1680, TMC-1650/1670, TMC-1610M/MER/MEX) and other adapters
+	  with ISA bus based on the Future Domain chipsets (Quantum ISA-200S,
+	  ISA-250MG; and at least one IBM board).
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called fdomain_isa.
+
 config SCSI_GDTH
 	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
 	depends on PCI && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index f6cc4fbe6957..2e2cffff777d 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -78,6 +78,7 @@ obj-$(CONFIG_SCSI_ISCI)		+= isci/
 obj-$(CONFIG_SCSI_IPS)		+= ips.o
 obj-$(CONFIG_SCSI_FDOMAIN)	+= fdomain.o
 obj-$(CONFIG_SCSI_FDOMAIN_PCI)	+= fdomain_pci.o
+obj-$(CONFIG_SCSI_FDOMAIN_ISA)	+= fdomain_isa.o
 obj-$(CONFIG_SCSI_GENERIC_NCR5380) += g_NCR5380.o
 obj-$(CONFIG_SCSI_QLOGIC_FAS)	+= qlogicfas408.o	qlogicfas.o
 obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogicfas408.o
diff --git a/drivers/scsi/fdomain_isa.c b/drivers/scsi/fdomain_isa.c
new file mode 100644
index 000000000000..9f8bf02f175f
--- /dev/null
+++ b/drivers/scsi/fdomain_isa.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/isa.h>
+#include <scsi/scsi_host.h>
+#include "fdomain.h"
+
+#define MAXBOARDS_PARAM 4
+static int io[MAXBOARDS_PARAM] = { 0, 0, 0, 0 };
+module_param_hw_array(io, int, ioport, NULL, 0);
+MODULE_PARM_DESC(io, "base I/O address of controller (0x140, 0x150, 0x160, 0x170)");
+
+static int irq[MAXBOARDS_PARAM] = { 0, 0, 0, 0 };
+module_param_hw_array(irq, int, irq, NULL, 0);
+MODULE_PARM_DESC(irq, "IRQ of controller (0=auto [default])");
+
+static int scsi_id[MAXBOARDS_PARAM] = { 0, 0, 0, 0 };
+module_param_hw_array(scsi_id, int, other, NULL, 0);
+MODULE_PARM_DESC(scsi_id, "SCSI ID of controller (default = 6)");
+
+static unsigned long addresses[] = {
+	0xc8000,
+	0xca000,
+	0xce000,
+	0xde000,
+};
+#define ADDRESS_COUNT ARRAY_SIZE(addresses)
+
+static unsigned short ports[] = { 0x140, 0x150, 0x160, 0x170 };
+#define PORT_COUNT ARRAY_SIZE(ports)
+
+/* This driver works *ONLY* for Future Domain cards using the TMC-1800,
+ * TMC-18C50, or TMC-18C30 chip.  This includes models TMC-1650, 1660, 1670,
+ * and 1680. These are all 16-bit cards.
+ *
+ * The following BIOS signature signatures are for boards which do *NOT*
+ * work with this driver (these TMC-8xx and TMC-9xx boards may work with the
+ * Seagate driver):
+ *
+ * FUTURE DOMAIN CORP. (C) 1986-1988 V4.0I 03/16/88
+ * FUTURE DOMAIN CORP. (C) 1986-1989 V5.0C2/14/89
+ * FUTURE DOMAIN CORP. (C) 1986-1989 V6.0A7/28/89
+ * FUTURE DOMAIN CORP. (C) 1986-1990 V6.0105/31/90
+ * FUTURE DOMAIN CORP. (C) 1986-1990 V6.0209/18/90
+ * FUTURE DOMAIN CORP. (C) 1986-1990 V7.009/18/90
+ * FUTURE DOMAIN CORP. (C) 1992 V8.00.004/02/92
+ *
+ * (The cards which do *NOT* work are all 8-bit cards -- although some of
+ * them have a 16-bit form-factor, the upper 8-bits are used only for IRQs
+ * and are *NOT* used for data. You can tell the difference by following
+ * the tracings on the circuit board -- if only the IRQ lines are involved,
+ * you have a "8-bit" card, and should *NOT* use this driver.)
+ */
+
+static struct signature signatures[] = {
+/*          1         2         3         4         5         6 */
+/* 123456789012345678901234567890123456789012345678901234567890 */
+{ "FUTURE DOMAIN CORP. (C) 1986-1990 1800-V2.07/28/89",	 5, 50,  2,  0, 0 },
+{ "FUTURE DOMAIN CORP. (C) 1986-1990 1800-V1.07/28/89",	 5, 50,  2,  0, 0 },
+{ "FUTURE DOMAIN CORP. (C) 1986-1990 1800-V2.07/28/89", 72, 50,  2,  0, 2 },
+{ "FUTURE DOMAIN CORP. (C) 1986-1990 1800-V2.0",	73, 43,  2,  0, 3 },
+{ "FUTURE DOMAIN CORP. (C) 1991 1800-V2.0.",		72, 39,  2,  0, 4 },
+{ "FUTURE DOMAIN CORP. (C) 1992 V3.00.004/02/92",	 5, 44,  3,  0, 0 },
+{ "FUTURE DOMAIN TMC-18XX (C) 1993 V3.203/12/93",	 5, 44,  3,  2, 0 },
+{ "IBM F1 P2 BIOS v1.0104/29/93",			 5, 28,  3, -1, 0 },
+{ "Future Domain Corp. V1.0008/18/93",			 5, 33,  3,  4, 0 },
+{ "Future Domain Corp. V1.0008/18/93",			26, 33,  3,  4, 1 },
+{ "Adaptec AHA-2920 PCI-SCSI Card",			42, 31,  3, -1, 1 },
+{ "IBM F1 P264/32",					 5, 14,  3, -1, 1 },
+/* This next signature may not be a 3.5 bios */
+{ "Future Domain Corp. V2.0108/18/93",			 5, 33,  3,  5, 0 },
+{ "FUTURE DOMAIN CORP.  V3.5008/18/93",			 5, 34,  3,  5, 0 },
+{ "FUTURE DOMAIN 18c30/18c50/1800 (C) 1994 V3.5",	 5, 44,  3,  5, 0 },
+{ "FUTURE DOMAIN CORP.  V3.6008/18/93",			 5, 34,  3,  6, 0 },
+{ "FUTURE DOMAIN CORP.  V3.6108/18/93",			 5, 34,  3,  6, 0 },
+{ "FUTURE DOMAIN TMC-18XX",				 5, 22, -1, -1, 0 },
+/* Note that the last line will match a "generic" 18XX bios.  Because
+ * Future Domain has changed the host SCSI ID and/or the location of the
+ * geometry information in the on-board RAM area for each of the first
+ * three BIOS's, it is still important to enter a fully qualified
+ * signature in the table for any new BIOS's (after the host SCSI ID and
+ * geometry location are verified).
+ */
+};
+#define SIGNATURE_COUNT ARRAY_SIZE(signatures)
+
+static int fdomain_isa_match(struct device *dev, unsigned int ndev)
+{
+	struct Scsi_Host *sh;
+	int i, base = 0, irq = 0, bios_base = 0;
+	struct signature *sig = NULL;
+	void __iomem *p;
+	static int saved_bios_base;
+	static struct signature *saved_sig;
+
+	if (ndev < ADDRESS_COUNT) {	/* scan supported ISA BIOS addresses */
+		p = ioremap(addresses[ndev], FDOMAIN_BIOS_SIZE);
+		if (!p)
+			return 0;
+		for (i = 0; i < SIGNATURE_COUNT; i++)
+			if (check_signature(p + signatures[i].offset,
+					    signatures[i].signature,
+					    signatures[i].length))
+				break;
+		if (i == SIGNATURE_COUNT)	/* no signature found */
+			goto fail_unmap;
+		if (signatures[i].flag == 1)	/* ignore PCI devices */
+			goto fail_unmap;
+		sig = &signatures[i];
+		bios_base = addresses[ndev];
+		/* read I/O base from BIOS area */
+		if (sig->bios_major == 2) {
+			switch (sig->flag) {
+			case 2:	/* ISA_200S */
+			case 3:	/* ISA_250MG */
+				base = readb(p + 0x1fa2) +
+				      (readb(p + 0x1fa3) << 8);
+				break;
+			case 4:	/* ISA_200S (another one) */
+				base = readb(p + 0x1fa3) +
+				      (readb(p + 0x1fa4) << 8);
+				break;
+			default:
+				base = readb(p + 0x1fcc) +
+				      (readb(p + 0x1fcd) << 8);
+				break;
+			}
+		}
+		iounmap(p);
+		if (!base) {	/* no I/O base in BIOS area */
+			/* save BIOS info for later use in port probing */
+			saved_bios_base = bios_base;
+			saved_sig = sig;
+			return 0;
+		}
+	} else	/* scan supported I/O ports */
+		base = ports[ndev - ADDRESS_COUNT];
+
+	/* use saved BIOS details if present */
+	if (!bios_base && saved_bios_base) {
+		bios_base = saved_bios_base;
+		sig = saved_sig;
+	}
+
+	if (!request_region(base, FDOMAIN_REGION_SIZE, "fdomain_isa"))
+		return 0;
+
+	sh = fdomain_create(base, irq, 0, bios_base, sig, dev);
+	if (!sh) {
+		release_region(base, FDOMAIN_REGION_SIZE);
+		return 0;
+	}
+
+	dev_set_drvdata(dev, sh);
+	return 1;
+fail_unmap:
+	iounmap(p);
+	return 0;
+}
+
+static int fdomain_isa_param_match(struct device *dev, unsigned int ndev)
+{
+	struct Scsi_Host *sh;
+
+	if (!io[ndev])
+		return 0;
+
+	if (!request_region(io[ndev], FDOMAIN_REGION_SIZE, "fdomain_isa")) {
+		dev_err(dev, "base 0x%x already in use", io[ndev]);
+		return 0;
+	}
+
+	sh = fdomain_create(io[ndev], irq[ndev], scsi_id[ndev], 0, NULL, dev);
+	if (!sh) {
+		dev_err(dev, "controller not found at base 0x%x", io[ndev]);
+		release_region(io[ndev], FDOMAIN_REGION_SIZE);
+		return 0;
+	}
+
+	dev_set_drvdata(dev, sh);
+	return 1;
+}
+
+static int fdomain_isa_remove(struct device *dev, unsigned int ndev)
+{
+	struct Scsi_Host *sh = dev_get_drvdata(dev);
+	int base = sh->io_port;
+
+	fdomain_destroy(sh);
+	release_region(base, FDOMAIN_REGION_SIZE);
+	dev_set_drvdata(dev, NULL);
+	return 0;
+}
+
+static struct isa_driver fdomain_isa_driver = {
+	.match		= fdomain_isa_match,
+	.remove		= fdomain_isa_remove,
+	.driver = {
+		.name	= "fdomain_isa",
+		.pm	= FDOMAIN_PM_OPS,
+	},
+};
+
+static int __init fdomain_isa_init(void)
+{
+	int isa_probe_count = ADDRESS_COUNT + PORT_COUNT;
+
+	if (io[0]) {	/* use module parameters if present */
+		fdomain_isa_driver.match = fdomain_isa_param_match;
+		isa_probe_count = MAXBOARDS_PARAM;
+	}
+
+	return isa_register_driver(&fdomain_isa_driver, isa_probe_count);
+}
+
+static void __exit fdomain_isa_exit(void)
+{
+	isa_unregister_driver(&fdomain_isa_driver);
+}
+
+module_init(fdomain_isa_init);
+module_exit(fdomain_isa_exit);
+
+MODULE_AUTHOR("Ondrej Zary, Rickard E. Faith");
+MODULE_DESCRIPTION("Future Domain TMC-16x0 ISA SCSI driver");
+MODULE_LICENSE("GPL");
-- 
Ondrej Zary
