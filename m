From: "Sabuj Pattanayek" <sabujp@gmail.com>
Subject: Re: kernel exception in Fusion MPT base driver 3.04.06 (linux-2.6.24.3)
Date: Wed, 19 Mar 2008 18:36:05 -0500
Message-ID: <e64671580803191636r59d0cd0ar93692dc50d852be7@mail.gmail.com>
References: <e64671580803171629g534ebf34l89adbb14bb985dc7@mail.gmail.com>
	 <20080318002502.852d0f12.akpm@linux-foundation.org>
	 <47DFFE90.8050808@sgi.com>
	 <e64671580803191411r7ca57fffu885e173f9b3285d0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:14631 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbYCSXgK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2008 19:36:10 -0400
Received: by fg-out-1718.google.com with SMTP id l27so554241fgb.17
        for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2008 16:36:05 -0700 (PDT)
In-Reply-To: <e64671580803191411r7ca57fffu885e173f9b3285d0@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

Hi,

>  >  Does the exception happen every time?

Well, I just got the kernel to boot all the way with both 2.6.24.3 and
2.6.20 accidentally by changing the FC host side settings on all the
target infortrend eonstor RAID boxes to point-to-point from loop. All
the targets and initiators are connected to a QLogic 5600 FC switch
and zones have been setup such that the initiators can see only the
targets. This active zoning has not changed during testing.

At the time I was actually testing the eonstor boxes outside the FC
switch by connecting them directly to another Apple Xserve running OS
X, which is using the same LSI FC HBA that I reported in my first post
regarding this issue. After testing that each target (LUN) could be
seen by the LSI FC HBA in the OSX Xserve, I reconnected the targets
back into the switch. Since the Linux Xserve was endlessly rebooting
itself after each kernel panic, to my surprise I had found that it
completed booting! All targets and LUNs can be seen under "cat
/proc/scsi/scsi".

To confirm that the loop host side setting was causing the problem, I
set one of the eonstor's back to loop and reset it. Immediately after
the eonstor came up it caused a kernel panic on the Linux Xserve
(which was already booted into the OS). This was the output on the
console:

porpoise login: Unrecoverable FP Unavailable Exception 800 at d000000000073da0
Oops: Unrecoverable FP Unavailable Exception, sig: 6 [#1]

Modules linked in: mptfc mptscsih mptbase
NIP: D000000000073DA0 LR: D0000000000675BC CTR: D000000000073DA0
REGS: c00000000076b4e0 TRAP: 0800   Not tainted  (2.6.20)
MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 48004048  XER: 00000000
TASK = c000000000671420[0] 'swapper' THREAD: c000000000768000
GPR00: D000000000073DA0 C00000000076B760 D0000000000803D0 C00000000FA46000
GPR04: C000000001B81310 0000000000000053 C00000000076B833 9000000000049032
GPR08: C000000001B82800 D0000000000782F8 0000000000000000 0000000000000000
GPR12: D00000000006A2F0 C000000000671C80 000000000023FB28 C00000000058C6D8
GPR16: C000000000664DB0 000000000023FB20 C00000000058B380 C00000000058C5E8
GPR20: C000000000664B40 C00000000058B130 0000000000000001 000000000023FB30
GPR24: C00000000058C6D8 0000000000000006 C00000000FA46000 C000000001B81310
GPR28: D000000000071AD0 0000000000000000 D000000000078B80 D000000000071B40
NIP [D000000000073DA0] .mptfc_event_process+0x0/0xc0 [mptfc]
LR [D0000000000675BC] .mpt_base_reply+0x4bc/0xdd0 [mptbase]
Call Trace:
[C00000000076B760] [D0000000000672BC] .mpt_base_reply+0x1bc/0xdd0
[mptbase] (unreliable)
[C00000000076B890] [D0000000000680FC] .mpt_interrupt+0x22c/0x770 [mptbase]
[C00000000076B940] [C00000000006CAC0] .handle_IRQ_event+0x70/0x100
[C00000000076B9E0] [C00000000006E76C] .handle_fasteoi_irq+0x8c/0x120
[C00000000076BA70] [C00000000000C788] .do_IRQ+0xe8/0x120
[C00000000076BAF0] [C0000000000041DC] hardware_interrupt_entry+0x18/0x1c
--- Exception: 501 at .cpu_idle+0xd8/0x140
    LR = .cpu_idle+0xd8/0x140
[C00000000076BDE0] [C000000000011934] .cpu_idle+0x124/0x140 (unreliable)
[C00000000076BE70] [C000000000009394] .rest_init+0x34/0x50
[C00000000076BEF0] [C00000000062D910] .start_kernel+0x260/0x300
[C00000000076BF90] [C000000000008460] .start_here_common+0x54/0xf4
Instruction dump:
c0000001 36947878 c0000001 3694789c c0000001 369478c0 c0000001 369478e4
c0000001 36947908 c0000001 3694792c <c0000001> 36947950 c0000001 36947974
 <0>Kernel panic - not syncing: Fatal exception in interrupt
 <0>Rebooting in 180 seconds..

I set the FC host side connection back to point-to-point and the Linux
Xserve was again able to boot into the OS. In any case, don't think
this is normal because the OSX XServe doesn't panic if it sees targets
set to loop.

Thanks,
Sabuj Pattanayek
