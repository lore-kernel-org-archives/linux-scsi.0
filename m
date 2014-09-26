From: Hannes Reinecke <hare@suse.de>
Subject: Question: request tag usage
Date: Fri, 26 Sep 2014 08:29:29 +0200
Message-ID: <542507C9.2060901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbaIZG3h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2014 02:29:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Robert Elliot <elliot@hp.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

Hi Christoph,

as discussed it would make sense to use the request->tag in eg
scmd_printk() to identify the command.
Which I duly did, only to figure out that the tag is always '-1', ie
tagging is not in use.
(Which is okay from the SCSI side, seeing the TCQ is basically a
SCSI parallel thing).
Looking closer I found plenty of code for handling tags in the block
layer (and the blk-mq stuff, of course), but virtually none of the
non-SPI driver seems to be using them.
Which makes the original idea a bit pointless, seeing that we need
to identify the command _always_, and not just if the host happens
to support tagging.

Which leads me to some questions:
- Is the stuff in blk-mq supposed to work as a superset of SCSI TCQ?
- If so, should any HBAs with a queue depth > 1 (which does not
  support TCQ) set the tag of a command?
  (that's what I've initially thought would happen ...)
- If not (and the ->tag field is basically unused), can't we
  have the HBA to fill in a value here?

What I would like to see is to have the '->tag' field as an
identification for the commands in flight. IE every HBA with a queue
depth > 1 should be setting the tags.

Which apparently was too much to hope for ...

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
