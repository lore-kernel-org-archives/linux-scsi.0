Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC05C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 17:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4C3A610D2
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 17:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhJ1RKX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 13:10:23 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:34740 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhJ1RKW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 13:10:22 -0400
Received: by mail-pj1-f43.google.com with SMTP id q2-20020a17090a2e0200b001a0fd4efd49so5690533pjd.1;
        Thu, 28 Oct 2021 10:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=reYNpE6xAWBpewv9K/pHFCc4Cr+QZEcky4GgEs2Yduo=;
        b=vNQsVKPnmUAtNObi3BqhV4TnlEb/7J/ME6+21aRugDlvhWuDwSvAg/LSAfstpvEoAs
         aJlvwtA/9BBClgAv3JqybdgCGKrvzTUUc7u0LED7daAdeFa7DLULO77g/LOMDpgOYFtz
         grJFVo/j01Zpy/jFOos8Ukddj+Wz4bpEfK8/JOTjqYGMtpsQELqkX9m9sy+1VEcjHVJo
         PnazD+uEnrgaXBDaze54K+GnxENgCELvLXgvQEaqtQWKmwXWPtqm2MT03X4heZJAoztW
         pPJppWwiWqNp5Mj/9E+ZI2kL9KMtU/C/zAAYE/kNRQzgKkRXHEt+J/p7p5gTea/hqW1L
         gSvw==
X-Gm-Message-State: AOAM531LQZJxdgfmE8H9nZ8QWyDcSV5wGRgThEzmbIIiURFRU9yJav/5
        4qhomD9i7pKxrHYc0YxisMkzjdSbmjiZFw==
X-Google-Smtp-Source: ABdhPJzP3tRwRt1FYZqgvyw2sQtJvy1oCcBgvljKt7oC5A5Sf4aodcrh90zSzY6Oy1sG/A9xn/3yYg==
X-Received: by 2002:a17:90b:4b44:: with SMTP id mi4mr5746298pjb.187.1635440874388;
        Thu, 28 Oct 2021 10:07:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:e816:bd0d:426c:f959])
        by smtp.gmail.com with ESMTPSA id j8sm3861709pfe.105.2021.10.28.10.07.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 10:07:53 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
To:     Christoph Hellwig <hch@infradead.org>,
        James Bottomley <jejb@linux.ibm.com>
Cc:     daejun7.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
 <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
 <0f9229c3c4c7859524411a47db96a3b53ac89c90.camel@linux.ibm.com>
 <YXrBTHmu/fiAaZH5@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <54b45df9-9339-c69d-73b5-9c293449b849@acm.org>
Date:   Thu, 28 Oct 2021 10:07:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YXrBTHmu/fiAaZH5@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/21 8:27 AM, Christoph Hellwig wrote:
> On Thu, Oct 28, 2021 at 10:28:01AM -0400, James Bottomley wrote:
>> If the block people are happy with this, then I'm OK with it, but it
>> doesn't look like you've solved the fanout deadlock problem because
>> this new mechanism is still going to allocate a new tag.
> 
> Yes, same problem as before.

Hi Christoph,

I spent some time looking around for other examples of allocating and
inserting a request from inside block layer callbacks. I only found one
such example, namely in the NVMe core. nvme_timeout() calls
nvme_alloc_request() and blk_execute_rq_nowait(). The difference between
what the UFS HPB code is doing and what nvme_timeout() does doesn't seem
that big to me. For clarity, I don't like the UFS HPB protocol nor how
support for that protocol has been implemented. However, I don't see how
the UFS HPB implementation would complicate maintenance of the block
layer core. Am I perhaps missing something?

Thanks,

Bart.
