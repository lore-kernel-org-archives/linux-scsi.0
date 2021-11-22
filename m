Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D1AC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 01:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhKVBjW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Nov 2021 20:39:22 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:45231 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhKVBjW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Nov 2021 20:39:22 -0500
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id A4B892EA40C;
        Sun, 21 Nov 2021 20:36:15 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id PwnOgINoB2YU; Sun, 21 Nov 2021 20:36:14 -0500 (EST)
Received: from [192.168.48.23] (host-45-58-208-241.dyn.295.ca [45.58.208.241])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 076CC2EA475;
        Sun, 21 Nov 2021 20:36:14 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: scsi_debug: sanity check block descriptor length in
 resp_mode_select
To:     George Kennedy <george.kennedy@oracle.com>,
        gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1637262208-28850-1-git-send-email-george.kennedy@oracle.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <f4897f94-4321-8a37-8371-8f68036c5f3a@interlog.com>
Date:   Sun, 21 Nov 2021 20:36:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1637262208-28850-1-git-send-email-george.kennedy@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-11-18 2:03 p.m., George Kennedy wrote:
> In resp_mode_select() sanity check the block descriptor len to avoid UAF.
> 
> BUG: KASAN: use-after-free in resp_mode_select+0xa4c/0xb40 drivers/scsi/scsi_debug.c:2509
> Read of size 1 at addr ffff888026670f50 by task scsicmd/15032
> 
> CPU: 1 PID: 15032 Comm: scsicmd Not tainted 5.15.0-01d0625 #15
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:107
>   print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:257
>   kasan_report.cold.14+0x7d/0x117 mm/kasan/report.c:443
>   __asan_report_load1_noabort+0x14/0x20 mm/kasan/report_generic.c:306
>   resp_mode_select+0xa4c/0xb40 drivers/scsi/scsi_debug.c:2509
>   schedule_resp+0x4af/0x1a10 drivers/scsi/scsi_debug.c:5483
>   scsi_debug_queuecommand+0x8c9/0x1e70 drivers/scsi/scsi_debug.c:7537
>   scsi_queue_rq+0x16b4/0x2d10 drivers/scsi/scsi_lib.c:1521
>   blk_mq_dispatch_rq_list+0xb9b/0x2700 block/blk-mq.c:1640
>   __blk_mq_sched_dispatch_requests+0x28f/0x590 block/blk-mq-sched.c:325
>   blk_mq_sched_dispatch_requests+0x105/0x190 block/blk-mq-sched.c:358
>   __blk_mq_run_hw_queue+0xe5/0x150 block/blk-mq.c:1762
>   __blk_mq_delay_run_hw_queue+0x4f8/0x5c0 block/blk-mq.c:1839
>   blk_mq_run_hw_queue+0x18d/0x350 block/blk-mq.c:1891
>   blk_mq_sched_insert_request+0x3db/0x4e0 block/blk-mq-sched.c:474
>   blk_execute_rq_nowait+0x16b/0x1c0 block/blk-exec.c:63
>   sg_common_write.isra.18+0xeb3/0x2000 drivers/scsi/sg.c:837
>   sg_new_write.isra.19+0x570/0x8c0 drivers/scsi/sg.c:775
>   sg_ioctl_common+0x14d6/0x2710 drivers/scsi/sg.c:941
>   sg_ioctl+0xa2/0x180 drivers/scsi/sg.c:1166
>   __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:52
>   do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:50
>   entry_SYSCALL_64_after_hwframe+0x44/0xae arch/x86/entry/entry_64.S:113
> 
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: George Kennedy <george.kennedy@oracle.com>

So this patch makes sure we don't read outside the parameter data (at least
for the 0th byte of the mode page) so that is an improvement. It could be
stronger if it took into account the size of the mode page which is copied
inside the following switch.

But I can't see how that leads to use after free from KASAN. Hmm, I suppose
any out-of-bounds read could be reported as a use after free. It would be
useful if KASAN differentiated the two cases.

Anyway, the patch can't hurt.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 1d0278d..51e3b57 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -2499,11 +2499,11 @@ static int resp_mode_select(struct scsi_cmnd *scp,
>   			    __func__, param_len, res);
>   	md_len = mselect6 ? (arr[0] + 1) : (get_unaligned_be16(arr + 0) + 2);
>   	bd_len = mselect6 ? arr[3] : get_unaligned_be16(arr + 6);
> -	if (md_len > 2) {
> +	off = bd_len + (mselect6 ? 4 : 8);
> +	if (md_len > 2 || off >= res) {
>   		mk_sense_invalid_fld(scp, SDEB_IN_DATA, 0, -1);
>   		return check_condition_result;
>   	}
> -	off = bd_len + (mselect6 ? 4 : 8);
>   	mpage = arr[off] & 0x3f;
>   	ps = !!(arr[off] & 0x80);
>   	if (ps) {
> 

