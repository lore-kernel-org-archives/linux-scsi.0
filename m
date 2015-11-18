From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Wed, 18 Nov 2015 09:59:15 +0200
Message-ID: <564C2FD3.6090608@dev.mellanox.co.il>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-4-git-send-email-hch@lst.de>
 <564851BB.1020004@dev.mellanox.co.il> <564B5E7D.9030309@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564B5E7D.9030309-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org



On 17/11/2015 19:06, Bart Van Assche wrote:
> On 11/15/2015 01:34 AM, Sagi Grimberg wrote:
>> This is taken from srp, and srp drains using a recv wr due to a race
>> causing a use-after-free condition in srp which re-posts a recv buffer
>> in the recv completion handler.
>
> Hello Sagi,
>
> Would it be possible to clarify this ? Does this refer to an existing
> race or a race that would only occur if the code would be modified ?

I was referring to a bug that srp_destroy_qp() was design to
address:

commit 7dad6b2e440d810273946b0e7092a8fe043c3b8a
Author: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Date:   Tue Oct 21 18:00:35 2014 +0200

     IB/srp: Fix a race condition triggered by destroying a queue pair

     At least LID reassignment can trigger a race condition in the SRP
     initiator driver, namely the receive completion handler trying to
     post a request on a QP during or after QP destruction and before
     the CQ's have been destroyed. Avoid this race by modifying a QP
     into the error state and by waiting until all receive completions
     have been processed before destroying a QP.

     Reported-by: Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
     Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
     Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
     Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
