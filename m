From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 05/18] block: allow specifying size for extra command data
Date: Fri, 27 Jan 2017 10:33:11 -0700
Message-ID: <7b0fd7de-55c1-508a-b875-8637dbd150aa@fb.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
 <1485365126-23210-6-git-send-email-hch@lst.de> <yq160l2a4us.fsf@oracle.com>
 <20170127161254.GA16557@lst.de> <1485537668.4267.7.camel@sandisk.com>
 <05d94df5-0ed8-5c3a-d6a6-7e9418366bb1@fb.com>
 <1485538224.4267.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485538224.4267.9.camel@sandisk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On 01/27/2017 10:30 AM, Bart Van Assche wrote:
> On Fri, 2017-01-27 at 10:26 -0700, Jens Axboe wrote:
>> On 01/27/2017 10:21 AM, Bart Van Assche wrote:
>>> On Fri, 2017-01-27 at 17:12 +0100, Christoph Hellwig wrote:
>>>> On Wed, Jan 25, 2017 at 10:15:55PM -0500, Martin K. Petersen wrote:
>>>>> +static void *alloc_request_size(gfp_t gfp_mask, void *data)
>>>>>
>>>>> I like alloc_request_simple() but alloc_request_size() seems a bit
>>>>> contrived. _reserve? _extra? _special? Don't have any good suggestions,
>>>>> I'm afraid.
>>>>
>>>> Not that I'm a fan of _size, but I like the other suggestions even less.
>>>
>>> Hello Christoph and Martin,
>>>
>>> How about using the function names alloc_full_request() / free_full_request()
>>> together with a comment that mentions that cmd_size is set by the LLD?
>>
>> Since we use pdu in other places, how about alloc_request_pdu() or
>> alloc_request_with_pdu()?
>>
>> And since it's all queued up, any bike shedding changes will have to be
>> incremental.
> 
> Hello Jens,
> 
> Other Linux subsystems use the term "private data" instead of PDU. How about
> modifying the block layer such that it uses the same terminology? I'm
> referring to function names like blk_mq_rq_from_pdu() and blk_mq_rq_to_pdu()

It's been pdu since it was introduced in 3.13, I really don't see a good
reason to change it. At least pdu or payload means something, where as
private is just... Well, not a big fan.

-- 
Jens Axboe

