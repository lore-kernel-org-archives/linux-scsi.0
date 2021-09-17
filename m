Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56629C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 21:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 292D360F70
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 21:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242303AbhIQVyL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 17:54:11 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:33761 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhIQVyH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 17:54:07 -0400
Received: by mail-pj1-f41.google.com with SMTP id il14-20020a17090b164e00b0019c7a7c362dso4210244pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 14:52:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lexjQrg9VT94MoPnwz/Ib2zijy1pkQuE2vIhbi6bl5s=;
        b=TnV6ULsQnifsF8VKl962yL3NemwXMfCvQBwHwWYyQnOFUnB5P/S5Wp0aw+NjowRC8H
         ZxXMRN6nNObgBF9eVuw8Dm8BnhHJrEp/i/7thFxhoxYQHZs0fslIxollyDWRHhBZO3g1
         O8LIGBQ27/dS24Pm82XaKxCCupJ4OCbdfy4U5CQg60cftcdAuvA8prDovZtWtYovO+aR
         8eM4BSdS+M8OhKyFEi7TjFPwDhgM+o32JMEEFELmLamPmkPzpxcqilp+6vY7HLBUILLQ
         biwm9pexAM59v19FIpS0Au1VtsLNywVCovsjAPtvfB/yKTM7EQDl/P8gvdsvja0n1Puv
         ALrw==
X-Gm-Message-State: AOAM5319QQqLGk/DJMZr1rv26iY+Cp4Uj+9tZWw4SCSop+uwd7JbjnkX
        RLYOYYT2L53M4aTf2OeMXuE=
X-Google-Smtp-Source: ABdhPJzoBh+GcW4+1h/UsYlTtUbyTXO//O7PG/ansna0jtKFGf6vTrdd4eQFTusTaxNKqACVi2yklA==
X-Received: by 2002:a17:902:6185:b0:13b:76f5:8a03 with SMTP id u5-20020a170902618500b0013b76f58a03mr11553974plj.85.1631915564215;
        Fri, 17 Sep 2021 14:52:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa45:4fa2:923f:21d1])
        by smtp.gmail.com with ESMTPSA id e11sm6650319pfv.201.2021.09.17.14.52.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 14:52:43 -0700 (PDT)
Subject: Re: [PATCH v2] scsi: ufs: Unbreak the reset handler
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
References: <20210916175408.2260084-1-bvanassche@acm.org>
 <DM6PR04MB6575C763ED538A0B2761A7D1FCDD9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9c533cd3-4ecd-712e-3f8b-f4193049438b@acm.org>
Date:   Fri, 17 Sep 2021 14:52:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB6575C763ED538A0B2761A7D1FCDD9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/17/21 2:31 PM, Avri Altman wrote:
>> -                       __ufshcd_transfer_req_compl(hba, pos,
>> /*retry_requests=*/true);
>> +                       __ufshcd_transfer_req_compl(hba, 1U << pos,
>> + false);
> 1) Maybe a word in the commit log about changing retry_requests from true to false.
> 2) Also while at it, maybe change u32 pos to u8 tag?
> 3) Add an unsigned long pending_reqs, add the tag inside the loop,
>   And call __ufshcd_transfer_req_compl(hba, pending_reqs, false) one time outside the loop.

Hi Avri,

While working on this patch I realized that commit c11a1ae9b8f6
("scsi: ufs: Add fault injection support") is not necessary.
ufshcd_prepare_req_desc_hdr() initializes the command status to
OCS_INVALID_COMMAND_STATUS and ufshcd_transfer_rsp_status()
translates that status code into DID_REQUEUE. I'm considering to
revert commit c11a1ae9b8f6.

I prefer not to change "u32 pos" into "u8 tag", otherwise backporting
this patch would become harder than necessary.

Is (3) important to you? I don't think that calls to
ufshcd_eh_device_reset_handler() are that common so performance
probably is not that important in this function.

Thanks,

Bart.
