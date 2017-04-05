From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: always use REQ_OP_WRITE_ZEROES for zeroing offload V2
Date: Wed,  5 Apr 2017 19:20:58 +0200
Message-ID: <20170405172125.22600-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This series makes REQ_OP_WRITE_ZEROES the only zeroing offload
supported by the block layer, and switches existing implementations
of REQ_OP_DISCARD that correctly set discard_zeroes_data to it,
removes incorrect discard_zeroes_data, and also switches WRITE SAME
based zeroing in SCSI to this new method.

The series is against the block for-next tree.

A git tree is also avaiable at:

    git://git.infradead.org/users/hch/block.git discard-rework.2

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/discard-rework.2

Changes since V2:
 - various spelling fixes
 - various reviews captured
 - two new patches from Martin at the end
