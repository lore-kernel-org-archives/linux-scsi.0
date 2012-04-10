From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] block: Change default IO scheduler to deadline
 except SATA
Date: Tue, 10 Apr 2012 16:12:34 -0400
Message-ID: <20120410201234.GA8265@redhat.com>
References: <4F843C17.5050004@kernel.dk>
 <20120410142148.GG21801@redhat.com>
 <20120410151042.GH21801@redhat.com>
 <4F847EC4.7040604@kernel.dk>
 <20120410185318.GL21801@redhat.com>
 <4F848253.6060303@kernel.dk>
 <20120410191121.GM21801@redhat.com>
 <4F8487D0.3010503@kernel.dk>
 <CAMM=eLeQzLM3MMHkKk=mVE4O8V+w8vvPbau8A1Z3mme-G4KiLA@mail.gmail.com>
 <4F849045.9070806@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F849045.9070806@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux kernel mailing list <linux-kernel@vger.kernel.org>, Moyer Jeff Moyer <jmoyer@redhat.com>, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 10 2012 at  3:55pm -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 2012-04-10 21:43, Mike Snitzer wrote:
> > I'm still missing your position (other than you now wanting to make it
> > a userspace concern).
> > 
> > Put differently: why should CFQ still be the default?
> > 
> > It is pretty widely held that deadline is the more sane default
> > (multiple distros are now using it, deadline is default for guests,
> > etc).  CFQ has become more niche.  The Linux default really should
> > reflect this.
> > 
> > The only case where defaulting to CFQ seems to make sense is
> > rotational SATA (and USB).
> 
> That's the precisely the reason it should still be the default. The
> default settings should reflect a good user experience out of the box.
> Most desktop machines are still using SATA drives. And even those that
> made the leap to SSD, lots of those are still pretty sucky at high queue
> depths or without read/write separation. So I'm quite sure the default
> still makes a lot of sense.

I agree that a default of CFQ still makes sense for SATA and USB.

But why can't there be multiple defaults?

default: deadline
SATA and USB default: cfq

> Punt tuning to the server side. If you absolutely want the best
> performance out of your _particular_ workload, you are expecting and
> required to tune things anyway. Not just the IO scheduler, but in
> general. You can't make the same requirements for the desktop.

Just because server admins are more used to tuning doesn't mean all
server admins do it -- especially not on first evaluation.

> As to kernel vs user, I just see little reason for doing it in the
> kernel if we can put that policy in user space.

There are distro packages that are shipped to control such knobs,
e.g. tuned.

They don't help _at all_ if the user doesn't know about them.  Knob
tuning is tedious on multiple levels.  Much like this thread ;)
