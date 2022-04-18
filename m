Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516D0C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Apr 2022 16:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346696AbiDRRBx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Apr 2022 13:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241062AbiDRRBv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2022 13:01:51 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BFC5F65
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2022 09:59:12 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id be5so12784330plb.13
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2022 09:59:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Dy5A/g6yvz+lMvxTVo7ph78eWp1RywEoWV+tOj/IQGg=;
        b=6ckfsrlIfGSV1UzgGB7dEqjzPZOfDz7rwF+KSHNLs5nlaXa7C0oZGdRByKnAWvJepp
         Hyonc1O1Qa3PKbUOSs7EvQ0HzFVY2hx+14hc+QzheLedkLFU2aWIfzVOnES4yNA5KAnS
         Zyic8hfz3Mq55hPcG5l9UahsWZcOrZFtFGkDFbPGmlZ7XyOpeP3U+OJcpF/xLqIvw+ZU
         usx/zQtF1ds7xWj5NCse0TMPQyek/4ZQPt7Rs/a/eSxCKAC0iIurSgKGJSAbYWq8FJ1L
         IGhDZYJu0dbkcbfDrnmNPEF3R2q7DOryyk1fEyeE2VXTdkrQER4hwHsE08AzkaQZZTha
         N6Iw==
X-Gm-Message-State: AOAM5334cmoGYVG1bRpaUJa9Hq0RsIvIZe+vScQX3BejldbGCpAaqj2g
        mUluZpPoNp1N9Sv4rDCQDvY=
X-Google-Smtp-Source: ABdhPJzbwBJblT2oHi+zQyGN1tONph80mm/HdopGXaInzWu6wPZ/w/13hmQlXhQ/5smtMtjFIaVFOw==
X-Received: by 2002:a17:902:c2c7:b0:159:9f9:85f3 with SMTP id c7-20020a170902c2c700b0015909f985f3mr2557540pla.18.1650301152304;
        Mon, 18 Apr 2022 09:59:12 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:713b:40eb:c240:d568? ([2620:15c:211:201:713b:40eb:c240:d568])
        by smtp.gmail.com with ESMTPSA id u10-20020a17090a890a00b001cb14240c4csm17508599pjn.1.2022.04.18.09.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 09:59:11 -0700 (PDT)
Message-ID: <845eaf8c-cf6d-f48f-b145-760a46489be5@acm.org>
Date:   Mon, 18 Apr 2022 09:59:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5/8] scsi: sd_zbc: Hide gap zones
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220415201752.2793700-1-bvanassche@acm.org>
 <20220415201752.2793700-6-bvanassche@acm.org>
 <db12ff0f-9b30-afd4-8fdb-f0514b2a02c6@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <db12ff0f-9b30-afd4-8fdb-f0514b2a02c6@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/17/22 16:22, Damien Le Moal wrote:
> On 4/16/22 05:17, Bart Van Assche wrote:
>> ZBC-2 allows host-managed disks to report gap zones. Another new feature
>> in ZBC-2 is support for constant zone starting LBA offsets. These two
>> features allow zoned disks to report a starting LBA offset that is a
>> power of two even if the number of logical blocks with data per zone is
>> not a power of two.
> 
> I think this last sentence would be clearer phrased like this:
> 
> These two features allow zoned disks to report zone start LBAs that are a
> power of two even if the number of logical blocks with data per zone is
> not a power of two.

I will modify the patch description.

Thanks,

Bart.
