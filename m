From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [ANNOUNCE] MPT Fusion driver 3.02.06 update
Date: Tue, 26 Oct 2004 13:29:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041026202915.GC3672@sgi.com>
References: <0E3FA95632D6D047BA649F95DAB60E57053AF0CB@exa-atlanta> <20041026171525.GA15153@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:24033 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S261447AbUJZUdF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 16:33:05 -0400
Received: from omx3.sgi.com (omx3-ext.sgi.com [192.48.171.20])
	by zeus.kernel.org (8.12.11/8.11.6) with ESMTP id i9QKX1Ga019241
	for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2004 13:33:01 -0700
Content-Disposition: inline
In-Reply-To: <20041026171525.GA15153@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Moore, Eric Dean" <Emoore@lsil.com>, linux-scsi@vger.kernel.org

On Tue, Oct 26, 2004 at 06:15:25PM +0100, Christoph Hellwig wrote:
> > > hooks it needs (e.g. the sas device list)
> > > 
> > 
> > We have to ship with these IOCTLS. Are there any compromise?
> > Sounds like you shot down my backup idea; e.g putting this code into 
> > seperate file which isn't provided for inclusion, but can be recompiled 
> > to link into mptctl?  I don't think we time to pursue your the idea of 
> > re-invent everything into the sas-transport layer.
> 
> No way.  This is similar to the hbaapi situation with qlogic and emulex.
> If you had worked with us early on on an API like I told you multiple times
> we'd have something sane now.
> 
> Btw, what part of HP badly wants this?  I'm sure Grant and Matthew
> could explain them internally what a bad idea this is.
> 
> >
> > Jeremy Higdon asked me to add this, not SuSE.
> 
> Jeremy, can you make sure SuSE has an uptodate transport attribute
> implementation ?

I doubt it.  It was recently updated from the 2.6.5 to 2.6.9 version,
and I don't think they'll be updating to the 2.6.10 version.

Eric, I guess you'll have to convert to the new 2.6.10 API.  Once
it's in the tree, any API changes should be made for you.  For the
drivers that you deliver (as opposed to the distribution), you can
just #ifdef it out, in much the same way that the drivers on Qlogic's
website have more #ifdefs.

It is annoying to have these API changes come in asynchronously.  I
would have preferred something that didn't break backward compatibility,
but linking it to the target instead of the lun probably doesn't allow
that.  Hopefully it will settle down a bit now.

jeremy
