From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Mon, 20 Oct 2014 13:57:21 +0200
Message-ID: <5444F8A1.4060701@acm.org>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org> <20141017110627.GD7819@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141017110627.GD7819-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/17/14 13:06, Christoph Hellwig wrote:
>>   	} else {
>> +		if (blk_mq_unique_tag_to_hwq(rsp->tag) != ch - target->ch)
>> +			pr_err("Channel idx mismatch: tag %#llx <> ch %#lx\n",
>> +			       rsp->tag, ch - target->ch);
>>   		scmnd = scsi_host_find_tag(target->scsi_host, rsp->tag);
>
> Shouldn't we do this validity check inside scsi_host_find_tag, so that
> all callers get it? That means adding an argument to it,  but there are
> very few callers at the moment.

Hello Christoph,

That pr_err() statement was convenient while debugging the multiqueue 
code in the SRP initiator driver but can be left out. Would you agree 
with leaving the above three lines of debug code out instead of adding 
an additional argument to scsi_host_find_tag() ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
