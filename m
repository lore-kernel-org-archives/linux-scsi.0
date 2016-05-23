From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Subject: Improve device reset for failed HDD
Date: Mon, 23 May 2016 21:53:43 +0300
Message-ID: <CAOE4rSyJnrbO_063uZ3tSTbwhm=bjORjZ4b=hNKtC-=8=Y6TLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33830 "EHLO
	mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbcEWTI7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2016 15:08:59 -0400
Received: by mail-it0-f67.google.com with SMTP id k76so6019172ita.1
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2016 12:08:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi!

I've a Seagate Barracuda 7200.14 (ST2000DM001-9YN164) 2TB HDD
with some bad sectors and when they're accessed it causes device to fail.
It's attached to HighPoint RocketRAID 2760 HBA (mvsas) and kernel 4.6

when accesing bad sector in log can see:

kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1771:port 2 slot
0 rx_desc 30000 has error info0000000001000000.
kernel: sas: Enter sas_scsi_recover_host busy: 1 failed: 1
kernel: sas: ata21: end_device-7:2: cmd error handler
kernel: sas: ata7: end_device-7:0: dev error handler
kernel: sas: ata8: end_device-7:1: dev error handler
kernel: sas: ata21: end_device-7:2: dev error handler
kernel: ata21.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
kernel: sas: ata10: end_device-7:3: dev error handler
kernel: sas: ata11: end_device-7:4: dev error handler
kernel: ata21.00: failed command: READ SECTOR(S) EXT
kernel: ata21.00: cmd 24/00:01:69:86:7a/00:00:9d:00:00/e0 tag 17 pio 512 in
                                           res
51/40:00:69:86:7a/00:00:9d:00:00/00 Emask 0x9 (media error)
kernel: sas: ata12: end_device-7:5: dev error handler
kernel: sas: ata13: end_device-7:6: dev error handler
kernel: ata21.00: status: { DRDY ERR }
kernel: sas: ata14: end_device-7:7: dev error handler
kernel: ata21.00: error: { UNC }
kernel: ata21.00: failed to IDENTIFY (I/O error, err_mask=0x1)
kernel: ata21.00: revalidation failed (errno=-5)
kernel: ata21: hard resetting link
kernel: ata21.00: failed to IDENTIFY (I/O error, err_mask=0x1)
kernel: ata21.00: revalidation failed (errno=-5)
kernel: ata21: hard resetting link
kernel: ata21.00: failed to IDENTIFY (I/O error, err_mask=0x1)
kernel: ata21.00: revalidation failed (errno=-5)
kernel: ata21.00: disabled
kernel: ata21: EH complete
kernel: sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1


then after this, device still appears available (/dev/sdp)
but any access to it fails, even good sectors and SMART

kernel: sd 7:0:8:0: [sdp] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:8:0: [sdp] tag#0 CDB: opcode=0x28 28 00 00 00 00 00 00 00 20 00
kernel: blk_update_request: I/O error, dev sdp, sector 0
kernel: sd 7:0:8:0: [sdp] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:8:0: [sdp] tag#0 CDB: opcode=0x28 28 00 00 00 00 00 00 00 08 00
kernel: blk_update_request: I/O error, dev sdp, sector 0
kernel: Buffer I/O error on dev sdp, logical block 0, async page read
kernel: sd 7:0:8:0: [sdp] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:8:0: [sdp] tag#0 CDB: opcode=0x28 28 00 00 00 00 00 00 00 08 00
kernel: blk_update_request: I/O error, dev sdp, sector 0
kernel: Buffer I/O error on dev sdp, logical block 0, async page read
kernel: sd 7:0:8:0: [sdp] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:8:0: [sdp] tag#0 CDB: opcode=0x28 28 00 e8 e0 88 a8 00 00 08 00
kernel: blk_update_request: I/O error, dev sdp, sector 3907029160
kernel: Buffer I/O error on dev sdp, logical block 488378645, async page read
kernel: sd 7:0:8:0: [sdp] Read Capacity(16) failed: Result:
hostbyte=0x04 driverbyte=0x00
kernel: sd 7:0:8:0: [sdp] Sense not available.
kernel: sd 7:0:8:0: [sdp] Read Capacity(10) failed: Result:
hostbyte=0x04 driverbyte=0x00
kernel: sd 7:0:8:0: [sdp] Sense not available.
kernel: sd 7:0:8:0: [sdp] Write Protect is on
kernel: sd 7:0:8:0: [sdp] Mode Sense: ea ea ea ea
kernel: sdp: detected capacity change from 2000398934016 to 0
kernel: sd 7:0:8:0: [sdp] Read Capacity(16) failed: Result:
hostbyte=0x04 driverbyte=0x00
kernel: sd 7:0:8:0: [sdp] Sense not available.
kernel: sd 7:0:8:0: [sdp] Read Capacity(10) failed: Result:
hostbyte=0x04 driverbyte=0x00
kernel: sd 7:0:8:0: [sdp] Sense not available.
kernel: sd 7:0:8:0: [sdp] Write Protect is off
kernel: sd 7:0:8:0: [sdp] Mode Sense: 00 00 00 00
kernel: sd 7:0:8:0: [sdp] Read Capacity(16) failed: Result:
hostbyte=0x04 driverbyte=0x00
kernel: sd 7:0:8:0: [sdp] Sense not available.
kernel: sd 7:0:8:0: [sdp] Read Capacity(10) failed: Result:
hostbyte=0x04 driverbyte=0x00
kernel: sd 7:0:8:0: [sdp] Sense not available.


