Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDD1C07E94
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 14:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F094A613AA
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 14:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhFDOy0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 10:54:26 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:38824 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhFDOy0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 10:54:26 -0400
Received: by mail-pg1-f179.google.com with SMTP id 6so8070674pgk.5;
        Fri, 04 Jun 2021 07:52:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LKSlHuFmSmd73FlqKOE/HzlbPQjKNdJGN1kLkWuNHd4=;
        b=BmFHzztiNTj4RANtUhnaVIYzadac626i15pDCPUoiXwx+BFM6Cs/vtTueEqf2BWqQ6
         WlmspeIvjqVJUMSqBTJi+5BTonS9Qxh4jyTjfdgLcgWUuW4AxLrxSajXV+Ff5P6lV6b6
         D3FeV5PKEWD69dexF2ECpDE+QFRjOv+YVI6XvUpLNEjEqP761Vg7UmzUGjMV1BX+5W2J
         6GCx7tHlImEgTnCF+t9NQJhrXpiCoF5eDQqun32aBy7e24ulIepvMEG9Gj8BnYecqK1d
         ninKf4ZV9ewinDQRBoSMith2tNCuWZx0K+WyBXjkumTfu4zk3FV3U5YvzeXcLHlP8UUq
         tiUw==
X-Gm-Message-State: AOAM533MXeyV9Y9P0nCiGoUWqQbivWDxztvuhGiriTjG1YqMZ6ZR65F0
        dAHkL0b0X/GoKyKZNOrt4KQ=
X-Google-Smtp-Source: ABdhPJz6SFb9mkl7CsLadsG32YMBrSBzrrGoY/7akC6W5wX8KqHDw+fMCGn8wF7nvNGwLJ8KAXVYxA==
X-Received: by 2002:a63:f154:: with SMTP id o20mr5404254pgk.53.1622818359676;
        Fri, 04 Jun 2021 07:52:39 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id j5sm153477pgl.70.2021.06.04.07.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 07:52:38 -0700 (PDT)
Subject: Re: [PATCH v12 1/3] bio: control bio max size
To:     Changheun Lee <nanich.lee@samsung.com>, damien.lemoal@wdc.com
Cc:     Avri.Altman@wdc.com, Johannes.Thumshirn@wdc.com,
        alex_y_xu@yahoo.ca, alim.akhtar@samsung.com,
        asml.silence@gmail.com, axboe@kernel.dk, bgoncalv@redhat.com,
        cang@codeaurora.org, gregkh@linuxfoundation.org, hch@infradead.org,
        jaegeuk@kernel.org, jejb@linux.ibm.com, jisoo2146.oh@samsung.com,
        junho89.kim@samsung.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, ming.lei@redhat.com,
        mj0123.lee@samsung.com, osandov@fb.com, patchwork-bot@kernel.org,
        seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        tj@kernel.org, tom.leiming@gmail.com, woosung2.lee@samsung.com,
        yi.zhang@redhat.com, yt0928.kim@samsung.com
References: <DM6PR04MB70812AF342F46F453696A447E73B9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <CGME20210604075331epcas1p13bb57f9ddfc7b112dec1ba8cf40fdc74@epcas1p1.samsung.com>
 <20210604073459.29235-1-nanich.lee@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <63afd2d3-9fa3-9f90-a2b3-37235739f5e2@acm.org>
Date:   Fri, 4 Jun 2021 07:52:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210604073459.29235-1-nanich.lee@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/4/21 12:34 AM, Changheun Lee wrote:
>> On 2021/06/04 14:22, Changheun Lee wrote:
>>> +unsigned int bio_max_bytes(struct bio *bio)
>>> +{
>>> +	struct block_device *bdev = bio->bi_bdev;
>>> +
>>> +	return bdev ? bdev->bd_disk->queue->limits.max_bio_bytes : UINT_MAX;
>>> +}
>>
>> unsigned int bio_max_bytes(struct bio *bio)
>> {
>> 	struct block_device *bdev = bio->bi_bdev;
>>
>> 	if (!bdev)
>> 		return UINT_MAX;
>> 	return bdev->bd_disk->queue->limits.max_bio_bytes;
>> }
>>
>> is a lot more readable...
>> Also, I remember there was some problems with bd_disk possibly being null. Was
>> that fixed ?
> 
> Thank you for review. But I'd like current style, and it's readable enough
> now I think. Null of bd_disk was just suspicion. bd_disk is not null if bdev
> is not null.
 Damien is right. bd_disk can be NULL. From
https://lore.kernel.org/linux-block/20210425043020.30065-1-bvanassche@acm.org/:
"bio_max_size() may get called before device_add_disk() and hence needs to
check whether or not the block device pointer is NULL. [ ... ]
This patch prevents that bio_max_size() triggers the following kernel
crash during a SCSI LUN scan:\
BUG: KASAN: null-ptr-deref in bio_add_hw_page+0xa6/0x310
Read of size 8 at addr 00000000000005a8 by task kworker/u16:0/7
Workqueue: events_unbound async_run_entry_fn
Call Trace:
 show_stack+0x52/0x58
 dump_stack+0x9d/0xcf
 kasan_report.cold+0x4b/0x50
 __asan_load8+0x69/0x90
 bio_add_hw_page+0xa6/0x310
 bio_add_pc_page+0xaa/0xe0
 bio_map_kern+0xdc/0x1a0
 blk_rq_map_kern+0xcd/0x2d0
 __scsi_execute+0x9a/0x290 [scsi_mod]
 scsi_probe_lun.constprop.0+0x17c/0x660 [scsi_mod]
 scsi_probe_and_add_lun+0x178/0x750 [scsi_mod]
 __scsi_add_device+0x18c/0x1a0 [scsi_mod]
 ata_scsi_scan_host+0xe5/0x260 [libata]
 async_port_probe+0x94/0xb0 [libata]
 async_run_entry_fn+0x7d/0x2d0
 process_one_work+0x582/0xac0
 worker_thread+0x8f/0x5a0
 kthread+0x222/0x250
 ret_from_fork+0x1f/0x30"

Bart.
