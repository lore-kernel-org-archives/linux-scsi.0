Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558B9C25B0E
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Aug 2022 17:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbiHPRmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Aug 2022 13:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbiHPRmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2022 13:42:36 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E734B7FE7D
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 10:42:35 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id 130so9681454pfy.6
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 10:42:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=3U0v/QRKh2Kvwk7krd3Gd8O926Db71pIgWCxLHDHDZc=;
        b=TpR7V4oixfBl9KQtKSre76ceibm2WDTAmSg0YDfRVifwZY1YOx5cRSZtk2zReRXQsa
         Bkj2ErgNaoiqQW5DwLo58yxUmyt8vQcUFq7B/KmzRJhE7qDgT3tqnEom7C34xasWG5OS
         S0DICxCnfqten7QINPx34wYPxaZsMLZyFIbnCFy9qm4EvTGmzCFaR/3RTqdcfSZlPCoN
         DV71vsntrz8fDecNonlYbr6vs8jsIYOp1tzbIy/Yk3l0qUJAhe0PMeRFSXzFuPYUwOMV
         uRAvelYrA7ooL1Rjs4D2on4w5C3uq/lXaOTTSCWzuOogMxV3FX7hCz0TiJaao44xcIxC
         MAAQ==
X-Gm-Message-State: ACgBeo08MyGDq5oJchaPhlSaABdpcyBVl5TiYmWO/sgPt2tuHERnZGUC
        1mdaZmrAOOVXLVgv0F3nHr0=
X-Google-Smtp-Source: AA6agR5X1jMyLSOcwKB78GV5QQnGI3it0gyiBjuhO75PUUUqAGm5jVKOOv3+Cq7PjXio5AS/+M3QLQ==
X-Received: by 2002:a63:698a:0:b0:41c:8dfb:29cb with SMTP id e132-20020a63698a000000b0041c8dfb29cbmr18773435pgc.170.1660671755296;
        Tue, 16 Aug 2022 10:42:35 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ff4b:545d:11c8:da9f? ([2620:15c:211:201:ff4b:545d:11c8:da9f])
        by smtp.gmail.com with ESMTPSA id d19-20020a170902aa9300b0016bea74d11esm9303624plr.267.2022.08.16.10.42.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 10:42:34 -0700 (PDT)
Message-ID: <6141d613-c4fc-dead-8d0d-d52073240710@acm.org>
Date:   Tue, 16 Aug 2022 10:42:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] scsi: ufs: Reduce the power mode change timeout
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>
References: <20220811234401.1957911-1-bvanassche@acm.org>
 <DM6PR04MB65752D7162050322A411C76AFC699@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB65752D7162050322A411C76AFC699@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/22 00:45, Avri Altman wrote:
>> The current power mode change timeout (180 s) is so large that it can
>> cause a watchdog timer to fire. Reduce the power mode change timeout to
>> 10 seconds.
> Maybe also worth noting that it was invented 20 years ago for scsi ioctl,
> And is less applicable for nowadays ufs devices
> 
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/ufs/core/ufshcd.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index e32b6b834b7f..2dd355a5da54 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -8776,6 +8776,8 @@ static int ufshcd_set_dev_pwr_mode(struct
>> ufs_hba *hba,
>>          struct scsi_device *sdp;
>>          unsigned long flags;
>>          int ret, retries;
>> +       unsigned long deadline;
>> +       int32_t remaining;
 >
> Maybe use ktime api, like its done throughout the driver?

Hi Avri,

Calling ktime_get() is much more expensive than reading the jiffies 
counter. That's why I prefer to use the jiffies counter if the timeout 
is significantly larger than 1 / HZ and if the accuracy of 1 / HZ is 
sufficient.

Thanks,

Bart.
