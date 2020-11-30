Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F34C64E8A
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 07:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 585C520719
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 07:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgK3HYH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 02:24:07 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8473 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgK3HYG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 02:24:06 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CkxXV387RzhkW5;
        Mon, 30 Nov 2020 15:23:06 +0800 (CST)
Received: from [10.174.178.248] (10.174.178.248) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Mon, 30 Nov 2020 15:23:08 +0800
From:   Yufen Yu <yuyufen@huawei.com>
Subject: [RFC] blk-mq/scsi: deadlock found on usb driver
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
CC:     <john.garry@huawei.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "Christoph Hellwig" <hch@infradead.org>,
        Ming Lei <ming.lei@redhat.com>, <osandov@fb.com>,
        <wubo40@huawei.com>, yanaijie <yanaijie@huawei.com>,
        <yuyufen@huawei.com>
Message-ID: <d6266f2e-9cc7-d222-dedd-15a1a0a6571f@huawei.com>
Date:   Mon, 30 Nov 2020 15:23:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.248]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, all

   We reported IO stuck on a scsi usb driver recently and any IO issued
to the device cannot return. The usb driver just have **one** driver tag
and  **two** sched tag. After debugging, we found there is a deadlock
race as following:

cpu0(scsi_eh)       cpu1                          cpu2
                     get sched tag(internal_tag=0)
                     get driver tag(tag=0)
                                                   get sched tag(internal_tag=1)
                                                   wait for driver tag
scsi_error_handler try issue io
wait for sched tag
                     try to dispatch the request
                     wait for setting shost state as SHOST_RUNNING
//scsi_host_set_state(shost, SHOST_RUNNING)

The scsi_eh thread stack as following:
PID: 945745  TASK: ffff950a8f2f0000  CPU: 42  COMMAND: "scsi_eh_15"
   [ffffbbee8d5b3ce0] __schedule at ffffffffa506ebac
   [ffffbbee8d5b3d00] sbitmap_get at ffffffffa4c4684f
   [ffffbbee8d5b3d48] schedule at ffffffffa506f208
   [ffffbbee8d5b3d50] io_schedule at ffffffffa506f5d2
   [ffffbbee8d5b3d60] blk_mq_get_tag at ffffffffa4bf5277
   [ffffbbee8d5b3d88] autoremove_wake_function at ffffffffa48ffe40
   [ffffbbee8d5b3db8] autoremove_wake_function at ffffffffa48ffe40
   [ffffbbee8d5b3e08] blk_mq_get_request at ffffffffa4bef14c
   [ffffbbee8d5b3e20] eh_lock_door_done at ffffffffa4da5580
   [ffffbbee8d5b3e38] blk_mq_alloc_request at ffffffffa4bef494
   [ffffbbee8d5b3e80] blk_get_request at ffffffffa4be5042
   [ffffbbee8d5b3e98] scsi_error_handler at ffffffffa4da8670
   [ffffbbee8d5b3ea0] __schedule at ffffffffa506ebb4
   [ffffbbee8d5b3f08] scsi_error_handler at ffffffffa4da8430
   [ffffbbee8d5b3f10] kthread at ffffffffa48d6d7d
   [ffffbbee8d5b3f20] kthread at ffffffffa48d6c70
   [ffffbbee8d5b3f50] ret_from_fork at ffffffffa520023f

Since there are no more available sched tag and driver tag. All of
threads will wait forever. We found the bug on 4.18 kernel, but the
latest kernel code also have the problem.

I don't have good idea about how to fix the bug. So, any suggestions are welcome.

Thanks,
Yufen
