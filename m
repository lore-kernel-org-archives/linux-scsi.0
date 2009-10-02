From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Subject: Linux 2.6.30.1, SCSI/USB related oops
Date: Fri, 02 Oct 2009 09:56:52 +0200
Message-ID: <4AC5B244.2070609@nets.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:61824 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755515AbZJBH4w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2009 03:56:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org

Hi,

I know the kernel is old, I decided to report it nevertheless.
I don't think the kernel should oops on read I/O failure, should it?


[7552222.692170] usb 2-1: new high speed USB device using ehci_hcd and address 7
[7552222.836222] usb 2-1: New USB device found, idVendor=04fc, idProduct=0c15
[7552222.836999] usb 2-1: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[7552222.837038] usb 2-1: Product: USB to Serial-ATA bridge
[7552222.837064] usb 2-1: Manufacturer: Sunplus Technology Inc.
[7552222.837090] usb 2-1: SerialNumber: SAMSUNG SPS07GJ10Y867493
[7552222.837410] usb 2-1: configuration #1 chosen from 1 choice
[7552222.839520] scsi5 : SCSI emulation for USB Mass Storage devices
[7552222.843580] usb-storage: device found at 7
[7552222.843589] usb-storage: waiting for device to settle before scanning
[7552227.840419] usb-storage: device scan complete
[7552227.846878] scsi 5:0:0:0: Direct-Access     SAMSUNG  SP2004C               PQ: 0 ANSI: 2
[7552227.915824] sd 5:0:0:0: [sde] 390721968 512-byte hardware sectors: (200 GB/186 GiB)
[7552227.918185] sd 5:0:0:0: [sde] Write Protect is off
[7552227.918224] sd 5:0:0:0: [sde] Mode Sense: 38 00 00 00
[7552227.918232] sd 5:0:0:0: [sde] Assuming drive cache: write through
[7552227.944318] sd 5:0:0:0: [sde] Assuming drive cache: write through
[7552227.944375]  sde:<6>usb 2-1: reset high speed USB device using ehci_hcd and address 7
[7552256.038794] usb 2-1: USB disconnect, address 7
[7552256.041227] scsi 5:0:0:0: [sde] Unhandled error code
[7552256.041264] scsi 5:0:0:0: [sde] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[7552256.041305] end_request: I/O error, dev sde, sector 0
[7552256.041334] Buffer I/O error on device sde, logical block 0
[7552256.042496] ldm_validate_partition_table(): Disk read failed.
[7552256.042585] Dev sde: unable to read RDB block 0
[7552256.042691]  unable to read partition table
[7552256.042938] BUG: unable to handle kernel paging request at 383d5257
[7552256.042971] IP: [<c01f634e>] disk_part_iter_next+0x3a/0x8a
[7552256.043015] *pde = 00000000
[7552256.043037] Oops: 0000 [#1]
[7552256.043060] last sysfs file: /sys/devices/pci0000:00/0000:00:10.3/usb2/2-1/2-1:1.0/host5/target5:0:0/5:0:0:0/type
[7552256.043103] Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq ipv6 ext4 jbd2 crc16 via_rng rng_core vt1211 hwmon_vid loop arc4 ecb ath5k mac80211 led_class cfg80211 evdev pcmcia snd_via82xx button gameport processor snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device serio_raw snd soundcore i2c_viapro i2c_core via_agp shpchp yenta_socket rsrc_nonstatic pcmcia_core pci_hotplug agpgart pcspkr dm_crypt usb_storage dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sd_mod ehci_hcd uhci_hcd ohci1394 sata_sil usbcore ieee1394 thermal fan thermal_sys
[7552256.043457]
[7552256.043478] Pid: 17697, comm: async/0 Not tainted (2.6.30.1-sol1 #2) CLE266-8235
[7552256.043517] EIP: 0060:[<c01f634e>] EFLAGS: 00010246 CPU: 0
[7552256.043545] EIP is at disk_part_iter_next+0x3a/0x8a
[7552256.043571] EAX: 00000000 EBX: c9f1ff58 ECX: 00000000 EDX: 383d524f
[7552256.043600] ESI: e667a400 EDI: e667a448 EBP: e667a400 ESP: c9f1ff44
[7552256.043628]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[7552256.043656] Process async/0 (pid: 17697, ti=c9f1f000 task=deb9b400 task.ti=c9f1f000)
[7552256.043692] Stack:
[7552256.043709]  d2c45040 e667a400 e667a448 e667a400 c01a7c42 e667a400 00000000 00000001
[7552256.043754]  00000000 de9ab5c8 e667a400 00000000 c01f61b6 00000000 c01f5a35 c01f5d46
[7552256.043809]  e667a400 00800040 de9ab5c8 de9ab5c0 f8120c96 d5f408a8 d5f40800 00000212
[7552256.043874] Call Trace:
[7552256.043893]  [<c01a7c42>] ? register_disk+0xcc/0xde
[7552256.043931]  [<c01f61b6>] ? add_disk+0x9a/0xe8
[7552256.043959]  [<c01f5a35>] ? exact_match+0x0/0x4
[7552256.043987]  [<c01f5d46>] ? exact_lock+0x0/0xd
[7552256.044020]  [<f8120c96>] ? sd_probe_async+0x17d/0x217 [sd_mod]
[7552256.044038]  [<c012d6af>] ? async_thread+0x0/0x1d0
[7552256.044038]  [<c012d797>] ? async_thread+0xe8/0x1d0
[7552256.044038]  [<c01166e3>] ? default_wake_function+0x0/0x8
[7552256.044038]  [<c0128e95>] ? kthread+0x3f/0x63
[7552256.044038]  [<c0128e56>] ? kthread+0x0/0x63
[7552256.044038]  [<c0103587>] ? kernel_thread_helper+0x7/0x10
[7552256.044038] Code: 10 e8 a0 94 06 00 8b 03 c7 43 04 00 00 00 00 8b 50 2c 8b 43 0c a8 01 74 12 83 e0 0c 83 cf ff 83 f8 01 19 c9 f7 d1 8d 6a 10 eb 41 <8b> 4a 08 bf 01 00 00 00 eb f1 8d 44 95 00 8b 30 85 f6 74 27 8b
[7552256.044038] EIP: [<c01f634e>] disk_part_iter_next+0x3a/0x8a SS:ESP 0068:c9f1ff44
[7552256.044038] CR2: 00000000383d5257
[7552256.044798] ---[ end trace 32f7e43da77f44e1 ]---

Best regards,
Arnd
