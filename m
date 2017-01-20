From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Thu, 19 Jan 2017 16:13:40 -0800
Message-ID: <0e0dd594-5348-9ccb-5929-b1ec73234f7c@kernel.dk>
References: <20170111134312.GH6286@linux-x5ow.site>
 <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
 <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
 <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
 <499af528-7810-f82d-1f11-cbf8f3a5b21c@grimberg.me>
 <CANvN+emx1-F3iAY45t1_MQRcijw7sf1jPvjwv0uh8A3GzzQwMg@mail.gmail.com>
 <e2b16f22-5743-23c8-cd20-13a20ec956b7@grimberg.me>
 <4ad78959-3991-98f1-4c27-298b20163e52@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <4ad78959-3991-98f1-4c27-298b20163e52@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/18/2017 06:02 AM, Hannes Reinecke wrote:
> On 01/17/2017 05:50 PM, Sagi Grimberg wrote:
>>
>>>     So it looks like we are super not efficient because most of the
>>>     times we catch 1
>>>     completion per interrupt and the whole point is that we need to find
>>>     more! This fio
>>>     is single threaded with QD=32 so I'd expect that we be somewhere in
>>>     8-31 almost all
>>>     the time... I also tried QD=1024, histogram is still the same.
>>>
>>>
>>> It looks like it takes you longer to submit an I/O than to service an
>>> interrupt,
>>
>> Well, with irq-poll we do practically nothing in the interrupt handler,
>> only schedule irq-poll. Note that the latency measures are only from
>> the point the interrupt arrives and the point we actually service it
>> by polling for completions.
>>
>>> so increasing queue depth in the singe-threaded case doesn't
>>> make much difference. You might want to try multiple threads per core
>>> with QD, say, 32
>>
>> This is how I ran, QD=32.
> 
> The one thing which I found _really_ curious is this:
> 
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%,
>> =64=100.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> =64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> =64=0.1%
>      issued    : total=r=7673377/w=0/d=0, short=r=0/w=0/d=0,
> drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=256
> 
> (note the lines starting with 'submit' and 'complete').
> They are _always_ 4, irrespective of the hardware and/or tests which I
> run. Jens, what are these numbers supposed to mean?
> Is this intended?

It's bucketized. 0=0.0% means that 0% of the submissions didn't submit
anything (unsurprisingly), and ditto for the complete side. The next bucket
is 1..4, so 100% of submissions and completions was in that range.

-- 
Jens Axboe

