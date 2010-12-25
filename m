From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: kernel BUG at fs/btrfs/disk-io.c:2312 (me too, same as already
 posted few days ago, with trace)
Date: Fri, 24 Dec 2010 18:45:35 -0800 (PST)
Message-ID: <alpine.DEB.2.01.1012241840420.7903@trent.utfs.org>
References: <20101225025531.4226fe9c@pluto.pipapo.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101225025531.4226fe9c@pluto.pipapo.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: Christian Thaeter <ct@pipapo.org>
Cc: linux-btrfs@vger.kernel.org, mniederle@gmx.at, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 25 Dec 2010 at 02:55, Christian Thaeter wrote:
> I got a kernel BUG() while i was rsyncing to an external test-disk (USB
> Y-cable, I think I didn't glitched the cable).

So, this seems more and more USB related, no? CC'ing lkml and linux-scsi. 
To recap: this happens with 2.6.37-rc5 and with 2.6.37-rc7, but did not 
happen with earlier kernels? (-rc4 was ok? Michael?)

> Anyways, I post this  at
> least for the note, perhaps an IO-Error should not barf the entire
> kernel someday.
> 
> The filesystem was mounted with -o compress=lzo,space_cache,noatime
> The kernel version is 2.6.37-rc7 with btrfs/next (up to commit
> 0df2b36c5f646615a9b0c4c1efa11641c36162ae) merged on top of it.
> 
> The Bug appeared when there was some high io-load (rsyncing and apt-get installing something on the source filesystem which is ext4)
> 
> Dec 25 02:08:56 pluto kernel: [  741.967359] device fsid 9d40faecbbdc1e5b-a5858346ea08a08f devid 1 transid 10 /dev/mapper/backup
> Dec 25 02:08:56 pluto kernel: [  741.970862] btrfs: use lzo compression
> Dec 25 02:08:56 pluto kernel: [  741.970868] btrfs: enabling disk space caching
> Dec 25 02:10:21 pluto kernel: [  826.947392] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
> Dec 25 02:10:21 pluto kernel: [  826.949370] input: Bluetooth Laser Travel Mouse as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/bluetooth/hci0/hci0:11/input10
> Dec 25 02:10:21 pluto kernel: [  826.949624] generic-bluetooth 0005:046D:B008.0001: input,hidraw0: BLUETOOTH HID v3.14 Mouse [Bluetooth Laser Travel Mouse] on 00:1A:6B:BA:38:86
> Dec 25 02:15:01 pluto /USR/SBIN/CRON[2574]: (root) CMD (command -v debian-sa1 > /dev/null && debian-sa1 1 1)
> Dec 25 02:17:01 pluto /USR/SBIN/CRON[2596]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
> Dec 25 02:18:44 pluto kernel: [ 1329.493258] usb 2-1: reset high speed USB device using ehci_hcd and address 3
> Dec 25 02:18:54 pluto kernel: [ 1339.723307] sd 2:0:0:0: Device offlined - not ready after error recovery
> Dec 25 02:18:54 pluto kernel: [ 1339.723316] usb 2-1: USB disconnect, address 3
> Dec 25 02:18:54 pluto kernel: [ 1339.723321] sd 2:0:0:0: [sdb] Unhandled error code
> Dec 25 02:18:54 pluto kernel: [ 1339.723326] sd 2:0:0:0: [sdb]  Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
> Dec 25 02:18:54 pluto kernel: [ 1339.723333] sd 2:0:0:0: [sdb] CDB: Write(10): 2a 00 00 73 79 70 00 00 10 00
> Dec 25 02:18:54 pluto kernel: [ 1339.723349] end_request: I/O error, dev sdb, sector 7567728
> Dec 25 02:18:54 pluto kernel: [ 1339.723400] sd 2:0:0:0: rejecting I/O to offline device
> Dec 25 02:18:54 pluto kernel: [ 1339.723415] sd 2:0:0:0: rejecting I/O to offline device
> Dec 25 02:18:57 pluto kernel: [ 1343.236930] lost page write due to I/O error on dm-1
> Dec 25 02:18:57 pluto kernel: [ 1343.237119] lost page write due to I/O error on dm-1
> Dec 25 02:18:57 pluto kernel: [ 1343.237128] btrfs: 1 errors while writing supers
> Dec 25 02:18:57 pluto kernel: [ 1343.237215] ------------[ cut here ]------------
> Dec 25 02:18:57 pluto kernel: [ 1343.237273] kernel BUG at fs/btrfs/disk-io.c:2312!
> Dec 25 02:18:57 pluto kernel: [ 1343.237319] invalid opcode: 0000 [#1] PREEMPT SMP 
> Dec 25 02:18:57 pluto kernel: [ 1343.237379] last sysfs file: /sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/C23D/charge_full
> Dec 25 02:18:57 pluto kernel: [ 1343.237459] CPU 1 
> Dec 25 02:18:57 pluto kernel: [ 1343.237481] Modules linked in: hidp hid usb_storage mmc_block sco bridge stp bnep rfcomm l2cap microcode fuse loop firewire_sbp2 snd_hda_codec_analog arc4 i915 ecb snd_hda_intel 
> snd_hda_codec pcmcia drm_kms_helper iwl3945 snd_hwdep drm joydev snd_pcm snd_timer iwlcore snd i2c_algo_bit yenta_socket soundcore mac80211 intel_agp hp_wmi i2c_core pcmcia_rsrc hp_accel btusb intel_gtt tpm_tis 
> wmi tpm bluetooth pcmcia_core lis3lv02d video tpm_bios agpgart ac snd_page_alloc psmouse cfg80211 output evdev processor battery input_polldev serio_raw container button rfkill ext4 mbcache jbd2 crc16 sha256_gen
> eric aes_x86_64 aes_generic cbc dm_crypt dm_mod btrfs zlib_deflate crc32c libcrc32c sg uhci_hcd sdhci_pci sdhci firewire_ohci firewire_core mmc_core sr_mod e1000e thermal cdrom sd_mod crc_t10dif crc_itu_t ehci_h
> cd usbcore fan thermal_sys nls_base [last unloaded: scsi_wait_scan]
> Dec 25 02:18:57 pluto kernel: [ 1343.238578] 
> Dec 25 02:18:57 pluto kernel: [ 1343.238599] Pid: 2261, comm: btrfs-transacti Not tainted 2.6.37-rc7btrfs-lzo+ #10 30C9/HP Compaq 2510p (GM651AW#ABD)
> Dec 25 02:18:57 pluto kernel: [ 1343.238688] RIP: 0010:[<ffffffffa0275fd8>]  [<ffffffffa0275fd8>] write_all_supers+0x278/0x280 [btrfs]
> Dec 25 02:18:57 pluto kernel: [ 1343.238800] RSP: 0018:ffff88013d8e3d40  EFLAGS: 00010282
> Dec 25 02:18:57 pluto kernel: [ 1343.238848] RAX: 000000000000003a RBX: ffff88013be811f0 RCX: 000000000000001e
> Dec 25 02:18:57 pluto kernel: [ 1343.238909] RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffffffff816e2c98
> Dec 25 02:18:57 pluto kernel: [ 1343.238969] RBP: ffff88013d8e3da0 R08: 0000000000000001 R09: 0000000000000000
> Dec 25 02:18:57 pluto kernel: [ 1343.239028] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> Dec 25 02:18:57 pluto kernel: [ 1343.239088] R13: ffff88013be811f0 R14: 0000000000000001 R15: 0000000000000000
> Dec 25 02:18:57 pluto kernel: [ 1343.239148] FS:  0000000000000000(0000) GS:ffff8800bf500000(0000) knlGS:0000000000000000
> Dec 25 02:18:57 pluto kernel: [ 1343.239218] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Dec 25 02:18:57 pluto kernel: [ 1343.239267] CR2: 00007fcdcdc380a0 CR3: 0000000001603000 CR4: 00000000000006e0
> Dec 25 02:18:57 pluto kernel: [ 1343.239328] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Dec 25 02:18:57 pluto kernel: [ 1343.239389] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Dec 25 02:18:57 pluto kernel: [ 1343.239449] Process btrfs-transacti (pid: 2261, threadinfo ffff88013d8e2000, task ffff88013d069620)
> Dec 25 02:18:57 pluto kernel: [ 1343.239522] Stack:
> Dec 25 02:18:57 pluto kernel: [ 1343.239544]  ffff88013d984f76 ffff88013d984f86 ffff88013be81180 0000000000000000
> Dec 25 02:18:57 pluto kernel: [ 1343.239626]  ffff88013d984e6b ffff88013b416800 ffff88013d8e3da0 ffff88013b416800
> Dec 25 02:18:57 pluto kernel: [ 1343.239707]  ffff88013d668b40 ffff88013d8e3df0 ffff88013506e640 0000000000000000
> Dec 25 02:18:57 pluto kernel: [ 1343.239789] Call Trace:
> Dec 25 02:18:57 pluto kernel: [ 1343.239832]  [<ffffffffa0275fee>] write_ctree_super+0xe/0x10 [btrfs]
> Dec 25 02:18:57 pluto kernel: [ 1343.239906]  [<ffffffffa027b7c7>] btrfs_commit_transaction+0x557/0x710 [btrfs]
> Dec 25 02:18:57 pluto kernel: [ 1343.239976]  [<ffffffff81069880>] ? autoremove_wake_function+0x0/0x40
> Dec 25 02:18:57 pluto kernel: [ 1343.240046]  [<ffffffffa0275573>] transaction_kthread+0x273/0x280 [btrfs]
> Dec 25 02:18:57 pluto kernel: [ 1343.240119]  [<ffffffffa0275300>] ? transaction_kthread+0x0/0x280 [btrfs]
> Dec 25 02:18:57 pluto kernel: [ 1343.240191]  [<ffffffffa0275300>] ? transaction_kthread+0x0/0x280 [btrfs]
> Dec 25 02:18:57 pluto kernel: [ 1343.240252]  [<ffffffff81069326>] kthread+0x96/0xa0
> Dec 25 02:18:57 pluto kernel: [ 1343.240299]  [<ffffffff81003cd4>] kernel_thread_helper+0x4/0x10
> Dec 25 02:18:57 pluto kernel: [ 1343.240352]  [<ffffffff81069290>] ? kthread+0x0/0xa0
> Dec 25 02:18:57 pluto kernel: [ 1343.240400]  [<ffffffff81003cd0>] ? kernel_thread_helper+0x0/0x10
> Dec 25 02:18:57 pluto kernel: [ 1343.240451] Code: 5e 41 5f c9 c3 44 89 fe 48 c7 c7 d8 88 2c a0 31 c0 e8 16 66 13 e1 0f 0b eb fe 44 89 e6 48 c7 c7 d8 88 2c a0 31 c0 e8 01 66 13 e1 <0f> 0b eb fe 0f 1f 40 00 55 48 89 f7 48 89 e5 89 d6 e8 72 fd ff 
> Dec 25 02:18:57 pluto kernel: [ 1343.240457] RIP  [<ffffffffa0275fd8>] write_all_supers+0x278/0x280 [btrfs]
> Dec 25 02:18:57 pluto kernel: [ 1343.240457]  RSP <ffff88013d8e3d40>
> Dec 25 02:18:57 pluto kernel: [ 1343.250690] ---[ end trace 19ee86da2308321f ]---
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
BOFH excuse #145:

Flat tire on station wagon with tapes.  ("Never underestimate the bandwidth of a station wagon full of tapes hurling down the highway" Andrew S. Tannenbaum)
