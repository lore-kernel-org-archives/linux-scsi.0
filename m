From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Tue, 04 Nov 2014 14:15:00 +0200
Message-ID: <5458C344.2040109@dev.mellanox.co.il>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org> <5443F69F.40606@dev.mellanox.co.il> <54450690.709@acm.org> <544622FE.5040906@dev.mellanox.co.il> <544FE13A.60807@dev.mellanox.co.il> <5450C6FC.90908@acm.org> <545248F8.8020102@dev.mellanox.co.il> <54524D08.4040203@acm.org> <545253E3.7000009@dev.mellanox.co.il> <545256E5.9010501@acm.org> <5452765E.1040604@dev.mellanox.co.il> <5453541D.7040206@acm.org> <54562B9C.3040004@dev.mellanox.co.il> <94D0CD8314A33A4D9D801C0FE68B402959354E19@G9W0745.americas.hpqcorp.net> <5458BC8B.40202@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5458BC8B.40202-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "Elliott, Robert (Server Storage)" <Elliott-VXdhtT5mjnY@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 11/4/2014 1:46 PM, Bart Van Assche wrote:
> On 11/03/14 02:46, Elliott, Robert (Server Storage) wrote:
>>> -----Original Message-----
>>> From: Sagi Grimberg [mailto:sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
>>> Sent: Sunday, November 02, 2014 7:03 AM
>>> To: Bart Van Assche; Christoph Hellwig
>>> Cc: Jens Axboe; Sagi Grimberg; Sebastian Parschauer; Elliott, Robert
>>> (Server Storage); Ming Lei; linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma
>>> Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
>>>
>> ...
>>> IMHO, this is not iSER specific issue, it is easily indicated from the
>>> code that a specific workload SRP will poll recv completion queue
>>> forever in an interrupt context.
>>>
>>> I encountered this issue on a virtual guest in a high workload (80+
>>> sessions with heavy traffic on all) because qemu smp_affinity setting
>>> was broken (might still be, didn't check that for a while). This caused
>>> all completion vectors to fire interrupts to core 0 causing a high
>>> events contention on a single event queue (causing lockup situations
>>> and starvation of other CQs). Using more completion queues will enhance
>>> this situation.
>>>
>>> I think running multichannel code when all MSIX vectors affinity are
>>> directed to a single CPU can invoke what I'm talking about.
>>
>> That's not an SRP specific problem either.  If you ask just one CPU to
>> service interrupts and block layer completions for submissions from lots
>> of other CPUs, it's bound to become overloaded.
>>
>> Setting rq_affinity=2 helps quite a bit for the block layer completion
>> work.  This patch proposed making that the default for blk-mq:
>>     https://lkml.org/lkml/2014/9/9/931
>>
>> For SRP interrupt processing, irqbalance recently changed its default
>> to ignore the affinity_hint; you now need to pass an option to honor
>> the hint, or provide a policy script to do so for selected irqs.  For
>> multi-million IOPS workloads, irqbalance takes far too long to reroute
>> them based on activity; you're likely to overload a CPU with 100%
>> hardirq processing, creating self-detected stalls for the submitting
>> processes on that CPU and other problems.  Sending interrupts back
>> to the submitting CPU provides self-throttling.
>
> Hello Sagi,
>
> To me it seems like with Rob's reply all questions about this patch
> series have been answered. But I think Christoph is still waiting for a
> Reviewed-by tag from you for patch 12/12.
>

Hey Bart & Rob,

I'm sorry but I didn't get to reply to the Rob's email yesterday.

I think that Rob and I are not talking about the same issue. In
case only a single core is servicing interrupts it is indeed expected
that it will spend 100% in hard-irq, that's acceptable since it is
pounded with completions all the time.

However, I'm referring to a condition where SRP will spend infinite
time servicing a single interrupt (while loop on ib_poll_cq that never
drains) which will lead to a hard lockup.

This *can* happen, and I do believe that with an optimized IO path
it is even more likely to.

Anyway, since I am sure you ran sufficient testing on this code (and
didn't see the issue) and I don't want to my concerns to block this
code from 3.18, and I didn't find other gating issues, you can add:

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
