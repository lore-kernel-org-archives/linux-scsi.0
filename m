From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: tag handling refactor V2
Date: Mon, 10 Nov 2014 12:06:38 -0600
Message-ID: <5460FEAE.6050909@cs.wisc.edu>
References: <1415634990-3023-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50416 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaKJSHK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2014 13:07:10 -0500
In-Reply-To: <1415634990-3023-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On 11/10/2014 09:56 AM, Christoph Hellwig wrote:
> The current SCSI handling suffers from large amounts of duplicate cod=
e, and
> a general confusion of multiple concepts of tagging.
>=20
> This series tries to reduce the amount of code, and introduce two sep=
arate
> clear concepts of tagging:
>=20
>  a) a driver can request block-level tagging to always have a valid i=
ndex
>     assigned to cmd->request->tag by the block layer.  This is alread=
y
>     automatically done for the blk-mq case, but this gives the option=
al
>     legacy request taggign similar semantics.
>  b) the concept of a SCSI "tagged command" is now entirely separate f=
rom
>     providing an actual tag, and always provided in a flag in the SCS=
I
>     command.  The driver does not need to opt-in this information, bu=
t
>     it doesn't have to use it.
>=20
> While this series removes 750 lines of code and provides a much clean=
er driver
> API it also opens up new questions:
>=20
>  - how is the change_queue_type API supposed to be used for most driv=
ers?  It
>    only changes the tag type from none to simple or back, but except =
for the
>    special implementation in the 53c700 driver doesn't change the que=
ue depth,
>    which might cause it to issue multiple non-tagged command.  Fortun=
ately
>    most drivers never look at this information, but then again changi=
ng the
>    queue type is useless to start with.
>  - for those drivers looking at the command tagged information we'd n=
eed
>    to quiesce the LUN.  No driver but the 53c700 driver does that, an=
d the
>    53c700 does it at a target-level, which despite a comment claiming=
 it's
>    needed doesn't seem to make sense given the code.  If we can make =
sure
>    to quience all LUNs we could avoid the per-command flag for tagged=
 commands
>    and always look at the scsi_device flag.
>  - similarly, do we need any synchronization when answering a tag mes=
sage reject?
>  - queue ramp down may drop to untagged mode, but queue ramp up never=
 reverse=D1=95
>    that.
>  - the ->tagged_supported and ->simple_tags flags are bit-fields with=
out clear
>    locking protection.  We probably want to move these and similar fi=
elds to
>    a proper atomic bit flags member.
>  - should the MSG_*_TAG fields move to the SPI transport class?  That=
's where
>    they are defined, and besides SPI drivers they are only (ab)used b=
y the
>    target code now.
>=20
> Changes since V1:
>  - small fixes for various review comments
>=20

Looks nice to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
