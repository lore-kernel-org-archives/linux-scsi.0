From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Kernel Panic in MPT SAS on 2.6.24 (and 2.6.23.14, 2.6.23.9)
Date: Wed, 6 Feb 2008 14:52:43 -0800
Message-ID: <20080206145243.f41f8c07.akpm@linux-foundation.org>
References: <20080206210426.GD11236@outback.rfc2324.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37006 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757432AbYBFWxk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 17:53:40 -0500
In-Reply-To: <20080206210426.GD11236@outback.rfc2324.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maximilian Wilhelm <max@rfc2324.org>
Cc: linux-kernel@vger.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org

On Wed, 6 Feb 2008 22:04:26 +0100
Maximilian Wilhelm <max@rfc2324.org> wrote:

> Hi!
> 
> While installing my new firewall I got the following kernel panic in
> the MPT SAS driver which I need for the disks.
> 
> The first kernel I bootet was 2.6.23.14 which did panic so I tried a
> 2.6.24 which panics, too. Our usual FAI kernel (2.6.23.9) is also
> affected.
> 
> If there is any information you may need to track this down, please
> let me know.
> 
> I've put the .config to http://files.rfc2324.org/mptsas_panic/2.6.24-config
> to limit the size of this mail.
> 
> ...
>
> ide-floppy driver 0.99.newide
> aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
> megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
> megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
> megasas: 00.00.03.10-rc5 Thu May 17 10:09:32 PDT 2007
> Driver 'sd' needs updating - please use bus_type methods
> Fusion MPT base driver 3.04.06
> Copyright (c) 1999-2007 LSI Corporation
> Fusion MPT SAS Host driver 3.04.06
> mptbase: ioc0: Initiating bringup
> ioc0: LSISAS1068E B3: Capabilities={Initiator}
> scsi0 : ioc0: LSISAS1068E B3, FwRev=00142e00h, Ports=1, MaxQ=511, IRQ=16
> scsi 0:0:0:0: Direct-Access     SEAGATE  ST973402SS       S207 PQ: 0 ANSI: 5
> scsi 0:0:1:0: Direct-Access     SEAGATE  ST973402SS       S207 PQ: 0 ANSI: 5
> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000010
> printing eip: c02c0b38 *pde = 00000000 
> Oops: 0000 [#1] SMP 
> Modules linked in:
> 
> Pid: 1, comm: swapper Not tainted (2.6.24 #1)
> EIP: 0060:[<c02c0b38>] EFLAGS: 00010246 CPU: 1
> EIP is at mptsas_probe_expander_phys+0x51/0x4a2
> EAX: 00000010 EBX: f7457ec0 ECX: f7c3fd9c EDX: 00000004
> ESI: f7fe7800 EDI: f7fe7800 EBP: f7fe7904 ESP: f7c3fe18
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process swapper (pid: 1, ti=f7c3e000 task=f7c22ab0 task.ti=f7c3e000)
> Stack: 0000ffff 00000000 00200200 fffefd74 c02b9cc8 f7fe7800 c04c5280 f7c3fecc 
>        376b1000 00000001 00000000 00000000 00000000 00100100 00200200 00000000 
>        00200200 fffefd74 c02b9cc8 f7fe7800 c04c5280 f7c3fe8c 376b1000 00000001 
> Call Trace:
>  [<c02b9cc8>] mpt_timer_expired+0x0/0x5c
>  [<c02b9cc8>] mpt_timer_expired+0x0/0x5c
>  [<c0280000>] ide_wait_cmd+0x90/0xa0
>  [<c02c2806>] mptsas_probe+0x38a/0x40b
>  [<c0180522>] sysfs_create_link+0xb7/0xf9
>  [<c021ceb6>] pci_device_probe+0x36/0x57
>  [<c023bcd0>] driver_probe_device+0xde/0x15c
>  [<c036d3e5>] klist_next+0x4b/0x6b
>  [<c023bde0>] __driver_attach+0x0/0x79
>  [<c023be26>] __driver_attach+0x46/0x79
>  [<c023b2a8>] bus_for_each_dev+0x33/0x55
>  [<c023bb37>] driver_attach+0x16/0x18
>  [<c023bde0>] __driver_attach+0x0/0x79
>  [<c023b58e>] bus_add_driver+0x6d/0x197
>  [<c021cff2>] __pci_register_driver+0x48/0x74
>  [<c0480bd3>] mptsas_init+0xbf/0xd6
>  [<c046c74e>] kernel_init+0x140/0x2a2
>  [<c01024ca>] ret_from_fork+0x6/0x1c
>  [<c046c60e>] kernel_init+0x0/0x2a2
>  [<c046c60e>] kernel_init+0x0/0x2a2
>  [<c010319f>] kernel_thread_helper+0x7/0x10
>  =======================
> Code: 85 c0 0f 84 68 04 00 00 8b 54 24 1c 8b 02 89 04 24 31 c9 89 da 89 f8 e8 2b f2 ff ff 89 44 24 2c 85 c0 8b 43 0c 0f 85 39 04 00 00 <0f> b7 00 8b 74 24 1c 89 06 8d 87 24 05 00 00 89 44 24 20 e8 5b 
> EIP: [<c02c0b38>] mptsas_probe_expander_phys+0x51/0x4a2 SS:ESP 0068:f7c3fe18
> ---[ end trace 50b3e7147499e641 ]---
> Kernel panic - not syncing: Attempted to kill init!
> 

Thanks.   Cc's added...
