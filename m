From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 01/13] aha1542: Stop using scsi_module.c
Date: Mon, 19 Jan 2015 23:37:45 +0100
Message-ID: <1421707077-25291-2-git-send-email-linux@rainbow-software.org>
References: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:44251 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbbASWiL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2015 17:38:11 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YDKxU-0006A4-6m
	for linux-scsi@vger.kernel.org; Mon, 19 Jan 2015 23:38:08 +0100
In-Reply-To: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Convert aha1542 to use scsi_add_host instead of scsi_module.c
Use pnp_driver and isa_driver to manage cards.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |  300 +++++++++++++++++++++++++++---------------------
 drivers/scsi/aha1542.h |    2 +-
 2 files changed, 169 insertions(+), 133 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 770c48d..b7a62da 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -35,7 +35,8 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include <linux/isapnp.h>
+#include <linux/isa.h>
+#include <linux/pnp.h>
 #include <linux/blkdev.h>
 #include <linux/slab.h>
 
@@ -71,7 +72,7 @@
 
 /* Boards 3,4 slots are reserved for ISAPnP scans */
 
-static unsigned int bases[MAXBOARDS] __initdata = {0x330, 0x334, 0, 0};
+static unsigned int bases[MAXBOARDS] = {0x330, 0x334, 0, 0};
 
 /* set by aha1542_setup according to the command line; they also may
    be marked __initdata, but require zero initializers then */
@@ -79,7 +80,7 @@ static unsigned int bases[MAXBOARDS] __initdata = {0x330, 0x334, 0, 0};
 static int setup_called[MAXBOARDS];
 static int setup_buson[MAXBOARDS];
 static int setup_busoff[MAXBOARDS];
-static int setup_dmaspeed[MAXBOARDS] __initdata = { -1, -1, -1, -1 };
+static int setup_dmaspeed[MAXBOARDS] = { -1, -1, -1, -1 };
 
 /*
  * LILO/Module params:  aha1542=<PORTBASE>[,<BUSON>,<BUSOFF>[,<DMASPEED>]]
@@ -103,18 +104,6 @@ static bool isapnp = 0;
 static int aha1542[] = {0x330, 11, 4, -1};
 module_param_array(aha1542, int, NULL, 0);
 module_param(isapnp, bool, 0);
-
-static struct isapnp_device_id id_table[] __initdata = {
-	{
-		ISAPNP_ANY_ID, ISAPNP_ANY_ID,
-		ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1542),
-		0
-	},
-	{0}
-};
-
-MODULE_DEVICE_TABLE(isapnp, id_table);
-
 #else
 static int isapnp = 1;
 #endif
@@ -221,7 +210,7 @@ fail:
 /* Only used at boot time, so we do not need to worry about latency as much
    here */
 
