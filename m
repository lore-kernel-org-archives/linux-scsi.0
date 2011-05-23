From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Integrity errors should not cause failover
Date: Mon, 23 May 2011 14:17:24 -0400
Message-ID: <20110523181723.GA18971@redhat.com>
References: <yq18vu4fw9e.fsf@sermon.lab.mkp.net>
 <20110518121156.GB18433@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756474Ab1EWSRc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2011 14:17:32 -0400
Content-Disposition: inline
In-Reply-To: <20110518121156.GB18433@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, linux-scsi@vger.kernel.org

On Wed, May 18 2011 at  8:11am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, May 18 2011 at 12:49am -0400,
> Martin K. Petersen <martin.petersen@oracle.com> wrote:
> 
> > 
> > Integrity errors need to be passed to the owner of the integrity
> > metadata for processing. Consequently EILSEQ should be passed up the
> > stack.
> > 
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> > Acked-by: Mike Snitzer <snitzer@redhat.com>
> > 
> > ---
> > 
> > Ping on this one?
> 
> It has been on my personal queue but I didn't push the issue with
> Alasdair (for 2.6.39).
> 
> At this point seems we should be targetting this fix for 2.6.40 but I'll
> defer to Alasdair on whether he'd like to push to .39 last minute.

Hi Martin,

Alasdair and I just chatted about this patch: it will always pass the
the -EILSEQ up _without_ performing any mpath path failure.

The newfound concern is: is there ever a benefit to failing the path
before returning -EILSEQ?

Or will -EILSEQ always imply there is nothing wrong with the path?
E.g. a transport error cannot cause a CRC error -- the transport
error is always trapped by SCSI and cannot result in continued
processing of an IO (that goes on to have CRC error)?

Thanks,
Mike

> 
> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index a550a05..aa4e570 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -1290,7 +1290,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
> >  	if (!error && !clone->errors)
> >  		return 0;	/* I/O complete */
> >  
> > -	if (error == -EOPNOTSUPP || error == -EREMOTEIO)
> > +	if (error == -EOPNOTSUPP || error == -EREMOTEIO || error == -EILSEQ)
> >  		return error;
> >  
> >  	if (mpio->pgpath)
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
