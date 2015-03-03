From: Mark Hounschell <markh-n2QNKt385d+sTnJN9+BGXg@public.gmane.org>
Subject: Re: BUG: SCSI aic7xxx driver and AMD IOMMU
Date: Tue, 03 Mar 2015 14:36:19 -0500
Message-ID: <54F60D33.8090401@compro.net>
References: <54E1FFFA.1060403@compro.net>
Reply-To: markh-n2QNKt385d+sTnJN9+BGXg@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <54E1FFFA.1060403-n2QNKt385d+sTnJN9+BGXg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org >> SCSI development list" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Joerg,

It looks like this problem is NOT a bug with the SCSI aic7xxx driver 
after all. I can duplicate this BUG very easily with other hardware. 
Simply removing a driver module  (whether it its self, has actually used 
any of the DMA API or not) that is sitting on the same pci bus as a card 
that is actually using DMA will cause this. And that card that is in use 
and using DMA will no longer function. It "looks and feels" like 
unloading a module causes the IOMMU to improperly unmap valid mappings.

Regards
Mark

 > Kernel 3.18.7 (x86_64) with an enabled IOMMU. This happens 
immediately after
> unloading the aic7xxx driver. In fact this happens unloading any module associated
> with any pci card on the same bus as the Adaptec AHA-2930CU card. If I blacklist
> the aic7xxx driver the problem never shows.  If I disable the IOMMU, the problem
> never shows.
>
> This was brought up over at iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org in this thread.
> http://lists.linuxfoundation.org/pipermail/iommu/2015-February/012274.html
> and they think it is not an iommu problem, but a possibly a problem with the
> aic7xxx driver.  Complete dmesg attached.
>
> [  106.355752] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0000 address=0x0000000000073980 flags=0x0070]
> [  106.358732] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0000 address=0x00000000000739a0 flags=0x0070]
> [  106.361870] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0000 address=0x00000000000739b0 flags=0x0070]
> [  112.352950] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0000 address=0x0000000000074d00 flags=0x0070]
> [  112.356057] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0000 address=0x0000000000074d20 flags=0x0070]
> [  112.359142] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0000 address=0x0000000000074d30 flags=0x0070]
> [  126.588896] AMD-Vi: Using protection domain 1 for device 0000:10:05.0
> [  126.591992] ------------[ cut here ]------------
> [  126.595107] WARNING: CPU: 4 PID: 0 at drivers/iommu/amd_iommu.c:2637 dma_ops_domain_unmap.part.13+0x65/0x70()
> [  126.598408] Modules linked in: iscsi_ibft iscsi_boot_sysfs af_packet kvm crc32_pclmul crc32c_intel aesni_intel snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec aes_x86_64 drm snd_hwdep snd_pcm glue_helper lrw aic79xx gf128mul ablk_helper cryptd snd_timer 3c59x scsi_transport_spi snd r8169 xhci_pci xhci_hcd serio_raw pcspkr mii tpm_infineon tpm_tis fam15h_power k10temp i2c_piix4 processor thermal_sys shpchp tpm soundcore 8250_fintek dm_mod sr_mod cdrom ata_generic mxm_wmi pata_atiixp ohci_pci wmi button sg autofs4 [last unloaded: aic7xxx]
> [  126.613992] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 3.18.7-lcrs #1
> [  126.618146] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./990FXA-UD5, BIOS FB 01/23/2013
> [  126.622456]  0000000000000009 ffff88044fd03cb8 ffffffff807bde4d 0000000000000000
> [  126.626815]  0000000000000000 ffff88044fd03cf8 ffffffff8024cf7c ffff88044fd03cf8
> [  126.631172]  ffff88043cdbc380 0000000000000000 0000000000000600 00000000000702c0
> [  126.635504] Call Trace:
> [  126.639703]  <IRQ>  [<ffffffff807bde4d>] dump_stack+0x4e/0x71
> [  126.644003]  [<ffffffff8024cf7c>] warn_slowpath_common+0x7c/0xa0
> [  126.648335]  [<ffffffff8024d045>] warn_slowpath_null+0x15/0x20
> [  126.652632]  [<ffffffff806a47e5>] dma_ops_domain_unmap.part.13+0x65/0x70
> [  126.656919]  [<ffffffff806a675b>] __unmap_single.isra.16+0x9b/0x100
> [  126.661242]  [<ffffffff806a7198>] unmap_page+0x48/0x70
> [  126.665572]  [<ffffffffa0157373>] boomerang_rx+0x333/0x600 [3c59x]
> [  126.669968]  [<ffffffffa015784a>] boomerang_interrupt+0x16a/0x4f0 [3c59x]
> [  126.674400]  [<ffffffff8029600e>] handle_irq_event_percpu+0x3e/0x1e0
> [  126.678860]  [<ffffffff802961ec>] handle_irq_event+0x3c/0x60
> [  126.683298]  [<ffffffff80298bfe>] handle_fasteoi_irq+0x7e/0x130
> [  126.687732]  [<ffffffff8020543d>] handle_irq+0x1d/0x30
> [  126.692164]  [<ffffffff80204cee>] do_IRQ+0x4e/0xf0
> [  126.696577]  [<ffffffff807c596a>] common_interrupt+0x6a/0x6a
> [  126.700873]  <EOI>  [<ffffffff802a6e23>] ? hrtimer_start+0x13/0x20
> [  126.705107]  [<ffffffff8020cad7>] ? default_idle+0x17/0x100
> [  126.709386]  [<ffffffff8020d4ca>] arch_cpu_idle+0xa/0x10
> [  126.713685]  [<ffffffff80281dda>] cpu_startup_entry+0x34a/0x380
> [  126.718010]  [<ffffffff80281a91>] ? cpu_startup_entry+0x1/0x380
> [  126.722361]  [<ffffffff80233857>] start_secondary+0x157/0x180
> [  126.726731] ---[ end trace ace20602a5302afb ]---
> [  128.557546] ------------[ cut here ]------------
> [  128.560501] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x00000000000766c0 flags=0x0020]
> [  128.560502] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076700 flags=0x0020]
> [  128.560503] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076740 flags=0x0020]
> [  128.560504] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076780 flags=0x0020]
> [  128.560505] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076800 flags=0x0020]
> [  128.560506] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x00000000000767c0 flags=0x0020]
> [  128.560506] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x00000000000768c0 flags=0x0020]
> [  128.560507] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076880 flags=0x0020]
> [  128.560508] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076840 flags=0x0020]
> [  128.560508] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076900 flags=0x0020]
> [  128.560509] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076940 flags=0x0020]
> [  128.560510] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076980 flags=0x0020]
> [  128.560511] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x00000000000769c0 flags=0x0020]
> [  128.560511] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076a00 flags=0x0020]
> [  128.560512] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076a40 flags=0x0020]
> [  128.560513] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076a80 flags=0x0020]
> [  128.560513] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076ac0 flags=0x0020]
> [  128.560514] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076b40 flags=0x0020]
> [  128.560515] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076b00 flags=0x0020]
> [  128.560516] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076b60 flags=0x0020]
> [  128.560516] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076b70 flags=0x0020]
> [  128.560517] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000076b70 flags=0x0020]
> [  128.658489] WARNING: CPU: 5 PID: 0 at drivers/iommu/amd_iommu.c:2637 dma_ops_domain_unmap.part.13+0x65/0x70()
> [  128.662613] Modules linked in: iscsi_ibft iscsi_boot_sysfs af_packet kvm crc32_pclmul crc32c_intel aesni_intel snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec aes_x86_64 drm snd_hwdep snd_pcm glue_helper lrw aic79xx gf128mul ablk_helper cryptd snd_timer 3c59x scsi_transport_spi snd r8169 xhci_pci xhci_hcd serio_raw pcspkr mii tpm_infineon tpm_tis fam15h_power k10temp i2c_piix4 processor thermal_sys shpchp tpm soundcore 8250_fintek dm_mod sr_mod cdrom ata_generic mxm_wmi pata_atiixp ohci_pci wmi button sg autofs4 [last unloaded: aic7xxx]
> [  128.680917] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G        W      3.18.7-lcrs #1
> [  128.685830] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./990FXA-UD5, BIOS FB 01/23/2013
> [  128.690782]  0000000000000009 ffff88044fd43cb8 ffffffff807bde4d 0000000000000000
> [  128.695763]  0000000000000000 ffff88044fd43cf8 ffffffff8024cf7c ffff88043b0ed800
> [  128.700633]  ffff88043cdbc0c0 0000000000000000 0000000000000600 0000000000018840
> [  128.705378] Call Trace:
> [  128.709897]  <IRQ>  [<ffffffff807bde4d>] dump_stack+0x4e/0x71
> [  128.714327]  [<ffffffff8024cf7c>] warn_slowpath_common+0x7c/0xa0
> [  128.718614]  [<ffffffff8024d045>] warn_slowpath_null+0x15/0x20
> [  128.722783]  [<ffffffff806a47e5>] dma_ops_domain_unmap.part.13+0x65/0x70
> [  128.726897]  [<ffffffff806a675b>] __unmap_single.isra.16+0x9b/0x100
> [  128.730921]  [<ffffffff806a7198>] unmap_page+0x48/0x70
> [  128.734950]  [<ffffffffa0157373>] boomerang_rx+0x333/0x600 [3c59x]
> [  128.738959]  [<ffffffffa015784a>] boomerang_interrupt+0x16a/0x4f0 [3c59x]
> [  128.742926]  [<ffffffff8029600e>] handle_irq_event_percpu+0x3e/0x1e0
> [  128.746880]  [<ffffffff802961ec>] handle_irq_event+0x3c/0x60
> [  128.750781]  [<ffffffff80298bfe>] handle_fasteoi_irq+0x7e/0x130
> [  128.754693]  [<ffffffff8020543d>] handle_irq+0x1d/0x30
> [  128.758567]  [<ffffffff80204cee>] do_IRQ+0x4e/0xf0
> [  128.762413]  [<ffffffff807c596a>] common_interrupt+0x6a/0x6a
> [  128.766265]  <EOI>  [<ffffffff802a6e23>] ? hrtimer_start+0x13/0x20
> [  128.770160]  [<ffffffff8020cad7>] ? default_idle+0x17/0x100
> [  128.774066]  [<ffffffff8020d4ca>] arch_cpu_idle+0xa/0x10
> [  128.777943]  [<ffffffff80281dda>] cpu_startup_entry+0x34a/0x380
> [  128.781847]  [<ffffffff802b2cb3>] ? clockevents_register_device+0xe3/0x150
> [  128.785796]  [<ffffffff80233857>] start_secondary+0x157/0x180
> [  128.789749] ---[ end trace ace20602a5302afc ]---
> [  128.793719] ------------[ cut here ]------------
> [  128.797684] WARNING: CPU: 5 PID: 0 at drivers/iommu/amd_iommu.c:2637 dma_ops_domain_unmap.part.13+0x65/0x70()
> [  128.801802] Modules linked in: iscsi_ibft iscsi_boot_sysfs af_packet kvm crc32_pclmul crc32c_intel aesni_intel snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec aes_x86_64 drm snd_hwdep snd_pcm glue_helper lrw aic79xx gf128mul ablk_helper cryptd snd_timer 3c59x scsi_transport_spi snd r8169 xhci_pci xhci_hcd serio_raw pcspkr mii tpm_infineon tpm_tis fam15h_power k10temp i2c_piix4 processor thermal_sys shpchp tpm soundcore 8250_fintek dm_mod sr_mod cdrom ata_generic mxm_wmi pata_atiixp ohci_pci wmi button sg autofs4 [last unloaded: aic7xxx]
> [  128.820266] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G        W      3.18.7-lcrs #1
> [  128.825113] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./990FXA-UD5, BIOS FB 01/23/2013
> [  128.830069]  0000000000000009 ffff88044fd43cb8 ffffffff807bde4d 0000000000000000
> [  128.835083]  0000000000000000 ffff88044fd43cf8 ffffffff8024cf7c 0000000000000600
> [  128.839959]  ffff88043cdbc3b0 0000000000000000 0000000000000600 00000000000766c0
> [  128.844908] Call Trace:
> [  128.849859]  <IRQ>  [<ffffffff807bde4d>] dump_stack+0x4e/0x71
> [  128.854950]  [<ffffffff8024cf7c>] warn_slowpath_common+0x7c/0xa0
> [  128.860112]  [<ffffffff8024d045>] warn_slowpath_null+0x15/0x20
> [  128.865305]  [<ffffffff806a47e5>] dma_ops_domain_unmap.part.13+0x65/0x70
> [  128.870579]  [<ffffffff806a675b>] __unmap_single.isra.16+0x9b/0x100
> [  128.875909]  [<ffffffff806a7198>] unmap_page+0x48/0x70
> [  128.881275]  [<ffffffffa0157373>] boomerang_rx+0x333/0x600 [3c59x]
> [  128.886716]  [<ffffffffa015784a>] boomerang_interrupt+0x16a/0x4f0 [3c59x]
> [  128.892218]  [<ffffffff8029600e>] handle_irq_event_percpu+0x3e/0x1e0
> [  128.897779]  [<ffffffff802961ec>] handle_irq_event+0x3c/0x60
> [  128.903360]  [<ffffffff80298bfe>] handle_fasteoi_irq+0x7e/0x130
> [  128.908988]  [<ffffffff8020543d>] handle_irq+0x1d/0x30
> [  128.914645]  [<ffffffff80204cee>] do_IRQ+0x4e/0xf0
> [  128.920336]  [<ffffffff807c596a>] common_interrupt+0x6a/0x6a
> [  128.926092]  <EOI>  [<ffffffff802a6e23>] ? hrtimer_start+0x13/0x20
> [  128.931943]  [<ffffffff8020cad7>] ? default_idle+0x17/0x100
> [  128.937858]  [<ffffffff8020d4ca>] arch_cpu_idle+0xa/0x10
> [  128.943815]  [<ffffffff80281dda>] cpu_startup_entry+0x34a/0x380
> [  128.949832]  [<ffffffff802b2cb3>] ? clockevents_register_device+0xe3/0x150
> [  128.955935]  [<ffffffff80233857>] start_secondary+0x157/0x180
> [  128.961925] ---[ end trace ace20602a5302afd ]---
> [  130.344563] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000077240 flags=0x0020]
> [  130.350437] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000077260 flags=0x0020]
> [  130.356094] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000077270 flags=0x0020]
> [  132.343625] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000078a00 flags=0x0020]
> [  132.349137] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000078a20 flags=0x0020]
> [  132.349138] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000078a30 flags=0x0020]
> [  134.342698] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000079cc0 flags=0x0020]
> [  134.348385] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000079ce0 flags=0x0020]
> [  134.354179] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x0000000000079cf0 flags=0x0020]
> [  136.341761] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x000000000007be40 flags=0x0020]
> [  136.347463] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x000000000007be70 flags=0x0020]
> [  136.353100] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x000000000007be60 flags=0x0020]
> [  138.340828] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x000000000007d9c0 flags=0x0020]
> [  138.346589] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x000000000007d9e0 flags=0x0020]
> [  138.352461] AMD-Vi: Event logged [IO_PAGE_FAULT device=0f:00.0 domain=0x0001 address=0x000000000007d9f0 flags=0x0020]
>
> # lspci
> 00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (external gfx0 port B) (rev 02)
> 00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD/ATI] RD990 I/O Memory Management Unit (IOMMU)
> 00:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (PCI express gpp port B)
> 00:04.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (PCI express gpp port D)
> 00:09.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (PCI express gpp port H)
> 00:0a.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (external gfx1 port A)
> 00:0b.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (NB-SB link)
> 00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40)
> 00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
> 00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller
> 00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
> 00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller
> 00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus Controller (rev 42)
> 00:14.1 IDE interface: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 IDE Controller (rev 40)
> 00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 Azalia (Intel HDA) (rev 40)
> 00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
> 00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI to PCI Bridge (rev 40)
> 00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
> 00:15.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0)
> 00:15.1 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1)
> 00:15.2 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB900 PCI to PCI bridge (PCIE port 2)
> 00:15.3 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB900 PCI to PCI bridge (PCIE port 3)
> 00:16.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
> 00:16.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller
> 00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor Function 0
> 00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor Function 1
> 00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor Function 2
> 00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor Function 3
> 00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor Function 4
> 00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor Function 5
> 01:00.0 VGA compatible controller: NVIDIA Corporation G70 [GeForce 7800 GT] (rev a1)
> 02:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200A PCI Express-to-PCI Bridge (rev 03)
> 03:04.0 PCI bridge: Pericom Semiconductor PCI to PCI Bridge (rev 02)
> 04:04.0 Intelligent controller [0e80]: PLX Technology, Inc. Device 0480 (rev 55)
> 04:05.0 Intelligent controller [0e80]: PLX Technology, Inc. Device 0480 (rev 55)
> 04:06.0 Intelligent controller [0e80]: PLX Technology, Inc. Device 0480 (rev 55)
> 04:07.0 Intelligent controller [0e80]: PLX Technology, Inc. Device 0480 (rev 55)
> 04:08.0 PCI bridge: Hint Corp HiNT HB4 PCI-PCI Bridge (PCI6150) (rev 04)
> 04:09.0 Unassigned class [ff00]: Compro Computer Services, Inc. PCI RTOM (rev 03)
> 04:0a.0 Memory controller: Compro Computer Services, Inc. Device 4360 (rev 4d)
> 05:00.0 Unassigned class [ff00]: Compro Computer Services, Inc. Device 0100 (rev 31)
> 06:00.0 USB controller: Etron Technology, Inc. EJ168 USB 3.0 Host Controller (rev 01)
> 07:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9172 SATA 6Gb/s Controller (rev 12)
> 08:00.0 PCI bridge: PLX Technology, Inc. PEX 8114 PCI Express-to-PCI/PCI-X Bridge (rev bc)
> 09:04.0 SCSI storage controller: Adaptec ASC-29320ALP U320 (rev 10)
> 0a:06.0 Unassigned class [ff00]: Compro Computer Services, Inc. PCI RTOM (rev 02)
> 0b:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
> 0c:00.0 USB controller: Etron Technology, Inc. EJ168 USB 3.0 Host Controller (rev 01)
> 0d:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9172 SATA 6Gb/s Controller (rev 12)
> 0e:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200A PCI Express-to-PCI Bridge (rev 03)
> 0f:04.0 PCI bridge: Pericom Semiconductor PCI to PCI Bridge (rev 02)
> 10:04.0 Network controller: VMIC GE-IP PCI5565,PMC5565 Reflective Memory Node (rev 01)
> 10:05.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado] (rev 78)
> 10:07.0 PCI bridge: Hint Corp HiNT HB4 PCI-PCI Bridge (PCI6150) (rev 04)
> 10:08.0 PCI bridge: Hint Corp HiNT HB4 PCI-PCI Bridge (PCI6150) (rev 04)
> 10:09.0 Communication controller: Digi International AccelePort Xr 920 (rev 01)
> 10:0a.0 SCSI storage controller: Adaptec AHA-2930CU (rev 03)
> 11:00.0 Unassigned class [ff00]: Compro Computer Services, Inc. Device 4710 (rev 41)
> 12:00.0 Unassigned class [ff00]: Compro Computer Services, Inc. Device 4710 (rev 41)
>
> Verbose lspci attached.
>
> For what it's worth, disks and tapes attached to this controller seem to work before
> this Oops occures.
>
> Thanks and Regards
> Mark
>
