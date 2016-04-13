From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [Lsf] LSF/MM Schedule and improving discard support
Date: Wed, 13 Apr 2016 10:30:37 -0700
Message-ID: <20160413173037.GB14037@birch.djwong.org>
References: <57067F19.3030404@sandisk.com>
 <1460044289.2311.5.camel@linux.vnet.ibm.com>
 <570E6C55.1060003@sandisk.com>
 <yq11t69wkcl.fsf@sermon.lab.mkp.net>
 <570E73D5.3010502@sandisk.com>
 <1460566264.2322.13.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24160 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbcDMRbD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 13:31:03 -0400
Content-Disposition: inline
In-Reply-To: <1460566264.2322.13.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, "lsf@lists.linux-foundation.org" <lsf@lists.linux-foundation.org>

On Wed, Apr 13, 2016 at 09:51:04AM -0700, James Bottomley wrote:
> On Wed, 2016-04-13 at 09:29 -0700, Bart Van Assche wrote:
> > On 04/13/2016 09:21 AM, Martin K. Petersen wrote:
> > > From a filesystem/ioctl perspective, BLKDISCARD is a hint. We
> > > should not be
> > > rounding off or aligning anything.
> > 
> > Hello Martin,
> > 
> > Today if a BLKDISCARD ioctl passes a non-aligned start and/or end 
> > sector to the kernel then the block layer will submit invalid (non
> > -aligned) REQ_DISCARD requests to the block driver the ioctl applies 
> > to. This is not acceptable. Does the above mean that you are 
> > proposing to fail such BLKDISCARD ioctls with an error code?
> 
> The answer would be of course not.  discard is a hint so malformed
> discard gets ignored by the device and success is returned because you
> can't oblige devices to obey hints (that's why they're called hints).

Agree.  For blockdev FALLOC_FL_PUNCH_HOLE I think we can simply check for
logical block size ("lbs") alignment and then pass the request to the
device with the understanding that it can do as it pleases.  We asked the
device to try to deallocate blocks, and perhaps it cannot.

Just to be clear, this only applies to zeroing discard; the "discard and who
knows what you can now read back" thing that nobody likes has been temporarily
wired up to FALLOC_FL_PUNCH_HOLE | FALLOC_FL_NO_HIDE_STALE. :)

> However, the problem of needing a mandatory discard for scrubbing
> blocks is part of the fallocate discussion, I think.

The third fallocate mode (FALLOC_FL_ZERO_RANGE) doesn't fit with the phrase
"mandatory discard for scrubbing blocks", though if one removed "discard" from
that phrase then it would.  The only thing that ZERO_RANGE guarantees is that
subsequent reads return zeroes.  XFS punches the entire range and reallocates
it with unwritten extents; ext4 fills the holes in the range with unwritten
extents and converts real extents to unwritten.  Both also write zeroes to any
part of the range that doesn't align to an FS block.

Yes, I think there are several questions to resolve here for mandatory zeroing
with FALLOC_FL_ZERO_RANGE (summarizing the issues I've come up with so far):

a) Should blockdev fallocate accept byte-granular offset/length arguments, even
if it has to use the page cache to write zeroes to the device?  This is what
file fallocate does today.

b) If blockdev fallocate does impose alignment requirements, should it return
EINVAL to a request that isn't aligned to the logical block size?

c) If a device really really prefers that its requests are aligned to
min_io_size (which can be much larger than the logical block size), should it
reject requests that aren't aligned to min_io?  Or perhaps it should take care
of the alignment problems on its own somehow?

For allocate mode (the thing Mike Snitzer brought up in another thread
yesterday), the alignment problems are much easier because we're allowed to
round the start down and the end up to fit whatever alignment we require.

Should we promote this to a storage track session at LSF next week?

--D

> 
> James
> 
> 
