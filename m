From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Correct some mistakes in drivers using the scsi hotplug model
Date: Tue, 31 Jul 2007 06:55:10 -0600
Message-ID: <20070731125510.GN21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40277 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016AbXGaMzM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 08:55:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


A few drivers are doing things like releasing IRQs before calling
scsi_remove_host(), which can lead to some ugly error messages.
Many more drivers are simply forgetting to call scsi_host_put() after
they've finished tearing down their driver structures.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
index 3a80897..6c2d4bb 100644
--- a/drivers/scsi/NCR_D700.c
+++ b/drivers/scsi/NCR_D700.c
@@ -357,6 +357,7 @@ NCR_D700_remove_one(struct Scsi_Host *host)
 	kfree((struct NCR_700_Host_Parameters *)host->hostdata[0]);
 	free_irq(host->irq, host);
 	release_region(host->base, 64);
+	scsi_host_put(host);
 }
 
 static int __devexit
diff --git a/drivers/scsi/NCR_Q720.c b/drivers/scsi/NCR_Q720.c
index a8bbdc2..6f03574 100644
--- a/drivers/scsi/NCR_Q720.c
+++ b/drivers/scsi/NCR_Q720.c
@@ -323,6 +323,7 @@ NCR_Q720_remove_one(struct Scsi_Host *host)
 {
 	scsi_remove_host(host);
 	ncr53c8xx_release(host);
+	scsi_host_put(host);
 }
 
 static int __exit
diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
index 0c758d1..8211225 100644
--- a/drivers/scsi/a4000t.c
+++ b/drivers/scsi/a4000t.c
@@ -105,6 +105,7 @@ static __devexit int a4000t_device_remove(struct device *dev)
 	kfree(hostdata);
 	free_irq(host->irq, host);
 	release_mem_region(A4000T_SCSI_ADDR, 0x1000);
+	scsi_host_put(host);
 
 	return 0;
 }
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 85f2394..27acef4 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -907,6 +907,7 @@ void aha152x_release(struct Scsi_Host *shpnt)
 	if(!shpnt)
 		return;
 
+	scsi_remove_host(shpnt);
 	if (shpnt->irq)
 		free_irq(shpnt->irq, shpnt);
 
@@ -920,7 +921,6 @@ void aha152x_release(struct Scsi_Host *shpnt)
 		pnp_device_detach(HOSTDATA(shpnt)->pnpdev);
 #endif
 
-	scsi_remove_host(shpnt);
 	list_del(&HOSTDATA(shpnt)->host_list);
 	scsi_host_put(shpnt);
 }
diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scsi.c
index cac3540..4865b6a 100644
--- a/drivers/scsi/bvme6000_scsi.c
+++ b/drivers/scsi/bvme6000_scsi.c
@@ -97,6 +97,7 @@ bvme6000_device_remove(struct device *dev)
 	NCR_700_release(host);
 	kfree(hostdata);
 	free_irq(host->irq, host);
+	scsi_host_put(host);
 
 	return 0;
 }
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 4275d1b..82f116a 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -1693,6 +1693,7 @@ static int __devexit ibmmca_remove(struct device *dev)
 	scsi_remove_host(shpnt);
 	release_region(shpnt->io_port, shpnt->n_io_port);
 	free_irq(shpnt->irq, dev);
+	scsi_host_put(shpnt);
 	return 0;
 }
 
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index bb90df8..818459f 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -760,6 +760,7 @@ static void ide_scsi_remove(ide_drive_t *drive)
 	struct ide_scsi_obj *scsi = scsihost_to_idescsi(scsihost);
 	struct gendisk *g = scsi->disk;
 
+	scsi_remove_host(scsihost);
 	ide_proc_unregister_driver(drive, scsi->driver);
 
 	ide_unregister_region(g);
@@ -768,7 +769,6 @@ static void ide_scsi_remove(ide_drive_t *drive)
 	g->private_data = NULL;
 	put_disk(g);
 
