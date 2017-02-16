From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: hch's native NVMe multipathing [was: Re: [PATCH 1/2] Don't
 blacklist nvme]
Date: Thu, 16 Feb 2017 13:21:29 -0500
Message-ID: <20170216182129.GC12678@redhat.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
 <20170215145617.GA4241@infradead.org>
 <20170216025357.GA9241@redhat.com>
 <20170216142621.GA21972@infradead.org>
 <20170216151337.GA12678@redhat.com>
 <20170216173856.GB17828@localhost.localdomain>
 <1487266648.2612.3.camel@sandisk.com>
 <20170216180742.GC17828@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932423AbdBPSVb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 13:21:31 -0500
Content-Disposition: inline
In-Reply-To: <20170216180742.GC17828@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Feb 16 2017 at  1:07pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> On Thu, Feb 16, 2017 at 05:37:41PM +0000, Bart Van Assche wrote:
> > On Thu, 2017-02-16 at 12:38 -0500, Keith Busch wrote:
> > > Maybe I'm not seeing the bigger picture. Is there some part to multipath
> > > that the kernel is not in a better position to handle?
> > 
> > Does this mean that the code to parse /etc/multipath.conf will be moved into
> > the kernel? Or will we lose the ability to configure the policies that
> > /etc/multipath.conf allows to configure?
> 
> No, I'm just considering the settings for a device that won't work
> at all if multipath.conf is wrong. For example, the uuid attributes,
> path priority, or path checker. These can't be considered configurable
> policies if all but one of them are invalid for a specific device type.
> 
> It shouldn't even be an option to let a user select TUR path checker
> for NVMe, and the only checkers multipath-tools provide that even make
> sense for NVMe are deprecated.

Then undeprecate them.  Decisions like marking a path checker deprecated
were _not_ made with NVMe in mind.  They must predate NVMe.

multipath-tools has tables that specify all the defaults for a given
target backend.  NVMe will just be yet another.  Yes some user _could_
shoot themselves in the foot by overriding the proper configuration but
since when are we motivated by _not_ giving users the power to hang
themselves?

As for configurability (chosing between N valid configs/settings): At
some point the user will want one behaviour vs another.  Thinking
otherwise is just naive.  Think error timeouts, etc.  Any multipath
kernel implementation (which dm-multipath is BTW) will eventually find
itself at a crossroads where the underlying fabric could be tweaked in
different ways.  Thinking you can just hardcode these attributes and
settings is foolish.
