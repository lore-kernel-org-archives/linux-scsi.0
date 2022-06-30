Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8687AC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 20:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiF3UWi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 16:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236775AbiF3UWa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 16:22:30 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E6022BEA
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 13:22:29 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id w1-20020a17090a6b8100b001ef26ab992bso594602pjj.0
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 13:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v0P466EEUErNr+fNYrZ2tBA1lb1vnA1+9qbcE61GlWI=;
        b=wTrxGlXDkoU8d4rkO9qVgogHmK9pfrhlOyurWxfZTxu4+l2fOC6maH+4ghMgqk9UYB
         hN9l0qUuyEuNafo0LRy5aUjtHPQtD5i9kIN7Du4Qfg1GOn+JmEzn/wS773LBFUTJd/yM
         UBJbmzhvv+RZY7+QzTYcLl5OTfFIuFWUKk3NNnndbJGKAlSPJpE/+HPaKWob0TfoMxR5
         qT1Ui+2qjFHzu/QMUtqP+flaGLahhWt2tm8I2EOkAvGUrmy4y/EhPRjTWmYW4e4rSDYZ
         QAz5ON85cCxZwFCO6Asb4xEfcHIS3xNf+/7gwboQBDRkJo+PdjLMQbQWeU5et5mmNYfL
         ZpkQ==
X-Gm-Message-State: AJIora8cUsK51GatHQxIPc8SDr1qzfCcXgT5wKd/9QMxzC8duNMd4X27
        3l5EHazOGR1qRHvfwY7lL7g=
X-Google-Smtp-Source: AGRyM1vycTvElaIkaK9LpbBQzZURp5JlJ/dlXIFCkV4s13Ca4dMMjPTfR42tKVjZqz4KUsyf6PrcHg==
X-Received: by 2002:a17:902:7596:b0:16a:3bea:11eb with SMTP id j22-20020a170902759600b0016a3bea11ebmr17252664pll.154.1656620549225;
        Thu, 30 Jun 2022 13:22:29 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id k21-20020a6568d5000000b0040d5abae51esm13776588pgt.91.2022.06.30.13.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 13:22:28 -0700 (PDT)
Message-ID: <1715e78d-2a02-da35-16e3-2761b9b6342e@acm.org>
Date:   Thu, 30 Jun 2022 13:22:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] scsi: core: Call blk_mq_free_tag_set() earlier
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>,
        Changhui Zhong <czhong@redhat.com>
References: <20220628175612.2157218-1-bvanassche@acm.org>
 <YruoKUbpBZvAkZ4L@T590> <8e464697-e179-19f7-e417-be089821a861@acm.org>
 <Yrz18+1iFb/QkiBZ@T590> <Yr1lh5YhR20S15H8@T590>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Yr1lh5YhR20S15H8@T590>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/30/22 01:57, Ming Lei wrote:
> BTW, Changhui reported one very similar issue when running elevator
> switch/scsi debug LUN hotplug.
> 
>>From Changhui's report, the issue is basically same with what
> f2b85040acec tried to address, but the try_module_get() in
> scsi_device_dev_release() may fail, so the scsi_debug module
> still can be unloaded.
> 
> The thing is that sdev can be released in async style, and target/host
> release is triggered by scsi_device_dev_release_usercontext().
> 
> So after scsi_host_remove() returns, the shost may still be live from
> driver core/sysfs viewpoint, and its release handler can be called
> after the LLD module is unloaded. Then this kind of issue is triggered.
> 
> Seems there are at least two approaches for fixing the issue:
> 
> 1) the one suggested in this thread:
> - moving any reference to shost->hostt in host release handler into
> scsi_host_remove(), and scsi_mq_destroy_tags()/scsi_proc_hostdir_rm(shost->hostt)()
> should be covered at least
> 
> 2) wait until all targets are released in scsi_host_remove()
> 
> I am fine with either of the two approaches.
> 
> Bart, please let me know if you are working towards the approach in 1).
> If not, I have one patch which implements 2).
> 
> BTW, after either 1) or 2) is done, commit f2b85040acec can be reverted.

Hi Ming,

All I need is that all activity on the host tag set has stopped by the 
time scsi_forget_host() returns. I do not need (1) or (2) to fix the bug 
reported in the description of the patch at the start of this thread.

Thanks,

Bart.
