Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18860C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 23:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345911AbiBJXyo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 18:54:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240464AbiBJXyn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 18:54:43 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653ED5F75
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 15:54:43 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id i6so11241943pfc.9
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 15:54:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JG1MbaPxwIDbfxyEq1zkFWxL1MhRXlNL1bqKQrf+SAo=;
        b=RLu4mp2HZZx0m64UzFuCjkEQ9dVHmuGQdEN64x/POONpg0jCFHhzunzjZoG61FKWxz
         uGQ2SfV0cO9W/hqs3KPTR0BXL02ph0oagciJ3NuoiliJL4LfDPvgItT1NDcEltl+viWW
         Zvm/6nPCOFBdJlO3SpycXIjg3UfwGwnkp6YA9d44Jsn3/hHSJV3Bp4ML7BJM3cHZst8t
         ptwpXKvs82Qm927Z2CuJxB+ddRyj597hfpnS6jWJqiFRpa9u9Xy1nmLUKMUbfIz4ZOiN
         bJv3uOq4H2oADkQ5FwqXUXjDExZkLWRcJLFQrV60jblMDXL0Ul9YC1U1KQ+Jnd8rTuTU
         LLvA==
X-Gm-Message-State: AOAM532w/JBaAczICUTyYMAhnTugH/alpvdbiQVXuY112kSs1L4udgeh
        NYe+T9b3GSR73symwxXMn16iMbJ33KtlfQ==
X-Google-Smtp-Source: ABdhPJz/uUvR2ogqMz5EHt/4xlEUnrUOjEznHOOLtMhz5DZG0wotnQ4PPAxKq69+Vx/Ez0V12iENtw==
X-Received: by 2002:a05:6a00:1696:: with SMTP id k22mr5603241pfc.54.1644537282490;
        Thu, 10 Feb 2022 15:54:42 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g12sm23490055pfm.119.2022.02.10.15.54.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 15:54:41 -0800 (PST)
Message-ID: <acf81166-75f9-ded9-a6ab-e9fe77f56cb7@acm.org>
Date:   Thu, 10 Feb 2022 15:54:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 21/44] imm: Move the SCSI pointer to private command
 data
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-22-bvanassche@acm.org>
 <9a73879b-cc52-0db3-5fe6-d3226ad709fc@suse.de>
 <05d0a3ab-ac64-5f59-8e4f-25cff2c8ce8a@acm.org>
 <4f4c4e13-52e8-12d8-6a8a-49d0ce45ce92@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4f4c4e13-52e8-12d8-6a8a-49d0ce45ce92@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/22 23:42, Hannes Reinecke wrote:
> On 2/9/22 19:27, Bart Van Assche wrote:
>> On 2/8/22 23:58, Hannes Reinecke wrote:
>>> On 2/8/22 18:24, Bart Van Assche wrote:
>>>> +struct imm_cmd_priv {
>>>> +    struct scsi_pointer scsi_pointer;
>>>> +};
>>>> +
>>> Why the indirection?
>>> You can use 'struct scsi_pointer' directly as payload, no?
>>
>> The indirection makes it easy to add more private command data in the 
>> future. However, I don't have a strong opinion about this. I can 
>> remove the indirection if you prefer this?
>>
> 
> That argument would be true for drivers under active development, but 
> these are ancient drivers which are in maintenance mode (at best).
> 
> I'd be surprised if we need to add more stuff to command payload.
> 
> Except the host_scribble bit; in the future we might be wanting to
> remove it in favour of the command payload, too.
> 
> But imm is not one of them, so we should be using 'struct scsi_pointer' 
> as the command payload directly.

I will use struct scsi_pointer directly in drivers that do not use 
host_scribble.

Thanks,

Bart.
