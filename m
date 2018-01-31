From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [dm-devel] [PATCH v5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 30 Jan 2018 20:31:33 -0700
Message-ID: <e8787489-845a-4370-7338-727cd5ed7650@kernel.dk>
References: <20180130142459.52668-1-snitzer@redhat.com>
 <43ac2314-c98d-bb76-0dfb-171d15cc5fd8@wdc.com>
 <7baf8e0f-7a15-4529-c32b-4ce0ee172598@kernel.dk>
 <1517368861.4421.2.camel@wdc.com>
 <d563628f-687d-c463-7e7e-d85a52cdf25b@kernel.dk>
 <1517369237.4421.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:36930 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752529AbeAaDbm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2018 22:31:42 -0500
Received: by mail-pf0-f181.google.com with SMTP id p1so11233115pfh.4
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2018 19:31:42 -0800 (PST)
In-Reply-To: <1517369237.4421.3.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On 1/30/18 8:27 PM, Bart Van Assche wrote:
> On Tue, 2018-01-30 at 20:22 -0700, Jens Axboe wrote:
>> On 1/30/18 8:21 PM, Bart Van Assche wrote:
>>> On Tue, 2018-01-30 at 20:17 -0700, Jens Axboe wrote:
>>>> BLK_STS_RESOURCE should always be safe to return, and it should work
>>>> the same as STS_DEV_RESOURCE, except it may cause an extra queue
>>>> run.
>>>>
>>>> Well written drivers should use STS_DEV_RESOURCE where it makes
>>>> sense.
>>>
>>> Hello Jens,
>>>
>>> I would appreciate it if other names would be chosen than BLK_STS_RESOURCE
>>> and BLK_STS_DEV_RESOURCE, e.g. names that directly refer to the fact that
>>> one of the two status codes causes the queue to be rerun and the other not.
>>> I'm afraid that the currently chosen names will cause confusion.
>>
>> DEV_RESOURCE is pretty clear I think, but I agree that STS_RESOURCE
>> could perhaps be better. STS_SYSTEM_RESOURCE? It makes the distinction
>> a bit clearer.
> 
> I'm concerned about both. A block driver can namely run out of device
> resources without receiving a notification if that resource becomes
> available again.

That is true, and that is why I don't want to driver to make guesses on
when to re-run. The saving grace here is that it should happen extremely
rarely. I went over this in a previous email. If it's not a rare
occurence, then there's no other way around it then wiring up a
notification mechanism to kick the queue when the shortage clears.

One way to deal with that is making the assumption that other IO will
clear the issue. That means we can confine it to the blk-mq layer.
Similarly to how we currently sometimes have to track starvation across
hardware queues and restart queue X when Y completes IO, we may have to
have a broader scope of shortage. That would probably fix all bug
pathological cases.

> In that case the appropriate return code is BLK_STS_RESOURCE. Hence my
> concern ...

But this isn't a new thing, the only real change here is making it so
that drivers don't have to think about that case.

-- 
Jens Axboe
