Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD541C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 13:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99C316109F
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 13:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhKBNWY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 09:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhKBNWY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Nov 2021 09:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0F0D61076;
        Tue,  2 Nov 2021 13:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635859189;
        bh=/FbBvuDIqll1nY6ugZ5ISgYPcBEZfDJ7GeMZ3M5GhHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h4Wvcp09OP+Tu6ErrIaJU6guA5PwAmGCvWPd5bK0KVicBz95eKeD+GCd1Qzh8NscB
         5QhdK/N9kt9B8Znc4P/HjUJNb5UvcV4i1XzgU9FHVXqXfja22qJeijTLzGZwEobOza
         vBflqpW6QuC/JCOM3VU+fvukveRge59AJgfvhDB4=
Date:   Tue, 2 Nov 2021 14:19:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH] scsi: scsi_debug: fix type in min_t to avoid stack OOB
Message-ID: <YYE68lDOjX9aE5yX@kroah.com>
References: <1635857278-29246-1-git-send-email-george.kennedy@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1635857278-29246-1-git-send-email-george.kennedy@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 02, 2021 at 07:47:58AM -0500, George Kennedy wrote:
> Change min_t() to use type "unsigned int" instead of type "int" to
> avoid stack out of bounds. With min_t() type "int" the values get
> sign extended and the larger value gets used causing stack out of bounds.
> 
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
> 
> BUG: KASAN: stack-out-of-bounds in memcpy include/linux/fortify-string.h:191 [inline]
> BUG: KASAN: stack-out-of-bounds in sg_copy_buffer+0x1de/0x240 lib/scatterlist.c:976
> Read of size 127 at addr ffff888072607128 by task syz-executor.7/18707
> 
> CPU: 1 PID: 18707 Comm: syz-executor.7 Not tainted 5.15.0-syzk #1
> Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7860+a7792d29 04/01/2014
> Call Trace:
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
>  print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:256
>  __kasan_report mm/kasan/report.c:442 [inline]
>  kasan_report.cold.14+0x7d/0x117 mm/kasan/report.c:459
>  check_region_inline mm/kasan/generic.c:183 [inline]
>  kasan_check_range+0x1a3/0x210 mm/kasan/generic.c:189
>  memcpy+0x23/0x60 mm/kasan/shadow.c:65
>  memcpy include/linux/fortify-string.h:191 [inline]
>  sg_copy_buffer+0x1de/0x240 lib/scatterlist.c:976
>  sg_copy_from_buffer+0x33/0x40 lib/scatterlist.c:1000
>  fill_from_dev_buffer.part.34+0x82/0x130 drivers/scsi/scsi_debug.c:1162
>  fill_from_dev_buffer drivers/scsi/scsi_debug.c:1888 [inline]
>  resp_readcap16+0x365/0x3b0 drivers/scsi/scsi_debug.c:1887
>  schedule_resp+0x4d8/0x1a70 drivers/scsi/scsi_debug.c:5478
>  scsi_debug_queuecommand+0x8c9/0x1ec0 drivers/scsi/scsi_debug.c:7533
>  scsi_dispatch_cmd drivers/scsi/scsi_lib.c:1520 [inline]
>  scsi_queue_rq+0x16b0/0x2d40 drivers/scsi/scsi_lib.c:1699
>  blk_mq_dispatch_rq_list+0xb9b/0x2700 block/blk-mq.c:1639
>  __blk_mq_sched_dispatch_requests+0x28f/0x590 block/blk-mq-sched.c:325
>  blk_mq_sched_dispatch_requests+0x105/0x190 block/blk-mq-sched.c:358
>  __blk_mq_run_hw_queue+0xe5/0x150 block/blk-mq.c:1761
>  __blk_mq_delay_run_hw_queue+0x4f8/0x5c0 block/blk-mq.c:1838
>  blk_mq_run_hw_queue+0x18d/0x350 block/blk-mq.c:1891
>  blk_mq_sched_insert_request+0x3db/0x4e0 block/blk-mq-sched.c:474
>  blk_execute_rq_nowait+0x16b/0x1c0 block/blk-exec.c:62
>  sg_common_write.isra.18+0xeb3/0x2000 drivers/scsi/sg.c:836
>  sg_new_write.isra.19+0x570/0x8c0 drivers/scsi/sg.c:774
>  sg_ioctl_common+0x14d6/0x2710 drivers/scsi/sg.c:939
>  sg_ioctl+0xa2/0x180 drivers/scsi/sg.c:1165
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:874 [inline]
>  __se_sys_ioctl fs/ioctl.c:860 [inline]
>  __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae

All of that needs to go above the signed-off-by lines, they need to be
last in the changelog text.

thanks,

greg k-h
