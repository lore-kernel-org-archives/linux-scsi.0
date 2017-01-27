From: Jens Axboe <axboe@fb.com>
Subject: Re: split scsi passthrough fields out of struct request V2
Date: Fri, 27 Jan 2017 09:11:14 -0700
Message-ID: <20170127161114.GA501@kernel.dk>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485365126-23210-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 25 2017, Christoph Hellwig wrote:
> Hi all,
> 
> this series splits the support for SCSI passthrough commands from the
> main struct request used all over the block layer into a separate
> scsi_request structure that drivers that want to support SCSI passthough
> need to embedded as the first thing into their request-private data,
> similar to how we handle NVMe passthrough commands.
> 
> To support this I've added support for that the private data after
> request structure to the legacy request path instead, so that it can
> be treated the same way as the blk-mq path.  Compare to the current
> scsi_cmnd allocator that actually is a major simplification.
> 
> Changes since V1:
>  - fix handling of a NULL sense pointer in __scsi_execute
>  - clean up handling of the flush flags in the block layer and MD
>  - additional small cleanup in dm-rq

I've queued this up for 4.11. Since some of the patches had dependencies
on changes in master since for-4.11/block was forked, they are sitting
in a separate branch that has both for-4.11/block and v4.10-rc5 pulled
in first. for-next has everything, as usual.

-- 
Jens Axboe

