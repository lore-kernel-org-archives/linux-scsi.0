From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Sun, 16 Mar 2008 20:55:04 +0900
Message-ID: <20080316205500I.tomof@acm.org>
References: <20080314183434J.tomof@acm.org>
	<Pine.LNX.4.44L0.0803141036150.4478-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:37847 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYCPL43 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Mar 2008 07:56:29 -0400
In-Reply-To: <Pine.LNX.4.44L0.0803141036150.4478-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, Geert.Uytterhoeven@sonycom.com, tony.luck@intel.com, Mark_Salyzyn@adaptec.com, ed.lin@promise.com, linuxraid@amcc.com, linux-usb@vger.kernel.org

On Fri, 14 Mar 2008 10:46:52 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Fri, 14 Mar 2008, FUJITA Tomonori wrote:
> 
> > > If nents doesn't change then for_each_sg() won't work right.  There 
> > > could be an alternative macro:
> > 
> > Oops, I thought that for_each_sg is defined like:
> > 
> > #define for_each_sg(sglist, sg, nr, __i)	\
> > 	for (__i = 0, sg = (sglist); __i < (nr) && sg; __i++, sg = sg_next(sg))
> > 
> > 
> > > /*
> > >  * Loop over each sg element, stopping at the end of the chain
> > >  */
> > > #define for_each_sg_all(sglist, sg, __i)	\
> > > 	for (__i = 0, sg = (sglist); sg; __i++, sg = sg_next(sg))
> > > 
> > > If you added this macro to include/linux/scatterlist.h and used it
> > > instead of for_each_sg() then you can get rid of nents entirely.  
> > > However I'm not sure whether this would be safe.  Do people sometimes 
> > > use a subset of the entries in a scatterlist?
> > 
> > IIRC, some drivers do that (though they might use sg_next).
> 
> But will usb-storage ever receive a scatterlist like that?  For 
> example, if there are three 4096-byte entries in the list, but the 
> transfer length is 8192 and nents is 2, then there could be a problem.

If LLDs don't use the padding or drain buffer feature (USB uses
neither), scsi midlayer doesn't send such (that is, the block layer
doesn't create such).


> (This could happen if some software layer preallocated an sg chain and
> used it over and over again, each time setting nents to whatever value
> was needed for a particular transfer.)
> 
> > I don't think that we add a new macro just for this function. We could
> > change for_each_sg in the above way or we could just do in
> > usb_stor_access_xfer_buf
> > 
> > for (i = 0, sg = *sgl; i < nents && sg; i++, sg = sg_next(sg))
> 
> This wouldn't be safe in the example I just mentioned if the
> usb-storage driver tried to do three transfers, each of 4096 bytes.  
> All three would succeed, but in fact the third call shouldn't transfer
> any data.

As I explained above, it should be safe with USB. But in general, LLDs
should not rely on a scatterlist about how much data they transfer.
