From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for
 multimedia devices
Date: Fri, 25 Jan 2013 14:41:59 -0800
Message-ID: <20130125224159.GQ3081@htj.dyndns.org>
References: <20130124225555.GC2373@mtj.dyndns.org>
 <51024FB1.3000206@redhat.com>
 <20130125170434.GC3081@htj.dyndns.org>
 <5102BDD4.2020501@redhat.com>
 <20130125172805.GG3081@htj.dyndns.org>
 <5102C780.3090402@redhat.com>
 <20130125181326.GK3081@htj.dyndns.org>
 <5102D353.8010305@redhat.com>
 <20130125190154.GM3081@htj.dyndns.org>
 <5103080A.4090803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5103080A.4090803@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Hello, Paolo.

On Fri, Jan 25, 2013 at 11:32:42PM +0100, Paolo Bonzini wrote:
> All you can do is use common sense, which says that if a command has
> been in a standard, someone has likely used it.  Of course someone
> _might_ have misused it too, but how likely is that?

So, that's where we differ, I guess.  When it comes to hardware
devices, especially the ones as widely and cheaply deployed as SCSI or
ATA, my common sense screams to stick to what's known to work and
don't venture outside unnecessarily.

> To try and give an answer, I grepped the "unusual" drivers in
> drivers/usb/storage.  All of them seem to use non-standard packets (i.e.
> basically are not SCSI) for their strange stuff, except two:
> initializers.c has one function that sends SCSI command 0xEC,
> realtek_cr.c uses 0xF0, both vendor specific.  So USB firmware writers,
> despite being known for tweaking SCSI standards in many ways, seem to be
> sensible in this respect.

You're grepping for known irregularities which need to be used to make
the device work.  Just read through, say, sd driver code and see how
hard it tries to stick to what's known to work rather than venturing
out to the space allowed by the spec.

The default approach in this area definitely is and should be
conservative in general.

> > I have to say that's an overly optimistic view of the world.  There
> > are even devices puking on receiving SCSI commands in a slightly
> > different sequence than windows sends them out and devices which lock
> > up if you send them enough TURs.
> 
> If it is not used, nobody will use it and setting the bit is effectively
> useless (but harmless too).

No, we don't know it's gonna be harmless.  How do we *know* that
outside of the naive expectation that devices are gonna safely and
sanely ignore things that they don't understand?

> > You would get -EPERM/ACCES whatnot from base OS and you would know the
> > command in use, no?
> 
> Yes, but I would like to avoid many iterations.  I don't have access
> myself to all that software except Windows.

I don't think it's gonna be that many iterations and would much prefer
doing several iterations and having the backing data for each command
added.

Thanks.

-- 
tejun
