From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/11] scsi: always assign block layer tags if enabled
Date: Tue, 04 Nov 2014 11:46:49 +0100
Message-ID: <5458AE99.8030403@suse.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-9-git-send-email-hch@lst.de> <545895E0.1000902@suse.de> <20141104104216.GD19154@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaKDKqu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 05:46:50 -0500
In-Reply-To: <20141104104216.GD19154@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On 11/04/2014 11:42 AM, Christoph Hellwig wrote:
> On Tue, Nov 04, 2014 at 10:01:20AM +0100, Hannes Reinecke wrote:
>> Hmm. With patch 03/11 and 04/11 you've removed the ordered_tags
>> fields, on the ground that the block layer never issues ordered tags
>> nowadays.
>> Yet these drivers still try to activate ordered tags.
>> So what's happening here?
>=20
> Broken APIs - in the current tree we can set the ->ordered_tags
> field through scsi_adjust_queue_depth and scsi_set_tag_type, but that
> field isn't ever checked except for the queue_type sysfs file and
> a few pintks.
>=20
Yeah, I've seen that.

>> Do these drivers switch on ordered tags on their own?
>> If so, why shouldn't the other drivers (like the various FC HBAs) be
>> allowed to do it, too?
>> Shouldn't we rather remove ordered tagging from those drivers, too?
>=20
> Except for a few SPI drivers that issue an ordered tag on their own
> every N commands to avoid locking devices up ordered tag support
> is gone from the tree (at least on the initiator side).
>=20
Okay.

>> (Although I'm not too happy about removing ordered tags support in
>> the other drivers. I have the nagging feeling they might become
>> important if and when ZBC ever gets off the ground ...)
>=20
> Good luck with that mess.  It will have to look very different anyway=
 if
> it should be remotely supportable, and would be limited to a small
> set of hardware currently not pretending to have ordered tag support
> (SAS + SATA basically).
>=20
Well, it's nothing definite as of yet.
SATA has NCQ nowadays, which should take care of this.
And for SAS ... we'll cross that bridge if we come to it.

So go ahead with this.

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
