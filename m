From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v3 1/5] target: ensure se_cmd->t_prot_sg is allocated
 when required
Date: Mon, 27 Apr 2015 18:08:16 +0300
Message-ID: <553E50E0.6080900@dev.mellanox.co.il>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>	<1429972410-7146-2-git-send-email-akinobu.mita@gmail.com>	<553CAF32.2030904@dev.mellanox.co.il>	<553CB381.6090409@dev.mellanox.co.il> <CAC5umyjPxmFVcW43iY0RCrQfGbuEx4k-owHUR3oM0Bg-DvzWoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33716 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670AbbD0PIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2015 11:08:41 -0400
Received: by wiax7 with SMTP id x7so86518808wia.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2015 08:08:40 -0700 (PDT)
In-Reply-To: <CAC5umyjPxmFVcW43iY0RCrQfGbuEx4k-owHUR3oM0Bg-DvzWoA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: target-devel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 4/27/2015 3:57 PM, Akinobu Mita wrote:
> 2015-04-26 18:44 GMT+09:00 Sagi Grimberg <sagig@dev.mellanox.co.il>:
>>>> @@ -2181,6 +2182,12 @@ static inline void
>>>> transport_reset_sgl_orig(struct se_cmd *cmd)
>>>>
>>>>    static inline void transport_free_pages(struct se_cmd *cmd)
>>>>    {
>>>> +    if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC)) {
>>>> +        transport_free_sgl(cmd->t_prot_sg, cmd->t_prot_nents);
>>>> +        cmd->t_prot_sg = NULL;
>>>> +        cmd->t_prot_nents = 0;
>>>> +    }
>>>> +
>>>
>>>
>>> Hi Akinobu,
>>>
>>> Any reason why this changed it's location to the start of the function?
>
> Because when SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is set, it will not
> reach the tail of the function.  So when SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC
> is cleared and SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC is set,
> se_cmd->t_prot_sg leaks.

I see. That's fine...

>
>>>>        if (cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC) {
>>>>            /*
>>>>             * Release special case READ buffer payload required for
>>>> @@ -2204,10 +2211,6 @@ static inline void transport_free_pages(struct
>>>> se_cmd *cmd)
>>>>        transport_free_sgl(cmd->t_bidi_data_sg, cmd->t_bidi_data_nents);
>>>>        cmd->t_bidi_data_sg = NULL;
>>>>        cmd->t_bidi_data_nents = 0;
>>>> -
>>>> -    transport_free_sgl(cmd->t_prot_sg, cmd->t_prot_nents);
>>>> -    cmd->t_prot_sg = NULL;
>>>> -    cmd->t_prot_nents = 0;
>>>>    }
>>>>
>>>>    /**
>>>> @@ -2346,6 +2349,17 @@ transport_generic_new_cmd(struct se_cmd *cmd)
>>>>        int ret = 0;
>>>>        bool zero_flag = !(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB);
>>>>
>>>> +    if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC)) {
>>>> +        if (cmd->prot_op != TARGET_PROT_NORMAL) {
>>>
>>>
>>> This seems wrong,
>>>
>>> What will happen for transports that will actually to allocate
>>> protection SGLs? The allocation is unreachable since
>>> SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC is not set...
>>
>>
>> Umm, actually this is reachable... But I still think the condition
>> should be the other way around (saving a condition in some common
>> cases).
>
> Do you mean you prefer below?
>
> if (cmd->prot_op != TARGET_PROT_NORMAL &&
>      !(cmd->se_cmd_flags & SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC)) {
> ...
>

I think it will be better.

