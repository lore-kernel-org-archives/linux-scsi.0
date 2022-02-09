Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 203D1C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 00:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbiBIAEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 19:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239077AbiBIAEb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 19:04:31 -0500
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CFDC06157B
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 16:04:30 -0800 (PST)
Received: by mail-pf1-f172.google.com with SMTP id i17so1190617pfq.13
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 16:04:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BUw7/kbOuJqpYbiF/D5Gp721o2Zg10P0Gyb2uPnZdIk=;
        b=Ib3q318RxDRBus2nc+COVzrRRFwtpWJLulVhoL+HNbd4FJu5rQcqCRG1RVgGNxdXQf
         VZGsIt0wW8lLu7j4e6TYvDFLpV42LzP3DClQ/vofVXnSEGZHaUxdVI78AJIlbN0dWvxM
         PTJb5i6bw1xAjp668S6eLh2iFnK5b2C+iWemiPgiePn3wV16vUqJuFpNoGH+ciNE4WzG
         x9Rfs01xRZcBJ9O8nuB7RaXq83A/BCb8HbIuJ7RAHmITTbPKqFoTjKu0DpwkqLb/paHx
         RmpXN28kSBoajeqt83Qx7XDuPE8ZjIq5BhZrul0DyVo/Or8PsCv6l1zbvz0Y24yWVsyg
         1y7Q==
X-Gm-Message-State: AOAM53271IHF9672J9okf6r+4m5P5Ng6ITe6CjtujwBvAJQBHbHNYVf/
        +lTr+gL228wjnxS/M21DFUQ=
X-Google-Smtp-Source: ABdhPJy7TxOtHAy39T09MLRNUVJcqvEzN1bUUyiqcIoWYH0/BSufM4ICimqT7CpP52+svLaFSDDEFg==
X-Received: by 2002:a63:6c01:: with SMTP id h1mr5482917pgc.118.1644365069697;
        Tue, 08 Feb 2022 16:04:29 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id u17sm8124480pfi.163.2022.02.08.16.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 16:04:29 -0800 (PST)
Message-ID: <483bf415-8a13-0d2c-8737-9322c19ba537@acm.org>
Date:   Tue, 8 Feb 2022 16:04:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 01/44] ips: Use true and false instead of TRUE and
 FALSE
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-2-bvanassche@acm.org>
 <deb3fd22-2352-097f-7fa0-20d2e338aac8@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <deb3fd22-2352-097f-7fa0-20d2e338aac8@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 10:04, John Garry wrote:
> On 08/02/2022 17:24, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
>> index 498bf04499ce..b3532d290848 100644
>> --- a/drivers/scsi/ips.c
>> +++ b/drivers/scsi/ips.c
>> @@ -655,13 +655,13 @@ ips_release(struct Scsi_Host *sh)
> 
> This function and other places return an int, and not a bool, so that 
> could be changed as well. Prob not worth the churn, though.

Because of this comment I took a closer look at the ips_release() 
function. It seems to me that that function only has one caller and that 
caller ignores the value returned by ips_release(). So how about 
changing the return type into 'void'?

Thanks,

Bart.
