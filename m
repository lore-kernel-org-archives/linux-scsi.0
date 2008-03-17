From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Mon, 17 Mar 2008 12:57:20 -0500
Message-ID: <1205776640.6767.154.camel@localhost.localdomain>
References: <20080313210655.GA13468@kroah.com>
	 <1205514958.2904.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59940 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467AbYCQR5X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 13:57:23 -0400
In-Reply-To: <1205514958.2904.27.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org

On Fri, 2008-03-14 at 12:15 -0500, James Bottomley wrote:
> On Thu, 2008-03-13 at 14:06 -0700, Greg KH wrote:
> > Here's a huge patch from Tony and Kay that converts the scsi layer to
> > use struct device instead of class_device.
> > 
> > It doesn't seem like it could be split up any smaller due to the
> > interconectedness of the whole mess, if you have any suggestions
> > otherwise, it would be appreciated.
> > 
> > If you want, I can take this through my tree as it does depend on a
> > previous IB patch to make that portion of the patch much smaller.
> > 
> > After this, all of the class_device code is now finally gone from the
> > kernel!
> 
> Actually, I have it built and running (actually 2.6.25-rc5-mc5 which
> includes all the changes in your tree).  Amazingly it's pretty much
> fully functional, except ses which seems to have suffered a breakdown in
> the way its model works.  I'll see if I can fix it up.
> 
> Since the patch is separable, it's probably best to take it through the
> SCSI tree ... including the infiniband bits that depend on the
> iser/iscsi transport classes.  You can give the rest of the infiniband
> pieces to roland, since he's got a nasty set of clashes with the
> __FUNCTION__->__func__ conversion which I don't want to be responsible
> for.

OK, I've changed my mind ... it doesn't really work well without all the
rest of the pieces ... plus I think there are going to be merge nasties
which I'd rather you sorted out.

What I'll do is run a scsi-post-merge-2.6 tree here:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-post-merge-2.6.git;a=summary

I've dropped a quasi stable branch from your quilt tree and plumbed it
into the -mc tree generation machinery, so it will warn me if you make
too radical an alteration to your quilt.

Andrew,

you probably won't be able to pull this into -mm without the -mc
machinery, so the best thing will simply to be to pull in the changes
patch here right at the end of the -mm build (the same goes for
linux-next):

http://www.kernel.org/pub/linux/kernel/people/jejb/scsi-post-merge-2.6.diff

It's a roll up patch of only the SCSI pieces.  It's updated every time I
push a patch, so it should always be current.

James


