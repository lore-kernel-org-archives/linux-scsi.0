From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/11] scsi: always assign block layer tags if enabled
Date: Tue, 4 Nov 2014 11:42:16 +0100
Message-ID: <20141104104216.GD19154@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-9-git-send-email-hch@lst.de> <545895E0.1000902@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51290 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaKDKmV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 05:42:21 -0500
Content-Disposition: inline
In-Reply-To: <545895E0.1000902@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On Tue, Nov 04, 2014 at 10:01:20AM +0100, Hannes Reinecke wrote:
> Hmm. With patch 03/11 and 04/11 you've removed the ordered_tags
> fields, on the ground that the block layer never issues ordered tags
> nowadays.
> Yet these drivers still try to activate ordered tags.
> So what's happening here?

Broken APIs - in the current tree we can set the ->ordered_tags
field through scsi_adjust_queue_depth and scsi_set_tag_type, but that
field isn't ever checked except for the queue_type sysfs file and
a few pintks.

> Do these drivers switch on ordered tags on their own?
> If so, why shouldn't the other drivers (like the various FC HBAs) be
> allowed to do it, too?
> Shouldn't we rather remove ordered tagging from those drivers, too?

Except for a few SPI drivers that issue an ordered tag on their own
every N commands to avoid locking devices up ordered tag support
is gone from the tree (at least on the initiator side).

> (Although I'm not too happy about removing ordered tags support in
> the other drivers. I have the nagging feeling they might become
> important if and when ZBC ever gets off the ground ...)

Good luck with that mess.  It will have to look very different anyway if
it should be remotely supportable, and would be limited to a small
set of hardware currently not pretending to have ordered tag support
(SAS + SATA basically).
