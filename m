From: Matthew Wilcox <willy@debian.org>
Subject: Re: Fix for memory leak problem in megaraid2.c /proc entries (fwd)
Date: Thu, 8 Apr 2004 16:38:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040408153835.GC18329@parcelfarce.linux.theplanet.co.uk>
References: <Pine.LNX.4.58.0404081126480.9356@les5.10east.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:16595 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261952AbUDHPig
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 11:38:36 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0404081126480.9356@les5.10east.com>
List-Id: linux-scsi@vger.kernel.org
To: Lester Hightower <hightowe@10east.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Apr 08, 2004 at 11:29:20AM -0400, Lester Hightower wrote:
> This diff fixes a memory leak in megaraid2.c, v2.10.1 (Dec 03, 2003):
> 
> [root@10east scsi]# diff megaraid2.c.MEMORY_LEAK.20040408.lhh megaraid2.c
> 3395c3395,3399
> <       if( channel >= max_channels ) return 0;
> ---
> >       if( channel >= max_channels ) {
> >               pci_free_consistent(pdev, 256, scsi_inq, scsi_inq_dma_handle);
> >               mega_free_inquiry(inquiry, dma_handle, pdev);
> >               return 0;
> >         }

FYI, in future please use diff -u to generate diffs; they are much more
robust and easier to read than the diff default.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
