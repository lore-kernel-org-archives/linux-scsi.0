From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 22/25] block: stop using discards for zeroing
Date: Wed, 05 Apr 2017 07:55:39 -0400
Message-ID: <yq1fuhnrrus.fsf@oracle.com>
References: <20170331163313.31821-1-hch@lst.de>
	<20170331163313.31821-23-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20170331163313.31821-23-hch-jcswGhMUV9g@public.gmane.org> (Christoph Hellwig's message
	of "Fri, 31 Mar 2017 18:33:10 +0200")
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> writes:

> Now that we have REQ_OP_WRITE_ZEROES implemented for all devices that
> support efficient zeroing of devices we can remove the call to

s/of devices/

> blkdev_issue_discard.  This means we only have two ways of zeroing
> left and can simply the code.

simplify

> + *  Note that this function may fail with -EOPNOTSUPP if the driver supports
> + *  efficient zeroing operation, but the device capabilities can only be
> + *  discovered by trial and error.  In this case the caller should call the
> + *  function again, and it will use the fallback path.

Maybe:

"Note that this function may fail with -EOPNOTSUPP if the driver signals
zeroing offload support but the device fails to process the command (for
some devices there is no non-destructive way to verify whether this
operation is actually supported). If -EOPNOTSUPP is returned, the caller
should retry the blkdev_issue_zeroout() and the fallback path will be
used."

Otherwise OK.

Reviewed-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-- 
Martin K. Petersen	Oracle Linux Engineering
