Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A15C2D0DA
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 17:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82D052075E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 17:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfLZRgW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 12:36:22 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37224 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfLZRgV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 12:36:21 -0500
Received: by mail-pl1-f196.google.com with SMTP id c23so10675528plz.4
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 09:36:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p0KcoE49thka5L3PWxLBih+8QZXxXSwuecET7UpNgGc=;
        b=GQxoyHKwzAjaAGny6B2pNKDpkGE8fP+MpgP+PF4WdqM7KiXRqj5xyvd+MgVSYoox+q
         BOMcVzysNlZm2vyT77euqze1GG+Ye1kZNep0A7DwRIjoqyo4Sn5zGMi+C1QIgQXfp850
         Hc5vRC5ASY2rFItC5uCSb6wQNtd+/ASAFEF37UUf8fW3upqscXRPg6fxp+ZGxJfi0WoA
         7WlZ8pFMiK1RyetQcdxq2WYswItd3MK5+2qFX14iIAbWWbmWaTB4BodgIiSez8iHeFSi
         0Yxh5aAq1mTgZhxcID/Be6MTrHL+L1HaLOg+3VwCRiAQcVWm/ML8ZGvFvHxEi7sFmypl
         ozDQ==
X-Gm-Message-State: APjAAAViWkLI/+Bcib+oTHUO7hS9hrdU8CjqnFPrTlaTRTzJh85FKvSV
        +JeQdHA4dJ/CS0rlHdv17ljhIFyC
X-Google-Smtp-Source: APXvYqyNp2KGEGTKwv79HfepL3IHHiziXR0KK0oGQ6aAlhAa9JG7xgEB2hn4Vivpyn3YZGj+8eww+g==
X-Received: by 2002:a17:90a:7781:: with SMTP id v1mr20822838pjk.57.1577381781329;
        Thu, 26 Dec 2019 09:36:21 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id q25sm37821901pfg.41.2019.12.26.09.36.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2019 09:36:20 -0800 (PST)
Subject: Re: [PATCH 5/6] ufs: Remove superfluous memory barriers
To:     Can Guo <cang@codeaurora.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191224220248.30138-1-bvanassche@acm.org>
 <20191224220248.30138-6-bvanassche@acm.org>
 <aba850f956421c187e0b88343f6d5070@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8eacc776-5a06-b984-8c26-39d0cbaa9d9a@acm.org>
Date:   Thu, 26 Dec 2019 09:36:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <aba850f956421c187e0b88343f6d5070@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/25/19 2:31 AM, Can Guo wrote:
> On 2019-12-25 06:02, Bart Van Assche wrote:
>> Calling wmb() after having written to a doorbell slows down code and does
>> not help to commit the doorbell write faster. Hence remove such wmb()
>> calls. Note: detailed information about the semantics of writel() is
>> available in Documentation/driver-api/device-io.rst.
>>
>> Cc: Bean Huo <beanhuo@micron.com>
>> Cc: Can Guo <cang@codeaurora.org>
>> Cc: Avri Altman <avri.altman@wdc.com>
>> Cc: Stanley Chu <stanley.chu@mediatek.com>
>> Cc: Tomas Winkler <tomas.winkler@intel.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 4d9bb1932b39..edcc137c436b 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1879,8 +1879,6 @@ void ufshcd_send_command(struct ufs_hba *hba,
>> unsigned int task_tag)
>>      ufshcd_clk_scaling_start_busy(hba);
>>      __set_bit(task_tag, &hba->outstanding_reqs);
>>      ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>> -    /* Make sure that doorbell is committed immediately */
>> -    wmb();
>>  }
>>
>>  /**
>> @@ -5766,8 +5764,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba 
>> *hba,
>>      wmb();
>>
>>      ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
>> -    /* Make sure that doorbell is committed immediately */
>> -    wmb();
>>
>>      spin_unlock_irqrestore(host->host_lock, flags);
> 
> Hi Bart,
> 
> Three wmb()s were added in commit ad1a1b9cd because we did see instances on
> which OCS=3(MISMATCH_DATA_BUFFER_SIZE) error were observed in large scale
> test. Commit ad1a1b9cd fixed the error and we had confirmed it through
> large amount of tests. I am not sure removing the 2 wmb()s here would cause
> regression or not.

Hi Can,

Thank you for having reported this. I will drop this patch.

Bart.
