From: Jens Axboe <axboe@fb.com>
Subject: Re: tag handling refactor V2
Date: Mon, 10 Nov 2014 15:28:50 -0700
Message-ID: <54613C22.8050907@fb.com>
References: <1415634990-3023-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34276 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbaKJW3j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2014 17:29:39 -0500
In-Reply-To: <1415634990-3023-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On 2014-11-10 08:56, Christoph Hellwig wrote:
> The current SCSI handling suffers from large amounts of duplicate cod=
e, and
> a general confusion of multiple concepts of tagging.
>
> This series tries to reduce the amount of code, and introduce two sep=
arate
> clear concepts of tagging:
>
>   a) a driver can request block-level tagging to always have a valid =
index
>      assigned to cmd->request->tag by the block layer.  This is alrea=
dy
>      automatically done for the blk-mq case, but this gives the optio=
nal
>      legacy request taggign similar semantics.
>   b) the concept of a SCSI "tagged command" is now entirely separate =
from
>      providing an actual tag, and always provided in a flag in the SC=
SI
>      command.  The driver does not need to opt-in this information, b=
ut
>      it doesn't have to use it.
>
> While this series removes 750 lines of code and provides a much clean=
er driver
> API it also opens up new questions:
>
>   - how is the change_queue_type API supposed to be used for most dri=
vers?  It
>     only changes the tag type from none to simple or back, but except=
 for the
>     special implementation in the 53c700 driver doesn't change the qu=
eue depth,
>     which might cause it to issue multiple non-tagged command.  Fortu=
nately
>     most drivers never look at this information, but then again chang=
ing the
>     queue type is useless to start with.
>   - for those drivers looking at the command tagged information we'd =
need
>     to quiesce the LUN.  No driver but the 53c700 driver does that, a=
nd the
>     53c700 does it at a target-level, which despite a comment claimin=
g it's
>     needed doesn't seem to make sense given the code.  If we can make=
 sure
>     to quience all LUNs we could avoid the per-command flag for tagge=
d commands
>     and always look at the scsi_device flag.
>   - similarly, do we need any synchronization when answering a tag me=
ssage reject?
>   - queue ramp down may drop to untagged mode, but queue ramp up neve=
r reverse=D1=95
>     that.
>   - the ->tagged_supported and ->simple_tags flags are bit-fields wit=
hout clear
>     locking protection.  We probably want to move these and similar f=
ields to
>     a proper atomic bit flags member.
>   - should the MSG_*_TAG fields move to the SPI transport class?  Tha=
t's where
>     they are defined, and besides SPI drivers they are only (ab)used =
by the
>     target code now.
>
> Changes since V1:
>   - small fixes for various review comments

Looks good to me, nice cleanup and the diffstat is excellent :-)

--=20
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
