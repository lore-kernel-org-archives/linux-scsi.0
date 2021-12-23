Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D889C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 01:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241867AbhLWBfi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 20:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238646AbhLWBfi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2021 20:35:38 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D007C061574
        for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2021 17:35:38 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso4996652ots.6
        for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2021 17:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NyOrVVWgXwCRjHjjilgDY+TGo/2NNLxhMsZor9OidFs=;
        b=p1sVVvw1U4VQN6Z7KSsvVCeq7qu9ThF5bfQGMSNEfyButdImRVjv4uu4rX0eaR4uLb
         7ts2gwomhyU2qBIMVUd+BDmZO385u/elkZOz2BzxVcWFNbr3WE3c0/53R6nsfkeLf8Az
         x9gmpM7T2WO1F8Tnc9qZerRXFHIpGm5gwiNsKKfw4XUKw3iOhrzP+xvsbyrLjh7Kbkzg
         gcGjb/WM6iQfp9eH8IekXOVseX2iL0Jcb2x08hlpqAlyFGehQXFvpTBtjpAvqGlCikqk
         tnzsss8aJL2DGhhGaKXr0VcpyE5wU3UXCvkOv7aXW5Z4kHE3lvF2Cedgu2WjDtRgt+3N
         KnFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NyOrVVWgXwCRjHjjilgDY+TGo/2NNLxhMsZor9OidFs=;
        b=eaUOWZHOhFZymHdcdM3RgL7GrA8K5lz38sldoePjtI/ZvT0b1od6gUjffdNSFF/p3y
         f94lspjlnGhDFBfBpJVPphp9fMy11PhJqrt/9CxKfRj04b90OFbLH8sKkMpbbHd1SFPW
         Z38ZuPySxu/xqmb04D84fn+lEmCBuPdiNyvkbwglXTuWPHQ5vMW/h83NBPiY55GloHU9
         TQRVhsu7cW4Hf50PzkGHFPoF7LRAj4P499F2CU1wsys9frBAs7948RDqEx4p700WtNyP
         IMyfgrHww+kb/ex/1hmb6QiJHI3EQWqDf4d7PMcV3zSZNenrxvFP64vbHKXDfDX/4+bL
         VLSQ==
X-Gm-Message-State: AOAM533+yilmnwaQNaRAbV3k1hJnz3KrJbC7F+TK879j3jbIedKMbQdv
        ozbys89Wvkdv1nXg2YP4cJhb8uSZHHY=
X-Google-Smtp-Source: ABdhPJwhkdza6G0UzC9H4PhqbhBfITK2WmtcWpwJc9VhjUeZPTG9mr66+TLY2hJZTYjNS7x19faj7Q==
X-Received: by 2002:a9d:2206:: with SMTP id o6mr115393ota.148.1640223336891;
        Wed, 22 Dec 2021 17:35:36 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 90sm302799otn.59.2021.12.22.17.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Dec 2021 17:35:35 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Jackie Liu <liu.yun@linux.dev>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org, hch@lst.de,
        axboe@kernel.dk
References: <20211022010201.426746-1-liu.yun@linux.dev>
 <20211222165435.GA283263@roeck-us.net>
 <6671fc20-e543-71c5-c505-395e6ee7e744@linux.dev>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2] scsi: bsg: fix errno when scsi_bsg_register_queue
 fails
Message-ID: <d9f64463-fdf3-0b67-cc34-7838864e1c77@roeck-us.net>
Date:   Wed, 22 Dec 2021 17:35:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6671fc20-e543-71c5-c505-395e6ee7e744@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/21 5:07 PM, Jackie Liu wrote:
> Hi Guenter.
> 
> Before commit ead09dd3aed5c ("scsi: bsg: Simplify device registration", the errno need return to the caller, I restore the old logic, and print
> this errno.
> 

The comment associated with the code says "We're treating error on bsg
register as non-fatal, so pretend nothing went wrong." Your commit does
not explain why that is wrong, and why the error should be returned
to the caller. In the current code, the comment is still there,
but the error is not ignored, and it is printed as informational message,
not as error message. At the very least that is misleading, and the code
no longer matches the comment. Also, the description in your commit does
not match the change made: It sounds like a change with no functional
impact ("Here, we should be print the correct error code when
scsi_bsg_register_queue fails") when in reality it does introduce
a functional change (the error is not only printed but also returned
to the caller).

Guenter

> -- 
> Jackie Liu
> 
> 在 2021/12/23 上午12:54, Guenter Roeck 写道:
>> On Fri, Oct 22, 2021 at 09:02:01AM +0800, Jackie Liu wrote:
>>> From: Jackie Liu <liuyun01@kylinos.cn>
>>>
>>> When the value of error is printed, it will always be 0. Here, we should be
>>> print the correct error code when scsi_bsg_register_queue fails.
>>>
>>
>> The comment above the changed code says:
>>
>> "
>> We're treating error on bsg register as non-fatal, so pretend nothing went wrong.
>> "
>>
>> With this patch in place, "error" is returned to the caller, and the code
>> no longer pretends that nothing is wrong. Also, the message is a dev_info
>> message, not dev_err, suggesting that ignoring the error was indeed on
>> purpose. Assuming the comment is correct, this patch is plain wrong;
>> the message should have printed PTR_ERR(sdev->bsg_dev) instead and not set
>> the 'error' variable.
>>
>> Guenter
>>
>>> Fixes: ead09dd3aed5 ("scsi: bsg: Simplify device registration")
>>> Cc: Jens Axboe <axboe@kernel.dk>
>>> Cc: Christoph Hellwig <hch@lst.de>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
>>> ---
>>>   v1->v2:
>>>   resend to linux-scsi mail list.
>>>
>>>   drivers/scsi/scsi_sysfs.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>>> index 86793259e541..d8789f6cda62 100644
>>> --- a/drivers/scsi/scsi_sysfs.c
>>> +++ b/drivers/scsi/scsi_sysfs.c
>>> @@ -1379,6 +1379,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>>>                * We're treating error on bsg register as non-fatal, so
>>>                * pretend nothing went wrong.
>>>                */
>>> +            error = PTR_ERR(sdev->bsg_dev);
>>>               sdev_printk(KERN_INFO, sdev,
>>>                       "Failed to register bsg queue, errno=%d\n",
>>>                       error);
>>> -- 
>>> 2.25.1
>>>

