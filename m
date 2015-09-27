From: =?utf-8?B?IlTDs3RoIEF0dGlsYSI=?= <atoth@atoth.sote.hu>
Subject: twa generates WARNING upon boot
Date: Sun, 27 Sep 2015 13:56:09 +0200
Message-ID: <68ee66bf9581d10b0ab813e5006869ec.squirrel@atoth.sote.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atoth.sote.hu ([195.111.75.211]:40005 "EHLO atoth.sote.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673AbbI0MT0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Sep 2015 08:19:26 -0400
Received: from atoth.sote.hu (apache@localhost [127.0.0.1])
	by atoth.sote.hu (8.14.9/8.14.9/atoth@atoth.sote.hu) with ESMTP id t8RBu9CS003015
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2015 13:56:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

After an unsuccessful attempt to contact linuxraid@lsi.com, I'm trying =
to
seek assistance on this list.

I've been seeing WARNINGs upon boot for a while now, without any obviou=
s
symptoms. I got some advice to report it upstream on the hardened-gento=
o
mailing list from PaX Team:

"twa_interrupt is from the 3ware 9xxx driver and it seems that it wants=
 to
unmap a page it doesn't own. DEBUG_INFO and addr2line would help to
identify the bad call in twa_interrupt (ffffffffxxxxxxxx in the below
trace) then you can send it upstream ;)."
Where xxxxxxxx was an address taken from a previous trace.

I've recompiled the kernel with DEBUG_INFO and FRAME_POINTERS enabled.

Here is a current trace I see after booting that kernel:
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at drivers/iommu/intel-iommu.c:3214
intel_unmap+0x186/0x1f0()
Driver unmaps unmatched page at PFN 0
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.1.7-hardened-r1 #2
Hardware name: System manufacturer System Product Name/Z8P(N)E-D12(X),
BIOS 1302    06/25/2012
 ffffffffab40bd6b 0000000000000000 0000000000000000 ffffffffab21608f
 ffff880237c03ca8 ffffffffa4ed0fa6 00000000000015d2 ffff880237c03d00
 ffff880237c03ce8 ffffffffa40ad9a0 0000000000000000 ffffffffab21608f
Call Trace:
 <IRQ>  [<ffffffffa4ed0fa6>] dump_stack+0x45/0x5d
 [<ffffffffa40ad9a0>] warn_slowpath_common+0x80/0xc0
 [<ffffffffa40ada44>] warn_slowpath_fmt+0x64/0x90
 [<ffffffffa46de866>] intel_unmap+0x186/0x1f0
 [<ffffffffa46de8ea>] intel_unmap_sg+0x1a/0x30
 [<ffffffffa475ef13>] scsi_dma_unmap+0x73/0x90
 [<ffffffffa47b8683>] twa_interrupt+0x493/0x780
 [<ffffffffa4100f7a>] handle_irq_event_percpu+0x7a/0x130
 [<ffffffffa4101069>] handle_irq_event+0x39/0x60
 [<ffffffffa4104469>] handle_fasteoi_irq+0x89/0x1a0
 [<ffffffffa4005715>] handle_irq+0x85/0x160
 [<ffffffffa4004f6c>] do_IRQ+0x4c/0x100
 [<ffffffffa4edd557>] common_interrupt+0x97/0x97
 <EOI>  [<ffffffffa403d1cc>] ?
default_send_IPI_mask_allbutself_phys+0xbc/0x100
 [<ffffffffa4042e79>] physflat_send_IPI_allbutself+0x19/0x30
 [<ffffffffa40385d8>] native_send_call_func_ipi+0x108/0x140
 [<ffffffffa4125c10>] ? proc_dma_show+0x70/0x70
 [<ffffffffa41264f4>] smp_call_function_many+0x1c4/0x270
 [<ffffffffa4126671>] kick_all_cpus_sync+0x21/0x30
 [<ffffffffa41bb546>] __do_tune_cpucache+0x56/0x4d0
 [<ffffffffa458f4b7>] ? string.isra.3+0x47/0x100
 [<ffffffffa41bb9f7>] do_tune_cpucache+0x37/0xb0
 [<ffffffffa41bbad5>] enable_cpucache+0x65/0x130
 [<ffffffffa4ec5c13>] setup_cpu_cache+0x173/0x270
 [<ffffffffa41bc2c2>] __kmem_cache_create+0x262/0x360
 [<ffffffffa418a5c2>] do_kmem_cache_create+0x92/0x1d0
 [<ffffffffa418a81e>] kmem_cache_create+0x11e/0x1d0
 [<ffffffffafc4c3d0>] ? twa_init+0x36/0x36
 [<ffffffffafc4c4a7>] init_sd+0xd7/0x198
 [<ffffffffa4000384>] do_one_initcall+0x94/0x1a0
 [<ffffffffafc15285>] kernel_init_freeable+0x183/0x22f
 [<ffffffffa4ec44f0>] ? rest_init+0x80/0x80
 [<ffffffffa4ec44f9>] kernel_init+0x9/0xf0
 [<ffffffffa4edcdfe>] ret_from_fork+0x3e/0x70
 [<ffffffffa4ec44f0>] ? rest_init+0x80/0x80
---[ end trace a39a5826ea41aa47 ]---

The 3ware card is a 9650SE-12ML running in a Asus Z8PE-D12X motherboard=
=2E

I don't know the exact command I have to type to get a meaningful outpu=
t
for addr2line...

Please let me know what else I should do in order to provide more info.

Thanks:
Dw.
--=20
dr T=C3=B3th Attila, Radiol=C3=B3gus, 06-20-825-8057
Attila Toth MD, Radiologist, +36-20-825-8057

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
