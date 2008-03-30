From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 4/5] scsi_debug: support large non-fake virtual disk
Date: Sun, 30 Mar 2008 11:58:29 +0900
Message-ID: <20080330115826G.tomof@acm.org>
References: <1206806398-22205-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1206806398-22205-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<47EE85D9.5070803@torque.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:42811 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbYC3C6k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Mar 2008 22:58:40 -0400
In-Reply-To: <47EE85D9.5070803@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, tomof@acm.org, James.Bottomley@HansenPartnership.com

On Sat, 29 Mar 2008 14:09:29 -0400
Douglas Gilbert <dougg@torque.net> wrote:

> FUJITA Tomonori wrote:
> > Currently, the maximum amount of RAM that scsi_debug can allocate is
> > 4GB. This patch increases it to 2TB; scsi_debug can allocates 2TB
> > memory and export it as if it were 2TB scsi disk.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: Douglas Gilbert <dougg@torque.net>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > ---
> >  drivers/scsi/scsi_debug.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index c98559e..1b6a6d8 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -1949,7 +1949,7 @@ static void __init init_all_queued(void)
> >  }
> >  
> >  static void __init sdebug_build_parts(unsigned char *ramp,
> > -				      unsigned int store_size)
> > +				      unsigned long store_size)
> >  {
> >  	struct partition * pp;
> >  	int starts[SDEBUG_MAX_PARTS + 2];
> > @@ -2476,14 +2476,14 @@ static void do_remove_driverfs_files(void)
> >  
> >  static int __init scsi_debug_init(void)
> >  {
> > -	unsigned int sz;
> > +	unsigned long sz;
> >  	int host_to_add;
> >  	int k;
> >  	int ret;
> >  
> >  	if (scsi_debug_dev_size_mb < 1)
> >  		scsi_debug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
> > -	sz = (unsigned int)scsi_debug_dev_size_mb * 1048576;
> > +	sz = (unsigned long)scsi_debug_dev_size_mb * 1048576;
> >  	sdebug_store_sectors = sz / SECT_SIZE;
> >  	sdebug_capacity = get_sdebug_capacity();
> >  
> 
> Tomo,
> Unsigned long is 32 bits on i386 (and 64 bits in the LP64
> data model). Don't you want 64 bits in all cases? Either
> unsigned long long, uint64_t or one of those crappy
> kernel typedefs for 64 bits.

I don't think that u64 is useful.

scsi_debug uses vmalloc for logical unit's contents. so u32 is large
enough for 32-bit systems.

Even if we change scsi_debug use alloc_pages to allocate multiple
pages, 32-bit systems can have only several GB memory at most. So u32
is large enough for them in most cases. The advantage of vmalloc, a
continuous memory area, making the driver simpler a bit, is nice.

vmalloc takes unsigned long so I changed 'unsigned int' to 'unsigned
long' here.

In the end, you need a 64-bit system if you want scsi_debug use huge
amount memory.
