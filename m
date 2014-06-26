From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: sd_setup_discard_cmnd: BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Wed, 25 Jun 2014 21:44:11 -0400
Message-ID: <yq17g44e978.fsf@sermon.lab.mkp.net>
References: <53A28B21.7070500@profihost.ag>
	<yq1ionwjn15.fsf@sermon.lab.mkp.net>
	<20140620155321.GA24389@soda.linbit>
	<yq1wqcbil0c.fsf@sermon.lab.mkp.net>
	<20140620182956.GB24389@soda.linbit>
	<yq1vbrrh0yo.fsf@sermon.lab.mkp.net>
	<20140624115324.GB17123@soda.linbit>
	<yq1simtgax8.fsf@sermon.lab.mkp.net>
	<20140625101421.GE17123@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23703 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbaFZBof (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 21:44:35 -0400
In-Reply-To: <20140625101421.GE17123@soda.linbit> (Lars Ellenberg's message of
	"Wed, 25 Jun 2014 12:14:21 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, Jens Axboe <axboe@kernel.dk>, konrad.wilk@oracle.com, elder@linaro.org, Josh Durgin <josh.durgin@inktank.com>, Greg KH <gregkh@linuxfoundation.org>

>>>>> "Lars" == Lars Ellenberg <lars.ellenberg@linbit.com> writes:

Lars> Because the way we do some internal bookkeeping, we announce a max
Lars> discard of 4 MiB.  

Yikes!

Lars> Similar for the WRITE_SAME interface (which we do not properly
Lars> support on the DRBD protocol level yet -- backward compatibility
Lars> concerns -- but intend to support "soon").

Yeah, WRITE SAME can take a long time to complete too. However, we're
typically issuing them 32 megs at a time.

Lars> If we only have a synchronous interface, we will probably have to
Lars> either add some "async wrapper", or defer such submissions to
Lars> worker threads.  I'd prefer to have an async submit path.

OK, I'll chew on it.

-- 
Martin K. Petersen	Oracle Linux Engineering
