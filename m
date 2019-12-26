Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E573BC2D0DA
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 17:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCBA820828
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 17:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfLZRfU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 12:35:20 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:38133 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfLZRfU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 12:35:20 -0500
Received: by mail-pj1-f68.google.com with SMTP id l35so3695867pje.3
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 09:35:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ghye4mr7B3KNF5+dyadgGje1rIOaAvKYW+WeWSyg9VY=;
        b=CjiJnCtsliChe8+SQwRDht1KHsHH0nbkzpGAIWlYxNHYAxnzAAFk9ghUCRY/04bNrQ
         wgQ4MxeO+vCo1DbrJOrDKWMis/vfnG6npNk+xhfREvB4uKQU1zeOPc0iaJj0cEwjaYhu
         x7oPeC25y6N0w8E+W+y4lq/lyEiuoZRTrSH4i5P0ZaifGUvF0vNMzQmr1thziMzdH60r
         wCHlc0cUfItz/CufDzEVzb1U6C4Nn0kQUax4uFgzkrBaqIU2nP9TsG/Jzp2PPVSEpXAW
         hOIDS/lE4XjB7pmWUo4fkX+Dm0UnNsZPu/0kRFvsiScsAlnOy0QlRdYygzWVKh0FSbmD
         rWEw==
X-Gm-Message-State: APjAAAXm0HUFvDXakl3NKne39GpVC/xT4ll7n51H2nWT4TNzlYaN3Bkj
        XkOwFu43AWCUduGZja14B8k=
X-Google-Smtp-Source: APXvYqyFWQFn6hgoyOZS6IINEBOuW/+gq7LY3awU2lJOnhLHVY6Rtf66ANb72Cu+7eH1Qt36WulWMw==
X-Received: by 2002:a17:902:8641:: with SMTP id y1mr47543098plt.110.1577381719376;
        Thu, 26 Dec 2019 09:35:19 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id x4sm37536447pff.143.2019.12.26.09.35.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2019 09:35:17 -0800 (PST)
Subject: Re: [PATCH 4/6] ufs: Fix a race condition in the tracing code
To:     Can Guo <cang@codeaurora.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191224220248.30138-1-bvanassche@acm.org>
 <20191224220248.30138-5-bvanassche@acm.org>
 <39b63e90a34a294957c89bd30d0e4912@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <27fdf41d-9ec1-380b-e481-7d76a2906c3d@acm.org>
Date:   Thu, 26 Dec 2019 09:35:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <39b63e90a34a294957c89bd30d0e4912@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/25/19 2:59 AM, Can Guo wrote:
> On 2019-12-25 06:02, Bart Van Assche wrote:
>> Starting execution of a command before tracing a command may cause the
>> completion handler to free data while it is being traced. Fix this race
>> by tracing a command before it is submitted.
>>
>> Cc: Bean Huo <beanhuo@micron.com>
>> Cc: Can Guo <cang@codeaurora.org>
>> Cc: Avri Altman <avri.altman@wdc.com>
>> Cc: Stanley Chu <stanley.chu@mediatek.com>
>> Cc: Tomas Winkler <tomas.winkler@intel.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 80b028ba39e9..4d9bb1932b39 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1875,12 +1875,12 @@ void ufshcd_send_command(struct ufs_hba *hba,
>> unsigned int task_tag)
>>  {
>>      hba->lrb[task_tag].issue_time_stamp = ktime_get();
>>      hba->lrb[task_tag].compl_time_stamp = ktime_set(0, 0);
>> +    ufshcd_add_command_trace(hba, task_tag, "send");
> 
> How about moving it after __set_bit(task_tag, &hba->outstanding_reqs);?
> 
> Thanks,
> 
> Can Guo.
> 
>>      ufshcd_clk_scaling_start_busy(hba);
>>      __set_bit(task_tag, &hba->outstanding_reqs);
>>      ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>>      /* Make sure that doorbell is committed immediately */
>>      wmb();
>> -    ufshcd_add_command_trace(hba, task_tag, "send");
>>  }

Hi Can,

As far as I can see ufshcd_add_command_trace() does not read 
hba->outstanding_reqs so calling ufshcd_add_command_trace() before 
changing outstanding_reqs should be fine.

The order chosen in the posted patch should minimize energy usage of the 
UFS controller, namely by calling the tracing function before starting 
clock scaling.

Thanks,

Bart.
