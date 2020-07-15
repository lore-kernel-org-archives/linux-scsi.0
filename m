Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59259C433E8
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 20:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F45D2067D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 20:26:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="PpmzzilW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgGOU0v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 16:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgGOU0u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 16:26:50 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25479C08C5DD
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 13:26:50 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f23so3653737iof.6
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 13:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ef4z+9Yicabx/PBiZK3UH32DMjpUIF0+c5gTonOKaqA=;
        b=PpmzzilWUzM1i/qTP1Ch+MKMpdOU0msPV2HQZbI56F4OnSxOQ8SwWWVRNy6yrunVFH
         /w24G6AhWABCKBxq6W9DTrAwMGwhOuy74V6lF49lC3Dn3xWDMQqxDo1EWGsZ5dGjALMH
         eKhOy4CqgkZMRcuq/fqcecn9cyJ7H+Yv1MO8xjTUKm4TuhrfEkgXklAPRnIuQcUzN8xr
         vKSGMpt1eM60SB5Fe5mTpyKY675HJSLlKGPjEdl6bOa6o0Fpqvzrih5jCMxo5TfUO56l
         5MIg7m2BAdA0m8B3lbtrPoqhWKvHW7RheAaBBo/OMNlQqwmamVkGPYNgmo7HwR9BQ84h
         kPBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ef4z+9Yicabx/PBiZK3UH32DMjpUIF0+c5gTonOKaqA=;
        b=q74dIeI0UbzDMDxUu4lWc3uVPN6ZaydttNL1PLtQFi1bVOrxm8y6mQ0XVmomkB19vF
         TwgAU92WbtXLQfp2VUcJePwLA31pa5ou6GdBOsQG9dPTs3fra6fUpwrlgA7xeNt14rYJ
         lV51MbefjSKxIkf3jOmYvtdQw8qs//OLM7I0f9EoThA0DabvGmoa2Vq1/HlIrP47uHiY
         iZnG7aGcREC8TwVzlaJuyZXllrQ+t3p2GVokVTyFgOPZqDmG9pQB2B0o7vncuYJBh/YT
         BWa5E9s48G+A04auwAa7eDkVnTMQaztihCkX2G5k2BO1oizODhMByuPPvSufC3HMpChP
         /G8Q==
X-Gm-Message-State: AOAM5326fsCq6I+HqX1RZZQSisx0fIU1VtiXxogICUsTPjVdePH1s7Yb
        ga8PAqIaUyhqV+R40t1b8P4iYqyNDPbNkw==
X-Google-Smtp-Source: ABdhPJxIVAK2QRW9sFfypKnRyRWe+EJVbCx66CK31VkDVrrWNAVS7DR5AIM8zVPWgrqC3n6xFAXg0A==
X-Received: by 2002:a6b:640f:: with SMTP id t15mr1044364iog.175.1594844809116;
        Wed, 15 Jul 2020 13:26:49 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a11sm1736327iow.26.2020.07.15.13.26.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 13:26:48 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] Export max open zones and max active zones to
 sysfs
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
References: <20200714211824.759224-1-niklas.cassel@wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <58eac7f6-ab09-7f96-eb02-a19e8153e89a@kernel.dk>
Date:   Wed, 15 Jul 2020 14:26:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200714211824.759224-1-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/20 3:18 PM, Niklas Cassel wrote:
> Export max open zones and max active zones to sysfs.
> 
> This patch series in based on Jens's linux-block/for-next branch.
> 
> All zoned block devices in the kernel utilize the "zoned block device
> support" (CONFIG_BLK_DEV_ZONED).
> 
> The Zoned Namespace Command Set Specification defines two different
> resource limits: Max Open Resources and Max Active Resources.
> 
> The ZAC and ZBC standards define a MAXIMUM NUMBER OF OPEN SEQUENTIAL WRITE
> REQUIRED ZONES field.
> 
> 
> Since the ZNS Max Open Resources field has the same purpose as the ZAC/ZBC
> field, (the ZNS field is 0's based, the ZAC/ZBC field isn't), create a
> common "max_open_zones" definition in the sysfs documentation, and export
> both the ZNS field and the ZAC/ZBC field according to this new common
> definition.
> 
> The ZNS Max Active Resources field does not have an equivalent field in
> ZAC/ZBC, however, since both ZAC/ZBC and ZNS utilize the "zoned block
> device support" in the kernel, create a "max_active_zones" definition in
> the sysfs documentation, similar to "max_open_zones", and export it
> according to this new definition. For ZAC/ZBC devices, this field will be
> exported as 0, meaning "no limit".

Applied, thanks.

-- 
Jens Axboe

