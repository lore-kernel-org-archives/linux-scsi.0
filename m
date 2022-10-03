Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93ABFC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 16:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiJCQiY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 12:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJCQiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 12:38:23 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74DC24BC9
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 09:38:22 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id w191so1222273pfc.5
        for <linux-scsi@vger.kernel.org>; Mon, 03 Oct 2022 09:38:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=2Sik9N1X/b3VzxEVsM2e2QivX5VC3jafBwbpfUy45lc=;
        b=YR/I3gEzoZTPn2XRqjIK9utVTm+67UMbiCKKuzcG/D9ulLVK/9TJUZIXxqCEBo/VU5
         9QCXolnU0xtuCxcg3UNzD1Bvf/GHFRjdInnFCEz3oHPxSWF1aySRfZxoRxOkIk2nkUWi
         2f0tjmFvffpwDjXpI37Bj5hYJ1hQbunSjiSAPNN1olCjk3OUCMQQlpiiHF/cieik2TtA
         +40fP0rk10TzDKxWT+jFNa0x8Y6KfYh7CvSQN5CMSlXk+uDLP3GE8Xv46SlhOqQB4Xl6
         tYcNDhGQLOhXl1ASSUmZycUseOhD1+2xsY7CuJr3YgSllYd70+jZPYx9vbhsHR6c7aph
         UqYA==
X-Gm-Message-State: ACrzQf3aEvlzjZq817fJziIAt9hG4LucE5szPqEcb+sjkuYAoHuaE866
        r97FKNGR9hs4XnHuEk/hbpI=
X-Google-Smtp-Source: AMsMyM5XG6JfnXJBym6nErUkxU4PEXm25ULcbikQPiQZvRkJq7QHFArrOPBtTxU+B5T70db0ceUQhA==
X-Received: by 2002:a05:6a00:4006:b0:53e:815a:ff71 with SMTP id by6-20020a056a00400600b0053e815aff71mr23316285pfb.4.1664815102070;
        Mon, 03 Oct 2022 09:38:22 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id 64-20020a620543000000b0053e6d352ae4sm7624212pff.24.2022.10.03.09.38.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 09:38:20 -0700 (PDT)
Message-ID: <b55f6125-2ec9-f692-6b81-bcbeae3b46dc@acm.org>
Date:   Mon, 3 Oct 2022 09:38:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 6/8] scsi: ufs: Try harder to change the power mode
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220929220021.247097-1-bvanassche@acm.org>
 <20220929220021.247097-7-bvanassche@acm.org>
 <1ebd2cff-d73b-2d6d-ec93-80133f93e57c@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1ebd2cff-d73b-2d6d-ec93-80133f93e57c@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/22 23:10, Adrian Hunter wrote:
> On 30/09/22 01:00, Bart Van Assche wrote:
>> Instead of only retrying the START STOP UNIT command if a unit attention
>> is reported, repeat it if any SCSI error is reported by the device or if
>> the command timed out.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/ufs/core/ufshcd.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 02e73208b921..e8c0504e9e83 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -8784,9 +8784,9 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>>   	for (retries = 3; retries > 0; --retries) {
>>   		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
>>   				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
>> -		if (!scsi_status_is_check_condition(ret) ||
>> -				!scsi_sense_valid(&sshdr) ||
>> -				sshdr.sense_key != UNIT_ATTENTION)
>> +		if (ret < 0)
>> +			break;
> 
> Could use a comment to answer: why not retry if ret < 0 ?

OK, I will add a comment above that if-test.

>> +		if (host_byte(ret) == 0 && scsi_status_is_good(ret))
>>   			break;
> 
> Also could use a comment: why not just "if (!ret)" ?

The UFS spec says "CONDITION MET - Not used for UFS" so changing the 
above test into "if (!ret)" would be valid. If nobody objects I will 
change the above test into "if (ret == 0)" instead of adding a comment.

Thanks,

Bart.