Problem is that some applications still keep going on (for example btrfs scrub)
and marks all next sectors/files/etc as bad even when they're not.

Then when I remove device with

$  echo 1 > /sys/block/sdp/device/delete

and physically unplug it and plug back in

kernel: sd 7:0:8:0: [sdp] Stopping disk
kernel: sd 7:0:8:0: [sdp] Start/Stop Unit failed: Result:
hostbyte=0x04 driverbyte=0x00
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 2 ctrl
sts=0x00000000.
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 2 irq
sts = 0x01001001
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1913:phy2 Removed Device
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 5 PID: 14363 at
/mnt/Linux/linux/fs/sysfs/group.c:237 sysfs_remove_group+0x8b/0x90
kernel: sysfs group ffffffff818a7520 not found for kobject 'end_device-7:2'
kernel: Modules linked in: nouveau arc4 ecb md4 hmac nls_utf8 cifs
dns_resolver snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device
fuse input_leds joydev mousedev
kernel:  v4l2_common aesni_intel snd_hda_codec_realtek
videobuf2_dma_sg videobuf2_memops aes_x86_64 videobuf2_v4l2
snd_hda_codec_hdmi snd_hda_codec_generic lrw videobuf
kernel:  ohci_hcd ehci_hcd ahci libahci scsi_transport_sas pata_atiixp
firewire_ohci firewire_core crc_itu_t libata usbcore scsi_mod
usb_common i2c_core i8042 serio wmi
kernel: CPU: 5 PID: 14363 Comm: kworker/u16:7 Tainted: G        W    L
 4.6.0-ARCH-dirty #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000286 000000000f07e6b6 ffff8801b7527c48 ffffffff812db8c2
