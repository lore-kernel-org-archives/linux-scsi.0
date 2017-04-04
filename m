From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [RFC PATCH 0/2] block,scsi: support host-wide tagset
Date: Tue, 4 Apr 2017 08:32:34 -0700
Message-ID: <20170404153234.GA3234@vader>
References: <1491307665-47656-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491307665-47656-1-git-send-email-hare@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Omar Sandoval <osandov@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 04, 2017 at 02:07:43PM +0200, Hannes Reinecke wrote:
> Hi all,
> 
> as discussed recently most existing HBAs have a host-wide tagset which
> does not map easily onto the per-queue tagset model of block mq.
> This patchset implements a flag BLK_MQ_F_GLOBAL_TAGS for block-mq, which
> enables the use of a shared tagset for all hardware queues.
> The second patch adds a flag 'host_tagset' to the SCSI host template,
> which allows drivers to enable the use of the global tagset.
> 
> This patchset probably has some performance implications as
> there is a quite high probability of cache-bouncing when allocating
> tags. Also I'm not quite sure if the implemented tagset sharing
> is the correct way to handle things.
> So this can be considered an RFC.
> 
> As usual, comments and reviews are welcome.

Hi, Hannes,

blk-mq already supports a shared tagset, and scsi-mq already uses that.
When we initialize a request queue, we add it to a tagset with
blk_mq_add_queue_set(), where we automatically mark the tagset as shared
if there is more than one queue using it. What does this do that
BLK_MQ_F_TAG_SHARED doesn't cover?
