From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 11792] New: Oops when reading
 /proc/megaraid/hba0/diskdrives-ch*
Date: Tue, 21 Oct 2008 12:47:01 -0700
Message-ID: <20081021124701.3d639c4e.akpm@linux-foundation.org>
References: <bug-11792-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbYJUTre (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 15:47:34 -0400
In-Reply-To: <bug-11792-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, sumantp@lsil.com, bo.yang@lsi.com
Cc: bugme-daemon@bugzilla.kernel.org, pterjan@gmail.com


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

For some reason this didn't come out on linux-scsi when I reassigned it
to scsi.

On Sun, 19 Oct 2008 16:27:35 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11792
> 
>            Summary: Oops when reading /proc/megaraid/hba0/diskdrives-ch*
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.27-rc8
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: drivers_other@kernel-bugs.osdl.org
>         ReportedBy: pterjan@gmail.com
> 
> 
> Latest working kernel version: 2.6.24
> Earliest failing kernel version: 2.6.27-rc8

It's a regression.

> Distribution: Mandriva
> Problem Description:
> 
> Oops when reading /proc/megaraid/hba0/diskdrives-ch*
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<f88729b4>] :megaraid:mega_internal_command+0x74/0x130
> *pdpt = 0000000032c80001 *pde = 0000000000000000 
> Oops: 0002 [#1] SMP 
> Modules linked in: nfsd auth_rpcgss exportfs ohci1394 ieee1394 nfs lockd
> nfs_acl sunrpc af_packet binfmt_misc loop ext3 jbd dm_mod rtc_cmos eepro100
> shpchp pci_hotplug ipmi_msghandler e100 ide_cd_mod mii i2c_core sg sworks_agp
> agpgart serverworks ide_core i2o_core megaraid sd_mod scsi_mod crc_t10dif xfs
> uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
> 
> Pid: 2319, comm: diff Not tainted (2.6.27-server-0.rc8.2mnb #1)
> EIP: 0060:[<f88729b4>] EFLAGS: 00010246 CPU: 0
> EIP is at mega_internal_command+0x74/0x130 [megaraid]
> EAX: 00000000 EBX: f7942364 ECX: 00000000 EDX: f2d96000
> ESI: f7942850 EDI: f7942860 EBP: f24e1df4 ESP: f24e1dc0
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process diff (pid: 2319, ti=f24e0000 task=f39f5710 task.ti=f24e0000)
> Stack: 3691e000 00000000 f24e1e1c c010e4c8 f24e1e0c 00000000 f24e1dfe f79429b4 
>        f79428e8 f2d96000 f7942364 f24e1dfe f24e1e10 f24e1e1c f8872b51 00040000 
>        00000000 e0000000 00003691 00000000 f8873f00 f7930c08 c2a56c08 f24e1f08 
> Call Trace:
>  [<c010e4c8>] ? dma_alloc_coherent+0x108/0x2c0
>  [<f8872b51>] ? mega_adapinq+0x41/0x60 [megaraid]
>  [<f8873f00>] ? proc_pdrv_ch0+0x0/0x20 [megaraid]
>  [<f8873887>] ? proc_pdrv+0xb7/0x6d0 [megaraid]
>  [<c01845fe>] ? __alloc_pages_internal+0xae/0x460
>  [<c01b6d29>] ? do_filp_open+0x1c9/0x7c0
>  [<f8873f00>] ? proc_pdrv_ch0+0x0/0x20 [megaraid]
>  [<f8873f18>] ? proc_pdrv_ch0+0x18/0x20 [megaraid]
>  [<c01ed6ab>] ? proc_file_read+0x17b/0x260
>  [<c01ed530>] ? proc_file_read+0x0/0x260
>  [<c01e8c9e>] ? proc_reg_read+0x5e/0x90
>  [<c01ab959>] ? vfs_read+0x99/0x160
>  [<c01e8c40>] ? proc_reg_read+0x0/0x90
>  [<c01abadd>] ? sys_read+0x3d/0x70
>  [<c0109e03>] ? sysenter_do_call+0x12/0x2f
>  [<c0390000>] ? native_cpu_up+0xf0/0x743
>  =======================
> Code: 98 4c c0 e8 ff 39 93 c7 8d bb fc 04 00 00 89 45 f0 8b 55 f0 89 83 84 05
> 00 00 8b 43 48 89 02 8b 83 b8 05 00 00 89 b3 44 06 00 00 <c6> 00 e1 8b 45 ec 83
> 8b f0 04 00 00 01 8b 75 e4 89 83 48 05 00 
> EIP: [<f88729b4>] mega_internal_command+0x74/0x130 [megaraid] SS:ESP
> 0068:f24e1dc0
> ---[ end trace 18d8357732584241 ]---
> 
> 

