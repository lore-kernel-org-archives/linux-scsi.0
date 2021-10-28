Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A32C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1919060FC4
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhJ1UGg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 16:06:36 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:40617 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhJ1UGg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 16:06:36 -0400
Received: by mail-pf1-f177.google.com with SMTP id x7so1998396pfh.7;
        Thu, 28 Oct 2021 13:04:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1K+bk6NacZ1m1XKXaDe80atm4JTwmJpcwCVGp6y32I4=;
        b=rx9xYVF0yGR5g28Zy3FU3SF0zPOc/erGhxw4DAEQCaXHvvW7JHwSSThpMDfIV3R6Y/
         5bBEiQ+tHQIZuaq2UFqsBo+Ng67AzxsSdSzUR4wdxsIC9ZZPyNNFqPSez/e0EsI4yQoF
         fDPULlC3Kn6irRytNi+KCTBH+ITTYk/1wBjIJRZ7byrxVueRVCM/nY17XtChddhGp4YJ
         Fsj4KpkW1K2Jz9iuBXmUDI77/+NEWxX6szmYLi+QIMUWNn3W9U1C2Xl+S8SxmHqCa4Gw
         FYqyE0Kiz9Rc/pdjTEXPoLXY+0zo7EvHEmod3rqBJACFSzVp1elAh1TjRqETJovRsSeZ
         lveA==
X-Gm-Message-State: AOAM530Vgdu8wRE055AIrFFFLmB+4j9t+t4RTMPWIipnlHPA9BL4L+3y
        6HvwdsnHzh6cQeAND1s5p1g=
X-Google-Smtp-Source: ABdhPJysGuZSTGQ7v+yjb7Ew6sNSAs/5db0fIntuQ9zAe2nGFeULfKVrLzrHKpu1/OHcavAHqfSdpA==
X-Received: by 2002:a63:4c17:: with SMTP id z23mr877638pga.198.1635451448500;
        Thu, 28 Oct 2021 13:04:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:e816:bd0d:426c:f959])
        by smtp.gmail.com with ESMTPSA id s18sm4540439pfk.160.2021.10.28.13.04.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 13:04:07 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
To:     jejb@linux.ibm.com, daejun7.park@samsung.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        Keoseong Park <keosung.park@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
 <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
 <0f9229c3c4c7859524411a47db96a3b53ac89c90.camel@linux.ibm.com>
 <0d66b6d0-26c6-573f-e2a0-022e22c47b52@acm.org>
 <1d7c1faf6b6fa71599b5157ae95fc48ce479b722.camel@linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <42ca5f60-4c57-ade1-5fb7-be935ac4ccce@acm.org>
Date:   Thu, 28 Oct 2021 13:04:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1d7c1faf6b6fa71599b5157ae95fc48ce479b722.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/21 12:12 PM, James Bottomley wrote:
> I think the deadlock is triggered if the system is down to its last
> reserved request on the memory clearing device and the next entry in
> the queue for this device is one which does a fanout so we can't
> service it with the single reserved request we have left for the
> purposes of making forward progress.  Sending it back doesn't help,
> assuming this is the only memory clearing path, because retrying it
> won't help ... we have to succeed with a request on this path to move
> forward with clearing memory.
> 
> I think this problem could be solved by processing the WRITE BUFFER and
> the request serially by hijacking the request sent down, but we can't
> solve it if we try to allocate a new request.

Hi James,

How about fixing the abuse of blk_insert_cloned_request() in the UFS HPB
before the v5.16 SCSI pull request is sent to Linus and implementing the
proposal from your email at a later time? I'm proposing to defer further
UFS HPB rework since the issue described above only affects UFS HPB users
and does not obstruct maintenance or refactoring of the block layer core.

Thanks,

Bart.
