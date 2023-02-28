Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CAEC64ED6
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Feb 2023 08:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjB1IGM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Feb 2023 03:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjB1IFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2023 03:05:44 -0500
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F1320D38;
        Tue, 28 Feb 2023 00:05:25 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id i34so36258842eda.7;
        Tue, 28 Feb 2023 00:05:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677571523;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0guNErct7/1yTAJGBCGWn62sdzg7Fin9ZNo8MlFXzNk=;
        b=bFvknP5EQlQP711Fdtp1/nZa++wU6JlZk9YdPH9GNcbQ5c5U2ZHl03rv/eHOP4yMGY
         YJg8aGxYJMmx0xbTpkZDzXGv/9b+39qUWeS/McQMrxFcZ27RCptiB3+K9SxbzNug/ULg
         7EH/0GurcCQtdiRT5rOKDrklmzH16yorcmtKc88u64bB6Uj2+Fq5Rf+4KYh4H/5dpXe5
         EXWwgfX1qaaLx+mdyOWg1spx9++D+qT+UCWZhuQiZkS3+KlPJwDWNLUBm6c93IBh88lK
         Qylu69LZaj8fkelWxqPEPnA0GVXj0jLSo0k8vWWpgAvZ3FPODWZD9JgDLRBMYn/iBw2z
         YUdA==
X-Gm-Message-State: AO0yUKX7vlQda/xfq3Dt/jICFkg9VkODvAPfJoSdlyF63W7Y7b1wPioy
        kMM9Vm5K7KGHLwAw6yF95iU=
X-Google-Smtp-Source: AK7set+c7o0xjmPWudHmmkUqfo5PvjF0F5NViP/fOHyF3G/zLvjuTOYbHp4mz1meRuScW5Q7gKs7UA==
X-Received: by 2002:a05:6402:268e:b0:4af:593c:c09b with SMTP id w14-20020a056402268e00b004af593cc09bmr2472874edd.0.1677571523749;
        Tue, 28 Feb 2023 00:05:23 -0800 (PST)
Received: from [10.100.102.14] (85-250-17-149.bb.netvision.net.il. [85.250.17.149])
        by smtp.gmail.com with ESMTPSA id d17-20020a056402401100b004aee4e2a56esm4016076eda.0.2023.02.28.00.05.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Feb 2023 00:05:23 -0800 (PST)
Message-ID: <bffe500a-24b9-eaa7-71f2-891be21c7ed5@grimberg.me>
Date:   Tue, 28 Feb 2023 10:05:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [LSF/MM/BPF BOF] Userspace command abouts
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>
References: <ad837a26-948a-c690-cd9e-4dfffb5f990d@grimberg.me>
 <57d8dff9-2fdb-8198-6cdc-7265797a704a@interlog.com>
 <23526cf9-d912-59a7-4742-6003d6ccfd45@grimberg.me>
 <Y/Yscr82hqdKl1Hw@kbusch-mbp.dhcp.thefacebook.com>
 <561afa67-04d0-c675-6bbb-048313da152b@grimberg.me>
 <73b4dd39-9ce8-9b55-8a1d-06865f3bde32@nvidia.com>
 <Y/lpmrwuehnsWmmR@kbusch-mbp.dhcp.thefacebook.com>
 <0fe59301-65e6-d8a9-033e-0243ad59c56b@opensource.wdc.com>
 <316431ed-1727-7e80-2090-84ac5b334f74@grimberg.me>
 <3ea301b1-c808-ce08-8ec8-3a631b385fb9@suse.de>
 <Y/zsE9i7012Ivwe1@kbusch-mbp.dhcp.thefacebook.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <Y/zsE9i7012Ivwe1@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>>> I'm not up to speed on how CDL is defined, but I'm unclear how CDL at
>>> the queue level would cause the host to open more queues?
> 
> Because each CDL class would need its own submission queue in that scheme. They
> can all share a single completion queue, so this scheme doesn't necassarily
> increase the number of interrupt vectors.

Ah, that is less desirable I think, Although we can already do
multiple queue maps, I think that the proliferation of queues is
harmful in the long run.

>>> Another question, does CDL have any relationship with NVMe "Time Limited
>>> Error Recovery"? where the host can set a feature for timeout and
>>> indicate if the controller should respect it per command?
>>>
>>> While this is not a full-blown every queue/command has its own timeout,
>>> it could address the original use-case given by Hannes. And it's already
>>> there.
>> I guess that is the NVMe version of CDLs; can you give me a reference for
>> it?
> 
> They're not the same. TLER starts timing after a command experiences a
> recoverable error, where CDL is an end-to-end timing for all commands.

Ah, ok. I didn't realize that TLER starts after an error.
