From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Sat, 15 Dec 2012 10:40:24 +0100
Message-ID: <50CC4588.1010608@acm.org>
References: <20121211000013.GI23107@beardog.cce.hp.com> <50C9F2B9.4050500@acm.org> <20121213172513.GH20898@beardog.cce.hp.com> <50CA0692.2010903@acm.org> <20121213164912.GA28496@infradead.org> <50CAF502.3070300@acm.org> <20121214164421.GQ20898@beardog.cce.hp.com> <50CB50A9.1050202@acm.org> <20121214195533.GS20898@beardog.cce.hp.com> <50CB7DF8.5020002@acm.org> <20121214210645.GV20898@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:48005 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab2LOJk3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Dec 2012 04:40:29 -0500
In-Reply-To: <20121214210645.GV20898@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com

On 12/14/12 22:06, scameron@beardog.cce.hp.com wrote:
> [ ... ] how to get the scsi mid layer to provide a wide enough
> highway for requests destined for very low latency devices.

While the SCSI mid-layer is processing an I/O request not only the queue 
lock has to be locked and unlocked several times but also the SCSI host 
lock. The reason that it's unavoidable to lock and unlock the host lock 
is because the SCSI core has been designed for SCSI equipment that has a 
queue depth limit per host (shost->can_queue). For single LUN devices 
that model could be changed in a queue depth limit per LUN. Also, it's 
probably not that hard to modify software SCSI target implementations 
such that these have a queue depth limit per LUN instead of per host. It 
might be interesting to verify whether the following approach helps to 
improve performance of the SCSI mid-layer:
* Make it possible for SCSI LLDs to tell the SCSI core whether there is
   a queue depth limit per host or per LUN.
* Do not update shost->host_busy and shost->target_busy when using the
   QD limit per LUN mode. This change will allow to avoid spin_lock()
   and spin_unlock() calls inside scsi_request_fn(). It will also allow
   to avoid having to take the host lock inside scsi_device_unbusy().
* In queue-depth-limit-per-LUN mode, neither add a SCSI device to the
   starved list if it's busy nor examine the starved list in
   scsi_run_queue().

Bart.

