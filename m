Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2DCC7618B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 17:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjCPR6f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 13:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjCPR6a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 13:58:30 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99D51CF5D;
        Thu, 16 Mar 2023 10:58:25 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id h8so2614718plf.10;
        Thu, 16 Mar 2023 10:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678989505;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=42qh0TJ+gQJypXCKia6jpq/HRk0KFBZPz4gtEfVjuWw=;
        b=kpz9kCJqiP9VhHk02VFUjk39T8p5FZxYKuwKL3USOAnGAGbT0VnCJ8uc0gB2ie0oWK
         Ct2rTqxgfJyOAwNiYlAPSVmVN1hE2ZvA8zCMZ6wnm01FwliKNgTDpogUdDwXCvHRwSjJ
         WWNn4QR1UKDbn7inKbr2+u4edu+Pa8gjdyO91xFdwdn/T01OPR/CwqKs4Hm5qDfwj9X0
         BIGvOSw/gVF0VCT/2UG+iu3Yp0oKpu5eG2/PBBOXrCa2+fHc5gw6L97CxDUuXTjbikil
         s469Klm6Rlj6q5NicyBxo1VcqZOVeCzxhgofvdLM8yENW5/OQucLT7Z49hxxWNzY5ar7
         5v8w==
X-Gm-Message-State: AO0yUKVy55bsnVKazR6lGofjgRfjsV/rq3F9tOKnNR9sW1xzL5k1AjKu
        cWZ57i0iMOjMnVPZOTLjoCs=
X-Google-Smtp-Source: AK7set+XWhAgid4VG9LOvXLGHZ1xHzrxKARO5tPgeLyd+NdxMvvxwgSX+2hbJsL+nCCfIkEdFtFUJw==
X-Received: by 2002:a17:902:f251:b0:19d:1fce:c9ec with SMTP id j17-20020a170902f25100b0019d1fcec9ecmr3717084plc.37.1678989505205;
        Thu, 16 Mar 2023 10:58:25 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e1f6:9298:f5ae:dab2? ([2620:15c:211:201:e1f6:9298:f5ae:dab2])
        by smtp.gmail.com with ESMTPSA id ks7-20020a170903084700b001933b4b1a49sm5884089plb.183.2023.03.16.10.58.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 10:58:24 -0700 (PDT)
Message-ID: <d5dcc9f2-6f7d-968f-a52d-a8e07df4c29e@acm.org>
Date:   Thu, 16 Mar 2023 10:58:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4 01/19] ioprio: cleanup interface definition
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
 <20230309215516.3800571-2-niklas.cassel@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230309215516.3800571-2-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/9/23 13:54, Niklas Cassel wrote:
>   /*
> - * The RT and BE priority classes both support up to 8 priority levels.
> + * The RT and BE priority classes both support up to 8 priority levels that
> + * can be specified using the lower 3-bits of the priority data.
>    */
> -#define IOPRIO_NR_LEVELS	8
> -#define IOPRIO_BE_NR		IOPRIO_NR_LEVELS
> +#define IOPRIO_LEVEL_NR_BITS		3
> +#define IOPRIO_NR_LEVELS		(1 << IOPRIO_LEVEL_NR_BITS)
> +#define IOPRIO_LEVEL_MASK		(IOPRIO_NR_LEVELS - 1)
> +#define IOPRIO_PRIO_LEVEL(ioprio)	((ioprio) & IOPRIO_LEVEL_MASK)
>   
> +#define IOPRIO_BE_NR			IOPRIO_NR_LEVELS

Is my understanding correct that today four I/O priority levels are 
supported and that these occupy two bits?

Thanks,

Bart.

