From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 09/10] Enable clustering and large transfers
Date: Sat, 1 Apr 2006 23:26:20 +0300 (EEST)
Message-ID: <Pine.LNX.4.63.0604012049310.4172@kai.makisara.local>
References: <1143561824404-git-send-email-matthew@wil.cx>
 <Pine.LNX.4.63.0604011656490.10426@kai.makisara.local> <20060401170345.GA4029@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:236 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S932183AbWDAU0b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Apr 2006 15:26:31 -0500
In-Reply-To: <20060401170345.GA4029@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

On Sat, 1 Apr 2006, Christoph Hellwig wrote:

> On Sat, Apr 01, 2006 at 05:35:13PM +0300, Kai Makisara wrote:
> > I have done some more investigation based on the message from Gerard 
> > Roudier that Jens found. I fetched the FreeBSD driver. It had a 
> > work-around for the 896 rev. 1 chips but I did not find that in the Linux 
> > version. The work-around does build two device s/g elements for any 
> > original s/g segment that crosses a 16 MB boundary.
> > 
> > In Linux we can do that by setting the .dma_boundary field in the 
> > scsi_host_template. Would it be an acceptable solution to set the 16 MB 
> > limit for all sym53c8xx adapters? It would take care of the known errata 
> > and Gerards suspicions about possible problems with other chips.
> 
> We can also set the flag in the scsi_host so not all adapters are punished.
> 
Yes, but the question is, do we want to be conservative and set the mask 
for all adapters (including the ones possibly having errata we don't 
know), or less conservative and set it for the ones we know are buggy.

For those who make decisions, below is an attempt at limiting dma only for 
the chip we know is having a problem. Builds and boots (with 53c1010).

Kai

--- linux-2.6.16/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-03-20 23:13:18.000000000 +0200
+++ linux-2.6.16-k1/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-04-01 23:16:04.000000000 +0300
@@ -1576,6 +1576,7 @@ static struct Scsi_Host * __devinit sym_
 	struct host_data *host_data;
 	struct sym_hcb *np = NULL;
 	struct Scsi_Host *instance = NULL;
+	struct sym_chip *chip = &dev->chip;
 	struct pci_dev *pdev = dev->pdev;
 	unsigned long flags;
 	struct sym_fw *fw;
@@ -1712,6 +1713,13 @@ static struct Scsi_Host * __devinit sym_
 	BUG_ON(sym2_transport_template == NULL);
 	instance->transportt	= sym2_transport_template;
 
+	/*
+	 *  Due to errata on the 896 rev. 1 chip, don't allow s/g segments to
+	 *  cross 16 MB boundary
+	 */
+	if (pdev->device == PCI_DEVICE_ID_NCR_53C896 && chip->revision_id < 2)
+		instance->dma_boundary = 0xFFFFFF;
+
 	spin_unlock_irqrestore(instance->host_lock, flags);
 
 	return instance;
@@ -1978,7 +1986,8 @@ static struct scsi_host_template sym2_te
 	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
 	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
 	.this_id		= 7,
-	.use_clustering		= DISABLE_CLUSTERING,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.max_sectors		= 0xFFFF,
 #ifdef SYM_LINUX_PROC_INFO_SUPPORT
 	.proc_info		= sym53c8xx_proc_info,
 	.proc_name		= NAME53C8XX,
