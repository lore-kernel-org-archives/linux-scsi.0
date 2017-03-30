From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/23] sd: implement REQ_OP_WRITE_ZEROES
Date: Wed, 29 Mar 2017 22:25:33 -0400
Message-ID: <yq1o9wj4i1u.fsf@oracle.com>
References: <20170323143341.31549-1-hch@lst.de>
	<20170323143341.31549-4-hch@lst.de>
	<1490726988.2573.16.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <1490726988.2573.16.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> (Bart Van Assche's message
	of "Tue, 28 Mar 2017 18:50:01 +0000")
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org" <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org" <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> writes:

Hi Bart,

> A quote from SBC: "An OPTIMAL UNMAP GRANULARITY field set to a
> non-zero value indicates the optimal granularity in logical blocks for
> unmap requests (e.g., an UNMAP command or a WRITE SAME (16) command
> with the UNMAP bit set to one).  An unmap request with a number of
> logical blocks that is not a multiple of this value may result in
> unmap operations on fewer LBAs than requested."

Indeed. Fewer LBAs than requested may be *unmapped*. That does not imply
that they are not *written*.

> This means that just like the start and end of a discard must be
> aligned on a discard_granularity boundary, WRITE SAME commands with
> the UNMAP bit set must also respect that granularity. I think this
> means that either __blkdev_issue_zeroout() has to be modified such
> that it rejects unaligned REQ_OP_WRITE_ZEROES operations or that
> blk_bio_write_same_split() has to be modified such that it generates
> REQ_OP_WRITEs for the unaligned start and tail.

No, that's not correct. SBC states:

"a) if the Data-Out Buffer of the WRITE SAME command is the same as the
   logical block data returned by a read operation from that LBA while
   in the unmapped state, then:

   1) the device server performs the actions described in table 6
      [unmap]; and

   2) if an unmap operation is not performed in step 1), then the device
      server shall perform the specified write operation to that LBA;"

I.e. With WRITE SAME it is the responsibility of the device server to
write any LBAs described by the command that were not successfully
unmapped.

-- 
Martin K. Petersen	Oracle Linux Engineering
