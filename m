Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDBEC54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 16:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiI0QoZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 12:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiI0QoW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 12:44:22 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130FB1E05CE
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 09:44:22 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id n7so856791plp.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 09:44:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=WChHCJ5zMPBUjHOuoStvmvj6fgBD6ui7eYw+cXOVKTM=;
        b=S8ij4fdZcAq60o87dDoxQa0Mx8N/ExzSB9lNvBbk40axLhhGLuF9477akrIO2nGoQd
         WAt4Iw9huqhCfaHFdotx9NBWJhdKZL+AljCJUvntmrBH0zijI0GfNJ3X4AG+wjxId4TY
         g3RwoFvhLx1L2NAhI528WuOKsKoAyrgscs8lxO7HKlu2kvMhg++Bxy69d7bKU4dbZpeg
         kzCpw+Ba5wCUNx/f4fVSbzkf+ovE9BQ+wqKmLfT64h7pTHeGELHzTaT7PuW10NRgmBVl
         Ei3sN7h12vRlNezx0LyrY4GXutfx2oNfLjKmXOUOVFFKneoPIyUOvnXPbQEPEXZhWKky
         wotQ==
X-Gm-Message-State: ACrzQf10367vtrwJFicoy0AgnQSiqgphW54P56t8ZS+PPnXsFfQOOdFG
        MjDZGrBTp3H9mFDzzSQlAyd4T+OfgyA=
X-Google-Smtp-Source: AMsMyM75Q43ot7ZO6EFtQZS1Z/0ki0yq+U7wjcmWZvnvsUsnFTBARmZfqodeg6YIMiYun756u9BzKg==
X-Received: by 2002:a17:903:32cf:b0:178:3d49:45b0 with SMTP id i15-20020a17090332cf00b001783d4945b0mr27960355plr.5.1664297061436;
        Tue, 27 Sep 2022 09:44:21 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:457b:8ecb:16d:677? ([2620:15c:211:201:457b:8ecb:16d:677])
        by smtp.gmail.com with ESMTPSA id y68-20020a623247000000b0053e7293be0bsm1966298pfy.121.2022.09.27.09.44.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 09:44:20 -0700 (PDT)
Message-ID: <8da1c1db-1ef4-d2c7-2bed-8c475d008b3c@acm.org>
Date:   Tue, 27 Sep 2022 09:44:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 5/8] scsi: ufs: Try harder to change the power mode
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220923201138.2113123-1-bvanassche@acm.org>
 <20220923201138.2113123-6-bvanassche@acm.org>
 <BL0PR04MB65646BEA3CADD907E21C64B5FC559@BL0PR04MB6564.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <BL0PR04MB65646BEA3CADD907E21C64B5FC559@BL0PR04MB6564.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/22 03:41, Avri Altman wrote:
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
>> @@ -8784,9 +8784,9 @@ static int ufshcd_set_dev_pwr_mode(struct
>> ufs_hba *hba,
>>          for (retries = 3; retries > 0; --retries) {
>>                  ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
>>                                  START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
>> -               if (!scsi_status_is_check_condition(ret) ||
>> -                               !scsi_sense_valid(&sshdr) ||
>> -                               sshdr.sense_key != UNIT_ATTENTION)
>> +               if (ret < 0)
>> +                       break;
>
> continue?

Hi Avri,

Thanks for having taken a look. I chose "break" on purpose since the 
only case for which I expect scsi_execute() to return a negative value 
is request queue shutdown. If the request queue is being shutdown I 
think we should break out of the loop.

Thanks,

Bart.
