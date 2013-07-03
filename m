From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH 1/4] scsi: ufs: Fix broken task management command implementation
Date: Wed, 03 Jul 2013 22:12:43 +0530
Message-ID: <51D45483.9080001@codeaurora.org>
References: <1371133860-17574-1-git-send-email-sthumma@codeaurora.org> <1371133860-17574-2-git-send-email-sthumma@codeaurora.org> <CALMYJDuRyovi3X_jmb0-PjZgRYgJfSi_ryg0YO48Cr2bRHLd+g@mail.gmail.com> <51CD7461.3000501@codeaurora.org> <CALMYJDv=QR8cMSoCfRgKDnyiJS6=gv7BXEPOq2vG7a1nCfvR0A@mail.gmail.com> <51D448A3.1050509@codeaurora.org> <CALMYJDvNAQApFoPOvf162kDNDC37Ub-=vpy5U8KM1skJFuyqMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:42934 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983Ab3GCQms (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jul 2013 12:42:48 -0400
In-Reply-To: <CALMYJDvNAQApFoPOvf162kDNDC37Ub-=vpy5U8KM1skJFuyqMw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, linux-arm-msm@vger.kernel.org

On 7/3/2013 9:53 PM, Santosh Y wrote:
> On Wed, Jul 3, 2013 at 9:22 PM, Sujit Reddy Thumma
> <sthumma@codeaurora.org> wrote:
>> On 7/2/2013 9:21 PM, Santosh Y wrote:
>>>
>>> On Fri, Jun 28, 2013 at 5:02 PM, Sujit Reddy Thumma
>>> <sthumma@codeaurora.org> wrote:
>>>>
>>>> On 6/27/2013 4:49 PM, Santosh Y wrote:
>>>>>>
>>>>>>
>>>>>>> +       spin_lock_irqsave(host->host_lock, flags);
>>>>>>>           task_req_descp = hba->utmrdl_base_addr;
>>>>>>>           task_req_descp += free_slot;
>>>>>>>
>>>>>>> @@ -2353,38 +2387,39 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>>>>>>>                   (struct utp_upiu_task_req *)
>>>>>>> task_req_descp->task_req_upiu;
>>>>>>>           task_req_upiup->header.dword_0 =
>>>>>>>                   UPIU_HEADER_DWORD(UPIU_TRANSACTION_TASK_REQ, 0,
>>>>>>> -                                             lrbp->lun,
>>>>>>> lrbp->task_tag);
>>>>>>> +                               lun_id, free_slot);
>>>>>
>>>>>
>>>>> Actually it still doesn't fix the problem. The*task tag*  used here
>>>>>
>>>>> should be unique across the SCSI/Query and Task Managment UPIUs.
>>>>
>>>>
>>>>
>>>> I am sorry, I didn't get that. Why should it be unique across the
>>>> SCSI/Query? For example, if a machine supports 32 request slots and 8
>>>> task
>>>> management slots, then the task management command tag can be anything
>>>> out
>>>> of 8 slots.
>>>>
>>>
>>> The spec(ufs 1.1) has the requirement under  '10.5.2 Basic Header
>>> Format'->'Task Tag'.
>>> Couple of devices I came across had similar behavior. The tracking of
>>> UPIUs --even belonging to a separate group-- seemed to be based on the
>>> 'task tag' value rather than 'type of UPIU'->'task tag'.
>>
>>
>> Thanks for the clarification. So to make the task tag unique we should do
>> something like below:
>>
>> @@ -2940,9 +2941,10 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>> int lun_id, int task_id,
>>          /* Configure task request UPIU */
>>          task_req_upiup =
>>
>>                  (struct utp_upiu_task_req *) task_req_descp->task_req_upiu;
>> +       task_tag = hba->nutrs + free_slot;
>
> Yes, this was exactly my internal fix at the time :-)

Okay. I will update the patch with this. Thanks.

>
>>
>>          task_req_upiup->header.dword_0 =
>>                  UPIU_HEADER_DWORD(UPIU_TRANSACTION_TASK_REQ, 0,
>> -                               lun_id, free_slot);
>> +                               lun_id, task_tag);
>>
>> Will this work for the devices you came across?
>>


-- 
Regards,
Sujit
