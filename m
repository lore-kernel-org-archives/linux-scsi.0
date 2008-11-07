From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 07 Nov 2008 09:56:15 -0600
Message-ID: <1226073375.8030.21.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
	 <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com>
	 <20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com>
	 <20081107144311.GE9543@mit.edu> <4914568A.7090307@redhat.com>
	 <49145E0C.4030705@hp.com> <Pine.LNX.4.64.0811071528190.8115@Nokia-N800-26>
	 <49146031.70003@hp.com>  <20081107154655.GH9543@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081107154655.GH9543@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: jim owens <jowens@hp.com>, David Woodhouse <dwmw2@infradead.org>, Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2008-11-07 at 10:46 -0500, Theodore Tso wrote:
> On Fri, Nov 07, 2008 at 10:35:13AM -0500, jim owens wrote:
> >
> > I'm talking DISK wear not SSD.  The array vendors who are causing
> > this problem are doing petabyte san devices, not SSDs.
> >
> > Rewriting the same sectors causes more bad block remaps
> > until the drive eventually runs out of remap space.
> 
> How much of a disk wear factor is there with modern disk drives?  The
> heads aren't touching the disk, and we have plenty of sectors which
> are constantly getting rewritten with traditional filesystems, with no
> ill effects as far as I know.  For example, FAT filesystems, the
> superblock, block allocation bitmaps all are constantly getting
> rewritten today, and I haven't heard of disk manufacturers complaining
> that this is a horrible thing.

All the evidence so far (the netapp and google et al error analysis
papers) seems to imply that hot rewrite spots don't actually correlate
with failures.  The suspicion is that remapping algorithms are good
enough to hide the problem and even if that is true, it's not something
we need worry about too much.  The other thought is that wear on
spinning media is mechanical rather than electromagnetic, so it doesn't
matter how many times the sector is rewritten but how many times the
head flies over the area (which is something we'll never manage to
control).

James


