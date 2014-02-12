From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/6] scsi: remove a useless get/put_device pair in scsi_request_fn
Date: Wed, 12 Feb 2014 12:38:10 +0100
Message-ID: <52FB5D22.5070208@suse.de>
References: <20140206184306.997538898@bombadil.infradead.org> <20140206184417.890824661@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaBLLiL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 06:38:11 -0500
In-Reply-To: <20140206184417.890824661@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Tejun Heo <tj@kernel.org>, Mike Christie <michaelc@cs.wisc.edu>

On 02/06/2014 07:43 PM, Christoph Hellwig wrote:
> From: Bart Van Assche <bvanassche@acm.org>
>=20
> SCSI devices may only be removed by calling scsi_remove_device().
> That function must invoke blk_cleanup_queue() before the final put
> of sdev->sdev_gendev. Since blk_cleanup_queue() waits for the
> block queue to drain and then tears it down, scsi_request_fn cannot
> be active anymore after blk_cleanup_queue() has returned and hence
> the get_device()/put_device() pair in scsi_request_fn is unnecessary.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Acked-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
