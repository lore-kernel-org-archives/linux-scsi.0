From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Thu, 30 Oct 2014 19:33:18 +0200
Message-ID: <5452765E.1040604@dev.mellanox.co.il>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org> <5443F69F.40606@dev.mellanox.co.il> <54450690.709@acm.org> <544622FE.5040906@dev.mellanox.co.il> <544FE13A.60807@dev.mellanox.co.il> <5450C6FC.90908@acm.org> <545248F8.8020102@dev.mellanox.co.il> <54524D08.4040203@acm.org> <545253E3.7000009@dev.mellanox.co.il> <545256E5.9010501@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <545256E5.9010501-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/30/2014 5:19 PM, Bart Van Assche wrote:
> On 10/30/14 16:06, Sagi Grimberg wrote:
>> I'm not aware of any implicit interrupt coalescing effect...
>
> In case it was not clear what I was referring to: if multiple completion
> queue handling routines run on the same CPU then the average number of
> work completions processed by each completion handling routine increases
> due to the increased time between generation of an interrupt and the
> start of the completion handler routine. As you know this helps overall
> system throughput.
>

Now I realize that we can hit serious problems here since we never
solved the issue of srp polling routine that might poll forever within
an interrupt (or at least until a hard lockup). Its interesting that
you weren't able to hit that with a high workload. Did you try running
this code on a virtual function (I witnessed this issue in iser on a VM).

Moreover, the fairness issue is even more likely to be encountered in 
multichannel. Did you try to hit that? I really think this patchset
*needs* to deal with the 2 issues I mentioned as the probability of
hitting them increases with a faster IO stack.

I remember this was discussed lately with consideration for using
blk-iopoll or not. But I think that for now the initial approach of
bailing out of the once we hit a budget is fine for now.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
