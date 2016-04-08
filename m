From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM TOPIC] block-mq issues with FC
Date: Fri, 8 Apr 2016 13:29:26 +0200
Message-ID: <57079616.4000202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41072 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567AbcDHL33 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2016 07:29:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf@lists.linux-foundation.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>

Hi all,

I'd like to propose a topic on block-mq issues with FC.
During my performance testing using block/scsi-mq with FC I've hit
several issues I'd like to discuss:

- timeout handling:
Out of necessity the status of any timed out command is undefined.
So to be absolutely safe HBAs will be using extended timeouts here
(eg 70secs for lpfc). During that time we _could_ signal I/O timeout
to the upper layers, but then the tag will be reused, despite the
HBA still having a reference to it.
I'd like to discuss how this could be solved best with blk-mq.

- Adaption on other HBAs to multiqueue:
The current block-mq design assumes symmetric send and receive
queues (in effect queue pairs). Any hardware _not_ providing this
(like qla2xxx) can not be easily converted to scsi-mq. I'd like to
discuss how one could approach converting these drivers.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
