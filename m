From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/9] move blk_iopoll to limit and make it generally
 available
Date: Sun, 15 Nov 2015 10:48:41 +0200
Message-ID: <564846E9.9070301@dev.mellanox.co.il>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-2-git-send-email-hch@lst.de>
 <CAJ3xEMgj2ycv61K38ZOowTRbrri_UhQgBcaKT0ZnnMHiBrmL5A@mail.gmail.com>
 <20151114070200.GA27738@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151114070200.GA27738-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


>> On Fri, Nov 13, 2015 at 3:46 PM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>>> The new name is irq_poll as iopoll is already taken.  Better suggestions
>>> welcome.
>>
>> Sagi (or Christoph if you can address that),
>>
>> @ some pointer over the last 18 months there was a port done at
>> mellanox for iser to use blk-iopoll and AFAIR it didn't work well or
>> didn't work at all. Can you tell now what was the problem and how did
>> you address it at your generalization?
>
> Hi Or,
>
> Sagi mentioned last time he tried a similar approach in iSER he saw
> some large latency sparks.  We've seen nothing worse than the original
> approach.  The Flash memory summit slide set has some numbers:
>
> http://www.flashmemorysummit.com/English/Collaterals/Proceedings/2015/20150811_FA11_Bandic.pdf
>
> they aren't quite up to date, but the latency distribution hasn't
> really changed.

Or is correct,

I have attempted to convert iser to use blk_iopoll in the past, however
I've seen inconsistent performance and latency skews (comparing to
tasklets iser is using today). This was manifested in IOPs test cases
where I ran multiple threads with higher queue-depth and not in
sanitized pure latency (QD=1) test cases. Unfortunately I didn't have
the time to pick it up since.

I do have every intention of testing it again with this. If it still
exist we will need to find the root-cause of it before converting
drivers to use it.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