-	scsi_remove_host(scsihost);
 	ide_scsi_put(scsi);
 }
 
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 492a51b..eacd666 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -656,6 +656,8 @@ ips_release(struct Scsi_Host *sh)
 
 	METHOD_TRACE("ips_release", 1);
 
+	scsi_remove_host(sh);
+
 	for (i = 0; i < IPS_MAX_ADAPTERS && ips_sh[i] != sh; i++) ;
 
 	if (i == IPS_MAX_ADAPTERS) {
@@ -707,7 +709,6 @@ ips_release(struct Scsi_Host *sh)
 	/* free IRQ */
 	free_irq(ha->irq, ha);
 
-	scsi_remove_host(sh);
 	scsi_host_put(sh);
 
 	ips_released_controllers++;
diff --git a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
index 3126824..4ad3a18 100644
--- a/drivers/scsi/lasi700.c
+++ b/drivers/scsi/lasi700.c
@@ -160,6 +160,7 @@ lasi700_driver_remove(struct parisc_device *dev)
 	free_irq(host->irq, host);
 	iounmap(hostdata->base);
 	kfree(hostdata);
+	scsi_host_put(host);
 
 	return 0;
 }
diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.c
index 1bdddad..131eb4e 100644
--- a/drivers/scsi/mvme16x_scsi.c
+++ b/drivers/scsi/mvme16x_scsi.c
@@ -108,6 +108,7 @@ mvme16x_device_remove(struct device *dev)
 	struct Scsi_Host *host = dev_get_drvdata(dev);
 	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
+	scsi_remove_host(host);
 	/* Disable scsi chip ints */
 	{
 		volatile unsigned long v;
@@ -116,10 +117,10 @@ mvme16x_device_remove(struct device *dev)
 		v &= ~0x10;
 		out_be32(0xfff4202c, v);
 	}
-	scsi_remove_host(host);
 	NCR_700_release(host);
 	kfree(hostdata);
 	free_irq(host->irq, host);
+	scsi_host_put(host);
 
 	return 0;
 }
diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
index 94baca8..1e874f1 100644
--- a/drivers/scsi/qlogicfas.c
+++ b/drivers/scsi/qlogicfas.c
@@ -166,6 +166,7 @@ static int qlogicfas_release(struct Scsi_Host *shost)
 {
 	struct qlogicfas408_priv *priv = get_priv_by_host(shost);
 
+	scsi_remove_host(shost);
 	if (shost->irq) {
 		qlogicfas408_disable_ints(priv);	
 		free_irq(shost->irq, shost);
@@ -174,7 +175,6 @@ static int qlogicfas_release(struct Scsi_Host *shost)
 		free_dma(shost->dma_channel);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
-	scsi_remove_host(shost);
 	scsi_host_put(shost);
 
 	return 0;
diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index d63d229..cb75468 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -165,6 +165,7 @@ sim710_device_remove(struct device *dev)
 	kfree(hostdata);
 	free_irq(host->irq, host);
 	release_region(host->base, 64);
+	scsi_host_put(host);
 	return 0;
 }
 
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 0a6b45b..cc1bcd2 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -127,6 +127,7 @@ static int __exit snirm710_driver_remove(struct platform_device *dev)
 	free_irq(host->irq, host);
 	iounmap(hostdata->base);
 	kfree(hostdata);
+	scsi_host_put(host);
 
 	return 0;
 }
diff --git a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
index 4b5f908..7465b38 100644
--- a/drivers/scsi/zalon.c
+++ b/drivers/scsi/zalon.c
@@ -174,6 +174,7 @@ static int __exit zalon_remove(struct parisc_device *dev)
 	scsi_remove_host(host);
 	ncr53c8xx_release(host);
 	free_irq(dev->irq, host);
+	scsi_host_put(host);
 
 	return 0;
 }
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index c822deb..e3cab87 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -157,6 +157,7 @@ static __devexit void zorro7xx_remove_one(struct zorro_dev *z)
 	NCR_700_release(host);
 	kfree(hostdata);
 	free_irq(host->irq, host);
+	scsi_host_put(host);
 	zorro_release_device(z);
 }
 

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
