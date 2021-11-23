Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBAEC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 19:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhKWTVd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 14:21:33 -0500
Received: from mail-pl1-f175.google.com ([209.85.214.175]:34410 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbhKWTVc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 14:21:32 -0500
Received: by mail-pl1-f175.google.com with SMTP id y8so17923811plg.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 11:18:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b0BCQnCv7UdMCI30mY2LZNcr/pYmdTbSIcdCNr/S4vY=;
        b=c8jq/5K6BVmC9LS84fGNUlgQjI+IjI2ZPLFB23HBFDFKe8bwWF9xqyEtTLQEaRktpV
         m1gyFZvZHPOwWx+DGTKoAivpswH0N5Dflyf0YU4Dp21c7slFkUqa+0se3OQceYljvD1H
         CavzEKkZdmG/IoxfogEm1zWo0/YOvQS9NWpoN4pXjl8IlIwVaG3fMcwiV4YrADnsP2ku
         an/i50zz4dAs3CfAplcf8bnd3H5HLIgKtxrOyoxWHq7HmN4wYtDyW643z3zQs4uUy2Xd
         hqIbN00hhOq8p3eezPTxOlct8owEXrlBBum/JEJ88KvS9z1qD2foluT2fnTK3ygiHbwd
         D0aQ==
X-Gm-Message-State: AOAM533Zz/LbMy2ejPLFG81RWtLznxJrR7qSjto2vkgIgFMPK0GJjJCz
        m4Zn137UVpcgFsqT1fl4PmBLfs9aPAjXbQ==
X-Google-Smtp-Source: ABdhPJzCgus8aqRrDQTAInf+gJZC08OwACrSE/3mevPR6cW9iDU+X5CWp1aro0ir0tp76HwPXvYRcA==
X-Received: by 2002:a17:90b:1d82:: with SMTP id pf2mr6094393pjb.17.1637695104024;
        Tue, 23 Nov 2021 11:18:24 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id t10sm765787pga.6.2021.11.23.11.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 11:18:23 -0800 (PST)
Subject: Re: [PATCH v2 05/20] scsi: core: Add support for internal commands
From:   Bart Van Assche <bvanassche@acm.org>
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
 <140badd9-7ee0-73c8-9563-07761ab17753@acm.org>
Message-ID: <64e961f1-f4c4-655a-82af-60d75ab35f7a@acm.org>
Date:   Tue, 23 Nov 2021 11:18:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <140badd9-7ee0-73c8-9563-07761ab17753@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/23/21 9:46 AM, Bart Van Assche wrote:
> On 11/23/21 12:13 AM, Hannes Reinecke wrote:
>> It's actually a bit more involved.
>>
>> The biggest issue is that the SCSI layer is littered with the assumption
>> that there _will_ be a ->device pointer in struct scsi_cmnd.
>> If we make up a scsi_cmnd structure _without_ that we'll have to audit
>> the entire stack to ensure we're not tripping over a NULL device pointer.
>> And to make matters worse, we also need to audit the completion path in
>> the driver, which typically have the same 'issue'.
>>
>> Case in point:
>>
>> # git grep -- '->device' drivers/scsi | wc --lines
>> 2712
>>
>> Which was the primary reason for adding a stub device to the SCSI Host;
>> simply to avoid all the pointless churn and have a valid device for all
>> commands.
>>
>> The only way I can see how to avoid getting dragged down into that
>> rat-hole is to _not_ returning a scsi_cmnd, but rather something else
>> entirely; that's the avenue I've exploited with my last patchset which
>> would just return a tag number.
>> But as there are drivers which really need a scsi_cmnd I can't se how we
>> can get away with not having a stub scsi_device for the scsi host.
>>
>> And that won't even show up in sysfs if we assign it a LUN number beyond
>> the addressable range; 'max_id':0 tends to be a safe choice here.
> 
> There is no risk that the scsi_cmnd.device member will be dereferenced for
> internal requests allocated by the UFS driver. But I understand from your
> email that making sure that the scsi_cmnd.device member is not NULL is
> important for other SCSI LLDs. I will look into the approach of associating
> a stub SCSI device with internal requests.

(replying to my own email)

Hi Hannes,

Allocating a struct scsi_device for internal requests seems tricky to me. The
most straightforward approach would be to call scsi_alloc_sdev(). However, that
function accepts a scsi_target pointer and calls .slave_alloc(). So a
scsi_target structure would have to be set up before that function is called and
SCSI LLDs would have to be audited to verify that .slave_alloc() works fine for
the H:C:I:L tuple assigned to the fake SCSI device. Additionally, how should the
inquiry data be initialized that is filled in by scsi_add_lun()?

Since I do not use SCSI hardware that needs a scsi_device to be associated with
internal requests, I prefer that this functionality is implemented in a future
patch series. Changing the hba->host->internal_queue occurrences in the UFS
driver into something like hba->host->internal_sdev->request_queue once this
functionality is implemented should be easy.

Thanks,

Bart.

