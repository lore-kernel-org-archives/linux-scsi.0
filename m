From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [BUG] mpt2sas: driver init fails on kernel >=4.2 for 9211-8i IT
Date: Mon, 21 Mar 2016 19:29:53 +0530
Message-ID: <CAK=zhgof7owM8bVKx2PJtVpUcYMvszvjfc12DwbPJgkEYPC4yw@mail.gmail.com>
References: <56EF049F.6050809@matthiasprager.de>
	<CAK=zhgqYjocyKkXAiJTxGkxTgX_jWb3Vr_V6oMxprJgbkdpE2A@mail.gmail.com>
	<56EFBC55.9070209@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36638 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbcCUN7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2016 09:59:54 -0400
Received: by mail-oi0-f43.google.com with SMTP id r187so140550231oih.3
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2016 06:59:54 -0700 (PDT)
In-Reply-To: <56EFBC55.9070209@matthiasprager.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Prager <linux@matthiasprager.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi Matthias,

Thanks for providing the logs. In these logs, I am not observing any
such a prints which should be suspected for this issue.

Can you please try once by setting mpt3sas driver's "msix_disable"
module parameter to one.

Also, can you please elaborate below statement for me, I am not able
understand this statement
 "I managed to boot the same 4.5.0 kernel successfully after warm
rebooting from 4.1.20"

Thanks,
Sreekanth

