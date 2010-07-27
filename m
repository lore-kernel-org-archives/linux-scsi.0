From: Christoph Hellwig <hch@lst.de>
Subject: [RFC] relaxed barrier semantics
Date: Tue, 27 Jul 2010 18:56:27 +0200
Message-ID: <20100727165627.GA474@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: jaxboe@fusionio.com, tj@kernel.org, James.Bottomley@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, jack@suse.cz, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

I've been dealin with reports of massive slowdowns due to the barrier
option if used with storage arrays that use do not actually have a
volatile write cache.

The reason for that is that sd.c by default sets the ordered mode to
QUEUE_ORDERED_DRAIN when the WCE bit is not set.  This is in accordance
with Documentation/block/barriers.txt but missed out on an important
point: most filesystems (at least all mainstream ones) couldn't care
less about the ordering semantics barrier operations provide.  In fact
they are actively harmful as they cause us to stall the whole I/O
queue while otherwise we'd only have to wait for a rather limited
amount of I/O.

The simplest fix is to not use write barrier for devices that do not
have a volatile write cache, by specifying the nobarrier option.  This
has a huge disadvantage that it requires manual user interaction instead
of simply working out of the box.  There are two better automatic
options:

 (1) if a filesystem detects the QUEUE_ORDERED_DRAIN mode, but doesn't
     actually need the barrier semantics it simply disables all calls
     to blockdev_issue_flush and never sets the REQ_HARDBARRIER flag
     on writes.  This is a relatively safe option, but it requires
     code in all filesystems, as well as in the raid / device mapper
     modules so that they can cope with it.
 (2) never set the QUEUE_ORDERED_DRAIN, and remove the code related to
     it aftet auditing that no filesystem actually relies on this
     behaviour.  Currently the block layer fails REQ_HARDBARRIER
     if QUEUE_ORDERED_NONE is set, so we'd have to fix that as well.
 (3) introduce a new QUEUE_ORDERED_REALLY_NONE which is set by
     drivers that know no barrier handling is needed.  It's equivalent
     to QUEUE_ORDERED_NONE except for not failing barrier requests.

I'm tempted to go for variant (2) above, and could use some help
auditing the filesystems for their use of the barrier semantics.

So far I've only found an explicit depency on this behaviour in
reiserfs, and there's is guarded by the barrier mount option, so
we could easily disable it when we know we don't have the full
barrier semantics.
