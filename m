From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] cxgb3i: ref count cdev access to prevent modification
 while in use (v3)
Date: Thu, 11 Aug 2011 15:18:03 -0500
Message-ID: <1313093883.4166.33.camel@mulgrave>
References: <1313086002-23653-1-git-send-email-nhorman@tuxdriver.com>
	 <1313087766.4166.27.camel@mulgrave>
	 <20110811191147.GC23747@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58238 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562Ab1HKUSJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2011 16:18:09 -0400
In-Reply-To: <20110811191147.GC23747@hmsreliant.think-freely.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Divy Le Ray <divy@chelsio.com>, Steve Wise <swise@chelsio.com>, Karen Xie <kxie@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>, "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>

On Thu, 2011-08-11 at 15:11 -0400, Neil Horman wrote:
> On Thu, Aug 11, 2011 at 06:36:10PM +0000, James Bottomley wrote:
> > > +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> > > @@ -1303,9 +1303,13 @@ static void cxgb3i_dev_close(struct t3cdev *t3dev)
> > >  
> > >  	if (!cdev || cdev->flags & CXGBI_FLAG_ADAPTER_RESET) {
> > >  		pr_info("0x%p close, f 0x%x.\n", cdev, cdev ? cdev->flags : 0);
> > > +		if (cdev)
> > > +			cdev_put(cdev);
> > > +		while (cdev && atomic_read(&cdev->use_count.refcount) > 1)
> > > +			msleep(1);
> > 
> > OK, so this was what leapt out the last time as a big no-no.  Firstly,
> > do you really have to wait for destruction?  If so, use a completion.
> > 
> So, this is really the crux of the issue.  I'm sorry If it wasn't sufficiently
> clear in the explination above. Let me try again:
> 
> The root of the problem is the racy assignments of ->lldev in offload_open and
> ofload_close.  cdev->lldev is dereferenced in init_act_open every time a new
> iscsi connection is established.  If we encounter an adapter error and go down
> the cxgb3 EEH path, we wind up in offload_close, which sets->lldev to NULL.  If
> this occurs while a connection is being established in init_act_open, we can get
> a NULL pointer as ->lldev, and we get the oops above.
> 
> So my approach to fix this was to serialize the setting of cdev->lldev to NULL behind
> a guarantee that there are no current users of cdev.  Since the cxgb3i driver
> only grabs cdevs via cxgbi_find_by_lldev or find_by_netdev, a reference count
> seemed like the way to go.  Not sure I could do the same efficiently with a
> completion.

So this basically means you use the above code to hold offload_close()
at cxgb3_remove_clients() until there are no more references ... which
is an undefined length of time.

That's actually rather a horrible hack.

Why does offload_close() have to NULL out tdev->lldev?  Since the model
is effectively refcounted

> I had also thought about moving the NULL setting into part of the release
> routine of kref_put (or previously my raw atomic use), but since that code (or
> the code that accesses it isn't at all serialized with a spinlock, I figured a
> reference count would be more efficient.  It all boils down (In my mind) to the
> fact that we're just modifying a pointer here, not actually dstroying a struct.
> 
> Truthfully, the way this code works probably needs a larger re-working than what
> I'm doing here, given how often I got turned around in it, but I'm nowhere near
> familiar enough with this driver to do that effectively.  I'm just trying to fix
> the oops at hand.

Can't this all be fixed just by making init_act_open() check for a NULL
t3 dev and return error if it is?

This is effectively equivalent to a cancellation path.  Now that's not
always possible, so if it's not possible, the rework would have to
refcount around lldev I think.

James


