Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146F7C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 21:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbiLLVSY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 16:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbiLLVRz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 16:17:55 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD57CDF0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:16:04 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id o12so1148316pjo.4
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:16:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qQIObcshdEmowzE1SXyLK3lldQwZQVzG9UdDv3uvtwM=;
        b=x5ySUt9Opw4n3Dv355t/hkRIKiSOs7P6lF+1t3W8sqW06b/wxN9HPbOQXur4viRX9m
         F0TO8+jQATfXof/8/byH3T4vksew0RlSv2T3r5rwTyS/jiNikE7WlJdg9yGK9frV5I2I
         TlS/sOJsLYAxi04aUvVGJymldlRutF1bxvnSLtdXCxPC1U10azna+dE5aBXK6J8s3n51
         msY4ilf3Zunc7VPd6NjI70GyzBXnna9e72zE0+eWE4MKquPmJVLXyB44JRAFMl0eU4/M
         NVSyDKAXDbfNLDQrA5d88EsNffjmeDAwRWoc2xcvqKP6QsG7PgWsmvEAxYl26kiR7Jle
         LGiQ==
X-Gm-Message-State: ANoB5plG2TJJV0gA33hWu8QkTsPKuuCyzqX1LEfiUj9v178WLxf7fYzf
        j8t4s0zFml+oPtfY94OMWmQ=
X-Google-Smtp-Source: AA0mqf7wxySMx/DFLn/AvD1THwqAS4/lgfcQo+VckOEV3sqRBLFWWbE+xkx66WftiuxnGkT5CDgvUw==
X-Received: by 2002:a17:902:8c8d:b0:187:262a:7955 with SMTP id t13-20020a1709028c8d00b00187262a7955mr16535841plo.9.1670879764263;
        Mon, 12 Dec 2022 13:16:04 -0800 (PST)
Received: from [10.20.6.139] (rrcs-24-43-192-3.west.biz.rr.com. [24.43.192.3])
        by smtp.gmail.com with ESMTPSA id z15-20020a170902cccf00b00189929219acsm6812289ple.183.2022.12.12.13.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 13:16:03 -0800 (PST)
Message-ID: <577ca6f4-5729-9ad1-117b-30f76534c948@acm.org>
Date:   Mon, 12 Dec 2022 11:16:01 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 07/15] scsi: spi: Convert to scsi_execute_args
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-8-michael.christie@oracle.com>
 <9f1501ae-329e-c183-0ef5-b60fa87ac5b9@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9f1501ae-329e-c183-0ef5-b60fa87ac5b9@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/9/22 02:10, John Garry wrote:
> On 09/12/2022 06:13, Mike Christie wrote:
>> +    blk_opf_t opf = op | REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
>> +            REQ_FAILFAST_DRIVER;
>> +    struct scsi_exec_args exec_args = {
>> +        .req_flags = BLK_MQ_REQ_PM,
> 
> I think that .sshdr could still be assigned here, like:
>          .sshdr = sshdr ? : &sshdr_tmp;

That seems like an improvement to me. Once the above suggestion has been
applied, please add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
