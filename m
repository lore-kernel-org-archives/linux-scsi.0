Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36EE0C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 01:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240775AbhLWBHU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 20:07:20 -0500
Received: from out2.migadu.com ([188.165.223.204]:53715 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240856AbhLWBHU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Dec 2021 20:07:20 -0500
Subject: Re: [PATCH v2] scsi: bsg: fix errno when scsi_bsg_register_queue
 fails
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1640221638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ro+egyUywDPyDinNUnKBlQYdGYEeD614Qtv/1Grm/io=;
        b=M+XyjsXqwnhOoaD1pHFte6DsCrCW9s5hHcDyyoPbdbtbyVRQnQGtMN7hqIGapnw4FMp/Tv
        uuXpeqZwkmachWMMoc6k/a4zlv8oraw0erKm2I7OaqwGG3/gcDqwyFHmVz4L56cbQDRRip
        jW4ck8uFQKi4GWbAcJ9vewEqatrf8yw=
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org, hch@lst.de,
        axboe@kernel.dk
References: <20211022010201.426746-1-liu.yun@linux.dev>
 <20211222165435.GA283263@roeck-us.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Jackie Liu <liu.yun@linux.dev>
Message-ID: <6671fc20-e543-71c5-c505-395e6ee7e744@linux.dev>
Date:   Thu, 23 Dec 2021 09:07:08 +0800
MIME-Version: 1.0
In-Reply-To: <20211222165435.GA283263@roeck-us.net>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Guenter.

Before commit ead09dd3aed5c ("scsi: bsg: Simplify device registration", 
the errno need return to the caller, I restore the old logic, and print
this errno.

--
Jackie Liu

ÔÚ 2021/12/23 ÉÏÎç12:54, Guenter Roeck Ð´µÀ:
> On Fri, Oct 22, 2021 at 09:02:01AM +0800, Jackie Liu wrote:
>> From: Jackie Liu <liuyun01@kylinos.cn>
>>
>> When the value of error is printed, it will always be 0. Here, we should be
>> print the correct error code when scsi_bsg_register_queue fails.
>>
> 
> The comment above the changed code says:
> 
> "
> We're treating error on bsg register as non-fatal, so pretend nothing went wrong.
> "
> 
> With this patch in place, "error" is returned to the caller, and the code
> no longer pretends that nothing is wrong. Also, the message is a dev_info
> message, not dev_err, suggesting that ignoring the error was indeed on
> purpose. Assuming the comment is correct, this patch is plain wrong;
> the message should have printed PTR_ERR(sdev->bsg_dev) instead and not set
> the 'error' variable.
> 
> Guenter
> 
>> Fixes: ead09dd3aed5 ("scsi: bsg: Simplify device registration")
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
>> ---
>>   v1->v2:
>>   resend to linux-scsi mail list.
>>
>>   drivers/scsi/scsi_sysfs.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 86793259e541..d8789f6cda62 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -1379,6 +1379,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>>   			 * We're treating error on bsg register as non-fatal, so
>>   			 * pretend nothing went wrong.
>>   			 */
>> +			error = PTR_ERR(sdev->bsg_dev);
>>   			sdev_printk(KERN_INFO, sdev,
>>   				    "Failed to register bsg queue, errno=%d\n",
>>   				    error);
>> -- 
>> 2.25.1
>>
