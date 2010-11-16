From: Wolfgang Denk <wd@denx.de>
Subject: Unloading sym53c8xx driver causes ___free_dma_mem_cluster warnings
Date: Tue, 16 Nov 2010 20:13:09 +0100
Message-ID: <20101116191309.DD04C14E644@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

when unloading the sym53c8xx driver a number of kernel warning
messages are printed:


[511902.538283] sym0: detaching ...
[511902.538286] sym0: resetting chip
[511902.538319] ------------[ cut here ]------------
[511902.538326] WARNING: at /builddir/build/BUILD/kernel-2.6.35.fc14/linux-2.6.35.i686/arch/x86/include/asm/dma-mapping.h:155 ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]()
[511902.538330] Hardware name: EP35C-DS3R
[511902.538332] Modules linked in: sym53c8xx(-) osst ch nfs fscache fuse ebtable_nat ebtables bridge stp llc nfsd lockd nfs_acl auth_rpcgss it87 hwmon_vid coretemp tun sunrpc cpufreq_ondemand acpi_cpufreq mperf ipv6 kqemu kvm_intel kvm uinput snd_hda_codec_realtek nvidia(P) snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device ppdev snd_pcm snd_timer snd parport_pc iTCO_wdt iTCO_vendor_support i2c_i801 parport r8169 mii i2c_core soundcore pl2303 usbserial snd_page_alloc microcode xfs exportfs raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx pata_acpi ata_generic pata_jmicron scsi_transport_spi [last unloaded: st]
[511902.538377] Pid: 4582, comm: rmmod Tainted: P        W   2.6.35.6-48.fc14.i686.PAE #1
[511902.538377] Call Trace:
[511902.538377]  [<c043fbd1>] warn_slowpath_common+0x6a/0x7f
[511902.538377]  [<ef2b8e7f>] ? ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]
[511902.538377]  [<c043fbfa>] warn_slowpath_null+0x14/0x18
[511902.538377]  [<ef2b8e7f>] ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]
[511902.538377]  [<ef2b8dac>] __sym_mfree+0x5c/0xa2 [sym53c8xx]
[511902.538377]  [<c0464de9>] ? __raw_local_irq_save+0x19/0x1e
[511902.538377]  [<ef2b91bf>] __sym_mfree_dma+0x3c/0x5d [sym53c8xx]
[511902.538377]  [<ef2b8be1>] sym_hcb_free+0x72/0x185 [sym53c8xx]
[511902.538377]  [<ef2b169d>] sym_free_resources+0x4c/0x6b [sym53c8xx]
[511902.538377]  [<ef2b174a>] sym_detach+0x8e/0xa2 [sym53c8xx]
[511902.538377]  [<ef2b1782>] sym2_remove+0x24/0x3c [sym53c8xx]
[511902.538377]  [<c05cd7a8>] pci_device_remove+0x1e/0x3e
[511902.538377]  [<c0661457>] __device_release_driver+0x62/0xa4
[511902.538377]  [<c0661a40>] driver_detach+0x62/0x82
[511902.538377]  [<c066133a>] bus_remove_driver+0x8d/0xc7
[511902.538377]  [<c0661ad4>] driver_unregister+0x50/0x57
[511902.538377]  [<c05cd982>] pci_unregister_driver+0x32/0x67
[511902.538377]  [<c04662cf>] ? cpumask_next+0x17/0x19
[511902.538377]  [<ef2ba37a>] sym2_exit+0x12/0x87 [sym53c8xx]
[511902.538377]  [<c0467333>] sys_delete_module+0x181/0x1de
[511902.538377]  [<c07bc1dd>] ? do_page_fault+0x219/0x275
[511902.538377]  [<c07bc20b>] ? do_page_fault+0x247/0x275
[511902.538377]  [<c047fdb7>] ? audit_syscall_entry+0x116/0x138
[511902.538377]  [<c040899f>] sysenter_do_call+0x12/0x28
[511902.538377] ---[ end trace 23e07d0c130b5514 ]---
[511902.538521] ------------[ cut here ]------------
[511902.538527] WARNING: at /builddir/build/BUILD/kernel-2.6.35.fc14/linux-2.6.35.i686/arch/x86/include/asm/dma-mapping.h:155 ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]()
[511902.538531] Hardware name: EP35C-DS3R
[511902.538532] Modules linked in: sym53c8xx(-) osst ch nfs fscache fuse ebtable_nat ebtables bridge stp llc nfsd lockd nfs_acl auth_rpcgss it87 hwmon_vid coretemp tun sunrpc cpufreq_ondemand acpi_cpufreq mperf ipv6 kqemu kvm_intel kvm uinput snd_hda_codec_realtek nvidia(P) snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device ppdev snd_pcm snd_timer snd parport_pc iTCO_wdt iTCO_vendor_support i2c_i801 parport r8169 mii i2c_core soundcore pl2303 usbserial snd_page_alloc microcode xfs exportfs raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx pata_acpi ata_generic pata_jmicron scsi_transport_spi [last unloaded: st]
[511902.538583] Pid: 4582, comm: rmmod Tainted: P        W   2.6.35.6-48.fc14.i686.PAE #1
[511902.538585] Call Trace:
[511902.538589]  [<c043fbd1>] warn_slowpath_common+0x6a/0x7f
[511902.538595]  [<ef2b8e7f>] ? ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]
[511902.538599]  [<c043fbfa>] warn_slowpath_null+0x14/0x18
[511902.538604]  [<ef2b8e7f>] ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]
[511902.538610]  [<ef2b8dac>] __sym_mfree+0x5c/0xa2 [sym53c8xx]
[511902.538614]  [<c0464de9>] ? __raw_local_irq_save+0x19/0x1e
[511902.538619]  [<ef2b91bf>] __sym_mfree_dma+0x3c/0x5d [sym53c8xx]
[511902.538625]  [<ef2b8c01>] sym_hcb_free+0x92/0x185 [sym53c8xx]
[511902.538630]  [<ef2b169d>] sym_free_resources+0x4c/0x6b [sym53c8xx]
[511902.538635]  [<ef2b174a>] sym_detach+0x8e/0xa2 [sym53c8xx]
[511902.538640]  [<ef2b1782>] sym2_remove+0x24/0x3c [sym53c8xx]
[511902.538643]  [<c05cd7a8>] pci_device_remove+0x1e/0x3e
[511902.538647]  [<c0661457>] __device_release_driver+0x62/0xa4
[511902.538650]  [<c0661a40>] driver_detach+0x62/0x82
[511902.538654]  [<c066133a>] bus_remove_driver+0x8d/0xc7
[511902.538657]  [<c0661ad4>] driver_unregister+0x50/0x57
[511902.538660]  [<c05cd982>] pci_unregister_driver+0x32/0x67
[511902.538664]  [<c04662cf>] ? cpumask_next+0x17/0x19
[511902.538669]  [<ef2ba37a>] sym2_exit+0x12/0x87 [sym53c8xx]
[511902.538673]  [<c0467333>] sys_delete_module+0x181/0x1de
[511902.538677]  [<c07bc1dd>] ? do_page_fault+0x219/0x275
[511902.538680]  [<c07bc20b>] ? do_page_fault+0x247/0x275
[511902.538684]  [<c047fdb7>] ? audit_syscall_entry+0x116/0x138
[511902.538688]  [<c040899f>] sysenter_do_call+0x12/0x28
[511902.538690] ---[ end trace 23e07d0c130b5515 ]---
[511902.538693] ------------[ cut here ]------------
[511902.538698] WARNING: at /builddir/build/BUILD/kernel-2.6.35.fc14/linux-2.6.35.i686/arch/x86/include/asm/dma-mapping.h:155 ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]()
[511902.538702] Hardware name: EP35C-DS3R
[511902.538703] Modules linked in: sym53c8xx(-) osst ch nfs fscache fuse ebtable_nat ebtables bridge stp llc nfsd lockd nfs_acl auth_rpcgss it87 hwmon_vid coretemp tun sunrpc cpufreq_ondemand acpi_cpufreq mperf ipv6 kqemu kvm_intel kvm uinput snd_hda_codec_realtek nvidia(P) snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device ppdev snd_pcm snd_timer snd parport_pc iTCO_wdt iTCO_vendor_support i2c_i801 parport r8169 mii i2c_core soundcore pl2303 usbserial snd_page_alloc microcode xfs exportfs raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx pata_acpi ata_generic pata_jmicron scsi_transport_spi [last unloaded: st]
[511902.538754] Pid: 4582, comm: rmmod Tainted: P        W   2.6.35.6-48.fc14.i686.PAE #1
[511902.538756] Call Trace:
[511902.538760]  [<c043fbd1>] warn_slowpath_common+0x6a/0x7f
[511902.538765]  [<ef2b8e7f>] ? ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]
[511902.538769]  [<c043fbfa>] warn_slowpath_null+0x14/0x18
[511902.538775]  [<ef2b8e7f>] ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]
[511902.538781]  [<ef2b8dac>] __sym_mfree+0x5c/0xa2 [sym53c8xx]
[511902.538784]  [<c0464de9>] ? __raw_local_irq_save+0x19/0x1e
[511902.538790]  [<ef2b91bf>] __sym_mfree_dma+0x3c/0x5d [sym53c8xx]
[511902.538795]  [<ef2b8c21>] sym_hcb_free+0xb2/0x185 [sym53c8xx]
[511902.538800]  [<ef2b169d>] sym_free_resources+0x4c/0x6b [sym53c8xx]
[511902.538805]  [<ef2b174a>] sym_detach+0x8e/0xa2 [sym53c8xx]
[511902.538810]  [<ef2b1782>] sym2_remove+0x24/0x3c [sym53c8xx]
[511902.538814]  [<c05cd7a8>] pci_device_remove+0x1e/0x3e
[511902.538817]  [<c0661457>] __device_release_driver+0x62/0xa4
[511902.538821]  [<c0661a40>] driver_detach+0x62/0x82
[511902.538824]  [<c066133a>] bus_remove_driver+0x8d/0xc7
[511902.538827]  [<c0661ad4>] driver_unregister+0x50/0x57
[511902.538831]  [<c05cd982>] pci_unregister_driver+0x32/0x67
[511902.538834]  [<c04662cf>] ? cpumask_next+0x17/0x19
[511902.538839]  [<ef2ba37a>] sym2_exit+0x12/0x87 [sym53c8xx]
[511902.538843]  [<c0467333>] sys_delete_module+0x181/0x1de
[511902.538847]  [<c07bc1dd>] ? do_page_fault+0x219/0x275
[511902.538850]  [<c07bc20b>] ? do_page_fault+0x247/0x275
[511902.538854]  [<c047fdb7>] ? audit_syscall_entry+0x116/0x138
[511902.538858]  [<c040899f>] sysenter_do_call+0x12/0x28
[511902.538861] ---[ end trace 23e07d0c130b5516 ]---
[511902.538864] ------------[ cut here ]------------
[511902.538870] WARNING: at /builddir/build/BUILD/kernel-2.6.35.fc14/linux-2.6.35.i686/arch/x86/include/asm/dma-mapping.h:155 ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]()
[511902.538873] Hardware name: EP35C-DS3R
[511902.538875] Modules linked in: sym53c8xx(-) osst ch nfs fscache fuse ebtable_nat ebtables bridge stp llc nfsd lockd nfs_acl auth_rpcgss it87 hwmon_vid coretemp tun sunrpc cpufreq_ondemand acpi_cpufreq mperf ipv6 kqemu kvm_intel kvm uinput snd_hda_codec_realtek nvidia(P) snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device ppdev snd_pcm snd_timer snd parport_pc iTCO_wdt iTCO_vendor_support i2c_i801 parport r8169 mii i2c_core soundcore pl2303 usbserial snd_page_alloc microcode xfs exportfs raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx pata_acpi ata_generic pata_jmicron scsi_transport_spi [last unloaded: st]
[511902.538925] Pid: 4582, comm: rmmod Tainted: P        W   2.6.35.6-48.fc14.i686.PAE #1
[511902.538928] Call Trace:
[511902.538931]  [<c043fbd1>] warn_slowpath_common+0x6a/0x7f
[511902.538937]  [<ef2b8e7f>] ? ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]
[511902.538941]  [<c043fbfa>] warn_slowpath_null+0x14/0x18
[511902.538947]  [<ef2b8e7f>] ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]
[511902.538952]  [<ef2b8dac>] __sym_mfree+0x5c/0xa2 [sym53c8xx]
[511902.538958]  [<ef2b91bf>] __sym_mfree_dma+0x3c/0x5d [sym53c8xx]
[511902.538964]  [<ef2b8cb8>] sym_hcb_free+0x149/0x185 [sym53c8xx]
[511902.538969]  [<ef2b169d>] sym_free_resources+0x4c/0x6b [sym53c8xx]
[511902.538974]  [<ef2b174a>] sym_detach+0x8e/0xa2 [sym53c8xx]
[511902.538979]  [<ef2b1782>] sym2_remove+0x24/0x3c [sym53c8xx]
[511902.538982]  [<c05cd7a8>] pci_device_remove+0x1e/0x3e
[511902.538986]  [<c0661457>] __device_release_driver+0x62/0xa4
[511902.538989]  [<c0661a40>] driver_detach+0x62/0x82
[511902.538992]  [<c066133a>] bus_remove_driver+0x8d/0xc7
[511902.538996]  [<c0661ad4>] driver_unregister+0x50/0x57
[511902.538999]  [<c05cd982>] pci_unregister_driver+0x32/0x67
[511902.539002]  [<c04662cf>] ? cpumask_next+0x17/0x19
[511902.539008]  [<ef2ba37a>] sym2_exit+0x12/0x87 [sym53c8xx]
[511902.539011]  [<c0467333>] sys_delete_module+0x181/0x1de
[511902.539015]  [<c07bc1dd>] ? do_page_fault+0x219/0x275
[511902.539019]  [<c07bc20b>] ? do_page_fault+0x247/0x275
[511902.539022]  [<c047fdb7>] ? audit_syscall_entry+0x116/0x138
[511902.539026]  [<c040899f>] sysenter_do_call+0x12/0x28
[511902.539029] ---[ end trace 23e07d0c130b5517 ]---
[511902.539032] ------------[ cut here ]------------
[511902.539038] WARNING: at /builddir/build/BUILD/kernel-2.6.35.fc14/linux-2.6.35.i686/arch/x86/include/asm/dma-mapping.h:155 ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]()
[511902.539041] Hardware name: EP35C-DS3R
[511902.539043] Modules linked in: sym53c8xx(-) osst ch nfs fscache fuse ebtable_nat ebtables bridge stp llc nfsd lockd nfs_acl auth_rpcgss it87 hwmon_vid coretemp tun sunrpc cpufreq_ondemand acpi_cpufreq mperf ipv6 kqemu kvm_intel kvm uinput snd_hda_codec_realtek nvidia(P) snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device ppdev snd_pcm snd_timer snd parport_pc iTCO_wdt iTCO_vendor_support i2c_i801 parport r8169 mii i2c_core soundcore pl2303 usbserial snd_page_alloc microcode xfs exportfs raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx pata_acpi ata_generic pata_jmicron scsi_transport_spi [last unloaded: st]
[511902.539093] Pid: 4582, comm: rmmod Tainted: P        W   2.6.35.6-48.fc14.i686.PAE #1
[511902.539095] Call Trace:
[511902.539099]  [<c043fbd1>] warn_slowpath_common+0x6a/0x7f
[511902.539105]  [<ef2b8e7f>] ? ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]
[511902.539109]  [<c043fbfa>] warn_slowpath_null+0x14/0x18
[511902.539114]  [<ef2b8e7f>] ___free_dma_mem_cluster+0x45/0xc7 [sym53c8xx]
[511902.539120]  [<ef2b8dac>] __sym_mfree+0x5c/0xa2 [sym53c8xx]
[511902.539126]  [<ef2b91bf>] __sym_mfree_dma+0x3c/0x5d [sym53c8xx]
[511902.539131]  [<ef2b16b4>] sym_free_resources+0x63/0x6b [sym53c8xx]
[511902.539136]  [<ef2b174a>] sym_detach+0x8e/0xa2 [sym53c8xx]
[511902.539141]  [<ef2b1782>] sym2_remove+0x24/0x3c [sym53c8xx]
[511902.539144]  [<c05cd7a8>] pci_device_remove+0x1e/0x3e
[511902.539148]  [<c0661457>] __device_release_driver+0x62/0xa4
[511902.539151]  [<c0661a40>] driver_detach+0x62/0x82
[511902.539154]  [<c066133a>] bus_remove_driver+0x8d/0xc7
[511902.539157]  [<c0661ad4>] driver_unregister+0x50/0x57
[511902.539161]  [<c05cd982>] pci_unregister_driver+0x32/0x67
[511902.539164]  [<c04662cf>] ? cpumask_next+0x17/0x19
[511902.539170]  [<ef2ba37a>] sym2_exit+0x12/0x87 [sym53c8xx]
[511902.539173]  [<c0467333>] sys_delete_module+0x181/0x1de
[511902.539177]  [<c07bc1dd>] ? do_page_fault+0x219/0x275
[511902.539181]  [<c07bc20b>] ? do_page_fault+0x247/0x275
[511902.539184]  [<c047fdb7>] ? audit_syscall_entry+0x116/0x138
[511902.539188]  [<c040899f>] sysenter_do_call+0x12/0x28
[511902.539191] ---[ end trace 23e07d0c130b5518 ]---
[511902.541664] sym53c8xx 0000:05:00.0: PCI INT A disabled

This is a long standing problem - I reported it more than a yar ago as
Fedora bug # 534161, see
https://bugzilla.redhat.com/show_bug.cgi?id=534161

Recently I receieved the following advice:

| Stanislaw Gruszka 2010-10-03 09:37:31 EDT
|
| I looked at the code (gash, the sym53c8xx_2 is one big mess).
|
| First in __sym_mfree_dma we take spin_lock_irqsave(&sym53c8xx_lock,
| flags) then after some complex logic call dma_free_coherent().
| Since interrupts are disabled WARN_ON(irqs_disabled()) print a
| message and call trace.
|
| I don't know how to solve it. One solution is move
| dma_free_coherent after spin_lock_irqrestore in __sys_mfree_dma,
| but as told logic is quite complex. Second is remove WARN_ON from
| dma_free_coherent. I have no idea why this warning is there -
| free_something functions should be callable from any context.
|
| Anyway this is not fixed mainline. Wolfgang, please report problem
| to proper upstream maintainers. If we get upstream solution, we can
| put it in fedora then.

OK, so I'm posting it here.

Thanks in advance.

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
The human mind  ordinarily  operates  at  only  ten  percent  of  its
capacity. The rest is overhead for the operating system.
