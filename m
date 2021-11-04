Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F9B1C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 22:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 713816112D
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 22:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhKDW6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 18:58:46 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:45219 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhKDW6p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 18:58:45 -0400
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 5AB232EAA21;
        Thu,  4 Nov 2021 18:56:06 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id wiQgyiN6lzTp; Thu,  4 Nov 2021 18:56:05 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-208-241.dyn.295.ca [45.58.208.241])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 80A6F2EAA1D;
        Thu,  4 Nov 2021 18:56:05 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v2] scsi: scsi_debug: don't call kcalloc if size arg is
 zero
To:     George Kennedy <george.kennedy@oracle.com>,
        gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, joe@perches.com
References: <1636056397-13151-1-git-send-email-george.kennedy@oracle.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <2f888f0e-bdc9-da07-bd63-b8bd6b591ec3@interlog.com>
Date:   Thu, 4 Nov 2021 18:56:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1636056397-13151-1-git-send-email-george.kennedy@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-11-04 4:06 p.m., George Kennedy wrote:
> If the size arg to kcalloc() is zero, it returns ZERO_SIZE_PTR.
> Because of that, for a following NULL pointer check to work
> on the returned pointer, kcalloc() must not be called with the
> size arg equal to zero. Return early without error before the
> kcalloc() call if size arg is zero.
> 
> BUG: KASAN: null-ptr-deref in memcpy include/linux/fortify-string.h:191 [inline]
> BUG: KASAN: null-ptr-deref in sg_copy_buffer+0x138/0x240 lib/scatterlist.c:974
> Write of size 4 at addr 0000000000000010 by task syz-executor.1/22789
> 
> CPU: 1 PID: 22789 Comm: syz-executor.1 Not tainted 5.15.0-syzk #1
> Hardware name: Red Hat KVM, BIOS 1.13.0-2
> Call Trace:
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
>   __kasan_report mm/kasan/report.c:446 [inline]
>   kasan_report.cold.14+0x112/0x117 mm/kasan/report.c:459
>   check_region_inline mm/kasan/generic.c:183 [inline]
>   kasan_check_range+0x1a3/0x210 mm/kasan/generic.c:189
>   memcpy+0x3b/0x60 mm/kasan/shadow.c:66
>   memcpy include/linux/fortify-string.h:191 [inline]
>   sg_copy_buffer+0x138/0x240 lib/scatterlist.c:974
>   do_dout_fetch drivers/scsi/scsi_debug.c:2954 [inline]
>   do_dout_fetch drivers/scsi/scsi_debug.c:2946 [inline]
>   resp_verify+0x49e/0x930 drivers/scsi/scsi_debug.c:4276
>   schedule_resp+0x4d8/0x1a70 drivers/scsi/scsi_debug.c:5478
>   scsi_debug_queuecommand+0x8c9/0x1ec0 drivers/scsi/scsi_debug.c:7533
>   scsi_dispatch_cmd drivers/scsi/scsi_lib.c:1520 [inline]
>   scsi_queue_rq+0x16b0/0x2d40 drivers/scsi/scsi_lib.c:1699
>   blk_mq_dispatch_rq_list+0xb9b/0x2700 block/blk-mq.c:1639
>   __blk_mq_sched_dispatch_requests+0x28f/0x590 block/blk-mq-sched.c:325
>   blk_mq_sched_dispatch_requests+0x105/0x190 block/blk-mq-sched.c:358
>   __blk_mq_run_hw_queue+0xe5/0x150 block/blk-mq.c:1761
>   __blk_mq_delay_run_hw_queue+0x4f8/0x5c0 block/blk-mq.c:1838
>   blk_mq_run_hw_queue+0x18d/0x350 block/blk-mq.c:1891
>   blk_mq_sched_insert_request+0x3db/0x4e0 block/blk-mq-sched.c:474
>   blk_execute_rq_nowait+0x16b/0x1c0 block/blk-exec.c:62
>   blk_execute_rq+0xdb/0x360 block/blk-exec.c:102
>   sg_scsi_ioctl drivers/scsi/scsi_ioctl.c:621 [inline]
>   scsi_ioctl+0x8bb/0x15c0 drivers/scsi/scsi_ioctl.c:930
>   sg_ioctl_common+0x172d/0x2710 drivers/scsi/sg.c:1112
>   sg_ioctl+0xa2/0x180 drivers/scsi/sg.c:1165
>   vfs_ioctl fs/ioctl.c:51 [inline]
>   __do_sys_ioctl fs/ioctl.c:874 [inline]
>   __se_sys_ioctl fs/ioctl.c:860 [inline]
>   __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: George Kennedy <george.kennedy@oracle.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

---

Reference: sbc5r01.pdf [at t10.org] for VERIFY(10) 5.36 page 212:

"A VERIFICATION LENGTH field set to zero specifies that no logical
blocks shall be transferred or verified. This condition shall not
be considered an error."


NVMe gets around this with "zero-based" counts (i.e. 0 means transfer
and Verify 1 block!). IMO the cure is worse than the disease.
For example you have uint16_t for the count of blocks to Verify, do
some calculation for the count but forget to check the answer for
0. Next you build the NVMe Verify command and subtract 1 from count and
place it in the Verify NLB field (cause its "0-based"). The calculation
did yield 0, so after the subtraction of 1, you pass 0xffff to the NLB
field. Why does that Verify command take so long?

> ---
>   drivers/scsi/scsi_debug.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 40b473e..3e97efc 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4258,6 +4258,8 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   		mk_sense_invalid_opcode(scp);
>   		return check_condition_result;
>   	}
> +	if (vnum == 0)
> +		return 0;	/* not an error */
>   	a_num = is_bytchk3 ? 1 : vnum;
>   	/* Treat following check like one for read (i.e. no write) access */
>   	ret = check_device_access_params(scp, lba, a_num, false);
> @@ -4321,6 +4323,8 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>   	}
>   	zs_lba = get_unaligned_be64(cmd + 2);
>   	alloc_len = get_unaligned_be32(cmd + 10);
> +	if (alloc_len == 0)
> +		return 0;	/* not an error */
>   	rep_opts = cmd[14] & 0x3f;
>   	partial = cmd[14] & 0x80;
>   
> 

