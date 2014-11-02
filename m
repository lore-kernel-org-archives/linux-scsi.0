From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Sun, 02 Nov 2014 15:03:24 +0200
Message-ID: <54562B9C.3040004@dev.mellanox.co.il>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org> <5443F69F.40606@dev.mellanox.co.il> <54450690.709@acm.org> <544622FE.5040906@dev.mellanox.co.il> <544FE13A.60807@dev.mellanox.co.il> <5450C6FC.90908@acm.org> <545248F8.8020102@dev.mellanox.co.il> <54524D08.4040203@acm.org> <545253E3.7000009@dev.mellanox.co.il> <545256E5.9010501@acm.org> <5452765E.1040604@dev.mellanox.co.il> <5453541D.7040206@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5453541D.7040206-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/31/2014 11:19 AM, Bart Van Assche wrote:
> On 10/30/14 18:33, Sagi Grimberg wrote:
>> Now I realize that we can hit serious problems here since we never
>> solved the issue of srp polling routine that might poll forever within
>> an interrupt (or at least until a hard lockup). Its interesting that
>> you weren't able to hit that with a high workload. Did you try running
>> this code on a virtual function (I witnessed this issue in iser on a VM).
>>
>> Moreover, the fairness issue is even more likely to be encountered in
>> multichannel. Did you try to hit that? I really think this patchset
>> *needs* to deal with the 2 issues I mentioned as the probability of
>> hitting them increases with a faster IO stack.
>>
>> I remember this was discussed lately with consideration for using
>> blk-iopoll or not. But I think that for now the initial approach of
>> bailing out of the once we hit a budget is fine for now.
>
> Hello Sagi,
>
> As you mentioned so far this fairness issue has only caused trouble with
> iSER in a virtual machine guest. I have not yet seen anyone reporting a
> QP servicing fairness problem for the SRP initiator.

IMHO, this is not iSER specific issue, it is easily indicated from the
code that a specific workload SRP will poll recv completion queue
forever in an interrupt context.

I encountered this issue on a virtual guest in a high workload (80+
sessions with heavy traffic on all) because qemu smp_affinity setting
was broken (might still be, didn't check that for a while). This caused 
all completion vectors to fire interrupts to core 0 causing a high
events contention on a single event queue (causing lockup situations
and starvation of other CQs). Using more completion queues will enhance
this situation.

I think running multichannel code when all MSIX vectors affinity are
directed to a single CPU can invoke what I'm talking about.

> Although analyzing
> and if needed limiting the maximum number of iterations in the SRP
> polling routine is on my to-do list, addressing that issue is outside of
> the scope of this patch series.

Although both of us did not yet hear of such complaints from SRP users,
I disagree because this might make the problems worse. But if you want
to take it later I guess that's fine too.

>
> Regarding the impact of this patch series on QP handling fairness: the
> time spent in the SRP RDMA completion handler depends on the number of
> completions processed at once. This number depends on:
> (a) The number of CPU cores in the initiator system that submit I/O and
>      that are associated with a single RDMA channel.
> (b) The target system processing speed per RDMA channel.
>
> This patch series reduces (a) by a factor ch_count.

This is under the assumption that IRQ affinity is spread across several
CPUS and that's fine, but we should *not* hit a hard lockup in case it
is not (and I suspect we can).

> (b) is either
> unaffected (linear scaling) or slightly reduced (less than linear
> scaling). My conclusion is that if this patch series has an impact on QP
> handling fairness that it will improve fairness since the number of
> completions processed at once either remains unchanged or that it is
> reduced.
>

I think in the single CPU completion queue processing, this can enhance
the problem as well.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
