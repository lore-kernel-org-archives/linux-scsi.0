Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D90C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 17:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237596AbhKVR2k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 12:28:40 -0500
Received: from mail-pj1-f45.google.com ([209.85.216.45]:44786 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhKVR2j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 12:28:39 -0500
Received: by mail-pj1-f45.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso481745pjo.3
        for <linux-scsi@vger.kernel.org>; Mon, 22 Nov 2021 09:25:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ugpxve9G4VYnMlyBIivtKHFiq8bxnHuJEk67EXz6YWM=;
        b=VIJGVDoL4BAzT9mSA/eiQeVHREOuKG55DUOHLCOm3Kblg/roZpDGZ7Rok1KQglKrya
         G9+iO6XLq0b7cYhtoJ9MbqCg8WXWge5oDmuzHUYdrnf4WbjOkQY/l3xr+ogMR8EjDo/o
         J9JGa72l93TJaCijUi7TjDib+OCSmgNuQkAXgjmdyzwPJ4dB5kdd3PCZ5AG0Bv10kM7q
         AiYG0vQXPy/lZGhwMc0pXjnyyIZt4KenXXY8UBa+5jFJnICu90TnTdR4PDwmlSBSZXv6
         o6d3f3ghpzeAV/z0dKsyUuQfAfJnBwgp5D6TifHtoKTCdmm+SqI/ZJlc+g4TNJAKVHnu
         0b9g==
X-Gm-Message-State: AOAM531iNopjF9of+EJ796Ffxdhwj4JKyiy26hYVSNYKZt4r0+fwNzUz
        XejJCfbWC/524d3fl+0RPIY=
X-Google-Smtp-Source: ABdhPJwYXC5Udar9eIudlRbm8RNb5QypMBrbl/VhrPXv85YHmC7g2Z+OnLIR7cEQ0u+RMC8CBt4Bbg==
X-Received: by 2002:a17:90b:4a0f:: with SMTP id kk15mr32513620pjb.223.1637601932927;
        Mon, 22 Nov 2021 09:25:32 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3432:c377:2744:1125])
        by smtp.gmail.com with ESMTPSA id k22sm9100899pfi.149.2021.11.22.09.25.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 09:25:32 -0800 (PST)
Subject: Re: [PATCH v2 06/20] scsi: core: Add support for reserved tags
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-7-bvanassche@acm.org>
 <4f76acb2-68ff-6f6a-775b-81efc4cf10cc@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c5e09609-d61a-dd6d-0962-3c30a099638c@acm.org>
Date:   Mon, 22 Nov 2021 09:25:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <4f76acb2-68ff-6f6a-775b-81efc4cf10cc@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/21 12:15 AM, John Garry wrote:
> On 19/11/2021 19:57, Bart Van Assche wrote:
>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>> index 72e1a347baa6..ec0f7705e06a 100644
>> --- a/include/scsi/scsi_host.h
>> +++ b/include/scsi/scsi_host.h
>> @@ -367,10 +367,17 @@ struct scsi_host_template {
> 
> why no field in struct Scsi_Host?

Why to duplicate this field in struct Scsi_Host? Do we expect that there
will be SCSI drivers in the future for which the number of reserved tags
is only known at runtime? This seems unlikely to me.

>> +    unsigned reserved_tags;
> 
> I thought that unsigned int was preferred

I will change 'unsigned' into 'unsigned int'.

Bart.
