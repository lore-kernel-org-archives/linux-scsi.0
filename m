Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE42CA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 18:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9E0C217F9
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 18:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfKASKF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 14:10:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41317 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbfKASKF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 14:10:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id p26so7574362pfq.8
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 11:10:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AekyYU7YBJe3U/LwAWAPvmk/32hIP0Eb6+OBgCDh+Nw=;
        b=SuhF6hy2Ptj0xBvEMvNdWiYACQEvh1Q5u9kRSGTOVU9CkWJyrE1pkUB/xoQjXt399l
         fOhdsf/UiU+Qn9OIi5UsNMl1bH3ZwNgqJZvCxDfysjk2+GQ6cOhk7+Q1MlctNHrZwb0R
         COCPKtkxyLP7esKm8uc2vBJfI+cUvgu7IkJvhMAyEvuGBIgFYIrvab8zYUnWKP9vgZ9/
         uwzdI7FGYAo7FMtLwYZWtki3O6VekJ8wpfvMk02BMN5F+OU7uNhxnh0F2PPPAU+w0mDs
         coRPcAY4EGsL7SkxacTBx2KW2O7V2cmUSxv886faepEY2UvAFL6rq3NaWUMy2aYJ1y6t
         MwEw==
X-Gm-Message-State: APjAAAWwGDVXLxzY6Oa18CurJ6ruij+iqkWcSCITB+WrKG9D/id70aZa
        op+SGf80dkCjIn1HCk11lrQSb1lmlu8=
X-Google-Smtp-Source: APXvYqwa9ySdwIOly6xAlgInGpu9AdRMC5GEWF0JO4Gzm6D4ghS5e6KkzsQBllaEvVmJ4elnzYTD0A==
X-Received: by 2002:a17:90a:1048:: with SMTP id y8mr815377pjd.22.1572631803935;
        Fri, 01 Nov 2019 11:10:03 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id o12sm7474613pgl.86.2019.11.01.11.10.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 11:10:02 -0700 (PDT)
Subject: Re: [PATCH 05/24] scsi: use standard SAM status codes
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191031110452.73463-1-hare@suse.de>
 <20191031110452.73463-6-hare@suse.de>
 <8c3245df-97e3-95aa-498f-4ed47db96132@acm.org>
 <74775fd3-3f13-1060-f93a-37db7b859ecd@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <33c4892c-b63f-2c5a-3963-6ea13e7c8ab0@acm.org>
Date:   Fri, 1 Nov 2019 11:10:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <74775fd3-3f13-1060-f93a-37db7b859ecd@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/1/19 9:54 AM, Hannes Reinecke wrote:
> On 11/1/19 5:26 PM, Bart Van Assche wrote:
>> On 10/31/19 4:04 AM, Hannes Reinecke wrote:
>>> Use standard SAM status codes and omit the explicit shift to convert
>>> to linux-specific ones.
>>
>> Isn't an explicit shift required to convert *from* linux-specific 
>> codes instead of for converting *to* linux-specific ones?
>>
>>>   drivers/ata/libata-scsi.c             |  2 +-
>>>   drivers/infiniband/ulp/srp/ib_srp.c   |  2 +-
>>>   drivers/scsi/3w-9xxx.c                |  5 +++--
>>>   drivers/scsi/3w-sas.c                 |  3 ++-
>>>   drivers/scsi/3w-xxxx.c                |  4 ++--
>>>   drivers/scsi/arcmsr/arcmsr_hba.c      |  4 ++--
>>>   drivers/scsi/bfa/bfad_im.c            |  2 +-
>>>   drivers/scsi/dc395x.c                 | 18 +++++-------------
>>>   drivers/scsi/dpt_i2o.c                |  2 +-
>>>   drivers/scsi/gdth.c                   | 12 ++++++------
>>>   drivers/scsi/megaraid.c               | 10 +++++-----
>>>   drivers/scsi/megaraid/megaraid_mbox.c | 12 ++++++------
>>>   drivers/scsi/pcmcia/nsp_cs.c          |  2 +-
>>>   13 files changed, 36 insertions(+), 42 deletions(-)
>>
>> Should this patch be split into one patch per driver such? If this 
>> patch would introduce a regression that will make it easier to address 
>> such regressions. Splitting this patch will also make reviewing easier.
>>
> If you think it's worthwhile ... sure.
> I'm already at 24 patches; splitting this off would get me an additional 
> 12 patches, all of which are basically one-liners.

Usually SCSI LLD authors only add their Reviewed-by tags to patches that 
only touch their driver and no other SCSI LLDs.

How about splitting this patch series into multiple smaller series?

Thanks,

Bart.
