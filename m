From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/4] block: Fix race on request_queue.end_io invocations
Date: Wed, 06 Jun 2012 12:44:36 +0000
Message-ID: <4FCF50B4.6000701@acm.org>
References: <4FCE3D20.4000205@acm.org> <4FCE3D77.8040909@acm.org> <20120605213248.GB3700@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03ant.iops.be ([212.53.5.218]:57962 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2FFMoo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jun 2012 08:44:44 -0400
In-Reply-To: <20120605213248.GB3700@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Jens Axboe <axboe@kernel.dk>

On 06/05/12 21:32, Tejun Heo wrote:

> On Tue, Jun 05, 2012 at 05:10:15PM +0000, Bart Van Assche wrote:
>> Some request_queue.end_io implementations can be called safely
>> without the queue lock held while several other implementations
>> assume that the queue lock is held. So let's play it safe and
>> make sure that the queue lock is held around end_io invocations.
>> Found this through source code review.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: <stable@kernel.org>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Not sure about stable@ tho.  This doesn't fix any visible issue at the
> moment and any change carries some risk.


I don't have a strong opinion about cc-ing stable - leaving out that tag
is fine for me.

Bart.
