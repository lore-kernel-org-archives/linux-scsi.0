From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM TOPIC] multiqueue and interrupt assignment
Date: Tue, 2 Feb 2016 17:31:11 +0100
Message-ID: <56B0D9CF.1080001@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698AbcBBQbN (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2016 11:31:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

Hi all,

here's another topic which I've hit during my performance tests:
How should interrupt affinity be handled with blk-multiqueue?

The problem is that the blk-multiqueue assumes a certain
CPU-to-queue mapping, _and_ the 'queue' in blk-mq syntax is actually
a submission/completion queue pair.

To achieve optimal performance one should set the interrupt affinity
for a given (hardware) queue to the matchine (blk-mq) queue.
But typically the interrupt affinity has to be set during HBA setup
ie way before any queues are allocated.
Which means we have three choices:
- outguess the blk-mq algorithm in the driver and set the
  interrupt affinity during HBA setup
- Add some callbacks to coordinate interrupt affinity between
  driver and blk-mq
- Defer it to manual assignment, but inferring the risk of
  a suboptimal performance.

At LSF/MM  I would like to have a discussion on how the interrupt
affinity should be handled for blk-mq, and whether a generic method
is possible or desirable.
Also there is the issue of certain drivers (eg lpfc) which normally
do interrupt affinity themselves, but disable it for multiqueue.
Which results in abysmal performance when comparing single queue
against multiqueue :-(

As a side note, what does blk-mq do if the interrupt affinity is
_deliberately_ set wrong? IE if the completions for one command
arrive on completely the wrong queue? Discard the completion? Move
it to the correct queue?

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
