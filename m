From: Lester Hightower <hightowe@10east.com>
Subject: Re: Fix for memory leak problem in megaraid2.c /proc entries (fwd)
Date: Thu, 8 Apr 2004 11:41:56 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404081140530.9356@les5.10east.com>
References: <Pine.LNX.4.58.0404081126480.9356@les5.10east.com>
 <20040408153835.GC18329@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from docs1.10east.com ([63.238.77.220]:5040 "EHLO 10east.com")
	by vger.kernel.org with ESMTP id S261947AbUDHPmE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2004 11:42:04 -0400
In-Reply-To: <20040408153835.GC18329@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org

On Thu, 8 Apr 2004, Matthew Wilcox wrote:

> On Thu, Apr 08, 2004 at 11:29:20AM -0400, Lester Hightower wrote:
> > This diff fixes a memory leak in megaraid2.c, v2.10.1 (Dec 03, 2003):
> >
> > [root@10east scsi]# diff megaraid2.c.MEMORY_LEAK.20040408.lhh megaraid2.c
> > 3395c3395,3399
> > <       if( channel >= max_channels ) return 0;
> > ---
> > >       if( channel >= max_channels ) {
> > >               pci_free_consistent(pdev, 256, scsi_inq, scsi_inq_dma_handle);
> > >               mega_free_inquiry(inquiry, dma_handle, pdev);
> > >               return 0;
> > >         }
>
> FYI, in future please use diff -u to generate diffs; they are much more
> robust and easier to read than the diff default.


Good point.  Sorry about that -- just slipped my mind.

Here it is, BTW:

[root@10east scsi]# diff -u megaraid2.c.MEMORY_LEAK.20040408.lhh megaraid2.c
--- megaraid2.c.MEMORY_LEAK.20040408.lhh        2004-02-18 08:36:31.000000000 -0500
+++ megaraid2.c 2004-04-08 10:52:15.000000000 -0400
@@ -3392,7 +3392,11 @@

        max_channels = adapter->product_info.nchannels;

-       if( channel >= max_channels ) return 0;
+       if( channel >= max_channels ) {
+               pci_free_consistent(pdev, 256, scsi_inq, scsi_inq_dma_handle);
+               mega_free_inquiry(inquiry, dma_handle, pdev);
+               return 0;
+        }

        for( tgt = 0; tgt <= MAX_TARGET; tgt++ ) {


--
Lester