-static int __init aha1542_in(unsigned int base, unchar * cmdp, int len)
+static int aha1542_in(unsigned int base, unchar *cmdp, int len)
 {
 	unsigned long flags;
 
@@ -242,7 +231,7 @@ fail:
 /* Similar to aha1542_in, except that we wait a very short period of time.
    We use this if we know the board is alive and awake, but we are not sure
    if the board will respond to the command we are about to send or not */
-static int __init aha1542_in1(unsigned int base, unchar * cmdp, int len)
+static int aha1542_in1(unsigned int base, unchar *cmdp, int len)
 {
 	unsigned long flags;
 
@@ -314,7 +303,7 @@ static int makecode(unsigned hosterr, unsigned scsierr)
 	return scsierr | (hosterr << 16);
 }
 
-static int __init aha1542_test_port(int bse, struct Scsi_Host *shpnt)
+static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 {
 	unchar inquiry_cmd[] = {CMD_INQUIRY};
 	unchar inquiry_result[4];
@@ -744,7 +733,7 @@ fail:
 	aha1542_intr_reset(bse);
 }
 
-static int __init aha1542_getconfig(int base_io, unsigned char *irq_level, unsigned char *dma_chan, unsigned char *scsi_id)
+static int aha1542_getconfig(int base_io, unsigned char *irq_level, unsigned char *dma_chan, unsigned char *scsi_id)
 {
 	unchar inquiry_cmd[] = {CMD_RETCONF};
 	unchar inquiry_result[3];
@@ -813,7 +802,7 @@ fail:
 /* This function should only be called for 1542C boards - we can detect
    the special firmware settings and unlock the board */
 
-static int __init aha1542_mbenable(int base)
+static int aha1542_mbenable(int base)
 {
 	static unchar mbenable_cmd[3];
 	static unchar mbenable_result[2];
@@ -848,7 +837,7 @@ fail:
 }
 
 /* Query the board to find out if it is a 1542 or a 1740, or whatever. */
-static int __init aha1542_query(int base_io, int *transl)
+static int aha1542_query(int base_io, int *transl)
 {
 	unchar inquiry_cmd[] = {CMD_INQUIRY};
 	unchar inquiry_result[4];
@@ -963,7 +952,7 @@ __setup("aha1542=",do_setup);
 #endif
 
 /* return non-zero on detection */
-static int __init aha1542_detect(struct scsi_host_template * tpnt)
+static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct device *pdev, int indx)
 {
 	unsigned char dma_chan;
 	unsigned char irq_level;
@@ -972,87 +961,18 @@ static int __init aha1542_detect(struct scsi_host_template * tpnt)
 	unsigned int base_io;
 	int trans;
 	struct Scsi_Host *shpnt = NULL;
-	int count = 0;
-	int indx;
 
 	DEB(printk("aha1542_detect: \n"));
 
 	tpnt->proc_name = "aha1542";
 
-#ifdef MODULE
-	bases[0] = aha1542[0];
-	setup_buson[0] = aha1542[1];
-	setup_busoff[0] = aha1542[2];
-	{
-		int atbt = -1;
-		switch (aha1542[3]) {
-		case 5:
-			atbt = 0x00;
-			break;
-		case 6:
-			atbt = 0x04;
-			break;
-		case 7:
-			atbt = 0x01;
-			break;
-		case 8:
-			atbt = 0x02;
-			break;
-		case 10:
-			atbt = 0x03;
-			break;
-		};
-		setup_dmaspeed[0] = atbt;
-	}
-#endif
-
-	/*
-	 *	Hunt for ISA Plug'n'Pray Adaptecs (AHA1535)
-	 */
-
-	if(isapnp)
-	{
-		struct pnp_dev *pdev = NULL;
-		for(indx = 0; indx < ARRAY_SIZE(bases); indx++) {
-			if(bases[indx])
-				continue;
-			pdev = pnp_find_dev(NULL, ISAPNP_VENDOR('A', 'D', 'P'), 
-				ISAPNP_FUNCTION(0x1542), pdev);
-			if(pdev==NULL)
-				break;
-			/*
-			 *	Activate the PnP card
-			 */
-
-			if(pnp_device_attach(pdev)<0)
-				continue;
-
-			if(pnp_activate_dev(pdev)<0) {
-				pnp_device_detach(pdev);
-				continue;
-			}
-
-			if(!pnp_port_valid(pdev, 0)) {
-				pnp_device_detach(pdev);
-				continue;
-			}
-
-			bases[indx] = pnp_port_start(pdev, 0);
-
-			/* The card can be queried for its DMA, we have 
-			   the DMA set up that is enough */
-
-			printk(KERN_INFO "ISAPnP found an AHA1535 at I/O 0x%03X\n", bases[indx]);
-		}
-	}
-	for (indx = 0; indx < ARRAY_SIZE(bases); indx++)
 		if (bases[indx] != 0 && request_region(bases[indx], 4, "aha1542")) {
-			shpnt = scsi_register(tpnt,
+			shpnt = scsi_host_alloc(tpnt,
 					sizeof(struct aha1542_hostdata));
 
 			if(shpnt==NULL) {
 				release_region(bases[indx], 4);
-				continue;
+				return NULL;
 			}
 			if (!aha1542_test_port(bases[indx], shpnt))
 				goto unregister;
@@ -1137,60 +1057,37 @@ fail:
 			HOSTDATA(shpnt)->aha1542_last_mbo_used = (AHA1542_MAILBOXES - 1);
 			memset(HOSTDATA(shpnt)->SCint, 0, sizeof(HOSTDATA(shpnt)->SCint));
 			spin_unlock_irqrestore(&aha1542_lock, flags);
-#if 0
-			DEB(printk(" *** READ CAPACITY ***\n"));
 
-			{
-				unchar buf[8];
-				static unchar cmd[] = { READ_CAPACITY, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
-				int i;
-
-				for (i = 0; i < sizeof(buf); ++i)
-					buf[i] = 0x87;
-				for (i = 0; i < 2; ++i)
-					if (!aha1542_command(i, cmd, buf, sizeof(buf))) {
-						printk(KERN_DEBUG "aha_detect: LU %d sector_size %d device_size %d\n",
-						       i, xscsi2int(buf + 4), xscsi2int(buf));
-					}
+			if (scsi_add_host(shpnt, pdev)) {
+				if (shpnt->dma_channel != 0xff)
+					free_dma(shpnt->dma_channel);
+				free_irq(irq_level, shpnt);
+				goto unregister;
 			}
 
-			DEB(printk(" *** NOW RUNNING MY OWN TEST *** \n"));
+			scsi_scan_host(shpnt);
 
-			for (i = 0; i < 4; ++i) {
-				unsigned char cmd[10];
-				static buffer[512];
-
-				cmd[0] = READ_10;
-				cmd[1] = 0;
-				xany2scsi(cmd + 2, i);
-				cmd[6] = 0;
-				cmd[7] = 0;
-				cmd[8] = 1;
-				cmd[9] = 0;
-				aha1542_command(0, cmd, buffer, 512);
-			}
-#endif
-			count++;
-			continue;
+			return shpnt;
 unregister:
 			release_region(bases[indx], 4);
-			scsi_unregister(shpnt);
-			continue;
+			scsi_host_put(shpnt);
+			return NULL;
 
 		};
 
-	return count;
+	return NULL;
 }
 
 static int aha1542_release(struct Scsi_Host *shost)
 {
+	scsi_remove_host(shost);
 	if (shost->irq)
 		free_irq(shost->irq, shost);
 	if (shost->dma_channel != 0xff)
 		free_dma(shost->dma_channel);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
-	scsi_unregister(shost);
+	scsi_host_put(shost);
 	return 0;
 }
 
@@ -1661,12 +1558,10 @@ static int aha1542_biosparam(struct scsi_device *sdev,
 }
 MODULE_LICENSE("GPL");
 
-
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "aha1542",
 	.name			= "Adaptec 1542",
-	.detect			= aha1542_detect,
-	.release		= aha1542_release,
 	.queuecommand		= aha1542_queuecommand,
 	.eh_device_reset_handler= aha1542_dev_reset,
 	.eh_bus_reset_handler	= aha1542_bus_reset,
@@ -1679,4 +1574,145 @@ static struct scsi_host_template driver_template = {
 	.unchecked_isa_dma	= 1, 
 	.use_clustering		= ENABLE_CLUSTERING,
 };
-#include "scsi_module.c"
+
+static int aha1542_isa_match(struct device *pdev, unsigned int ndev)
+{
+	struct Scsi_Host *sh = aha1542_hw_init(&driver_template, pdev, ndev);
+
+	if (!sh)
+		return 0;
+
+	dev_set_drvdata(pdev, sh);
+	return 1;
+}
+
+static int aha1542_isa_remove(struct device *pdev,
+				    unsigned int ndev)
+{
+	aha1542_release(dev_get_drvdata(pdev));
+	dev_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static struct isa_driver aha1542_isa_driver = {
+	.match		= aha1542_isa_match,
+	.remove		= aha1542_isa_remove,
+	.driver		= {
+		.name	= "aha1542"
+	},
+};
+static int isa_registered;
+
+#ifdef CONFIG_PNP
+static struct pnp_device_id aha1542_pnp_ids[] = {
+	{ .id = "ADP1542" },
+	{ .id = "" }
+};
+MODULE_DEVICE_TABLE(pnp, aha1542_pnp_ids);
+
+static int aha1542_pnp_probe(struct pnp_dev *pdev, const struct pnp_device_id *id)
+{
+	int indx;
+	struct Scsi_Host *sh;
+
+	for (indx = 0; indx < ARRAY_SIZE(bases); indx++) {
+		if (bases[indx])
+			continue;
+
+		if (pnp_activate_dev(pdev) < 0)
+			continue;
+
+		bases[indx] = pnp_port_start(pdev, 0);
+
+		/* The card can be queried for its DMA, we have
+		   the DMA set up that is enough */
+
+		printk(KERN_INFO "ISAPnP found an AHA1535 at I/O 0x%03X\n", bases[indx]);
+	}
+
+	sh = aha1542_hw_init(&driver_template, &pdev->dev, indx);
+	if (!sh)
+		return -ENODEV;
+
+	pnp_set_drvdata(pdev, sh);
+	return 0;
+}
+
+static void aha1542_pnp_remove(struct pnp_dev *pdev)
+{
+	aha1542_release(pnp_get_drvdata(pdev));
+	pnp_set_drvdata(pdev, NULL);
+}
+
+static struct pnp_driver aha1542_pnp_driver = {
+	.name		= "aha1542",
+	.id_table	= aha1542_pnp_ids,
+	.probe		= aha1542_pnp_probe,
+	.remove		= aha1542_pnp_remove,
+};
+static int pnp_registered;
+#endif /* CONFIG_PNP */
+
+static int __init aha1542_init(void)
+{
+	int ret = 0;
+#ifdef MODULE
+	int atbt = -1;
+
+	bases[0] = aha1542[0];
+	setup_buson[0] = aha1542[1];
+	setup_busoff[0] = aha1542[2];
+
+	switch (aha1542[3]) {
+	case 5:
+		atbt = 0x00;
+		break;
+	case 6:
+		atbt = 0x04;
+		break;
+	case 7:
+		atbt = 0x01;
+		break;
+	case 8:
+		atbt = 0x02;
+		break;
+	case 10:
+		atbt = 0x03;
+		break;
+	};
+	setup_dmaspeed[0] = atbt;
+#endif
+
+#ifdef CONFIG_PNP
+	if (isapnp) {
+		ret = pnp_register_driver(&aha1542_pnp_driver);
+		if (!ret)
+			pnp_registered = 1;
+	}
+#endif
+	ret = isa_register_driver(&aha1542_isa_driver, MAXBOARDS);
+	if (!ret)
+		isa_registered = 1;
+
+#ifdef CONFIG_PNP
+	if (pnp_registered)
+		ret = 0;
+#endif
+	if (isa_registered)
+		ret = 0;
+
+	return ret;
+}
+
+static void __exit aha1542_exit(void)
+{
+#ifdef CONFIG_PNP
+	if (pnp_registered)
+		pnp_unregister_driver(&aha1542_pnp_driver);
+#endif
+	if (isa_registered)
+		isa_unregister_driver(&aha1542_isa_driver);
+}
+
+module_init(aha1542_init);
+module_exit(aha1542_exit);
diff --git a/drivers/scsi/aha1542.h b/drivers/scsi/aha1542.h
index b871d2b..76e6abc 100644
--- a/drivers/scsi/aha1542.h
+++ b/drivers/scsi/aha1542.h
@@ -131,7 +131,7 @@ struct ccb {			/* Command Control Block 5.3 */
 				/* REQUEST SENSE */
 };
 
-static int aha1542_detect(struct scsi_host_template *);
+static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct device *pdev, int indx);
 static int aha1542_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 static int aha1542_bus_reset(Scsi_Cmnd * SCpnt);
 static int aha1542_dev_reset(Scsi_Cmnd * SCpnt);
-- 
Ondrej Zary

