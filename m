From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 02/13] block: Use accessor functions for queue limits
Date: Mon, 1 Jun 2009 07:15:57 +0200
Message-ID: <20090601051556.GU11363@kernel.dk>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com> <1242362435-11953-3-git-send-email-martin.petersen@oracle.com> <200905311751.37898.bzolnier@gmail.com> <yq1ab4sa6cc.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:53552 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbZFAFPz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jun 2009 01:15:55 -0400
Content-Disposition: inline
In-Reply-To: <yq1ab4sa6cc.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jun 01 2009, Martin K. Petersen wrote:
> >>>>> "Bart" == Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> writes:
> 
> >> Convert all external users of queue limits to using wrapper functions
> >> instead of poking the request queue variables directly.
> 
> Did bisect this?
> 
> The patch you mention didn't touch the bounce limits at all.  One of my
> other patches moved portions of the queue limits to an embedded struct.
> However, it was purely variable renaming.  I have not touched anything
> related to memory allocations.

It replaces

        q->bounce_pfn = t->limits.bounce_pfn;

with

        blk_queue_bounce_limit(q, t->limits.bounce_pfn);

which are definitely not a functionally equivalent change.

-- 
Jens Axboe

