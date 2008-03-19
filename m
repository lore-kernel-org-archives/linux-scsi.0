From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Wed, 19 Mar 2008 15:38:18 -0500
Message-ID: <1205959098.11527.51.camel@localhost.localdomain>
References: <20080313210655.GA13468@kroah.com>
	 <1205514958.2904.27.camel@localhost.localdomain>
	 <1205776640.6767.154.camel@localhost.localdomain>
	 <20080319004807.GB8298@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45846 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964774AbYCSUiX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 16:38:23 -0400
In-Reply-To: <20080319004807.GB8298@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org

On Tue, 2008-03-18 at 17:48 -0700, Greg KH wrote:
> On Mon, Mar 17, 2008 at 12:57:20PM -0500, James Bottomley wrote:
> > On Fri, 2008-03-14 at 12:15 -0500, James Bottomley wrote:
> > > On Thu, 2008-03-13 at 14:06 -0700, Greg KH wrote:
> > > > Here's a huge patch from Tony and Kay that converts the scsi layer to
> > > > use struct device instead of class_device.
> > > > 
> > > > It doesn't seem like it could be split up any smaller due to the
> > > > interconectedness of the whole mess, if you have any suggestions
> > > > otherwise, it would be appreciated.
> > > > 
> > > > If you want, I can take this through my tree as it does depend on a
> > > > previous IB patch to make that portion of the patch much smaller.
> > > > 
> > > > After this, all of the class_device code is now finally gone from the
> > > > kernel!
> > > 
> > > Actually, I have it built and running (actually 2.6.25-rc5-mc5 which
> > > includes all the changes in your tree).  Amazingly it's pretty much
> > > fully functional, except ses which seems to have suffered a breakdown in
> > > the way its model works.  I'll see if I can fix it up.
> > > 
> > > Since the patch is separable, it's probably best to take it through the
> > > SCSI tree ... including the infiniband bits that depend on the
> > > iser/iscsi transport classes.  You can give the rest of the infiniband
> > > pieces to roland, since he's got a nasty set of clashes with the
> > > __FUNCTION__->__func__ conversion which I don't want to be responsible
> > > for.
> > 
> > OK, I've changed my mind ... it doesn't really work well without all the
> > rest of the pieces ... plus I think there are going to be merge nasties
> > which I'd rather you sorted out.
> 
> Ok, so what do you want me to do?

Keep the patch in your tree.

>   I can keep the scsi patch and the IB
> patches in my tree and merge them that way, but I think it causes
> problems with your scsi patches.  That will cause the -next and -mm tree
> issues, right?

No, that's what the post-merge tree is below.  Its an unstable (as in
fairly rapidly rebasing) tree built on your quilt that includes all the
device changes.  After you push your gregkh-drivers tree upstream, I'll
rebase it on the final history in Linus tree, and then it should only
have the added SCSI pieces ready for merging.

Any changes that come in which would cause a conflict in the generic
device stuff, we'll force to be rediffed against the post merge tree.
Effectively I'm running two merge window trees now:  scsi-misc-2.6 which
contains all the fixes ready for integration now (and will go at the
start of the merge window) and scsi-post-merge-2.6 which contains
changes dependent on you getting your gregkh-drivers quilt upstream
before it can go.

The only difference between the current post merge tree and the one I
had to run for 2.6.24 is that 2.6.24 was built on Jens block git tree
because of the sg_table changes.  This time I'm building on a quilt,
which makes the tree a bit more difficult to deal with for people
pulling from it.

> > What I'll do is run a scsi-post-merge-2.6 tree here:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-post-merge-2.6.git;a=summary
> > 
> > I've dropped a quasi stable branch from your quilt tree and plumbed it
> > into the -mc tree generation machinery, so it will warn me if you make
> > too radical an alteration to your quilt.
> 
> So I shouldn't drop the patch from my tree?

Correct.

James


