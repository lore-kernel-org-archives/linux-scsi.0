From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: block: Deprecate QUEUE_FLAG_CLUSTER and use queue_limits instead
Date: Thu, 25 Nov 2010 21:53:38 -0500
Message-ID: <yq1ipzkn6bx.fsf@sermon.lab.mkp.net>
References: <85ABFDC4641C4847BA6088F2982EFD8F049D4EB8@nonamew.ptu.promise.com>
	<yq14ob5o2d4.fsf@sermon.lab.mkp.net>
	<yq1vd3lmkdt.fsf_-_@sermon.lab.mkp.net>
	<4CEEAE35.5060805@fusionio.com> <yq1r5e8ncmz.fsf@sermon.lab.mkp.net>
	<20101126022804.GA15662@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:59622 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0KZCy7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2010 21:54:59 -0500
In-Reply-To: <20101126022804.GA15662@redhat.com> (Mike Snitzer's message of
	"Thu, 25 Nov 2010 21:28:05 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jaxboe@fusionio.com>, dm-devel@redhat.com, Promise_Linux <Promise_Linux@promise.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

[Stacking drivers having to set the queue flag]

Mike> But that was already done properly, so that wasn't a problem that
Mike> needed fixing (it just had potential to be overlooked if/when
Mike> there is a new stacking driver).

Yeah, just elaborating that the existing approach is flawed for several
reasons.

I don't know what happened to the wrapper function that set both
flags. I must have botched it when the topology code got merged.


Mike> It took me a bit to see exactly where we got it wrong.  Looks like
Mike> __scsi_alloc_queue was only concerned with the queue flag.  So a
Mike> minimalist fix would've been to also set no_cluster = 1 in
Mike> __scsi_alloc_queue?

Yep. But I'd rather fix this up the right way instead of perpetuating
the ugly two-flag monte.

-- 
Martin K. Petersen	Oracle Linux Engineering
