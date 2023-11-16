Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B2DC197A0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 21:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjKPVff (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 16:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjKPVfe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 16:35:34 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D77181;
        Thu, 16 Nov 2023 13:35:31 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-28396255b81so284611a91.0;
        Thu, 16 Nov 2023 13:35:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700170531; x=1700775331;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uSuZUwRMRsk/1gHZEzqEqVMjZ6S7+cbmHVcshPK0FHs=;
        b=ED4M8hqr+WywkOxxHX2yiuOlMdf3K+pEJmdPJhApIQZm5eWffZJEecD+YbiNorAO1f
         IjlSv2BGIiKkH8T8gPXFM5v/odA3KpYN+hUMAN7wY0r7czoRmDqsQEKiOETJ5udUO3T9
         Hl622d5tTAh0B7PrlmHKzsi4pGrVFTVmbIUsdRJCsTGF5CQuPUgO1Te0+4mj33HZQHIm
         U0nN/DDpdmZSXb7uEYNH2FGRbKvAlKmEzUjNZyBfbGdeefvI941bsmi0+zN/RvXX1HBu
         rhqMe5ifcksaSzYoJRnalB7Vea7xkZ3xbHIinumvRi7ByB5NEUW2GcbTwxiXCiOpC+XK
         5t0Q==
X-Gm-Message-State: AOJu0YxMrgLlg/3JdgYAB9fC2TxjCbssp1Ewb+yhEpKHPeuSY+k0zdB9
        NOvLHUxf4SsGU9bZ1JBsrIw=
X-Google-Smtp-Source: AGHT+IGT/50YJ/YnQ+R16M/lJgwHTKhXUb2jBpakdUfkmrbPBwvTpoMFQANUiokGMT5Zkq0+WR2LPA==
X-Received: by 2002:a17:90b:3841:b0:283:784:f8ed with SMTP id nl1-20020a17090b384100b002830784f8edmr15838184pjb.38.1700170530753;
        Thu, 16 Nov 2023 13:35:30 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:9b50:bd2b:ae57:7a6d? ([2620:0:1000:8411:9b50:bd2b:ae57:7a6d])
        by smtp.gmail.com with ESMTPSA id x11-20020a1709028ecb00b001cc51680695sm111521plo.259.2023.11.16.13.35.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Nov 2023 13:35:30 -0800 (PST)
Message-ID: <935a62fd-7fbe-47c0-ba94-26d81119f545@acm.org>
Date:   Thu, 16 Nov 2023 13:35:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] scsi: core: Support disabling fair tag sharing
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Ed Tsai <ed.tsai@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20231114180426.1184601-1-bvanassche@acm.org>
 <20231114180426.1184601-3-bvanassche@acm.org>
 <80dee412-2fda-6a23-0b62-08f87bd7e607@huaweicloud.com>
 <d706f265-f991-45c0-a551-34ecdee55f7c@acm.org>
 <d1e94a08-f28e-ddd9-5bda-7fee28b87f31@huaweicloud.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d1e94a08-f28e-ddd9-5bda-7fee28b87f31@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/23 17:08, Yu Kuai wrote:
> 在 2023/11/16 2:19, Bart Van Assche 写道:
>> On 11/14/23 23:24, Yu Kuai wrote:
>>> Can we also consider to disable fair tag sharing by default for the
>>> driver that total driver tags is less than a threshold?
>> I don't want to do this because such a change could disable fair tag
>> sharing for drivers that support both SSDs and hard disks being associated
>> with a single SCSI host.
> 
> Ok, then is this possible to add a sysfs entry to disable/enable fair
> tag sharing manually?

Hi Yu,

I will look into this.

Thanks,

Bart.

