From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Thu, 21 Jul 2016 16:32:09 -0400
Message-ID: <20160721203209.GB27509@redhat.com>
References: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
 <20160720140815.GA19045@redhat.com>
 <20160720142727.GA57399@redhat.com>
 <1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbcGUUcL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2016 16:32:11 -0400
Content-Disposition: inline
In-Reply-To: <1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

On Wed, Jul 20 2016 at  1:37pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 07/20/2016 07:27 AM, Mike Snitzer wrote:
> >On Wed, Jul 20 2016 at 10:08am -0400,
> >Mike Snitzer <snitzer@redhat.com> wrote:
> >[ ... ]
> >diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> >index 7a96618..347ff25 100644
> >--- a/drivers/md/dm-rq.c
> >+++ b/drivers/md/dm-rq.c
> >@@ -414,7 +414,7 @@ static void dm_complete_request(struct request *rq, int error)
> > 	if (!rq->q->mq_ops)
> > 		blk_complete_request(rq);
> > 	else
> >-		blk_mq_complete_request(rq, error);
> >+		blk_mq_complete_request(rq, 0);
> > }
> >
> > /*
> 
> Hello Mike,
> 
> Thanks for the patch. But unfortunately even with this patch applied
> I see fio reporting I/O errors when run on top of dm-mq after a
> (simulated) cable pull.

BTW, curious, how is it that you're simulating the cable pull?  I'd like
to see if doing the same, via a new test in mptest, exposes this issue
you're hitting.

Mike
