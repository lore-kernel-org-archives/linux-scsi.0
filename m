From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] sym53c8xx_2 pci_remove cleanup
Date: Fri, 10 Oct 2003 12:36:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031010113636.GX27861@parcelfarce.linux.theplanet.co.uk>
References: <3F847EEB.4060306@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:60394 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262062AbTJJLgk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2003 07:36:40 -0400
Content-Disposition: inline
In-Reply-To: <3F847EEB.4060306@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@debian.org>, James Bottomley <James.Bottomley@steeleye.com>

On Wed, Oct 08, 2003 at 04:17:31PM -0500, Brian King wrote:
> 
> This is a patch to the sym2 driver to properly cleanup midlayer 
> resources both on module unload and pci hot remove.

Here's the patch I currently have in my tree for doing the same thing.
I wanted to test it, but I don't have any machines that don't have their
root on it ... and so far I've failed to set up NFSroot on any of them.

I'm not sure whether it applies to the public tree or not, but it also
handles scsi_add_host() failure.  If it doesn't apply to your tree, let
me know and I'll send you the latest version.

Index: drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c,v
retrieving revision 1.34
diff -u -p -r1.34 sym_glue.c
--- drivers/scsi/sym53c8xx_2/sym_glue.c	21 Sep 2003 04:45:52 -0000	1.34
+++ drivers/scsi/sym53c8xx_2/sym_glue.c	6 Oct 2003 12:09:08 -0000
@@ -1630,8 +1630,8 @@ out_err32:
  *  If all is OK, install interrupt handling and
  *  start the timer daemon.
  */
-static int __devinit 
-sym_attach (struct scsi_host_template *tpnt, int unit, struct sym_device *dev)
+static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
+		int unit, struct sym_device *dev)
 {
 	struct host_data *host_data;
 	struct sym_hcb *np = NULL;
@@ -1821,13 +1821,7 @@ sym_attach (struct scsi_host_template *t
 
 	spin_unlock_irqrestore(instance->host_lock, flags);
 
-	/*
-	 *  Now let the generic SCSI driver
-	 *  look for the SCSI devices on the bus ..
-	 */
-	scsi_add_host(instance, &dev->pdev->dev); /* XXX: handle failure */
-	scsi_scan_host(instance);
-	return 0;
+	return instance;
 
  reset_failed:
 	printf_err("%s: FATAL ERROR: CHECK SCSI BUS - CABLES, "
@@ -1835,13 +1829,13 @@ sym_attach (struct scsi_host_template *t
 	spin_unlock_irqrestore(instance->host_lock, flags);
  attach_failed:
 	if (!instance)
-		return -1;
+		return NULL;
 	printf_info("%s: giving up ...\n", sym_name(np));
 	if (np)
 		sym_free_resources(np);
 	scsi_host_put(instance);
 
-	return -1;
+	return NULL;
  }
 
 
@@ -2180,12 +2174,9 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 
 
 /*
- *  Linux release module stuff.
- *
  *  Called before unloading the module.
  *  Detach the host.
  *  We have to free resources and halt the NCR chip.
- *
  */
 static int __devexit sym_detach(struct sym_hcb *np)
 {
@@ -2194,18 +2185,15 @@ static int __devexit sym_detach(struct s
 	del_timer_sync(&np->s.timer);
 
 	/*
-	 *  Reset NCR chip.
-	 *  We should use sym_soft_reset(), but we donnot want to do 
-	 *  so, since we may not be safe if interrupts occur.
+	 * Reset NCR chip.
+	 * We should use sym_soft_reset(), but we don't want to do 
+	 * so, since we may not be safe if interrupts occur.
 	 */
 	printk("%s: resetting chip\n", sym_name(np));
 	OUTB (nc_istat, SRST);
 	UDELAY (10);
 	OUTB (nc_istat, 0);
 
-	/*
-	 *  Free host resources
-	 */
 	sym_free_resources(np);
 
 	return 1;
@@ -2314,6 +2302,7 @@ static int __devinit sym2_probe(struct p
 {
 	struct sym_device sym_dev;
 	struct sym_nvram nvram;
+	struct Scsi_Host *instance;
 
 	memset(&sym_dev, 0, sizeof(sym_dev));
 	memset(&nvram, 0, sizeof(nvram));
@@ -2332,12 +2321,20 @@ static int __devinit sym2_probe(struct p
 
 	sym_get_nvram(&sym_dev, &nvram);
 
-	if (sym_attach(&sym2_template, attach_count, &sym_dev))
+	instance = sym_attach(&sym2_template, attach_count, &sym_dev);
+	if (!instance)
 		goto free;
 
+	if (scsi_add_host(instance, &pdev->dev))
+		goto detach;
+	scsi_scan_host(instance);
+
 	attach_count++;
+
 	return 0;
 
+ detach:
+	sym_detach(pci_get_drvdata(pdev));
  free:
 	pci_release_regions(pdev);
  disable:
@@ -2347,7 +2344,13 @@ static int __devinit sym2_probe(struct p
 
 static void __devexit sym2_remove(struct pci_dev *pdev)
 {
-	sym_detach(pci_get_drvdata(pdev));
+	struct sym_hcb *np = pci_get_drvdata(pdev);
+	struct Scsi_Host *host = np->s.host;
+
+	scsi_remove_host(host);
+	scsi_host_put(host);
+
+	sym_detach(np);
 
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
