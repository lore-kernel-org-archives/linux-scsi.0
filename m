From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch] qlogic: don't use scsi_{register,unregister} for pcmcia
Date: Thu, 23 Oct 2003 23:13:41 -0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031024011341.GF474@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Qz2CZ664xQdCRdPu"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:13837 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261925AbTJXBOn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2003 21:14:43 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>


--Qz2CZ664xQdCRdPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-- 
aris


--Qz2CZ664xQdCRdPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qlogic-pcmcia_uses_scsi_host_alloc.patch"

--- linux/drivers/scsi/qlogicfas.c.orig	2003-10-22 22:25:19.000000000 -0200
+++ linux/drivers/scsi/qlogicfas.c	2003-10-22 21:26:59.000000000 -0200
@@ -650,7 +650,11 @@
 	} else
 		printk(KERN_INFO "Ql: Using preset IRQ %d\n", qlirq);
 
+#ifdef PCMCIA
+	hreg = scsi_host_alloc(host, 0);
+#else
 	hreg = scsi_register(host, 0);	/* no host data */
+#endif
 	if (!hreg)
 		goto err_release_mem;
 	hreg->io_port = qbase;
--- linux/drivers/scsi/pcmcia/qlogic_stub.c.orig	2003-10-20 21:04:02.000000000 -0200
+++ linux/drivers/scsi/pcmcia/qlogic_stub.c	2003-10-22 22:24:34.000000000 -0200
@@ -288,7 +288,7 @@
 	CardServices(ReleaseIO, link->handle, &link->io);
 	CardServices(ReleaseIRQ, link->handle, &link->irq);
 
-	scsi_unregister(info->host);
+	scsi_host_put(info->host);
 
 	link->state &= ~DEV_CONFIG;
 }

--Qz2CZ664xQdCRdPu--
