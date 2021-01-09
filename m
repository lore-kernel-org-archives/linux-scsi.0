Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01812C433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 20:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF4C523B00
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 20:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbhAIUld (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jan 2021 15:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbhAIUld (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2021 15:41:33 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A37C061786;
        Sat,  9 Jan 2021 12:40:52 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id v14so10506661wml.1;
        Sat, 09 Jan 2021 12:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ib82eIyanEEkt8I4OWdosJ1EHFYlnvzj4hshfHKZ+yA=;
        b=pAr7qg5K7ex6JHMgvJwLgGIE7KvhsaELwWZy/UMO9LlwANmuqGSr/CxpHsbkdAxPw7
         qfV137NMqGysLhk2RKnC5+am7MY6IJfksScCRYOZ8MiHWpc8rS5RBGN0gjua0qoX4+9a
         XmhOm+V0ABrt+S4E6tNmvoflk95Mi8Z57tk3k+n3wUzrWibzpn5di6zcckYoNCLm07CA
         jP4OrRZ9byN7KotFnRv0bPNTKxYxPnI+NZVUptUiyIR+XzeseWoiDM4m3wu9C0xMynIo
         39gO7Nykx/Ya+fKUAZYx16zAMUHkue9pEMfkpUtWEpdLCAsNurzg7+GSll8SCmCzzkDA
         uOUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Ib82eIyanEEkt8I4OWdosJ1EHFYlnvzj4hshfHKZ+yA=;
        b=cnhzqMNs4DII7QvAjfSGnO4OrRy7qIDLNmwv6IK6rvimA5ibsIcIRRKtMROmvmNJmM
         rpB2aqj8OJlkkiLeNM/6uP0Tfhbp0NUFZARo9hYJhXyD4Qr9maYZvYvJiEp6QmqY0sMM
         nEzkw2NQyPw2LH+VvOfolVWr2f31ncQyKiIpQ0w1iEsceTX52CdTUYtMq26TjT+k6bQ0
         eUA4PMMNX6BUxmxR8yt5w9yiddlUqxdUlDdt4W3vQpg72EVpz8GRiaMbcszIw5pEL3HK
         cj3k1bPHhVf4iln8Rh+Mor4iYI/Q3XGC/+t6m+4y3Iy84bAol5AkyX5M9VZaduXrM9HY
         +fVA==
X-Gm-Message-State: AOAM532YTzHUjCp2nPK7KKEOhj81+t+mzraRWpEbasnndCDXtkzInDqF
        U0XUbFVCVIlxNB7sCyZycX/e3TLk9DjBJCSq
X-Google-Smtp-Source: ABdhPJyU5uEHFcmyFjb3oynOlR4xgz6vxFwYo6o0ODoz0OEt4Zl9I2u6RrOWggwV+nsTKIgSXyLvSQ==
X-Received: by 2002:a7b:c3c8:: with SMTP id t8mr8268783wmj.88.1610224851184;
        Sat, 09 Jan 2021 12:40:51 -0800 (PST)
Received: from [192.168.8.114] ([85.255.237.6])
        by smtp.gmail.com with ESMTPSA id w189sm16858374wmg.31.2021.01.09.12.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 12:40:50 -0800 (PST)
Subject: Re: [PATCH] target/file: don't zero iter before iov_iter_bvec
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <34cd22d6cec046e3adf402accb1453cc255b9042.1610207523.git.asml.silence@gmail.com>
 <BYAPR04MB4965F4DCF59E5225CF17322D86AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <4d063dde-c710-44e3-31b9-8fb6b7e1d952@gmail.com>
Date:   Sat, 9 Jan 2021 20:37:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB4965F4DCF59E5225CF17322D86AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/01/2021 20:09, Chaitanya Kulkarni wrote:
> On 1/9/21 07:59, Pavel Begunkov wrote:
>> iov_iter_bvec() initialises iterators well, no need to pre-zero it
>> beforehand as done in fd_execute_rw_aio(). Compilers can't optimise it
>> out and generate extra code for that (confirmed with assembly).
> It will be great if we can quantify this optimization with the actual
> performance
> numbers.

I expect you won't find any, but such little things can pile up
into a not-easy-to-spot overhead over time.

In any case, I don't think this requires performance justification
because it neither makes it less safe or uglier. Those iov_iter*()
are there to handle initialisation, that's a part of the iter API.

>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  drivers/target/target_core_file.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
>> index cce455929778..5a66854def95 100644
>> --- a/drivers/target/target_core_file.c
>> +++ b/drivers/target/target_core_file.c
>> @@ -267,7 +267,7 @@ fd_execute_rw_aio(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>>  	struct fd_dev *fd_dev = FD_DEV(dev);
>>  	struct file *file = fd_dev->fd_file;
>>  	struct target_core_file_cmd *aio_cmd;
>> -	struct iov_iter iter = {};
>> +	struct iov_iter iter;
>>  	struct scatterlist *sg;
>>  	ssize_t len = 0;
>>  	int ret = 0, i;
> 

-- 
Pavel Begunkov
