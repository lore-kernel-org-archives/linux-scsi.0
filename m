Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE32C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 02:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhLWCmo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 21:42:44 -0500
Received: from out0.migadu.com ([94.23.1.103]:38677 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231315AbhLWCmn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Dec 2021 21:42:43 -0500
Subject: Re: [PATCH v2] scsi: bsg: fix errno when scsi_bsg_register_queue
 fails
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1640227358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Nh6vPMXJR3H17KLwubz1kVXK+ogjnDcuz3z202sfRM=;
        b=U0vp7pFRKA00OZWvvIMmSMPw9JbdQROvYXe0oWQLU7Gwk/14KnfhSk+VUvquU7YJjcMaDN
        QyJ48yWE+3UuOysNUeIfEG6AxzA+77WO73dIdV64BI6FtgDaSZyRZ+V30rHGeA6vqoSJf+
        xoiYEG5ZG1/s9RdVM3VeVcmzHD1mMcI=
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org, hch@lst.de,
        axboe@kernel.dk
References: <20211022010201.426746-1-liu.yun@linux.dev>
 <20211222165435.GA283263@roeck-us.net>
 <6671fc20-e543-71c5-c505-395e6ee7e744@linux.dev>
 <d9f64463-fdf3-0b67-cc34-7838864e1c77@roeck-us.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Jackie Liu <liu.yun@linux.dev>
Message-ID: <6e8e5593-eeed-dcb6-2b4d-008b82c8d14c@linux.dev>
Date:   Thu, 23 Dec 2021 10:42:30 +0800
MIME-Version: 1.0
In-Reply-To: <d9f64463-fdf3-0b67-cc34-7838864e1c77@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2021/12/23 上午9:35, Guenter Roeck 写道:
> On 12/22/21 5:07 PM, Jackie Liu wrote:
>> Hi Guenter.
>>
>> Before commit ead09dd3aed5c ("scsi: bsg: Simplify device 
>> registration", the errno need return to the caller, I restore the old 
>> logic, and print
>> this errno.
>>
> 
> The comment associated with the code says "We're treating error on bsg
> register as non-fatal, so pretend nothing went wrong." Your commit does
> not explain why that is wrong, and why the error should be returned
> to the caller. In the current code, the comment is still there,
> but the error is not ignored, and it is printed as informational message,
> not as error message. At the very least that is misleading, and the code
> no longer matches the comment. Also, the description in your commit does
> not match the change made: It sounds like a change with no functional
> impact ("Here, we should be print the correct error code when
> scsi_bsg_register_queue fails") when in reality it does introduce
> a functional change (the error is not only printed but also returned
> to the caller).
> 
> Guenter

I see, Thanks for point out, after commit ee37e09d81a4 ("[SCSI] fix
duplicate removal on error path in scsi_sysfs_add_sdev"), Before this
errno will be forced to return 0.

After:

[1] error = device_create_file(&sdev->sdev_gendev,  	
                            sdev->host->hostt->sdev_attrs[i]);

Then:

with 92c4b58b15c5 ("scsi: core: Register sysfs attributes earlier")
delete code [1], so we force return errno.

I don’t know if I should restore the original logic or delete
this comment information. Guenter and Christoph, What do you think? I
can send another patch based on this.

--
Jackie Liu

> 
>> -- 
>> Jackie Liu
>>
>> 在 2021/12/23 上午12:54, Guenter Roeck 写道:
>>> On Fri, Oct 22, 2021 at 09:02:01AM +0800, Jackie Liu wrote:
>>>> From: Jackie Liu <liuyun01@kylinos.cn>
>>>>
>>>> When the value of error is printed, it will always be 0. Here, we 
>>>> should be
>>>> print the correct error code when scsi_bsg_register_queue fails.
>>>>
>>>
>>> The comment above the changed code says:
>>>
>>> "
>>> We're treating error on bsg register as non-fatal, so pretend nothing 
>>> went wrong.
>>> "
>>>
>>> With this patch in place, "error" is returned to the caller, and the 
>>> code
>>> no longer pretends that nothing is wrong. Also, the message is a 
>>> dev_info
>>> message, not dev_err, suggesting that ignoring the error was indeed on
>>> purpose. Assuming the comment is correct, this patch is plain wrong;
>>> the message should have printed PTR_ERR(sdev->bsg_dev) instead and 
>>> not set
>>> the 'error' variable.
>>>
>>> Guenter
>>>
>>>> Fixes: ead09dd3aed5 ("scsi: bsg: Simplify device registration")
>>>> Cc: Jens Axboe <axboe@kernel.dk>
>>>> Cc: Christoph Hellwig <hch@lst.de>
>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
>>>> ---
>>>>   v1->v2:
>>>>   resend to linux-scsi mail list.
>>>>
>>>>   drivers/scsi/scsi_sysfs.c | 1 +
>>>>   1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>>>> index 86793259e541..d8789f6cda62 100644
>>>> --- a/drivers/scsi/scsi_sysfs.c
>>>> +++ b/drivers/scsi/scsi_sysfs.c
>>>> @@ -1379,6 +1379,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>>>>                * We're treating error on bsg register as non-fatal, so
>>>>                * pretend nothing went wrong.
>>>>                */
>>>> +            error = PTR_ERR(sdev->bsg_dev);
>>>>               sdev_printk(KERN_INFO, sdev,
>>>>                       "Failed to register bsg queue, errno=%d\n",
>>>>                       error);
>>>> -- 
>>>> 2.25.1
>>>>
> 
