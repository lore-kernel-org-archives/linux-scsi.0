Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D5F9C25B47
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 17:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjJXRFx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 13:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344023AbjJXQuK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 12:50:10 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB63BDA;
        Tue, 24 Oct 2023 09:50:04 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1caa371dcd8so30780595ad.0;
        Tue, 24 Oct 2023 09:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698166204; x=1698771004; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7OWsY7SJu8Gcvebw6x0jzvB0rtdPPzgdRgH26lmxO24=;
        b=GatAlJKtbEMsG4VGtBOo21eD5FG5iY2cb1u9Pp65kI/GtscB7Bdot8Wo2eCAMk1G85
         sjACzUXY9ITc461zBi5RaM3/Rbl/Dux62tdufn0Hp6N9GBgN/iUNWfSk84ATTorjTv1v
         Qh2MnVLsga91iFDgZU8HUYTO0axK6LUbhB03nK1m73ofqWAZMRWFgTp1KS+BKerycqPU
         ypXVM9T4skmeUo44zB0FUboYbnSY7Wb5UWse3Byc/y8ZZkBVoZxRcKQv44M4AsdoZ/Gf
         tkR5c+G4OM37Aa2pWjUH/t11e/VssYlRq7JR5JlUrJDLcGwIi7Z9unPIRuWPG4PkZU/e
         ZvKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698166204; x=1698771004;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7OWsY7SJu8Gcvebw6x0jzvB0rtdPPzgdRgH26lmxO24=;
        b=xVK1Uj8xo9zkK0c6g7IkYe5gxhJTtvGpqsR1+D8UyUKyfWQCIqBfEuELDgqaDjt1yV
         SDOf7etCL5EUiik45/9owqXkuGA3CA7DRjEchi1/qLNhj7XCItH37BmmI5kz2nuSleck
         ZcSES28zWpO6T3HWmDARNt3r1wxzc1UM0ormYXj582ng+zQmVo2hqfvaTpzq2toczyXn
         EYEWjPJuLRWg4ce+JNIrLFXchZWmWGFmjVZ7gl48+HH0V4Tyio1baQwqQjcdTtmdzWwK
         E1vJZ7Ou4gDQXo3pMdNzei9aDiyzGpoLJ+gOPjRmD1AKZGb6gxosP7hgqL115KLBZJoH
         sCCw==
X-Gm-Message-State: AOJu0Yy/L1wR1c95LQlmghlXAiIeUj9/P2BzQWAWYNokOAn/0amgmpQt
        qefM5ipBeNBP4gEH3xvW+5w=
X-Google-Smtp-Source: AGHT+IEXDosIVFqRUC5d6Eu+w9C11XUamGFEmaHuZlAJYQoFh9KHdrCMuKcoVbR/s64kV7W2ri7xkg==
X-Received: by 2002:a17:902:cec6:b0:1c5:cbfb:c16f with SMTP id d6-20020a170902cec600b001c5cbfbc16fmr11682593plg.25.1698166204037;
        Tue, 24 Oct 2023 09:50:04 -0700 (PDT)
Received: from [0.0.0.0] (74.211.104.32.16clouds.com. [74.211.104.32])
        by smtp.gmail.com with ESMTPSA id u15-20020a170902e80f00b001c9bc811d4dsm7659875plg.295.2023.10.24.09.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 09:50:03 -0700 (PDT)
Message-ID: <f882e8ba-c563-4c9a-99ab-50b20fe7b1b0@gmail.com>
Date:   Wed, 25 Oct 2023 00:49:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: scsi_debug: delete some bogus error checking
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Wenchao Hao <haowenchao2@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <f96d6366-9271-4020-ab66-f75737a1e8bd@moroto.mountain>
 <d2cb55a9-6bc0-47a0-a812-418d187c2c00@gmail.com>
 <d8ec82e6-5ba5-4945-825c-0e622c62f5b6@kadam.mountain>
