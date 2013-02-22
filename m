From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] dm: Avoid use-after-free of a mapped device
Date: Fri, 22 Feb 2013 06:28:36 -0500
Message-ID: <20130222112836.GA30457@redhat.com>
References: <51274C2F.6070500@acm.org>
 <51274CC3.9070204@acm.org>
 <20130222110829.GA30269@redhat.com>
 <512754E1.9080008@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab3BVL2s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2013 06:28:48 -0500
Content-Disposition: inline
In-Reply-To: <512754E1.9080008@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>

On Fri, Feb 22 2013 at  6:22am -0500,
Bart Van Assche <bvanassche@acm.org> wrote:

> On 02/22/13 12:08, Mike Snitzer wrote:
> >On Fri, Feb 22 2013 at  5:47am -0500,
> >Bart Van Assche <bvanassche@acm.org> wrote:
> >
> >>As the comment above rq_completed() explains, md members must
> >>not be touched after the dm_put() at the end of that function
> >>has been invoked. Avoid that the md->queue can be run
> >>asynchronously after the last md reference has been dropped by
> >>running that queue synchronously.
> >
> >Your commit header should probably reference commit
> >a8c32a5c98943d370ea606a2e7dc04717eb92206 ("dm: fix deadlock with request
> >based dm and queue request_fn recursion") and cc: stable with "v3.7+"
> >guidance.
> >
> >Acked-by: Mike Snitzer <snitzer@redhat.com>
> 
> Hello Mike,
> 
> Thanks for reviewing this patch and for the ack. Regarding the
> stable tag: had you noticed that commit a8c32a5 had a "Cc: stable"
> tag itself and hence probably has already been backported to kernels
> older than v3.7 ?

Ah yes.  Good point.

Jens, since this DM change is dependent on Bart's 1/2 block patch it'd
be ideal if you could pick up both of these patches for v3.9.

Thanks,
Mike
