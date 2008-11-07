From: Theodore Tso <tytso@mit.edu>
Subject: Re: thin provisioned LUN support
Date: Fri, 7 Nov 2008 15:42:20 -0500
Message-ID: <20081107204220.GJ29717@mit.edu>
References: <1226074270.15281.50.camel@think.oraclecorp.com> <1226074710.8030.43.camel@localhost.localdomain> <1226078535.15281.63.camel@think.oraclecorp.com> <4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu> <49148BDF.9050707@redhat.com> <20081107193503.GG29717@mit.edu> <yq1iqqz9uqt.fsf@sermon.lab.mkp.net> <20081107201913.GI29717@mit.edu> <20081107202149.GJ15439@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:47816 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751434AbYKGUm1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 15:42:27 -0500
Content-Disposition: inline
In-Reply-To: <20081107202149.GJ15439@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ric Wheeler <rwheeler@redhat.com>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>

On Fri, Nov 07, 2008 at 01:21:49PM -0700, Matthew Wilcox wrote:
> 
> I think we would have a full-throated discussion about whether the
> right thing to do was to put the tracking in the block layer or in LVM.
> Rather similar to what we're doing now, in fact.

Agreed.  I'm just saying that what the array vendors are pushing for
is not totally unreasonable.  This problem can be separated into two
issues.  One is whether or not trim requests have to be 4 meg (or some
other size substantially bigger than filesystem block size) aligned,
and the other is whether the provisioning chunk size is 4 meg. 

The latter still would most ideally work well with filesystems which
are aware of this fact and try hard to allocate to keep as many 4 meg
chunks as possible completely unused, and to try very hard to allocate
using 4 meg chunks that are already partially unused.

Where the trim request coalescing happens is a more interesting
question.  You can either do it in the filesystem, in the block device
layer, or in the storage arraydevice itself.  One interesting thought
is that perhaps it may actually make more sense to do it in the
filesystem.  Since the filesystem has block allocation data structures
that already tell it which blocks are in use or not, there's no point
replicating that in the data array --- and so the filesystem can
detect when the last 4k block in a 4 meg chunk has been freed, and
then issue the trim request for the 4 meg TRIM/UNMAP request to the
block array.  One advantage of doing it in the filesystem is that the
block allocation data structures are already journaled, and so by
keying this off filesystem's block allocation structures, we won't
lose any potential TRIM requests even across a reboot.  (In contrast,
if the block device or the storage array is managing a list of trim
requests and in hopes of merging enough pieces to cover a 4 meg
aligned TRIM request, the in-memory rbtree is transient and would be
lost if the machine reboots.)

Sure, no filesystemsdo this now, but it's a just a Small Matter of
Programming --- and array vendors like EMC (cough, cough), could
easily pay for some filesystem hackers to implement this for some
popular Linux filesystem.  It could even be a directed funding program
through the Linux Foundation if EMC doesn't feel it has sufficient
people who have expertise in the upstream kernel development process.  :-)

       	   		     	 	  - Ted