Content-Language: en-US
From:   Wenchao Hao <haowenchao22@gmail.com>
In-Reply-To: <d8ec82e6-5ba5-4945-825c-0e622c62f5b6@kadam.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/23 1:06 PM, Dan Carpenter wrote:
> On Sat, Oct 21, 2023 at 01:28:50AM +0800, Wenchao Hao wrote:
>> On 2023/10/20 22:15, Dan Carpenter wrote:
>>> Smatch complains that "dentry" is never initialized.  These days everyone
>>> initializes all their stack variables to zero so this means that it will
>>> trigger a warning every time this function is run.
>>>
>>> Really debugfs functions are not supposed to be checked for errors so
>>> this checking can just be deleted.
>>>
>>> Fixes: f084fe52c640 ("scsi: scsi_debug: Add debugfs interface to fail target reset")
>>> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
>>> ---
>>> See my blog for more information on the history of debugfs error
>>> checking:
>>>
>>> https://staticthinking.wordpress.com/2023/07/24/debugfs-functions-are-not-supposed-to-be-checked/
>>> ---
>>>  drivers/scsi/scsi_debug.c | 7 -------
>>>  1 file changed, 7 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>>> index 0a4e41d84df8..c0be9a53ac79 100644
>>> --- a/drivers/scsi/scsi_debug.c
>>> +++ b/drivers/scsi/scsi_debug.c
>>> @@ -1127,7 +1127,6 @@ static const struct file_operations sdebug_target_reset_fail_fops = {
>>>  static int sdebug_target_alloc(struct scsi_target *starget)
>>>  {
>>>  	struct sdebug_target_info *targetip;
>>> -	struct dentry *dentry;
>>>  
>>>  	targetip = kzalloc(sizeof(struct sdebug_target_info), GFP_KERNEL);
>>>  	if (!targetip)
>>> @@ -1135,15 +1134,9 @@ static int sdebug_target_alloc(struct scsi_target *starget)
>>>  
>>>  	targetip->debugfs_entry = debugfs_create_dir(dev_name(&starget->dev),
>>>  				sdebug_debugfs_root);
>>> -	if (IS_ERR_OR_NULL(targetip->debugfs_entry))
>>> -		pr_info("%s: failed to create debugfs directory for target %s\n",
>>> -			__func__, dev_name(&starget->dev));
>>>  
>>>  	debugfs_create_file("fail_reset", 0600, targetip->debugfs_entry, starget,
>>>  				&sdebug_target_reset_fail_fops);
>>> -	if (IS_ERR_OR_NULL(dentry))
>>> -		pr_info("%s: failed to create fail_reset file for target %s\n",
>>> -			__func__, dev_name(&starget->dev));
>>>  
>>>  	starget->hostdata = targetip;
>>>  
>>
>>
>> Thank you for the fix, the check for debugfs_create_file() is added because 
>> scsi_debug driver is often used to test abnormal situations, here just check
>> and prompt a log, so maybe you should not remove it and fix the issue
>> following changes:
>>
> 
> No, the correct thing is to remove it.  This is explained in my blog
> article linked to earlier.
> 
> https://staticthinking.wordpress.com/2023/07/24/debugfs-functions-are-not-supposed-to-be-checked/
> 

There are other places in scsi_debug which check return value
of debugfs functions added by my previous patches, would you
remove them?

Thanks


> commit ff9fb72bc07705c00795ca48631f7fffe24d2c6b
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Wed Jan 23 11:28:14 2019 +0100
> 
>     debugfs: return error values, not NULL
>     
>     When an error happens, debugfs should return an error pointer value, not
>     NULL.  This will prevent the totally theoretical error where a debugfs
>     call fails due to lack of memory, returning NULL, and that dentry value
>     is then passed to another debugfs call, which would end up succeeding,
>     creating a file at the root of the debugfs tree, but would then be
>     impossible to remove (because you can not remove the directory NULL).
>     
>     So, to make everyone happy, always return errors, this makes the users
>     of debugfs much simpler (they do not have to ever check the return
>     value), and everyone can rest easy.
> 
> In your code, if there is an error the debugfs code will print an error and
> your code will print an info.  The info adds nothing.  Also if debugfs fails
> to load you are already screwed so the info adds nothing.
> 
> In your code if the user disables CONFIG_DEBUGFS then printing "failed to create
> fail_reset file for target" is wrong.  The user did that deliberately.  No need
> to complain about the user's deliberate choices.  If it's really necessary to
> have CONFIG_DEBUGFS then enforce that with Kconfig.
> 
> regards,
> dan carpenter

