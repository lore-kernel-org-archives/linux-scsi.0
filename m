From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Mon, 24 Nov 2014 10:33:37 -0700
Message-ID: <54736BF1.5050305@kernel.dk>
References: <alpine.LRH.2.11.1411150829190.26813@adalberg.ut.ee> <546771B4.1010507@kernel.dk> <20141120060135.GA2862@infradead.org> <20141121.145600.2001813891553289235.davem@davemloft.net> <20141124082132.GA22971@infradead.org> <54735052.7020807@kernel.dk> <20141124162249.GG5050@linux.vnet.ibm.com> <547367DF.5060706@kernel.dk> <20141124173129.GL5050@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20141124173129.GL5050@linux.vnet.ibm.com>
Sender: sparclinux-owner@vger.kernel.org
To: paulmck@linux.vnet.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>, David Miller <davem@davemloft.net>, mroos@linux.ee, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/24/2014 10:31 AM, Paul E. McKenney wrote:
> On Mon, Nov 24, 2014 at 10:16:15AM -0700, Jens Axboe wrote:
>> On 11/24/2014 09:22 AM, Paul E. McKenney wrote:
>>> On Mon, Nov 24, 2014 at 08:35:46AM -0700, Jens Axboe wrote:
>>>> On 11/24/2014 01:21 AM, Christoph Hellwig wrote:
>>>>> On Fri, Nov 21, 2014 at 02:56:00PM -0500, David Miller wrote:
>>>>>> I would suggest looking into the possibility that we allocate the memory
>>>>>> using the count of valid cpus, rather than the largest cpu number.
>>>>>>
>>>>>> That's a common error that runs into problems with discontiguous
>>>>>> cpu numbering like Sparc sometimes has.
>>>>>
>>>>> Yes, that does look like the case.  Do you have a good trick on how
>>>>> to allocate a map for the highest possible cpu number without first
>>>>> iterating the cpu map?  I couldn't find something that looks like a
>>>>> highest_possible_cpu() helper.
>>>>
>>>> Honestly I think that num_posible_cpus() should return the max of
>>>> number of CPUs (weigt), and the highest numbered CPU. It's a pain in
>>>> the butt to handle this otherwise.
>>>
>>> Hear, hear!!!  That would make my life easier, and would make this sort
>>> of problem much less likely to occur!
>>
>> How about this one?
>
> Works for me!

Thanks! I'll add an appropriate comment and send it out for review.

> (Just for the record, as far as I know, this doesn't matter for RCU,
> which already uses nr_cpu_ids.)

Was that done after hitting something like this?

Meelis, can you check if it fixes your issue?


-- 
Jens Axboe

