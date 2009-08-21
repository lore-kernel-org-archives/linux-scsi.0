From: Christoph Hellwig <hch@infradead.org>
Subject: Re: O_DIRECT and barriers
Date: Fri, 21 Aug 2009 10:20:08 -0400
Message-ID: <20090821142008.GA30617@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbZHUOUH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2009 10:20:07 -0400
Content-Disposition: inline
In-Reply-To: <20090821114010.GG12579@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Aug 21, 2009 at 01:40:10PM +0200, Jens Axboe wrote:
> I've talked to Chris about this in the past too, but I never got around
> to benchmarking FUA for O_DIRECT. It should be pretty easy to wire up
> without making too many changes, and we do have FUA support on most SATA
> drives too. Basically just a check in the driver for whether the
> request is O_DIRECT and a WRITE, ala:
> 
>         if (rq_data_dir(rq) == WRITE && rq_is_sync(rq))
>                 WRITE_FUA;
> 
> I know that FUA is used by that other OS, so I think we should be golden
> on the hw support side.

Just doing FUA should be pretty easy, in fact from my reading of the
code we already use FUA for barriers if supported, that is only drain
the queue, do a pre-flush for a barrier and then issue the actual
barrier write as FUA.

I can play around with getting rid of the pre-flush and doing cache
flush based emulation if FUA is not supported if you're fine with that.
