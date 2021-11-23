Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7116C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 17:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239626AbhKWRuO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 12:50:14 -0500
Received: from mail-pg1-f177.google.com ([209.85.215.177]:46817 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239618AbhKWRuJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 12:50:09 -0500
Received: by mail-pg1-f177.google.com with SMTP id r138so9404112pgr.13
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 09:47:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3qDj7fdwWxkAvnR5s/zHZkEVkMnvTkRQl98S3yHGYT4=;
        b=2UWbyjObnf4HS6455G+4XaEADWo1bAdxvpzg5iYvRbXUI2T2g7XTJqst+7nHResTiv
         80h6HcbJbaUbWNzAIRqgav4ICTdeAYp2k0++noObY8mtjqJ1j5jEKIAwfW+NLnJgDsa6
         5BJPgaJadtfeZKT8n+uOb0/c86bDA3RM+FGV3GRYcZYM5TNEeh33Wp7sEq4ulVNx1I7U
         gWRVU72ByO/KvpclKo87em6NZtgLuMsylux120d5QbwS88hpKwLAD+qPFiWIH4l3rGL+
         webf90nJQypnN1CBpADZ5+48luZTBgB2SMpD1ZLZzlYyr7qfs8BPJAfYy4x2gX3r9u8F
         wUag==
X-Gm-Message-State: AOAM531dYLI7XX60OQmdnJXm0/teMn7Gcca+HNmQngqoIBouLo896qoI
        elSpyoyWiRK61oGL8tPG5aM=
X-Google-Smtp-Source: ABdhPJzCfs0Gx8O5WgSIKhvxohorvjJBLdXXFnZvgeoX6oaGjF3NudrP6EAy+73ElvSaL9/tvVcRZg==
X-Received: by 2002:a63:778c:: with SMTP id s134mr5086810pgc.289.1637689620907;
        Tue, 23 Nov 2021 09:47:00 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id k8sm13169377pfu.75.2021.11.23.09.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 09:47:00 -0800 (PST)
Subject: Re: [PATCH v2 05/20] scsi: core: Add support for internal commands
To:     Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-6-bvanassche@acm.org>
 <d396a5ed-763e-de79-1714-b4e58e812c7f@huawei.com>
 <24ce9815-c01d-9ad4-2221-5a5b041ee231@acm.org>
 <0be5022e-bf3d-6e9f-22ee-9848265d2b82@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <140badd9-7ee0-73c8-9563-07761ab17753@acm.org>
Date:   Tue, 23 Nov 2021 09:46:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <0be5022e-bf3d-6e9f-22ee-9848265d2b82@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/23/21 12:13 AM, Hannes Reinecke wrote:
> It's actually a bit more involved.
> 
> The biggest issue is that the SCSI layer is littered with the assumption
> that there _will_ be a ->device pointer in struct scsi_cmnd.
> If we make up a scsi_cmnd structure _without_ that we'll have to audit
> the entire stack to ensure we're not tripping over a NULL device pointer.
> And to make matters worse, we also need to audit the completion path in
> the driver, which typically have the same 'issue'.
> 
> Case in point:
> 
> # git grep -- '->device' drivers/scsi | wc --lines
> 2712
> 
> Which was the primary reason for adding a stub device to the SCSI Host;
> simply to avoid all the pointless churn and have a valid device for all
> commands.
> 
> The only way I can see how to avoid getting dragged down into that
> rat-hole is to _not_ returning a scsi_cmnd, but rather something else
> entirely; that's the avenue I've exploited with my last patchset which
> would just return a tag number.
> But as there are drivers which really need a scsi_cmnd I can't se how we
> can get away with not having a stub scsi_device for the scsi host.
> 
> And that won't even show up in sysfs if we assign it a LUN number beyond
> the addressable range; 'max_id':0 tends to be a safe choice here.

There is no risk that the scsi_cmnd.device member will be dereferenced for
internal requests allocated by the UFS driver. But I understand from your
email that making sure that the scsi_cmnd.device member is not NULL is
important for other SCSI LLDs. I will look into the approach of associating
a stub SCSI device with internal requests.

Thanks,

Bart.
