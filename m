From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Lsf] [LSF/MM TOPIC] block-mq issues with FC
Date: Fri, 08 Apr 2016 11:00:51 -0700
Message-ID: <1460138451.2340.60.camel@HansenPartnership.com>
References: <57079616.4000202@suse.de>
	 <20160408174006.GI2781@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34928 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186AbcDHSAz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2016 14:00:55 -0400
In-Reply-To: <20160408174006.GI2781@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, Hannes Reinecke <hare@suse.de>
Cc: lsf@lists.linux-foundation.org, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2016-04-08 at 13:40 -0400, Matthew Wilcox wrote:
> On Fri, Apr 08, 2016 at 01:29:26PM +0200, Hannes Reinecke wrote:
> > I'd like to propose a topic on block-mq issues with FC.
> > During my performance testing using block/scsi-mq with FC I've hit
> > several issues I'd like to discuss:
> 
> If there's a general block-mq bitching session, I have some ideas :-)

"Block mq bitching session" is going to look a bit bad on the public
schedule, what about "Block MQ implementor feedback"?

>  - Inability to use all queues supported by a device.  Intel's P3700
>    supports 31 queues, but block-mq insists on assigning an even multiple
>    of CPUs to each queue.  So if you have 48 CPUs, it will use 24 queues.
>    If you have 128 CPUs, it will only use 16 of the queues.
> 
>  - Interrupt steering needs to be controlled by block-mq instead of
>    the driver.  It's pointless to have each driver implement its own
>    policies on interrupt steering, irqbalanced remains a source of
>    end-user frustration, and block-mq can change the queue<->cpu mapping
>    without the driver's knowledge.
> 
> (thanks to Keith for his input on the first and suggestion of the second).

OK, what about two sessions, one for general bitching (the feedback
sessions) and one for concrete proposals for improvements ... so rather
than just complaining about the problem, if you have concrete ideas
about fixing it, that would go into the second session.

James


