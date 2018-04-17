From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-mq: Clear out elevator private data
Date: Tue, 17 Apr 2018 17:00:01 -0600
Message-ID: <ddaa34ef-b143-1739-d227-c4b09dad6f6c@kernel.dk>
References: <20180417214218.GA44753@beast>
 <7d192394-568c-53e0-4359-723769c3ed7d@kernel.dk>
 <CAGXu5jLLn9HxkR0G6=-Qqjr__=ya_NM3zCLsZwa1V5m7fisQ5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLLn9HxkR0G6=-Qqjr__=ya_NM3zCLsZwa1V5m7fisQ5A@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, LKML <linux-kernel@vger.kernel.org>, Paolo Valente <paolo.valente@linaro.org>, Bart Van Assche <bart.vanassche@wdc.com>, David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 4/17/18 4:57 PM, Kees Cook wrote:
> On Tue, Apr 17, 2018 at 2:45 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 4/17/18 3:42 PM, Kees Cook wrote:
>>> Some elevators may not correctly check rq->rq_flags & RQF_ELVPRIV, and
>>> may attempt to read rq->elv fields. When requests got reused, this
>>> caused BFQ to think it already had a bfqq (rq->elv.priv[1]) allocated.
>>> This could lead to odd behaviors like having the sense buffer address
>>> slowly start incrementing. This eventually tripped HARDENED_USERCOPY
>>> and KASAN.
>>>
>>> This patch wipes all of rq->elv instead of just rq->elv.icq. While
>>> it shouldn't technically be needed, this ends up being a robustness
>>> improvement that should lead to at least finding bugs in elevators faster.
>>
>> Comments from the other email still apply, we should not need to do this
>> full memset() for every request. From a quick look, BFQ needs to straighten
>> out its usage of prepare request and interactions with insert_request.
> 
> Sure, understood. I would point out, FWIW, that memset() gets unrolled
> by the compiler and this is just two more XORs in the same cacheline
> (the two words following icq). (And there is SO much more being
> cleared during alloc, it didn't seem like hardly any extra cost vs the
> robustness it provided.)

Yeah, it's not super pricey, but it's not needed. BFQ is the user of
the members, and the one that assigns them. You're saying leftover
assignments, since it doesn't always assign them. Hence I think that's
a better fix, just sent out a test patch a few minutes ago.

You did all the hard work, I'm just coasting on your findings.

-- 
Jens Axboe
