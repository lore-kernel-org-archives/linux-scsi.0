From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] [2/5] Improve 53c700 /proc/interrupt output
Date: Sun, 20 Mar 2005 20:56:14 -0600
Message-ID: <1111373774.5625.17.camel@mulgrave>
References: <20050319035626.97A54496108@palinux.hppa>
	 <1111247587.5525.7.camel@mulgrave>
	 <20050319162307.GM21986@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:28095 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261486AbVCUC4a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2005 21:56:30 -0500
In-Reply-To: <20050319162307.GM21986@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Matthew Wilcox <willy@parisc-linux.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-03-19 at 16:23 +0000, Matthew Wilcox wrote:
> On Sat, Mar 19, 2005 at 09:53:07AM -0600, James Bottomley wrote:
> > How about I look at abstracting the name so that the glue driver (in
> > your case lasi700) can set the name?
> 
> That would work too ...

OK, how about the attached.  It does what you want for lasi700 and what
I want for NCR_D700 (plus it's actually slightly more efficient for the
D700 interrupts).

James

===== drivers/scsi/53c700.c 1.63 vs edited =====
--- 1.63/drivers/scsi/53c700.c	2005-03-20 10:11:44 -06:00
+++ edited/drivers/scsi/53c700.c	2005-03-20 17:28:01 -06:00
@@ -296,8 +296,7 @@
 
 struct Scsi_Host *
 NCR_700_detect(struct scsi_host_template *tpnt,
-	       struct NCR_700_Host_Parameters *hostdata, struct device *dev,
-	       unsigned long irq, u8 scsi_id)
+	       struct NCR_700_Host_Parameters *hostdata, struct device *dev)
 {
 	dma_addr_t pScript, pSlots;
 	__u8 *memory;
@@ -393,8 +392,6 @@
 	host->unique_id = hostdata->base;
 	host->base = hostdata->base;
 	hostdata->eh_complete = NULL;
-	host->irq = irq;
-	host->this_id = scsi_id;
 	host->hostdata[0] = (unsigned long)hostdata;
 	/* kick the chip */
 	NCR_700_writeb(0xff, host, CTEST9_REG);
@@ -415,28 +412,16 @@
 	/* reset the chip */
 	NCR_700_chip_reset(host);
 
-	if (request_irq(irq, NCR_700_intr, SA_SHIRQ, dev->bus_id, host)) {
-		dev_printk(KERN_ERR, dev, "53c700: irq %lu request failed\n ",
-			   irq);
-		goto out_put_host;
-	}
-
 	if (scsi_add_host(host, dev)) {
 		dev_printk(KERN_ERR, dev, "53c700: scsi_add_host failed\n");
-		goto out_release_irq;
+		scsi_host_put(host);
+		return NULL;
 	}
 
 	spi_signalling(host) = hostdata->differential ? SPI_SIGNAL_HVD :
 		SPI_SIGNAL_SE;
 
 	return host;
-
- out_release_irq:
-	free_irq(irq, host);
- out_put_host:
-	scsi_host_put(host);
-
-	return NULL;
 }
 
 int
===== drivers/scsi/53c700.h 1.22 vs edited =====
--- 1.22/drivers/scsi/53c700.h	2005-03-20 10:11:44 -06:00
+++ edited/drivers/scsi/53c700.h	2005-03-20 17:28:01 -06:00
@@ -60,8 +60,7 @@
 
 /* These are the externally used routines */
 struct Scsi_Host *NCR_700_detect(struct scsi_host_template *,
-		struct NCR_700_Host_Parameters *, struct device *,
-		unsigned long, u8);
+		struct NCR_700_Host_Parameters *, struct device *);
 int NCR_700_release(struct Scsi_Host *host);
 irqreturn_t NCR_700_intr(int, void *, struct pt_regs *);
 
===== drivers/scsi/NCR_D700.c 1.23 vs edited =====
--- 1.23/drivers/scsi/NCR_D700.c	2005-02-26 18:04:25 -06:00
+++ edited/drivers/scsi/NCR_D700.c	2005-03-20 19:40:32 -06:00
@@ -97,6 +97,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mca.h>
+#include <linux/interrupt.h>
 #include <asm/io.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
@@ -168,11 +169,13 @@
 struct NCR_D700_private {
 	struct device		*dev;
 	struct Scsi_Host	*hosts[2];
+	char			name[30];
+	char			pad;
 };
 
 static int 
