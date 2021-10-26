Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AB8C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 16:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 562836108B
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 16:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbhJZQjL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 12:39:11 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:41973 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbhJZQjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 12:39:10 -0400
Received: by mail-pg1-f172.google.com with SMTP id 83so11661pgc.8;
        Tue, 26 Oct 2021 09:36:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dAqe3YnTOdTV+SdN4Z4XT4EnkTy0b5083zzk171qBC0=;
        b=TPaXNsOtz3xm+dUGhCPEelKAQJkPYKBHvYH4mA1gZ6tbtnZi+HWlIc78ESx2XTKdnx
         UEVOT2X0mh73Q6RJEoNLpptIS8oIFjfN6hUipPM26dcKtrpr+QQIpCeO79D1uAZzAckW
         Nka32tB9c+ZW7Xs0h2q08oeHW2Wsnptw9Rxx73KHf4jfRI1fdfyrQNgmW7TZkv9ROxVd
         rhFA9hcKvwkO8QYU7lP/vj4tySicvIDVB88x+Cb9KYMNP4wcgCT780bSBSwfDKh+x0X/
         O9j3VgG9QS8VboTUGWBpmOUNkGYEiReCTWp0NxFuAl3aDAouaxHYvAsfVv8Mf6s/CBQw
         bgzw==
X-Gm-Message-State: AOAM532gOaY22naaygalqRlMWXv5AM9rM9ip9dni5rgMfez5oIHFu5M8
        C+RCdERDSZrfhoxiORRxeMN7HqlcA3S+Ug==
X-Google-Smtp-Source: ABdhPJztnj190k8biAi6qT1Cq9ZUO6zQSL5ez8cdvbIcEY88OnzKGBUbDokriozgwkeyiyWb7iFU9w==
X-Received: by 2002:a63:1406:: with SMTP id u6mr19767758pgl.106.1635266205096;
        Tue, 26 Oct 2021 09:36:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:26a4:3b5f:3c4f:53f5])
        by smtp.gmail.com with ESMTPSA id mp14sm1328815pjb.17.2021.10.26.09.36.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 09:36:44 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
To:     Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc:     axboe@kernel.dk, alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20211026071204.1709318-1-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
Date:   Tue, 26 Oct 2021 09:36:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211026071204.1709318-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/21 12:12 AM, Christoph Hellwig wrote:
> The HPB support added this merge window is fundanetally flawed as it
                                              ^^^^^^^^^^^^
                                              fundanetally -> fundamentally

Since the implementation can be reworked not to use
blk_insert_cloned_request() I'm not sure using the word "fundamentally"
is appropriate.

> uses blk_insert_cloned_request to insert a cloned request onto the same
> queue as the one that the original request came from, leading to all
> kinds of issues in blk-mq accounting (in addition to this API being
> a special case for dm-mpath that should not see other users).

More detailed information would have been welcome.

> Fixes: f02bc9754a68 ("scsi: ufs: ufshpb: Introduce Host Performance Buffer
> feature")

I assume that you wanted to refer to commit 41d8a9333cc9 ("scsi: ufs: ufshpb:
Add HPB 2.0 support") instead since that commit is the only commit that
introduced a blk_insert_cloned_request() call in the UFS HPB code?

Bart.
