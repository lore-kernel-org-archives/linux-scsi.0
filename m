From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [LSF/MM TOPIC] block-mq issues with FC
Date: Fri, 08 Apr 2016 08:11:10 -0700
Message-ID: <1460128270.2340.13.camel@HansenPartnership.com>
References: <57079616.4000202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33740 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757392AbcDHPLO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2016 11:11:14 -0400
In-Reply-To: <57079616.4000202@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, lsf@lists.linux-foundation.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>

On Fri, 2016-04-08 at 13:29 +0200, Hannes Reinecke wrote:
> Hi all,
> 
> I'd like to propose a topic on block-mq issues with FC.
> During my performance testing using block/scsi-mq with FC I've hit
> several issues I'd like to discuss:
> 
> - timeout handling:
> Out of necessity the status of any timed out command is undefined.
> So to be absolutely safe HBAs will be using extended timeouts here
> (eg 70secs for lpfc). During that time we _could_ signal I/O timeout
> to the upper layers, but then the tag will be reused, despite the
> HBA still having a reference to it.
> I'd like to discuss how this could be solved best with blk-mq.

What's wrong with the obvious answer: the tag shouldn't be re-used
until after at least the TMF abort.  If we need to escalate that then
it looks like the controller lost the tag and requires a bigger hammer.

However, when I look at what we do, it seems the running abort handler
is triggered from the block timeout function, so where's the problem?
... surely mq can't free the tag until that returns, because it might
extend the time. 

James


> - Adaption on other HBAs to multiqueue:
> The current block-mq design assumes symmetric send and receive
> queues (in effect queue pairs). Any hardware _not_ providing this
> (like qla2xxx) can not be easily converted to scsi-mq. I'd like to
> discuss how one could approach converting these drivers.
> 
> Cheers,
> 
> Hannes

