From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] block: Make blk_drain_queue() work for stopped queues
Date: Tue, 20 Mar 2012 20:04:21 +0000
Message-ID: <4F68E2C5.6010201@acm.org>
References: <4F65E09D.6010600@acm.org> <20120318155703.GB8045@dhcp-172-17-108-109.mtv.corp.google.com> <4F663BE3.4000503@acm.org> <20120319170435.GH11069@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:41141 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab2CTUEZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2012 16:04:25 -0400
In-Reply-To: <20120319170435.GH11069@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Stanislaw Gruszka <sgruszka@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 03/19/12 17:04, Tejun Heo wrote:
> I don't think it's a good idea to push requests out to stopped queue.
> Wouldn't aborting all pending requests be better? Thanks. 

How about the (lightly tested) patch below ? It combines three separate
changes:
- Making blk_drain_queue() ignore the stopped state of a queue.
- Add struct request_queue.kill_all_requests_fn.
- Fix a null pointer dereference triggered by sd during device removal.
