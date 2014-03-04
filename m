From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v1 10/13] IB/iser: Support T10-PI operations
Date: Tue, 04 Mar 2014 16:44:45 +0200
Message-ID: <5315E6DD.4060909@dev.mellanox.co.il>
References: <1393499589-15633-1-git-send-email-sagig@mellanox.com> <1393499589-15633-11-git-send-email-sagig@mellanox.com> <531408C8.10107@cs.wisc.edu> <53159F09.6050802@mellanox.com> <5315A3E4.508@dev.mellanox.co.il> <5315B83D.6060503@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47223 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100AbaCDOot (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2014 09:44:49 -0500
Received: by mail-wg0-f44.google.com with SMTP id a1so5069397wgh.3
        for <linux-scsi@vger.kernel.org>; Tue, 04 Mar 2014 06:44:48 -0800 (PST)
In-Reply-To: <5315B83D.6060503@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>, Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@mellanox.com>
Cc: roland@kernel.org, nab@linux-iscsi.org, oren@mellanox.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org

On 3/4/2014 1:25 PM, Or Gerlitz wrote:
> On 04/03/2014 11:59, Sagi Grimberg wrote:
>> On 3/4/2014 11:38 AM, Or Gerlitz wrote:
>>> On 03/03/2014 06:44, Mike Christie wrote:
>>>> The xmit_task callout does handle failures like EINVAL. If the 
>>>> above map
>>>> calls fail then you would get infinite retries. You would currently 
>>>> want
>>>> to do the mapping in the init_task callout instead.
>>>>
>>>> If it makes it easier on the driver implementation then it is ok to
>>>> modify the xmit_task callers so that they handle multiple error codes
>>>> for drivers like iser that have the xmit_task callout called from
>>>> iscsi_queuecommand.
>>>
>>> Mike,
>>>
>>> After looking on the code with Sagi,  it seems to us that the 
>>> correct way to go here, would be to enhance in iscsi_queuecommand 
>>> the processing of the result returned by 
>>> session->tt->xmit_task(task) to behave in a similar manner to how 
>>> the return value of iscsi_prep_scsi_cmd_pdu() is treated. E.g for 
>>> errors such as ENOMEM and EGAIN take the "reject" flow which would 
>>> cause the SCSI midlayer to retry the command and for other return 
>>> values go to the "fault" flow which will cause the ML to abort the 
>>> command.
>>>
>>> Or.
>>>
>>
>> Yes, we were thinking about the following:
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -1707,10 +1707,17 @@ int iscsi_queuecommand(struct Scsi_Host 
>> *host, struct scsi_cmnd *sc)
>>                                 goto prepd_fault;
>>                         }
>>                 }
>> -               if (session->tt->xmit_task(task)) {
>> -                       session->cmdsn--;
>> -                       reason = FAILURE_SESSION_NOT_READY;
>> -                       goto prepd_reject;
>> +
>> +               reason = session->tt->xmit_task(task);
>> +               if (reason) {
>> +                       if (reason == -ENOMEM || reason == -EAGAIN) {
>> +                               session->cmdsn--;
>
> I am pretty sure this has to be done anyway, no matter why the 
> xmit_task callback failed

Even if we abort? this just follows the same logic as 
iscsi_prep_scsi_cmd_pdu error flow.

>
>> + reason = FAILURE_SESSION_NOT_READY;
>> +                               goto prepd_reject;
>> +                       } else {
>> +                               sc->result = DID_ABORT << 16;
>> +                               goto prepd_fault;
>> +                       }
>>                 }
>>         } else {
>>                 list_add_tail(&task->running, &conn->cmdqueue);
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

