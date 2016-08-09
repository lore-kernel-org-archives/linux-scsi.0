From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 02/28] be2iscsi: Replace _bh with _irqsave/irqrestore
Date: Tue, 9 Aug 2016 12:48:32 -0500
Message-ID: <57AA1770.6010802@redhat.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1469092085-14311-3-git-send-email-jitendra.bhivare@broadcom.com>
 <57A4DD34.4080000@redhat.com> <yq1popivjjk.fsf@sermon.lab.mkp.net>
 <2c0a32a2af7f12150da2818d0b0ec4d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbcHIRse (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2016 13:48:34 -0400
In-Reply-To: <2c0a32a2af7f12150da2818d0b0ec4d6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 08/09/2016 03:29 AM, Jitendra Bhivare wrote:
>> -----Original Message-----
>> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
>> Sent: Tuesday, August 09, 2016 6:35 AM
>> To: Mike Christie
>> Cc: Jitendra Bhivare; linux-scsi@vger.kernel.org
>> Subject: Re: [PATCH 02/28] be2iscsi: Replace _bh with
> _irqsave/irqrestore
>>
>>>>>>> "Mike" == Mike Christie <mchristi@redhat.com> writes:
>>
>>>> In beiscsi_alloc_pdu, _bh versions of spin_lock are being used for
>>>> protecting SGLs and WRBs. _bh versions are needed as the function
>>>> gets invoked in process context and BLOCK_IOPOLL softirq.
>>>>
>>>> In spin_unlock_bh, after releasing the lock and enabling BH,
>>>> do_softirq is called which executes till last SOFTIRQ.
>>>>
>>>> beiscsi_alloc_pdu is called under session lock. Through block layer,
>>>> iSCSI stack in some cases send IOs with interrupts disabled. In such
>>>> paths,
>>
>>
>> Mike> What path is this? Is this with mq enabled or disabled?
>>
>> Jitendra?
>>
>> --
>> Martin K. Petersen	Oracle Linux Engineering
> [JB] Sorry for the delayed response, there was some issue with my mail
> client.
> There are paths block layer where IRQs are disabled with request_queue
> queue_lock.
> - blk_timeout_work : this triggers NOP-OUT thru' iscsi_eh_cmd_timed_out.
> - blk_execute_rq_nowait

I am not sure I understand the problem/solution. Why does the patch only
need to modify be2iscsi's locking? Why wouldn't you need to also change
the libiscsi session lock locking? You don't need irqs to be running
right? You are just doing this so the locking calls (irq vs bh) matches up?

Don't you also need to fix the non-mq IO path. scsi_request_fn needs a
fix to use spin_lock_irqsave/spin_unlock_irqrestore because
blk_execute_rq_nowait already disables them right?


