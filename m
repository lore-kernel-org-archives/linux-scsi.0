Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20165C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 16:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3CA161220
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 16:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244115AbhDLQmL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 12:42:11 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:52192 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343871AbhDLQgU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Apr 2021 12:36:20 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 277182EA14C;
        Mon, 12 Apr 2021 12:36:01 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 7+IC5J2S2mQf; Mon, 12 Apr 2021 12:16:51 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id A76CF2EA12E;
        Mon, 12 Apr 2021 12:35:59 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: KMSAN: kernel-infoleak in sg_scsi_ioctl
To:     Hao Sun <sunhao.th@gmail.com>, axboe@kernel.dk, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <CACkBjsYu87czSrJoW+NQ9Vykm1byQ5u-eOP=a1ze+PojCsidfA@mail.gmail.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <e70ba561-dd55-c38d-62a4-dd2e0603be10@interlog.com>
Date:   Mon, 12 Apr 2021 12:35:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACkBjsYu87czSrJoW+NQ9Vykm1byQ5u-eOP=a1ze+PojCsidfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
See below.

On 2021-04-12 9:02 a.m., Hao Sun wrote:
> Hi
> 
> When using Healer(https://github.com/SunHao-0/healer/tree/dev) to fuzz
> the Linux kernel, I found the following bug report.
> 
> commit:   4ebaab5fb428374552175aa39832abf5cedb916a
> version:   linux 5.12
> git tree:    kmsan
> kernel config and full log can be found in the attached file.
> 
> =====================================================
> BUG: KMSAN: kernel-infoleak in kmsan_copy_to_user+0x9c/0xb0
> mm/kmsan/kmsan_hooks.c:249
> CPU: 2 PID: 23939 Comm: executor Not tainted 5.12.0-rc6+ #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
>   __dump_stack lib/dump_stack.c:79 [inline]
>   dump_stack+0x1ff/0x275 lib/dump_stack.c:120
>   kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
>   kmsan_internal_check_memory+0x48c/0x520 mm/kmsan/kmsan.c:437
>   kmsan_copy_to_user+0x9c/0xb0 mm/kmsan/kmsan_hooks.c:249
>   instrument_copy_to_user ./include/linux/instrumented.h:121 [inline]
>   _copy_to_user+0x112/0x1d0 lib/usercopy.c:33
>   copy_to_user ./include/linux/uaccess.h:209 [inline]
>   sg_scsi_ioctl+0xfa9/0x1180 block/scsi_ioctl.c:507
>   sg_ioctl_common+0x2713/0x4930 drivers/scsi/sg.c:1108
>   sg_ioctl+0x166/0x2d0 drivers/scsi/sg.c:1162
>   vfs_ioctl fs/ioctl.c:48 [inline]
>   __do_sys_ioctl fs/ioctl.c:753 [inline]
>   __se_sys_ioctl+0x2c2/0x400 fs/ioctl.c:739
>   __x64_sys_ioctl+0x4a/0x70 fs/ioctl.c:739
>   do_syscall_64+0xa2/0x120 arch/x86/entry/common.c:48
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x47338d
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe31ab90c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 000000000059c128 RCX: 000000000047338d
> RDX: 0000000020000040 RSI: 0000000000000001 RDI: 0000000000000003
> RBP: 00000000004e8e5d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c128
> R13: 00007ffe2284af2f R14: 00007ffe2284b0d0 R15: 00007fe31ab90dc0
> Uninit was stored to memory at:
>   kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
>   kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
>   kmsan_memcpy_memmove_metadata+0x25b/0x290 mm/kmsan/kmsan.c:226
>   kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:246
>   __msan_memcpy+0x46/0x60 mm/kmsan/kmsan_instr.c:110
>   bio_copy_kern_endio_read+0x3ee/0x560 block/blk-map.c:443
>   bio_endio+0xa1a/0xcc0 block/bio.c:1453
>   req_bio_endio block/blk-core.c:265 [inline]
>   blk_update_request+0xd4f/0x2190 block/blk-core.c:1456
>   scsi_end_request+0x111/0xc50 drivers/scsi/scsi_lib.c:570
>   scsi_io_completion+0x276/0x2840 drivers/scsi/scsi_lib.c:970
>   scsi_finish_command+0x6fc/0x720 drivers/scsi/scsi.c:214
>   scsi_softirq_done+0x205/0xa40 drivers/scsi/scsi_lib.c:1450
>   blk_complete_reqs block/blk-mq.c:576 [inline]
>   blk_done_softirq+0x133/0x1e0 block/blk-mq.c:581
>   __do_softirq+0x271/0x782 kernel/softirq.c:345
> 
> Uninit was created at:
>   kmsan_save_stack_with_flags+0x3c/0x90
>   kmsan_alloc_page+0xc4/0x1b0
>   __alloc_pages_nodemask+0xdb0/0x54a0
>   alloc_pages_current+0x671/0x990
>   blk_rq_map_kern+0xb8e/0x1310
>   sg_scsi_ioctl+0xc94/0x1180
>   sg_ioctl_common+0x2713/0x4930
>   sg_ioctl+0x166/0x2d0
>   __se_sys_ioctl+0x2c2/0x400
>   __x64_sys_ioctl+0x4a/0x70
>   do_syscall_64+0xa2/0x120
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Byte 0 of 1 is uninitialized
>   Memory access of size 1 starts at ffff99e033fb9360
>   Data copied to user address 0000000020000048
> 
> The following system call sequence (Syzlang format) can reproduce the crash:
> # {Threaded:false Collide:false Repeat:false RepeatTimes:0 Procs:1
> Slowdown:1 Sandbox:none Fault:false FaultCall:-1 FaultNth:0 Leak:false
> NetInjection:true NetDevices:true NetReset:false Cgroups:false
> BinfmtMisc:true CloseFDs:true KCSAN:false DevlinkPCI:true USB:true
> VhciInjection:true Wifi:true IEEE802154:true Sysctl:true
> UseTmpDir:true HandleSegv:true Repro:false Trace:false}
> 
> r0 = syz_open_dev$sg(&(0x7f0000000000)='/dev/sg#\x00', 0x0, 0x20000094b402)
> ioctl$SG_GET_LOW_DMA(r0, 0x227a, &(0x7f0000000040))
> ioctl$SCSI_IOCTL_SEND_COMMAND(r0, 0x1, &(0x7f0000000040)={0x0, 0x1, 0x1})

