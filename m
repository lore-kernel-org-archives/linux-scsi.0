From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH resend] bsg: Fix sense buffer bug in SG_IO
Date: Tue, 3 Feb 2009 15:57:36 +0900
Message-ID: <20090203155720K.fujita.tomonori@lab.ntt.co.jp>
References: <49872DF3.3060401@panasas.com>
	<20090202185345.GM30821@kernel.dk>
	<4987E55F.4000606@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:45867 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbZBCG6G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Feb 2009 01:58:06 -0500
In-Reply-To: <4987E55F.4000606@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: jens.axboe@oracle.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, osd-dev@open-osd.org

On Tue, 03 Feb 2009 08:34:07 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
> When submitting requests via SG_IO, which does a sync io, a
> bsg_command is not allocated. So an in-Kernel sense_buffer was not
> set. However when calling blk_execute_rq() with no sense buffer
> one is provided from the stack. Now bsg at blk_complete_sgv4_hdr_rq()
> would check if rq->sense_len and a sense was requested by sg_io_v4
> the rq->sense was copy_user() back, but by now it is already mangled
> stack memory.
> 
> I have fixed that by forcing a sense_buffer when calling bsg_map_hdr().
> The bsg_command->sense is provided in the write/read path like before,
> and on-the-stack buffer is provided when doing SG_IO.
> 
> I have also fixed a dprintk message to print rq->errors in hex because
> of the scsi bit-field use of this member. For other block devices it
> does not matter anyway.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  block/bsg.c |   17 ++++++++++-------
>  1 files changed, 10 insertions(+), 7 deletions(-)

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


I think I did this in the previous submission though.
