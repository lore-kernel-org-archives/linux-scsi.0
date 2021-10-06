Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07FBC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 16:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AED78610A8
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 16:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239322AbhJFQDH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 12:03:07 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:46979 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhJFQDG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 12:03:06 -0400
Received: by mail-pj1-f53.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so2672345pjb.5
        for <linux-scsi@vger.kernel.org>; Wed, 06 Oct 2021 09:01:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PjUkrHIw2+bFmt+nVitBrpG8atV4o3KdG6P7Pc4wWzo=;
        b=Ccny2BFbY4KbU4Qqyue4fJLZjBE6HJTza2NFba69EH2ErFCoZTp4k5Pts2JAye2j22
         HcZPoUbuaqqlC5sBfDfLmsijZcc9wxzR+NDV3phwSnEs5cVMcUDY/CuOxme+OtFG/x76
         PJXCmlqiengo8es1nlU9F7Z7SCBse9nECOAKLTrWQ2QPx6koLPbZXLD7ztebRMKxdyeZ
         9B7u6IXTZOufADzx4bRJl6PoeXK41VQb/tO/fCT2a82OYnZaHrXBIkiNK1It7ZwKkuzh
         v+/z8zmy2l9nWjlf1XugJXdznDhX8OPgKJHcqCl8qMZG8qyFdGRMzOr2JPK9fLp2GnjG
         Ej+w==
X-Gm-Message-State: AOAM532oNR+9bYgnsw9JW0hYacJ9FMUtmNaRWu51B55G1lO672KFzFl/
        3yjcE5K8wOKykZuhRaIvGZBvZpn+YfQ=
X-Google-Smtp-Source: ABdhPJyTQyRwkYd3i2duips3dTN388fQOsbcFR0KZhP/OFNYRDKNKpyJ0Nf0RXDAALNYV2ojgPg6QQ==
X-Received: by 2002:a17:90a:7a8b:: with SMTP id q11mr11732955pjf.35.1633536073304;
        Wed, 06 Oct 2021 09:01:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6ad6:c36f:fdfb:9e74])
        by smtp.gmail.com with ESMTPSA id i125sm21310005pfc.36.2021.10.06.09.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 09:01:12 -0700 (PDT)
Subject: Re: [PATCH V7 1/2] scsi: ufs: Fix runtime PM dependencies getting
 broken
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20211005134445.234671-1-adrian.hunter@intel.com>
 <20211005134445.234671-2-adrian.hunter@intel.com>
 <dcb1c627-1431-8437-7a02-e5d74a3f3b70@acm.org>
 <9ad82ef9-30ea-1f01-db65-931d6ec14693@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e4b54446-3b3b-ec34-7e57-eb47a38d0835@acm.org>
Date:   Wed, 6 Oct 2021 09:01:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <9ad82ef9-30ea-1f01-db65-931d6ec14693@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/21 11:35 PM, Adrian Hunter wrote:
> On 05/10/2021 21:52, Bart Van Assche wrote:
>> The following code:
>>
>>      if (err == 0) {
>>          pm_runtime_disable(dev);
>>          err = pm_runtime_set_active(dev);
>>          pm_runtime_enable(dev);
>>          [ ... ]
>>      }
>>
>> has been introduced in scsi_dev_type_resume() by commit 3c31b52f96f7
>> ("scsi: async sd resume"). I'm in favor of removing that code.
> 
> Presumably that code is necessary.  Trying to remove it really seems a
> separate issue.

I want to move that code into the sd driver before this patch goes upstream.

Thanks,

Bart.


