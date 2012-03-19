From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] block: Make blk_drain_queue() work for stopped queues
Date: Mon, 19 Mar 2012 17:22:58 +0000
Message-ID: <4F676B72.4080804@acm.org>
References: <4F65E09D.6010600@acm.org> <20120318155703.GB8045@dhcp-172-17-108-109.mtv.corp.google.com> <4F663BE3.4000503@acm.org> <20120319170435.GH11069@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:45552 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab2CSRXE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2012 13:23:04 -0400
In-Reply-To: <20120319170435.GH11069@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Stanislaw Gruszka <sgruszka@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 03/19/12 17:04, Tejun Heo wrote:
> Thanks for the pointer. It would be great if you can describe / link
> the actual case the patch is trying to solve.

Another example is the sd scanning code (sd_probe_async()) which can
queue SCSI commands concurrently with the blk_cleanup_queue() call
called (indirectly) from scsi_remove_host().

>
>> there is still a tiny race window left by that patch - new
>> requests can get queued after the SCSI request function has been invoked
>> by scsi_free_queue() and before blk_cleanup_queue() gets invoked. Hence
>> the proposal to change the block layer to make sure that all queued
>> requests get processed eventually.
> I don't think it's a good idea to push requests out to stopped queue.
> Wouldn't aborting all pending requests be better?

Sure, but is that possible from inside the block layer ? With patch
http://marc.info/?l=linux-scsi&m=133207725114386 applied, the following
code is present at the start of scsi_request_fn():

	if (unlikely(blk_queue_dead(q))) {
 		while ((req = blk_peek_request(q)) != NULL)
 			scsi_kill_request(req, q);

Bart.