On Mon, Mar 21, 2016 at 2:48 PM, Matthias Prager
<linux@matthiasprager.de> wrote:
> Hi Sreekanth,
>
> thank you for replying so quickly. Here are the logs you requested
> (kernel 4.5.0):
>
>> [    2.083177] mpt3sas version 09.102.00.00 loaded
>> [    2.083757] mpt2sas_cm0: mpt3sas_base_attach
>> [    2.083956] mpt2sas_cm0: mpt3sas_base_map_resources
>> [    2.084708] mpt2sas_cm0: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (3074748 kB)
>> [    2.084964] mpt2sas_cm0: _base_get_ioc_facts
>> [    2.085154] mpt2sas_cm0: _base_wait_for_iocstate
>> [    2.140893]        offset:data
>> [    2.141082]        [0x00]:03100200
>> [    2.141257]        [0x04]:00002300
>> [    2.141432]        [0x08]:00000000
>> [    2.141606]        [0x0c]:00000000
>> [    2.141780]        [0x10]:00000000
>> [    2.141955]        [0x14]:00010480
>> [    2.142129]        [0x18]:22130d68
>> [    2.142303]        [0x1c]:0001285c
>> [    2.142477]        [0x20]:14000400
>> [    2.142651]        [0x24]:00000020
>> [    2.142825]        [0x28]:0100000f
>> [    2.143000]        [0x2c]:000c000b
>> [    2.143174]        [0x30]:003c0003
>> [    2.143349]        [0x34]:0020ffe0
>> [    2.143544]        [0x38]:00800122
>> [    2.143719]        [0x3c]:00000009
>> [    2.143895] mpt2sas_cm0: hba queue depth(3432), max chains per io(128)
>> [    2.144106] mpt2sas_cm0: request frame size(128), reply frame size(128)
>> [    2.144397] mpt2sas_cm0: msix is supported, vector_count(1)
>> [    2.144600] mpt2sas_cm0: MSI-X vectors supported: 1, no of cores: 4, max_msix_vectors: -1
>> [    2.145161] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 58
>> [    2.145361] mpt2sas_cm0: iomem(0x00000000fd4fc000), mapped(0xffffc900000d0000), size(16384)
>> [    2.145591] mpt2sas_cm0: ioport(0x0000000000004000), size(256)
>> [    2.146206] mpt2sas_cm0: _base_get_ioc_facts
>> [    2.146397] mpt2sas_cm0: _base_wait_for_iocstate
>> [    2.202087]        offset:data
>> [    2.202281]        [0x00]:03100200
>> [    2.202456]        [0x04]:00002300
>> [    2.202631]        [0x08]:00000000
>> [    2.202805]        [0x0c]:00000000
>> [    2.202980]        [0x10]:00000000
>> [    2.203154]        [0x14]:00010480
>> [    2.203328]        [0x18]:22130d68
>> [    2.203521]        [0x1c]:0001285c
>> [    2.203695]        [0x20]:14000400
>> [    2.203870]        [0x24]:00000020
>> [    2.204044]        [0x28]:0100000f
>> [    2.204219]        [0x2c]:000c000b
>> [    2.204394]        [0x30]:003c0003
>> [    2.204571]        [0x34]:0020ffe0
>> [    2.204746]        [0x38]:00800122
>> [    2.204926]        [0x3c]:00000009
>> [    2.205102] mpt2sas_cm0: hba queue depth(3432), max chains per io(128)
>> [    2.205314] mpt2sas_cm0: request frame size(128), reply frame size(128)
>> [    2.205528] mpt2sas_cm0: _base_make_ioc_ready
>> [    2.205719] mpt2sas_cm0: _base_get_port_facts
>> [    2.234205]        offset:data
>> [    2.234397]        [0x00]:05070000
>> [    2.234573]        [0x04]:00000000
>> [    2.234748]        [0x08]:00000000
>> [    2.234928]        [0x0c]:00000000
>> [    2.235103]        [0x10]:00000000
>> [    2.235278]        [0x14]:00003000
>> [    2.235453]        [0x18]:00000078
>> [    2.235629] mpt2sas_cm0: _base_allocate_memory_pools
>> [    2.235826] mpt2sas_cm0: scatter gather: sge_in_main_msg(3), sge_per_chain(15), sge_per_io(128), chains_per_io(9)
>> [    2.236227] mpt2sas_cm0: reply post free pool (0xffff8800bb380000): depth(6944),element_size(8), pool_size(54 kB)
>> [    2.236611] mpt2sas_cm0: reply_post_free_dma = (0xbb380000)
>> [    2.236813] mpt2sas_cm0: scsi host: can_queue depth (3307)
>> [    2.237086] mpt2sas_cm0: request pool(0xffff8800ba880000): depth(3432), frame_size(128), pool_size(429 kB)
>> [    2.238580] mpt2sas_cm0: request pool: dma(0xba880000)
>> [    2.238781] mpt2sas_cm0: scsiio(0xffff8800ba880000): depth(3307)
>> [    2.243644] mpt2sas_cm0: chain pool depth(29763), frame_size(128), pool_size(3720 kB)
>> [    2.243887] mpt2sas_cm0: hi_priority(0xffff8800ba8e7600): depth(60), start smid(3308)
>> [    2.244113] mpt2sas_cm0: internal(0xffff8800ba8e9400): depth(65), start smid(3368)
>> [    2.244390] mpt2sas_cm0: sense pool(0xffff8800ba480000): depth(3307), element_size(96), pool_size(310 kB)
>> [    2.244774] mpt2sas_cm0: sense_dma(0xba480000)
>> [    2.245038] mpt2sas_cm0: reply pool(0xffff8800ba500000): depth(3496), frame_size(128), pool_size(437 kB)
>> [    2.245413] mpt2sas_cm0: reply_dma(0xba500000)
>> [    2.245608] mpt2sas_cm0: reply_free pool(0xffff8800ba430000): depth(3496), element_size(4), pool_size(13 kB)
>> [    2.245985] mpt2sas_cm0: reply_free_dma (0xba430000)
>> [    2.246181] mpt2sas_cm0: config page(0xffff8800ba429000): size(512)
>> [    2.246389] mpt2sas_cm0: config_page_dma(0xba429000)
>> [    2.246584] mpt2sas_cm0: Allocated physical memory: size(4964 kB)
>> [    2.246791] mpt2sas_cm0: Current Controller Queue Depth(3307),Max Controller Queue Depth(3432)
>> [    2.247155] mpt2sas_cm0: Scatter Gather Elements per IO(128)
>> [    2.247361] mpt2sas_cm0: _base_make_ioc_operational
>> [    2.247962] mpt2sas_cm0: _base_send_ioc_init
>> [    2.248154]        offset:data
>> [    2.248325]        [0x00]:02000004
>> [    2.248499]        [0x04]:00000000
>> [    2.248673]        [0x08]:00000000
>> [    2.248848]        [0x0c]:23000200
>> [    2.249023]        [0x10]:00000000
>> [    2.249197]        [0x14]:00000000
>> [    2.249372]        [0x18]:00200000
>> [    2.249546]        [0x1c]:0da81b20
>> [    2.249720]        [0x20]:00000000
>> [    2.249894]        [0x24]:00000000
>> [    2.250068]        [0x28]:ba880000
>> [    2.250242]        [0x2c]:00000000
>> [    2.250416]        [0x30]:bb380000
>> [    2.250589]        [0x34]:00000000
>> [    2.250768]        [0x38]:ba430000
>> [    2.250941]        [0x3c]:00000000
>> [    2.251115]        [0x40]:983eb686
>> [    2.251288]        [0x44]:00000153
>> [    2.296610]        offset:data
>> [    2.296795]        [0x00]:02050004
>> [    2.296969]        [0x04]:00000000
>> [    2.297143]        [0x08]:00000000
>> [    2.297318]        [0x0c]:00000000
>> [    2.297493]        [0x10]:00000000
>> [    2.297668] mpt2sas_cm0: _base_event_notification
>> [    5.093707] floppy0: no floppy controllers found
>> [   32.293619] mpt2sas_cm0: _base_event_notification: timeout
>> [   32.293909] mf:
>>
>> [   32.294132] 07000000
>> [   32.294397] 00000000
>> [   32.294445] 00000000
>> [   32.294719] 00000000
>> [   32.294767] 00000000
>> [   32.295031] 0f2f7fff
>> [   32.295078] ffffff7c
>> [   32.295342] ffffffff
>> [   32.295389]
>>
>> [   32.295823] ffffffff
>> [   32.295871] 00000000
>> [   32.296134] 00000000
>>
>> [   32.296615] mpt2sas_cm0: mpt3sas_base_free_resources
>> [   32.296880] mpt2sas_cm0: _base_make_ioc_ready
>> [   32.297135] mpt2sas_cm0: sending message unit reset !!
>> [   32.298941] mpt2sas_cm0: message unit reset: SUCCESS
>> [   32.299212] mpt2sas_cm0: mpt3sas_base_unmap_resources
>> [   32.300381] mpt2sas_cm0: _base_release_memory_pools
>> [   32.300654] mpt2sas_cm0: request_pool(0xffff8800ba880000): free
>> [   32.300934] mpt2sas_cm0: sense_pool(0xffff8800ba480000): free
>> [   32.301211] mpt2sas_cm0: reply_pool(0xffff8800ba500000): free
>> [   32.301485] mpt2sas_cm0: reply_free_pool(0xffff8800ba430000): free
>> [   32.301774] mpt2sas_cm0: reply_post_free_pool(0xffff8800bb380000): free
>> [   32.302061] mpt2sas_cm0: config_page(0xffff8800ba429000): free
>> [   32.371097] mpt2sas_cm0: failure at drivers/scsi/mpt3sas/mpt3sas_scsih.c:8592/_scsih_probe()!
>> [   32.371958] mpt2sas_cm1: mpt3sas_base_attach
>> [   32.372154] mpt2sas_cm1: mpt3sas_base_map_resources
>> [   32.372950] mpt2sas_cm1: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (3074748 kB)
>> [   32.373201] mpt2sas_cm1: _base_get_ioc_facts
>> [   32.375261] mpt2sas_cm1: _base_wait_for_iocstate
>> [   32.432012]        offset:data
>> [   32.432262]        [0x00]:03100200
>> [   32.432499]        [0x04]:00002300
>> [   32.432735]        [0x08]:00000000
>> [   32.432971]        [0x0c]:00000000
>> [   32.433206]        [0x10]:00000000
>> [   32.433443]        [0x14]:00010480
>> [   32.433701]        [0x18]:22130d68
>> [   32.433937]        [0x1c]:0001285c
>> [   32.435434]        [0x20]:14000400
>> [   32.435674]        [0x24]:00000020
>> [   32.435909]        [0x28]:0100000f
>> [   32.436144]        [0x2c]:000c000b
>> [   32.436379]        [0x30]:003c0003
>> [   32.436615]        [0x34]:0020ffe0
>> [   32.436850]        [0x38]:00800122
>> [   32.437085]        [0x3c]:00000009
>> [   32.437322] mpt2sas_cm1: hba queue depth(3432), max chains per io(128)
>> [   32.437607] mpt2sas_cm1: request frame size(128), reply frame size(128)
>> [   32.438014] mpt2sas_cm1: msix is supported, vector_count(1)
>> [   32.438288] mpt2sas_cm1: MSI-X vectors supported: 1, no of cores: 4, max_msix_vectors: 8
>> [   32.439101] mpt2sas1-msix0: PCI-MSI-X enabled: IRQ 58
>> [   32.439373] mpt2sas_cm1: iomem(0x00000000fd1fc000), mapped(0xffffc900000d8000), size(16384)
>> [   32.439682] mpt2sas_cm1: ioport(0x0000000000007000), size(256)
>> [   32.440504] mpt2sas_cm1: _base_get_ioc_facts
>> [   32.440765] mpt2sas_cm1: _base_wait_for_iocstate
>> [   32.499305]        offset:data
>> [   32.499557]        [0x00]:03100200
>> [   32.499794]        [0x04]:00002300
>> [   32.500031]        [0x08]:00000000
>> [   32.500267]        [0x0c]:00000000
>> [   32.500504]        [0x10]:00000000
>> [   32.500740]        [0x14]:00010480
>> [   32.500974]        [0x18]:22130d68
>> [   32.501209]        [0x1c]:0001285c
>> [   32.501444]        [0x20]:14000400
>> [   32.501687]        [0x24]:00000020
>> [   32.501922]        [0x28]:0100000f
>> [   32.502157]        [0x2c]:000c000b
>> [   32.502391]        [0x30]:003c0003
>> [   32.502626]        [0x34]:0020ffe0
>> [   32.502862]        [0x38]:00800122
>> [   32.503098]        [0x3c]:00000009
>> [   32.503336] mpt2sas_cm1: hba queue depth(3432), max chains per io(128)
>> [   32.503644] mpt2sas_cm1: request frame size(128), reply frame size(128)
>> [   32.503933] mpt2sas_cm1: _base_make_ioc_ready
>> [   32.504191] mpt2sas_cm1: _base_get_port_facts
>> [   32.534282]        offset:data
>> [   32.534537]        [0x00]:05070000
>> [   32.534782]        [0x04]:00000000
>> [   32.535058]        [0x08]:00000000
>> [   32.536473]        [0x0c]:00000000
>> [   32.536710]        [0x10]:00000000
>> [   32.536946]        [0x14]:00003000
>> [   32.537183]        [0x18]:00000078
>> [   32.537420] mpt2sas_cm1: _base_allocate_memory_pools
>> [   32.537686] mpt2sas_cm1: scatter gather: sge_in_main_msg(3), sge_per_chain(15), sge_per_io(128), chains_per_io(9)
>> [   32.538232] mpt2sas_cm1: reply post free pool (0xffff8800bb3d0000): depth(6944),element_size(8), pool_size(54 kB)
>> [   32.538758] mpt2sas_cm1: reply_post_free_dma = (0xbb3d0000)
>> [   32.539030] mpt2sas_cm1: scsi host: can_queue depth (3307)
>> [   32.539378] mpt2sas_cm1: request pool(0xffff8800ba480000): depth(3432), frame_size(128), pool_size(429 kB)
>> [   32.539882] mpt2sas_cm1: request pool: dma(0xba480000)
>> [   32.540149] mpt2sas_cm1: scsiio(0xffff8800ba480000): depth(3307)
>> [   32.545893] mpt2sas_cm1: chain pool depth(29763), frame_size(128), pool_size(3720 kB)
>> [   32.546137] mpt2sas_cm1: hi_priority(0xffff8800ba4e7600): depth(60), start smid(3308)
>> [   32.546365] mpt2sas_cm1: internal(0xffff8800ba4e9400): depth(65), start smid(3368)
>> [   32.546651] mpt2sas_cm1: sense pool(0xffff8800ba880000): depth(3307), element_size(96), pool_size(310 kB)
>> [   32.547030] mpt2sas_cm1: sense_dma(0xba880000)
>> [   32.547537] mpt2sas_cm1: reply pool(0xffff880000100000): depth(3496), frame_size(128), pool_size(437 kB)
>> [   32.547921] mpt2sas_cm1: reply_dma(0x100000)
>> [   32.548117] mpt2sas_cm1: reply_free pool(0xffff8800ba964000): depth(3496), element_size(4), pool_size(13 kB)
>> [   32.548500] mpt2sas_cm1: reply_free_dma (0xba964000)
>> [   32.548698] mpt2sas_cm1: config page(0xffff8800ba960000): size(512)
>> [   32.548908] mpt2sas_cm1: config_page_dma(0xba960000)
>> [   32.549105] mpt2sas_cm1: Allocated physical memory: size(4964 kB)
>> [   32.549314] mpt2sas_cm1: Current Controller Queue Depth(3307),Max Controller Queue Depth(3432)
>> [   32.550950] mpt2sas_cm1: Scatter Gather Elements per IO(128)
>> [   32.551160] mpt2sas_cm1: _base_make_ioc_operational
>> [   32.551855] mpt2sas_cm1: _base_send_ioc_init
>> [   32.552051]        offset:data
>> [   32.552224]        [0x00]:02000004
>> [   32.552400]        [0x04]:00000000
>> [   32.552576]        [0x08]:00000000
>> [   32.552761]        [0x0c]:23000200
>> [   32.552937]        [0x10]:00000000
>> [   32.553114]        [0x14]:00000000
>> [   32.553291]        [0x18]:00200000
>> [   32.553468]        [0x1c]:0da81b20
>> [   32.553685]        [0x20]:00000000
>> [   32.553862]        [0x24]:00000000
>> [   32.554038]        [0x28]:ba480000
>> [   32.554215]        [0x2c]:00000000
>> [   32.554393]        [0x30]:bb3d0000
>> [   32.554569]        [0x34]:00000000
>> [   32.554752]        [0x38]:ba964000
>> [   32.554929]        [0x3c]:00000000
>> [   32.555106]        [0x40]:983f2ce6
>> [   32.555283]        [0x44]:00000153
>> [   32.601516]        offset:data
>> [   32.601768]        [0x00]:02050004
>> [   32.602003]        [0x04]:00000000
>> [   32.602239]        [0x08]:00000000
>> [   32.602474]        [0x0c]:00000000
>> [   32.602709]        [0x10]:00000000
>> [   32.602945] mpt2sas_cm1: _base_event_notification
>> [   62.593604] mpt2sas_cm1: _base_event_notification: timeout
>> [   62.593906] mf:
>>
>> [   62.594127] 07000000
>> [   62.594390] 00000000
>> [   62.594438] 00000000
>> [   62.594709] 00000000
>> [   62.594757] 00000000
>> [   62.595019] 0f2f7fff
>> [   62.595067] ffffff7c
>> [   62.595330] ffffffff
>> [   62.595377]
>>
>> [   62.595808] ffffffff
>> [   62.595855] 00000000
>> [   62.596117] 00000000
>>
>> [   62.596601] mpt2sas_cm1: mpt3sas_base_free_resources
>> [   62.596871] mpt2sas_cm1: _base_make_ioc_ready
>> [   62.597125] mpt2sas_cm1: sending message unit reset !!
>> [   62.599013] mpt2sas_cm1: message unit reset: SUCCESS
>> [   62.599283] mpt2sas_cm1: mpt3sas_base_unmap_resources
>> [   62.600443] mpt2sas_cm1: _base_release_memory_pools
>> [   62.600721] mpt2sas_cm1: request_pool(0xffff8800ba480000): free
>> [   62.601002] mpt2sas_cm1: sense_pool(0xffff8800ba880000): free
>> [   62.601280] mpt2sas_cm1: reply_pool(0xffff880000100000): free
>> [   62.601560] mpt2sas_cm1: reply_free_pool(0xffff8800ba964000): free
>> [   62.601845] mpt2sas_cm1: reply_post_free_pool(0xffff8800bb3d0000): free
>> [   62.602133] mpt2sas_cm1: config_page(0xffff8800ba960000): free
>> [   62.673591] mpt2sas_cm1: failure at drivers/scsi/mpt3sas/mpt3sas_scsih.c:8592/_scsih_probe()!
>
> These are for two controllers, I don't know whether the output from the
> second is helpful at all - I added it anyway.
>
>
> I managed to boot the same 4.5.0 kernel successfully after warm
> rebooting from 4.1.20. That gave me this dmesg output (for comparison):
>
>> [    2.057685] mpt3sas version 09.102.00.00 loaded
>> [    2.058371] mpt2sas_cm0: mpt3sas_base_attach
>> [    2.058632] mpt2sas_cm0: mpt3sas_base_map_resources
>> [    2.059583] mpt2sas_cm0: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (3074748 kB)
>> [    2.059911] mpt2sas_cm0: _base_get_ioc_facts
>> [    2.060166] mpt2sas_cm0: _base_wait_for_iocstate
>> [    2.116337]        offset:data
>> [    2.116576]        [0x00]:03100200
>> [    2.116817]        [0x04]:00002300
>> [    2.117051]        [0x08]:00000000
>> [    2.117285]        [0x0c]:00000000
>> [    2.117518]        [0x10]:00000000
>> [    2.117752]        [0x14]:00010480
>> [    2.117986]        [0x18]:22130d68
>> [    2.118220]        [0x1c]:0001285c
>> [    2.119624]        [0x20]:14000400
>> [    2.119858]        [0x24]:00000020
>> [    2.120093]        [0x28]:0100000f
>> [    2.120351]        [0x2c]:000c000b
>> [    2.120586]        [0x30]:003c0003
>> [    2.120820]        [0x34]:0020ffe0
>> [    2.121055]        [0x38]:00800122
>> [    2.121288]        [0x3c]:00000009
>> [    2.121524] mpt2sas_cm0: hba queue depth(3432), max chains per io(128)
>> [    2.121808] mpt2sas_cm0: request frame size(128), reply frame size(128)
>> [    2.122195] mpt2sas_cm0: msix is supported, vector_count(1)
>> [    2.122468] mpt2sas_cm0: MSI-X vectors supported: 1, no of cores: 4, max_msix_vectors: -1
>> [    2.123239] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 58
>> [    2.123507] mpt2sas_cm0: iomem(0x00000000fd4fc000), mapped(0xffffc900000d0000), size(16384)
>> [    2.123816] mpt2sas_cm0: ioport(0x0000000000004000), size(256)
>> [    2.124623] mpt2sas_cm0: _base_get_ioc_facts
>> [    2.124878] mpt2sas_cm0: _base_wait_for_iocstate
>> [    2.180907]        offset:data
>> [    2.181145]        [0x00]:03100200
>> [    2.181379]        [0x04]:00002300
>> [    2.181613]        [0x08]:00000000
>> [    2.181847]        [0x0c]:00000000
>> [    2.182081]        [0x10]:00000000
>> [    2.182315]        [0x14]:00010480
>> [    2.182547]        [0x18]:22130d68
>> [    2.182781]        [0x1c]:0001285c
>> [    2.183014]        [0x20]:14000400
>> [    2.183248]        [0x24]:00000020
>> [    2.183481]        [0x28]:0100000f
>> [    2.183720]        [0x2c]:000c000b
>> [    2.183954]        [0x30]:003c0003
>> [    2.184190]        [0x34]:0020ffe0
>> [    2.184424]        [0x38]:00800122
>> [    2.184658]        [0x3c]:00000009
>> [    2.184893] mpt2sas_cm0: hba queue depth(3432), max chains per io(128)
>> [    2.185177] mpt2sas_cm0: request frame size(128), reply frame size(128)
>> [    2.185462] mpt2sas_cm0: _base_make_ioc_ready
>> [    2.185717] mpt2sas_cm0: _base_get_port_facts
>> [    2.214057]        offset:data
>> [    2.214295]        [0x00]:05070000
>> [    2.214529]        [0x04]:00000000
>> [    2.214762]        [0x08]:00000000
>> [    2.214997]        [0x0c]:00000000
>> [    2.215230]        [0x10]:00000000
>> [    2.215464]        [0x14]:00003000
>> [    2.215697]        [0x18]:00000078
>> [    2.215931] mpt2sas_cm0: _base_allocate_memory_pools
>> [    2.216194] mpt2sas_cm0: scatter gather: sge_in_main_msg(3), sge_per_chain(15), sge_per_io(128), chains_per_io(9)
>> [    2.216734] mpt2sas_cm0: reply post free pool (0xffff8800bafc0000): depth(6944),element_size(8), pool_size(54 kB)
>> [    2.217244] mpt2sas_cm0: reply_post_free_dma = (0xbafc0000)
>> [    2.217514] mpt2sas_cm0: scsi host: can_queue depth (3307)
>> [    2.217866] mpt2sas_cm0: request pool(0xffff8800ba800000): depth(3432), frame_size(128), pool_size(429 kB)
>> [    2.218369] mpt2sas_cm0: request pool: dma(0xba800000)
>> [    2.218637] mpt2sas_cm0: scsiio(0xffff8800ba800000): depth(3307)
>> [    2.224773] mpt2sas_cm0: chain pool depth(29763), frame_size(128), pool_size(3720 kB)
>> [    2.225092] mpt2sas_cm0: hi_priority(0xffff8800ba867600): depth(60), start smid(3308)
>> [    2.225395] mpt2sas_cm0: internal(0xffff8800ba869400): depth(65), start smid(3368)
>> [    2.225958] mpt2sas_cm0: sense pool(0xffff8800ba480000): depth(3307), element_size(96), pool_size(310 kB)
>> [    2.226457] mpt2sas_cm0: sense_dma(0xba480000)
>> [    2.227039] mpt2sas_cm0: reply pool(0xffff8800ba500000): depth(3496), frame_size(128), pool_size(437 kB)
>> [    2.227413] mpt2sas_cm0: reply_dma(0xba500000)
>> [    2.227616] mpt2sas_cm0: reply_free pool(0xffff8800ba450000): depth(3496), element_size(4), pool_size(13 kB)
>> [    2.227992] mpt2sas_cm0: reply_free_dma (0xba450000)
>> [    2.228192] mpt2sas_cm0: config page(0xffff8800ba43b000): size(512)
>> [    2.228402] mpt2sas_cm0: config_page_dma(0xba43b000)
>> [    2.228598] mpt2sas_cm0: Allocated physical memory: size(4964 kB)
>> [    2.228806] mpt2sas_cm0: Current Controller Queue Depth(3307),Max Controller Queue Depth(3432)
>> [    2.229171] mpt2sas_cm0: Scatter Gather Elements per IO(128)
>> [    2.229378] mpt2sas_cm0: _base_make_ioc_operational
>> [    2.229959] mpt2sas_cm0: _base_send_ioc_init
>> [    2.230151]        offset:data
>> [    2.230323]        [0x00]:02000004
>> [    2.230499]        [0x04]:00000000
>> [    2.230675]        [0x08]:00000000
>> [    2.230851]        [0x0c]:23000200
>> [    2.231026]        [0x10]:00000000
>> [    2.231201]        [0x14]:00000000
>> [    2.231376]        [0x18]:00200000
>> [    2.231551]        [0x1c]:0da81b20
>> [    2.231726]        [0x20]:00000000
>> [    2.231900]        [0x24]:00000000
>> [    2.232075]        [0x28]:ba800000
>> [    2.232250]        [0x2c]:00000000
>> [    2.232423]        [0x30]:bafc0000
>> [    2.232597]        [0x34]:00000000
>> [    2.232775]        [0x38]:ba450000
>> [    2.232950]        [0x3c]:00000000
>> [    2.233125]        [0x40]:98596e4f
>> [    2.233299]        [0x44]:00000153
>> [    2.278752]        offset:data
>> [    2.278988]        [0x00]:02050004
>> [    2.279220]        [0x04]:00000000
>> [    2.279453]        [0x08]:00000000
>> [    2.279685]        [0x0c]:00000000
>> [    2.279918]        [0x10]:00000000
>> [    2.280151] mpt2sas_cm0: _base_event_notification
>> [    2.280537] mpt2sas_cm0: _base_event_notification: complete
>> [    2.281694] mpt2sas_cm0: LSISAS2008: FWVersion(20.00.04.00), ChipRevision(0x03), BiosVersion(07.39.00.00)
>> [    2.282196] mpt2sas_cm0: Protocol=(
>> [    2.282261] Initiator
>> [    2.282522] ,Target
>> [    2.282567] ),
>> [    2.282824] Capabilities=(
>> [    2.282877] TLR
>> [    2.283132] ,EEDP
>> [    2.283175] ,Snapshot Buffer
>> [    2.283444] ,Diag Trace Buffer
>> [    2.283502] ,Task Set Full
>> [    2.283774] ,NCQ
>> [    2.283816] )
>> [    2.284350] scsi host0: Fusion MPT SAS Host
>> [    2.299028] mpt2sas_cm0: sending port enable !!
>> [    2.299540] mpt2sas_cm0: Discovery: (start)
>>
>> [    2.299972] mpt2sas_cm0: SAS Enclosure Device Status Change
>> [    2.299984] mpt2sas_cm0: discovery event: (start)
>>
>> [    2.300554] mpt2sas_cm0: SAS Topology Change List
>> [    2.300759] mpt2sas_cm0: Discovery: (stop)
>>
>> [    2.301146] mpt2sas_cm0: Discovery: (start)
>>
>> [    2.301535] mpt2sas_cm0: Discovery: (stop)
>>
>> [    2.301927] mpt2sas_cm0: Discovery: (start)
>>
>> [    2.302316] mpt2sas_cm0: Discovery: (stop)
>>
>> [    2.302707] mpt2sas_cm0: Discovery: (start)
>>
>> [    2.304908] mpt2sas_cm0: Discovery: (stop)
>>
>> [    2.305297] mpt2sas_cm0: Discovery: (start)
>>
>> [    2.306776] mpt2sas_cm0: Discovery: (stop)
>>
>> [    2.307166] mpt2sas_cm0: Discovery: (start)
>>
>> [    2.307559] mpt2sas_cm0: Discovery: (stop)
>>
>> [    2.307948] mpt2sas_cm0: Discovery: (start)
>>
>> [    2.308336] mpt2sas_cm0: Discovery: (stop)
>>
>> [    2.311738] mpt2sas_cm0: host_add: handle(0x0001), sas_addr(0x500605b003683dd0), phys(8)
>> [    2.312097] mpt2sas_cm0: enclosure status change: (enclosure add)
>>                       handle(0x0001), enclosure logical id(0x500605b003683dd0) number slots(0)
>> [    2.312551] mpt2sas_cm0: sas topology change: (responding)
>> [    2.312768]        handle(0x0000), enclosure_handle(0x0001) start_phy(00), count(8)
>> [    2.313003]        phy(01), attached_handle(0x0009): target add: link rate: new(0x0a), old(0x00)
>> [    2.313250]        phy(02), attached_handle(0x000a): target add: link rate: new(0x09), old(0x00)
>> [    2.313498]        phy(03), attached_handle(0x000b): target add: link rate: new(0x09), old(0x00)
>> [    2.313745]        phy(04), attached_handle(0x000c): target add: link rate: new(0x09), old(0x00)
>> [    2.313992]        phy(05), attached_handle(0x000d): target add: link rate: new(0x09), old(0x00)
>> [    2.314248]        phy(06), attached_handle(0x000e): target add: link rate: new(0x09), old(0x00)
>> [    2.314495]        phy(07), attached_handle(0x000f): target add: link rate: new(0x09), old(0x00)
>> [    2.314747] mpt2sas_cm0: updating handles for sas_host(0x500605b003683dd0)
>> [    2.316041] mpt2sas_cm0: _scsih_sas_device_init_add: handle(0x0009), sas_addr(0x4433221101000000)
>> [    2.316465] mpt2sas_cm0: _scsih_sas_device_init_add: enclosure logical id(0x500605b003683dd0), slot( 2)
>> [    2.317200] mpt2sas_cm0: _scsih_sas_device_init_add: handle(0x000a), sas_addr(0x4433221102000000)
>> [    2.317669] mpt2sas_cm0: _scsih_sas_device_init_add: enclosure logical id(0x500605b003683dd0), slot( 1)
>> [    2.318431] mpt2sas_cm0: _scsih_sas_device_init_add: handle(0x000b), sas_addr(0x4433221103000000)
>> [    2.318900] mpt2sas_cm0: _scsih_sas_device_init_add: enclosure logical id(0x500605b003683dd0), slot( 0)
>> [    2.319366] mpt2sas_cm0: _scsih_determine_boot_device: current_boot_device(0x4433221103000000)
>> [    2.320151] mpt2sas_cm0: _scsih_sas_device_init_add: handle(0x000c), sas_addr(0x4433221104000000)
>> [    2.321371] mpt2sas_cm0: _scsih_sas_device_init_add: enclosure logical id(0x500605b003683dd0), slot( 7)
>> [    2.322137] mpt2sas_cm0: _scsih_sas_device_init_add: handle(0x000d), sas_addr(0x4433221105000000)
>> [    2.322606] mpt2sas_cm0: _scsih_sas_device_init_add: enclosure logical id(0x500605b003683dd0), slot( 6)
>> [    2.323367] mpt2sas_cm0: _scsih_sas_device_init_add: handle(0x000e), sas_addr(0x4433221106000000)
>> [    2.323834] mpt2sas_cm0: _scsih_sas_device_init_add: enclosure logical id(0x500605b003683dd0), slot( 5)
>> [    2.324602] mpt2sas_cm0: _scsih_sas_device_init_add: handle(0x000f), sas_addr(0x4433221107000000)
>> [    2.325071] mpt2sas_cm0: _scsih_sas_device_init_add: enclosure logical id(0x500605b003683dd0), slot( 4)
>> [    2.325541] mpt2sas_cm0: discovery event: (stop)
>>
>> [    2.326017] mpt2sas_cm0: discovery event: (start)
>>
>> [    2.326492] mpt2sas_cm0: discovery event: (stop)
>>
>> [    2.326975] mpt2sas_cm0: discovery event: (start)
>>
>> [    2.327450] mpt2sas_cm0: discovery event: (stop)
>>
>> [    2.327923] mpt2sas_cm0: discovery event: (start)
>>
>> [    2.328396] mpt2sas_cm0: discovery event: (stop)
>>
>> [    2.328868] mpt2sas_cm0: discovery event: (start)
>>
>> [    2.329340] mpt2sas_cm0: discovery event: (stop)
>>
>> [    2.329816] mpt2sas_cm0: discovery event: (start)
>>
>> [    2.330316] mpt2sas_cm0: discovery event: (stop)
>>
>> [    2.330797] mpt2sas_cm0: discovery event: (start)
>>
>> [    2.331269] mpt2sas_cm0: discovery event: (stop)
>>
>> [    2.331740] mpt2sas_cm0: port enable: complete from worker thread
>> [    2.350236] mpt2sas_cm0: port enable: SUCCESS
>> [    2.356432] scsi 0:0:0:0: Direct-Access     ATA      ST3750330NS      SN06 PQ: 0 ANSI: 6
>> [    2.356683] scsi 0:0:0:0: SATA: handle(0x000b), sas_addr(0x4433221103000000), phy(3), device_name(0x5000c5000267c9f8)
>> [    2.357080] scsi 0:0:0:0: SATA: enclosure_logical_id(0x500605b003683dd0), slot(0)
>> [    2.357405] scsi 0:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
>> [    2.383043] scsi 0:0:1:0: Direct-Access     ATA      Hitachi HDS5C302 A800 PQ: 0 ANSI: 6
>> [    2.383296] scsi 0:0:1:0: SATA: handle(0x0009), sas_addr(0x4433221101000000), phy(1), device_name(0x5000cca369cdd311)
>> [    2.383684] scsi 0:0:1:0: SATA: enclosure_logical_id(0x500605b003683dd0), slot(2)
>> [    2.384028] scsi 0:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
>> [    2.405088] scsi 0:0:2:0: Direct-Access     ATA      ST3750330NS      SN06 PQ: 0 ANSI: 6
>> [    2.405346] scsi 0:0:2:0: SATA: handle(0x000a), sas_addr(0x4433221102000000), phy(2), device_name(0x5000c5000ccfbd32)
>> [    2.405735] scsi 0:0:2:0: SATA: enclosure_logical_id(0x500605b003683dd0), slot(1)
>> [    2.406082] scsi 0:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
>> [    2.424125] scsi 0:0:3:0: Direct-Access     ATA      ST3750330NS      SN06 PQ: 0 ANSI: 6
>> [    2.424373] scsi 0:0:3:0: SATA: handle(0x000c), sas_addr(0x4433221104000000), phy(4), device_name(0x5000c5000267abee)
>> [    2.424763] scsi 0:0:3:0: SATA: enclosure_logical_id(0x500605b003683dd0), slot(7)
>> [    2.425108] scsi 0:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
>> [    2.444834] scsi 0:0:4:0: Direct-Access     ATA      ST3750330NS      SN06 PQ: 0 ANSI: 6
>> [    2.445086] scsi 0:0:4:0: SATA: handle(0x000d), sas_addr(0x4433221105000000), phy(5), device_name(0x5000c50009c0e5e6)
>> [    2.445478] scsi 0:0:4:0: SATA: enclosure_logical_id(0x500605b003683dd0), slot(6)
>> [    2.445803] scsi 0:0:4:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
>> [    2.464065] scsi 0:0:5:0: Direct-Access     ATA      ST3750330NS      SN16 PQ: 0 ANSI: 6
>> [    2.464312] scsi 0:0:5:0: SATA: handle(0x000e), sas_addr(0x4433221106000000), phy(6), device_name(0x5000c5003cb9ac10)
>> [    2.464699] scsi 0:0:5:0: SATA: enclosure_logical_id(0x500605b003683dd0), slot(5)
>> [    2.465048] scsi 0:0:5:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
>> [    2.484016] scsi 0:0:6:0: Direct-Access     ATA      ST3750330NS      SN06 PQ: 0 ANSI: 6
>> [    2.484266] scsi 0:0:6:0: SATA: handle(0x000f), sas_addr(0x4433221107000000), phy(7), device_name(0x5000c5000839b69e)
>> [    2.484655] scsi 0:0:6:0: SATA: enclosure_logical_id(0x500605b003683dd0), slot(4)
>> [    2.485001] scsi 0:0:6:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
>> [    2.500660] mpt2sas_cm1: mpt3sas_base_attach
>> [    2.500861] mpt2sas_cm1: mpt3sas_base_map_resources
>> [    2.501599] mpt2sas_cm1: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (3074748 kB)
>> [    2.501847] mpt2sas_cm1: _base_get_ioc_facts
>> [    2.502036] mpt2sas_cm1: _base_wait_for_iocstate
>> [    2.559080]        offset:data
>> [    2.559318]        [0x00]:03100200
>> [    2.559552]        [0x04]:00002300
>> [    2.559785]        [0x08]:00000000
>> [    2.560020]        [0x0c]:00000000
>> [    2.560277]        [0x10]:00000000
>> [    2.560511]        [0x14]:00010480
>> [    2.560745]        [0x18]:22130d68
>> [    2.560978]        [0x1c]:0001285c
>> [    2.561210]        [0x20]:14000400
>> [    2.561443]        [0x24]:00000020
>> [    2.561675]        [0x28]:0100000f
>> [    2.561907]        [0x2c]:000c000b
>> [    2.562139]        [0x30]:003c0003
>> [    2.562371]        [0x34]:0020ffe0
>> [    2.562602]        [0x38]:00800122
>> [    2.562839]        [0x3c]:00000009
>> [    2.563073] mpt2sas_cm1: hba queue depth(3432), max chains per io(128)
>> [    2.563355] mpt2sas_cm1: request frame size(128), reply frame size(128)
>> [    2.563745] mpt2sas_cm1: msix is supported, vector_count(1)
>> [    2.564016] mpt2sas_cm1: MSI-X vectors supported: 1, no of cores: 4, max_msix_vectors: 8
>> [    2.564918] mpt2sas1-msix0: PCI-MSI-X enabled: IRQ 59
>> [    2.566189] mpt2sas_cm1: iomem(0x00000000fd1fc000), mapped(0xffffc900000d8000), size(16384)
>> [    2.566498] mpt2sas_cm1: ioport(0x0000000000007000), size(256)
>> [    2.567328] mpt2sas_cm1: _base_get_ioc_facts
>> [    2.567583] mpt2sas_cm1: _base_wait_for_iocstate
>> [    2.625125]        offset:data
>> [    2.625364]        [0x00]:03100200
>> [    2.625597]        [0x04]:00002300
>> [    2.625830]        [0x08]:00000000
>> [    2.626064]        [0x0c]:00000000
>> [    2.626296]        [0x10]:00000000
>> [    2.626529]        [0x14]:00010480
>> [    2.626769]        [0x18]:22130d68
>> [    2.627002]        [0x1c]:0001285c
>> [    2.627235]        [0x20]:14000400
>> [    2.627467]        [0x24]:00000020
>> [    2.627702]        [0x28]:0100000f
>> [    2.627936]        [0x2c]:000c000b
>> [    2.628170]        [0x30]:003c0003
>> [    2.628403]        [0x34]:0020ffe0
>> [    2.628638]        [0x38]:00800122
>> [    2.628872]        [0x3c]:00000009
>> [    2.629107] mpt2sas_cm1: hba queue depth(3432), max chains per io(128)
>> [    2.629388] mpt2sas_cm1: request frame size(128), reply frame size(128)
>> [    2.629671] mpt2sas_cm1: _base_make_ioc_ready
>> [    2.629928] mpt2sas_cm1: _base_get_port_facts
>> [    2.660127]        offset:data
>> [    2.660389]        [0x00]:05070000
>> [    2.660623]        [0x04]:00000000
>> [    2.660858]        [0x08]:00000000
>> [    2.661093]        [0x0c]:00000000
>> [    2.661326]        [0x10]:00000000
>> [    2.661562]        [0x14]:00003000
>> [    2.661796]        [0x18]:00000078
>> [    2.664346] mpt2sas_cm1: _base_allocate_memory_pools
>> [    2.664608] mpt2sas_cm1: scatter gather: sge_in_main_msg(3), sge_per_chain(15), sge_per_io(128), chains_per_io(9)
>> [    2.665142] mpt2sas_cm1: reply post free pool (0xffff8800b8b10000): depth(6944),element_size(8), pool_size(54 kB)
>> [    2.666671] mpt2sas_cm1: reply_post_free_dma = (0xb8b10000)
>> [    2.666954] mpt2sas_cm1: scsi host: can_queue depth (3307)
>> [    2.667311] mpt2sas_cm1: request pool(0xffff8800b8b80000): depth(3432), frame_size(128), pool_size(429 kB)
>> [    2.667813] mpt2sas_cm1: request pool: dma(0xb8b80000)
>> [    2.668080] mpt2sas_cm1: scsiio(0xffff8800b8b80000): depth(3307)
>> [    2.674131] mpt2sas_cm1: chain pool depth(29763), frame_size(128), pool_size(3720 kB)
>> [    2.674448] mpt2sas_cm1: hi_priority(0xffff8800b8be7600): depth(60), start smid(3308)
>> [    2.674750] mpt2sas_cm1: internal(0xffff8800b8be9400): depth(65), start smid(3368)
>> [    2.675105] mpt2sas_cm1: sense pool(0xffff8800b8100000): depth(3307), element_size(96), pool_size(310 kB)
>> [    2.675605] mpt2sas_cm1: sense_dma(0xb8100000)
>> [    2.675944] mpt2sas_cm1: reply pool(0xffff8800b8180000): depth(3496), frame_size(128), pool_size(437 kB)
>> [    2.676443] mpt2sas_cm1: reply_dma(0xb8180000)
>> [    2.676702] mpt2sas_cm1: reply_free pool(0xffff8800b80a0000): depth(3496), element_size(4), pool_size(13 kB)
>> [    2.677124] mpt2sas_cm1: reply_free_dma (0xb80a0000)
>> [    2.677322] mpt2sas_cm1: config page(0xffff8800b807f000): size(512)
>> [    2.677532] mpt2sas_cm1: config_page_dma(0xb807f000)
>> [    2.677728] mpt2sas_cm1: Allocated physical memory: size(4964 kB)
>> [    2.677936] mpt2sas_cm1: Current Controller Queue Depth(3307),Max Controller Queue Depth(3432)
>> [    2.678304] mpt2sas_cm1: Scatter Gather Elements per IO(128)
>> [    2.678514] mpt2sas_cm1: _base_make_ioc_operational
>> [    2.679081] mpt2sas_cm1: _base_send_ioc_init
>> [    2.679275]        offset:data
>> [    2.679448]        [0x00]:02000004
>> [    2.679625]        [0x04]:00000000
>> [    2.679805]        [0x08]:00000000
>> [    2.681200]        [0x0c]:23000200
>> [    2.681377]        [0x10]:00000000
>> [    2.681554]        [0x14]:00000000
>> [    2.681729]        [0x18]:00200000
>> [    2.681906]        [0x1c]:0da81b20
>> [    2.682082]        [0x20]:00000000
>> [    2.682259]        [0x24]:00000000
>> [    2.682435]        [0x28]:b8b80000
>> [    2.682611]        [0x2c]:00000000
>> [    2.682787]        [0x30]:b8b10000
>> [    2.682963]        [0x34]:00000000
>> [    2.683139]        [0x38]:b80a0000
>> [    2.683314]        [0x3c]:00000000
>> [    2.683489]        [0x40]:98597011
>> [    2.683665]        [0x44]:00000153
>> [    2.729849]        offset:data
>> [    2.730089]        [0x00]:02050004
>> [    2.730349]        [0x04]:00000000
>> [    2.730586]        [0x08]:00000000
>> [    2.730822]        [0x0c]:00000000
>> [    2.731058]        [0x10]:00000000
>> [    2.731295] mpt2sas_cm1: _base_event_notification
>> [    2.731606] mpt2sas_cm1: _base_event_notification: complete
>> [    2.732501] mpt2sas_cm1: LSISAS2008: FWVersion(20.00.04.00), ChipRevision(0x02), BiosVersion(07.39.00.00)
>> [    2.733010] mpt2sas_cm1: Protocol=(
>> [    2.733074] Initiator
>> [    2.733339] ,Target
>> [    2.733384] ),
>> [    2.733642] Capabilities=(
>> [    2.733696] TLR
>> [    2.733952] ,EEDP
>> [    2.733995] ,Snapshot Buffer
>> [    2.734268] ,Diag Trace Buffer
>> [    2.734326] ,Task Set Full
>> [    2.734595] ,NCQ
>> [    2.734637] )
>> [    2.735155] scsi host1: Fusion MPT SAS Host
>> [    2.749047] mpt2sas_cm1: sending port enable !!
>> [    2.749563] mpt2sas_cm1: Discovery: (start)
>>
>> [    2.749989] mpt2sas_cm1: SAS Enclosure Device Status Change
>> [    2.750001] mpt2sas_cm1: discovery event: (start)
>>
>> [    2.750578] mpt2sas_cm1: SAS Topology Change List
>> [    2.750788] mpt2sas_cm1: Discovery: (stop)
>>
>> [    2.751181] mpt2sas_cm1: Discovery: (start)
>>
>> [    2.751571] mpt2sas_cm1: Discovery: (stop)
>>
>> [    2.752002] mpt2sas_cm1: Discovery: (start)
>>
>> [    2.752391] mpt2sas_cm1: Discovery: (stop)
>>
>> [    2.752779] mpt2sas_cm1: Discovery: (start)
>>
>> [    2.754205] mpt2sas_cm1: Discovery: (stop)
>>
>> [    2.754593] mpt2sas_cm1: Discovery: (start)
>>
>> [    2.754983] mpt2sas_cm1: Discovery: (stop)
>>
>> [    2.755371] mpt2sas_cm1: Discovery: (start)
>>
>> [    2.755762] mpt2sas_cm1: Discovery: (stop)
>>
>> [    2.759602] mpt2sas_cm1: host_add: handle(0x0001), sas_addr(0x500605b0026f79b0), phys(8)
>> [    2.759969] mpt2sas_cm1: enclosure status change: (enclosure add)
>>                       handle(0x0001), enclosure logical id(0x500605b0026f79b0) number slots(0)
>> [    2.760407] mpt2sas_cm1: sas topology change: (responding)
>> [    2.760612]        handle(0x0000), enclosure_handle(0x0001) start_phy(00), count(8)
>> [    2.760834]        phy(02), attached_handle(0x000e): target add: link rate: new(0x0a), old(0x00)
>> [    2.761066]        phy(03), attached_handle(0x000b): target add: link rate: new(0x0a), old(0x00)
>> [    2.761304]        phy(04), attached_handle(0x000d): target add: link rate: new(0x09), old(0x00)
>> [    2.761538]        phy(05), attached_handle(0x0009): target add: link rate: new(0x09), old(0x00)
>> [    2.761771]        phy(06), attached_handle(0x000a): target add: link rate: new(0x09), old(0x00)
>> [    2.762002]        phy(07), attached_handle(0x000c): target add: link rate: new(0x09), old(0x00)
>> [    2.762235] mpt2sas_cm1: updating handles for sas_host(0x500605b0026f79b0)
>> [    2.763653] mpt2sas_cm1: _scsih_sas_device_init_add: handle(0x000e), sas_addr(0x4433221102000000)
>> [    2.764036] mpt2sas_cm1: _scsih_sas_device_init_add: enclosure logical id(0x500605b0026f79b0), slot( 1)
>> [    2.764772] mpt2sas_cm1: _scsih_sas_device_init_add: handle(0x000b), sas_addr(0x4433221103000000)
>> [    2.765147] mpt2sas_cm1: _scsih_sas_device_init_add: enclosure logical id(0x500605b0026f79b0), slot( 0)
>> [    2.765891] mpt2sas_cm1: _scsih_sas_device_init_add: handle(0x000d), sas_addr(0x4433221104000000)
>> [    2.767250] mpt2sas_cm1: _scsih_sas_device_init_add: enclosure logical id(0x500605b0026f79b0), slot( 7)
>> [    2.768009] mpt2sas_cm1: _scsih_sas_device_init_add: handle(0x0009), sas_addr(0x4433221105000000)
>> [    2.768394] mpt2sas_cm1: _scsih_sas_device_init_add: enclosure logical id(0x500605b0026f79b0), slot( 6)
>> [    2.769136] mpt2sas_cm1: _scsih_sas_device_init_add: handle(0x000a), sas_addr(0x4433221106000000)
>> [    2.769510] mpt2sas_cm1: _scsih_sas_device_init_add: enclosure logical id(0x500605b0026f79b0), slot( 5)
>> [    2.769888] mpt2sas_cm1: _scsih_determine_boot_device: current_boot_device(0x4433221106000000)
>> [    2.770641] mpt2sas_cm1: _scsih_sas_device_init_add: handle(0x000c), sas_addr(0x4433221107000000)
>> [    2.771025] mpt2sas_cm1: _scsih_sas_device_init_add: enclosure logical id(0x500605b0026f79b0), slot( 4)
>> [    2.771405] mpt2sas_cm1: discovery event: (stop)
>>
>> [    2.771788] mpt2sas_cm1: discovery event: (start)
>>
>> [    2.772172] mpt2sas_cm1: discovery event: (stop)
>>
>> [    2.772554] mpt2sas_cm1: discovery event: (start)
>>
>> [    2.772942] mpt2sas_cm1: discovery event: (stop)
>>
>> [    2.773326] mpt2sas_cm1: discovery event: (start)
>>
>> [    2.773709] mpt2sas_cm1: discovery event: (stop)
>>
>> [    2.774090] mpt2sas_cm1: discovery event: (start)
>>
>> [    2.774474] mpt2sas_cm1: discovery event: (stop)
>>
>> [    2.774855] mpt2sas_cm1: discovery event: (start)
>>
>> [    2.775237] mpt2sas_cm1: discovery event: (stop)
>>
>> [    2.775619] mpt2sas_cm1: port enable: complete from worker thread
>> [    2.780192] mpt2sas_cm1: port enable: SUCCESS
>> [    2.782404] scsi 1:0:0:0: Direct-Access     ATA      Hitachi HDP72505 A5BA PQ: 0 ANSI: 6
>> [    2.782651] scsi 1:0:0:0: SATA: handle(0x000a), sas_addr(0x4433221106000000), phy(6), device_name(0x5000cca34dc05584)
>> [    2.783039] scsi 1:0:0:0: SATA: enclosure_logical_id(0x500605b0026f79b0), slot(5)
>> [    2.783390] scsi 1:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
>> [    2.803032] scsi 1:0:1:0: Direct-Access     ATA      ST8000AS0002-1NA AR15 PQ: 0 ANSI: 6
>> [    2.803272] scsi 1:0:1:0: SATA: handle(0x000e), sas_addr(0x4433221102000000), phy(2), device_name(0x5000c500908f1d05)
>> [    2.803660] scsi 1:0:1:0: SATA: enclosure_logical_id(0x500605b0026f79b0), slot(1)
>> [    2.803981] scsi 1:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
>> [    2.821712] scsi 1:0:2:0: Direct-Access     ATA      ST3000DM001-1CH1 CC43 PQ: 0 ANSI: 6
>> [    2.821963] scsi 1:0:2:0: SATA: handle(0x000b), sas_addr(0x4433221103000000), phy(3), device_name(0x5000c5004dfd2a8a)
>> [    2.822352] scsi 1:0:2:0: SATA: enclosure_logical_id(0x500605b0026f79b0), slot(0)
>> [    2.822694] scsi 1:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
>> [    2.844233] scsi 1:0:3:0: Direct-Access     ATA      ST3500320NS      SN16 PQ: 0 ANSI: 6
>> [    2.844483] scsi 1:0:3:0: SATA: handle(0x000d), sas_addr(0x4433221104000000), phy(4), device_name(0x5000c50009dca65b)
>> [    2.844870] scsi 1:0:3:0: SATA: enclosure_logical_id(0x500605b0026f79b0), slot(7)
>> [    2.845216] scsi 1:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
>> [    2.868963] scsi 1:0:4:0: Direct-Access     ATA      SAMSUNG HD401LJ  0-15 PQ: 0 ANSI: 6
>> [    2.870994] scsi 1:0:4:0: SATA: handle(0x0009), sas_addr(0x4433221105000000), phy(5), device_name(0x695d550daf678093)
>> [    2.871382] scsi 1:0:4:0: SATA: enclosure_logical_id(0x500605b0026f79b0), slot(6)
>> [    2.871728] scsi 1:0:4:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
>> [    2.894004] scsi 1:0:5:0: Direct-Access     ATA      ST3750330NS      SN06 PQ: 0 ANSI: 6
>> [    2.894257] scsi 1:0:5:0: SATA: handle(0x000c), sas_addr(0x4433221107000000), phy(7), device_name(0x5000c5000266bb02)
>> [    2.894646] scsi 1:0:5:0: SATA: enclosure_logical_id(0x500605b0026f79b0), slot(4)
>> [    2.894972] scsi 1:0:5:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
>
> I don't see a clear pattern yet, but I suspect warm rebooting >=4.2
> after having run 4.1.x leads to sucessful driver inits. But I also
> remember having had cold boots, with kernels >=4.2 that worked fine
> (obviously not all of the time). <=4.1.20 kernels on the other hand boot
> fine every single time.
>
> Interestingly the igb driver (ethernet) seems to be acting up at least
> with 4.5.0 on exactly the same boots when mpt2sas init fails. I don't
> know whether this could be connected or not (I just became aware of this
> coincidence).
>
>
> ---
> Matthias
>
>
> Am 21.03.2016 um 05:53 schrieb Sreekanth Reddy:
>> Hi Matthias,
>>
>> Can you please share us the driver logs with driver logging_level set
>> to 0x3f8. So that we can get more info from this log.
>>
>> Thanks,
>> Sreekanth
>>
>> On Mon, Mar 21, 2016 at 1:44 AM, Matthias Prager
>> <linux@matthiasprager.de> wrote:
>>> Hello,
>>>
>>> I don't know what's the correct procedure, whether I should file a bug or first report this issue on the kernel mailing-list. So please feel free to tell me to open a ticket in the bugtracker (bugzilla.kernel.org?).
>>>
>>> But first let me present the issue I encounter:
>>>
>>> Kernels >= 4.2 (4.2.1 was the first on I tried, but also 4.3, 4.4 and 4.5) fail to load the mpt2sas driver on most (but not all) boots. Kernels <= 4.1.x work fine every single time (4.1.19 was the latest I tried, also 3.18.29).
>>>
>>> Here is the dmesg output for a failed driver init with Kernel 4.5.0:
>>>> [    2.068313] mpt3sas version 09.102.00.00 loaded
>>>> [    2.069412] mpt2sas_cm0: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (3074748 kB)
>>>> [    2.125260] mpt2sas_cm0: MSI-X vectors supported: 1, no of cores: 4, max_msix_vectors: -1
>>>> [    2.125996] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 58
>>>> [    2.126199] mpt2sas_cm0: iomem(0x00000000fd4fc000), mapped(0xffffc900000d0000), size(16384)
>>>> [    2.126430] mpt2sas_cm0: ioport(0x0000000000004000), size(256)
>>>> [    2.216371] mpt2sas_cm0: Allocated physical memory: size(4964 kB)
>>>> [    2.216600] mpt2sas_cm0: Current Controller Queue Depth(3307),Max Controller Queue Depth(3432)
>>>> [    2.217004] mpt2sas_cm0: Scatter Gather Elements per IO(128)
>>>> [    5.086959] floppy0: no floppy controllers found
>>>> [   32.256720] mpt2sas_cm0: _base_event_notification: timeout
>>>> [   32.256940] mf:
>>>>
>>>> [   32.257106] 07000000
>>>> [   32.257302] 00000000
>>>> [   32.257337] 00000000
>>>> [   32.257533] 00000000
>>>> [   32.257568] 00000000
>>>> [   32.257764] 0f2f7fff
>>>> [   32.257800] ffffff7c
>>>> [   32.257995] ffffffff
>>>> [   32.258031]
>>>>
>>>> [   32.258352] ffffffff
>>>> [   32.258387] 00000000
>>>> [   32.258582] 00000000
>>>>
>>>> [   32.258950] mpt2sas_cm0: sending message unit reset !!
>>>> [   32.260688] mpt2sas_cm0: message unit reset: SUCCESS
>>>> [   32.325956] mpt2sas_cm0: failure at drivers/scsi/mpt3sas/mpt3sas_scsih.c:8592/_scsih_probe()!
>>>
>>> For comparison here is a dmesg output for a successful boot on Kernel 4.1.15:
>>>> [    2.035568] mpt2sas version 20.100.00.00 loaded
>>>> [    2.037243] mpt2sas0: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (2046352 kB)
>>>> [    2.755374] mpt2sas0: MSI-X vectors supported: 1, no of cores: 3, max_msix_vectors: 8
>>>> [    2.756377] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 58
>>>> [    2.756708] mpt2sas0: iomem(0x00000000fd5fc000), mapped(0xffffc900000d0000), size(16384)
>>>> [    2.757083] mpt2sas0: ioport(0x0000000000004000), size(256)
>>>> [    3.842944] mpt2sas0: Allocated physical memory: size(4964 kB)
>>>> [    3.843303] mpt2sas0: Current Controller Queue Depth(3307), Max Controller Queue Depth(3432)
>>>> [    3.843717] mpt2sas0: Scatter Gather Elements per IO(128)
>>>> [    4.415980] mpt2sas0: LSISAS2008: FWVersion(20.00.04.00), ChipRevision(0x03), BiosVersion(07.39.00.00)
>>>> [    4.416618] mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
>>>> [    4.417846] scsi host0: Fusion MPT SAS Host
>>>> [    4.436865] mpt2sas0: sending port enable !!
>>>> [    4.440460] mpt2sas0: host_add: handle(0x0001), sas_addr(0xxxxxxxxxxxxxxxxx), phys(8)
>>>>
>>>> ...
>>>> [    4.444045] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS5C302 A800 PQ: 0 ANSI: 6
>>>> [    4.444338] scsi 0:0:0:0: SATA: handle(0x0009), sas_addr(0xxxxxxxxxxxxxxxxx), phy(1), device_name(0xxxxxxxxxxxxxxxxx)
>>>> [    4.444823] scsi 0:0:0:0: SATA: enclosure_logical_id(0xxxxxxxxxxxxxxxxx), slot(2)
>>>> [    4.445197] scsi 0:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
>>>> ... (n times for n drives)
>>>>
>>>> [    4.515443] mpt2sas0: port enable: SUCCESS
>>>
>>>
>>> The Controller(s) are all Avego/LSI 9211-8i running the latest version of IT firmware (v20.00.04.00). These are passed through to a gentoo-linux VM on an ESXi 5.1 host (latest patchlevel). I have two of these systems (one production one testing) with nearly identical hardware (Supermicro X8DTi-F boards with 2x Intel Westmere CPUs). I also have an older set of systems running the same software config (Intel S3200SHLC boards with single Core2Quad) which exhibit the same buggy behavior.
>>>
>>> The 'uname -a' line on the current testing system looks like this:
>>>> Linux pserver2 4.1.19-gentoo #4 SMP Thu Mar 17 16:02:48 CET 2016 x86_64 Intel(R) Xeon(R) CPU E5506 @ 2.13GHz GenuineIntel GNU/Linux
>>> p
>>>
>>> There seem to be other people with similar issues:
>>> <https://bbs.archlinux.org/viewtopic.php?id=209495>
>>>
>>> Any thoughts?
>>>
>>> ---
>>> Matthias
>