-NCR_D700_probe_one(struct NCR_D700_private *p, int siop,
-		int irq, int slot, u32 region, int differential)
+NCR_D700_probe_one(struct NCR_D700_private *p, int siop, int irq,
+		   int slot, u32 region, int differential)
 {
 	struct NCR_700_Host_Parameters *hostdata;
 	struct Scsi_Host *host;
@@ -201,18 +204,18 @@
 	NCR_700_set_io_mapped(hostdata);
 
 	/* and register the siop */
-	host = NCR_700_detect(&NCR_D700_driver_template, hostdata,
-			      p->dev, irq,
-			      /* FIXME: read this from SUS */
-			      id_array[slot * 2 + siop]);
+	host = NCR_700_detect(&NCR_D700_driver_template, hostdata, p->dev);
 	if (!host) {
 		ret = -ENOMEM;
 		goto detect_failed;
 	}
 
+	p->hosts[siop] = host;
+	/* FIXME: read this from SUS */
+	host->this_id = id_array[slot * 2 + siop];
+	host->irq = irq;
 	scsi_scan_host(host);
 
-	p->hosts[siop] = host;
 	return 0;
 
  detect_failed:
@@ -223,6 +226,20 @@
 	return ret;
 }
 
+static int
+NCR_D700_intr(int irq, void *data, struct pt_regs *regs)
+{
+	struct NCR_D700_private *p = (struct NCR_D700_private *)data;
+	int i, found = 0;
+
+	for (i = 0; i < 2; i++)
+		if (p->hosts[i] &&
+		    NCR_700_intr(irq, p->hosts[i], regs) == IRQ_HANDLED)
+			found++;
+
+	return found ? IRQ_HANDLED : IRQ_NONE;
+}
+
 /* Detect a D700 card.  Note, because of the setup --- the chips are
  * essentially connectecd to the MCA bus independently, it is easier
  * to set them up as two separate host adapters, rather than one
@@ -301,13 +318,19 @@
 	p = kmalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
+	memset(p, '\0', sizeof(*p));
 	p->dev = dev;
-
+	snprintf(p->name, sizeof(p->name), "D700(%s)", dev->bus_id);
+	if (request_irq(irq, NCR_D700_intr, SA_SHIRQ, p->name, p)) {
+		printk(KERN_ERR "D700: request_irq failed\n");
+		kfree(p);
+		return -EBUSY;
+	}
 	/* plumb in both 700 chips */
 	for (i = 0; i < 2; i++) {
 		int err;
 
-		if ((err = NCR_D700_probe_one(p, i, irq, slot,
+		if ((err = NCR_D700_probe_one(p, i, slot, irq,
 					      offset_addr + (0x80 * i),
 					      differential)) != 0)
 			printk("D700: SIOP%d: probe failed, error = %d\n",
===== drivers/scsi/lasi700.c 1.24 vs edited =====
--- 1.24/drivers/scsi/lasi700.c	2005-03-18 07:03:01 -06:00
+++ edited/drivers/scsi/lasi700.c	2005-03-20 20:51:59 -06:00
@@ -127,16 +127,23 @@
 
 	NCR_700_set_mem_mapped(hostdata);
 
-	host = NCR_700_detect(&lasi700_template, hostdata, &dev->dev,
-			      dev->irq, 7);
+	host = NCR_700_detect(&lasi700_template, hostdata, &dev->dev);
 	if (!host)
 		goto out_kfree;
+	host->this_id = 7;
+	host->irq = dev->irq;
+	if(request_irq(dev->irq, NCR_700_intr, SA_SHIRQ, "lasi700", host)) {
+		printk(KERN_ERR "lasi700: request_irq failed!\n");
+		goto out_put_host;
+	}
 
 	dev_set_drvdata(&dev->dev, host);
 	scsi_scan_host(host);
 
 	return 0;
 
+ out_put_host:
+	scsi_host_put(host);
  out_kfree:
 	iounmap(hostdata->base);
 	kfree(hostdata);
===== drivers/scsi/sim710.c 1.26 vs edited =====
--- 1.26/drivers/scsi/sim710.c	2004-11-13 18:28:48 -06:00
+++ edited/drivers/scsi/sim710.c	2005-03-20 19:23:49 -06:00
@@ -127,16 +127,24 @@
 	NCR_700_set_io_mapped(hostdata);
 
 	/* and register the chip */
-	if((host = NCR_700_detect(&sim710_driver_template, hostdata, dev, irq,
-				  scsi_id)) == NULL) {
+	if((host = NCR_700_detect(&sim710_driver_template, hostdata, dev))
+	   == NULL) {
 		printk(KERN_ERR "sim710: No host detected; card configuration problem?\n");
 		goto out_release;
 	}
+	host->this_id = scsi_id;
+	host->irq = irq;
+	if (request_irq(irq, NCR_700_intr, SA_SHIRQ, "sim710", host)) {
+		printk(KERN_ERR "sim710: request_irq failed\n");
+		goto out_put_host;
+	}
 
 	scsi_scan_host(host);
 
 	return 0;
 
+ out_put_host:
+	scsi_host_put(host);
  out_release:
 	release_region(host->base, 64);
  out_free:


