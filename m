Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6E3ECAAD3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 17:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiINRyx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 13:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiINRys (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 13:54:48 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE46C79636
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 10:54:46 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso15159954pjd.4
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 10:54:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=bFwWMl2vZQQAvuteqndyAbwy7asOl7p+RumrSlMx9RM=;
        b=rigehjZxYbZCWJku/Tdwud78iOOkj1Ym4+HwTZZhWMXG0kmmtrQwPG6hfYzSXdX0Dy
         Omf+OeMLmYwzO1CPyio0OjlUcCxksIxdt+kbooS/umMk5UMs3N+qTqO9yruzW5h5KV4x
         VWZ1Q4jC1XpWSBqHKYYzZeUrkiNmlUxwKeTDNNfv6/ft/q01ihE4W98QGVbsT73NdoCR
         7h4Jftb9RllQR/R9USSHKkoYbQ0c5tec8vrSXHic9wigbxHUv281M2YPEaToa28sl8sO
         lqh/TdgXO7lS2VlrYZPwGHVHNXDmQxpasK9NTMkTZG0gS6PJLmwCwHRH+FtPiXLOl90L
         XVRA==
X-Gm-Message-State: ACrzQf2K3D3LSPyE7ZppSygdFolF6PHs6V+WizY3at9xK35nGvVxYGEc
        OqjZ5XhsmINZLavZihigcP4=
X-Google-Smtp-Source: AMsMyM7JUQw834+0pr85c1sTPMiQsmsr/k59GwvQnM841AK1gfT6tBdIKcPY9cIvr+ZLp5jXQyxZWQ==
X-Received: by 2002:a17:90b:1d0f:b0:202:be3e:a14a with SMTP id on15-20020a17090b1d0f00b00202be3ea14amr6047049pjb.102.1663178085642;
        Wed, 14 Sep 2022 10:54:45 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:44a3:d997:5eda:cf2b? ([2620:15c:211:201:44a3:d997:5eda:cf2b])
        by smtp.gmail.com with ESMTPSA id gc10-20020a17090b310a00b001fd6066284dsm9499410pjb.6.2022.09.14.10.54.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 10:54:44 -0700 (PDT)
Message-ID: <b62a8571-b1cf-fc09-3dae-3c75c06bbb32@acm.org>
Date:   Wed, 14 Sep 2022 10:54:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v4 4/4] scsi: core: Rework the code for dropping the LLD
 module reference
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220913195716.3966875-1-bvanassche@acm.org>
 <20220913195716.3966875-5-bvanassche@acm.org>
 <011da034-b67a-c232-ebe0-d6d7d802247f@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <011da034-b67a-c232-ebe0-d6d7d802247f@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/14/22 02:52, John Garry wrote:
> On 13/09/2022 20:57, Bart Van Assche wrote:
>> -    mod = sdev->host->hostt->module;
>> +    mod = sdev->drop_module_ref ? sdev->host->hostt->module : NULL;
> 
> I suppose that this works.
> 
> My reservation is that there were some concerns of current module 
> referencing solution, so may not be better to build directly on it:
> 
> https://lore.kernel.org/linux-scsi/Ynt0aFMX+z%2FUhGJ2@infradead.org/

Hi John,

The above link points at a reply from Christoph Hellwig with the 
suggestion to use __module_get(). Implementing that suggestion would 
require to modify the kernel module implementation. My conclusion from 
reading the code in kernel/module/main.c is that increasing the module 
reference count after unloading has started currently has no effect. I 
have not found any code in the delete_module() system call 
implementation that waits for the reference count to drop to zero after 
try_stop_module() succeeded. I will look into this.

Thanks,

Bart.

