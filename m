Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E4EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 01:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiBOBdq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 20:33:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBOBdq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 20:33:46 -0500
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A3912F14D
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 17:33:37 -0800 (PST)
Received: by mail-pj1-f45.google.com with SMTP id n19-20020a17090ade9300b001b9892a7bf9so1062128pjv.5
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 17:33:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cQ5V/7co3SCFnizLxOhJOYuKG94MsWlmhYc/O83Rn7Y=;
        b=rBbFDqKqW96Ogqx/O+tUPJyOc+pxVtJLOyqzVppZE4eXI0Hobp7PK1KgwtVBcesBx4
         BhZA4plpTFLj/o23UFcwLTd6WpjqVBlDs1kifVaFPIJrw5p8GtPCXBPvl7kHybTxW/QM
         S6Y4eBOIuVlDEiMPlul10raNS3KDJ27MDVmQ6pWXhhKCZVdSYAKSHEFhzq9F2lG1wbwq
         g8ik0aC9fRrgTrt2zBeCzatSUxyQ+HyN/Axw3eJydsUfF4gULYfxDdUOwosgB0WV4QaG
         tWmWmfflLcIolSIWUkVzxOM+RLxOGYpugA96zIyx484IHM2lakwZyy6826pGS6VpSLnx
         B/HA==
X-Gm-Message-State: AOAM532T2/KDCw4zjX5a9E0gTZnlCZK0LPkLHI2bQnbqv7zroCBJbuTh
        Pv5Iq8g96CkJP1J20t2ygCs=
X-Google-Smtp-Source: ABdhPJxTK33asLRAwSSN+cP2rFVI0asiZTiSSLbIXZAj6PxwsJWykzJV5LYXqqCR/zrf5zEZ3k2mLQ==
X-Received: by 2002:a17:903:120e:: with SMTP id l14mr1706688plh.124.1644888816391;
        Mon, 14 Feb 2022 17:33:36 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id 1sm15033341pji.40.2022.02.14.17.33.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 17:33:35 -0800 (PST)
Message-ID: <7977d8ee-a75f-b3d6-291f-084b516c8a66@acm.org>
Date:   Mon, 14 Feb 2022 17:33:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3 02/48] scsi: ips: Change the return type of
 ips_release() into 'void'
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-3-bvanassche@acm.org>
 <107d0c5d-bc81-8177-afd1-2901c5d4b3fe@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <107d0c5d-bc81-8177-afd1-2901c5d4b3fe@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/14/22 01:43, Hannes Reinecke wrote:
> On 2/11/22 23:32, Bart Van Assche wrote:
>> ips_release() has one caller and that caller ignores the value 
>> returned by
>> ips_release(). Hence change the return type of that function into 'void'.
>>
>> Cc: Hannes Reinecke <hare@suse.com>
>> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> Cc: John Garry <john.garry@huawei.com>
>> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/ips.c | 7 ++-----
>>   1 file changed, 2 insertions(+), 5 deletions(-)
>>
> Nit: could be merged with the previous patch.
> But nothing critical, and can be done in the next version (if such a 
> thing is necessary).

Hmm ... isn't the rule one change per patch? Anyway, I can combine the 
first two patches if you feel strongly about this.

Thanks,

Bart.
