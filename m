Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC335C25B47
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 16:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbjJXQl5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 12:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbjJXQl4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 12:41:56 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC097133;
        Tue, 24 Oct 2023 09:41:53 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1c8a1541232so40129225ad.0;
        Tue, 24 Oct 2023 09:41:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698165713; x=1698770513;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9h8QESnesfI/2xgkBEeyIn3zqQHGqYc+uKKPeuOMZZM=;
        b=J2J5lAOW3eFdtQuoczjyWyxF+cGloiHjHKpeYxQARW58l36GHbS1RIAdE/Ey1ZKLqr
         taDLb5GVdm6lPVgrITzePKnDK0YdSeVKH3Y5yPLUclM4AcsVvLc/Ee6bvFQ1V2O0+3ZV
         fDv4ay2bKhdbDV1XC8U5OSTxRI21rDFv+mIxDb04kxb31E6gQ5YRcVg9lV7uQWq/we6t
         6AUY/HkG6nDbmYeAmEy1usnx5Mv6fg1Is5YT3+fhNVR1d72wvnLF/KcK2MUknMjbFLI8
         e5QdkbTWa2ImIR/LcErVIcQwG0um0OBEmEkZ978gIlYf4xPN3nJ5MA2vIw2gm2uR4ZEB
         sE/w==
X-Gm-Message-State: AOJu0YyFdL2eYAUISfc9nTLpCkNHYsTK9LsX7F31/0S9//fQe5agFTs2
        pmb1n4nKTXMSghubdvnkWOs=
X-Google-Smtp-Source: AGHT+IGjQQ10KwiGQKdPeA+wWZdBAWgsecQcomGIIcdR7osP18H1W0cl6lDwOWCkNdKevmD0hXHCKg==
X-Received: by 2002:a17:902:d2cd:b0:1ca:3fa6:4aef with SMTP id n13-20020a170902d2cd00b001ca3fa64aefmr15587645plc.66.1698165713001;
        Tue, 24 Oct 2023 09:41:53 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b089:b200:3b6d:bf8? ([2620:15c:211:201:b089:b200:3b6d:bf8])
        by smtp.gmail.com with ESMTPSA id i17-20020a17090332d100b001c32fd9e412sm7591284plr.58.2023.10.24.09.41.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 09:41:52 -0700 (PDT)
Message-ID: <5d37f5ed-130a-4e75-b9a7-f77aeb4c7c89@acm.org>
Date:   Tue, 24 Oct 2023 09:41:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] Support disabling fair tag sharing
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
References: <20231023203643.3209592-1-bvanassche@acm.org>
 <ZTcr3AHr9l4sHRO2@fedora>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZTcr3AHr9l4sHRO2@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/23 19:28, Ming Lei wrote:
> On Mon, Oct 23, 2023 at 01:36:32PM -0700, Bart Van Assche wrote:
>> Performance of UFS devices is reduced significantly by the fair tag sharing
>> algorithm. This is because UFS devices have multiple logical units and a
>> limited queue depth (32 for UFS 3.1 devices) and also because it takes time to
>> give tags back after activity on a request queue has stopped. This patch series
>> addresses this issue by introducing a flag that allows block drivers to
>> disable fair sharing.
>>
>> Please consider this patch series for the next merge window.
> 
> In previous post[1], you mentioned that the issue is caused by non-IO
> queue of WLUN, but in this version, looks there isn't such story any more.
> 
> IMO, it isn't reasonable to account non-IO LUN for tag fairness, so
> solution could be to not take non-IO queue into account for fair tag
> sharing. But disabling fair tag sharing for this whole tagset could be
> too over-kill.
> 
> And if you mean normal IO LUNs, can you share more details about the
> performance drop? such as the test case, how many IO LUNs, and how to
> observe performance drop, cause it isn't simple any more since multiple
> LUN's perf has to be considered.
> 
> [1] https://lore.kernel.org/linux-block/20231018180056.2151711-1-bvanassche@acm.org/

Hi Ming,

Submitting I/O to a WLUN is only one example of a use case that
activates the fair sharing algorithm for UFS devices. Another use
case is simultaneous activity for multiple data LUNs. Conventional
UFS devices typically have four data LUNs and zoned UFS devices
typically have five data LUNs. From an Android device with a zoned UFS
device:

$ adb shell ls /sys/class/scsi_device
0:0:0:0
0:0:0:1
0:0:0:2
0:0:0:3
0:0:0:4
0:0:0:49456
0:0:0:49476
0:0:0:49488

The first five are data logical units. The last three are WLUNs.

For a block size of 4 KiB, I see 144 K IOPS for queue depth 31 and
107 K IOPS for queue depth 15 (queue depth is reduced from 31 to 15
if I/O is being submitted to two LUNs simultaneously). In other words,
disabling fair sharing results in up to 35% higher IOPS for small reads
and in case two logical units are active simultaneously. I think that's
a very significant performance difference.

Thanks,

Bart.
