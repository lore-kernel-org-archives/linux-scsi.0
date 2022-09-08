Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCD8C38145
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 16:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbiIHQxK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 12:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbiIHQwn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 12:52:43 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401BDF2D4E
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 09:50:38 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so3095559pjl.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 09:50:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=/fEOBF6YfcQnf1oNjSnbHNXKGzwnTyLYhdq3ULSSkSs=;
        b=lHjJAbpH2C8w0uqNl5dWHpEHEIkPNuwmqEcatSMMC/F7qIJwz7MRyOVbWcwDxQUQlI
         OYTpS8ASU09Kfv5WahMooU1f9BURlNCTwMxIdhs83rCeipp2eZjDgDMM78fean/MOK1L
         mxzOcl43nkE3hKwgHq9C+t4dJmH/S8pFYhd8Z3Dp2YtSUZSTTbKOwS4CKytRgZmblmA/
         753lHMtqIAkDxq1gl14OEyaJ2NqtZOGnJdXhmrXffo37SjpCMnu7iXxR9ir4wjAtWHON
         WqzQL/CbLhVkbZZmEyVb6oyUEeTR3e82sOIRLrSv+TeBrrNHAwhv+SyzBi8N/RpTX4C2
         UYvw==
X-Gm-Message-State: ACgBeo1JFUSusY2HmeRq+FCTZaI0wPRICu1OzOMH8PkKjfCJimQJfA4T
        SlUTiS077BbXI/GPsJiP3nA=
X-Google-Smtp-Source: AA6agR5ITCjjwnqGhrAHWnTwSyHCeFOZUJhSQHY92aVxGIvVIrKwDRLWKcqwM1vfybbNFnFnTPZJvA==
X-Received: by 2002:a17:902:f08a:b0:176:b477:8be0 with SMTP id p10-20020a170902f08a00b00176b4778be0mr9974312pla.66.1662655823867;
        Thu, 08 Sep 2022 09:50:23 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:71db:3cdf:3590:2e95? ([2620:15c:211:201:71db:3cdf:3590:2e95])
        by smtp.gmail.com with ESMTPSA id x14-20020aa79a4e000000b0053e22fc5b4fsm7041650pfj.0.2022.09.08.09.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 09:50:23 -0700 (PDT)
Message-ID: <19c5a7c7-3c43-be1a-71c7-b1d5c4edd1d5@acm.org>
Date:   Thu, 8 Sep 2022 09:50:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 0/2] Prepare for constifying SCSI host templates
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-scsi@vger.kernel.org
References: <20220830210509.1919493-1-bvanassche@acm.org>
 <9e9a24a0-3d04-306f-b8f6-dfe5fe03efab@huawei.com>
 <e22609d9-f5bc-4e03-b6d6-1393e8df6214@linaro.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e22609d9-f5bc-4e03-b6d6-1393e8df6214@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/8/22 08:04, Krzysztof Kozlowski wrote:
> On 01/09/2022 16:23, John Garry wrote:
>> On 30/08/2022 22:05, Bart Van Assche wrote:
>>
>> + Krzysztof
>>
>> This is the same topic as what Krzysztof was working on in
>> https://lore.kernel.org/linux-scsi/6f28acde-2177-0bc7-b06d-c704153489c0@linaro.org/
>>
>> And at least we have the scsi_host_template.module issue to solve - any
>> plan or progress for that?
> 
> I won't have time to work on that anytime soon, so feel free to pickup
> my patchset and rework or continue on your own.

Thanks for the feedback Krzysztof. I will keep you in Cc when I repost 
this patch series.

Bart.

