Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9928FC7EE23
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 14:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbjEWOtF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 10:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbjEWOtE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 10:49:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25F7E9
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 07:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684853297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tCqOpxr0nnnLiP9DyyZOzmcZxzwnoAGy3acWgoQxcdk=;
        b=C+FDL7XnSYqgl8GP5nK1fKy1h2QyD3tOmoItL6VUjTQEyE4ZlI2lLbRvaSJ92iVFsV1Shh
        dT67dH+cRl8Sm0s/scAXmaPikhTlCrS13vmPVB8vQL17wGXYHkFV8/Pzn1T/FtaaGsKXwL
        9RGOKDsh4R7Cuy7nqXqKJqYnaZgLVB8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-JvJp-0W8Mz-c1iFoNcWcdg-1; Tue, 23 May 2023 10:48:15 -0400
X-MC-Unique: JvJp-0W8Mz-c1iFoNcWcdg-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-512937f82b2so1259065a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 07:48:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684853294; x=1687445294;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tCqOpxr0nnnLiP9DyyZOzmcZxzwnoAGy3acWgoQxcdk=;
        b=EXIehq1+ZYGW/ai+F8psbfC89WvJxhsvgE4cWQW1wYEnTcFZ3FUakC3VEDcTs6RSgh
         mORmPvV/h7mIiJCV70g9ITZ+d1nNQTCGrifJ+3EeVJbZc2astjDjtiEye/GoQRlJahwx
         FC7PKD+wBfCNblhiWETPEKy3hShrEd4Z4n2WVhLSSnn0Yn5oWQNL8Ru57GFxA8tB/aP4
         FhLcwzAXP7rVmnFUtrn1Bl4jL+GoC8/SrfY1qQMxQEQCXjMYbq/RcpVss2XiCJcTIog4
         1R0hFDsmRlIDHAPagcZ/f/WZPLpOBwI5COys8b68cYCnaOn5wYmjNdIcJE/LBsh5lBkj
         CfRA==
X-Gm-Message-State: AC+VfDyaHUNuILYVxHxrGD35HjvDAuk+JZOSi0qrIicqI4Vty9sqV8Fg
        D0lTpeABEochDeIo71JGcifS6H21N4qm961cC2stZQCPTxTdocX2SQ2UeUku1+KYd/BDxB3vuh2
        hPnNB4sDaFCTPzg10kTHRag==
X-Received: by 2002:a17:907:a07:b0:966:3c82:4a95 with SMTP id bb7-20020a1709070a0700b009663c824a95mr14081258ejc.19.1684853294589;
        Tue, 23 May 2023 07:48:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ45XSE0ctzRa/PX4zWYTTxxjrjsmyp2hPlXUOWlmyB4bbx3XKWREeQagggqcbcqCuBWwwU+Xg==
X-Received: by 2002:a17:907:a07:b0:966:3c82:4a95 with SMTP id bb7-20020a1709070a0700b009663c824a95mr14081238ejc.19.1684853294286;
        Tue, 23 May 2023 07:48:14 -0700 (PDT)
Received: from [192.168.0.107] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id b19-20020a170906729300b00965ec1faf27sm4538776ejl.74.2023.05.23.07.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 07:48:13 -0700 (PDT)
Message-ID: <892bc614-9e2e-904b-29e0-62daeb855f79@redhat.com>
Date:   Tue, 23 May 2023 16:48:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] drivers: mpt3sas: mpt3sas_debugfs: return value check of
 `mpt3sas_debugfs_root`
To:     Dan Carpenter <dan.carpenter@linaro.org>,
        Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Jing Xu <U202112064@hust.edu.cn>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        hust-os-kernel-patches@googlegroups.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230423122535.31019-1-U202112064@hust.edu.cn>
 <6e69b57c-80ae-8b6e-cb5f-9e05da46ecd6@redhat.com>
 <1484408f-f68e-4354-ab59-56af9cd1ef14@kili.mountain>
 <b7154e2c-0438-87d1-9edc-7eb1aad40cd1@hust.edu.cn>
 <81d236bb-3913-4eef-bf71-6d17535d6d79@kili.mountain>
Content-Language: en-US
From:   Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <81d236bb-3913-4eef-bf71-6d17535d6d79@kili.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/8/23 16:38, Dan Carpenter wrote:
> On Mon, May 08, 2023 at 09:40:41PM +0800, Dongliang Mu wrote:
>>>>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
>>>>> index a6ab1db81167..c92e08c130b9 100644
>>>>> --- a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
>>>>> +++ b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
>>>>> @@ -99,8 +99,6 @@ static const struct file_operations mpt3sas_debugfs_iocdump_fops = {
>>>>>   void mpt3sas_init_debugfs(void)
>>>>>   {
>>>>>   	mpt3sas_debugfs_root = debugfs_create_dir("mpt3sas", NULL);
>>>>> -	if (!mpt3sas_debugfs_root)
>>>>> -		pr_info("mpt3sas: Cannot create debugfs root\n");
>>>> Hi Jing,
>>>> most drivers just ignore the return value but here the author wanted to
>>>> have the information logged.
>>>> Can you instead of removing the message modify the 'if' condition so it
>>>> suits the author's intention?
>>>
>>> This code was always just wrong.
>>>
>>> The history of this is slightly complicated and boring.  These days it's
>>> harmless dead code so I guess it's less bad than before.
>>
>> Hi Dan and Tomas,
>>
>> Any conclusion about this patch? The student Jing Xu is not sure about how
>> to revise this patch.
> 
> The correct fix is to delete the code.
> 
> Debugfs code has error checking built in and was never supposed to be
> checked for errors in normal driver code.
> 
> Originally, debugfs returned a mix of error pointers and NULL.  In the
> kernel, when you have a mix of error pointers and NULL, then the NULL
> means that the feature has been disabled deliberately.  It's not an
> error, we should not print a message.
> 
> So a different, correct-ish way to write write debugfs error handling
> was to say:
> 
> 	mpt3sas_debugfs_root = debugfs_create_dir("mpt3sas", NULL);
> 	if (IS_ERR(mpt3sas_debugfs_root))
> 		return PTR_ERR(mpt3sas_debugfs_root);
I'm fine with this as well, I could wish we get a fix for the exact same
case of debugfs_create_dir in mpt3sas_setup_debugfs and ideally all the
debugfs_create* in  mpt3sas_debugfs.c in a single patch. But this patch
is ok even if that wasn't possible.
tomash

> 
> However, in those days, a lot of people didn't understand error pointers
> and thought that "if (IS_ERR_OR_NULL(mpt3sas_debugfs_root)) {" was a
> super secure way to check for errors.  Or they just got it wrong and
> checked for NULL instead of error pointers.  Any of the checks are
> wrong, but if (IS_ERR()) check was at least correct-ish.
> 
> I dealt with this a lot because of my work with Smatch.  I used to be
> happy if I could persuade someone to write at least correct-ish code,
> but it was pretty painful to try explain this over and over and very few
> people deleted the checks.
> 
> Eventually Greg changed the code to never return NULL and mass deleted
> the IS_ERR() checks.  Not returning NULL makes it simpler to understand.
> And it makes it impossible to check in the correct-ish way so it kind of
> forces people to just delete the error handling.
> 
> regards,
> dan carpenter
> 

