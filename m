From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/4] Make blk_cleanup_queue() wait until request_fn finished
Date: Tue, 23 Oct 2012 14:16:12 +0200
Message-ID: <50868A8C.1070204@acm.org>
References: <50758EBE.7050202@acm.org> <50758F90.4020407@acm.org> <20121016235152.GL16166@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:34209 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab2JWMQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2012 08:16:15 -0400
In-Reply-To: <20121016235152.GL16166@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

On 10/17/12 01:51, Tejun Heo wrote:
>> -void blk_drain_queue(struct request_queue *q, bool drain_all)
>> +static void blk_drain_queue(struct request_queue *q, bool drain_all)
>>   {
>>   	int i;
>>
>>   	while (true) {
>> -		bool drain = false;
>> +		int drain = 0;
>
> I don't think this is necessary.  bool conversion works fine
> regardless how high the bits are.  Isn't avoiding signed/unsigned
> autocast maze one of the reasons why we're using bool to begin with?

My concern is about statements like "drain |= q->nr_rqs[i]". As far as I 
know nr_rqs can exceed the value 255 ?

Bart.
