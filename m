From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for
 multimedia devices
Date: Fri, 25 Jan 2013 11:01:54 -0800
Message-ID: <20130125190154.GM3081@htj.dyndns.org>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
 <1359039649-17734-7-git-send-email-pbonzini@redhat.com>
 <20130124225555.GC2373@mtj.dyndns.org>
 <51024FB1.3000206@redhat.com>
 <20130125170434.GC3081@htj.dyndns.org>
 <5102BDD4.2020501@redhat.com>
 <20130125172805.GG3081@htj.dyndns.org>
 <5102C780.3090402@redhat.com>
 <20130125181326.GK3081@htj.dyndns.org>
 <5102D353.8010305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5102D353.8010305@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Hey,

On Fri, Jan 25, 2013 at 07:47:47PM +0100, Paolo Bonzini wrote:
> That doesn't happen.  There's plenty of vendor-specific opcodes and mode
> pages, not to mention out-of-band channels, e.g. work directly at the
> USB level like the mode select stuff.
> 
> IIRC IOMEGA ZIP drives had some egregious abuse in READ and WRITE of the
> boot sector, presenting fake partition tables or something like that.
> But it wasn't using strange commands for that.

Some did that at least in ATA.  It was mapping some command to
firmware write.  Given how many USB devices implement SCSI these days,
I wouldn't be too firm with "that doesn't happen".  How can such
all-covering statement be asserted?

> > Another aspect is that sometimes opcodes are recycled and people of
> > course don't try to recycle opcodes which are in wide use.  They
> > choose the ones which failed to gain much traction and became
> > obsolete.  The recycled command might not be suitable for exposing to
> > userland.
> 
> No, that doesn't happen either.  There's plenty of reserved opcodes, and
> this time you can count on the standards people which are more
> reasonable than vendors.

ISTR recycle.  Maybe it was ATA too and SCSI people are better.  I
don't know.

> > So, there are actual costs coming from exposing them, which is fine if
> > the benefit can offset them enough, but what would be the benefit of
> > exposing commands which aren't being used?
> 
> If it is not used, nobody will use it and nothing will break.

I have to say that's an overly optimistic view of the world.  There
are even devices puking on receiving SCSI commands in a slightly
different sequence than windows sends them out and devices which lock
up if you send them enough TURs.

> > , so that doesn't seem like
> > that much of winning to me.  Discovering use cases is actually much
> > easier than finding broken devices for some obscure commands.
> 
> Not if many of your uses are proprietary (Windows, AIX on PPC, z/OS on
> s390, Oracle, SAP, you name it).

You would get -EPERM/ACCES whatnot from base OS and you would know the
command in use, no?

Thanks.

-- 
tejun
