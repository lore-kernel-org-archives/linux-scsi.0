From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: always use REQ_OP_WRITE_ZEROES for zeroing offload
Date: Wed, 05 Apr 2017 07:40:36 -0400
Message-ID: <yq1vaqjt74b.fsf@oracle.com>
References: <20170331163313.31821-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20170331163313.31821-1-hch-jcswGhMUV9g@public.gmane.org> (Christoph Hellwig's message
	of "Fri, 31 Mar 2017 18:32:48 +0200")
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

Christoph,

> This series makes REQ_OP_WRITE_ZEROES the only zeroing offload
> supported by the block layer, and switches existing implementations
> of REQ_OP_DISCARD that correctly set discard_zeroes_data to it,
> removes incorrect discard_zeroes_data, and also switches WRITE SAME
> based zeroing in SCSI to this new method.

Very, very nice. I think this is the correct approach.

I'm going to send two follow-up patches that allow us to use UNMAP for
discards and WRITE SAME w/ UNMAP for zeroout. That appears to be the
preferred configuration for most storage devices.

-- 
Martin K. Petersen	Oracle Linux Engineering
