Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CC6C4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 15:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 428896052B
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 15:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244887AbhHFP4S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 11:56:18 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:37398 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244940AbhHFP4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 11:56:17 -0400
Received: by mail-pj1-f46.google.com with SMTP id dw2-20020a17090b0942b0290177cb475142so23398835pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 06 Aug 2021 08:56:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=beXRMX8EnxTahU9C1CGi3NCCnCvijOWZu6/UB8Ydwm4=;
        b=Ymm1BpfJTFTO1ozShyzQ0sgBO7FWlMOnmuAsdAEGzCFLpQYhlKfaNo/W/vp3coIwKl
         ARaCFiVV8DGVL6A/69OJgo43eWISP4qvfRU3RSMaSXkjSbjwOhz4oirGjH9Lwc+DxOyE
         OAm0F1eM8vxf5++YzPTOP4U0p4jVomqIFe+rMjgnzCdRUrSc8o+zr+hYlkt2vQ5Rogk5
         /KYvjeayQlRSkx3qqLLju6TK7pwT2BEFy+aeKzQhA64k39xdnhLugaKaG/ixmowOkfDr
         jXJXIxC2aujRPyELKO1u9wKiWCI/oLC16Z5mb6TX3g6TbD3D+0hudrOVX+OjHfif5zPl
         xhhg==
X-Gm-Message-State: AOAM530Awj6ES4v8JstFwfkXD/Kwj1zYdDjqmTl3WpLeanqyu6O5gDjT
        3zL5OfUAZPeM3zF+zwVzE6w=
X-Google-Smtp-Source: ABdhPJyoT8kfJ+keuzradRMuJMsHRP0ZgXmS2HeU+5j9WMBHRw387k1nshAF3c0dORph78FrAKfLAg==
X-Received: by 2002:a17:90a:ead3:: with SMTP id ev19mr10947520pjb.229.1628265361428;
        Fri, 06 Aug 2021 08:56:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id j5sm12588229pgg.41.2021.08.06.08.56.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 08:56:01 -0700 (PDT)
Subject: Re: [PATCH v4 12/52] NCR5380: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210805191828.3559897-1-bvanassche@acm.org>
 <20210805191828.3559897-13-bvanassche@acm.org>
 <b2ff95ac-49b2-6967-799-66bf23d3b7e@linux-m68k.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <041a2d03-c37e-288c-c042-95b825bf2fbc@acm.org>
Date:   Fri, 6 Aug 2021 08:56:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <b2ff95ac-49b2-6967-799-66bf23d3b7e@linux-m68k.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/6/21 2:24 AM, Finn Thain wrote:
> On Thu, 5 Aug 2021, Bart Van Assche wrote:
> 
>> Prepare for removal of the request pointer by using scsi_cmd_to_rq()
>> instead. This patch does not change any functionality.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Acked-by: Finn Thain <fthain@linux-m68k.org>
> 
> Did you consider replacing rq_data_dir(cmd->request) with
> cmd->sc_data_direction for this driver?

That's an interesting suggestion but I prefer to minimize the number of 
changes I make in NCR5380 drivers since I do not have access to a setup 
on which I can test any of these drivers.

Bart.
