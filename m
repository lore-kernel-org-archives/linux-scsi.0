From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] [SCSI] st.c : fix up log messages format
Date: Tue, 7 Nov 2006 21:56:38 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0611072143560.4373@kai.makisara.local>
References: <20061103092512.88130.qmail@web31807.mail.mud.yahoo.com>
 <20061103133217.GC27140@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kolumbus.fi ([193.229.0.46]:55248 "EHLO mail.kolumbus.fi")
	by vger.kernel.org with ESMTP id S1752474AbWKGT4P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2006 14:56:15 -0500
In-Reply-To: <20061103133217.GC27140@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Luben Tuikov <ltuikov@yahoo.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 3 Nov 2006, Matthew Wilcox wrote:

> On Fri, Nov 03, 2006 at 01:25:12AM -0800, Luben Tuikov wrote:
> >  	sdev_printk(KERN_WARNING, SDp,
> > -		    "Attached scsi tape %s", tape_name(tpnt));
> > -	printk(KERN_WARNING "%s: try direct i/o: %s (alignment %d B)\n",
> > -	       tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
> > -	       queue_dma_alignment(SDp->request_queue) + 1);
> > +		    "Attached scsi tape %s\n", tape_name(tpnt));

This has already been fixed.

> > +	sdev_printk(KERN_WARNING, SDp,
> > +		    "%s: try direct i/o: %s (alignment %d bytes)\n",
> > +		    tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
> > +		    queue_dma_alignment(SDp->request_queue) + 1);
> >  
> 
> I know you didn't change this ... but why are these KERN_WARNING?
> Surely KERN_INFO is more appropriate here?

Historical reasons: I suspected that the default loglevel at that time 
would hide the message from the testers. The classification should have 
been changed long time ago.

Looking at the code, I noticed another place with improper printk class. 
The patch below combines all of these things. Tested in todays git kernel.

--

Printk -> sdev_printk change originally from Luben Tuikov 
<ltuikov@yahoo.com>. Loglevel changes prompted by Matthew Wilcox 
<matthew@wil.cx>. 

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6/drivers/scsi/st.c	2006-10-26 20:20:04.000000000 +0300
+++ linux-2.6-k1/drivers/scsi/st.c	2006-11-07 21:39:10.000000000 +0200
@@ -9,7 +9,7 @@
    Steve Hirsch, Andreas Koppenh"ofer, Michael Leodolter, Eyal Lebedinsky,
    Michael Schaefer, J"org Weule, and Eric Youngdale.
 
-   Copyright 1992 - 2005 Kai Makisara
+   Copyright 1992 - 2006 Kai Makisara
    email Kai.Makisara@kolumbus.fi
 
    Some small formal changes - aeb, 950809
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static const char *verstr = "20050830";
+static const char *verstr = "20061107";
 
 #include <linux/module.h>
 
@@ -999,7 +999,7 @@ static int check_tape(struct scsi_tape *
 			STp->min_block = ((STp->buffer)->b_data[4] << 8) |
 			    (STp->buffer)->b_data[5];
 			if ( DEB( debugging || ) !STp->inited)
-				printk(KERN_WARNING
+				printk(KERN_INFO
                                        "%s: Block limits %d - %d bytes.\n", name,
                                        STp->min_block, STp->max_block);
 		} else {
@@ -1224,7 +1224,7 @@ static int st_flush(struct file *filp, f
 	}
 
 	DEBC( if (STp->nbr_requests)
-		printk(KERN_WARNING "%s: Number of r/w requests %d, dio used in %d, pages %d (%d).\n",
+		printk(KERN_DEBUG "%s: Number of r/w requests %d, dio used in %d, pages %d (%d).\n",
 		       name, STp->nbr_requests, STp->nbr_dio, STp->nbr_pages, STp->nbr_combinable));
 
 	if (STps->rw == ST_WRITING && !STp->pos_unknown) {
@@ -4056,11 +4056,11 @@ static int st_probe(struct device *dev)
 			goto out_free_tape;
 	}
 
-	sdev_printk(KERN_WARNING, SDp,
+	sdev_printk(KERN_NOTICE, SDp,
 		    "Attached scsi tape %s\n", tape_name(tpnt));
-	printk(KERN_WARNING "%s: try direct i/o: %s (alignment %d B)\n",
-	       tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
-	       queue_dma_alignment(SDp->request_queue) + 1);
+	sdev_printk(KERN_INFO, SDp, "%s: try direct i/o: %s (alignment %d B)\n",
+		    tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
+		    queue_dma_alignment(SDp->request_queue) + 1);
 
 	return 0;
 
