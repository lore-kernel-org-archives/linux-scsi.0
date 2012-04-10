From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH] block: Change default IO scheduler to deadline
 except SATA
Date: Tue, 10 Apr 2012 15:11:21 -0400
Message-ID: <20120410191121.GM21801@redhat.com>
References: <20120410133708.GE21801@redhat.com>
 <4F843C17.5050004@kernel.dk>
 <20120410142148.GG21801@redhat.com>
 <20120410151042.GH21801@redhat.com>
 <4F847EC4.7040604@kernel.dk>
 <20120410185318.GL21801@redhat.com>
 <4F848253.6060303@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F848253.6060303@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>, Moyer Jeff Moyer <jmoyer@redhat.com>, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 10, 2012 at 08:56:19PM +0200, Jens Axboe wrote:
> On 2012-04-10 20:53, Vivek Goyal wrote:
> > On Tue, Apr 10, 2012 at 08:41:08PM +0200, Jens Axboe wrote:
> > 
> > [..]
> >>> So we are back to the question of can scsi devices find out if a Lun
> >>> is backed by single disk or multiple disks.
> >>
> >> The cleanest would be to have the driver signal these attributes at
> >> probe time. You could even adjust CFQ properties based on this, driving
> >> the queue depth harder etc. Realistically, going forward, most fast
> >> flash devices will be driven by a noop-like scheduler on multiqueue. So
> >> CPU cost of the IO scheduler can mostly be ignored, since CFQ cost on
> >> even big RAIDs isn't an issue due to the low IOPS rates.
> > 
> > Agreed that on RAID CPU cost is not a problem. Just that idling and low
> > queue depth kills the performance.
> 
> Exactly, and both of these are trivially adjustable as long as we know
> when to do it.
> 
> > So apart from "rotational" if driver can give some hints about underlying
> > devices being RAID (or multi device), it will help. Just that it looks
> > like scsi does not have a way to determine that.
> 
> This sort of thing should be done with a udev rule.

[CCing kay]

Kay does not like the idea of doing something along this line in udev.
He thinks that kernel changes over a period of time making udev rules
stale and hence it should be done in kernel. :-) I think he has had
some not so good experiences in the past.

Though personally I think that anything which is not set in stone should
go to udev. It atleast allows for easy change if user does not like the
setting. (disable the rule, modify the rule etc). And then rules evolve
as things change in kernel.

Anyway, this point can be detabted later once we figure out what's the
set of atrributes to look at.


> It should not be too
> hard to match for the most popular arrays, catching the majority of the
> setups by default. Or you could ask the SCSI folks for some heuristics,
> it's not unlikely that a few different attributes could make that bullet
> proof, pretty much.

I am wondering what will happen to request based multipath targets in
this scheme. There will have to be I guess additional rules to look for
underlying paths and then change the io scheduler accordingly.

CCing linux-scsi, if scsi guys have some ideas on what can we look at to 
determine what scheduler to use.

Thanks
Vivek
