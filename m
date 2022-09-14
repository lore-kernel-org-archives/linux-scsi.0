Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9170C6FA82
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 16:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiINQnO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 12:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiINQnH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 12:43:07 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5A676453
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 09:43:04 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id s18so9748780plr.4
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 09:43:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=R81kToIU9C3vz1nro/2cccWGlf9WbpeOA/5OSELVtiE=;
        b=x+vQqzBqFbBQdXcjkx/8GUWJgETA+8mxzCRnA0cdKFlVpWw0Rrp6UzRRgKET56mQC8
         C2jWXrE5fmyiTmxu6LlgdQlRIujWIwz01nYTrogK3Xy2Mw2B0MZAwJdpNpO1e27T0uAU
         L++ZxUI2b7Tg4272gTf2ceyuWhHQXhQsQeWOrlgAnFuafBh6J0KXJiUfgnUntn+zcczk
         m7mnb/JQ36av4ltVH4oh006jyX1raee+WUR33DrUSWioTR0lephVPPy8OsQ+uciiFZFY
         2r1VZJAQZ8PryhHPQteAhTW7ryFflxQv2SPTQlihr6mQOUspVQRORCeipPdX1oEHHko/
         mltg==
X-Gm-Message-State: ACgBeo0S8pCj5+jEFSbPksu2XBoen8HppRZ0nmogGt/X3audWkNQsvM4
        Ir35OxeS8F0MVemgmfZgZZc=
X-Google-Smtp-Source: AA6agR4u69YN1bVH/lSes+zItnJWgCzDglJ9O4dOE1uetxE+jZKVarizp0Cn1Vfg6X75IEYSLAiuCA==
X-Received: by 2002:a17:902:7b8b:b0:170:c7fc:388a with SMTP id w11-20020a1709027b8b00b00170c7fc388amr8518660pll.29.1663173783799;
        Wed, 14 Sep 2022 09:43:03 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:44a3:d997:5eda:cf2b? ([2620:15c:211:201:44a3:d997:5eda:cf2b])
        by smtp.gmail.com with ESMTPSA id ja4-20020a170902efc400b001768bd49e4esm10988449plb.37.2022.09.14.09.43.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 09:43:02 -0700 (PDT)
Message-ID: <3ee85c43-161f-58a1-0319-8062547a630b@acm.org>
Date:   Wed, 14 Sep 2022 09:43:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v4 2/4] scsi: esas2r: Introduce scsi_template_proc_dir()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Bradley Grove <linuxdrivers@attotech.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220913195716.3966875-1-bvanassche@acm.org>
 <20220913195716.3966875-3-bvanassche@acm.org>
 <d63c326b-fa17-694c-cb72-aa746919218c@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d63c326b-fa17-694c-cb72-aa746919218c@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/14/22 02:06, John Garry wrote:
> On 13/09/2022 20:57, Bart Van Assche wrote:
>> This patch does not change any functionality.
> 
> ... intentionally :)

The above comment is not clear to me, nor whether any action is expected 
from my side?

Thanks,

Bart.
