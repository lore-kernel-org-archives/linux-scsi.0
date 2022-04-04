Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9491CC4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 21:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379557AbiDDVTx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380721AbiDDVPL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2022 17:15:11 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E662F3B4
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 14:13:14 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id z128so9351732pgz.2
        for <linux-scsi@vger.kernel.org>; Mon, 04 Apr 2022 14:13:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=viUszSWrcwmiSuDHM+i9gG9yQaQqPAyEe16NwfWq7wE=;
        b=Ya9Y7IDzvtNh7hrzlfGFi7wwTRKbn+IlEEXCmhsNRcLJn4gDFVaNzfUvBUbaxrLn4R
         ahNRr7FJFdPCbxHKkjU8UbQU+YSSaZl9/cZOhrWoDplkdHUEbr/9V2sTvJR6FRBrcrbh
         nq7Spth+pTOd7LA3kObbXfL/aKfBgFJ7TSvTqECUY0EWD01dSDrPvo31CsEGvT1TT+B4
         Vgdm7DyIO/ZKARoJ3M6HuoXPJ/tj+fuT1Zu+LeTK0MBpyxCq+wgGvkj143lSfcowAZsO
         2aIxDrCYzL1MY1I+6TkcNsvLw62zPEugVqpjFweR7sTzMXU9sTZalPZzSYx19+k7gvtJ
         mDWw==
X-Gm-Message-State: AOAM530Qx0a8/NNG4gMx9CSJiSfy8nKq5UTtGLpmH+Jd9UWKF2pUaIeX
        5bAXQdLHYQ6B6lb33IHpF/k=
X-Google-Smtp-Source: ABdhPJwr+J6l5mmgl30ZbmkxxaEHgv7SzVC8iBz3QFPkGX8Ks8P14pQVRAxJlPKIam9w73ZoPoWh+g==
X-Received: by 2002:a63:dd54:0:b0:382:2fb1:13cf with SMTP id g20-20020a63dd54000000b003822fb113cfmr97872pgj.72.1649106793563;
        Mon, 04 Apr 2022 14:13:13 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id u14-20020a056a00124e00b004fab8f3245fsm13771131pfi.149.2022.04.04.14.13.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 14:13:12 -0700 (PDT)
Message-ID: <5073d69e-20c4-0fce-a045-47c52e2d3424@acm.org>
Date:   Mon, 4 Apr 2022 14:13:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 00/29] UFS patches for kernel v5.19
Content-Language: en-US
To:     Bean Huo <huobean@gmail.com>, Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        quic_cang@quicinc.com
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <60dc8a92c7eda8f190a8a6123bc927e8403bdbb1.camel@gmail.com>
 <eee8d304-aacd-9116-9e2d-92e2e3682b5b@acm.org>
 <DM6PR04MB6575DBC3CFAD57F5AA19DCF8FCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
 <9bff98fa4a4a8a61a5c46830ef9515a7dfddcb89.camel@gmail.com>
 <ebf3cc31-9cd1-3615-b033-06bfc7d25b9a@acm.org>
 <94902f1e26a18ff7774dc429502bef7d54f23b5d.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <94902f1e26a18ff7774dc429502bef7d54f23b5d.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/4/22 01:12, Bean Huo wrote:
> Very interested in this design. I'm assuming you're still going to
> continue parsing SCSI commands. Can we also shorten the UFS command
> path?
> 
> Meaning we convert block requests directly to UFS UPIU commands?
> instead of like the current one: block request -> CDB -> UPIU.

Hi Bean,

Is there any data that shows that the benefits of shortening the UFS 
command path outweigh the disadvantages? For other SCSI LLDs the cost of 
atomic operations and memory barriers in the LLD outweighs the cost of 
the operations in the SCSI core and sd drivers. I'm not sure whether 
that's also the case for the UFS driver.

Thanks,

Bart.
