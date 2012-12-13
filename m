From: scameron@beardog.cce.hp.com
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Thu, 13 Dec 2012 11:25:13 -0600
Message-ID: <20121213172513.GH20898@beardog.cce.hp.com>
References: <20121211000013.GI23107@beardog.cce.hp.com> <50C9F2B9.4050500@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:1543 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab2LMQZU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2012 11:25:20 -0500
Content-Disposition: inline
In-Reply-To: <50C9F2B9.4050500@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com, scameron@beardog.cce.hp.com

On Thu, Dec 13, 2012 at 04:22:33PM +0100, Bart Van Assche wrote:
> On 12/11/12 01:00, scameron@beardog.cce.hp.com wrote:
> >The driver, like nvme, has a submit and reply queue per cpu.
> 
> This is interesting. If my interpretation of the POSIX spec is correct 
> then aio_write() allows to queue overlapping writes and all writes 
> submitted by the same thread have to be performed in the order they were 
> submitted by that thread. What if a thread submits a first write via 
> aio_write(), gets rescheduled on another CPU and submits a second 
> overlapping write also via aio_write() ? If a block driver uses one 
> queue per CPU, does that mean that such writes that were issued in order 
> can be executed in a different order by the driver and/or hardware than 
> the order in which the writes were submitted ?
> 
> See also the aio_write() man page, The Open Group Base Specifications 
> Issue 7, IEEE Std 1003.1-2008 
> (http://pubs.opengroup.org/onlinepubs/9699919799/functions/aio_write.html).

It is my understanding that the low level driver is free to re-order the
i/o's any way it wants, as is the hardware.  It is up to the layers above
to enforce any ordering requirements.  For a long time there was a bug
in the cciss driver that all i/o's submitted to the driver got reversed
in order -- adding to head of a list instead of to the tail, or vice versa,
I forget which -- and it caused no real problems (apart from some slight
performance issues that were mostly masked by the Smart Array's cache.
It was caught by firmware guys noticing LBAs coming in in weird orders
for supposedly sequential workloads.

So in your scenario, I think the overlapping writes should not be submitted
by the block layer to the low level driver concurrently, as the block layer
is aware that the lld is free to re-order things.  (I am very certain
that this is the case for scsi low level drivers and block drivers using a
request_fn interface -- less certain about block drivers using the
make_request interface to submit i/o's, as this interface is pretty new
to me.

If I am wrong about any of that, that would be very interesting to know.

-- steve

