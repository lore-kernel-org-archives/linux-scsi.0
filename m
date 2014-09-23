From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Tue, 23 Sep 2014 13:02:55 -0600
Message-ID: <5421C3DF.5000102@acm.org>
References: <541C27BF.6070609@acm.org> <541C28E0.7010705@acm.org> <5421A093.1070203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5421A093.1070203-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 23/09/2014 10:32, Sagi Grimberg wrote:
> On 9/19/2014 4:00 PM, Bart Van Assche wrote:
>> Improve performance by using multiple RDMA/RC channels per SCSI host
>> for communicating with an SRP target.
>>
>
> Hey Bart,
>
> Since you don't seem to negotiate/declare multichannel with the target,
> did you test this code with some target implementations other than SCST
> that happen to be out there?
>
> Overall, I think this patch would be easier to review if you also 
> provide a list of logical changes (which obviously are introduced in 
> this patch). Patch 7/8 can use some more information of target-channel
> relations as well.

Hello Sagi,

That's a good question. So far this patch series has only been tested 
against the SCST SRP target driver. However, as you probably noticed, if 
setting up a second or later RDMA channel fails SRP login is not failed 
but communication proceeds with the number of channels that have been 
established. This mechanism should retain backwards compatibility with 
SRP target systems that do not support multichannel communication. 
However, if the new code for SRP login turns out to be triggering bugs 
in existing SRP target implementations we can still add a blacklist for 
these implementations.

I will provide a more detailed list of logical changes in the second 
version of this patch series.

Bart.
Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
