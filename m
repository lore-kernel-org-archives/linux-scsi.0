From: Christoph Hellwig <hch@lst.de>
Subject: tag handling refactor
Date: Tue,  4 Nov 2014 08:54:05 +0100
Message-ID: <1415087656-9491-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34624 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaKDHyM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 02:54:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

The current SCSI handling suffers from large amounts of duplicate code,=
 and
a general confusion of multiple concepts of tagging.

This series tries to reduce the amount of code, and introduce two separ=
ate
clear concepts of tagging:

 a) a driver can request block-level tagging to always have a valid ind=
ex
    assigned to cmd->request->tag by the block layer.  This is already
    automatically done for the blk-mq case, but this gives the optional
    legacy request taggign similar semantics.
 b) the concept of a SCSI "tagged command" is now entirely separate fro=
m
    providing an actual tag, and always provided in a flag in the SCSI
    command.  The driver does not need to opt-in this information, but
    it doesn't have to use it.

While this series removes 750 lines of code and provides a much cleaner=
 driver
API it also opens up new questions:

 - how is the change_queue_type API supposed to be used for most driver=
s?  It
   only changes the tag type from none to simple or back, but except fo=
r the
   special implementation in the 53c700 driver doesn't change the queue=
 depth,
   which might cause it to issue multiple non-tagged command.  Fortunat=
ely
   most drivers never look at this information, but then again changing=
 the
   queue type is useless to start with.
 - for those drivers looking at the command tagged information we'd nee=
d
   to quiesce the LUN.  No driver but the 53c700 driver does that, and =
the
   53c700 does it at a target-level, which despite a comment claiming i=
t's
   needed doesn't seem to make sense given the code.  If we can make su=
re
   to quience all LUNs we could avoid the per-command flag for tagged c=
ommands
   and always look at the scsi_device flag.
 - similarly, do we need any synchronization when answering a tag messa=
ge reject?
 - queue ramp down may drop to untagged mode, but queue ramp up never r=
everse=D1=95
   that.
 - the ->tagged_supported and ->simple_tags flags are bit-fields withou=
t clear
   locking protection.  We probably want to move these and similar fiel=
ds to
   a proper atomic bit flags member.
 - should the MSG_*_TAG fields move to the SPI transport class?  That's=
 where
   they are defined, and besides SPI drivers they are only (ab)used by =
the
   target code now.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
