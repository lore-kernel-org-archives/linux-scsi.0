Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97006C00144
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jul 2022 22:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiGZWh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 18:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGZWh0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 18:37:26 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032AF1573D
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 15:37:24 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id c3so14455735pfb.13
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 15:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9w6OPzIUFLzqavb1Krx0m6JVeaPAqvjg3ynqGHXZx/0=;
        b=OmCWIznDm9lynDLNLrs9YL2N+cdyzfBJPaz1Dj0Ok212cie7iu3RCuwqrZeyI2Huh/
         0JhFl7FNzxW2Rc/KNzs/+aficp0XF3uOaVFf1AhX3MY+4bdt8rHj/f/gXt5IKKDpZfal
         pLqpj8PQYenoLW3PW/Z56VQkScPpO6KS1Oe0ZU+S1SQzgPLDF1KTIgQw9igbJerCilVX
         EF7C1LQJF5+L014EH0mqMgfcFYXuIYQjpqQ1ls7p8/9fCRBrpLxyw8nGDmjDDig+s+M2
         gYfEqvgRaWdrY2c6LtfHl+n7xbgACn8fJQi+G1hQT6Z/xydDdfYCry9siU5KSbinB/Bt
         FI9Q==
X-Gm-Message-State: AJIora/H5gwkH/yZlTJEWIyo8Xd7IjIO/X4ZkClwmDXEvXuNlptG+uoT
        Xp/sB85voNMkmjkU68+9yuc=
X-Google-Smtp-Source: AGRyM1tvZSs2nMjj/jN3Y4b6cVytBY3mqBRZgRYtil8DbT6n5bAF17PCChZPzDrzNxFN+KqmiBBbpA==
X-Received: by 2002:a62:15cd:0:b0:528:bf80:37c1 with SMTP id 196-20020a6215cd000000b00528bf8037c1mr19359570pfv.22.1658875043883;
        Tue, 26 Jul 2022 15:37:23 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:34f4:7aa8:57:d456? ([2620:15c:211:201:34f4:7aa8:57:d456])
        by smtp.gmail.com with ESMTPSA id u10-20020a17090a6a8a00b001eafa265869sm87073pjj.56.2022.07.26.15.37.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 15:37:22 -0700 (PDT)
Message-ID: <10899fac-2a28-776f-40cb-d9f4973af081@acm.org>
Date:   Tue, 26 Jul 2022 15:37:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] scsi: ufs: Increase the maximum data buffer size
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
References: <20220725173528.849643-1-bvanassche@acm.org>
 <DM6PR04MB6575FF4ED352199899172E23FC949@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575FF4ED352199899172E23FC949@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/26/22 05:54, Avri Altman wrote:
> Bart hi,
> 
>> Measurements have shown that for some UFS devices the maximum sequential
>> I/O throughput is achieved with a transfer size above 512 KiB. Hence
>> increase the maximum size of the data buffer associated with a single
>> request from SCSI_DEFAULT_MAX_SECTORS (1024) * 512 bytes = 512 KiB into
>> 255 MiB.
>>
>> Notes:
>> - The maximum data buffer size supported by the UFSHCI specification
>>    is 65535 * 256 KiB or about 16 GiB.
>> - The maximum data buffer size for READ(10) commands is 65535 logical
>>    blocks. To transfer more than 65535 * 4096 bytes = 255 MiB with a
>>    single SCSI command, the READ(16) command is required. Support for
>>    READ(16) is optional in the UFS 3.1 and UFS 4.0 standards.
> I still have concerns of a negative impact of a too-large-max-sectors.
> 
> I replicate your fio measurements using galaxy S22 - one of the most advanced production platform currently in the market.
> See the results below: fio bs vs max-sectors.  data is the read BW[MiB/s].
> Given that:
> a) there isn't that much of a difference among the various max-sectors
> b) max-sectors is configurable via max_sectors_kb sysfs entry, and
> c) going from the benchmark world into the real world, a large write (255MiB),
>      interleaved by many small reads (4k), may cause high latency, up to even a timeout (!?)
> 
> I would leave the max-sectors threshold as it is, or use the moderate 1MB limit.
> Unless you can back the  "Measurements have shown" statement with a more concrete data.
> 
> Thanks,
> Avri
> 
> 
> 	|	1MB		|	2MB		|	128MB		|	255MB
> --------------------------------------------------------------------------------------------------------------------
> 4KiB	|	14.7		|	13.3		|	15.7		|	19.5
> 8KiB	|	26.7		|	27.4		|	25.8		|	30.0
> 16KiB	|	44		|	53.2		|	46.3		|	61.2
> 64KiB	|	179		|	207		|	171		|	184
> 32KiB	|	100		|	120		|	105		|	119
> 128KiB	|	275		|	322		|	271		|	256
> 256KiB	|	440		|	452		|	417		|	378
> 512KiB	|	535		|	525		|	483		|	471
> 1MiB	|	592		|	584		|	531		|	408
> 2MiB	|	349		|	361		|	375		|	297
> 4MiB	|	502		|	492		|	515		|	441
> 8MiB	|	645		|	663		|	682		|	650
> 16MiB	|	752		|	749		|	752		|	762
> 32MiB	|	817		|	790		|	822		|	791
> 64MiB	|	1710		|	1703		|	1700		|	1692
> 128MiB	|	1733		|	1730		|	1724		|	1712
> 256MiB	|	1752		|	1748		|	1738		|	1732

Hi Avri,

Thank you for having run these measurements. Regarding (b): the 
max_sectors_kb sysfs entry can be used to reduce the value set by a SCSI 
LLD but not to increase that value. From block/blk-sysfs.c:

	if (max_sectors_kb > max_hw_sectors_kb)
		return -EINVAL;

I will post a new version of this patch with the max_sectors limit set 
to 1 MiB.

Thanks,

Bart.
