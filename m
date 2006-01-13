From: "F. Poncin" <cr27587@chello.be>
Subject: Re: USB/SCSI slab corruption.
Date: Fri, 13 Jan 2006 10:39:09 +0100
Message-ID: <43C7753D.8030404@chello.be>
References: <20060112233606.GP19827@redhat.com> <43C6F31C.5090909@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from amsfep12-int.chello.nl ([213.46.243.17]:46677 "EHLO
	amsfep12-int.chello.nl") by vger.kernel.org with ESMTP
	id S932620AbWAMJjN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 04:39:13 -0500
In-Reply-To: <43C6F31C.5090909@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, Dave Jones <davej@redhat.com>, linux-usb-devel@lists.sourceforge.net, akpm@osdl.org

Stefan Richter wrote:

> Dave Jones wrote:
>
>> A nasty 2.6.15 report from one of our Fedora users.
>>
>>         Dave
>>
>>  > then when it got to map my USB drive:  > SCSI device sdb:=20
>> 321672960 512-byte hdwr sectors (164697 MB)  > slab error in=20
>> cache_free_debugcheck(): cache `sgpool-8': double free, or  > memory=
=20
>> outside object was overwritten  >  [<c0153593>]=20
>> cache_free_debugcheck+0x1ab/0x22f     [<c014d3c2>]  >=20
>> mempool_free+0x3a/0x73  >  [<c01540e2>] kmem_cache_free+0x2a/0x69   =
 =20
>> [<c014d3c2>]  > mempool_free+0x3a/0x73  >  [<f8862c8b>]=20
>> scsi_io_completion+0x207/0x4d2 [scsi_mod]     [<f885dcad>]  >=20
>> scsi_finish_command+0x82/0xd0 [scsi_mod]  >  [<f885db8e>]=20
>> scsi_softirq+0xc0/0x137 [scsi_mod]     [<c012a152>]  >=20
>> __do_softirq+0x72/0xdc  >  [<c01063d3>] do_softirq+0x4b/0x4f  > =20
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=20
>
> [...]
>
> This looks very similar to this report about an SBP-2 HDD under=20
> 2.6.14-rc4: http://marc.theaimsgroup.com/?t=3D112931959700002

As discussed with Andrew Morton yesterday, this seems to be fixed on my=
=20
side (latest kernel)

extract from dmesg:

ieee1394: Node added: ID:BUS[0-00:1023]  GUID[000bc20300011c51]
ieee1394: Host added: ID:BUS[0-01:1023]  GUID[0000d10080967536]
scsi2 : SBP-2 IEEE-1394
ieee1394: sbp2: Logged into SBP-2 device
ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
 Vendor: Initio    Model: ST3400832A        Rev: 4.07
 Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 13 00 00
sdc: got wrong page
sdc: assuming drive cache: write through
SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 13 00 00
sdc: got wrong page
sdc: assuming drive cache: write through
sdc: sdc1
sd 2:0:0:0: Attached scsi disk sdc


"F. Poncin" <cr27587@chello.be> wrote:

> Hello,
> I found this in several recent boot logs.
>
> Summary: slab error in cache_free_debugcheck(): cache `sgpool-8':=20
> double free, or memory outside object was overwritten
> Kernel version: 2.6.14-rc4-g9149ccfa
> Steps to reproduce: on boot
> Hardware: Dell 8300 + External USB disk enclosures
>
> I'm not subscribed to the list. Please Cc:
> Additional info / test on request.
>
> extract from dmesg:
>
> scsi2 : SCSI emulation for IEEE-1394 SBP-2 Devices
> ieee1394: sbp2: Logged into SBP-2 device
> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
>  Vendor: Initio    Model: ST3400832A        Rev: 4.07
>  Type:   Direct-Access                      ANSI SCSI revision: 00
> SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
> slab error in cache_free_debugcheck(): cache `sgpool-8': double free,=
=20
> or memory outside object was overwritten
> [<c014a43b>] cache_free_debugcheck+0x15e/0x215
> [<c0144c73>] mempool_free+0x6c/0x73
> [<c014ae71>] kmem_cache_free+0x25/0x59
> [<c0144c73>] mempool_free+0x6c/0x73
> [<f8891d92>] scsi_io_completion+0x1fd/0x4ac [scsi_mod]
> [<f8826d3f>] sd_rw_intr+0x155/0x30e [sd_mod]
> [<c0148e2b>] poison_obj+0x1c/0x38
> [<c032ca6e>] _spin_lock+0x1c/0x75
> [<f888cc33>] scsi_finish_command+0x82/0xb5 [scsi_mod]
> [<c032ca6e>] _spin_lock+0x1c/0x75
> [<f888cb0a>] scsi_softirq+0xc0/0x141 [scsi_mod]
> [<c01252e1>] tasklet_action+0x59/0xbe
> [<c0124f79>] __do_softirq+0x69/0xd5
> [<c0104ceb>] do_softirq+0x57/0x5b
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [<c01250c0>] irq_exit+0x42/0x44
> [<c0104bbc>] do_IRQ+0x5c/0x8e
> [<c032b277>] schedule+0x627/0xcd8
> [<c01036a6>] common_interrupt+0x1a/0x20
> [<c0100e91>] mwait_idle+0x25/0x4a
> [<c023d243>] acpi_processor_idle+0x0/0x29e
> [<c023d344>] acpi_processor_idle+0x101/0x29e
> [<c023d243>] acpi_processor_idle+0x0/0x29e
> [<c0100ceb>] cpu_idle+0x45/0x7d
> [<c03f088a>] start_kernel+0x18c/0x1cb
> [<c03f030b>] unknown_bootoption+0x0/0x1b0
> c233b7a8: redzone 1: 0x170fc2a5, redzone 2: 0xc0144b47.
> sdc: asking for cache data failed
> sdc: assuming drive cache: write through
> SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
> slab error in cache_free_debugcheck(): cache `sgpool-8': double free,=
=20
> or memory outside object was overwritten
> [<c014a43b>] cache_free_debugcheck+0x15e/0x215
> [<c0144c73>] mempool_free+0x6c/0x73
> [<c014ae71>] kmem_cache_free+0x25/0x59
> [<c0144c73>] mempool_free+0x6c/0x73
> [<f8891d92>] scsi_io_completion+0x1fd/0x4ac [scsi_mod]
> [<f8826d3f>] sd_rw_intr+0x155/0x30e [sd_mod]
> [<c0148e2b>] poison_obj+0x1c/0x38
> [<c032ca6e>] _spin_lock+0x1c/0x75
> [<f888cc33>] scsi_finish_command+0x82/0xb5 [scsi_mod]
> [<c032ca6e>] _spin_lock+0x1c/0x75
> [<f888cb0a>] scsi_softirq+0xc0/0x141 [scsi_mod]
> [<c01252e1>] tasklet_action+0x59/0xbe
> [<c0124f79>] __do_softirq+0x69/0xd5
> [<c0104ceb>] do_softirq+0x57/0x5b
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [<c01250c0>] irq_exit+0x42/0x44
> [<c0104bbc>] do_IRQ+0x5c/0x8e
> [<c01036a6>] common_interrupt+0x1a/0x20
> [<c0100e91>] mwait_idle+0x25/0x4a
> [<c023d243>] acpi_processor_idle+0x0/0x29e
> [<c023d344>] acpi_processor_idle+0x101/0x29e
> [<c023d243>] acpi_processor_idle+0x0/0x29e
> [<c0100ceb>] cpu_idle+0x45/0x7d
> [<c03f088a>] start_kernel+0x18c/0x1cb
> [<c03f030b>] unknown_bootoption+0x0/0x1b0
> c233b7a8: redzone 1: 0x170fc2a5, redzone 2: 0xc0144b47.
> sdc: asking for cache data failed
> sdc: assuming drive cache: write through
> sdc:<6>FDC 0 is a post-1991 82077
>
>
> --=20
> Fr=E9d=E9ric Poncin


=20

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
