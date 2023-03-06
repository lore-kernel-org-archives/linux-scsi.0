Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF799C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 13:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjCFNvY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 08:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjCFNvT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 08:51:19 -0500
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F5D20689
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 05:51:12 -0800 (PST)
Received: by mail-pl1-f175.google.com with SMTP id p6so10431625plf.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 05:51:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678110672;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lTsjNwiihQDQoRlQ5o/SomQxndkzV0Pk+GEqVrgoG0E=;
        b=B35J3B57j6lYfLpsFmbO7V4RJx/I6+jnO4nywRrYMweu2X2Ot0ALnoesJGLTPoYss1
         sIcX81I6aWgMN/SturROlLh2mHA88cuD9/u1/DROh6tt80We6ID8UGXBZPAvC1svKS6d
         LutYBgLNP4ynnW2q6uXEXZcycxMkkEWGdPeudmhZBtB4QrWDr/BmbWSOdy3rxEMkPnKl
         5cdKqfl6dpEXfXwBeTltWlPiKw93EtKbjPVkL/2gPpyFKRDZDeBeC94wQhbFSynsBoGt
         fIo1k/Xs3fC6fhaSrirkPInBAx9yEt+mH8RZzRr2TBdfTmYXSuq0G8bWgwcWtsSsNks2
         ZWhg==
X-Gm-Message-State: AO0yUKUAS2CaQWHZMxgPXfdgtFeKtbgNlag8C1tKuFd9qJXXIAww2JSp
        OnsQbSXXqZrlcHTk3dZm62s=
X-Google-Smtp-Source: AK7set8heMa+Pzolp7G+y8oqUstfk4X18FcLA70b5YsGEYzscXaN8AWvYlSIoretBmaZA9NfRP4L4Q==
X-Received: by 2002:a17:902:e84f:b0:19a:8ce1:2c55 with SMTP id t15-20020a170902e84f00b0019a8ce12c55mr13543978plg.8.1678110672228;
        Mon, 06 Mar 2023 05:51:12 -0800 (PST)
Received: from [192.168.132.235] ([63.145.95.70])
        by smtp.gmail.com with ESMTPSA id kq13-20020a170903284d00b0019a7f427b79sm6751218plb.119.2023.03.06.05.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 05:51:11 -0800 (PST)
Message-ID: <28688dcd-36a9-3c37-e4df-044cdccb7e55@acm.org>
Date:   Mon, 6 Mar 2023 05:51:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 01/81] scsi: qla2xxx: Refer directly to the
 qla2xxx_driver_template
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-2-bvanassche@acm.org>
 <fb29154c-fdac-8b45-1e8a-4b4e732e4dd7@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <fb29154c-fdac-8b45-1e8a-4b4e732e4dd7@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/6/23 05:10, John Garry wrote:
> On 04/03/2023 00:29, Bart Van Assche wrote:
>> --- a/drivers/scsi/qla2xxx/qla_target.c
>> +++ b/drivers/scsi/qla2xxx/qla_target.c
>> @@ -6395,8 +6395,8 @@ int qlt_add_target(struct qla_hw_data *ha, 
>> struct scsi_qla_host *base_vha)
>>           return -ENOMEM;
>>       }
>> -    if (!(base_vha->host->hostt->supported_mode & MODE_TARGET))
>> -        base_vha->host->hostt->supported_mode |= MODE_TARGET;
>> +    if (!(qla2xxx_driver_template.supported_mode & MODE_TARGET))
>> +        qla2xxx_driver_template.supported_mode |= MODE_TARGET;
> 
> So we're saying if that MODE_TARGET bit is not set, then set it. It 
> would be neater to just always set it, right?
> 
> Apart from that, I will say that I haven't studied the driver in detail, 
> but my impression is that we should just set this flag per-shost in 
> base_vha->host.active_mode, and not the host template supported_mode 
> member. Indeed, we don't even seem to be making this driver 
> scsi_host_template as const in this series, which I thought was the aim 
> (and I assume because of this).

Hi John,

If I have to repost this patch series I will implement this suggestion.

Thanks,

Bart.

