From: Andrew Morton <akpm@osdl.org>
Subject: Fw: slab error in cache_free_debugcheck(): cache `sgpool-8':
Date: Mon, 17 Oct 2005 00:23:39 -0700
Message-ID: <20051017002339.5156d7f4.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:58274 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932099AbVJQHYU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 03:24:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: "F. Poncin" <cr27587@chello.be>


THis is rather deadly.   Is it likely to be a 1394 bug, or scsi?


Begin forwarded message:

Date: Fri, 14 Oct 2005 21:50:14 +0200
=46rom: "F. Poncin" <cr27587@chello.be>
To: linux-kernel@vger.kernel.org
Subject: slab error in cache_free_debugcheck(): cache `sgpool-8':


Hello,
I found this in several recent boot logs.

Summary: slab error in cache_free_debugcheck(): cache `sgpool-8': doubl=
e=20
free, or memory outside object was overwritten
Kernel version: 2.6.14-rc4-g9149ccfa
Steps to reproduce: on boot
Hardware: Dell 8300 + External USB disk enclosures

I'm not subscribed to the list. Please Cc:
Additional info / test on request.

extract from dmesg:

scsi2 : SCSI emulation for IEEE-1394 SBP-2 Devices
ieee1394: sbp2: Logged into SBP-2 device
ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
  Vendor: Initio    Model: ST3400832A        Rev: 4.07
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
slab error in cache_free_debugcheck(): cache `sgpool-8': double free, o=
r=20
memory outside object was overwritten
 [<c014a43b>] cache_free_debugcheck+0x15e/0x215
 [<c0144c73>] mempool_free+0x6c/0x73
 [<c014ae71>] kmem_cache_free+0x25/0x59
 [<c0144c73>] mempool_free+0x6c/0x73
 [<f8891d92>] scsi_io_completion+0x1fd/0x4ac [scsi_mod]
 [<f8826d3f>] sd_rw_intr+0x155/0x30e [sd_mod]
 [<c0148e2b>] poison_obj+0x1c/0x38
 [<c032ca6e>] _spin_lock+0x1c/0x75
 [<f888cc33>] scsi_finish_command+0x82/0xb5 [scsi_mod]
 [<c032ca6e>] _spin_lock+0x1c/0x75
 [<f888cb0a>] scsi_softirq+0xc0/0x141 [scsi_mod]
 [<c01252e1>] tasklet_action+0x59/0xbe
 [<c0124f79>] __do_softirq+0x69/0xd5
 [<c0104ceb>] do_softirq+0x57/0x5b
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 [<c01250c0>] irq_exit+0x42/0x44
 [<c0104bbc>] do_IRQ+0x5c/0x8e
 [<c032b277>] schedule+0x627/0xcd8
 [<c01036a6>] common_interrupt+0x1a/0x20
 [<c0100e91>] mwait_idle+0x25/0x4a
 [<c023d243>] acpi_processor_idle+0x0/0x29e
 [<c023d344>] acpi_processor_idle+0x101/0x29e
 [<c023d243>] acpi_processor_idle+0x0/0x29e
 [<c0100ceb>] cpu_idle+0x45/0x7d
 [<c03f088a>] start_kernel+0x18c/0x1cb
 [<c03f030b>] unknown_bootoption+0x0/0x1b0
c233b7a8: redzone 1: 0x170fc2a5, redzone 2: 0xc0144b47.
sdc: asking for cache data failed
sdc: assuming drive cache: write through
SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
slab error in cache_free_debugcheck(): cache `sgpool-8': double free, o=
r=20
memory outside object was overwritten
 [<c014a43b>] cache_free_debugcheck+0x15e/0x215
 [<c0144c73>] mempool_free+0x6c/0x73
 [<c014ae71>] kmem_cache_free+0x25/0x59
 [<c0144c73>] mempool_free+0x6c/0x73
 [<f8891d92>] scsi_io_completion+0x1fd/0x4ac [scsi_mod]
 [<f8826d3f>] sd_rw_intr+0x155/0x30e [sd_mod]
 [<c0148e2b>] poison_obj+0x1c/0x38
 [<c032ca6e>] _spin_lock+0x1c/0x75
 [<f888cc33>] scsi_finish_command+0x82/0xb5 [scsi_mod]
 [<c032ca6e>] _spin_lock+0x1c/0x75
 [<f888cb0a>] scsi_softirq+0xc0/0x141 [scsi_mod]
 [<c01252e1>] tasklet_action+0x59/0xbe
 [<c0124f79>] __do_softirq+0x69/0xd5
 [<c0104ceb>] do_softirq+0x57/0x5b
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 [<c01250c0>] irq_exit+0x42/0x44
 [<c0104bbc>] do_IRQ+0x5c/0x8e
 [<c01036a6>] common_interrupt+0x1a/0x20
 [<c0100e91>] mwait_idle+0x25/0x4a
 [<c023d243>] acpi_processor_idle+0x0/0x29e
 [<c023d344>] acpi_processor_idle+0x101/0x29e
 [<c023d243>] acpi_processor_idle+0x0/0x29e
 [<c0100ceb>] cpu_idle+0x45/0x7d
 [<c03f088a>] start_kernel+0x18c/0x1cb
 [<c03f030b>] unknown_bootoption+0x0/0x1b0
c233b7a8: redzone 1: 0x170fc2a5, redzone 2: 0xc0144b47.
sdc: asking for cache data failed
sdc: assuming drive cache: write through
 sdc:<6>FDC 0 is a post-1991 82077


--
=46r=E9d=E9ric Poncin

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
