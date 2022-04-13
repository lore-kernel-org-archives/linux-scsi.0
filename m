Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 056C1C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Apr 2022 00:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiDMAK2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 20:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiDMAK1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 20:10:27 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709702B19D
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 17:08:08 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id j17so481897pfi.9
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 17:08:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DV3MqyFvN2qEcEU2LMShOH6QgvKElm8M5Xf8Fuxbs98=;
        b=gHtj8PJNFbldGHsoA8dtrlP6cAo84b8VtQxCDXfNphzLsF/zUqCrjSzOklNz1ry7HO
         jUsBCEfc7GLwM3/yQJBis8Gyl/qkzHxdBDOL2YYm9hDRUwfwKL7N/bZtM3pGiT4Ej9pb
         AKqaeUipH3yGhH9bC99+5S4WUc8ITYBVq0n9ArVchiOAYTddlLBJD+BdEKuRUx7CaWpz
         R0w7lKvKZnVSUYPKSAEUO1tpOcUX1Q4aKXzRYnOX+K+Gm3CVs+IvG1RDVECrfGPld1d4
         7Z5eVhyfOJP35DodtagCB+MGa+kXUiJBIq5ORsAWCNzaU0kOa49LXG5IocmVozJQd+HD
         706Q==
X-Gm-Message-State: AOAM530xibONf8NSQBW81EOlFmhPHK+Sb2St7FmxBiJOoJ6L+hEH+Ldp
        Mt7FqP76JQ8IDIv7y0XqrOrZ5mh7VTdYKA==
X-Google-Smtp-Source: ABdhPJx7gVbVNyksBfUHJ7HMDgE1GfjLFAPMgraYKjkfGEb9Y7GS8jOYteYq4HsWcg2Z+5QELoqaJA==
X-Received: by 2002:a05:6a00:24cb:b0:505:7935:670e with SMTP id d11-20020a056a0024cb00b005057935670emr25374042pfv.36.1649808487765;
        Tue, 12 Apr 2022 17:08:07 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:d4b2:56ee:d001:c159? ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id y16-20020a637d10000000b00381268f2c6fsm4065652pgc.4.2022.04.12.17.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 17:08:07 -0700 (PDT)
Message-ID: <f94c1865-ffac-d917-0604-00530047229d@acm.org>
Date:   Tue, 12 Apr 2022 17:08:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 07/29] scsi: ufs: Use get_unaligned_be16() instead of
 be16_to_cpup()
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>
References: <20220412181853.3715080-1-bvanassche@acm.org>
 <20220412181853.3715080-8-bvanassche@acm.org>
 <YlXuliEBsVH0VPaP@sol.localdomain>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YlXuliEBsVH0VPaP@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/22 14:26, Eric Biggers wrote:
> On Tue, Apr 12, 2022 at 11:18:31AM -0700, Bart Van Assche wrote:
>> Use get_unaligned_be16(...) instead of the equivalent but harder to read
>> be16_to_cpup((__be16 *)...).
>>
>> Reviewed-by: Bean Huo <beanhuo@micron.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/ufs/ufshcd.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index d4ef31e1a409..3ec26c9eb1be 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -7334,7 +7334,7 @@ static u32 ufshcd_get_max_icc_level(int sup_curr_uA, u32 start_scan, char *buff)
>>   	u16 unit;
>>   
>>   	for (i = start_scan; i >= 0; i--) {
>> -		data = be16_to_cpup((__be16 *)&buff[2 * i]);
>> +		data = get_unaligned_be16(&buff[2 * i]);
> 
> This is not "equivalent".  get_unaligned_be16() works on unaligned values
> whereas be16_to_cpup() assumes a naturally aligned value.  This patch might
> still be the right thing to do, but the explanation is not correct.

This is what I found in an English dictionary for the word equivalent:
"corresponding or virtually identical especially in effect or function". The
effect of this patch is that the same value will be stored in 'data' as without
this patch. Additionally, no runtime error will be generated with the patch
applied if the original code did not trigger a runtime exception. I think that
how I used the word "equivalent" is consistent with the explanation I found in
an English dictionary.

Thanks,

Bart.
