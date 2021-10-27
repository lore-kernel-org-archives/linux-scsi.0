Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFADC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 03:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DD0860EC0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 03:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbhJ0DFe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 23:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237816AbhJ0DFd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 23:05:33 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AD1C061745
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 20:03:09 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id b188so1872912iof.8
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 20:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=omKeu29+ryItY7DLSJ7AbPWyTJqOXcPm2RufUXYz74E=;
        b=ZgegrBRE+ea0GGZnA8IfRhTfh19ZufmPqkwRongRQWVR6ezc1XQXsJXoXgkoaq0vjD
         UJpV/7XHAe1VQi6UmvV9LgixPrfNcOMmZD3hqFg2pIw+n3CydCZqINCkd3TGA3eiTyLg
         a0vC7HrxarDpxuwGv9J0DkisQ7/wnqVlqE00ppiGgno+A4DtFwxKJJILu/6yRrbqPhkD
         ZUgM61HCrXvsViTtLYCG9FlimfJKn8BVOnNzLKujU+ILCpRnlLygdvRM0zhzq7Hw+joq
         KOGCSPdKpMAtvyQ6VCdVmaE/XzoAud35Pf/jq4nMkzDzuOHPkqNhbuuEu93MTFA+ksFr
         9QfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=omKeu29+ryItY7DLSJ7AbPWyTJqOXcPm2RufUXYz74E=;
        b=i5Cp8fcFUnP+JG351oijDc7yl1ZJw077KiBM8JDh6w80BiYYtuR9NPlezPnTBrN4yI
         XlVOP6qQr0rRu3gYe94JwLNo4OvxE3wtlhMIuASFpSIrEtDEgTRh0dCuPkB5XWgKAsvc
         17iBZpmvpWJmoJOX/k7Sn92pjI0DHpvg3JGFUoNWj0PeW7zfSy9bdjZRAhrXuTyhF6NR
         bKbqaAFlOH9QFSvHRqm4P2dwAJY0yfgWyRmEFdYlk3isWzl8rXK/IsjTJRuzuNKmSwmU
         awiWrgxvU9vG6VoR6tEwWDe6Q2vG77J6SFnwzdwcqCkfUCHC3jXh/lJkV5MIytcQYstL
         zMoA==
X-Gm-Message-State: AOAM53121ZekVBsmWqaV2I03wiMTEL94q6hUxxUUi7CHnOm+FFXXVDvP
        VQQRvtdZ1+oRDIJza6gGqk7/YqyztY57Cg==
X-Google-Smtp-Source: ABdhPJzUEdzdye8317F6uiPURMPbYz4MGyb1FFCANKFMSNj8CoPQuFy2Ranf3nqsHx5xdVm06eAANQ==
X-Received: by 2002:a6b:c94b:: with SMTP id z72mr17404466iof.101.1635303787203;
        Tue, 26 Oct 2021 20:03:07 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id i15sm11770000ilu.24.2021.10.26.20.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 20:03:06 -0700 (PDT)
Subject: Re: [PATCH v9 0/5] Initial support for multi-actuator HDDs
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20211027022223.183838-1-damien.lemoal@wdc.com>
 <cea34b2a-6835-d090-4f0c-3bf456a6ed00@kernel.dk>
 <CH2PR04MB70782D5877F24ECC9A0F644AE7859@CH2PR04MB7078.namprd04.prod.outlook.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <64a81be7-ef62-8f8c-bfdc-759e04530366@kernel.dk>
Date:   Tue, 26 Oct 2021 21:03:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CH2PR04MB70782D5877F24ECC9A0F644AE7859@CH2PR04MB7078.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/21 8:49 PM, Damien Le Moal wrote:
> On 2021/10/27 11:38, Jens Axboe wrote:
>> On 10/26/21 8:22 PM, Damien Le Moal wrote:
>>> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>>
>>> Single LUN multi-actuator hard-disks are cappable to seek and execute
>>> multiple commands in parallel. This capability is exposed to the host
>>> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).
>>> Each positioning range describes the contiguous set of LBAs that an
>>> actuator serves.
>>>
>>> This series adds support to the scsi disk driver to retreive this
>>> information and advertize it to user space through sysfs. libata is
>>> also modified to handle ATA drives.
>>>
>>> The first patch adds the block layer plumbing to expose concurrent
>>> sector ranges of the device through sysfs as a sub-directory of the
>>> device sysfs queue directory. Patch 2 and 3 add support to sd and
>>> libata. Finally patch 4 documents the sysfs queue attributed changes.
>>> Patch 5 fixes a typo in the document file (strictly speaking, not
>>> related to this series).
>>>
>>> This series does not attempt in any way to optimize accesses to
>>> multi-actuator devices (e.g. block IO schedulers or filesystems). This
>>> initial support only exposes the independent access ranges information
>>> to user space through sysfs.
>>
>> I've applied 1/9 for now, as that clearly belongs in the block tree.
>> Might be the cleanest if SCSI does a post tree that depends on
>> for-5.16/block. Or I can apply it all as they are reviewed. Let me
>> know.
> 
> Forgot: They are all reviewed, including Martin who sent a Reviewed-by for the
> series, but not an Acked-by for patch 2. As for libata patch 3, obviously, this
> is Acked-by me.

Queued up 2-5 in the for-5.16/scsi-ma branch.

-- 
Jens Axboe

