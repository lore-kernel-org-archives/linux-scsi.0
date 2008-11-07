From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 16:06:22 -0500
Message-ID: <yq1ej1n9rg1.fsf@sermon.lab.mkp.net>
References: <yq1r65na5ll.fsf@sermon.lab.mkp.net>
	<1226074002.8030.33.camel@localhost.localdomain>
	<1226074270.15281.50.camel@think.oraclecorp.com>
	<1226074710.8030.43.camel@localhost.localdomain>
	<1226078535.15281.63.camel@think.oraclecorp.com>
	<4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu>
	<49148BDF.9050707@redhat.com> <20081107193503.GG29717@mit.edu>
	<yq1iqqz9uqt.fsf@sermon.lab.mkp.net> <20081107201913.GI29717@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081107201913.GI29717@mit.edu> (Theodore Tso's message of "Fri\, 7 Nov 2008 15\:19\:13 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ric Wheeler <rwheeler@redhat.com>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Ted" == Theodore Tso <tytso@mit.edu> writes:

Ted> Let's be just a *little* bit fair here.  Suppose we wanted to
Ted> implement thin-provisioned disks using devicemapper and LVM;
Ted> consider that LVM uses a default PE size of 4M for some very good
Ted> reasons.  Asking filesystems to be a little smarter about
Ted> allocation policies so that we allocate in existing 4M chunks
Ted> before going onto the next, and asking the block layer to pool
Ted> trim requests to 4M chunks is not totally unreasonable.

It would also be much easier for the array folks if we never wrote
anything less than 768KB and always on a 768KB boundary.


Ted> Array vendors use chunk sizes > than typical filesystem chunk
Ted> sizes for the same reason that LVM does.  So to say that this is
Ted> due to purely a "broken firmware architecture" is a little
Ted> unfair.

Why?  What is the advantage of doing it in Linux as opposed to in the
array firmware?

The issue at hand here is that we'll be issuing discards/trims/unmaps
and if they don't end up being multiples of 768KB starting on a 768KB
boundary the array is just going to ignore the command.

They expect us to keep track of what's used and what's unused within
that single chunk and let them know when we've completely cleared it
out.

The alternative is to walk the fs metadata occasionally, look for
properly aligned, completely unused chunks and them submit UNMAPs to
the array.  That really seems like 1980's defrag technology to me.

I don't have a problem with arrays user bigger chunk sizes internally.
That's fine.  What I don't see if why we have to carry the burden of
keeping in track of what's being used and what's not based upon some
quasi-random value.  Especially given that the array is going to
silently ignore any UNMAP requests that it doesn't like.

Array folks already have to keep track of their internal virtual to
physical mapping.  Why shouldn't they have to maintain a bitmap or an
extent list as part of their internal metadata?  Why should we have to
carry that burden?

And why would we want to go through all this hassle when it's not a
problem for disks or (so far) for mid-range storage devices that use
exactly the same command set?

What I'm objecting to is not coalescing of discard requests.  Or
laying out filesystems intelligently.  That's fine and I think we
should do it (heck, I'm working on that).  What I'm heavily against is
having Linux carry the burden of keeping state around for stuff that's
really internal to the array firmware.

-- 
Martin K. Petersen	Oracle Linux Engineering
