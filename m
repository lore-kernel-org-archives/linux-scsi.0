From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 2/2] fusion SAS support (mptsas driver)
Date: Wed, 14 Sep 2005 15:52:23 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C04079F2A@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42389 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932782AbVINVwj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 17:52:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

On Friday, September 09, 2005 8:27 AM, Christoph Hellwig wrote:
> 
> Adds the actual mptsas driver, based upon the LSI driver with new work
> for SAS transport class integration from Eric Moore and me.
> 
> This obviously depends on the SAS transport class.
> 
> 

I'm getting a oops when mptsas.ko loads. It appears to be
in sas_host_setup() when dev_to_shost() is called.

I applied you're three patches to the current stream from last Friday, which
at that time was 2.6.13 + 2.6.13-git-9.  Is that correct kernel
I should be on? Or should it be something else?

Here is the oops =>

Fusion MPT base driver 3.03.02
Copyright (c) 1999-2005 LSI Logic Corporation
Fusion MPT SAS Host driver 3.03.02
ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 56 (level, low) -> IRQ 21
mptbase: Initiating ioc0 bringup
ioc0: SAS1068: Capabilities={Initiator}
scsi0 : ioc0: LSISAS1068, FwRev=00040c00h, Ports=1, MaxQ=511, IRQ=21
Unable to handle kernel NULL pointer dereference at virtual address 00000278
 printing eip:
e0d89150
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in: mptsas scsi_transport_sas mptscsih mptbase snd_pcm_oss
snd_mixer_oss edd evdev joydev sg st sr_mod ide_cd cdrom nvram speedstep_lib
freq_table thermal processor fan button battery ac nfsd exportfs
snd_ac97_codec snd_ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc
ipv6 ehci_hcd uhci_hcd i2c_i801 i2c_core intel_agp agpgart tg3 usbcore ext3
jbd dm_mod reiserfs
CPU:    1
EIP:    0060:[<e0d89150>]    Not tainted VLI
EFLAGS: 00010246   (2.6.13-git9) 
EIP is at sas_host_setup+0x20/0x40 [scsi_transport_sas]
eax: 00000000   ebx: dce77400   ecx: d5a684a4   edx: 00000000
esi: dce77400   edi: d5a684fa   ebp: d32fbe44   esp: d32fbe40
ds: 007b   es: 007b   ss: 0068
Process insmod (pid: 14732, threadinfo=d32fa000 task=dc4d6a50)
Stack: e0d89130 d32fbe54 c025a694 dce77400 dc56919e d32fbe78 c025a1c1
d5a684a4 
       d5a68480 c025a670 dc5690ec dc5690ec dc569000 00000000 d32fbe80
c025a6ad 
       d32fbe94 c029fcca e0d6c500 dc569000 00000000 d32fbeb4 c02976bb
dc56920c 
Call Trace:
 [<c010536b>] show_stack+0x9b/0xb0
 [<c01054bc>] show_registers+0x11c/0x190
 [<c0105693>] die+0xe3/0x160
 [<c033d7f7>] do_page_fault+0x357/0x5b4
 [<c0104fef>] error_code+0x4f/0x60
 [<c025a694>] transport_setup_classdev+0x24/0x30
 [<c025a1c1>] attribute_container_add_device+0xf1/0x140
 [<c025a6ad>] transport_setup_device+0xd/0x10
 [<c029fcca>] scsi_sysfs_add_host+0x9a/0xb0
 [<c02976bb>] scsi_add_host+0x10b/0x1c0
 [<e0d6a1db>] mptsas_probe+0x30b/0x3b0 [mptsas]
 [<c0203b4d>] pci_call_probe+0xd/0x10
 [<c0203b8a>] __pci_device_probe+0x3a/0x50
 [<c0203bc1>] pci_device_probe+0x21/0x40
 [<c025796d>] driver_probe_device+0x2d/0xb0
 [<c0257a9a>] __driver_attach+0x3a/0x40
 [<c02570e9>] bus_for_each_dev+0x49/0x70
 [<c0257ab4>] driver_attach+0x14/0x20
 [<c0257537>] bus_add_driver+0x67/0xb0
 [<c0257e49>] driver_register+0x39/0x40
 [<c0203ddf>] pci_register_driver+0x6f/0x80
 [<e0c7e096>] mptsas_init+0x96/0x9c [mptsas]
 [<c0139dfa>] sys_init_module+0x12a/0x1c0
 [<c0103e6b>] sysenter_past_esp+0x54/0x79
Code: 5b 5e 5d c3 8d b4 26 00 00 00 00 55 89 e5 53 eb 09 8b 43 74 31 d2 85
c0 74 11 89 c3 e8 9a eb 50 df 85 c0 74 ec 8d 93 14 ff ff ff <8b> 82 78 02 00
00 89 00 89 40 04 c7 40 08 01 00 00 00 c7 40 0c 
 
