From: Jens Axboe <axboe@suse.de>
Subject: Re: [RFC]: performance improvement by coalescing requests?
Date: Mon, 20 Jun 2005 22:24:27 +0200
Message-ID: <20050620202427.GB7712@suse.de>
References: <60807403EABEB443939A5A7AA8A7458B01520EDD@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:43191 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261475AbVFTUXH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 16:23:07 -0400
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B01520EDD@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Jun 20 2005, Salyzyn, Mark wrote:
> This is not a patch to be applied to any release, for discussion only.
> 
> We have managed to increase the performance of the I/O to the driver by
> pushing back on the scsi_merge layer when we detect that we are issuing
> sequential requests (patch enclosed below to demonstrate the technique
> used to investigate). In the algorithm used, when we see that we have an
> I/O that adjoins the previous request, we reduce the queue depth to a
> value of 2 for the device. This allows the incoming I/O to be
> scrutinized by the scsi_merge layer for a bit longer permitting them to
> be merged together into a larger more efficient request.
> 
> By limiting the queue to a depth of two, we also do not delay the system
> much since we keep one worker and one outstanding remaining in the
> controller. This keeps the I/O's fed without delay.
> 
> The net result was instead of receiving, for example, 64 4K sequential
> I/O requests to an eager controller more than willing to accept the
> commands into it's domain, we instead see two 4K I/O requests, followed
> by one 248KB I/O request.
> 
> I would like to hear from the luminaries about how we could move this
> proposed policy to the scsi or block layers for a generalized increase
> in Linux performance.
> 
> One should note that this kind of policy to deal with sequential I/O
> activity is not new in high performance operating systems. It is simply
> lacking in the Linux I/O layers.

You say io, but I guess you mean writes in particular? If someone is
queuing large chunks of reads in 4kb sizes and starting a wait on the
first one immediately, that would defeat plugging and cause suboptimal
performance. That would be caller bug to be addressed though. So I'm
surprised that you see this happening, the plugging should handle this
case just fine. Or for any substantial amount of io, you would be
queueing it so fast that it should have plenty of time to be merged
until the drive sucks them in. For sequential io submitted in 4kb
chunks, by default we would not be invoking the request handler until we
have queued 4 (unplug_thresh) requests of 256kb (assuming that's the
adapter limit) or a few ms have passed. And a few ms should be enough
time to queue that amount many many times over.

Do you see this happening right from a queue depth of 1? I'm curious as
to what the testing scenario is that is able to provoke suboptimal
behavior in this way.

-- 
Jens Axboe

