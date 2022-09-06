Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B7BC6FA86
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 18:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiIFSE5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 14:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiIFSEx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 14:04:53 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184141C133
        for <linux-scsi@vger.kernel.org>; Tue,  6 Sep 2022 11:04:44 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id o15-20020a17090a3d4f00b002004ed4d77eso6706365pjf.5
        for <linux-scsi@vger.kernel.org>; Tue, 06 Sep 2022 11:04:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=E4qNtguvErLAMr+I83DmTlltMWurZcfC1pDZE+j1HL0=;
        b=SvZr6hcaITFM06f3qxOwU4Gr80zXE6yJLppYm5QCom5vZIz0H57kM+sQ9jhKhANTOF
         10svWR2UOSmK9TiRCTeOyWrU/8kKaMxfJoSV16O+QpcWDS/L/XQF8jIvTGlVaPqfpFtt
         0K030C4F9PgTudk6Rbzjj2FO7eT33KfMhS52TGjIudLcc2uUUNAd4N30sMbc68+OmPQ8
         YnSimyQenzkAQSOivSrPw8ifaxCR6Xw5YdVj8cQ5PoLssVHsPtbuKhNCMntmpgXUNfz0
         I/eAtXh+AgXw2kFkSjPggeVyrU/Txzkw4gSirI9e0zUxZB0BrXEuIcRT6YZSGPE/Pf60
         rU7A==
X-Gm-Message-State: ACgBeo17tDcTDzvHI9JXqxG/9Of3arjvhaKyMiDtjjQDSu2cA1SeKxD+
        tzxNvxijbsT7czSMSVTUa+U=
X-Google-Smtp-Source: AA6agR64HfjNjFOdbfXVG3OCMoS8dKA+n1DziOFfkpMoSzMugyWofP3G54QROu1LdwQH9MjaxM28/w==
X-Received: by 2002:a17:903:11c7:b0:171:2818:4cd7 with SMTP id q7-20020a17090311c700b0017128184cd7mr54210980plh.136.1662487483421;
        Tue, 06 Sep 2022 11:04:43 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:4e4a:abd5:5969:d00e? ([2620:15c:211:201:4e4a:abd5:5969:d00e])
        by smtp.gmail.com with ESMTPSA id d10-20020a170902ceca00b0015e8d4eb1d7sm10359265plg.33.2022.09.06.11.04.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 11:04:42 -0700 (PDT)
Message-ID: <5a293aef-80da-1130-b11d-d556828a6bf8@acm.org>
Date:   Tue, 6 Sep 2022 11:04:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3] scsi: ufs: Increase the maximum data buffer size
Content-Language: en-US
To:     Bean Huo <huobean@gmail.com>,
        "yohan.joung@sk.com" <yohan.joung@sk.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
References: <20220726225232.1362251-1-bvanassche@acm.org>
 <55fce3baaabf4e33aeaccbe5b4e1f145@sk.com>
 <6263c2a5-e7b6-c9e5-69e8-b6d93604d82d@acm.org>
 <ea43b861ac1c7b87a11934d2e5606fa37b2ae7fe.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ea43b861ac1c7b87a11934d2e5606fa37b2ae7fe.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/2/22 07:52, Bean Huo wrote:
> On Wed, 2022-08-03 at 09:23 -0700, Bart Van Assche wrote:
>> On 8/2/22 16:40, yohan.joung@sk.com wrote:
>>> Is it possible by adding only max_sector to increase the data
>>> buffer size?
>>
>> Yes.
>>
>>> I think the data buffer will split to 512 KiB, because the sg_table
>>> size is SG_ALL
>>
>> I don't think so. With this patch applied, the limits supported by
>> the
>> UFS driver are as follows:
>>
>>          .sg_tablesize           = SG_ALL,                   /* 128 */
>>          .max_segment_size       = PRDT_DATA_BYTE_COUNT_MAX, /* 256
>> KiB*/
>>          .max_sectors            = (1 << 20) / SECTOR_SIZE,  /* 1 MiB
>> */
>>
>> So the maximum data buffer size is min(max_sectors * 512,
>> sg_tablesize *
>> max_segment_size) = min(1 MiB, 128 * 256 KiB) = 1 MiB. On a system
>> with
>> 4 KiB pages, the data buffer size will be 128 * 4 KiB = 512 MiB if
>> none
>> of the pages involved in the I/O are contiguous.
>
> This change just increases the shost->max_sectors limit from 501KB to
> 1Mb, but the final value will be overridden by the optimal transfer
> length defined in the VPD, right?

Hi Bean,

It seems to me that the block layer only uses the optimal transfer size 
(io_opt) to determine how much data to read ahead during sequential 
reads? See also disk_update_readahead().

The above patch increases max_sectors but is not sufficient to increase 
the maximum transfer size: SG_ALL (128) * 4 KiB (dma_boundary + 1) = 512 
KiB. To increase the maximum transfer size, the dma_boundary parameter 
would have to be modified. I have not yet submitted a patch that 
modifies that parameter since on my test setup (Exynos host controller) 
the current value is the largest value supported.

Thanks,

Bart.
