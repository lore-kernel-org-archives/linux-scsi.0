From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] update qlogic and fdomain drivers to use pcmcia_register_driver
Date: Thu, 27 Mar 2003 16:05:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030327160535.B10288@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.13/drivers/scsi/pcmcia/fdomain_stub.c	Thu Feb 27 12:35:58 2003
+++ edited/drivers/scsi/pcmcia/fdomain_stub.c	Sun Mar 23 22:34:13 2003
@@ -379,26 +379,27 @@
     return 0;
 } /* fdomain_event */
 
-/*====================================================================*/
+static struct pcmcia_driver fdomain_cs_driver = {
+	.owner		= THIS_MODULE,
+	.drv		= {
+		.name	= "fdomain_cs",
+	},
+	.attach		= fdomain_attach,
+	.detach		= fdomain_detach,
+};
 
-static int __init init_fdomain_cs(void) {
-    servinfo_t serv;
-    DEBUG(0, "%s\n", version);
-    CardServices(GetCardServicesInfo, &serv);
-    if (serv.Revision != CS_RELEASE_CODE) {
-	printk(KERN_NOTICE "fdomain_cs: Card Services release "
-	       "does not match!\n");
-	return -1;
-    }
-    register_pccard_driver(&dev_info, &fdomain_attach, &fdomain_detach);
-    return 0;
+static int __init init_fdomain_cs(void)
+{
+	return pcmcia_register_driver(&fdomain_cs_driver);
 }
 
-static void __exit exit_fdomain_cs(void) {
-    DEBUG(0, "fdomain_cs: unloading\n");
-    unregister_pccard_driver(&dev_info);
-    while (dev_list != NULL)
-	fdomain_detach(dev_list);
+static void __exit exit_fdomain_cs(void)
+{
+	pcmcia_unregister_driver(&fdomain_cs_driver);
+
+	/* XXX: this really needs to move into generic code.. */
+	while (dev_list != NULL)
+		fdomain_detach(dev_list);
 }
 
 module_init(init_fdomain_cs);
--- 1.12/drivers/scsi/pcmcia/qlogic_stub.c	Thu Feb 27 12:12:48 2003
+++ edited/drivers/scsi/pcmcia/qlogic_stub.c	Sun Mar 23 22:30:18 2003
@@ -397,25 +397,26 @@
 	return 0;
 }				/* qlogic_event */
 
-/*====================================================================*/
+
+static struct pcmcia_driver qlogic_cs_driver = {
+	.owner		= THIS_MODULE,
+	.drv		= {
+		.name	= "qlogic_cs",
+	},
+	.attach		= qlogic_attach,
+	.detach		= qlogic_detach,
+};
 
 static int __init init_qlogic_cs(void)
 {
-	servinfo_t serv;
-	DEBUG(0, "%s\n", version);
-	CardServices(GetCardServicesInfo, &serv);
-	if (serv.Revision != CS_RELEASE_CODE) {
-		printk(KERN_NOTICE "qlogic_cs: Card Services release " "does not match!\n");
-		return -1;
-	}
-	register_pccard_driver(&dev_info, &qlogic_attach, &qlogic_detach);
-	return 0;
+	return pcmcia_register_driver(&qlogic_cs_driver);
 }
 
 static void __exit exit_qlogic_cs(void)
 {
-	DEBUG(0, "qlogic_cs: unloading\n");
-	unregister_pccard_driver(&dev_info);
+	pcmcia_unregister_driver(&qlogic_cs_driver);
+
+	/* XXX: this really needs to move into generic code.. */
 	while (dev_list != NULL)
 		qlogic_detach(dev_list);
 }
