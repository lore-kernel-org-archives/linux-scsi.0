From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Potential out-of-bounds access in drivers/scsi/sd.c
Date: Wed, 4 Sep 2013 11:42:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1309041134190.1186-100000@iolanthe.rowland.org>
References: <52274799.4090605@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51455 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964809Ab3IDPmH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2013 11:42:07 -0400
In-Reply-To: <52274799.4090605@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, linux-scsi@vger.kernel.org, richard@r-senior.demon.co.uk, ltuikov@yahoo.com, jbottomley@parallels.com, Andrey Konovalov <andreyknvl@google.com>, Kostya Serebryany <kcc@google.com>

On Wed, 4 Sep 2013, Paolo Bonzini wrote:

> > --- usb-3.11.orig/drivers/scsi/sd.c
> > +++ usb-3.11/drivers/scsi/sd.c
> > @@ -2419,7 +2419,7 @@ sd_read_cache_type(struct scsi_disk *sdk
> >  			}
> >  		}
> >  
> > -		if (modepage == 0x3F) {
> > +		if (modepage == 0x3F || offset + 2 >= len) {
> >  			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
> >  				  "present\n");
> >  			goto defaults;
> 
> If you do this, the buggy "if" becomes dead code (the loop above doesn't
> have any "break", so you know that offset >= len and the new condition
> is always true).
> 
> So the patch does indeed prevent the bug, but the code can be simplified.

That's right.  I didn't realize it at first, but the only way to get 
here is if the next page offset lies beyond the end of the data in the 
buffer.  Therefore the patch can be simplified as follows.

Alan Stern



Index: usb-3.11/drivers/scsi/sd.c
===================================================================
--- usb-3.11.orig/drivers/scsi/sd.c
+++ usb-3.11/drivers/scsi/sd.c
@@ -2419,14 +2419,9 @@ sd_read_cache_type(struct scsi_disk *sdk
 			}
 		}
 
-		if (modepage == 0x3F) {
-			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
-				  "present\n");
-			goto defaults;
-		} else if ((buffer[offset] & 0x3f) != modepage) {
-			sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
-			goto defaults;
-		}
+		sd_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
+		goto defaults;
+
 	Page_found:
 		if (modepage == 8) {
 			sdkp->WCE = ((buffer[offset + 2] & 0x04) != 0);

