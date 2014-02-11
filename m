From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 1/2]percpu_ida: fix a live lock
Date: Tue, 11 Feb 2014 01:12:28 -0800
Message-ID: <20140211091228.GA25567@infradead.org>
References: <20140104210804.GA24199@kmo-pixel>
 <20140105131300.GB4186@kernel.org>
 <20140106204641.GB9037@kmo>
 <52CB1783.4050205@kernel.dk>
 <20140106214726.GD9037@kmo>
 <20140209155006.GA16149@dhcp-26-207.brq.redhat.com>
 <20140210103211.GA28396@infradead.org>
 <52F8FDA7.7070809@kernel.dk>
 <20140210224145.GB2362@kmo>
 <52F95B73.7030205@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52F95B73.7030205@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kmo@daterainc.com>, Alexander Gordeev <agordeev@redhat.com>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 10, 2014 at 04:06:27PM -0700, Jens Axboe wrote:
> For the common case, I'd assume that anywhere between 31..256 tags
> is "normal". That's where the majority of devices will end up being,
> largely. So single digits would be an anomaly.

Unfortunately that's not true in SCSI land, where most driver do per-lun
tagging, and the the cmd_per_lun values are very low and very often
single digits, as a simple grep for cmd_per_lun will tell.  Now it might
be that the tag space actually is much bigger in the hardware and the
driver authors for some reason want to limit the number of outstanding
commands, but the interface to the drivers doesn't allow them to express
such a difference at the moment.

> >How about we just make the number of tags that are allowed to be stranded an
> >explicit parameter (somehow) - then it can be up to device drivers to do
> >something sensible with it. Half is probably an ideal default for devices where
> >that works, but this way more constrained devices will be able to futz with it
> >however they want.
> 
> I don't think we should involve device drivers in this, that's
> punting a complicated issue to someone who likely has little idea
> what to do about it. This needs to be handled sensibly in the core,
> not in a device driver. If we can't come up with a sensible
> algorithm to handle this, how can we expect someone writing a device
> driver to do so?

Agreed, punting this to the drivers is a bad idea.  But at least
exposing variable for the allowed tag space and allowed outstanding
commands to be able to make a smarter decision might be a good idea.  On
the other hand this will require us to count the outstanding commands
again, introducing more cachelines touched than nessecary.  To make
things worse for complex topologies like SCSI we might have to limit the
outstanding commands at up to three levels in the hierarchy.
