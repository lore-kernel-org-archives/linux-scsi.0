Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BADFC6FA86
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Sep 2022 16:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiIGQTF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Sep 2022 12:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiIGQTD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2022 12:19:03 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A89FA4B2D;
        Wed,  7 Sep 2022 09:19:02 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d82so1503901pfd.10;
        Wed, 07 Sep 2022 09:19:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=TW5/xrU71CRZ+SFtRp+t5LY3Ivw7HfzPCmyqfMpNsds=;
        b=QWwboI8aO+Hq3Wx2k7faYDURr9Gu4IvHQyl9xjxow6OkDlDvxzHt/Z3YDN16CUNQLS
         UVgKqO+VGKYnvIPECdMet3bDTgnA9IXM75acuSLAkmSF2z3ieQAT0n+ucNbD9lpfHLEl
         cwTpL9AdcYW3/Urv9KGiQSBjxRb6303MtZ3sLjafX0uzfI/ks1rFnVh/ZBOpb5IvBPVI
         OeBmbotEvWwR0JQJljt6T2kJR3HVogTCsvLxvVVjYPDB1bYdNe3IMZrISFRNUTz4ci3j
         tRaNZZaqqu1LLTAoaK0VqCOSN3Wk/zIC/ZwfZHEj31bIHV0ltp/MntEXdU9Ij62F0zbo
         e0JQ==
X-Gm-Message-State: ACgBeo3PzR3pj6Su4rOIWU3TwsPYjTmqL7ZHh4WFFOOyrVwybmgTk+8W
        R1HqwQY3fqGSW+g8IB0yOmR4i/hZuM8=
X-Google-Smtp-Source: AA6agR7Bgwe6TvU0UVF6sPA2YFGQYnY+Wa89EBd5H/d62Yo0FVRHmOjVTZ/6x1ty6Yi+3Dq1Cdjdhg==
X-Received: by 2002:a63:fb56:0:b0:429:983f:b91e with SMTP id w22-20020a63fb56000000b00429983fb91emr4072903pgj.399.1662567540886;
        Wed, 07 Sep 2022 09:19:00 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:899e:cff7:8f51:a7ba? ([2620:15c:211:201:899e:cff7:8f51:a7ba])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090301c600b001712c008f99sm12500257plh.11.2022.09.07.09.18.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 09:18:59 -0700 (PDT)
Message-ID: <196c8254-1dcb-1fcf-d746-0bf3a4c12ff4@acm.org>
Date:   Wed, 7 Sep 2022 09:18:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/4] target: core: fix preempt and abort for allreg res
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220907135851.3756-1-d.bogdanov@yadro.com>
 <20220907135851.3756-2-d.bogdanov@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220907135851.3756-2-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/7/22 06:58, Dmitry Bogdanov wrote:
> -		if (pr_reg->pr_res_key != sa_res_key)
> +		if ((sa_res_key) && (pr_reg->pr_res_key != sa_res_key))
>   			continue;

Please do not introduce superfluous parentheses. Four parentheses can be 
left out from the above code without affecting readability.

Thanks,

Bart.
