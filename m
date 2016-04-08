From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Lsf] [LSF/MM TOPIC] block-mq issues with FC
Date: Fri, 08 Apr 2016 09:06:26 -0700
Message-ID: <1460131586.2340.23.camel@HansenPartnership.com>
References: <57079616.4000202@suse.de>
	 <1460128270.2340.13.camel@HansenPartnership.com>
	 <1460130673.25335.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34228 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754266AbcDHQG3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2016 12:06:29 -0400
In-Reply-To: <1460130673.25335.51.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: Hannes Reinecke <hare@suse.de>, lsf@lists.linux-foundation.org, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2016-04-08 at 11:51 -0400, Ewan D. Milne wrote:
> On Fri, 2016-04-08 at 08:11 -0700, James Bottomley wrote:
> > On Fri, 2016-04-08 at 13:29 +0200, Hannes Reinecke wrote:
> > > Hi all,
> > > 
> > > I'd like to propose a topic on block-mq issues with FC.
> > > During my performance testing using block/scsi-mq with FC I've 
> > > hit several issues I'd like to discuss:
> > > 
> > > - timeout handling:
> > > Out of necessity the status of any timed out command is 
> > > undefined. So to be absolutely safe HBAs will be using extended 
> > > timeouts here (eg 70secs for lpfc). During that time we _could_ 
> > > signal I/O timeout to the upper layers, but then the tag will be 
> > > reused, despite the HBA still having a reference to it. I'd like
> > > to discuss how this could be solved best with blk-mq.
> > 
> > What's wrong with the obvious answer: the tag shouldn't be re-used
> > until after at least the TMF abort.  If we need to escalate that 
> > then it looks like the controller lost the tag and requires a 
> > bigger hammer.
> > 
> > However, when I look at what we do, it seems the running abort 
> > handler is triggered from the block timeout function, so where's 
> > the problem? ... surely mq can't free the tag until that returns, 
> > because it migh extend the time.
> > 
> > James
> 
> There was some discussion a while back about whether we could 
> decouple the SCSI EH's recovery of the device from using the failed 
> scmds, so that once the disposition of the original I/O was 
> determined (i.e. they had succeeded, failed or timed out & aborted), 
> the scmds could be returned to a higher layer while the EH attempted 
> to recover the device.

OK, so is the problem the tag or the request pointed to by the scmd?  I
think in the tag case, as long as it's not recovered until after the
abort is processed (i.e. until a disposition is returned from
scsi_times_out) then we're fine.  If the abort fails, we quiesce the
host anyway, so the block layer can happily queue commands with re-used
tags and the device will never see the duplication.

I can't see how there can be a problem with the requests, because we
hold a reference to them in the scmd, so while it might be nicer to
release them earlier, it shouldn't be a problem today.

James


>   That way, in a multipath environment, we could submit the I/O on
> working paths and avoid lengthy delays while we went through all the
> resets.
> 
> We still need a successful abort after a timeout, but at least in the
> above scenario we shouldn't be reusing the tags until the device is
> recovered, as further I/O should be blocked while EH is running.
> 
> -Ewan
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux
> -block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

