From: Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 22/23] drbd: implement REQ_OP_WRITE_ZEROES
Date: Thu, 30 Mar 2017 12:06:41 +0200
Message-ID: <20170330100641.GI5939@soda.linbit>
References: <20170323143341.31549-1-hch@lst.de>
	<20170323143341.31549-23-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170323143341.31549-23-hch-jcswGhMUV9g@public.gmane.org>
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
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 23, 2017 at 10:33:40AM -0400, Christoph Hellwig wrote:
> It seems like DRBD assumes its on the wire TRIM request always zeroes data.
> Use that fact to implement REQ_OP_WRITE_ZEROES.
> 
> XXX: will need a careful audit from the drbd team!

Thanks, this one looks ok to me.

The real question for me is, will the previous one (21/23)
return != 0 (some EOPNOTSUPP or else) to DRBD in more situations than
what we have now?  Will it make an fstrim cause thinly provisioned
devices to suddenly be fully allocated?
Or does it unmap "the same" as what we have now?
Especially on top of dm-thin, but also on top of any other device.
That's something that is not really "obvious" to me yet.

Cheers,
    Lars
