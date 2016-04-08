From: Christoph Hellwig <hch@lst.de>
Subject: Re: [LSF/MM TOPIC] block-mq issues with FC
Date: Fri, 8 Apr 2016 20:13:30 +0200
Message-ID: <20160408181330.GA22406@lst.de>
References: <57079616.4000202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47129 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbcDHSNc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2016 14:13:32 -0400
Content-Disposition: inline
In-Reply-To: <57079616.4000202@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: lsf@lists.linux-foundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>

First: what is actually FC specific here?

> - timeout handling:
> Out of necessity the status of any timed out command is undefined.
> So to be absolutely safe HBAs will be using extended timeouts here
> (eg 70secs for lpfc). During that time we _could_ signal I/O timeout
> to the upper layers, but then the tag will be reused, despite the
> HBA still having a reference to it.
> I'd like to discuss how this could be solved best with blk-mq.

reusing a tag that the hardware hasn't returned is simply unsfafe,
nothing really blk-mq specific here.

> - Adaption on other HBAs to multiqueue:
> The current block-mq design assumes symmetric send and receive
> queues (in effect queue pairs). Any hardware _not_ providing this
> (like qla2xxx) can not be easily converted to scsi-mq. I'd like to
> discuss how one could approach converting these drivers.

Why do you think blk-mq assumes this?
