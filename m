Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6169FC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 15:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F7361057
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 15:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245537AbhEQPss (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 11:48:48 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:36455 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239307AbhEQPqj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2021 11:46:39 -0400
Received: by mail-pj1-f54.google.com with SMTP id n6-20020a17090ac686b029015d2f7aeea8so4799565pjt.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 May 2021 08:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qTK//d31aZhvSYQqXCvfzzoZBJ2U6MgUWRnpl0nFbOQ=;
        b=kzMLYUpQ45Mg0j9SrUJJZOKDUnQYi/YlnyWTUgrQjhd6T8DNAFOv89+bXSy4AiLVeT
         SGHnkCuM3RjjprX9fdAhrcNi4EqBUrPZmDeVkGO9EGf98Q4ZRGz6YKLT2Z4wEY+i4LS3
         +sNY8baIelQhZ473r5JQ/f0ZcHAYoyyVVWBE3s2CsYH/Xddd/Z+M9t2QtrS9aaaLWgGH
         LbVDxrrqM3ilrlHqf0VEpiDDQoyUjqYPIyotlQjLb67nuBt6sysxJ3TVPQkj+Wk9uWEg
         IUIz9SewYlz9SZIGPkiaf93t9Acl0woGZ81kZWluuUJ2keXsMCsgfmuw5K0yprz0ii7i
         0qIA==
X-Gm-Message-State: AOAM531txEUadDIIBZdtvGp6h/TMw4KKHw8pbk9oac0xO6Lm1C8d0ork
        Ktk6PgaZte+A2qn5cHY/PtCfP+YPb5s=
X-Google-Smtp-Source: ABdhPJxNoRI0YMmGeCfYFvv43n3jxkOHuqPQsRSjGViTPj4m0J6EmD3hvIh1M1i7CM6nCwD3TSDYMw==
X-Received: by 2002:a17:902:a40e:b029:e9:7253:8198 with SMTP id p14-20020a170902a40eb02900e972538198mr465062plq.82.1621266323129;
        Mon, 17 May 2021 08:45:23 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:8224:c0d6:d9dd:57b3? ([2601:647:4000:d7:8224:c0d6:d9dd:57b3])
        by smtp.gmail.com with ESMTPSA id f18sm11015466pjh.55.2021.05.17.08.45.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 08:45:22 -0700 (PDT)
Subject: Re: [PATCH 1/3] libsas: Introduce more SAM status code aliases in
 enum exec_status
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20210514232308.7826-1-bvanassche@acm.org>
 <20210514232308.7826-2-bvanassche@acm.org> <20210515064407.GB26545@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <10ff7ccc-fb76-d5a7-708e-6bfa0f2d4ace@acm.org>
Date:   Mon, 17 May 2021 08:45:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210515064407.GB26545@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/14/21 11:44 PM, Christoph Hellwig wrote:
>> index 9271d7a49b90..9b17f7c8c314 100644
>> --- a/include/scsi/libsas.h
>> +++ b/include/scsi/libsas.h
>> @@ -477,6 +477,9 @@ enum exec_status {
>>  	/* The SAM_STAT_.. codes fit in the lower 6 bits, alias some of
>>  	 * them here to silence 'case value not in enumerated type' warnings
>>  	 */
>> +	__SAM_STAT_GOOD = SAM_STAT_GOOD,
>> +	__SAM_STAT_BUSY = SAM_STAT_BUSY,
>> +	__SAM_STAT_TASK_ABORTED = SAM_STAT_TASK_ABORTED,
>>  	__SAM_STAT_CHECK_CONDITION = SAM_STAT_CHECK_CONDITION,
> 
> I don't think the (existing) naming and comment are very helpful here.
> 
> I'd so a s/__SAM_/SAS_SAM_/

Hi Christoph,

How about changing __SAM_STAT_ into SAS_STAT_ to keep the prefix short?

> and replace the comment with something like:
> 
> 	/*
> 	 * The first 6 bytes are used to return the SAM_STAT_* codes.  To avoid
> 	 * 'case value not in enumerated type' compiler warnings every value
> 	 * returned through the exec_status enum will need an alias with
> 	 * the SAS_ prefix here.
> 	 */
> 	SAS_SAM_STAT_GOOD = SAM_STAT_GOOD,
> 	SAS_SAM_STAT_BUSY = SAM_STAT_BUSY,
> 	...

There is another issue with that comment: 7 bits are required to
represent status code 40h - TASK ABORTED. Anyway, thanks for having
taken a look. I will update the comment.

Bart.



