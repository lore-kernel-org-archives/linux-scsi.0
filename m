Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321D9C7618A
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 18:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjCPSJl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 14:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjCPSJk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 14:09:40 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6976C0835;
        Thu, 16 Mar 2023 11:09:39 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id p6so1469707pga.0;
        Thu, 16 Mar 2023 11:09:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678990179;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4EXxnvoR771WGOO5ke6BtcxPDiDKqClvvmajt38cuxY=;
        b=FVNB2ZxoXGE+M424g/uMeNgVHHD7Rb8cAGcKR/YCpzQa6OAvQK+lmSx3MzHCD+9r6s
         bmLW29nU+4CZPGVjg7b0Fe/lyK1OREe35YXIxKpYNfkDX1BOKwePKeAdOvqBDUSrPU53
         tHK+DLgPxK844ucRUdwyUc9Zxq4T+xpy4wR565kKRN74b51JcgS44WGXrz/3DpTSTe8n
         txQ2HvdRrM5ITrQlcQwEa3Lwg9JbQawZQrHAesSAF02bf7W9SCNrcF5gz06xvANik5vt
         0VF0In5ckaqBomaIDIby+v1bhvGVrpnSdbk0cEO1vevvDOF+dt0XAXHBLTa3XtCSzyOV
         sq+g==
X-Gm-Message-State: AO0yUKUJDJEscga923pcr1DcpCCYI+a9A14i2sR0cmU2QkcX7MyHpCiq
        h59jfB6OLDINVdECtD3fO9E=
X-Google-Smtp-Source: AK7set+pLDEKd/Dnnv+KvVA0Q5aMiadTKLgWNrwgtOOBeopFoGHJpB8/3A2EgDDRMC3l8FAmGsdFog==
X-Received: by 2002:a62:2987:0:b0:5a9:cb6b:7843 with SMTP id p129-20020a622987000000b005a9cb6b7843mr3798027pfp.27.1678990179111;
        Thu, 16 Mar 2023 11:09:39 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e1f6:9298:f5ae:dab2? ([2620:15c:211:201:e1f6:9298:f5ae:dab2])
        by smtp.gmail.com with ESMTPSA id d19-20020a634f13000000b00502ea8014f3sm5417229pgb.42.2023.03.16.11.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 11:09:38 -0700 (PDT)
Message-ID: <f929fba2-1b83-9478-e511-7ff3c8b352a7@acm.org>
Date:   Thu, 16 Mar 2023 11:09:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4 01/19] ioprio: cleanup interface definition
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
 <20230309215516.3800571-2-niklas.cassel@wdc.com>
 <d5dcc9f2-6f7d-968f-a52d-a8e07df4c29e@acm.org>
In-Reply-To: <d5dcc9f2-6f7d-968f-a52d-a8e07df4c29e@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/16/23 10:58, Bart Van Assche wrote:
> On 3/9/23 13:54, Niklas Cassel wrote:
>>   /*
>> - * The RT and BE priority classes both support up to 8 priority levels.
>> + * The RT and BE priority classes both support up to 8 priority 
>> levels that
>> + * can be specified using the lower 3-bits of the priority data.
>>    */
>> -#define IOPRIO_NR_LEVELS    8
>> -#define IOPRIO_BE_NR        IOPRIO_NR_LEVELS
>> +#define IOPRIO_LEVEL_NR_BITS        3
>> +#define IOPRIO_NR_LEVELS        (1 << IOPRIO_LEVEL_NR_BITS)
>> +#define IOPRIO_LEVEL_MASK        (IOPRIO_NR_LEVELS - 1)
>> +#define IOPRIO_PRIO_LEVEL(ioprio)    ((ioprio) & IOPRIO_LEVEL_MASK)
>> +#define IOPRIO_BE_NR            IOPRIO_NR_LEVELS
> 
> Is my understanding correct that today four I/O priority levels are 
> supported and that these occupy two bits?

Please ignore the above question - according to the ioprio_get() man 
page there are eight levels.

Bart.

