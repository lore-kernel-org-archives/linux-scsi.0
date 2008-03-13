From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Thu, 13 Mar 2008 14:32:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0803131420090.5744-100000@iolanthe.rowland.org>
References: <20080313085733M.tomof@acm.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080313085733M.tomof@acm.org>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, Geert.Uytterhoeven@sonycom.com, tony.luck@intel.com, Mark_Salyzyn@adaptec.com, ed.lin@promise.com, linuxraid@amcc.com, linux-usb@vger.kernel.orgfujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Thu, 13 Mar 2008, FUJITA Tomonori wrote:

> > > +	for_each_sg(*sgl, sg, nents, i) {
> > 
> > Will there be a problem in subsequent calls if *sgl has been
> > incremented but nents hasn't been changed?  Maybe nents needs to be a 
> > pointer also.
> 
> usb_stor_access_xfer_buf doesn't check scsi_sg_count (the number of sg
> entries). It assumes that callers take care about the issue.
> 
> If you want nents to be a pointer, I'm fine with it.

If nents doesn't change then for_each_sg() won't work right.  There 
could be an alternative macro:

/*
 * Loop over each sg element, stopping at the end of the chain
 */
#define for_each_sg_all(sglist, sg, __i)	\
	for (__i = 0, sg = (sglist); sg; __i++, sg = sg_next(sg))

If you added this macro to include/linux/scatterlist.h and used it
instead of for_each_sg() then you can get rid of nents entirely.  
However I'm not sure whether this would be safe.  Do people sometimes 
use a subset of the entries in a scatterlist?

If it isn't safe then nents would have to be passed as a pointer too.  
At this stage I think it would be better to encapsulate sgl, offset, 
and nents in a single structure than to pass multiple pointers.

Alan Stern

