Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE8DC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 14:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A71EB60E98
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 14:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhKCOna (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 10:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhKCOn3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 10:43:29 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE4BC061203
        for <linux-scsi@vger.kernel.org>; Wed,  3 Nov 2021 07:40:53 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id t38so2520236pfg.12
        for <linux-scsi@vger.kernel.org>; Wed, 03 Nov 2021 07:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WXn/tck9I3dCSb6Sqxnz0FpL7sizj58Bae5H10F9O20=;
        b=WLcw+BX4CEBEwC5oxT61xEeODA46ZoNoaQq1Ki9IqYn8A4R8KLEqtrJAJagmlgla6Z
         O/rgOjq7fN87R5PedHVVHg8v0C8WP4EowdL2E780f6Aehp4LIvDHPgISJ3wE1omL5wfV
         5BVQ1PsWng8p5jSUQ3aa8zfQrfLORGL9w0tf5/cKSLjjIADE4az1jumM/HH4AjTR+ea/
         FPjbOers02FJtnn7jvz258mBdkVkZesCLAIyZuX47PJNTS80bb5PiJAtQHu7EXHak6ys
         hIh2LXUz3rveShzyCec0gYruXieX3mGz3bUKsAn4v8EyyYR/qFzYewRZ20Yjf+ziyzpN
         J7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WXn/tck9I3dCSb6Sqxnz0FpL7sizj58Bae5H10F9O20=;
        b=cEnr04NYVs8ZehOL8afgp+wxEaj0cmTaScqTVAZw+oZnngkJVaXjfMpsB1Z834QIlR
         jDYdCx1RsvJyX/tMPkKPKMPlScFULrKFQdWwlEUfUwavXp5ux2dLwMK7msRK/tlbWrnq
         kQRM3STf+HMiKyHJnCF+L8tcNkZj7FxUB1udb7XdRbknyRPJkVs7Fr1gmvY7vg1ReVgV
         WkBRtC6rJB4SrF+4cktzhan4RtC5s7SQcwOOPpygCJiU/LvmQXn9GzFbIzKYKePqD2j3
         Sjz5PDfl5O3SLmXMxlsVTS4NaTvlvZObMThcZ4JF7X/E1M7RBJfChe4y01VC9AB9P1He
         mXSw==
X-Gm-Message-State: AOAM530HOACzdwhvrIugovm3LqVj/FktcvUbLrWTleQwELBN5q9c3kV0
        TbH4QAp0IpG/jBccXeur+WA4DQ==
X-Google-Smtp-Source: ABdhPJxb1BGI7wiwVazryNyanP5gFZuzdtXbmEhWke+a/LIlM0549Gnd85lr7EzfpFeKlxD+/SIneQ==
X-Received: by 2002:a63:d00c:: with SMTP id z12mr32568626pgf.334.1635950451526;
        Wed, 03 Nov 2021 07:40:51 -0700 (PDT)
Received: from [192.168.254.36] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id g22sm292376pfj.82.2021.11.03.07.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 07:40:51 -0700 (PDT)
Message-ID: <9e820a6e-a42e-1098-4044-5b6786ad7b2e@linaro.org>
Date:   Wed, 3 Nov 2021 07:40:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/2] scsi: scsi_ioctl: Validate command size
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20211103003719.1041490-1-tadeusz.struk@linaro.org>
 <d1259a80-ac2f-a164-685a-4d1763653021@acm.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <d1259a80-ac2f-a164-685a-4d1763653021@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/21 20:32, Bart Van Assche wrote:
>> +    if (hdr->cmd_len < 6 || hdr->cmd_len > sizeof(req->__cmd))
>> +        return -EMSGSIZE;
> 
> That doesn't look right to me since sg_io() allocates req->cmd if necessary:
> 
>      if (hdr->cmd_len > BLK_MAX_CDB) {
>          req->cmd = kzalloc(hdr->cmd_len, GFP_KERNEL);
>          if (!req->cmd)
>              goto out_put_request;
>      }

I missed that. I will send a v2 soon.

-- 
Thanks,
Tadeusz
