Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69F7C00A5A
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 17:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjASR1t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Jan 2023 12:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjASR1m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2023 12:27:42 -0500
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D497C44A0;
        Thu, 19 Jan 2023 09:27:33 -0800 (PST)
Received: by mail-pf1-f174.google.com with SMTP id g205so2038934pfb.6;
        Thu, 19 Jan 2023 09:27:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uevu+pvo3ZIi+T3WwIxEqVbeApxQC0IOyRnax7XyE0g=;
        b=hMt7VTVU+Vog/MW1LEswDd0ZhkmX0ofin0LyHazIAp3FfieY8pt4d6wutLplHm5Gmx
         jjTcGuPp6imxepjaIKT1S55sqEKoqdFOI460a5BhON6LEhROgBZEaxFKD2NbPiEPrQpT
         1F1LMzKEL287P3mePwL6ZpaGASb7oJ9+O/TyBBrORO+FrF1u9UVwxufH5aWdv0w7JhYb
         y5r6KkahBdMeSUm4q3Ros7g6mVjNoO724dsXmb3y1y/crBUn1ZUk/7GkYIwEzvFB/2JN
         BG9cYCAXdbk7MWAllJZ3c78V1ePro1bi+lETScyg5fqNk+zJaY9G1ZT3z7/gwiw3wxWD
         nPQQ==
X-Gm-Message-State: AFqh2krhEiYL7aX+/juLfAEsC70hpkoEKMSISr+YUwfHiOeZrc+Q2WLI
        PJUNrEVSWn9nzcXgpD4BXnuMLHnW5YU=
X-Google-Smtp-Source: AMrXdXsmP/s8P80OwssBj+z7YDI11lTYIyvM8NlAJDTadbx7AcxRqEXTLCVlb72+ZvG1IHJ+yo9TSw==
X-Received: by 2002:aa7:9399:0:b0:58d:272a:52a0 with SMTP id t25-20020aa79399000000b0058d272a52a0mr10567279pfe.32.1674149253310;
        Thu, 19 Jan 2023 09:27:33 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:ff60:f896:307d:56f7? ([2620:15c:211:201:ff60:f896:307d:56f7])
        by smtp.gmail.com with ESMTPSA id c205-20020a624ed6000000b00580a0bb411fsm3505268pfb.174.2023.01.19.09.27.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 09:27:32 -0800 (PST)
Message-ID: <a849cb56-a384-530d-e12e-1dba2bed4355@acm.org>
Date:   Thu, 19 Jan 2023 09:27:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 8/9] scsi: core: Set BLK_SUB_PAGE_SEGMENTS for small
 max_segment_size values
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ming Lei <ming.lei@redhat.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <20230118225447.2809787-1-bvanassche@acm.org>
 <20230118225447.2809787-9-bvanassche@acm.org> <20230119053852.GA16933@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230119053852.GA16933@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/18/23 21:38, Christoph Hellwig wrote:
>> +	if (shost->max_segment_size && shost->max_segment_size < PAGE_SIZE)
>> +		blk_queue_flag_set(QUEUE_FLAG_SUB_PAGE_SEGMENTS, q);
> 
> Independ of me really not wanting this code at all if we can avoid it:
> this has no business in the SCSI midlayer or drivers.  Once the config
> option is enabled, setting the flag should happen inside
> blk_queue_max_segment_size.

Hi Christoph,

Thanks for having taken a look. I will move this code into the block layer.

Thanks,

Bart.
