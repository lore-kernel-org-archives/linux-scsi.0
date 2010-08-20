From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Date: Fri, 20 Aug 2010 15:22:14 +0200
Message-ID: <20100820132214.GA6184@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1281616891-5691-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

FYI: here's a little writeup to document the new cache flushing scheme,
intended to replace Documentation/block/barriers.txt.  Any good
suggestion for a filename in the kernel tree?

---

Explicit volatile write cache control
=====================================

Introduction
------------

Many storage devices, especially in the consumer market, come with volatile
write back caches.  That means the devices signal I/O completion to the
operating system before data actually has hit the physical medium.  This
behavior obviously speeds up various workloads, but it means the operating
system needs to force data out to the physical medium when it performs
a data integrity operation like fsync, sync or an unmount.

The Linux block layer provides a two simple mechanism that lets filesystems
control the caching behavior of the storage device.  These mechanisms are
a forced cache flush, and the Force Unit Access (FUA) flag for requests.


Explicit cache flushes
----------------------

The REQ_FLUSH flag can be OR ed into the r/w flags of a bio submitted from the
filesystem and will make sure the volatile cache of the storage device
has been flushed before the actual I/O operation is started.  The explicit
guarantees write requests that have completed before the bio was submitted
actually are on the physical medium before this request has started.
In addition the REQ_FLUSH flag can be set on an otherwise empty bio
structure, which causes only an explicit cache flush without any dependent
I/O.  It is recommend to use the blkdev_issue_flush() helper for a pure
cache flush.


Forced Unit Access
-----------------

The REQ_FUA flag can be OR ed into the r/w flags of a bio submitted from the
filesystem and will make sure that I/O completion for this requests is not
signaled before the data has made it to non-volatile storage on the
physical medium.


Implementation details for filesystems
--------------------------------------

Filesystem can simply set the REQ_FLUSH and REQ_FUA bits and do not have to
worry if the underlying devices need any explicit cache flushing and how
the Forced Unit Access is implemented.  The REQ_FLUSH and REQ_FUA flags
may both be set on a single bio.


Implementation details for make_request_fn based block drivers
--------------------------------------------------------------

These drivers will always see the REQ_FLUSH and REQ_FUA bits as they sit
directly below the submit_bio interface.  For remapping drivers the REQ_FUA
bits needs to be propagate to underlying devices, and a global flush needs
to be implemented for bios with the REQ_FLUSH bit set.  For real device
drivers that do not have a volatile cache the REQ_FLUSH and REQ_FUA bits
on non-empty bios can simply be ignored, and REQ_FLUSH requests without
data can be completed successfully without doing any work.  Drivers for
devices with volatile caches need to implement the support for these
flags themselves without any help from the block layer.


Implementation details for request_fn based block drivers
--------------------------------------------------------------

For devices that do not support volatile write caches there is no driver
support required, the block layer completes empty REQ_FLUSH requests before
entering the driver and strips off the REQ_FLUSH and REQ_FUA bits from
requests that have a payload.  For device with volatile write caches the
driver needs to tell the block layer that it supports flushing caches by
doing:

	blk_queue_flush(sdkp->disk->queue, REQ_FLUSH);

and handle empty REQ_FLUSH requests in it's prep_fn/request_fn.  Note that
REQ_FLUSH requests with a payload are automatically turned into a sequence
of empty REQ_FLUSH and the actual write by the block layer.  For devices
that also support the FUA bit the block layer needs to be told to pass
through that bit using:

	blk_queue_flush(sdkp->disk->queue, REQ_FLUSH | REQ_FUA);

and handle write requests that have the REQ_FUA bit set properly in it's
prep_fn/request_fn.  If the FUA bit is not natively supported the block
layer turns it into an empty REQ_FLUSH requests after the actual write.
