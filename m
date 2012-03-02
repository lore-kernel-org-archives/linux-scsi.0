From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/7] block: Clean up merge logic
Date: Fri, 2 Mar 2012 16:36:16 -0500
Message-ID: <20120302213616.GH26315@redhat.com>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
 <1330658571-12958-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab2CBVgY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Mar 2012 16:36:24 -0500
Content-Disposition: inline
In-Reply-To: <1330658571-12958-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Thu, Mar 01, 2012 at 10:22:45PM -0500, Martin K. Petersen wrote:
> From: "Martin K. Petersen" <martin.petersen@oracle.com>
> 
> Discards were globally marked as mergeable and as a result we had
> several code paths that explicitly disabled merging when discard was
> set. Mark discard requests as unmergable and remove special-casing of
> REQ_DISCARD. The relevant nomerge flags are consolidated in blk_types.h,
> and rq_mergeable() and bio_mergeable() have been modified to use them.
> 
> bio_is_rw() is used in place of bio_has_data() a few places. This is
> done to to distinguish true reads and writes from other fs type requests
> that carry a payload (e.g. WRITE SAME).
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Acked-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-core.c          |   10 +++++-----
>  block/blk-merge.c         |   22 +---------------------
>  block/elevator.c          |    6 ++----
>  include/linux/bio.h       |   23 +++++++++++++++++++++--
>  include/linux/blk_types.h |    4 ++++
>  include/linux/blkdev.h    |   23 +++++++++++------------
>  6 files changed, 44 insertions(+), 44 deletions(-)

While you are removing special casing of REQ_DISCARD, may be following is
also a good candidate.

static inline int blk_do_io_stat(struct request *rq)
{
        return rq->rq_disk &&
               (rq->cmd_flags & REQ_IO_STAT) &&
               (rq->cmd_type == REQ_TYPE_FS ||
                (rq->cmd_flags & REQ_DISCARD));
}

Thanks
Vivek
