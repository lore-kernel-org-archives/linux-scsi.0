From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Date: Wed, 29 Jul 2009 21:29:28 +0200
Message-ID: <20090729192928.GA22759@merkur.ravnborg.org>
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site> <20090729162844.GA22561@merkur.ravnborg.org> <1248885456.3900.48.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepb.post.tele.dk ([195.41.46.236]:49605 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbZG2T3a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2009 15:29:30 -0400
Content-Disposition: inline
In-Reply-To: <1248885456.3900.48.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 04:37:36PM +0000, James Bottomley wrote:
> On Wed, 2009-07-29 at 18:28 +0200, Sam Ravnborg wrote:
> > On Wed, Jul 29, 2009 at 08:56:03AM -0500, James Bottomley wrote:
> > > On Wed, 2009-07-29 at 14:11 +0300, Michael S. Tsirkin wrote:
> > > > scsi/scsi.h is exported to userspace, so it should
> > > > use __u8 instead of u8 as other userspace-visible headers do.
> > > 
> > > Actually, can we just put a hold on this until we decide what we're
> > > doing with exporting include/scsi.
> > > 
> > > Arguments so far are
> > > 
> > >      1. Don't export and let glibc supply the headers (as it does now)
> > >      2. Move headers to be exported to include/linux
> > >      3. Take over include/scsi export from glibc: this will necessitate
> > >         comparing our current headers and those of glibc and moving
> > >         stuff around.
> > 
> > 2 + 3...
> > Let include/scsi be kernel internal stuff.
> > And have the exported headers in include/linux.
> 
> I don't quite understand what you're saying here.  I think 2 and 3 are
> either/or options.  Either we move the exported files to include/linux
> or we export from include/scsi.
That we should in any case look at what glibc have defined in
their respective headers when we prepare the kernel versions for export.

> 
> I have to say I don't like option 2 because the breakage is visible to
> user level programs (unless we can persuade glibc people to #include
> <linux/scsi.h> in scsi/scsi.h).

We could turn this the other way around...
glibc could add a wrapper file when they are ready to rely on the kernel
version.
So userspace continue to work independent of glibc using their own set
of headers for scsi or they use the kernel supplied headers via the
wrapper header file . Just an idea.

It would be bad if userspace had to do something strange to pick
up scsi.h in scsi/ for some glibc versions and from linux/ for
other glibc versions.

	Sam
