Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 576D0C4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 11:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33C3660F55
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 11:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbhHILvD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 07:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbhHILvC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 07:51:02 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC24C0613D3;
        Mon,  9 Aug 2021 04:50:41 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so34110367pjs.0;
        Mon, 09 Aug 2021 04:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=lEzRqawbCO3Oz7zqhJzZDzxmM9xxyvbKbGJKK51n77s=;
        b=CGGbHiQxQHOtVwEfubzZ9ceQPWqmETo95FQMcSqJ0TCV2NzJ9F0fuC3wm/RCnSVZRG
         Z5wfMX20T4zAnugcvmObELxDMvAfiA9i05R3D86KdMluIyMeW7LNQ7qDLkiZGME09a+n
         /qspJvkO+BTbNWqmzQqscmIVX799p/dhOPaHU9sg4Ev+7YK54vf4byFGi7Idl0ioojXN
         +c3GokUwZvjCMXT4CFAFbtPnB6Hak/lmGqHob1fNDdTCHPN1n6Y9rAcDfX4xy3k+eV1J
         tkXE1oibwbxSXIyroWAAjsNdKB0kvGXA4l2ghjQisC/7svtWGQSnq7O97HsqM+P3aNba
         ovxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=lEzRqawbCO3Oz7zqhJzZDzxmM9xxyvbKbGJKK51n77s=;
        b=A97jSCOkVTzJB3GNNsADe4xz+yuX/nmKbigmMzHf909KxQdnuJus0AHSzM3/61bWmv
         O5Aa0wxCQuOF7r2m1gVMWs4xDIHtP3jTOLfepLZs+NG4N+ssB5f7Gi1iy1r/vVqAXc69
         uKn+/hSHni0nqKaI5QjE1VPa9OdPujhmyHdnrYeumO8D5K8pVIwdusbjglapT2VDBDvq
         K/2cQSqPabn/gOrX8/2Wg80YJHuO8Ilw4jYuOVTz/BcckCXT0Eh+jglPfWHZhPtI1gYX
         ZSJaRDy4Q9zvE0X9qw779Cqzi6EjVjnv3xi0N6sV9Kt7zXhk+jdKVVYmm6Av95QoIf7H
         iMMQ==
X-Gm-Message-State: AOAM533/mHWAHH0uRzB90rbjosJ8cDt51kYcTbGBv+7yzAgISvvn0qbh
        Alyr0G1zB8AWkamDI17hMiY=
X-Google-Smtp-Source: ABdhPJxJrRwYquMEhsP80YPY2COvRlMDmLJN3BmTl+5y3TJFofzDG7vEJ3GquXp8SItJi85ZD/nmGw==
X-Received: by 2002:a17:902:c641:b029:12c:ef04:fa86 with SMTP id s1-20020a170902c641b029012cef04fa86mr9762891pls.40.1628509841418;
        Mon, 09 Aug 2021 04:50:41 -0700 (PDT)
Received: from [10.177.0.134] ([85.203.23.214])
        by smtp.gmail.com with ESMTPSA id z16sm22469492pgu.21.2021.08.09.04.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 04:50:41 -0700 (PDT)
Subject: Re: [PATCH] scsi: target: pscsi: Fix possible null-pointer
 dereference in pscsi_complete_cmd()
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        TOTE Robot <oslab@tsinghua.edu.cn>, martin.petersen@oracle.com
References: <20210807134651.245436-1-islituo@gmail.com>
 <dea07ecc-7700-5ee7-aa40-2d4455dc6c3f@gmail.com>
From:   Tuo Li <islituo@gmail.com>
Message-ID: <7c6622d0-2f28-27a7-250e-9a8fd79691a8@gmail.com>
Date:   Mon, 9 Aug 2021 19:50:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <dea07ecc-7700-5ee7-aa40-2d4455dc6c3f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks for your feedback. We will prepare a V2 patch and put the 
transport_kunmap_data_sg()
into the else-branch of the if (!buf).

Best wishes,
Tuo Li

On 2021/8/9 18:36, Bodo Stroesser wrote:
> On 07.08.21 15:46, Tuo Li wrote:
>> The return value of transport_kmap_data_sg() is assigned to the variable
>> buf:
>>    buf = transport_kmap_data_sg(cmd);
>>
>> And then it is checked:
>>    if (!buf) {
>>
>> This indicates that buf can be NULL. However, it is dereferenced in the
>> following statements:
>>    if (!(buf[3] & 0x80))
>>      buf[3] |= 0x80;
>>    if (!(buf[2] & 0x80))
>>     buf[2] |= 0x80;
>>
>> To fix these possible null-pointer dereferences, dereference buf only 
>> when
>> it is not NULL.
>>
>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>> Signed-off-by: Tuo Li <islituo@gmail.com>
>> ---
>>   drivers/target/target_core_pscsi.c | 14 +++++++-------
>>   1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/target/target_core_pscsi.c 
>> b/drivers/target/target_core_pscsi.c
>> index 2629d2ef3970..560815729182 100644
>> --- a/drivers/target/target_core_pscsi.c
>> +++ b/drivers/target/target_core_pscsi.c
>> @@ -620,14 +620,14 @@ static void pscsi_complete_cmd(struct se_cmd 
>> *cmd, u8 scsi_status,
>>               buf = transport_kmap_data_sg(cmd);
>>               if (!buf) {
>>                   ; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
>> -            }
>> -
>> -            if (cdb[0] == MODE_SENSE_10) {
>> -                if (!(buf[3] & 0x80))
>> -                    buf[3] |= 0x80;
>>               } else {
>> -                if (!(buf[2] & 0x80))
>> -                    buf[2] |= 0x80;
>> +                if (cdb[0] == MODE_SENSE_10) {
>> +                    if (!(buf[3] & 0x80))
>> +                        buf[3] |= 0x80;
>> +                } else {
>> +                    if (!(buf[2] & 0x80))
>> +                        buf[2] |= 0x80;
>> +                }
>>               }
>>                 transport_kunmap_data_sg(cmd);
>>
>
> I'm wondering whether we should better put the
> transport_kunmap_data_sg into the else-branch of the if (!buf)?
> AFAICS, calling it after transport_kmap_data_sg failed does not
> cause problems, but I feel it would be cleaner.
>
> Otherwise it looks good to me.

