Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B04C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 17:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36E2161186
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 17:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhKDRwq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:52:46 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:57370 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbhKDRwq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 13:52:46 -0400
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id EC5CC2EA404;
        Thu,  4 Nov 2021 13:50:06 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id 0npWVEXymDwo; Thu,  4 Nov 2021 13:50:06 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-208-241.dyn.295.ca [45.58.208.241])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 303882EA048;
        Thu,  4 Nov 2021 13:50:06 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: scsi_debug: fix return checks for kcalloc
To:     George Kennedy <george.kennedy@oracle.com>,
        gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
References: <1635966102-29320-1-git-send-email-george.kennedy@oracle.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <18e67614-3d59-d057-4b15-b41d0c8e82d2@interlog.com>
Date:   Thu, 4 Nov 2021 13:50:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1635966102-29320-1-git-send-email-george.kennedy@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-11-03 3:01 p.m., George Kennedy wrote:
> Change return checks from kcalloc() to now check for NULL and
> ZERO_SIZE_PTR using the ZERO_OR_NULL_PTR macro or the following
> crash can occur if ZERO_SIZE_PTR indicator is returned.
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
> ---
>   drivers/scsi/scsi_debug.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 40b473e..222e985 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3909,7 +3909,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
>   		return ret;
>   	dnum = 2 * num;
>   	arr = kcalloc(lb_size, dnum, GFP_ATOMIC);
> -	if (NULL == arr) {
> +	if (ZERO_OR_NULL_PTR(arr)) {
>   		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
>   				INSUFF_RES_ASCQ);
>   		return check_condition_result;
> @@ -4265,7 +4265,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   		return ret;

This is related to a field in a SCSI command (e.g. a READ) that dictates
the size of the data-in transfer. In all cases that I can think of the
standards say it is _not_ an error if that field is zero. So it is
incorrect to report an ILLEGAL_REQUEST in that case, those commands
should do nothing (apart from check the other fields (e.g. for an out of
range starting LBA)) and return GOOD status.

So this patch is incorrect.

Doug Gilbert

>   
>   	arr = kcalloc(lb_size, vnum, GFP_ATOMIC);
> -	if (!arr) {
> +	if (ZERO_OR_NULL_PTR(arr)) {
>   		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
>   				INSUFF_RES_ASCQ);
>   		return check_condition_result;
> @@ -4334,7 +4334,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>   			    max_zones);
>   
>   	arr = kcalloc(RZONES_DESC_HD, alloc_len, GFP_ATOMIC);
> -	if (!arr) {
> +	if (ZERO_OR_NULL_PTR(arr)) {
>   		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
>   				INSUFF_RES_ASCQ);
>   		return check_condition_result;
> 

