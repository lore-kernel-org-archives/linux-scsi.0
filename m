Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45968ECAAD4
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 03:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiH2DfO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Aug 2022 23:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiH2DfM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Aug 2022 23:35:12 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E78101D3
        for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2022 20:35:10 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id bg22so6758146pjb.2
        for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2022 20:35:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=tnUw1an/QcyIkQLpsJFUSctJUxnXQu9us+byecmHs90=;
        b=1qS86jygVgfimsqyy+b5InBan/hfvWXWLefTKsYXVJrCS+R0uPBi0LDAp7RfhYXo/1
         R3n5HlTa8jF5tlV+sHBaygyUgxdJtRaMUR5xirNMiU/2+T5Rnk+IG1Ig0a6D6yyQIV2W
         JUhnrMm/sb/7XXSciWE7nMEMXA6JZG+WPwtzOAkDb6SQ4pT5pylNlcUe2I8ug3DfTUqu
         i/LFhtU7xaw+ObBWAcn6rirBNb0Nzhcm6xqHjhU0YWYL4SZ2/yS1kGFzuVHrZNJyo+ti
         iO/tPkVZC+ly9hqxtQgwKriWyFss/u9DW8BfUjtAR7mOoC2UyIsG8cqvInwY5yBKcyv5
         MiKQ==
X-Gm-Message-State: ACgBeo1VT3l5if3ZaXj9K2+n0p+tg4IXQLNhr2UJ1uK0ZZtle21v1Rvk
        BeP13PFwgoovbj2HNCnGbLM=
X-Google-Smtp-Source: AA6agR7IZzlLNBNj9ttM3ONRo0KYoAXvm5ch7DDGV9EZeBEBeerw3mr5xLENCgY+zSHDU0i3I9Az5g==
X-Received: by 2002:a17:90b:1e0a:b0:1f5:6554:d502 with SMTP id pg10-20020a17090b1e0a00b001f56554d502mr15912983pjb.101.1661744109866;
        Sun, 28 Aug 2022 20:35:09 -0700 (PDT)
Received: from [172.20.0.236] ([12.219.165.6])
        by smtp.gmail.com with ESMTPSA id x128-20020a626386000000b0052d200c8040sm5930629pfb.211.2022.08.28.20.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Aug 2022 20:35:08 -0700 (PDT)
Message-ID: <aa14894e-305b-b18b-a2c8-ad411cb75460@acm.org>
Date:   Sun, 28 Aug 2022 20:35:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] scsi: core: Fix a use-after-free
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220826002635.919423-1-bvanassche@acm.org>
 <YwwT5BC+s0VHT5UK@T590>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YwwT5BC+s0VHT5UK@T590>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/28/22 18:18, Ming Lei wrote:
> On Thu, Aug 25, 2022 at 05:26:34PM -0700, Bart Van Assche wrote:
>> There are two .exit_cmd_priv implementations. Both implementations use
>> resources associated with the SCSI host. Make sure that these resources are
>> still available when .exit_cmd_priv is called by waiting inside
>> scsi_remove_host() until the tag set has been freed.
>>
>> This patch fixes the following use-after-free:
>>
>> ==================================================================
>> BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
>> Read of size 8 at addr ffff888100337000 by task multipathd/16727
>> Call Trace:
>>   <TASK>
>>   dump_stack_lvl+0x34/0x44
>>   print_report.cold+0x5e/0x5db
>>   kasan_report+0xab/0x120
>>   srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
>>   scsi_mq_exit_request+0x4d/0x70
>>   blk_mq_free_rqs+0x143/0x410
>>   __blk_mq_free_map_and_rqs+0x6e/0x100
>>   blk_mq_free_tag_set+0x2b/0x160
>>   scsi_host_dev_release+0xf3/0x1a0
> 
> The trace must be triggered on old kernel, cause this issue is fixed by
> upstream since commit f323896fe6fa ("scsi: core: Call blk_mq_free_tag_set() earlier")
> from you, :-)

Hi Ming,

Did you perhaps overlook the patch series "[PATCH 0/4] Revert "Call 
blk_mq_free_tag_set() earlier"" 
(https://lore.kernel.org/linux-scsi/20220821220502.13685-1-bvanassche@acm.org/)? 
This patch reworks the patch series "Call blk_mq_free_tag_set() earlier" 
but without triggering the deadlock reported by syzbot and also here: 
https://lore.kernel.org/all/Yv%2FMKymRC9O04Nqu@google.com/

Thanks,

Bart.
