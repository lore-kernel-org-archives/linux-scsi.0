From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 4/4] scsi: Stop accepting SCSI requests before removing
 a device
Date: Wed, 06 Jun 2012 16:18:06 +0000
Message-ID: <4FCF82BE.1090505@acm.org>
References: <4FCE3D20.4000205@acm.org> <4FCE3E63.7000002@acm.org> <4FCE8349.2000908@cs.wisc.edu> <4FCF4C1E.1080300@acm.org> <4FCF5E6B.40507@cs.wisc.edu> <4FCF654A.2080900@cs.wisc.edu> <4FCF7164.70207@acm.org> <4FCF7720.6030306@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:40048 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab2FFQSO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jun 2012 12:18:14 -0400
In-Reply-To: <4FCF7720.6030306@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>

On 06/06/12 15:28, Mike Christie wrote:

> On 06/06/2012 10:04 AM, Bart Van Assche wrote:
>> I'm not sure. If a requeued request times out before blk_cleanup_queue()
>> is invoked then it's possible that the requeue_work is started after the
>> struct scsi_device has already been deleted.
> 
> Won't the cancel_work_sync call you are adding prevent that? After
> blk_cleanup_queue has returned we know that no IO is running or in the
> eh, and we know no new IO will be started. And then, after the
> cancel_work_sync call you are adding has returned we know that there
> will not be any workstruct queued or running.


We've probably each made different assumptions about whether or not the
requeue work scheduling happens under the queue lock, so we're probably
both right. I'll prepare, test and post a new patch set, that will make
the discussion easier.

Bart.

 


