Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A79CC433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Apr 2022 21:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234830AbiDCV4t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 17:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356933AbiDCV4s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 17:56:48 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F8215A3A
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 14:54:53 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id nt14-20020a17090b248e00b001ca601046a4so3267253pjb.0
        for <linux-scsi@vger.kernel.org>; Sun, 03 Apr 2022 14:54:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9b2kscuKXu9uc97rYzKzGQoIEOf7Gquytzmp7etlzSM=;
        b=sLEyZ+2RtskgMlY4ERVgf2kdXsv7jj4wiSmIJJ/yodvnS3fYzq67uT5iUL2eFhFh5b
         MayN6GQTp0rkXRsSMXkBTrR90LU5UzdNen7J7owxlbq722fB6E6Y0y0ea+6G5xKWFzvI
         qtPte1YdHSDCau01z6XJxvl5pXT5revf9WyHTtM0B/QuTkRI7vbT3MkiRESrzR823DY3
         Y/ss6vLMDm+PbJ6fGiMR2XzMJZOmAFRScDDN4QAeX2Uuda3+3FSFhbMFHMCHy0+QOVNn
         jCIZ4WLBhe/lSmdC3JhZMDe5S5oidTUZMO+/94M0aKdK7AaJxcMBJhORBZD7uAmLTif7
         bpng==
X-Gm-Message-State: AOAM533fgSbMzm1V8RIUkZJR/JFPm6zQyG27M4LQLTmoY134YMufg3hz
        F8OmXFpIIBZ/9Uzzso3bpkk=
X-Google-Smtp-Source: ABdhPJzSSuaY0UFQuzcZd+mEyXQ/kF/yyp50D0z0i87GLIPAv9Fx8bPUH4KBbKcUTJracWTvGeu1XQ==
X-Received: by 2002:a17:902:edc5:b0:156:68e4:416 with SMTP id q5-20020a170902edc500b0015668e40416mr12248471plk.87.1649022892617;
        Sun, 03 Apr 2022 14:54:52 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090a3fc600b001ca88b0bdfesm2532538pjm.13.2022.04.03.14.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 14:54:51 -0700 (PDT)
Message-ID: <ebf3cc31-9cd1-3615-b033-06bfc7d25b9a@acm.org>
Date:   Sun, 3 Apr 2022 14:54:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 00/29] UFS patches for kernel v5.19
Content-Language: en-US
To:     Bean Huo <huobean@gmail.com>, Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <60dc8a92c7eda8f190a8a6123bc927e8403bdbb1.camel@gmail.com>
 <eee8d304-aacd-9116-9e2d-92e2e3682b5b@acm.org>
 <DM6PR04MB6575DBC3CFAD57F5AA19DCF8FCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
 <9bff98fa4a4a8a61a5c46830ef9515a7dfddcb89.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9bff98fa4a4a8a61a5c46830ef9515a7dfddcb89.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/3/22 14:36, Bean Huo wrote:
> Yes, I reviewed the entire series of patches and there are no
> significant structural changes. Still want to squeeze ufs driver under
> driver/scsi/ufs/. No major conflict with pending submissions. Go ahead.

Hi Bean,

It has been suggested to move the UFS driver code into the following two 
directories to keep paths short:
* drivers/ufs/core
* drivers/ufs/host

That approach is similar to the approach followed for the MMC and NVMe 
drivers.

Additionally, some other SCSI drivers already occur outside the 
drivers/scsi directory, e.g. the drivers/infiniband/ulp/srp/ib_srp.c driver.

Thanks,

Bart.
