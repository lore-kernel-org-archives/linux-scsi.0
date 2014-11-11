From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/11] scsi: don't set tagging state from scsi_adjust_queue_depth
Date: Tue, 11 Nov 2014 16:41:24 +0100
Message-ID: <54622E24.8090809@suse.de>
References: <1415634990-3023-1-git-send-email-hch@lst.de> <1415634990-3023-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbaKKPlZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2014 10:41:25 -0500
In-Reply-To: <1415634990-3023-10-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On 11/10/2014 04:56 PM, Christoph Hellwig wrote:
> Remove the tagged argument from scsi_adjust_queue_depth, and just let=
 it
> handle the queue depth.  For most drivers those two are fairly separa=
te,
> given that most modern drivers don't care about the SCSI "tagged" sta=
tus
> of a command at all, and many old drivers allow queuing of multiple
> untagged commands in the driver.
>=20
> Instead we start out with the ->simple_tags flag set before calling
> ->slave_configure, which is how all drivers actually looking at
> ->simple_tags except for one worke anyway.  The one other case looks
> broken, but I've kept the behavior as-is for now.
>=20
> Except for that we only change ->simple_tags from the ->change_queue_=
type,
> and when rejecting a tag message in a single driver, so keeping this
> churn out of scsi_adjust_queue_depth is a clear win.
>=20
> Now that the usage of scsi_adjust_queue_depth is more obvious we can
> also remove all the trivial instances in ->slave_alloc or ->slave_con=
figure
> that just set it to the cmd_per_lun default.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
