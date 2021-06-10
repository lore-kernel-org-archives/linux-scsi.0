Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C22C48BCF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 037E461421
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFJDmt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 23:42:49 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:51975 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhFJDmq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 23:42:46 -0400
Received: by mail-pj1-f49.google.com with SMTP id k5so2822531pjj.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 20:40:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7lSLataGV7iSRJAgxXLdQ/flixWASBBaqlnjuhyNmZc=;
        b=olaA9f4YSV8z0FUIZNuOUET1HqTHzlHGYSVasvDDWOfXIN4s07Jac+yHZXYL5CWA05
         mPqOEksCm5QOqEVghsw0bRD2KOlpsm6AkWUCL6vtBbeoVsN7HeMFgT0rkAR4P0gc73yB
         UFrZLlllH6D5eL58DwsSu2fZX2zq9uRkL/MvZrxGdvlvaVEDwB8J1YbmgpwMJyAFIDPH
         s/nX0ij972sMKECBRQr1NE4jcoLSPetJttecGOpkYAOiBB+EZ7FWqUwwVtDq0PHR1F3u
         eYGhm0wKWRM7on/9gT/vSKO/OkF3W9sa7zSf1Hc1vzltnE3BJcKqEFOEM7mMbuDl9A/r
         WJKw==
X-Gm-Message-State: AOAM530IBrT4GORGe7iJ9vGT+IVP8p+0zNTO4gpYobLeufafRe0GwdA1
        ZIcZVci3OS13MYFIKAzSPKqqcYaUOps=
X-Google-Smtp-Source: ABdhPJzP/P4Ue46dLjJwHPkqSc84Tca8IjqZIW/javp0SrazW/DylLJDkMm/4gGtRkFoWcHYXIYOOw==
X-Received: by 2002:a17:902:c086:b029:104:3ec0:cef6 with SMTP id j6-20020a170902c086b02901043ec0cef6mr2941300pld.83.1623296437287;
        Wed, 09 Jun 2021 20:40:37 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id s3sm1084174pgs.62.2021.06.09.20.40.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 20:40:36 -0700 (PDT)
Subject: Re: [PATCH 13/15] scsi: core: Add helper to return number of logical
 blocks in a request
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <20210609033929.3815-14-martin.petersen@oracle.com>
 <a3687cac-dcc9-5579-5767-d211be505625@acm.org>
 <yq1im2mflzw.fsf@ca-mkp.ca.oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c042a828-d8b2-f8f0-192b-4037de243547@acm.org>
Date:   Wed, 9 Jun 2021 20:40:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <yq1im2mflzw.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/9/21 8:19 PM, Martin K. Petersen wrote:
>> On 6/8/21 8:39 PM, Martin K. Petersen wrote:
>>> +static inline unsigned int scsi_get_block_count(struct scsi_cmnd *scmd)
>>> +{
>>> +	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
>>> +
>>> +	return blk_rq_bytes(scmd->request) >> shift;
>>> +}
>>
>> I think we either need a comment above this function that explains that
>> the return value is a number of logical blocks or to change the function
>> name to make the meaning of the return value clear.
> 
> I went with the scsi_get_ prefix to match the scsi_get_sectors() and
> scsi_get_lba() calls. Felt that "block" would suffice but I could make
> it scsi_logical_block_count() if you prefer?

The name scsi_logical_block_count() sounds fine to me :-)

Thanks,

Bart.


