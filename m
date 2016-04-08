From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Lsf] [LSF/MM TOPIC] block-mq issues with FC
Date: Fri, 8 Apr 2016 10:26:49 -0700
Message-ID: <5707E9D9.70504@sandisk.com>
References: <57079616.4000202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0073.outbound.protection.outlook.com ([157.56.110.73]:1632
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754523AbcDHR0y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2016 13:26:54 -0400
In-Reply-To: <57079616.4000202@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "lsf@lists.linux-foundation.org" <lsf@lists.linux-foundation.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 04/08/2016 04:29 AM, Hannes Reinecke wrote:
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
>
> - Adaption on other HBAs to multiqueue:
> The current block-mq design assumes symmetric send and receive
> queues (in effect queue pairs). Any hardware _not_ providing this
> (like qla2xxx) can not be easily converted to scsi-mq. I'd like to
> discuss how one could approach converting these drivers.

Hello Hannes,

Without commenting on the specifics of the above proposal, I'm 
interested in a further discussion of how to improve multiqueue support 
for FC drivers.

Bart.

