From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Thu, 30 Oct 2014 17:06:11 +0200
Message-ID: <545253E3.7000009@dev.mellanox.co.il>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org> <5443F69F.40606@dev.mellanox.co.il> <54450690.709@acm.org> <544622FE.5040906@dev.mellanox.co.il> <544FE13A.60807@dev.mellanox.co.il> <5450C6FC.90908@acm.org> <545248F8.8020102@dev.mellanox.co.il> <54524D08.4040203@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54524D08.4040203-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/30/2014 4:36 PM, Bart Van Assche wrote:
> On 10/30/14 15:19, Sagi Grimberg wrote:
>> My impression here that in the default settings, on a 1 NUMA node with
>> 8 cores, 2 different srp connections (using 4 channels each) will be
>> associated with comp vectors 0-3. while it could potentially use
>> vectors 4-7 and reduce possible mutual interference. right?
>
> Hello Sagi,
>
> That's correct. For this example if use of all completion vectors is
> desired additional configuration is required, e.g. by setting ch_count
> to 8 in /etc/modprobe.d/ib_srp.conf.

That is why I think that the user is still expected to be aware of
the configuration in order to get max performance. I would like to
see best performance to "just work". For example, I don't see any sort
of sw queue count to configure, it "just works".

Now I also agree with this may mean more (or sometimes way more)
resources, but I suggest that if we go with default of 4 per numa node
we should take care of such situations.

I'm not strict about this wrt to this patch set. But I think we should
consider this bit.

> By the way, I'm not sure it is
> possible to avoid manual configuration and tuning entirely. As an
> example, with a six core CPU at the initiator side and with
> hyperthreading enabled (12 CPU threads in total) I see higher IOPS
> results with ch_count=6 compared to ch_count=8 or ch_count=12.
> I have
> not tried to determine why but maybe this is because ch_count values
> that are below the number of CPU threads cause some interrupt coalescing.

I'm not aware of any implicit interrupt coalescing effect...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
