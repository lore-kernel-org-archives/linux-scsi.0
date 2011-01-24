From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: Crash in 2.6.37
Date: Mon, 24 Jan 2011 07:46:44 +0100
Message-ID: <4D3D2054.1060905@grumpydevil.homelinux.org>
References: <4D3C05E9.9030105@grumpydevil.homelinux.org> <1295828488.8278.33.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tritonia.xxlwebhosting.nl ([81.4.88.63]:47983 "EHLO
	tritonia.xxlwebhosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab1AXGqv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2011 01:46:51 -0500
In-Reply-To: <1295828488.8278.33.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

On 01/24/2011 01:21 AM, James Bottomley wrote:
> On Sun, 2011-01-23 at 11:41 +0100, Rudy Zijlstra wrote:
>    
>> Dears,
>>
>> I got the following crash by:
>> - cp several G onto a raid 5 on a Marvell 88SE6480//// based controller
>> while also doing
>> - cp * ../test/ on the same raid.
>>
>> I strongly suspect mvsas to be the cause
>>      
> I've got to ask why?
>    
cause the 88SE6480 has been giving grief for a long time, and i was 
loading that one specifically.
you may well be right (i do not read crash info i fear), but a bit 
strange to have NFS crash when nfs was not much used at that moment

Rudy
>    
>> Please keep me on cc, as i am not subscribed to linux-scsi
>>
>> Thanks,
>>
>>
>> Rudy
>>
>> The crash:
>>
>> [ 2821.392849] BUG: unable to handle kernel paging request at
>> 000000000000bbbb
>> [ 2821.393697] IP: [<ffffffff815a1b5c>] cache_revisit_request+0xab/0x105
>> [ 2821.393697] PGD 78e4d067 PUD 78c9a067 PMD 0
>> [ 2821.393697] Oops: 0000 [#1] SMP
>> [ 2821.393697] last sysfs file:
>> /sys/bus/pci/drivers/megaraid_sas/release_date
>> [ 2821.393697] CPU 2
>> [ 2821.393697] Modules linked in: parport_pc parport rc_tt_1500
>> ir_lirc_codec lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder
>> budget_ci lnbp21 budget_core saa7146 ir_rc5_decoder ir_nec_decoder
>> ttpci_eeprom tda1004x ir_core stb6100 tda10023 stv0297 stb0899 stv0299
>> dvb_core tda827x floppy
>> [ 2821.393697]
>> [ 2821.393697] Pid: 1105, comm: rpc.mountd Not tainted 2.6.37 #1
>> X7SB4/E/X7SB4/E
>> [ 2821.393697] RIP: 0010:[<ffffffff815a1b5c>]  [<ffffffff815a1b5c>]
>> cache_revisit_request+0xab/0x105
>> [ 2821.393697] RSP: 0018:ffff880069e45c18  EFLAGS: 00010206
>> [ 2821.393697] RAX: 000000000000bbbb RBX: ffff880069e45c18 RCX:
>> 000000000000bbbb
>> [ 2821.393697] RDX: fffffffc4003d6e4 RSI: 0000000000000000 RDI:
>> ffffffff81c73774
>> [ 2821.393697] RBP: ffff880069e45c38 R08: 00000000000000d0 R09:
>> 0000000000000000
>> [ 2821.393697] R10: 0000000000000000 R11: e000000000000000 R12:
>> ffff88007adc9f00
>> [ 2821.393697] R13: ffff88007adc9f00 R14: ffff880069e7ee00 R15:
>> ffff88007adc9f20
>> [ 2821.393697] FS:  00007f0247a2a740(0000) GS:ffff88007fd00000(0000)
>> knlGS:0000000000000000
>> [ 2821.393697] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 2821.393697] CR2: 000000000000bbbb CR3: 000000007917a000 CR4:
>> 00000000000406e0
>> [ 2821.393697] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> [ 2821.393697] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> [ 2821.393697] Process rpc.mountd (pid: 1105, threadinfo
>> ffff880069e44000, task ffff880072408750)
>> [ 2821.393697] Stack:
>> [ 2821.393697]  ffff880069e45c18 ffff880069e45c18 ffff88007adc9f00
>> ffffffff81a39860
>> [ 2821.393697] PGD 78e4d067 PUD 78c9a067 PMD 0
>> [ 2821.393697] Oops: 0000 [#1] SMP
>> [ 2821.393697] last sysfs file:
>> /sys/bus/pci/drivers/megaraid_sas/release_date
>> [ 2821.393697] CPU 2
>> [ 2821.393697] Modules linked in: parport_pc parport rc_tt_1500
>> ir_lirc_codec lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder
>> budget_ci lnbp21 budget_core saa7146 ir_rc5_decoder ir_nec_decoder
>> ttpci_eeprom tda1004x ir_core stb6100 tda10023 stv0297 stb0899 stv0299
>> dvb_core tda827x floppy
>> [ 2821.393697]
>> [ 2821.393697] Pid: 1105, comm: rpc.mountd Not tainted 2.6.37 #1
>> X7SB4/E/X7SB4/E
>> [ 2821.393697] RIP: 0010:[<ffffffff815a1b5c>]  [<ffffffff815a1b5c>]
>> cache_revisit_request+0xab/0x105
>>      
> This says the bad deref occurred in the sunrpc authentication cache.
> Nothing at all in the trace implicates mvsas ... in fact nothing even
> remotely relates to it at all.  It really looks like an NFS problem.
>
> James
>
>
>    
>> [ 2821.393697] RSP: 0018:ffff880069e45c18  EFLAGS: 00010206
>> [ 2821.393697] RAX: 000000000000bbbb RBX: ffff880069e45c18 RCX:
>> 000000000000bbbb
>> [ 2821.393697] RDX: fffffffc4003d6e4 RSI: 0000000000000000 RDI:
>> ffffffff81c73774
>> [ 2821.393697] RBP: ffff880069e45c38 R08: 00000000000000d0 R09:
>> 0000000000000000
>> [ 2821.393697] R10: 0000000000000000 R11: e000000000000000 R12:
>> ffff88007adc9f00
>> [ 2821.393697] R13: ffff88007adc9f00 R14: ffff880069e7ee00 R15:
>> ffff88007adc9f20
>> [ 2821.393697] FS:  00007f0247a2a740(0000) GS:ffff88007fd00000(0000)
>> knlGS:0000000000000000
>> [ 2821.393697] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 2821.393697] CR2: 000000000000bbbb CR3: 000000007917a000 CR4:
>> 00000000000406e0
>> [ 2821.393697] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> [ 2821.393697] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> [ 2821.393697] Process rpc.mountd (pid: 1105, threadinfo
>> ffff880069e44000, task ffff880072408750)
>> [ 2821.393697] Stack:
>> [ 2821.393697]  ffff880069e45c18 ffff880069e45c18 ffff88007adc9f00
>> ffffffff81a39860
>> [ 2821.393697]  ffff880069e45c58 ffffffff815a2698 ffffffff81a39860
>> ffff880069e45d08
>> [ 2821.393697]  ffff880069e45ca8 ffffffff815a2f80 ffffffff81c43df8
>> 0000006781c43df8
>> [ 2821.393697] Call Trace:
>> [ 2821.393697]  [<ffffffff815a2698>] cache_fresh_unlocked+0x1e/0x2e
>> [ 2821.393697]  [<ffffffff815a2f80>] sunrpc_cache_update+0x15d/0x17d
>> [ 2821.393697]  [<ffffffff811aadb8>] svc_export_update+0x29/0x2e
>> [ 2821.393697]  [<ffffffff811ab2a4>] svc_export_parse+0x4e7/0x586
>> [ 2821.393697]  [<ffffffff815a158d>] cache_do_downcall+0x3b/0x4c
>> [ 2821.393697]  [<ffffffff815a1e1b>] cache_write+0xaf/0x129
>> [ 2821.393697]  [<ffffffff815a1ec8>] cache_write_procfs+0x19/0x1b
>> [ 2821.393697]  [<ffffffff81126ac0>] proc_reg_write+0x87/0xa6
>> [ 2821.393697]  [<ffffffff8123df1d>] ? security_file_permission+0x29/0x2e
>> [ 2821.393697]  [<ffffffff815a1eaf>] ? cache_write_procfs+0x0/0x1b
>> [ 2821.393697]  [<ffffffff810de19f>] vfs_write+0xa9/0x105
>> [ 2821.393697]  [<ffffffff810de2b1>] sys_write+0x45/0x69
>> [ 2821.393697]  [<ffffffff81002a52>] system_call_fastpath+0x16/0x1b
>> [ 2821.393697] Code: 4c 89 47 08 49 89 38 48 89 50 10 48 89 50 18 48 8b
>> 7d e0 48 89 57 08 48 89 78 10 48 89 58 18 48 89 55 e0 48 89 c8 48 85 c0
>> 74 0b<48>  8b 08 4c 39 60 20 75 ef eb 93 89 35 a3 24 6d 00 48 c7 c7 74
>> [ 2821.393697] RIP  [<ffffffff815a1b5c>] cache_revisit_request+0xab/0x105
>> [ 2821.393697]  RSP<ffff880069e45c18>
>> [ 2821.393697] CR2: 000000000000bbbb
>> [ 2821.716219] ---[ end trace a4730c6e3ffc5077 ]---
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>      
>
>    

