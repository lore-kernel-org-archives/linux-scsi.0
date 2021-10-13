Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F269C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 18:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FD6C6113D
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 18:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbhJMSmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 14:42:37 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:59760 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhJMSmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 14:42:36 -0400
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id BFFB32EA525;
        Wed, 13 Oct 2021 14:40:31 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id gmdedJn2uhmy; Wed, 13 Oct 2021 14:40:31 -0400 (EDT)
Received: from [192.168.48.23] (host-23-91-187-47.dyn.295.ca [23.91.187.47])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id B3C7E2EA078;
        Wed, 13 Oct 2021 14:40:30 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v2 resend 2/2] scsi:scsi_debug:Fix out-of-bound read in
 resp_report_tgtpgs
To:     Ye Bin <yebin10@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org
References: <20211013033913.2551004-1-yebin10@huawei.com>
 <20211013033913.2551004-3-yebin10@huawei.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <ff5097fd-a969-c088-fec4-3a0f2b898993@interlog.com>
Date:   Wed, 13 Oct 2021 14:40:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211013033913.2551004-3-yebin10@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-10-12 11:39 p.m., Ye Bin wrote:
> We got follow issue when run syzkaller:
> BUG: KASAN: slab-out-of-bounds in memcpy include/linux/string.h:377 [inline]
> BUG: KASAN: slab-out-of-bounds in sg_copy_buffer+0x150/0x1c0 lib/scatterlist.c:831
> Read of size 2132 at addr ffff8880aea95dc8 by task syz-executor.0/9815
> 
> CPU: 0 PID: 9815 Comm: syz-executor.0 Not tainted 4.19.202-00874-gfc0fe04215a9 #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0xe4/0x14a lib/dump_stack.c:118
>   print_address_description+0x73/0x280 mm/kasan/report.c:253
>   kasan_report_error mm/kasan/report.c:352 [inline]
>   kasan_report+0x272/0x370 mm/kasan/report.c:410
>   memcpy+0x1f/0x50 mm/kasan/kasan.c:302
>   memcpy include/linux/string.h:377 [inline]
>   sg_copy_buffer+0x150/0x1c0 lib/scatterlist.c:831
>   fill_from_dev_buffer+0x14f/0x340 drivers/scsi/scsi_debug.c:1021
>   resp_report_tgtpgs+0x5aa/0x770 drivers/scsi/scsi_debug.c:1772
>   schedule_resp+0x464/0x12f0 drivers/scsi/scsi_debug.c:4429
>   scsi_debug_queuecommand+0x467/0x1390 drivers/scsi/scsi_debug.c:5835
>   scsi_dispatch_cmd+0x3fc/0x9b0 drivers/scsi/scsi_lib.c:1896
>   scsi_request_fn+0x1042/0x1810 drivers/scsi/scsi_lib.c:2034
>   __blk_run_queue_uncond block/blk-core.c:464 [inline]
>   __blk_run_queue+0x1a4/0x380 block/blk-core.c:484
>   blk_execute_rq_nowait+0x1c2/0x2d0 block/blk-exec.c:78
>   sg_common_write.isra.19+0xd74/0x1dc0 drivers/scsi/sg.c:847
>   sg_write.part.23+0x6e0/0xd00 drivers/scsi/sg.c:716
>   sg_write+0x64/0xa0 drivers/scsi/sg.c:622
>   __vfs_write+0xed/0x690 fs/read_write.c:485
> kill_bdev:block_device:00000000e138492c
>   vfs_write+0x184/0x4c0 fs/read_write.c:549
>   ksys_write+0x107/0x240 fs/read_write.c:599
>   do_syscall_64+0xc2/0x560 arch/x86/entry/common.c:293
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
>   As with previous patch, we get 'alen' from command, and 'alen''s type is
>   int, If userspace pass large length we will get negative 'alen'.
>   So just set 'n'/'alen'/'rlen' with u32 type.
> 
> Signed-off-by: Ye Bin <yebin10@huawei.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> ---
>   drivers/scsi/scsi_debug.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index be0440545744..ead65cdfb522 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1896,8 +1896,9 @@ static int resp_report_tgtpgs(struct scsi_cmnd *scp,
>   	unsigned char *cmd = scp->cmnd;
>   	unsigned char *arr;
>   	int host_no = devip->sdbg_host->shost->host_no;
> -	int n, ret, alen, rlen;
>   	int port_group_a, port_group_b, port_a, port_b;
> +	u32 alen, n, rlen;
> +	int ret;
>   
>   	alen = get_unaligned_be32(cmd + 6);
>   	arr = kzalloc(SDEBUG_MAX_TGTPGS_ARR_SZ, GFP_ATOMIC);
> @@ -1959,9 +1960,9 @@ static int resp_report_tgtpgs(struct scsi_cmnd *scp,
>   	 * - The constructed command length
>   	 * - The maximum array size
>   	 */
> -	rlen = min_t(int, alen, n);
> +	rlen = min(alen, n);
>   	ret = fill_from_dev_buffer(scp, arr,
> -			   min_t(int, rlen, SDEBUG_MAX_TGTPGS_ARR_SZ));
> +			   min_t(u32, rlen, SDEBUG_MAX_TGTPGS_ARR_SZ));
>   	kfree(arr);
>   	return ret;
>   }
> 

