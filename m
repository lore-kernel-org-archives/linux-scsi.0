From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch] qlogic: call request_irq with private data
Date: Thu, 23 Oct 2003 23:12:10 -0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031024011210.GE474@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="BI5RvnYi6R4T2M87"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:3341 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261920AbTJXBNP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2003 21:13:15 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-- 
aris


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qlogic-request_irq_with_priv_data.patch"

--- linux/drivers/scsi/qlogicfas.c.orig	2003-10-17 16:49:30.000000000 -0200
+++ linux/drivers/scsi/qlogicfas.c	2003-10-17 16:54:06.000000000 -0200
@@ -650,9 +650,6 @@
 	} else
 		printk(KERN_INFO "Ql: Using preset IRQ %d\n", qlirq);
 
-	if (qlirq >= 0 && !request_irq(qlirq, do_ql_ihandl, 0, "qlogicfas", NULL))
-		host->can_queue = 1;
-
 	hreg = scsi_register(host, 0);	/* no host data */
 	if (!hreg)
 		goto err_release_mem;
@@ -666,12 +663,20 @@
 		"Qlogicfas Driver version 0.46, chip %02X at %03X, IRQ %d, TPdma:%d",
 		qltyp, qbase, qlirq, QL_TURBO_PDMA);
 
+	if (request_irq(qlirq, do_ql_ihandl, 0, "qlogicfas", hreg))
+		goto free_scsi_host;
+
 	return hreg;
 
+free_scsi_host:
+#ifdef PCMCIA
+	scsi_host_put(hreg);
+#else
+	scsi_unregister(hreg);
+#endif
+
 err_release_mem:
 	release_region(qbase, 0x10);
-	if (host->can_queue)
-		free_irq(qlirq, do_ql_ihandl);
 	return NULL;;
 
 }

--BI5RvnYi6R4T2M87--
