From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 08/11] scsi: always assign block layer tags if enabled
Date: Tue, 04 Nov 2014 21:32:12 -0500
Message-ID: <yq1ioiufkcz.fsf@sermon.lab.mkp.net>
References: <1415087656-9491-1-git-send-email-hch@lst.de>
	<1415087656-9491-9-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20407 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaKECeJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 21:34:09 -0500
In-Reply-To: <1415087656-9491-9-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Tue, 4 Nov 2014 08:54:13 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Allow a driver to ask for block layer tags by setting
Christoph> .use_blk_tags in the host template, in which case it will
Christoph> always see a valid value in request->tag, similar to the
Christoph> behavior when using blk-mq.  This means request-> even
Christoph> SCSI "untagged" commands will now have a tag, which is
Christoph> especially useful when using a host-wide tag map.

Christoph> + scsi_adjust_queue_depth(dev, MSG_SIMPLE_TAG, cmd_per_lun);
Christoph> + else
Christoph> + scsi_adjust_queue_depth(dev, 0, cmd_per_lun);
 
I kept tripping over these. In one case we have a well-defined
MSG_SIMPLE_TAG constant in the other it's '0'.

Also, when I read the disable case it's not immediately obvious whether
the 0 is the queue depth or the tag type (although in the example above
it's obvious due to it being cmd_per_lun).

Anyway. Minor nitpicking.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