kernel:  ffff8801b7527c98 0000000000000000 ffff8801b7527c88 ffffffff8107a5eb
kernel:  000000edb7527c88 0000000000000000 ffffffff818a7520 ffff8800aadcec10
kernel: Call Trace:
kernel:  [<ffffffff812db8c2>] dump_stack+0x63/0x81
kernel:  [<ffffffff8107a5eb>] __warn+0xcb/0xf0
kernel:  [<ffffffff8107a66f>] warn_slowpath_fmt+0x5f/0x80
kernel:  [<ffffffff81268888>] ? kernfs_find_and_get_ns+0x48/0x60
kernel:  [<ffffffff8126c3cb>] sysfs_remove_group+0x8b/0x90
kernel:  [<ffffffff8140b137>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813fd848>] device_del+0x58/0x260
kernel:  [<ffffffff813fda6e>] device_unregister+0x1e/0x60
kernel:  [<ffffffff812c7250>] bsg_unregister_queue+0x60/0xb0
kernel:  [<ffffffffa00546b8>] sas_rphy_remove+0x48/0x70 [scsi_transport_sas]
kernel:  [<ffffffffa00546f2>] sas_rphy_delete+0x12/0x20 [scsi_transport_sas]
kernel:  [<ffffffffa01207d3>] sas_destruct_devices+0x63/0x90 [libsas]
kernel:  [<ffffffff81093945>] process_one_work+0x1e5/0x480
kernel:  [<ffffffff81093c28>] worker_thread+0x48/0x4e0
kernel:  [<ffffffff81093be0>] ? process_one_work+0x480/0x480
kernel:  [<ffffffff810998d8>] kthread+0xd8/0xf0
kernel:  [<ffffffff815a9b82>] ret_from_fork+0x22/0x40
kernel:  [<ffffffff81099800>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace c5b6865bf5c3aba7 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 5 PID: 14363 at
/mnt/Linux/linux/fs/sysfs/group.c:237 sysfs_remove_group+0x8b/0x90
kernel: sysfs group ffffffff818a7520 not found for kobject 'end_device-7:2'
kernel: Modules linked in: nouveau arc4 ecb md4 hmac nls_utf8 cifs
dns_resolver snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device
fuse input_leds joydev mousedev
kernel:  v4l2_common aesni_intel snd_hda_codec_realtek
videobuf2_dma_sg videobuf2_memops aes_x86_64 videobuf2_v4l2
snd_hda_codec_hdmi snd_hda_codec_generic lrw videobuf
kernel:  ohci_hcd ehci_hcd ahci libahci scsi_transport_sas pata_atiixp
firewire_ohci firewire_core crc_itu_t libata usbcore scsi_mod
usb_common i2c_core i8042 serio wmi
kernel: CPU: 5 PID: 14363 Comm: kworker/u16:7 Tainted: G        W    L
 4.6.0-ARCH-dirty #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000286 000000000f07e6b6 ffff8801b7527c80 ffffffff812db8c2
kernel:  ffff8801b7527cd0 0000000000000000 ffff8801b7527cc0 ffffffff8107a5eb
kernel:  000000edb7527cc0 0000000000000000 ffffffff818a7520 ffff8800aadc9010
kernel: Call Trace:
kernel:  [<ffffffff812db8c2>] dump_stack+0x63/0x81
kernel:  [<ffffffff8107a5eb>] __warn+0xcb/0xf0
kernel:  [<ffffffff8107a66f>] warn_slowpath_fmt+0x5f/0x80
kernel:  [<ffffffff81268888>] ? kernfs_find_and_get_ns+0x48/0x60
kernel:  [<ffffffff8126c3cb>] sysfs_remove_group+0x8b/0x90
kernel:  [<ffffffff8140b137>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813fd848>] device_del+0x58/0x260
kernel:  [<ffffffffa00546c8>] sas_rphy_remove+0x58/0x70 [scsi_transport_sas]
kernel:  [<ffffffffa00546f2>] sas_rphy_delete+0x12/0x20 [scsi_transport_sas]
kernel:  [<ffffffffa01207d3>] sas_destruct_devices+0x63/0x90 [libsas]
kernel:  [<ffffffff81093945>] process_one_work+0x1e5/0x480
kernel:  [<ffffffff81093c28>] worker_thread+0x48/0x4e0
kernel:  [<ffffffff81093be0>] ? process_one_work+0x480/0x480
kernel:  [<ffffffff810998d8>] kthread+0xd8/0xf0
kernel:  [<ffffffff815a9b82>] ret_from_fork+0x22/0x40
kernel:  [<ffffffff81099800>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace c5b6865bf5c3abaa ]---
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1257:found
dev[2:5] is gone.
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 2 ctrl
sts=0x00122000.
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 2 irq
sts = 0x00000081
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1961:Get
signature time out, reset phy 2
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 2 ctrl
sts=0x00122000.
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 2 irq
sts = 0x00001081
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_94xx.c 884:get all reg
link rate is 0x122000
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_94xx.c 889:get link rate is 10
kernel: mvsas 0000:07:00.0: Phy2 : No sig fis
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1919:phy2 Attached Device
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 2 ctrl
sts=0x00122000.
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 2 irq
sts = 0x00010000
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 2026:notify plug
in on phy[2]
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_94xx.c 884:get all reg
link rate is 0x122000
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_94xx.c 889:get link rate is 10
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1079:phy 2 attach
dev info is 20001
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1081:phy 2 attach
sas addr is 2
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 277:phy 2 byte dmaded.
kernel: sas: phy-7:2 added to port-7:2, phy_mask:0x4 ( 200000000000000)
kernel: sas: DOING DISCOVERY on port 2, pid:14363
kernel: sas: DONE DISCOVERY on port 2, pid:14363, result:0
kernel: sas: Enter sas_scsi_recover_host busy: 0 failed: 0
kernel: sas: ata7: end_device-7:0: dev error handler
kernel: sas: ata8: end_device-7:1: dev error handler
kernel: sas: ata22: end_device-7:2: dev error handler
kernel: sas: ata10: end_device-7:3: dev error handler
kernel: sas: ata11: end_device-7:4: dev error handler
kernel: sas: ata12: end_device-7:5: dev error handler
kernel: sas: ata13: end_device-7:6: dev error handler
kernel: sas: ata14: end_device-7:7: dev error handler
kernel: ata22.00: ATA-8: ST2000DM001-9YN164, CC9F, max UDMA/133
kernel: ata22.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
kernel: ata22.00: configured for UDMA/133
kernel: sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
kernel: scsi 7:0:9:0: Direct-Access     ATA      ST2000DM001-9YN1 CC9F
PQ: 0 ANSI: 5
kernel: sd 7:0:9:0: [sdp] 3907029168 512-byte logical blocks: (2.00 TB/1.82 TiB)
kernel: sd 7:0:9:0: [sdp] 4096-byte physical blocks
kernel: sd 7:0:9:0: [sdp] Write Protect is off
kernel: sd 7:0:9:0: [sdp] Mode Sense: 00 3a 00 00
kernel: sd 7:0:9:0: [sdp] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
kernel: sd 7:0:9:0: [sdp] Attached SCSI disk

HDD works fine again until bad sector is accesed again.

I'm wondering how could improve this situation so that kernel
would autmatically do this device remove/add for this case or
handle it better.

Thanks.
