From: scameron@beardog.cce.hp.com
Subject: SCSI mid layer and high IOPS capable devices
Date: Mon, 10 Dec 2012 18:00:13 -0600
Message-ID: <20121211000013.GI23107@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:29177 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2LJXAQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Dec 2012 18:00:16 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: stephenmcameron@gmail.com, scameron@beardog.cce.hp.com, dab@hp.com


Is there any work going on to improve performance of the SCSI layer
to better support devices capable of high IOPS?

I've been playing around with some flash-based devices and have
a block driver that uses the make_request interface (calls
blk_queue_make_request() rather than blk_init_queue()) and a
SCSI LLD variant of the same driver.  The block driver is similar
in design and performance to the nvme driver.

If I compare the performance, the block driver gets about 3x the
performance as the SCSI LLD.  The SCSI LLD spends a lot of time
(according to perf) contending for locks in scsi_request_fn(),
presumably the host lock or the queue lock, or perhaps both.

All other things being equal, a SCSI LLD would be preferable to
me, but, with performance differing by a factor of around 3x, all
other things are definitely not equal.

I tried using scsi_debug with fake_rw and also the scsi_ram driver
that was recently posted to get some idea of what the maximum IOPS
that could be pushed through the SCSI midlayer might be, and the
numbers were a little disappointing (was getting around 150k iops
with scsi_debug with reads and writes faked, and around 3x that
with the block driver actually doing the i/o).

Essentially, what I've been finding out is consistent with what's in
this slide deck: http://static.usenix.org/event/lsf08/tech/IO_Carlson_Accardi_SATA.pdf

The driver, like nvme, has a submit and reply queue per cpu.
I'm sort of guessing that funnelling all the requests through
a single request queue per device that only one cpu can touch
at a time as the scsi mid layer does is a big part of what's
killing performance.  Looking through the scsi code, if I read
it correctly, the assumption that each device has a request queue
seems to be all over the code, so how exactly one might go about
attempting to improve the situation is not really obvious to me.

Anyway, just wondering if anybody is looking into doing some
improvements in this area.

-- steve

