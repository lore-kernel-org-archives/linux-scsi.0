Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF728C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9948961A2A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351262AbhI3SWf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:22:35 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:40482 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350955AbhI3SWd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 14:22:33 -0400
Received: by mail-pg1-f180.google.com with SMTP id h3so7115963pgb.7
        for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2021 11:20:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6D3bMTp1vtep7FyuwXgPkNnmdg++OrKv9WyykUBVuio=;
        b=hPiZy68pC4gEYUJ/hEoMS/50PqomXLUL5WmH5gqL4d0UewC0Dnmd+qwFWuL7RPiiwz
         ZEfqTrAz4Y4POEQsBPF7ruMY7jw9RY2Dznh996N6qBd8kFscC+gdX+ShfIAlgpEtAEtO
         pdhQthyGT1gPSyNUwkC4cCP78b4tyr0oCG6G7b60qq3eYY0anaoSD5xCOgwL7n6OPnFe
         nQM1Y4J3bl4K9l/105KUNZRNZ6GArYecWb9QuM6Uq5y6PGpI/51aApEIF3CVMQ5za449
         KyyaCpRl3DG01JRV2xmEgkSzO4PHZJo0vgCAzEKILL4SrwG2d0foPWt5yYfji1ANLnaF
         tL3w==
X-Gm-Message-State: AOAM531SBv50P053jAuAXOhMML7L/WhJhwihJP01+M7zZG5u9yMQZR2u
        aSFWgssxAxboCxUHSPIETN4=
X-Google-Smtp-Source: ABdhPJw999UN8WDwbuc7uC+G3Y+BDaR2sNJ+2A44tBaaOZCgGutefBGuFgaFp0Aq1uWWgJveHU50ew==
X-Received: by 2002:a05:6a00:16cb:b0:44b:bd38:e068 with SMTP id l11-20020a056a0016cb00b0044bbd38e068mr6937648pfc.34.1633026050037;
        Thu, 30 Sep 2021 11:20:50 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id m28sm3697145pgl.9.2021.09.30.11.20.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 11:20:49 -0700 (PDT)
Subject: Re: [PATCH v2 45/84] libsas: Call scsi_done() directly
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Lee Duncan <lduncanb@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Yan <yanaijie@huawei.com>, Yufen Yu <yuyufen@huawei.com>
References: <20210929220600.3509089-1-bvanassche@acm.org>
 <20210929220600.3509089-46-bvanassche@acm.org>
 <a2a1eaf0-91cd-df48-eca8-1b1e03ecd3e9@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fa3bc398-4291-db11-ca40-21e87bafdc07@acm.org>
Date:   Thu, 30 Sep 2021 11:20:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a2a1eaf0-91cd-df48-eca8-1b1e03ecd3e9@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/30/21 11:08 AM, John Garry wrote:
> On 29/09/2021 23:05, Bart Van Assche wrote:
>> Conditional statements are faster than indirect calls. Hence call
>> scsi_done() directly.
>>
>> Reviewed-by: Lee Duncan <lduncanb@suse.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Can you double-check these tags, as I know I provided a RB tag, but I'm not sure about Lee?

Right, this Reviewed-by tag should have been applied to the previous patch in
this series. I will review all Reviewed-by tags.

Thanks,

Bart.
