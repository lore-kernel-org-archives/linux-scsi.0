From: Matthew Wilcox <willy@debian.org>
Subject: GFP_DMA Janitation
Date: Sat, 14 Dec 2002 05:35:18 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021214053518.K10991@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Janitors <kernel-janitor-discuss@lists.sourceforge.net>


I know there's a lot of clean-up and janitorial work going on at the
moment, so maybe someone already fixed the bogus uses of GFP_DMA in
drivers/scsi?  For those who're not aware, GFP_DMA is _only_ a flag,
not a full specifier.  ie it should be used as
	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA); 
rather than
	buffer = kmalloc(512, GFP_DMA);
which is how sr.c uses it at present.

Current offenders:

drivers/scsi/aha1542.c:703:             SCpnt->host_scribble = (unsigned char *) kmalloc(512, GFP_DMA);
drivers/scsi/megaraid.c:5020:   _tv = (void *)__get_free_pages(GFP_DMA, order);
drivers/scsi/pluto.c:120:       fcs = (struct ctrl_inquiry *) kmalloc (sizeof (struct ctrl_inquiry) * fcscount, GFP_DMA);
drivers/scsi/sd.c:1124: buffer = kmalloc(512, GFP_DMA);
drivers/scsi/sr.c:596:  buffer = kmalloc(512, GFP_DMA);
drivers/scsi/sr.c:708:  buffer = kmalloc(512, GFP_DMA);
drivers/scsi/sr_ioctl.c:99:             bounce_buffer = (char *) kmalloc(cgc->buflen, GFP_DMA);

The other users of GFP_DMA seem to use it correctly.

BTW, not specifing anything with GFP_DMA leads to the allocation currently
being performed as GFP_ATOMIC, only without the permission to access
the emergency pools.  A terribly risky situation.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
