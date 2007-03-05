From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [Patch 2/2] cciss: add struct pci_driver shutdown support (replaces reboot notifier)
Date: Mon, 5 Mar 2007 16:06:34 -0600
Message-ID: <20070305220634.GA9002@beardog.cca.cpqcorp.net>
References: <20070223204239.GA10570@beardog.cca.cpqcorp.net> <20070227122634.324fc8b1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:46659 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbXCEWGi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Mar 2007 17:06:38 -0500
Content-Disposition: inline
In-Reply-To: <20070227122634.324fc8b1.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com

On Tue, Feb 27, 2007 at 12:26:34PM -0800, Andrew Morton wrote:
> > On Fri, 23 Feb 2007 14:42:39 -0600 "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> > This patch supercedes yesterdays cciss-shutdown patch. The primary difference is
> > removing __devexit from cciss_remove_one. Instead of create another function I'd
> > rather use the code that was intended to perform the cleanup and cache flush. I've
> > tested as a loadable module and statically linked without error.
> > Please consider this for inclusion.
> 
> Please don't document patches like this.
> 
> The entirety of your changelog and the Subject: are relative to a patch
> which will never hit the mainline git tree.  Put yourself in the position
> of someone reading the git changelogs in a year's time.  They're going to
> be left scratching their heads at the above, aren't they?
> 
> Always include a complete and standalone, not-referential-to-an-old-patch
> changelog in each iteration of a patch.
> 
> Always choose a suitable Subject:
> 
> Yes, it's good to tell us things about how this patch differs from the
> previous one.  That info can be placed after the ^--- which comes after
> your signed-off-by:, or can be placed at the top of the email, as long as
> the full permanent changelog is there too.
> 
> Bottom line: you are submitting code and its documentation into the
> permanent kernel record, not just the mailing list.  Try to make it
> appropriate, thanks.
> 
> 
> Please send a new Subject: and changlog for this patch.
> 
Patch 2/2

This patch adds support for the struct pci_driver shutdown method to cciss. We require
notification of an impending reboot or shutdown so that we can flush the battery
backed write cache (BBWC) on the Smart Array controller.
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
------------------------------------------------------------------------------------------
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 9d84ab3..b16f48c 100644
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
@@ -3428,9 +3428,10 @@ static void __devexit cciss_remove_one(s
 	memset(flush_buf, 0, 4);
 	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0, 0, 0, NULL,
 			      TYPE_CMD);
-	if (return_code != IO_OK) {
-		printk(KERN_WARNING "Error Flushing cache on controller %d\n",
-		       i);
+	if (return_code == IO_OK) {
+		printk(KERN_INFO "Completed flushing cache on controller %d\n", i);
+	} else {
+		printk(KERN_WARNING "Error flushing cache on controller %d\n", i);
 	}
 	free_irq(hba[i]->intr[2], hba[i]);
 
@@ -3481,6 +3482,7 @@ static struct pci_driver cciss_pci_drive
 	.probe = cciss_init_one,
 	.remove = __devexit_p(cciss_remove_one),
 	.id_table = cciss_pci_device_id,	/* id_table */
+	.shutdown = cciss_remove_one,
 };
 
 /*
