From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 22/23] drbd: implement REQ_OP_WRITE_ZEROES
Date: Thu, 30 Mar 2017 22:34:05 -0400
Message-ID: <yq137duyy1u.fsf@oracle.com>
References: <20170323143341.31549-1-hch@lst.de>
	<20170323143341.31549-23-hch@lst.de>
	<20170330100641.GI5939@soda.linbit> <20170330114408.GA15777@lst.de>
	<20170330134957.GA508@redhat.com> <yq1pogy3i6u.fsf@oracle.com>
	<20170330231550.GA3102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20170330231550.GA3102-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Mike Snitzer's message of
	"Thu, 30 Mar 2017 19:15:50 -0400")
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

Mike,

> But while discussing this effort with Jeff Moyer he asked: shouldn't the
> zeroed blocks be provisioned?  This is a fairly embarassing question not
> to be able to answer in the moment.  So I clearly need to learn what the
> overall intent of WRITE_ZEROES actually is.

The intent is to guarantee all future reads to these blocks will return
zeroes. Whether to allocate or deallocate or do a combination to achieve
that goal is up to the device.

> If it is meant as a replacement for WRITE_SAME (as hch switched dm-io
> over from WRITE_SAME with a payload of 0 to WRITE_ZEROES) and for the
> backing mechanism for blkdev_issue_zeroout() then I guess I have my
> answer.

Yes. I was hoping MD would use WRITE SAME to initialize data and parity
drives. That's why I went with SAME nomenclature rather than ZEROES
(which had just appeared in NVMe at that time).

Christoph's renaming is mostly to emphasize the purpose and the
semantics. People keep getting confused because both REQ_DISCARD and
REQ_WRITE_SAME use the WRITE SAME SCSI command. But the two uses are
completely orthogonal and governed by different heuristics in sd.c.

> Unless DM thinp can guarantee that the discarded blocks will
> always return zeroes (by zeroing before all partial block writes) my
> discard based dm-thinp implementation of WRITE_ZEROES is a complete
> throw-away (unless block zeroing is enabled.. which it never is because
> performance sucks with it).  So if an upper-level of the IO stack
> (e.g. ext4) were to assume that a block will _definitely_ have zeroes
> then DM thinp would fall short.

You don't have a way to mark those blocks as being full of zeroes
without actually writing them?

Note that the fallback to a zeroout command is to do a regular write. So
if DM doesn't zero the blocks, the block layer is going to it.

-- 
Martin K. Petersen	Oracle Linux Engineering
