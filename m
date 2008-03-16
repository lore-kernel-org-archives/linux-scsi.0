From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Sun, 16 Mar 2008 13:18:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0803161304240.4171-100000@iolanthe.rowland.org>
References: <20080316205500I.tomof@acm.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080316205500I.tomof@acm.org>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, bharrosh@panasas.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, Geert.Uytterhoeven@sonycom.com, tony.luck@intel.com, Mark_Salyzyn@adaptec.com, ed.lin@promise.com, linuxraid@amcc.com, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 16 Mar 2008, FUJITA Tomonori wrote:

> On Fri, 14 Mar 2008 10:46:52 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Fri, 14 Mar 2008, FUJITA Tomonori wrote:
> > 
> > > > If nents doesn't change then for_each_sg() won't work right.  There 
> > > > could be an alternative macro:
> > > 
> > > Oops, I thought that for_each_sg is defined like:
> > > 
> > > #define for_each_sg(sglist, sg, nr, __i)	\
> > > 	for (__i = 0, sg = (sglist); __i < (nr) && sg; __i++, sg = sg_next(sg))
> > > 
> > > 
> > > > /*
> > > >  * Loop over each sg element, stopping at the end of the chain
> > > >  */
> > > > #define for_each_sg_all(sglist, sg, __i)	\
> > > > 	for (__i = 0, sg = (sglist); sg; __i++, sg = sg_next(sg))
> > > > 
> > > > If you added this macro to include/linux/scatterlist.h and used it
> > > > instead of for_each_sg() then you can get rid of nents entirely.  
> > > > However I'm not sure whether this would be safe.  Do people sometimes 
> > > > use a subset of the entries in a scatterlist?
> > > 
> > > IIRC, some drivers do that (though they might use sg_next).
> > 
> > But will usb-storage ever receive a scatterlist like that?  For 
> > example, if there are three 4096-byte entries in the list, but the 
> > transfer length is 8192 and nents is 2, then there could be a problem.
> 
> If LLDs don't use the padding or drain buffer feature (USB uses
> neither), scsi midlayer doesn't send such (that is, the block layer
> doesn't create such).

Then it should be okay to open-code that loop and test whether sg is 
NULL.

> As I explained above, it should be safe with USB. But in general, LLDs
> should not rely on a scatterlist about how much data they transfer.

True.  Let's add a comment explaining the situation.  For example:

	/* If this routine is called multiple times for a single
	 * scatterlist, the nents value will not be updated properly.
	 * Transfers will stop when the end of the list is reached,
	 * which might not be correct in cases where nents is less than
	 * the actual number of entries in the list.  However, if 
	 * drivers are careful not to use multiple calls to transfer
	 * more data than was requested then this will be safe.
	 */
	for (sg = *sgl; nents > 0 && sg; --nents, sg = sg_next(sg)) {

When this change is made, we will be able to convert usb-storage over 
to using your library routine.

Alan Stern

