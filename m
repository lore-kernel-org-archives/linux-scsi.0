From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] x86: Fix gfp flags for coherent DMA memory allocation
Date: Tue, 15 Sep 2015 09:36:23 +0000
Message-ID: <20150915093621.GA13060@xzibit.linux.bs1.fc.nec.co.jp>
References: <20150914073834.GA13077@xzibit.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150914073834.GA13077@xzibit.linux.bs1.fc.nec.co.jp>
Content-Language: ja-JP
Content-ID: <E220C12E63714D48990BE3CE81073319@gisp.nec.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>, "hpa@zytor.com" <hpa@zytor.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/14/15 16:38, Junichi Nomura wrote:
> Commit 6894258eda2f reversed the order of gfp_flags adjustment in
> dma_alloc_attrs() for x86 [arch/x86/kernel/pci-dma.c]
> As a result, relevant flags set by dma_alloc_coherent_gfp_flags()
> is just discarded and causes coherent DMA memory allocation failure
> on some devices.
> 
> Fixes: 6894258eda2f ("dma-mapping: consolidate dma_{alloc,free}_{attrs,coherent}")
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> 
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 84b8ef8..1b55de1 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -131,8 +131,8 @@ void dma_generic_free_coherent(struct device *dev, size_t size, void *vaddr,
>  
>  bool arch_dma_alloc_attrs(struct device **dev, gfp_t *gfp)
>  {
> -	*gfp = dma_alloc_coherent_gfp_flags(*dev, *gfp);
>  	*gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
> +	*gfp = dma_alloc_coherent_gfp_flags(*dev, *gfp);

Additional note:

I noticed this problem because megaraid driver, which uses 32-bit
dma mask for coherent buffers, failed initialization and my system
didn't boot.

But there can be other drivers which are silently and unnecessarily
falling back to swiotlb due to this problem.

megaraid_sas 0000:10:00.0: FW now in Ready state 
megaraid_sas 0000:10:00.0: firmware supports msix	: (16) 
megaraid_sas 0000:10:00.0: current msix/online cpus	: (16/32) 
megaraid_sas 0000:10:00.0: Init cmd success 
megaraid_sas 0000:10:00.0: firmware type	: Legacy(64 VD) firmware 
megaraid_sas 0000:10:00.0: controller type	: MR(512MB) 
megaraid_sas 0000:10:00.0: swiotlb buffer is full (sz: 665896 bytes) 
swiotlb: coherent allocation failed for device 0000:10:00.0 size=665896 
CPU: 0 PID: 657 Comm: modprobe Tainted: G            E   4.3.0-rc1 #1 
Hardware name: 
 ffff88046e99f098 ffff88046db8f9c8 ffffffff812a7904 ffffffffffffffff 
 00000000ffffffff ffff88046db8fa18 ffffffff812cfe74 ffff88046cd00188 
 0000000800000008 ffff88046dfce8c0 00000000000002d0 ffff88046cd00188 
Call Trace: 
 [<ffffffff812a7904>] dump_stack+0x48/0x64 
 [<ffffffff812cfe74>] swiotlb_alloc_coherent+0x154/0x170 
 [<ffffffff8104a2af>] x86_swiotlb_alloc_coherent+0x5f/0x70 
 [<ffffffffa000f9b5>] megasas_init_adapter_fusion+0x375/0x4b0 [megaraid_sas] 
 [<ffffffffa0005a06>] megasas_init_fw+0x2e6/0x940 [megaraid_sas] 
 [<ffffffffa0007795>] megasas_probe_one+0x745/0xb60 [megaraid_sas] 
 [<ffffffff812e913c>] local_pci_probe+0x4c/0xa0 
 [<ffffffff812e9213>] pci_call_probe+0x83/0xa0 
 [<ffffffff812e9744>] ? pci_match_device+0xe4/0x110 
 [<ffffffff812e982f>] pci_device_probe+0x7f/0xb0 
 [<ffffffff813ce2f3>] really_probe+0x133/0x390 
 [<ffffffff813ce5a9>] driver_probe_device+0x59/0xd0 
 [<ffffffff813ce6bd>] __driver_attach+0x9d/0xa0 
 [<ffffffff813ce620>] ? driver_probe_device+0xd0/0xd0 
 [<ffffffff813ce620>] ? driver_probe_device+0xd0/0xd0 
 [<ffffffff813cc2fa>] bus_for_each_dev+0x8a/0xb0 
 [<ffffffff813cdd6e>] driver_attach+0x1e/0x20 
 [<ffffffff813cd7cf>] bus_add_driver+0x1cf/0x290 
 [<ffffffff813cee50>] driver_register+0x60/0xe0 
 [<ffffffff812e952c>] __pci_register_driver+0x4c/0x50 
 [<ffffffffa001d0a4>] megasas_init+0xa4/0x1ba [megaraid_sas] 
 [<ffffffffa001d000>] ? 0xffffffffa001d000 
 [<ffffffff8100027d>] do_one_initcall+0xad/0x1c0 
 [<ffffffff810dba39>] do_init_module+0x69/0x210 
 [<ffffffff810de19a>] load_module+0x5aa/0x730 
 [<ffffffff810dad60>] ? mod_sysfs_teardown+0x140/0x140 
 [<ffffffff810da790>] ? module_sect_show+0x30/0x30 
 [<ffffffff810de4a2>] SyS_init_module+0x92/0xc0 
 [<ffffffff815ce697>] entry_SYSCALL_64_fastpath+0x12/0x6a 
megaraid_sas 0000:10:00.0: Could not allocate memory for map info 

-- 
Jun'ichi Nomura, NEC Corporation