Since the code opens a sg device node then the sg driver, which is a
pass-through driver, is invoked. However instead of using sg's pass-through
facilities, that call to ioctl(SCSI_IOCTL_SEND_COMMAND) is invoking the
long deprecated SCSI mid-level pass-through. So if there is infoleak bug
you should flag sg_scsi_ioctl() in block/scsi_ioctl.c. See the notes
associated with that function which imply it can't be protected from
certain types of abuse due to its interface design. That is why it is
deprecated. Also the equivalent of root permissions are required
to execute those functions.

That code looks strange, ioctl(SG_GET_LOW_DMA) reads the
host->unchecked_isa_dma value (now always 0 ??) into an int at
0x7f0000000040. That same address is then used for the struct
scsi_ioctl_command object passed to ioctl(SCSI_IOCTL_SEND_COMMAND).

Looking at the data passed to SCSI_IOCTL_SEND_COMMAND in_len=0
(data-out length in bytes), out_len=1 and, if 2 zero bytes follow
what is shown, that is a (SCSI-2) REZERO UNIT command which returns
no data. Now the BUG print-out seems to come from this line:
     copy_to_user(sic->data, buffer, out_len);

but buffer was kzalloc-ed and nothing was (should have been) DMA-ed
into it. So where is the problem?

Since the bio/block code isn't often asked to handle a block size
of 1 byte, this addition may strengthen things:
	if ((in_len % 512) != 0 || (out_len % 512) != 0)
		return -EINVAL;

Since bytes=max(in_len, out_len) then that can be simplified to:
	if ((bytes % 512) != 0)
		return -EINVAL;

Doug Gilbert

> Using syz-execprog can run this reproduction program directly:
>   ./syz-execprog -repeat 0 -procs 1 -slowdown 1 -enable tun -enable
> netdev -enable binfmt-misc -enable close_fds -enable devlinkpci
> -enable usb -enable vhci -enable wifi -enable ieee802154 -enable
> sysctl repro.prog
> 

