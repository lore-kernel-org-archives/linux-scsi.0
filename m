From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 01/12] scsi_transport_srp: Introduce srp_wait_for_queuecommand()
Date: Thu, 30 Apr 2015 17:13:30 +0300
Message-ID: <5542388A.5050008@dev.mellanox.co.il>
References: <5541EE21.3050809@sandisk.com> <5541EE4A.30803@sandisk.com> <20150430093719.GA23486@infradead.org> <5542034D.5010300@sandisk.com> <554204D7.9050204@dev.mellanox.co.il> <55420AEA.10108@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55420AEA.10108-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 4/30/2015 1:58 PM, Bart Van Assche wrote:
> On 04/30/15 12:33, Sagi Grimberg wrote:
>> On 4/30/2015 1:26 PM, Bart Van Assche wrote:
>>> On 04/30/15 11:37, Christoph Hellwig wrote:
>>>> On Thu, Apr 30, 2015 at 10:56:42AM +0200, Bart Van Assche wrote:
>>>>> Introduce the helper function srp_wait_for_queuecommand().
>>>>> Move the definition of scsi_request_fn_active(). This patch
>>>>> does not change any functionality. A second call to
>>>>> scsi_wait_for_queuecommand() will be introduced in the next
>>>>> patch.
>>>>
>>>> Can we take a step back here?
>>>>
>>>> This isn;t something driver should be doing, so we really should take
>>>> care of this in the SCSI midlayer.
>>>>
>>>> Especially given that we don't maintain request_fn_active for blk-mq.
>>>
>>> Hello Christoph,
>>>
>>> How about the following:
>>> * Modify scsi_target_block() and scsi_target_unblock(...,
>>>     SDEV_TRANSPORT_OFFLINE) such that these functions wait until
>>>     active queuecommand() calls have finished.
>>
>> Won't this make scsi_target_unblock a sleeping function? It might
>> not fit all the contexts scsi_target_unblock is called.
>
> The only callers in upstream code of scsi_target_block() and
> scsi_target_unblock() I am aware of are the FC, iSCSI and SRP transport
> layers and the drivers that use these transport layers. As far as I can
> see both functions are always called from thread context and without
> holding any spinlocks. A possible alternative to what I proposed in my
> previous e-mail could be to provide a new function that waits for active
> queuecommand() calls and that has to be called explicitly.
>

Maybe that might be better.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
