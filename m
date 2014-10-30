From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v3 11/11] IB/srp: Fix a race condition triggered by destroying
 a queue pair
Date: Thu, 30 Oct 2014 17:10:10 +0200
Message-ID: <545254D2.3080707@dev.mellanox.co.il>
References: <545240AE.6060009@acm.org> <5452420B.2070206@acm.org> <54524A7B.3060708@dev.mellanox.co.il> <545250FA.1090908@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42430 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013AbaJ3PKP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 11:10:15 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so4830759wiv.7
        for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2014 08:10:14 -0700 (PDT)
In-Reply-To: <545250FA.1090908@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 10/30/2014 4:53 PM, Bart Van Assche wrote:
> On 10/30/14 15:26, Sagi Grimberg wrote:
>> On 10/30/2014 3:50 PM, Bart Van Assche wrote:
>>> +    /* Destroying a QP and reusing ch->done is only safe if not
>>> connected */
>>> +    WARN_ON_ONCE(target->connected);
>>
>> I thought we agreed that cannot happen. I guess I don't mind keeping
>> it... BTW, were you able to reproduce this race as well?
>
> Hello Sagi,
>
> Agreed that it is possible to conclude from the ib_srp source code that
> the above "WARN_ON_ONCE(target->connected)" statement will never be
> triggered. The reason I added that statement is to have an explicit
> check of that condition. Such statements can be helpful in case anyone
> would like to modify the SRP initiator driver.
>

Yea, OK.

> I have not yet been able to reproduce the crash addressed by this patch.
> But the code added via this patch has been triggered in my tests. Since
> this code is e.g. called from srp_free_ch_ib(), unloading the ib_srp
> kernel module after login succeeded is sufficient to trigger this code.

Yes of course, was just curious to know if you got this crash as well...

Sagi.
