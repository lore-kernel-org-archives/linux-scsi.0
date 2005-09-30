From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [Linux-usb-users] Possible bug in usb storage (2.6.11 kernel)
Date: Fri, 30 Sep 2005 17:48:45 +0100
Message-ID: <20050930164845.GA14585@linux-mips.org>
References: <20050927.234616.36922370.anemo@mba.ocn.ne.jp> <Pine.LNX.4.44L0.0509271120370.5703-100000@iolanthe.rowland.org> <20050929.012705.37532453.anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from extgw-uk.mips.com ([62.254.210.129]:3851 "EHLO
	bacchus.net.dhis.org") by vger.kernel.org with ESMTP
	id S1030370AbVI3QtS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 12:49:18 -0400
Content-Disposition: inline
In-Reply-To: <20050929.012705.37532453.anemo@mba.ocn.ne.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: stern@rowland.harvard.edu, jim.ramsay@gmail.com, mdharm-kernel@one-eyed-alien.net, linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

On Thu, Sep 29, 2005 at 01:27:05AM +0900, Atsushi Nemoto wrote:

> >>>>> On Tue, 27 Sep 2005 11:38:35 -0400 (EDT), Alan Stern <stern@rowland.harvard.edu> said:
> 
> stern> If that is so, it's a bug in linux-mips.  ARCH_KMALLOC_MINALIGN
> stern> is supposed to be at least as large as a cacheline.  See this
> stern> comment in mm/slab.c:
> 
> Thank you for pointing out this.
> 
> Some time ago I also supposed so, but I was told to use
> dma_get_cache_alignment() instead.  The comment was not exist at that
> time...

ARCH_KMALLOC_MINALIGN is set to 8 on MIPS because we used to have 64-bit
members in struct semaphore but on 32-bit kernels kmalloc would return 4-byte
allocated memory only.  Whoops, an ooops ;)  Obviously that's been a thinko
as it was done without consideration for DMA.

Coherent I/O isn't affected, also there are a few R3000-class processors where
8 bytes happens to be just the right value.  For anything else this is a bug
which we probably get away most of the time and the value should would be
the largest size of any cacheline in the cache hierarchy, so upto 128 for some
systems.

  Ralf
