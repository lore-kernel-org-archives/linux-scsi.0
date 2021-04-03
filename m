Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BA7C433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5294161262
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbhDCXAy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:00:54 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:45811 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbhDCXAy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:00:54 -0400
Received: by mail-pg1-f182.google.com with SMTP id d10so945298pgf.12
        for <linux-scsi@vger.kernel.org>; Sat, 03 Apr 2021 16:00:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UaUVuvYMtO0KwvkdswLYj2+uCruBczsTaZY+v26SpVg=;
        b=DhUvNavic1Izbje7DUz1Ql+DDkNO/mv7N8eY7plI8EcyPzQMS5UaB7MroYQ6nLJYIu
         UtFYc943heXykRJaaqozYu9cLCCDYNc6MdzXb+wpsftyOBRfgJOgbUYTrujPfh5kkufQ
         w22QabSIJ7MUeZC5kA241CT/foLxFfdSQkBaOFHBhs9eeaPXPa1WbXyD2NII4J3H8fOt
         48mDab0PUXdusatEZvxPHt2Fx5FxveCGsyHzWFBrImNOHqawc6OdfYXE/Ld838iGsPUy
         AnlAeoyejXwt+QT83X+WHWoJR/ikoZNezk6IAiGp+p6jzzCJpND2f+3ne/05K+zQH7Ue
         mtLw==
X-Gm-Message-State: AOAM533/MtG3uUDis/lUldV01KhY7DJWJHRSl53k/zaFHPHcnROjox7m
        oM28SSeUrhSvT1mHWneKPmI=
X-Google-Smtp-Source: ABdhPJz6jzrcdiwvc8+ceJ4ht/RaXM4J7MSlWn5B9/qKZEI2lPJcPw4IPJVQyFhWhkT1cBlHiR/mEA==
X-Received: by 2002:a63:b60b:: with SMTP id j11mr17206938pgf.19.1617490850685;
        Sat, 03 Apr 2021 16:00:50 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f0e0:a6d2:1540:7561? ([2601:647:4000:d7:f0e0:a6d2:1540:7561])
        by smtp.gmail.com with ESMTPSA id o134sm11773571pfd.113.2021.04.03.16.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Apr 2021 16:00:49 -0700 (PDT)
Subject: Re: [PATCH v3 1/7] pm80xx: Add sysfs attribute to check mpi state
To:     Viswas.G@microchip.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Ruksar.devadi@microchip.com, vishakhavc@google.com,
        radha@google.com, jinpu.wang@cloud.ionos.com,
        Ashokkumar.N@microchip.com, john.garry@huawei.com
References: <20210330064008.9666-1-Viswas.G@microchip.com>
 <20210330064008.9666-2-Viswas.G@microchip.com>
 <yq14kgpfk6o.fsf@ca-mkp.ca.oracle.com>
 <SN6PR11MB3488C8DDDA4F1C6F241691E99D7A9@SN6PR11MB3488.namprd11.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6426669b-7460-d8af-1f59-9056d0513105@acm.org>
Date:   Sat, 3 Apr 2021 16:00:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB3488C8DDDA4F1C6F241691E99D7A9@SN6PR11MB3488.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/21 9:58 PM, Viswas.G@microchip.com wrote:
> HMI_ERR gives the error details if the MPI initialization fails. Do
> we still need to spilt this ? Please advise.
Please take a look at Documentation/filesystems/sysfs.rst. From that
file: "Attributes should be ASCII text files, preferably with only one
value per file."

Thanks,

Bart.
