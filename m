From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Mon, 24 Nov 2014 15:01:55 -0700
Message-ID: <5473AAD3.7010409@kernel.dk>
References: <54735052.7020807@kernel.dk>	<20141124162249.GG5050@linux.vnet.ibm.com>	<547367DF.5060706@kernel.dk> <20141124.165623.42259031853400756.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20141124.165623.42259031853400756.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: paulmck@linux.vnet.ibm.com, hch@infradead.org, mroos@linux.ee, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/24/2014 02:56 PM, David Miller wrote:
> From: Jens Axboe <axboe@kernel.dk>
> Date: Mon, 24 Nov 2014 10:16:15 -0700
>
>> How about this one?
>
> The "num" in num_possible_cpus() means a count, as in how many are
> there.
>
> It doesn't mean largest ID of members of set X, which is what you
> are asking for.
>
> Even worse, having num_online_cpus() and num_possible_cpus() count
> from a different perspective is really confusing.

Not disagreeing with you... Personally I don't care too much, I can just 
work-around this in blk-mq. I'm more worried about others reimplementing 
the same bugs later. And yes, the fact that's it's the weight of the 
bitmap is exactly the problem, as we have no good way of saying 
"allocate me this array indexed by cpu count", since we don't know the 
numbers of the CPUs. This isn't a problem on x86 (or on anything but 
sparc64, as far as I'm aware), since the weight and highest CPU count 
are one and the same.

> Usually when people want a per-cpu thing they allocate percpu
> memory which hides all of these details, why don't you allocate
> the map as dynamic per-cpu memory?
>
> It will also do the NUMA node local allocations for you as well.

The allocation is node affine currently. This isn't per-cpu storage, for 
the per-cpu storage blk-mq uses the normal per-cpu primitives for 
alloctions. It's just a small array mapping a cpu number to a hardware 
queue number. It's read-only storage, after it has been updated.

I'll just updated blk-mq to use nr_cpu_ids and be done with it.

-- 
Jens Axboe

