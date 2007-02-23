From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [Patch 2/2] cciss: supercedes add shutdown support (replaces reboot notifier)
Date: Fri, 23 Feb 2007 15:44:33 -0600
Message-ID: <20070223214433.GB26058@beardog.cca.cpqcorp.net>
References: <20070223204239.GA10570@beardog.cca.cpqcorp.net> <20070223213236.GA3535@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:52018 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933223AbXBWVof (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Feb 2007 16:44:35 -0500
Content-Disposition: inline
In-Reply-To: <20070223213236.GA3535@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: akpm@osdl.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Feb 23, 2007 at 01:32:36PM -0800, Greg KH wrote:
> On Fri, Feb 23, 2007 at 02:42:39PM -0600, Mike Miller (OS Dev) wrote:
> > Patch 2/2
> > 
> > This patch supercedes yesterdays cciss-shutdown patch. The primary difference is
> > removing __devexit from cciss_remove_one. Instead of create another function I'd
> > rather use the code that was intended to perform the cleanup and cache flush. I've
> > tested as a loadable module and statically linked without error.
> > Please consider this for inclusion.
> > 
> > Signed-off-by: Mike Miller <mike.miller@hp.com>
> > ------------------------------------------------------------------------------------------
> > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> > index 9d84ab3..b16f48c 100644
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -3404,7 +3404,7 @@ #endif
> >  	return -1;
> >  }
> >  
> > -static void __devexit cciss_remove_one(struct pci_dev *pdev)
> > +static void cciss_remove_one(struct pci_dev *pdev)
> >  {
> >  	ctlr_info_t *tmp_ptr;
> >  	int i, j;
> > @@ -3428,9 +3428,10 @@ static void __devexit cciss_remove_one(s
> >  	memset(flush_buf, 0, 4);
> >  	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0, 0, 0, NULL,
> >  			      TYPE_CMD);
> > -	if (return_code != IO_OK) {
> > -		printk(KERN_WARNING "Error Flushing cache on controller %d\n",
> > -		       i);
> > +	if (return_code == IO_OK) {
> > +		printk(KERN_WARNING "Completed flushing cache on controller %d\n", i);
> 
> Why do you want the world to know this on every shutdown?
> 
> At the least, use dev_warn() to show the proper device and driver that
> this is happening to, but does it really need to go to the warning log?
> It sounds like a normal operation to me.  How about dev_dbg() instead?
> 
> thanks,
> 
> greg k-h

OK, here's a version that only prints if a problem occurred. That's the way the code
was originally written.

-- mikem
------------------------------------------------------------------------------------------
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 9d84ab3..c50c09b 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3404,7 +3404,7 @@ #endif
 	return -1;
 }
 
-static void __devexit cciss_remove_one(struct pci_dev *pdev)
+static void cciss_remove_one(struct pci_dev *pdev)
 {
 	ctlr_info_t *tmp_ptr;
 	int i, j;
@@ -3429,8 +3429,7 @@ static void __devexit cciss_remove_one(s
 	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0, 0, 0, NULL,
 			      TYPE_CMD);
 	if (return_code != IO_OK) {
-		printk(KERN_WARNING "Error Flushing cache on controller %d\n",
-		       i);
+		printk(KERN_WARNING "Error flushing cache on controller %d\n", i);
 	}
 	free_irq(hba[i]->intr[2], hba[i]);
 
@@ -3481,6 +3480,7 @@ static struct pci_driver cciss_pci_drive
 	.probe = cciss_init_one,
 	.remove = __devexit_p(cciss_remove_one),
 	.id_table = cciss_pci_device_id,	/* id_table */
+	.shutdown = cciss_remove_one,
 };
 
 /*
