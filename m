Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A517C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 20:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5571B61CCA
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 20:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhGGUq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 16:46:58 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:35838 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhGGUq6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 16:46:58 -0400
Received: by mail-pl1-f177.google.com with SMTP id b5so1755424plg.2
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 13:44:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E5cl8rfaUsiZGZU1cjcb26qMdu3tn0gNckj8eKKLuSE=;
        b=q+rkqd6XHhf8TTElDRS0rTEoF3F9i4L9IdLwptQd9C5BbwOJuYNuQVuAxNajf+NSTk
         dNSQpCqY8nDbcf70RsDtIOdJdfHOD79yh3tmLx65Cjpt/DNkHFJuxh0U22BijvFB7WAS
         q3TQJEryRT2642xu9bUBtRBDESC4m6Z1RPLWPmRdTbahCoRqjqnT1Z/esGmIw5CaRWHL
         SQQvXqo/ChnPvdA+5LVtduGUuJ8yDqNnoZxoUOxgLDJrXWiqfMdMWYYNx9tB9NtJApaE
         9n7t6RNKcIqBPL84ua0dMf8TDHLb1IG/UQwQiZVsMYt0I0tH9DovK3esXv0Z8JRkNlPB
         Q7WA==
X-Gm-Message-State: AOAM533URJim+YoHFeggZbH5H01X513NktbUMg8YzZvBVo4bZc/iOMjx
        ADQwGbvkDKyrTBWneWHMMiI=
X-Google-Smtp-Source: ABdhPJxs9P34qb9P/ZI3C7UlLpXtLhNN2ioPwwSpadbfijgPPPQ9MXSgy+QCNk53cMm88U3UdzhoMA==
X-Received: by 2002:a17:90b:4b52:: with SMTP id mi18mr11017778pjb.37.1625690656846;
        Wed, 07 Jul 2021 13:44:16 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6679:27d9:f7a8:3b7e? ([2601:647:4000:d7:6679:27d9:f7a8:3b7e])
        by smtp.gmail.com with ESMTPSA id f20sm83290pfv.47.2021.07.07.13.44.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 13:44:16 -0700 (PDT)
Subject: Re: [PATCH 07/21] ufs: Only include power management code if
 necessary
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-8-bvanassche@acm.org>
 <DM6PR04MB657574076FC4E3FDAF5914C6FC1C9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <307aabfd-d1f0-d27e-8a2c-ed3dd19393dd@acm.org>
Date:   Wed, 7 Jul 2021 13:44:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB657574076FC4E3FDAF5914C6FC1C9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/4/21 11:33 PM, Avri Altman wrote:
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index a34aa6d486c7..37302a8b3937 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -8736,6 +8736,7 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba
>> *hba)
>>                 usleep_range(5000, 5100);
>>  }
>>
>> +#ifdef CONFIG_PM
> Maybe move this few lines up to include ufshcd_vreg_set_lpm as well?

The following call chain requires that ufshcd_vreg_set_lpm() is always
available: ufshcd_shutdown() -> ufshcd_suspend() -> ufshcd_vreg_set_lpm().

> Are there any ufs platforms that doesn't use pm management?
> Automotive platforms maybe?

I'm not sure whether there is any platform on which UFS PM is disabled.
My purpose with this patch is to document which code is not used if
power management is disabled.

Bart.

