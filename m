From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v3 11/11] IB/srp: Fix a race condition triggered by destroying
 a queue pair
Date: Thu, 30 Oct 2014 15:53:46 +0100
Message-ID: <545250FA.1090908@acm.org>
References: <545240AE.6060009@acm.org> <5452420B.2070206@acm.org> <54524A7B.3060708@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54524A7B.3060708-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/30/14 15:26, Sagi Grimberg wrote:
> On 10/30/2014 3:50 PM, Bart Van Assche wrote:
>> +    /* Destroying a QP and reusing ch->done is only safe if not
>> connected */
>> +    WARN_ON_ONCE(target->connected);
>
> I thought we agreed that cannot happen. I guess I don't mind keeping
> it... BTW, were you able to reproduce this race as well?

Hello Sagi,

Agreed that it is possible to conclude from the ib_srp source code that 
the above "WARN_ON_ONCE(target->connected)" statement will never be 
triggered. The reason I added that statement is to have an explicit 
check of that condition. Such statements can be helpful in case anyone 
would like to modify the SRP initiator driver.

I have not yet been able to reproduce the crash addressed by this patch. 
But the code added via this patch has been triggered in my tests. Since 
this code is e.g. called from srp_free_ch_ib(), unloading the ib_srp 
kernel module after login succeeded is sufficient to trigger this code.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
