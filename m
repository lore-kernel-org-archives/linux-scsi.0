From: Chris Mason <chris.mason@oracle.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 15:48:30 -0500
Message-ID: <1226090910.15281.84.camel@think.oraclecorp.com>
References: <1226074002.8030.33.camel@localhost.localdomain>
	 <1226074270.15281.50.camel@think.oraclecorp.com>
	 <1226074710.8030.43.camel@localhost.localdomain>
	 <1226078535.15281.63.camel@think.oraclecorp.com>
	 <4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu>
	 <49148BDF.9050707@redhat.com> <20081107193503.GG29717@mit.edu>
	 <yq1iqqz9uqt.fsf@sermon.lab.mkp.net> <20081107201913.GI29717@mit.edu>
	 <20081107202149.GJ15439@parisc-linux.org>  <4914A492.4080009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:62746 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbYKGUtU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 15:49:20 -0500
In-Reply-To: <4914A492.4080009@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Theodore Tso <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>

On Fri, 2008-11-07 at 15:26 -0500, Ric Wheeler wrote:
> Matthew Wilcox wrote:
> > On Fri, Nov 07, 2008 at 03:19:13PM -0500, Theodore Tso wrote:
> >   
> >> Let's be just a *little* bit fair here.  Suppose we wanted to
> >> implement thin-provisioned disks using devicemapper and LVM; consider
> >> that LVM uses a default PE size of 4M for some very good reasons.
> >> Asking filesystems to be a little smarter about allocation policies so
> >> that we allocate in existing 4M chunks before going onto the next, and
> >> asking the block layer to pool trim requests to 4M chunks is not
> >> totally unreasonable.
> >>
> >> Array vendors use chunk sizes > than typical filesystem chunk sizes
> >> for the same reason that LVM does.  So to say that this is due to
> >> purely a "broken firmware architecture" is a little unfair.
> >>     
> >
> > I think we would have a full-throated discussion about whether the
> > right thing to do was to put the tracking in the block layer or in LVM.
> > Rather similar to what we're doing now, in fact.
> >   
> You definitely could imagine having a device mapper target that could 
> track the discards commands and subsequent writes which would invalidate 
> the previous discards.
> 
> Actually, it would be kind of nice to move all of this away from the 
> file systems entirely.

* Fast
* Crash safe
* Bounded ram usage
* Accurately deliver the trims

Pick any three ;)  If we're dealing with large files, I can see it
working well.  For files that are likely to be smaller than the physical
extent size, you end up with either extra state bits on disk (and
keeping them in sync) or a log structured lvm.

I do agree that an offline tool to account for bytes used would be able
to make up for this, and from a thin provisioning point of view, we
might be better off if we don't accurately deliver all the trims all the
time.

People just use the space again soon anyway, I'd have to guess the
filesystems end up in a steady state outside of special events.

In another email Ted mentions that it makes sense for the FS allocator
to notice we've just freed the last block in an aligned region of size
X, and I'd agree with that.

The trim command we send down when we free the block could just contain
the entire range that is free (and easy for the FS to determine) every
time.

-chris


