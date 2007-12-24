From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: SCSI errors on powerpc with 2.6.24-rc6-mm1
Date: Mon, 24 Dec 2007 10:18:50 +0530
Message-ID: <20071224044850.GA11449@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:42780 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbXLXEs5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Dec 2007 23:48:57 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

I've just seen this on my dmesg, this is new, never seen this before on
this box and it happens only with this version of the kernel.

In this configuration, the page size is set to 64K and I've enabled fake
NUMA nodes on PowerPC.

tce_buildmulti_pSeriesLP: plpar_tce_put failed. rc=-4
        index   = 0x4000002
        npages  = 0x0
        tce[0] val = 0x15ad0001
Call Trace:
[c00000000ffe74f0] [c0000000000491a4]
.tce_buildmulti_pSeriesLP+0x26c/0x2ac (unreliable)
[c00000000ffe75c0] [c0000000000295e4] .iommu_map_sg+0x1d4/0x418
[c00000000ffe76d0] [c000000000028664] .dma_iommu_map_sg+0x3c/0x50
[c00000000ffe7750] [c0000000003b6c30] .scsi_dma_map+0x70/0x94
[c00000000ffe77d0] [c0000000003dedbc] .ipr_queuecommand+0x300/0x500
[c00000000ffe7880] [c0000000003ae964] .scsi_dispatch_cmd+0x21c/0x2b8
[c00000000ffe7920] [c0000000003b67a0] .scsi_request_fn+0x310/0x460
[c00000000ffe79d0] [c00000000024ab90] .blk_run_queue+0x94/0xec
[c00000000ffe7a70] [c0000000003b3b08] .scsi_run_queue+0x24c/0x27c
[c00000000ffe7b20] [c0000000003b4424] .scsi_next_command+0x48/0x70
[c00000000ffe7bc0] [c0000000003b4b48] .scsi_end_request+0xbc/0xe4
[c00000000ffe7c60] [c0000000003b5294] .scsi_io_completion+0x170/0x3e8
[c00000000ffe7d40] [c0000000003ae0e4] .scsi_finish_command+0xb4/0xd4
[c00000000ffe7dd0] [c0000000003b584c] .scsi_softirq_done+0x114/0x138
[c00000000ffe7e60] [c00000000024af70] .blk_done_softirq+0xa0/0xd0
[c00000000ffe7ef0] [c00000000007a2a0] .__do_softirq+0xa8/0x164
[c00000000ffe7f90] [c000000000027edc] .call_do_softirq+0x14/0x24
[c00000003e183950] [c00000000000bdcc] .do_softirq+0x74/0xc0
[c00000003e1839e0] [c00000000007a450] .irq_exit+0x5c/0xac
[c00000003e183a60] [c00000000000c414] .do_IRQ+0x17c/0x1f4
[c00000003e183b00] [c000000000004c24] hardware_interrupt_entry+0x24/0x28
--- Exception: 501 at .ppc64_runlatch_off+0x28/0x60
    LR = .pseries_dedicated_idle_sleep+0xd8/0x1a4
[c00000003e183df0] [c000000000048494]
.pseries_dedicated_idle_sleep+0x78/0x1a4 (unreliable)
[c00000003e183e80] [c00000000001110c] .cpu_idle+0x10c/0x1e8
[c00000003e183f00] [c00000000002b5b0] .start_secondary+0x1b4/0x1d8
[c00000003e183f90] [c0000000000083c4] .start_secondary_prolog+0xc/0x10
ipr: 0:0:3:0: 8150: PCI bus error
ipr: IOASA Dump:
ipr: 00000000: 04418000 009000D0 0006FFD0 00000000
ipr: 00000010: 00000000 00000000 00000000 00000000
ipr: 00000020: 01060000 D0001814 01062A00 000F531E
ipr: 00000030: 00040000 00000000 303800B6 00000000
ipr: 00000040: 00000000 04060000 00CCDDDD AABBCCCC
ipr: 00000050: 0006FFD0 6800FFD0 7FFF0030 B9000010
ipr: 00000060: 40000000 80000800 08200000 000013FE
ipr: 00000070: 00000000 00000000 8C00000E 00000000
ipr: 00000080: 00000000 00000000 00000000 00000000

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
