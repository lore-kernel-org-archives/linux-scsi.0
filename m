Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD1FEB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jul 2023 16:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjGQQ7p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jul 2023 12:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjGQQ7n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2023 12:59:43 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C9B136
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 09:59:41 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1b89cfb4571so38165955ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 09:59:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689613180; x=1692205180;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d666XnqV32E4G9sv4HRl0vko4rSuBUQcEt1RziQcg2k=;
        b=iGrGeZFYA/wsbvdDPhS63vkIaHEqig1N9/A4XDQEXStxbbvNm7jQqDprYmgssFGZIl
         rLOjFbEmc871qh/IVVRDQ+/4gPlzri6KDwT1uJQCyzQa1Mx4BVcuc2tB9d7YBH0CGhLS
         FhaI0xE/kSvjreEZ+E4WlIWa9ifYFDEeB9XOQp/PoFfw80CRoBtonPm3pRHH+pPzlZ3c
         ySYICQEXcda6KY2tgzxLlc9PFxvZRfZuQBcfyQLlf2UNh23tdnv9t9ZXLDKioG6zm/FL
         DmpNVLUVcgDvWitqPasv9j9xTReGWn/dMhX+ptQYruXa1DToOdS9JK2nyW3egyOcc/+C
         ml8A==
X-Gm-Message-State: ABy/qLZ66sN0CXsr36qogE4eyTvzwSnDXE5TlmRh/0o6z1W15WlaTyw+
        7R5i1NRUw4WRNDeW6puaqo0=
X-Google-Smtp-Source: APBJJlEGtDUQU9yL6Fwas0nVBbDTBlsUdFMjDESM9DHHzW1rJhOn4s9A4OtYW/xWlLQX6uFOh26j7w==
X-Received: by 2002:a17:903:22ca:b0:1b8:a234:7617 with SMTP id y10-20020a17090322ca00b001b8a2347617mr15982671plg.5.1689613180233;
        Mon, 17 Jul 2023 09:59:40 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ac3:b183:3725:4b8f? ([2620:15c:211:201:ac3:b183:3725:4b8f])
        by smtp.gmail.com with ESMTPSA id g5-20020a170902740500b001b7fd27144dsm144936pll.40.2023.07.17.09.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 09:59:39 -0700 (PDT)
Message-ID: <6fc0f1b1-bcdc-81d3-d9ad-00ed228e701f@acm.org>
Date:   Mon, 17 Jul 2023 09:59:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v10 02/33] scsi: Allow passthrough to override what errors
 to retry
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-3-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230714213419.95492-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/23 14:33, Mike Christie wrote:
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 526def14e7fb..9a3908614dc9 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -71,6 +71,23 @@ enum scsi_cmnd_submitter {
>   	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
>   } __packed;
>   
> +#define SCMD_FAILURE_RESULT_ANY	0x7fffffff
> +#define SCMD_FAILURE_STAT_ANY	0xff
> +#define SCMD_FAILURE_SENSE_ANY	0xff
> +#define SCMD_FAILURE_ASC_ANY	0xff
> +#define SCMD_FAILURE_ASCQ_ANY	0xff
> +#define SCMD_FAILURE_NO_LIMIT	-1

A comment that explains the meaning of SCMD_FAILURE_RESULT_ANY and
SCMD_FAILURE_NO_LIMIT would be welcome. Does SCMD_FAILURE_RESULT_ANY 
e.g. retry only negative values of scmd->result, only positive or both?

I assume that SCMD_FAILURE_NO_LIMIT means that there is no limit on the 
number of retries?

Thanks,

Bart.
