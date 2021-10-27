Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C647C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33E0A60F90
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhJ0AsA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 20:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234724AbhJ0AsA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 20:48:00 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB89C061767
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 17:45:35 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id i14so1506959ioa.13
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 17:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=eZf9272suVHnJNK0V9D7kNi2z8Iuaq6OZhVMhPvpXuE=;
        b=VgECXHUlgWnAxNomla/5XdxozNqpIv1qF5iCq1uAfJ+t3YJiBvTr4NMkmE0OYXCLRx
         MnqYpdWFZQvKLdE/ECvzvthRPF6hWjMWokcR/e71rh9IN/IP6cF2djf+tIDtjeTtKe1e
         T+ULBToPhZXL7GKqC1uyrPkJk2tPpd/5kf+1TrfigU5I/cW/w+CvhOHu6GAHs3jD3ooN
         eWu8OoYqLvHuRY/2U0jgTCUoUubPJozHi43imLDNyv7IJlsTMQt0f5K7wNHEkzU9rSk6
         PU0kD2KjtkFYe5bspEjPEFvM2Dx1Kc5/n+rZjoELj5ZND3kVtIaqrN4k7vR58wvQVHSj
         /Z8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eZf9272suVHnJNK0V9D7kNi2z8Iuaq6OZhVMhPvpXuE=;
        b=kORIGUP9oeI1/HmEXy9svyqWoYbVaXBOw9je068HPGxYtO1kok5n+N0XL3tUrIcqrG
         CL94516YY0oaBIf+Z/BpRgcp3zQSZ7uvvGIyOMmxJ74Ig7gWhmPtz9GO/H23gETThAn1
         lDAv90EQUH6ZALcIBz1+XXMr6gb+tQw9XpY5a3ATXPX9I/ch4etfFMdjaGxFKJX590xB
         XNAq/esKCEPTJJaGX/get1YlkSCMRRpZ1zP/JNdtmDCRQathIf6GgL5j35t1xzWYYf2X
         oYqYJgZq9AjEc+ZLqJDA+B0bUntCjDbtcdvmjL5tZ6jokryyj/9GUXsgAghwJhhzIirB
         4Icw==
X-Gm-Message-State: AOAM533d9z2oaIjx8NYo9z3MFmWit+mcrWVdtmEL2kV7X8EZ2RZrNo64
        PmbrdifnaQNUe+84hGFSi5ZukKS5kU5kXg==
X-Google-Smtp-Source: ABdhPJzBrKDhLXW3CV8ZRPim4Opbo6gaPpJIwlOA0ZpFu1c0YbaGzvHY0l6PGdTawaeiUzQYYIpFbA==
X-Received: by 2002:a5e:890b:: with SMTP id k11mr3933296ioj.71.1635295534940;
        Tue, 26 Oct 2021 17:45:34 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id i8sm12391376ilm.10.2021.10.26.17.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 17:45:34 -0700 (PDT)
Subject: Re: [PATCH v8 0/5] Initial support for multi-actuator HDDs
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20210909023545.1101672-1-damien.lemoal@wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <173fe7e1-7e46-1827-5521-3e2648b85fcd@kernel.dk>
Date:   Tue, 26 Oct 2021 18:45:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210909023545.1101672-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/8/21 8:35 PM, Damien Le Moal wrote:
> Single LUN multi-actuator hard-disks are cappable to seek and execute
> multiple commands in parallel. This capability is exposed to the host
> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).
> Each positioning range describes the contiguous set of LBAs that an
> actuator serves.
> 
> This series adds support to the scsi disk driver to retreive this
> information and advertize it to user space through sysfs. libata is
> also modified to handle ATA drives.
> 
> The first patch adds the block layer plumbing to expose concurrent
> sector ranges of the device through sysfs as a sub-directory of the
> device sysfs queue directory. Patch 2 and 3 add support to sd and
> libata. Finally patch 4 documents the sysfs queue attributed changes.
> Patch 5 fixes a typo in the document file (strictly speaking, not
> related to this series).
> 
> This series does not attempt in any way to optimize accesses to
> multi-actuator devices (e.g. block IO schedulers or filesystems). This
> initial support only exposes the independent access ranges information
> to user space through sysfs.

Let's get this queued up for 5.16. I forgot what we agreed upon, can go
either block or SCSI. We likely have a bunch more block changes this
round than usual, and hence a higher risk of conflict, so from that
perspective alone I think the block layer would be easier.

In any case, Damien, it needs a respin as it doesn't apply against
my for-5.16/block at this point.

-- 
Jens Axboe

