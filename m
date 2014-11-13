From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: tag handling refactor V2
Date: Wed, 12 Nov 2014 17:15:38 -0800
Message-ID: <1415841338.7154.33.camel@jarvis.lan>
References: <1415634990-3023-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51866 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753306AbaKMBPk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2014 20:15:40 -0500
In-Reply-To: <1415634990-3023-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On Mon, 2014-11-10 at 16:56 +0100, Christoph Hellwig wrote:
> - for those drivers looking at the command tagged information we'd need
>    to quiesce the LUN.  No driver but the 53c700 driver does that, and the
>    53c700 does it at a target-level, which despite a comment claiming it's
>    needed doesn't seem to make sense given the code.

I can answer that from ancient memory.  The mid-layer tag tracking
wasn't sufficient to track the negotiated state of the tags.  the 53c700
was constructed before the slave alloc/configure routines came along, so
it used a per target tracker for the tag negotiation (i.e. it was all on
or all off per target).  The reason for the quiesce is so as not to have
to try to work out if any LUN has any tagged commands outstanding when
changing to untagged.

James


