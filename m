Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7C9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 18:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2810761130
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 18:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbhJMSmm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 14:42:42 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:59798 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhJMSmm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 14:42:42 -0400
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id E45392EAA0E;
        Wed, 13 Oct 2021 14:40:37 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id gzAhiMfkuP1q; Wed, 13 Oct 2021 14:40:37 -0400 (EDT)
Received: from [192.168.48.23] (host-23-91-187-47.dyn.295.ca [23.91.187.47])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 4551A2EA530;
        Wed, 13 Oct 2021 14:40:37 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v2 resend 1/2] scsi:scsi_debug: Fix out-of-bound read in
 resp_readcap16
To:     Ye Bin <yebin10@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org
References: <20211013033913.2551004-1-yebin10@huawei.com>
 <20211013033913.2551004-2-yebin10@huawei.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <7f2622fe-de37-525a-5f93-961b510e1389@interlog.com>
Date:   Wed, 13 Oct 2021 14:40:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211013033913.2551004-2-yebin10@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-10-12 11:39 p.m., Ye Bin wrote:
> We got following warning when runing syzkaller:
> [ 3813.830724] sg_write: data in/out 65466/242 bytes for SCSI command 0x9e-- guessing data in;
> [ 3813.830724]    program syz-executor not setting count and/or reply_len properly
> [ 3813.836956] ==================================================================
> [ 3813.839465] BUG: KASAN: stack-out-of-bounds in sg_copy_buffer+0x157/0x1e0
> [ 3813.841773] Read of size 4096 at addr ffff8883cf80f540 by task syz-executor/1549
> [ 3813.846612] Call Trace:
> [ 3813.846995]  dump_stack+0x108/0x15f
> [ 3813.847524]  print_address_description+0xa5/0x372
> [ 3813.848243]  kasan_report.cold+0x236/0x2a8
> [ 3813.849439]  check_memory_region+0x240/0x270
> [ 3813.850094]  memcpy+0x30/0x80
> [ 3813.850553]  sg_copy_buffer+0x157/0x1e0
> [ 3813.853032]  sg_copy_from_buffer+0x13/0x20
> [ 3813.853660]  fill_from_dev_buffer+0x135/0x370
> [ 3813.854329]  resp_readcap16+0x1ac/0x280
> [ 3813.856917]  schedule_resp+0x41f/0x1630
> [ 3813.858203]  scsi_debug_queuecommand+0xb32/0x17e0
> [ 3813.862699]  scsi_dispatch_cmd+0x330/0x950
> [ 3813.863329]  scsi_request_fn+0xd8e/0x1710
> [ 3813.863946]  __blk_run_queue+0x10b/0x230
> [ 3813.864544]  blk_execute_rq_nowait+0x1d8/0x400
> [ 3813.865220]  sg_common_write.isra.0+0xe61/0x2420
> [ 3813.871637]  sg_write+0x6c8/0xef0
> [ 3813.878853]  __vfs_write+0xe4/0x800
> [ 3813.883487]  vfs_write+0x17b/0x530
> [ 3813.884008]  ksys_write+0x103/0x270
> [ 3813.886268]  __x64_sys_write+0x77/0xc0
> [ 3813.886841]  do_syscall_64+0x106/0x360
> [ 3813.887415]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> We can reproduce this issue with following syzkaller log:
> r0 = openat(0xffffffffffffff9c, &(0x7f0000000040)='./file0\x00', 0x26e1, 0x0)
> r1 = syz_open_procfs(0xffffffffffffffff, &(0x7f0000000000)='fd/3\x00')
> open_by_handle_at(r1, &(0x7f00000003c0)=ANY=[@ANYRESHEX], 0x602000)
> r2 = syz_open_dev$sg(&(0x7f0000000000), 0x0, 0x40782)
> write$binfmt_aout(r2, &(0x7f0000000340)=ANY=[@ANYBLOB="00000000deff000000000000000000000000000000000000000000000000000047f007af9e107a41ec395f1bded7be24277a1501ff6196a83366f4e6362bc0ff2b247f68a972989b094b2da4fb3607fcf611a22dd04310d28c75039d"], 0x126)
> 
> As in resp_readcap16 we get "int alloc_len" value -1104926854, and then pass
> huge arr_len to fill_from_dev_buffer, but arr is only has 32 bytes space. So
> lead to OOB in sg_copy_buffer.
> To solve this issue just define alloc_len with U32 type.
> 
> Signed-off-by: Ye Bin <yebin10@huawei.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> ---
>   drivers/scsi/scsi_debug.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 66f507469a31..be0440545744 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1856,7 +1856,7 @@ static int resp_readcap16(struct scsi_cmnd *scp,
>   {
>   	unsigned char *cmd = scp->cmnd;
>   	unsigned char arr[SDEBUG_READCAP16_ARR_SZ];
> -	int alloc_len;
> +	u32 alloc_len;
>   
>   	alloc_len = get_unaligned_be32(cmd + 10);
>   	/* following just in case virtual_gb changed */
> @@ -1885,7 +1885,7 @@ static int resp_readcap16(struct scsi_cmnd *scp,
>   	}
>   
>   	return fill_from_dev_buffer(scp, arr,
> -			    min_t(int, alloc_len, SDEBUG_READCAP16_ARR_SZ));
> +			    min_t(u32, alloc_len, SDEBUG_READCAP16_ARR_SZ));
>   }
>   
>   #define SDEBUG_MAX_TGTPGS_ARR_SZ 1412
> 

