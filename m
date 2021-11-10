Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5C2C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 18:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9758A60240
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 18:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbhKJTBr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 14:01:47 -0500
Received: from mail-pg1-f177.google.com ([209.85.215.177]:34486 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbhKJS7u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 13:59:50 -0500
Received: by mail-pg1-f177.google.com with SMTP id 200so3083873pga.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2021 10:57:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PAs0i/8pExENcox8IHxnkCgWtI32V7AaOPGtbMwtFhs=;
        b=7emEm6LmW0w54b4ZR+ZN0LJ8j4Tch17M9HRr9bFNzAsU41LCY/jaR8kDHj41gOqMZ+
         L/H28OefHg6Q2yGfhPULN5YJ4huQcEjyhVO9ggKG/AOxN5FTAsPGVPyrVwEydXTedTJA
         OZ8+tXZutTQ13gZL+j/pqDMBHSIRfxHEgs8a27ITvTfP2vsQEVE4ia21fFHMe9AvwivG
         HNCWuWP14jWyDnyv/PfQp8hX+F2cyQNd75OLHglHm/cSskwjDU/yvNKNRfvzuD9qCHBH
         FVFkl4InkUfHTpa5grYUU1TVo32f+07w4pRJAM31HyxT/dllEyR31wDYUSy5BvQaDvit
         8rgw==
X-Gm-Message-State: AOAM533RMQXF6YyuRpkzbfP8seySWrL1iF7108eL2GHiCGdB9nuJK1gQ
        cRPGd4ihQ5yg3Xgqf0YS8/g=
X-Google-Smtp-Source: ABdhPJw3Rv9yvxL5+hSrZYHKg+D03Pw9ZoHvStc8GC4T4QgPSHQkoGNhIMfXR+6IgfQCzpUfmw1drQ==
X-Received: by 2002:a05:6a00:a8e:b0:480:ab08:1568 with SMTP id b14-20020a056a000a8e00b00480ab081568mr1284291pfl.28.1636570622434;
        Wed, 10 Nov 2021 10:57:02 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:b41d:11d3:d117:fe23])
        by smtp.gmail.com with ESMTPSA id n20sm270051pgc.10.2021.11.10.10.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 10:57:01 -0800 (PST)
Subject: Re: [PATCH 10/11] scsi: ufs: Optimize the command queueing code
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-11-bvanassche@acm.org>
 <bd2cdc84-3776-a08c-dc41-272719097c83@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2753f2d4-7f1e-6ae2-37a6-fe6af8b07051@acm.org>
Date:   Wed, 10 Nov 2021 10:57:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <bd2cdc84-3776-a08c-dc41-272719097c83@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/21 12:04 AM, Adrian Hunter wrote:
> On 10/11/2021 02:44, Bart Van Assche wrote:
>> @@ -2698,8 +2653,11 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>>   
>>   	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
>>   
>> -	if (!down_read_trylock(&hba->clk_scaling_lock))
>> -		return SCSI_MLQUEUE_HOST_BUSY;
>> +	/*
>> +	 * Allows ufshcd_clock_scaling_prepare() and also the UFS error handler
>> +	 * to wait for prior ufshcd_queuecommand() calls.
>> +	 */
>> +	rcu_read_lock();
> 
> The improvement to flush/drain ufshcd_queuecommand() via RCU should
> be a separate patch because it is not dependent on the other changes.

I will split this patch into two patches.

Thanks,

Bart.
