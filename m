From: Hannes Reinecke <hare@suse.de>
Subject: blk-mq and interrupt affinity
Date: Fri, 29 Jan 2016 10:40:27 +0100
Message-ID: <56AB338B.4020804@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbcA2Jk3 (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Fri, 29 Jan 2016 04:40:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

Hi all,

Looking through the blk-mq code I tried to figure out if and how the
driver is supposed to set any interrupt affinity when block-mq is
enabled.

Thing is, for your typical driver you would set the interrupt
affinity during init time (eg for SCSI drivers during host_alloc).
But to set the interrupt affinity you'd need the cpumask, which is
only populated way later during queue setup.

So now I got two bad choices: either I have to delay setting the
interrupt affinity until after the queue is created, making things
awkward with several queues, or I have to out-guess the blk-mq
mapping algorithm and set the interrupt affinity prior to queue setup.

Tests with the lpfc driver found that one absolutely _does_ want to
do irq affinity; not doing so limits the performance to single-queue
results.

So what is the expected strategy here?
Or am I just too stupid to find it?

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
