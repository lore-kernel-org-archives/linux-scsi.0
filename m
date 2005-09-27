From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] Possible bug in usb storage (2.6.11 kernel)
Date: Tue, 27 Sep 2005 11:38:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509271120370.5703-100000@iolanthe.rowland.org>
References: <20050927.234616.36922370.anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964976AbVI0Pih@vger.kernel.org>
In-Reply-To: <20050927.234616.36922370.anemo@mba.ocn.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: jim.ramsay@gmail.com, mdharm-kernel@one-eyed-alien.net, USB users list <linux-usb-users@lists.sourceforge.net>, Kernel development list <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, 27 Sep 2005, Atsushi Nemoto wrote:

> >>>>> On Tue, 27 Sep 2005 10:21:17 -0400 (EDT), Alan Stern <stern@rowland.harvard.edu> said:
> 
> stern> Yes I did.  You can see it at
> stern> https://lists.one-eyed-alien.net/pipermail/usb-storage/2005-September/001953.html
> 
> Thank you.  But 'kmalloc(US_SENSE_SIZE, GFP_KERNEL)' is not enough (at
> least) for MIPS since some MIPS chips have 32 byte cacheline and
> ARCH_KMALLOC_MINALIGN is 8 on linux-mips.
> 
> Using 'max(dma_get_cache_alignment(), US_SENSE_SIZE)' would be OK.

If that is so, it's a bug in linux-mips.  ARCH_KMALLOC_MINALIGN is 
supposed to be at least as large as a cacheline.  See this comment in 
mm/slab.c:

/*
 * Enforce a minimum alignment for the kmalloc caches.
 * Usually, the kmalloc caches are cache_line_size() aligned, except when
 * DEBUG and FORCED_DEBUG are enabled, then they are BYTES_PER_WORD aligned.
 * Some archs want to perform DMA into kmalloc caches and need a guaranteed
 * alignment larger than BYTES_PER_WORD. ARCH_KMALLOC_MINALIGN allows that.
 * Note that this flag disables some debug features.
 */

and also this comment (referring to the kmalloc caches):

		/*
		 * For performance, all the general caches are L1 aligned.
		 * This should be particularly beneficial on SMP boxes, as it
		 * eliminates "false sharing".
		 * Note for systems short on memory removing the alignment will
		 * allow tighter packing of the smaller caches.
		 */

Alan Stern
