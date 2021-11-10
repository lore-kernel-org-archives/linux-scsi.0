Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24783C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 19:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2E5D6108B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 19:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhKJTV6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 14:21:58 -0500
Received: from mail-pj1-f46.google.com ([209.85.216.46]:51040 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbhKJTV4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 14:21:56 -0500
Received: by mail-pj1-f46.google.com with SMTP id x7so2320067pjn.0
        for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2021 11:19:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=keYQ5mOcLgQQxLVIJ8kgqpApi3+/zTEmC9Dev3DivvA=;
        b=yoZzpKnvpMfGxaUWjUfPyw0s1SgQDdbs/oofjhEmExX4dVK8wbHN/1bA6Hdg78wUEr
         rkJwg19R0QrnpQQYzgPC4dGVX85f3qKvjMCM7RgzsmFBwKJcrv1y+4Fp5tvMvN0Di9pP
         m0495cIfEh7LZrHk1Yufttmc5DxNZH6P8hBwatPj7N4cFKbMAO7XpCm/eyhBsFftI+Mo
         MEcSaTry/a5mPQirpPHdvhrxNXUFtgZEYYwuZID/AvHzUeXUX6+YM+aUx6GsJpT4iSZz
         reo+ZlTUyGRAJc8dOjMTTRZEKn8STlDY75X76aqWRzVd4K3DquO1LpzBDX7+ldKo8iOB
         N0WQ==
X-Gm-Message-State: AOAM533ItI2YLMVz2U2Zef6n4DvKT4UoKRA6BL7gkWPjaxSatILMyVaU
        xtjONf+PZF3ETcH7hrSzWAs=
X-Google-Smtp-Source: ABdhPJw2Eh8nNGsfnPVjdOySbmjbAPdl5sOdmDy6bBH8H78Ckw3mu+1VjG15PFhiy+5NF+j28uDRNQ==
X-Received: by 2002:a17:902:bd98:b0:13f:9ae7:54d1 with SMTP id q24-20020a170902bd9800b0013f9ae754d1mr1601740pls.15.1636571948219;
        Wed, 10 Nov 2021 11:19:08 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:b41d:11d3:d117:fe23])
        by smtp.gmail.com with ESMTPSA id md6sm370977pjb.22.2021.11.10.11.19.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 11:19:07 -0800 (PST)
Subject: Re: [PATCH 1/2] scsi: core: Add support for reserved tags
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-2-bvanassche@acm.org>
 <139e5cb6-c91e-fa64-f261-6359b6abe376@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <57aa04ba-edd5-93b9-4e0d-2fda4ccbe975@acm.org>
Date:   Wed, 10 Nov 2021 11:19:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <139e5cb6-c91e-fa64-f261-6359b6abe376@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/21 10:59 PM, Hannes Reinecke wrote:
> This is essentially the same patch as I posted a while ago (cf 
> https://lore.kernel.org/linux-scsi/20210222132405.91369-1- hare@suse.de/).
> 
> But there had been push-back on that series as it would also try to use 
> a scsi host device for driver-internal commands.
> 
> Maybe we should combine our efforts; patch 2 is equivalent to your 
> patch, and 3-5 are a conversion of the fnic driver to use those 
> commands. So we should merge our efforts to get this thing off the ground.
> 
> For the remainder of the patchset I'm currently working on a solution to 
> address the upstream concerns.

Hi Hannes,

In the UFS driver we are using a request queue that is not associated 
with any SCSI device for allocating driver-internal tags from the same 
tags space as SCSI commands. Is this a solution that is generic enough 
to be re-used by other SCSI drivers? See also the output of git grep -nH 
'hba->cmd_queue'.

Thanks,

Bart.
