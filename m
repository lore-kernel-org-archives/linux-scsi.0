Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C62DC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 14:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 176B120771
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 14:07:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="WPdAVatL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgFSOHZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 10:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbgFSOHY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 10:07:24 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3164CC06174E
        for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2020 07:07:24 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id x25so7697713edr.8
        for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2020 07:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=xO11uuE/crojqzil+07a11Y5rKMfgKyGRC1AgXfnHmo=;
        b=WPdAVatLDzXWRx7+VQ9sF4ds+ALEvWcp0ALEv8+z6brIJz8UxhtivVJUCbZ9PkbSfX
         +j4VghLBY9oMrIowCXqzGGNhQOXzimyprOIj6CJJLemeJo+qgGhTauKp2fntprzhLs/h
         HaYbthV3XzdPKVQFrifBlVa28MAPD71O6o6srtZj1jRYmE7jI0SWlvv6jXRjiX/k93UP
         lI6yPpRtoAmgKSubmgO64UA7toHegH3El/uje4wBrnOacU5pb700zD2yh0mttJvHottY
         OkK+7Qlgzkb6gCkv3TZhmdnxGM7oF48Tq/U/2qDITp+HZtDCacwgDNZ1w34pNEfBlhvZ
         Xc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xO11uuE/crojqzil+07a11Y5rKMfgKyGRC1AgXfnHmo=;
        b=S5VezdFin8VWtqkAgDD3qFZZwzYrF2ZLxJKHt8/Q0+xI24EZuJALVtj5zJ1qM+XwbE
         PcrrD/SSDG1+flZorghPrn+g99hK6ary7d8zUhL/ujNVxWXZoy1RyyM30ORWaaoKHQSb
         5YSsucnPBrqB0UIvA0UU7ESMfc8RBO1mf8rZGQtBdv1QPABYKZ8SQjjGWsv9wEIYC0dl
         mxgdB9IIQAM1Qzg1g4uV5hCMGwnaVtF2TrJOSt1m2+/EeNW8RSL8p+F+VG91D2+nEN2D
         ITsfvz97aLsq52HyS5DVhhBx/CoRRrE0a4tmL9D24dSiDubU0mhcNPCBuy0bUTEH1CF8
         0h8g==
X-Gm-Message-State: AOAM530Bg8lLNASKpN9aUQEUC6PYEaImwSEoDCF/uUdXM4Pvw7zdzJ/i
        stfmDW1y/jSelmvkLdQTjeXuaw==
X-Google-Smtp-Source: ABdhPJymdiZiBMnEivt76qZDiljKku8JW7lBqL6vcuTQoLccLFypJBasN0TWfHsz07UcESSces/amw==
X-Received: by 2002:a50:a687:: with SMTP id e7mr3358013edc.62.1592575642886;
        Fri, 19 Jun 2020 07:07:22 -0700 (PDT)
Received: from ?IPv6:2001:16b8:48f6:5100:b0c1:1cd:44ba:a39f? ([2001:16b8:48f6:5100:b0c1:1cd:44ba:a39f])
        by smtp.gmail.com with ESMTPSA id h1sm4649277edz.88.2020.06.19.07.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 07:07:22 -0700 (PDT)
Subject: Re: [bug report][megaraid_sas] On 3108 RADI1 read performance is
 improved when nr_requests is decreased
To:     Hou Tao <houtao1@huawei.com>, linux-scsi@vger.kernel.org,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc:     Hannes Reinecke <hare@suse.de>, martin.petersen@oracle.com,
        linux-block@vger.kernel.org
References: <b87390d4-9981-41c2-7d5b-344ee3cf602a@huawei.com>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <1e07c300-fa9c-fd6d-05d7-7d68fe678f15@cloud.ionos.com>
Date:   Fri, 19 Jun 2020 16:07:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <b87390d4-9981-41c2-7d5b-344ee3cf602a@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 6/19/20 10:15 AM, Hou Tao wrote:
> Hi,
>
> Recently we encountered a read performance problem on LSI SAS-3 3108 RAID controller.
> The read performance is much better when nr_requests is set as 192 compared with 256,
> but after disabling the NoRA (No Readahead) feature of the hardware RAID1, there will
> be no difference between nr_requests=192 and nr_requests=256.

Do you know if RAID10 mode could be affected or not? And how about MegaRAID
2208 controller? Thanks.

> One scene is the direct read of one ext4 file with 8GB size. The ext4 fs is stacked
> on hardware RAID1 with 3.7TB size, and the RAID1 is composed of two HDDs.
> The queue_depth of RAID1 device is set as 256 by driver.
>
> fio --direct=1 --ioengine=libaio --group_reporting=1 --runtime=30 --bs=4k \
> 	--name=1 --numjobs=1 --iodepth=512 --filesize=8G --directory=/tmp/sdd
>
> one ext4 file:
> IOPS   | nr_requests=128 | nr_requests=192 | nr_requests=256 |
>   RA    | 51k             | 51k             | 48k             |
>   NoRA  | 47k             | 46k             | 47k             |
>
> Another scene is the direct read of two ext4 files with 4GB size.
>
> fio --direct=1 --ioengine=libaio --group_reporting=1 --runtime=30 --bs=4k \
> 	--numjobs=2 --iodepth=256 --filesize=4G --directory=/tmp/sdd
>
> two ext4 files:
> IOPS   | nr_requests=128 | nr_requests=192 | nr_requests=256 |
>   RA    | 95.7k           | 94.5k           | 30.7k           |
>   NoRA  | 27.3k           | 27.1k           | 27.2k           |
>
> These results show RA feature can boost the read performance, but when nr_requests
> is increased, performance is degraded.
>
> However when using a JBOD setup on HDD which has the same model as the HDD
> in RAID1 setup, there is no such problem.
>
> one ext4 file:
> IOPS   | nr_requests=128 | nr_requests=192 | nr_requests=256 |
>         | 50k             | 50.4k           | 50.5            |
>
> two ext4 files:
> IOPS   | nr_requests=128 | nr_requests=192 | nr_requests=256 |
>         | 46.5k           | 46.3k           | 46.0k           |
>
> So is the performance degradation a known issue of the RAID1 RA feature,
> or is there other explanation for it ?
>
> Regards,
> Tao
>
> ---
> Other details of test environment:
>
> (1) linux kernel version
> 5.6.15
>
> (2) block setup
>
> device/queue_depth:256
> queue/scheduler:[mq-deadline] kyber bfq none
>
> (3) driver version

[...]

> (4) megaraid firmware version
>
> Product Name = SAS3108
> FW Package Build = 24.16.0-0106
> BIOS Version = 6.32.02.0_4.17.08.00_0x06150500
> FW Version = 4.660.00-8102
> Driver Name = megaraid_sas
> Driver Version = 07.713.01.00-rc1
> Current Personality = RAID-Mode

Not sure the behavior could be different with the latest firmware 
version 24.21.0-0126.

Thanks,
Guoqing
