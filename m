Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E32C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 16:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 893CA20708
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 16:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgGGQiM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 12:38:12 -0400
Received: from smtp.infotech.no ([82.134.31.41]:37256 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbgGGQiL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Jul 2020 12:38:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id ACE3E20418F;
        Tue,  7 Jul 2020 18:38:09 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lh2rkXnu87i8; Tue,  7 Jul 2020 18:38:07 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 4562F204163;
        Tue,  7 Jul 2020 18:38:05 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 1/2] scsi: scsi_debug: Add check for sdebug_max_queue
 during module init
To:     John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, ming.lei@redhat.com,
        kashyap.desai@broadcom.com
References: <1594128751-212234-1-git-send-email-john.garry@huawei.com>
 <1594128751-212234-2-git-send-email-john.garry@huawei.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <797fced2-6392-ea3c-37de-1c0857707c67@interlog.com>
Date:   Tue, 7 Jul 2020 12:38:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1594128751-212234-2-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-07 9:32 a.m., John Garry wrote:
> sdebug_max_queue should not exceed SDEBUG_CANQUEUE, otherwise crashes like
> this can be triggered by passing an out-of-range value:
> 
> Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI RC0 - V1.16.01 03/15/2019
>   pstate: 20400009 (nzCv daif +PAN -UAO BTYPE=--)
>   pc : schedule_resp+0x2a4/0xa70 [scsi_debug]
>   lr : schedule_resp+0x52c/0xa70 [scsi_debug]
>   sp : ffff800022ab36f0
>   x29: ffff800022ab36f0 x28: ffff0023a935a610
>   x27: ffff800008e0a648 x26: 0000000000000003
>   x25: ffff0023e84f3200 x24: 00000000003d0900
>   x23: 0000000000000000 x22: 0000000000000000
>   x21: ffff0023be60a320 x20: ffff0023be60b538
>   x19: ffff800008e13000 x18: 0000000000000000
>   x17: 0000000000000000 x16: 0000000000000000
>   x15: 0000000000000000 x14: 0000000000000000
>   x13: 0000000000000000 x12: 0000000000000000
>   x11: 0000000000000000 x10: 0000000000000000
>   x9 : 0000000000000001 x8 : 0000000000000000
>   x7 : 0000000000000000 x6 : 00000000000000c1
>   x5 : 0000020000200000 x4 : dead0000000000ff
>   x3 : 0000000000000200 x2 : 0000000000000200
>   x1 : ffff800008e13d88 x0 : 0000000000000000
>   Call trace:
> schedule_resp+0x2a4/0xa70 [scsi_debug]
> scsi_debug_queuecommand+0x2c4/0x9e0 [scsi_debug]
> scsi_queue_rq+0x698/0x840
> __blk_mq_try_issue_directly+0x108/0x228
> blk_mq_request_issue_directly+0x58/0x98
> blk_mq_try_issue_list_directly+0x5c/0xf0
> blk_mq_sched_insert_requests+0x18c/0x200
> blk_mq_flush_plug_list+0x11c/0x190
> blk_flush_plug_list+0xdc/0x110
> blk_finish_plug+0x38/0x210
> blkdev_direct_IO+0x450/0x4d8
> generic_file_read_iter+0x84/0x180
> blkdev_read_iter+0x3c/0x50
> aio_read+0xc0/0x170
> io_submit_one+0x5c8/0xc98
> __arm64_sys_io_submit+0x1b0/0x258
> el0_svc_common.constprop.3+0x68/0x170
> do_el0_svc+0x24/0x90
> el0_sync_handler+0x13c/0x1a8
> el0_sync+0x158/0x180
>   Code: 528847e0 72a001e0 6b00003f 540018cd (3941c340)
> 
> In addition, it should not be less than 1.
> 
> So add checks for these, and fail the module init for those cases.
> 
> Fixes: c483739430f10 ("scsi_debug: add multiple queue support")
> Signed-off-by: John Garry <john.garry@huawei.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 4692f5b6ad13..68534a23866e 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6613,6 +6613,12 @@ static int __init scsi_debug_init(void)
>   		pr_err("submit_queues must be 1 or more\n");
>   		return -EINVAL;
>   	}
> +
> +	if ((sdebug_max_queue > SDEBUG_CANQUEUE) || (sdebug_max_queue <= 0)) {
> +		pr_err("max_queue must be in range [1, %d]\n", SDEBUG_CANQUEUE);
> +		return -EINVAL;
> +	}
> +
>   	sdebug_q_arr = kcalloc(submit_queues, sizeof(struct sdebug_queue),
>   			       GFP_KERNEL);
>   	if (sdebug_q_arr == NULL)
> 

