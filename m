Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E76C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 16:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiGRQqd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 12:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiGRQqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 12:46:31 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B791F33
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 09:46:30 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id o31-20020a17090a0a2200b001ef7bd037bbso13253803pjo.0
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 09:46:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=IwJe4HbwVBMt1h3hnr1ncGrmWgDhSFdwziS0xEsHDk0=;
        b=l6/lALR/6LH4ilBZg3Wze4zHXzNhEOYmFzQGcAHzuQE9uP8LHbWkB5AD6JNCLwMfbI
         EpSke01Z+IAqnLkB4LWmXkpkXnOa9mN33OhDFLxzbTp+SPPNcLn2dQgea3SyYtdog7yT
         0BXiPxzGLieaaDig1+HOB7koibwIsJaR6t7sLA6lp6DHdlW5GydRpw3TfFXh/FKHNSe6
         xe9IX40rbmOZAeQC1TlB6IdGU1eQlPnKOOHUFV4g/n3rgT4xdWptefH8SS94/ko0EDfc
         zOtUmbM49XoTbLpfw+wwxiTk2p61MlP982zhJkD2pSyWTarVc8eTqBQy16VJMQdSRE6O
         2omg==
X-Gm-Message-State: AJIora85SHKaFR64htNV2QIUxXrMmFupzz3IYT7vzk9NVWZ7xcsciwGo
        ZzsjZEtGU5aivECsMSGd2lc=
X-Google-Smtp-Source: AGRyM1sqAwFZfoSVdzSzIVE52re+9ewcYZojNiacQbyh+7poOj8iQ2FUJRsUFZhJhRMILOLAoONabw==
X-Received: by 2002:a17:902:c94b:b0:16c:7289:b402 with SMTP id i11-20020a170902c94b00b0016c7289b402mr28840679pla.66.1658162789841;
        Mon, 18 Jul 2022 09:46:29 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id y10-20020aa7942a000000b0052890d61628sm9595067pfo.60.2022.07.18.09.46.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 09:46:28 -0700 (PDT)
Message-ID: <4c4132ce-ea97-82bb-1e0d-5887bd3e18d5@acm.org>
Date:   Mon, 18 Jul 2022 09:46:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/3] scsi: sd_zbc: Fix handling of RC BASIS
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-4-bvanassche@acm.org>
 <90cb95f0-7d8b-af10-9480-76a2163993e2@opensource.wdc.com>
 <95f2f1d5-3e32-bb6f-b8e4-df0c232ed6eb@opensource.wdc.com>
 <7f58e047-8fa8-7300-3062-ab1d22495b2d@acm.org>
 <6d228185-1ce3-b0c8-71b8-badfe78505b7@opensource.wdc.com>
 <01cac097-1420-2142-c701-2542bf437656@acm.org>
 <11a23d81-b949-15de-11d3-426d2fd45db9@opensource.wdc.com>
 <03268468-f884-fa94-91f9-40ef4c3e57ca@acm.org>
In-Reply-To: <03268468-f884-fa94-91f9-40ef4c3e57ca@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/18/22 06:59, Bart Van Assche wrote:
> On 7/18/22 03:38, Damien Le Moal wrote:
>> Even the above code (removing the "sdkp->rc_basis == 0" test) is
>> borderline in my opinion. The code with the test is per specs, so 
>> correct.
> 
> I do not agree that the current code is compliant with the ZBC 
> specification. My interpretation of the ZBC specification is that the RC 
> BASIS field influences the meaning of the RETURNED LOGICAL BLOCK ADDRESS 
> field in the READ CAPACITY response only. The max_lba variable in 
> sd_zbc_check_capacity() represents the MAXIMUM LBA field from the REPORT 
> ZONES response. All I found in ZBC-2 about that field is the following: 
> "The MAXIMUM LBA field contains the LBA of the last logical block on the 
> logical unit." I haven't found any reference to RC BASIS in the 
> description of the REPORT ZONES command - neither in ZBC-1 nor in ZBC-2.

Hi Damien,

I want to take the above back. After having taken a closer look at the 
READ CAPACITY implementation I think the current implementation of 
sd_zbc_check_capacity() is fine.

Thanks,

Bart.
