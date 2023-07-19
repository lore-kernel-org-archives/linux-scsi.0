Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA26C0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jul 2023 16:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjGSQeQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 12:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjGSQeP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 12:34:15 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450A41BB
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 09:34:14 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-34770dd0b4eso3024435ab.0
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 09:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689784453; x=1690389253;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iieXIi4cTzyX5sU/8yPoIFAVtn6YDcW57zqx5TU7ebg=;
        b=09WDlvC5f3GHlUlyn7LLHiT2uEm9wFMXxoxDrEG8gH4lw3bi3yOTAr3tbp+QZZfUAz
         I5FYc7PXZDulRrB2oJo+MvElwG733Aav7+9YolhYjS+9zHALaiNiW0TmvdPf9S9Wfe4/
         j/nSTRCoxOpEtrfOA5SRXC7xfWEiY+teBOjagU/fYxuEaN9JVFvFau9pQw6T2HVrkjZE
         p8+DShYM9cRWom2iG89hFEdBVOY3EK0CwSzOWkWXIP7VvGFQMAO2fJwFynw0wMxKYtES
         bJ1kqi7KY1Ut0cCHCYdiNpadLAk5U7UfOeYqr/YqkClojs90CGAo2za7Plp746lVXLkM
         U81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689784453; x=1690389253;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iieXIi4cTzyX5sU/8yPoIFAVtn6YDcW57zqx5TU7ebg=;
        b=g2IWwONodPX+bZWOK5VA5O7TD7cSE3UywBk9PnP3gzUM47ubz8WRE30HOe84h+vode
         rwnADwhpAkaCKsLm8sver4QTNAHaYb8biwA8JG7U5dMfAXgerht3UvoHlp4SqiE1lHsm
         q+EO9KtMeYZvLkgWMLoG1Zx1iBQ8GlIV4M36KoIgkEc9fBDlTrzL5kMZ4UWs+yV8ptgT
         SmTJ9H30pupOCUmkqHPU4FEblSaU9y1GJGBmlOm3oOBeTCIiG95x2d5LIXAVbCwtjDCF
         psmetTZZALc9B51GxjcahI3QNt5Dywa0/AN2Mzoaghf87INZpNFJw6xJx8zs3kIKl1Aw
         xZXg==
X-Gm-Message-State: ABy/qLakKM0Ur4s9ammNvFqBQKAzM4fokH5WGXlzbzK5ghaBnObIpEPL
        wg7vr+RoGwJ7tPAeX/wwFnV6Zw==
X-Google-Smtp-Source: APBJJlHh1Ulh9YNQ/Kx0yxnv+q8TVdGiL9skL9b/HxsOgkmxJ1VEsju4EJ1CyOQA9JHtCZSwQ9vgxA==
X-Received: by 2002:a92:da83:0:b0:33b:d741:5888 with SMTP id u3-20020a92da83000000b0033bd7415888mr299113iln.0.1689784453679;
        Wed, 19 Jul 2023 09:34:13 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t2-20020a056e02060200b00345aaa564a6sm1519038ils.44.2023.07.19.09.34.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 09:34:12 -0700 (PDT)
Message-ID: <ac099071-a16d-46a4-a1b1-2cc786a0a337@kernel.dk>
Date:   Wed, 19 Jul 2023 10:34:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] scsi/sg: fix checking return value of blk_get_queue()
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, mhartmay@linux.ibm.com,
        bblock@linux.ibm.com, bvanassche@acm.org, hch@lst.de
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20230705024001.177585-1-yukuai1@huaweicloud.com>
 <d112d30e-d144-4c76-db98-5de4767f5945@huaweicloud.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d112d30e-d144-4c76-db98-5de4767f5945@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/18/23 7:09?PM, Yu Kuai wrote:
> Hi, Jens
> 
> ? 2023/07/05 10:40, Yu Kuai ??:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Commit fcaa174a9c99 ("scsi/sg: don't grab scsi host module reference")
>> make a mess how blk_get_queue() is called, blk_get_queue() returns true
>> on success while the caller expects it returns 0 on success.
>>
>> Fix this problem and also add a corresponding error message on failure.
>>
>> Fixes: fcaa174a9c99 ("scsi/sg: don't grab scsi host module reference")
>> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> Closes: https://lore.kernel.org/all/87lefv622n.fsf@linux.ibm.com/
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> 
> Sorry about the trouble... Can you apply this patch? I notice that the
> original patch is applied to stable.

I can, I had assumed that Martin would pick it up on the SCSI side?

-- 
Jens Axboe

