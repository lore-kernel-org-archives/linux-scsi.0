Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB952C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242266AbiECUNN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242287AbiECUM7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:12:59 -0400
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CABD4093C
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:09:16 -0700 (PDT)
Received: by mail-ot1-f45.google.com with SMTP id i25-20020a9d6259000000b00605df9afea7so12016588otk.1
        for <linux-scsi@vger.kernel.org>; Tue, 03 May 2022 13:09:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i4qGR0imgOYicCRLwmbl9K5IraxQM0E325bZcMtzYAw=;
        b=u8Fiwjzl1pCNVmPLstM+2tb6Tcnic+8yOBriAiE1lxWJZ+pP6Kc9vXu1woK8uO1P1n
         usRY6faGmA8uuTEfDO3vCSYFIKj7aHo7yd52vyrAczbUSsAwGPagfYuUifMA193xaDiw
         HTcnh7VaZj9JmwppAHnI+WDn8JYQKtqky0ReUO0OxAAZqhhu/N6Ma2I6Gzq5yV6WimJf
         Zj94Kx8PnuJRYuB8PaohbEcbTbPWlsLdsB8M80A2goHv+wCFTQQGsCUW5juUB5yrxp06
         rAy810RvjNbSH8kfy8jaxvbuxfumzfPryocmncHUEINvzs6bo/PHyOzy9EtWG14rpzQg
         icoA==
X-Gm-Message-State: AOAM532YkUeaV5LAd7E24ESvwzpLXlF7sMD8HiOElzoJ5iZEsxmiyOWM
        5E6/jgT0R6rruL1n8ygcAd7ONLEfQZc=
X-Google-Smtp-Source: ABdhPJzcdmqkS1TkRG6dyJB+K68MGcV2oXQFNQXEzqpeelfJUrs4UgiWAq5Z3CrcoI9/ypfEl5NUqw==
X-Received: by 2002:a9d:5c8d:0:b0:605:dfef:54e7 with SMTP id a13-20020a9d5c8d000000b00605dfef54e7mr6262672oti.344.1651608555702;
        Tue, 03 May 2022 13:09:15 -0700 (PDT)
Received: from [10.10.69.251] ([8.34.116.185])
        by smtp.gmail.com with ESMTPSA id r7-20020a056830236700b0060603221238sm4313116oth.8.2022.05.03.13.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 13:09:15 -0700 (PDT)
Message-ID: <6598e955-ee0a-e113-0981-36941fe55d76@acm.org>
Date:   Tue, 3 May 2022 13:09:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 17/24] snic: reserve tag for TMF
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-18-hare@suse.de>
 <b047dd15-4cb7-68d4-47d9-1cbe5f1b69d3@acm.org>
 <38829ee8-23cd-d03c-577f-fad7f0842d57@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <38829ee8-23cd-d03c-577f-fad7f0842d57@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/22 11:31, Hannes Reinecke wrote:
> On 5/3/22 09:18, Bart Van Assche wrote:
>> On 5/2/22 14:38, Hannes Reinecke wrote:
>>> diff --git a/drivers/scsi/snic/snic_main.c 
>>> b/drivers/scsi/snic/snic_main.c
>>> index 29d56396058c..f344cbc27923 100644
>>> --- a/drivers/scsi/snic/snic_main.c
>>> +++ b/drivers/scsi/snic/snic_main.c
>>> @@ -512,6 +512,9 @@ snic_probe(struct pci_dev *pdev, const struct 
>>> pci_device_id *ent)
>>>                        max_t(u32, SNIC_MIN_IO_REQ, max_ios));
>>>       snic->max_tag_id = shost->can_queue;
>>> +    /* Reserve one reset command */
>>> +    shost->can_queue--;
>>> +    snic->tmf_tag_id = shost->can_queue;
>>>       shost->max_lun = snic->config.luns_per_tgt;
>>>       shost->max_id = SNIC_MAX_TARGET;
>>
>> Hmm ... shouldn't cmd_per_lun also be decreased?
>>
> Shudder. No. Why?

I found the answer. The following code from scsi_add_host_with_dma() 
reduces cmd_per_lun so it is not necessary to do that from inside 
snic_probe():

	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
				   shost->can_queue);

Bart.
