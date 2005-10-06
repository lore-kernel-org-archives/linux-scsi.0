From: Olaf Hering <olh@suse.de>
Subject: bad error handling in lpfc in 2.6.13
Date: Fri, 7 Oct 2005 00:24:00 +0200
Message-ID: <20051006222400.GA10273@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:29663 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751015AbVJFWYG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2005 18:24:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org
Cc: Olof Johansson <olof@austin.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>

James,

we have LP9000 in a pSeries 520 (POWER5 hardware). 
I had to upgrade the firmware, otherwise the newer lpfc which went into
mainline and in SLES9 SP2 would not recognize the adapter properly.

There seems to be a hardcare configuration problem on our side, all
kernels I have tried showed this error when installing onto a device:

lpfc 0001:58:01.0: 0:0457 Adapter Hardware Error Data: x20000000 x17cf4 x50000003

This happens with all driver versions I have tried (SLES9 SP1/2/3 and
2.6.13). With 2.6.13 I get iommu failures, and a panic, shown below.
I tried to install two times, once with each firmware version:

3.91a1 - with the panic below
3.93a0 - this did not panic, I got some :
 Badness in __iommu_free at arch/ppc64/kernel/iommu.c:208



...
lpfc 0001:58:01.0: 0:0327 Rsp ring 0 error -  command completion for iotag x6f7 not found
lpfc 0001:58:01.0: 0:0327 Rsp ring 0 error -  command completion for iotag x6f5 not found
lpfc 0001:58:01.0: 0:0327 Rsp ring 0 error -  command completion for iotag x6f6 not found
lpfc 0001:58:01.0: 0:0748 abort handler timed out waiting for abort to complete. Data: x0 x1 x1 x7ac
lpfc 0001:58:01.0: 0:0748 abort handler timed out waiting for abort to complete. Data: x0 x1 x1 x7ad
lpfc 0001:58:01.0: 0:0748 abort handler timed out waiting for abort to complete. Data: x0 x1 x1 x7ae
lpfc 0001:58:01.0: 0:0713 SCSI layer issued LUN reset (1, 1) Data: x2002 x0 x0
lpfc 0001:58:01.0: 0:0457 Adapter Hardware Error Data: x20000000 x17cf4 x50000003
...

Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=128 NUMA PSERIES LPAR
Modules linked in: dm_snapshot multipath raid6 raid5 xor raid1 raid0 dm_mod st l
pfc scsi_transport_fc ipr firmware_class ibmveth e1000 usb_storage ide_cd sg sr_
mod sd_mod scsi_mod cdrom cramfs isofs vfat fat nls_iso8859_1 nls_cp437 nls_base
 zlib_inflate
NIP: C0000000000265AC XER: 00000001 LR: C000000000026594 CTR: C00000000002A620
REGS: c00000000f72f530 TRAP: 0300   Not tainted  (2.6.13-15-ppc64)
MSR: 8000000000001032 EE: 0 PR: 0 FP: 0 ME: 1 IR/DR: 11 CR: 24000084
DAR: 0000000000000014 DSISR: 0000000040000000
TASK: c00000000f5347e0[1047] 'lpfc_worker_0' THREAD: c00000000f72c000 CPU: 0
GPR00: 0000000000000000 C00000000F72F7B0 C0000000006B7ED0 8000000000001032
GPR04: 0000000000000000 0000000000000001 0000000000000C59 C0000000007A8400
GPR08: C00000000F7137F8 0000000000000000 C00000000F7137E8 0000000000000000
GPR12: D00000000028D860 C0000000004F3000 0000000000000000 0000000004010000
GPR16: C0000000004B32F0 C0000000004B3538 000000000199FE38 00000000044C32F0
GPR20: 0000000000000003 C00000000F6FA410 0000000000000378 C00000000F6FA418
GPR24: C00000000F6FA6D8 C00000000F6FA458 8000000000001032 C000000004A96A50
GPR28: C000000004A96A00 0000000000000000 0000000000000000 0000000000000001
NIP [c0000000000265ac] .iommu_unmap_sg+0x6c/0x140
LR [c000000000026594] .iommu_unmap_sg+0x54/0x140
Call Trace:
[c00000000f72f7b0] [c000000000026594] .iommu_unmap_sg+0x54/0x140 (unreliable)
[c00000000f72f850] [c00000000002a64c] .pci_iommu_unmap_sg+0x2c/0x60
--- Exception: d000000000287ddc at .lpfc_sli_brdreset+0x1e4/0x3d0 [lpfc]
    LR = .lpfc_sli_brdreset+0x1ac/0x3d0 [lpfc]
