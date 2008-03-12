From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Wed, 12 Mar 2008 11:24:21 +0900
Message-ID: <20080312112421X.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.44L0.0803111543220.26916-100000@iolanthe.rowland.org>
	<20080312091400V.fujita.tomonori@lab.ntt.co.jp>
	<20080312092856P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:64513 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYCLC0n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2008 22:26:43 -0400
In-Reply-To: <20080312092856P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: tomof@acm.org, bharrosh@panasas.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, Geert.Uytterhoeven@sonycom.com, tony.luck@intel.com, Mark_Salyzyn@adaptec.com, ed.lin@promise.com, linuxraid@amcc.com, linux-usb@vger.kernel.org

On Wed, 12 Mar 2008 09:28:56 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Wed, 12 Mar 2008 09:14:00 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Tue, 11 Mar 2008 16:09:26 -0400 (EDT)
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > On Tue, 11 Mar 2008, FUJITA Tomonori wrote:
> > > 
> > > > On Mon, 10 Mar 2008 16:10:36 +0200
> > > > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > > 
> > > > > Have you had a look at drivers/usb/storage/protocol.c usb_stor_access_xfer_buf() ?
> > > > > It looks like it could also use these, but there they have a twist where they want
> > > > > to do it in parts. Do you think that the code there could also use the helpers 
> > > > > presented here somehow? (I know that one of the USB guys was asking about it)
> > > > 
> > > > I've not. If the USB people are eager to use the new APIs, I'll try
> > > > though I prefer to keep them simple.
> > > 
> > > It would be great if the code could be removed from usb-storage and put
> > > in a central library.  The problem is, as Boaz mentioned, that some of
> > > the subdrivers need to transfer their data in pieces.
> > 
> > I'm fine with add a trick for USB to the APIs as long as USB people
> > inspect and test the trick ;)
> > 
> > 
> > > It may be that the device is able to send or receive only a few blocks 
> > > at a time, or it may be that the blocks aren't stored in continguous 
> > > locations on the device.  Either way, the drivers need to do multiple 
> > > transfers, each starting from where the previous one left off.
> > > 
> > > It shouldn't be too hard to adjust your code to make this work.  
> > > Instead of passing sgl and nents directly to sg_copy_buffer(), pass a
> > > pointer to a structure containing fields for sgl, nents, n, sg_off, and
> > > sg_copy.  Then the caller could retain the ending values for use in a
> > > later call.
> > > 
> > > Does this sound reasonable?
> > 
> > How about this?
> > 
> > diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> > index a3d567a..8951e3c 100644
> > --- a/include/linux/scatterlist.h
> > +++ b/include/linux/scatterlist.h
> > @@ -213,6 +213,13 @@ int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int, gfp_t,
> >  		     sg_alloc_fn *);
> >  int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
> >  
> > +int sg_copy_buffer(struct scatterlist **sgl, unsigned int nents,
> > +		   unsigned long *offset, void *buf, int buflen, int to_buffer);
> > +int sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
> > +			void *buf, int buflen);
> > +int sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
> > +		      void *buf, int buflen);
> > +
> 
> It enables us to simplify usb_stor_access_xfer_buf like this, I think
> (it's not tested).

I fixed some minor issues (comments, warning, etc) and I've uploaded
the patchset:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git sg-copy

