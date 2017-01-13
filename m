From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/15] dm: remove incomple BLOCK_PC support
Date: Fri, 13 Jan 2017 09:14:16 +0100
Message-ID: <20170113081416.GA26337@lst.de>
References: <1484060780-15592-1-git-send-email-hch@lst.de>
	<1484060780-15592-6-git-send-email-hch@lst.de>
	<20170112010936.GA19953@redhat.com> <20170112080054.GD7567@lst.de>
	<20170112222845.GA25349@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170112222845.GA25349@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 12, 2017 at 05:28:45PM -0500, Mike Snitzer wrote:
> What is "incomplete" about request-based DM's BLOCK_PC support?

BLOCK_PC requests are always aomething issued by the driver itself
(for a broad defintion of the driver, aka everything under the block
layer that works together is a driver for this purpose, e.g. all
of the SCSI subsystem).  If a driver doesn't issue BLOCK_PC
requests itself or through library functions only called from the
driver (e.g. scsi_cmd_ioctl) it is incomplete because it can't
be used.

> I'm also missing how you're saying the new blk-mq request-based DM will
> work with your new model.  I appreciate that we get the request from the
> underlying blk-mq request_queue and it'll be properly sized.  But
> wouldn't we need to pass data back up for these SCSI pass-through
> requests?  So wouldn't the top-level multipath request_queue need to
> setup cmd_size?

As said above - supporting BLOCK_PC for dm does not make sense, as
it's an internal passthrough mechanism for driver internal use.
It just happened we standardized it at the block layer because SCSI
commands are a standard supported by a few different drivers, e.g.
SCSI itself, the old ide code for ATAPI and CCISS and virtio_blk
which primarily are block drivers but allow some SCSI passthrough.

To be honest I'd love to just fold BLOCK_PC into the SCSI layer sooner
or later - the old IDE code and CCISS should die off sooner or later,
and virtio_blk scsi passthrough was a horrible idea to start with
(and I say that as the person who had the idea back then and implemented
it..)

> Sorry for the naive questions (that clearly speak to me not
> understanding how this aspect of the block and SCSI code work).. but I'd
> like to understand where DM will be lacking going forward.

At least in terms of BLOCK_PC nothing will change for dm, the code
was simply dead on arrival.  Maybe I should change the subject
to say that more clearly.