[c00000000f72f8c0] [c0000000000101e4] .dma_unmap_sg+0x64/0xc0 (unreliable)
[c00000000f72f960] [d000000000287d64] .lpfc_free_scsi_buf+0xf4/0x130 [lpfc]
[c00000000f72f9f0] [d000000000287ddc] .lpfc_scsi_cmd_iocb_cleanup+0x3c/0x70 [lpf
c]
[c00000000f72fa90] [d00000000026e738] .lpfc_sli_abort_iocb_ring+0x1c8/0x2f0 [lpf
c]
[c00000000f72fb40] [d0000000002711f0] .lpfc_sli_brdreset+0x380/0x3d0 [lpfc]
[c00000000f72fbf0] [d0000000002715cc] .lpfc_sli_hba_down+0x38c/0x3d0 [lpfc]
[c00000000f72fcc0] [d0000000002810c8] .lpfc_offline+0x138/0x1b0 [lpfc]
[c00000000f72fd50] [d000000000281b5c] .lpfc_handle_eratt+0x13c/0x2b0 [lpfc]
[c00000000f72fde0] [d00000000027f868] .lpfc_do_work+0x7c8/0xc60 [lpfc]
[c00000000f72fee0] [c00000000007ed48] .kthread+0x178/0x190
[c00000000f72ff90] [c0000000000145a8] .kernel_thread+0x4c/0x68
Instruction dump:
0b000000 2fa30000 419e0080 3b630050 7f63db78 483d0b01 60000000 381fffff
7c7a1b78 7c1d07b4 2f9dffff 419e001c <801e0014> 3bfe0028 809e0010 3bc00000
 smp_call_function on cpu 0: other cpus not responding (0)
 rport-1:0-2: blocked FC remote port time out: removing target



This is with the newer firmware and 2.6.13:

....
lpfc 0001:58:01.0: 0:0748 abort handler timed out waiting for abort to complete. Data: x0 x1 x1 x57b
lpfc 0001:58:01.0: 0:0713 SCSI layer issued LUN reset (1, 1) Data: x2002 x0 x0
iommu_free: invalid entry
        entry     = 0x10
        dma_addr  = 0x10000
        Table     = 0xc000000004eaca00
        bus#      = 0x0
        size      = 0x10000
        startOff  = 0x18000
        index     = 0x3
Badness in __iommu_free at arch/ppc64/kernel/iommu.c:208
Call Trace:  
[c00000000f407a10] [c0000000000263a8] .__iommu_free+0x108/0x1e0 (unreliable)
[c00000000f407ab0] [c000000000026654] .iommu_unmap_sg+0x114/0x140
[c00000000f407b50] [c00000000002a64c] .pci_iommu_unmap_sg+0x2c/0x60
[c00000000f407bc0] [c0000000000101e4] .dma_unmap_sg+0x64/0xc0
[c00000000f407c60] [d000000000287d64] .lpfc_free_scsi_buf+0xf4/0x130 [lpfc]
[c00000000f407cf0] [d000000000288a14] .lpfc_reset_lun_handler+0x174/0x3f0 [lpfc]
[c00000000f407dc0] [d0000000001374cc] .scsi_try_bus_device_reset+0x4c/0xc0 [scsi_mod]
[c00000000f407e40] [d0000000001395e4] .scsi_error_handler+0x9f4/0x1030 [scsi_mod]
[c00000000f407f90] [c0000000000145a8] .kernel_thread+0x4c/0x68
iommu_free: invalid entry
        entry     = 0xc0000
        dma_addr  = 0xc0000000
        Table     = 0xc000000004eaca00
        bus#      = 0x0
        size      = 0x10000
        startOff  = 0x18000
        index     = 0x3
Badness in __iommu_free at arch/ppc64/kernel/iommu.c:208
Call Trace:
[c00000000f407a10] [c0000000000263a8] .__iommu_free+0x108/0x1e0 (unreliable)
[c00000000f407ab0] [c000000000026654] .iommu_unmap_sg+0x114/0x140
[c00000000f407b50] [c00000000002a64c] .pci_iommu_unmap_sg+0x2c/0x60
[c00000000f407bc0] [c0000000000101e4] .dma_unmap_sg+0x64/0xc0
[c00000000f407c60] [d000000000287d64] .lpfc_free_scsi_buf+0xf4/0x130 [lpfc]
[c00000000f407cf0] [d000000000288a14] .lpfc_reset_lun_handler+0x174/0x3f0 [lpfc]
[c00000000f407dc0] [d0000000001374cc] .scsi_try_bus_device_reset+0x4c/0xc0 [scsi_mod]
[c00000000f407e40] [d0000000001395e4] .scsi_error_handler+0x9f4/0x1030 [scsi_mod]
[c00000000f407f90] [c0000000000145a8] .kernel_thread+0x4c/0x68
ReiserFS: sde3: using ordered data mode
ReiserFS: sde3: journal params: device sde3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sde3: checking transaction log (sde3)
ReiserFS: sde3: Using r5 hash to sort names
ReiserFS: sde3: warning: Created .reiserfs_priv on sde3 - reserved for xattr storage.
Adding 720888k swap on /dev/sda2.  Priority:-1 extents:1
...

-- 
short story of a lazy sysadmin:
 alias appserv=wotan
