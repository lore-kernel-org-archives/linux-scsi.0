From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [RFC 0/2] target refcounting infrastructure fixes for usb
Date: Fri, 20 Dec 2013 15:18:10 -0800
Message-ID: <20131220231810.GA2835@xanatos>
References: <Pine.LNX.4.44L0.1312181644460.3745-100000@iolanthe.rowland.org>
 <1387411505.24521.3.camel@dabdike>
 <20131219182603.GD3573@xanatos>
 <1387482527.2242.9.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22649 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab3LTXSN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 18:18:13 -0500
Content-Disposition: inline
In-Reply-To: <1387482527.2242.9.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Thu, Dec 19, 2013 at 11:48:47AM -0800, James Bottomley wrote:
> It should apply incrementally on top of the previous two.  If it
> actually works, I'll fold it into the first patch.

Well, it doesn't oops anymore, but it does generate a pile of warnings:

Dec 20 15:13:55 xanatos kernel: [   39.308652] usb usb2: usb wakeup-resume
Dec 20 15:13:55 xanatos kernel: [   39.308671] usb usb2: usb auto-resume
Dec 20 15:13:55 xanatos kernel: [   39.308688] hub 2-0:1.0: hub_resume
Dec 20 15:13:55 xanatos kernel: [   39.308759] hub 2-0:1.0: port 2: status 0203 change 0001
Dec 20 15:13:55 xanatos kernel: [   39.410694] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0000
Dec 20 15:13:55 xanatos kernel: [   39.410793] hub 2-0:1.0: port 2, status 0203, change 0000, 5.0 Gb/s
Dec 20 15:13:55 xanatos kernel: [   39.523217] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
Dec 20 15:13:55 xanatos kernel: [   39.539322] usb 2-2: skipped 1 descriptor after endpoint
Dec 20 15:13:55 xanatos kernel: [   39.539331] usb 2-2: skipped 1 descriptor after endpoint
Dec 20 15:13:55 xanatos kernel: [   39.539343] usb 2-2: skipped 2 descriptors after endpoint
Dec 20 15:13:55 xanatos kernel: [   39.539347] usb 2-2: skipped 2 descriptors after endpoint
Dec 20 15:13:55 xanatos kernel: [   39.539350] usb 2-2: skipped 2 descriptors after endpoint
Dec 20 15:13:55 xanatos kernel: [   39.539353] usb 2-2: skipped 2 descriptors after endpoint
Dec 20 15:13:55 xanatos kernel: [   39.539473] usb 2-2: default language 0x0409
Dec 20 15:13:55 xanatos kernel: [   39.539944] usb 2-2: udev 2, busnum 2, minor = 129
Dec 20 15:13:55 xanatos kernel: [   39.539949] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
Dec 20 15:13:55 xanatos kernel: [   39.539953] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
Dec 20 15:13:55 xanatos kernel: [   39.539956] usb 2-2: Product: Plugable USB3-SATA-UASP1
Dec 20 15:13:55 xanatos kernel: [   39.539959] usb 2-2: Manufacturer: ASM1053E
Dec 20 15:13:55 xanatos kernel: [   39.539962] usb 2-2: SerialNumber: 123456789045
Dec 20 15:13:55 xanatos kernel: [   39.540325] usb 2-2: usb_probe_device
Dec 20 15:13:55 xanatos kernel: [   39.540329] usb 2-2: configuration #1 chosen from 1 choice
Dec 20 15:13:55 xanatos kernel: [   39.540984] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
Dec 20 15:13:55 xanatos kernel: [   39.541449] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
Dec 20 15:13:55 xanatos kernel: [   39.803919] usb-storage 2-2:1.0: usb_probe_interface
Dec 20 15:13:55 xanatos kernel: [   39.803925] usb-storage 2-2:1.0: usb_probe_interface - got id
Dec 20 15:13:55 xanatos kernel: [   39.805481] usbcore: registered new interface driver usb-storage
Dec 20 15:13:55 xanatos kernel: [   39.813311] uas 2-2:1.0: usb_probe_interface
Dec 20 15:13:55 xanatos kernel: [   39.813316] uas 2-2:1.0: usb_probe_interface - got id
Dec 20 15:13:55 xanatos kernel: [   39.816517] scsi6 : uas
Dec 20 15:13:55 xanatos kernel: [   39.817396] usbcore: registered new interface driver uas
Dec 20 15:13:55 xanatos kernel: [   39.817800] scsi 6:0:0:0: Direct-Access     ASM1053E Plugable USB3-SA 0    PQ: 0 ANSI: 6
Dec 20 15:13:55 xanatos kernel: [   39.819074] sd 6:0:0:0: Attached scsi generic sg1 type 0
Dec 20 15:13:55 xanatos kernel: [   39.822442] sd 6:0:0:0: [sdb] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
Dec 20 15:13:55 xanatos kernel: [   39.823167] sd 6:0:0:0: [sdb] Write Protect is off
Dec 20 15:13:55 xanatos kernel: [   39.823170] sd 6:0:0:0: [sdb] Mode Sense: 43 00 00 00
Dec 20 15:13:55 xanatos kernel: [   39.823485] sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 20 15:13:55 xanatos kernel: [   39.826181]  sdb: sdb1 sdb2 sdb4
Dec 20 15:13:55 xanatos kernel: [   39.828846] sd 6:0:0:0: [sdb] Attached SCSI disk
Dec 20 15:13:56 xanatos kernel: [   40.488826] kjournald starting.  Commit interval 5 seconds
Dec 20 15:13:56 xanatos kernel: [   40.489106] EXT3-fs (sdb1): using internal journal
Dec 20 15:13:56 xanatos kernel: [   40.489109] EXT3-fs (sdb1): mounted filesystem with ordered data mode
Dec 20 15:13:56 xanatos kernel: [   40.500765] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
Dec 20 15:13:56 xanatos kernel: [   40.523432] FAT-fs (sdb4): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
Dec 20 15:14:05 xanatos kernel: [   48.893833] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
Dec 20 15:14:05 xanatos kernel: [   48.893982] hub 2-0:1.0: warm reset port 2
Dec 20 15:14:05 xanatos kernel: [   48.932106] sd 6:0:0:0: [sdb] uas_cmd_cmplt ffff880097b1d000 tag 0, inflight: CMD IN
Dec 20 15:14:05 xanatos kernel: [   48.932112] sd 6:0:0:0: [sdb] cmd cmplt err -71
Dec 20 15:14:05 xanatos kernel: [   48.935707] sd 6:0:0:0: [sdb] uas_cmd_cmplt ffff880097b1ca00 tag 1, inflight: CMD IN
Dec 20 15:14:05 xanatos kernel: [   48.935727] sd 6:0:0:0: [sdb] cmd cmplt err -71
Dec 20 15:14:05 xanatos kernel: [   48.948901] hub 2-0:1.0: port 2 not warm reset yet, waiting 50ms
Dec 20 15:14:05 xanatos kernel: [   49.005322] hub 2-0:1.0: port 2, status 02c0, change 0041, 5.0 Gb/s
Dec 20 15:14:05 xanatos kernel: [   49.005327] usb 2-2: USB disconnect, device number 2
Dec 20 15:14:05 xanatos kernel: [   49.005329] usb 2-2: unregistering device
Dec 20 15:14:05 xanatos kernel: [   49.005331] usb 2-2: unregistering interface 2-2:1.0
Dec 20 15:14:05 xanatos kernel: [   49.005557] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
Dec 20 15:14:05 xanatos kernel: [   49.005589] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
Dec 20 15:14:05 xanatos kernel: [   49.005620] xhci_hcd 0000:00:14.0: shutdown urb ffff88009dd86e40 ep1in-bulk
Dec 20 15:14:05 xanatos kernel: [   49.005623] xhci_hcd 0000:00:14.0: shutdown urb ffff88009dd86540 ep1in-bulk
Dec 20 15:14:05 xanatos kernel: [   49.005664] sd 6:0:0:0: [sdb] uas_data_cmplt ffff880097b1d000 tag 0, inflight: CMD
Dec 20 15:14:05 xanatos kernel: [   49.005668] sd 6:0:0:0: [sdb] data cmplt err -108 stream 2
Dec 20 15:14:05 xanatos kernel: [   49.005676] sd 6:0:0:0: [sdb] uas_data_cmplt ffff880097b1ca00 tag 1, inflight: CMD
Dec 20 15:14:05 xanatos kernel: [   49.005678] sd 6:0:0:0: [sdb] data cmplt err -108 stream 3
Dec 20 15:14:05 xanatos kernel: [   49.005690] xhci_hcd 0000:00:14.0: shutdown urb ffff88009dd86f00 ep3in-bulk
Dec 20 15:14:05 xanatos kernel: [   49.005694] xhci_hcd 0000:00:14.0: shutdown urb ffff88009dd866c0 ep3in-bulk
Dec 20 15:14:05 xanatos kernel: [   49.005702] usb 2-2: stat urb: status -108
Dec 20 15:14:05 xanatos kernel: [   49.005714] usb 2-2: stat urb: status -108
Dec 20 15:14:05 xanatos kernel: [   49.005724] sd 6:0:0:0: [sdb] uas_disconnect ffff880097b1d000 tag 0, inflight: CMD
Dec 20 15:14:05 xanatos kernel: [   49.005726] sd 6:0:0:0: [sdb] uas_disconnect ffff880097b1ca00 tag 1, inflight: CMD
Dec 20 15:14:05 xanatos kernel: [   49.005728] sd 6:0:0:0: [sdb] uas_zap_dead ffff880097b1d000 tag 0, inflight: CMD abort
Dec 20 15:14:05 xanatos kernel: [   49.005730] sd 6:0:0:0: [sdb] abort completed
Dec 20 15:14:05 xanatos kernel: [   49.005733] sd 6:0:0:0: [sdb] uas_zap_dead ffff880097b1ca00 tag 1, inflight: CMD abort
Dec 20 15:14:05 xanatos kernel: [   49.005735] sd 6:0:0:0: [sdb] abort completed
Dec 20 15:14:05 xanatos kernel: [   49.006020] ------------[ cut here ]------------
Dec 20 15:14:05 xanatos kernel: [   49.006026] WARNING: CPU: 0 PID: 34 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
Dec 20 15:14:05 xanatos kernel: [   49.006027] sysfs group ffffffff81ca3240 not found for kobject '6:0:0:0'
Dec 20 15:14:05 xanatos kernel: [   49.006028] Modules linked in: nls_iso8859_1 uas usb_storage cuse dm_crypt uvcvideo x86_pkg_temp_thermal coretemp ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core videodev aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd arc4 snd_hda_codec_hdmi iwldvm mac80211 microcode psmouse snd_usb_audio thinkpad_acpi iwlwifi snd_usbmidi_lib snd_hda_codec_realtek nvram serio_raw snd_seq_midi snd_seq_midi_event snd_hda_intel snd_rawmidi joydev snd_seq snd_hda_codec cfg80211 snd_hwdep snd_pcm bnep rfcomm snd_page_alloc ehci_pci lpc_ich bluetooth ehci_hcd snd_seq_device snd_timer snd soundcore tpm_tis binfmt_misc btrfs libcrc32c xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper drm e1000e ahci sdhci_pci libahci sd
 hci ptp xhci_hcd pps_core video
Dec 20 15:14:05 xanatos kernel: [   49.006062] CPU: 0 PID: 34 Comm: khubd Not tainted 3.13.0-rc1+ #153
Dec 20 15:14:05 xanatos kernel: [   49.006063] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Dec 20 15:14:05 xanatos kernel: [   49.006064]  0000000000000009 ffff8801179f9a10 ffffffff81658a4e ffff8801179f9a58
Dec 20 15:14:05 xanatos kernel: [   49.006067]  ffff8801179f9a48 ffffffff81048c3d 0000000000000000 ffffffff81ca3240
Dec 20 15:14:05 xanatos kernel: [   49.006069]  ffff8800992bfc10 ffff88010ab481a0 ffff8800c5674800 ffff8801179f9aa8
Dec 20 15:14:05 xanatos kernel: [   49.006072] Call Trace:
Dec 20 15:14:05 xanatos kernel: [   49.006075]  [<ffffffff81658a4e>] dump_stack+0x4d/0x66
Dec 20 15:14:05 xanatos kernel: [   49.006079]  [<ffffffff81048c3d>] warn_slowpath_common+0x7d/0xa0
Dec 20 15:14:05 xanatos kernel: [   49.006081]  [<ffffffff81048cac>] warn_slowpath_fmt+0x4c/0x50
Dec 20 15:14:05 xanatos kernel: [   49.006083]  [<ffffffff8165f6ce>] ? mutex_unlock+0xe/0x10
Dec 20 15:14:05 xanatos kernel: [   49.006086]  [<ffffffff81223550>] ? sysfs_get_dirent_ns+0x50/0x70
Dec 20 15:14:05 xanatos kernel: [   49.006088]  [<ffffffff81224896>] sysfs_remove_group+0xc6/0xd0
Dec 20 15:14:05 xanatos kernel: [   49.006091]  [<ffffffff81430483>] dpm_sysfs_remove+0x43/0x50
Dec 20 15:14:05 xanatos kernel: [   49.006094]  [<ffffffff81426235>] device_del+0x45/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.006096]  [<ffffffff814263de>] device_unregister+0x1e/0x60
Dec 20 15:14:05 xanatos kernel: [   49.006099]  [<ffffffff81324390>] bsg_unregister_queue+0x60/0xa0
Dec 20 15:14:05 xanatos kernel: [   49.006103]  [<ffffffff8145c009>] __scsi_remove_device+0xb9/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.006105]  [<ffffffff8145a5af>] scsi_forget_host+0x6f/0x80
Dec 20 15:14:05 xanatos kernel: [   49.006108]  [<ffffffff8144ee96>] scsi_remove_host+0x76/0x130
Dec 20 15:14:05 xanatos kernel: [   49.006111]  [<ffffffffa05ab07d>] uas_disconnect+0x7d/0xa0 [uas]
Dec 20 15:14:05 xanatos kernel: [   49.006114]  [<ffffffff814b7287>] usb_unbind_interface+0x77/0x2b0
Dec 20 15:14:05 xanatos kernel: [   49.006116]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.006119]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.006121]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.006123]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.006125]  [<ffffffff814b4b90>] usb_disable_device+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.006127]  [<ffffffff814a92e5>] usb_disconnect+0xb5/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.006129]  [<ffffffff814ac526>] hub_thread+0x616/0x1710
Dec 20 15:14:05 xanatos kernel: [   49.006132]  [<ffffffff8109812d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Dec 20 15:14:05 xanatos kernel: [   49.006135]  [<ffffffff8108eb10>] ? prepare_to_wait_event+0x100/0x100
Dec 20 15:14:05 xanatos kernel: [   49.006137]  [<ffffffff814abf10>] ? usb_reset_device+0x1d0/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.006140]  [<ffffffff8106dc8c>] kthread+0xfc/0x120
Dec 20 15:14:05 xanatos kernel: [   49.006143]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.006145]  [<ffffffff81669cac>] ret_from_fork+0x7c/0xb0
Dec 20 15:14:05 xanatos kernel: [   49.006147]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.006149] ---[ end trace 9806a4327f2ac457 ]---
Dec 20 15:14:05 xanatos kernel: [   49.006200] sd 6:0:0:0: [sdb] Unhandled error code
Dec 20 15:14:05 xanatos kernel: [   49.006204] sd 6:0:0:0: [sdb]  
Dec 20 15:14:05 xanatos kernel: [   49.006207] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Dec 20 15:14:05 xanatos kernel: [   49.006209] sd 6:0:0:0: [sdb] CDB: 
Dec 20 15:14:05 xanatos kernel: [   49.006212] Read(10): 28 00 01 8c 72 e0 00 01 00 00
Dec 20 15:14:05 xanatos kernel: [   49.006220] end_request: I/O error, dev sdb, sector 25981664
Dec 20 15:14:05 xanatos kernel: [   49.006296] sd 6:0:0:0: [sdb] Unhandled error code
Dec 20 15:14:05 xanatos kernel: [   49.006299] sd 6:0:0:0: [sdb]  
Dec 20 15:14:05 xanatos kernel: [   49.006300] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Dec 20 15:14:05 xanatos kernel: [   49.006301] sd 6:0:0:0: [sdb] CDB: 
Dec 20 15:14:05 xanatos kernel: [   49.006302] Read(10): 28 00 01 8c 73 e0 00 01 00 00
Dec 20 15:14:05 xanatos kernel: [   49.006307] end_request: I/O error, dev sdb, sector 25981920
Dec 20 15:14:05 xanatos kernel: [   49.009320] ------------[ cut here ]------------
Dec 20 15:14:05 xanatos kernel: [   49.009330] WARNING: CPU: 3 PID: 34 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
Dec 20 15:14:05 xanatos kernel: [   49.009333] sysfs group ffffffff81ca3240 not found for kobject '6:0:0:0'
Dec 20 15:14:05 xanatos kernel: [   49.009334] Modules linked in: nls_iso8859_1 uas usb_storage cuse dm_crypt uvcvideo x86_pkg_temp_thermal coretemp ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core videodev aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd arc4 snd_hda_codec_hdmi iwldvm mac80211 microcode psmouse snd_usb_audio thinkpad_acpi iwlwifi snd_usbmidi_lib snd_hda_codec_realtek nvram serio_raw snd_seq_midi snd_seq_midi_event snd_hda_intel snd_rawmidi joydev snd_seq snd_hda_codec cfg80211 snd_hwdep snd_pcm bnep rfcomm snd_page_alloc ehci_pci lpc_ich bluetooth ehci_hcd snd_seq_device snd_timer snd soundcore tpm_tis binfmt_misc btrfs libcrc32c xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper drm e1000e ahci sdhci_pci libahci sd
 hci ptp xhci_hcd pps_core video
Dec 20 15:14:05 xanatos kernel: [   49.009397] CPU: 3 PID: 34 Comm: khubd Tainted: G        W    3.13.0-rc1+ #153
Dec 20 15:14:05 xanatos kernel: [   49.009399] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Dec 20 15:14:05 xanatos kernel: [   49.009401]  0000000000000009 ffff8801179f9a28 ffffffff81658a4e ffff8801179f9a70
Dec 20 15:14:05 xanatos kernel: [   49.009405]  ffff8801179f9a60 ffffffff81048c3d 0000000000000000 ffffffff81ca3240
Dec 20 15:14:05 xanatos kernel: [   49.009409]  ffff88010ab485a8 ffff88010ab481a0 ffff8800c5674800 ffff8801179f9ac0
Dec 20 15:14:05 xanatos kernel: [   49.009413] Call Trace:
Dec 20 15:14:05 xanatos kernel: [   49.009419]  [<ffffffff81658a4e>] dump_stack+0x4d/0x66
Dec 20 15:14:05 xanatos kernel: [   49.009424]  [<ffffffff81048c3d>] warn_slowpath_common+0x7d/0xa0
Dec 20 15:14:05 xanatos kernel: [   49.009427]  [<ffffffff81048cac>] warn_slowpath_fmt+0x4c/0x50
Dec 20 15:14:05 xanatos kernel: [   49.009431]  [<ffffffff8165f6ce>] ? mutex_unlock+0xe/0x10
Dec 20 15:14:05 xanatos kernel: [   49.009434]  [<ffffffff81223550>] ? sysfs_get_dirent_ns+0x50/0x70
Dec 20 15:14:05 xanatos kernel: [   49.009437]  [<ffffffff81224896>] sysfs_remove_group+0xc6/0xd0
Dec 20 15:14:05 xanatos kernel: [   49.009442]  [<ffffffff81430483>] dpm_sysfs_remove+0x43/0x50
Dec 20 15:14:05 xanatos kernel: [   49.009446]  [<ffffffff81426235>] device_del+0x45/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.009449]  [<ffffffff814263de>] device_unregister+0x1e/0x60
Dec 20 15:14:05 xanatos kernel: [   49.009453]  [<ffffffff8145c015>] __scsi_remove_device+0xc5/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.009457]  [<ffffffff8145a5af>] scsi_forget_host+0x6f/0x80
Dec 20 15:14:05 xanatos kernel: [   49.009461]  [<ffffffff8144ee96>] scsi_remove_host+0x76/0x130
Dec 20 15:14:05 xanatos kernel: [   49.009466]  [<ffffffffa05ab07d>] uas_disconnect+0x7d/0xa0 [uas]
Dec 20 15:14:05 xanatos kernel: [   49.009470]  [<ffffffff814b7287>] usb_unbind_interface+0x77/0x2b0
Dec 20 15:14:05 xanatos kernel: [   49.009474]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.009481]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.009489]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.009496]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.009503]  [<ffffffff814b4b90>] usb_disable_device+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.009510]  [<ffffffff814a92e5>] usb_disconnect+0xb5/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.009518]  [<ffffffff814ac526>] hub_thread+0x616/0x1710
Dec 20 15:14:05 xanatos kernel: [   49.009525]  [<ffffffff8109812d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Dec 20 15:14:05 xanatos kernel: [   49.009533]  [<ffffffff8108eb10>] ? prepare_to_wait_event+0x100/0x100
Dec 20 15:14:05 xanatos kernel: [   49.009541]  [<ffffffff814abf10>] ? usb_reset_device+0x1d0/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.009549]  [<ffffffff8106dc8c>] kthread+0xfc/0x120
Dec 20 15:14:05 xanatos kernel: [   49.009557]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.009562]  [<ffffffff81669cac>] ret_from_fork+0x7c/0xb0
Dec 20 15:14:05 xanatos kernel: [   49.009565]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.009567] ---[ end trace 9806a4327f2ac458 ]---
Dec 20 15:14:05 xanatos kernel: [   49.009582] ------------[ cut here ]------------
Dec 20 15:14:05 xanatos kernel: [   49.009585] WARNING: CPU: 3 PID: 34 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
Dec 20 15:14:05 xanatos kernel: [   49.009587] sysfs group ffffffff81ca3240 not found for kobject 'sg1'
Dec 20 15:14:05 xanatos kernel: [   49.009589] Modules linked in: nls_iso8859_1 uas usb_storage cuse dm_crypt uvcvideo x86_pkg_temp_thermal coretemp ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core videodev aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd arc4 snd_hda_codec_hdmi iwldvm mac80211 microcode psmouse snd_usb_audio thinkpad_acpi iwlwifi snd_usbmidi_lib snd_hda_codec_realtek nvram serio_raw snd_seq_midi snd_seq_midi_event snd_hda_intel snd_rawmidi joydev snd_seq snd_hda_codec cfg80211 snd_hwdep snd_pcm bnep rfcomm snd_page_alloc ehci_pci lpc_ich bluetooth ehci_hcd snd_seq_device snd_timer snd soundcore tpm_tis binfmt_misc btrfs libcrc32c xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper drm e1000e ahci sdhci_pci libahci sd
 hci ptp xhci_hcd pps_core video
Dec 20 15:14:05 xanatos kernel: [   49.009642] CPU: 3 PID: 34 Comm: khubd Tainted: G        W    3.13.0-rc1+ #153
Dec 20 15:14:05 xanatos kernel: [   49.009644] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Dec 20 15:14:05 xanatos kernel: [   49.009645]  0000000000000009 ffff8801179f9988 ffffffff81658a4e ffff8801179f99d0
Dec 20 15:14:05 xanatos kernel: [   49.009657]  ffff8801179f99c0 ffffffff81048c3d 0000000000000000 ffffffff81ca3240
Dec 20 15:14:05 xanatos kernel: [   49.009670]  ffff8800b3691810 ffff88010ab481a0 0000000000000282 ffff8801179f9a20
Dec 20 15:14:05 xanatos kernel: [   49.009680] Call Trace:
Dec 20 15:14:05 xanatos kernel: [   49.009683]  [<ffffffff81658a4e>] dump_stack+0x4d/0x66
Dec 20 15:14:05 xanatos kernel: [   49.009687]  [<ffffffff81048c3d>] warn_slowpath_common+0x7d/0xa0
Dec 20 15:14:05 xanatos kernel: [   49.009690]  [<ffffffff81048cac>] warn_slowpath_fmt+0x4c/0x50
Dec 20 15:14:05 xanatos kernel: [   49.009693]  [<ffffffff8165f6ce>] ? mutex_unlock+0xe/0x10
Dec 20 15:14:05 xanatos kernel: [   49.009697]  [<ffffffff81223550>] ? sysfs_get_dirent_ns+0x50/0x70
Dec 20 15:14:05 xanatos kernel: [   49.009700]  [<ffffffff81224896>] sysfs_remove_group+0xc6/0xd0
Dec 20 15:14:05 xanatos kernel: [   49.009703]  [<ffffffff81430483>] dpm_sysfs_remove+0x43/0x50
Dec 20 15:14:05 xanatos kernel: [   49.009706]  [<ffffffff81426235>] device_del+0x45/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.009709]  [<ffffffff814263de>] device_unregister+0x1e/0x60
Dec 20 15:14:05 xanatos kernel: [   49.009712]  [<ffffffff8142649c>] device_destroy+0x3c/0x50
Dec 20 15:14:05 xanatos kernel: [   49.009716]  [<ffffffff8146ccf9>] sg_remove+0xd9/0x140
Dec 20 15:14:05 xanatos kernel: [   49.009719]  [<ffffffff814262c1>] device_del+0xd1/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.009722]  [<ffffffff814263de>] device_unregister+0x1e/0x60
Dec 20 15:14:05 xanatos kernel: [   49.009726]  [<ffffffff8145c015>] __scsi_remove_device+0xc5/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.009729]  [<ffffffff8145a5af>] scsi_forget_host+0x6f/0x80
Dec 20 15:14:05 xanatos kernel: [   49.009736]  [<ffffffff8144ee96>] scsi_remove_host+0x76/0x130
Dec 20 15:14:05 xanatos kernel: [   49.009743]  [<ffffffffa05ab07d>] uas_disconnect+0x7d/0xa0 [uas]
Dec 20 15:14:05 xanatos kernel: [   49.009750]  [<ffffffff814b7287>] usb_unbind_interface+0x77/0x2b0
Dec 20 15:14:05 xanatos kernel: [   49.009758]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.009765]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.009768]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.009771]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.009774]  [<ffffffff814b4b90>] usb_disable_device+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.009777]  [<ffffffff814a92e5>] usb_disconnect+0xb5/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.009780]  [<ffffffff814ac526>] hub_thread+0x616/0x1710
Dec 20 15:14:05 xanatos kernel: [   49.009783]  [<ffffffff8109812d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Dec 20 15:14:05 xanatos kernel: [   49.009787]  [<ffffffff8108eb10>] ? prepare_to_wait_event+0x100/0x100
Dec 20 15:14:05 xanatos kernel: [   49.009790]  [<ffffffff814abf10>] ? usb_reset_device+0x1d0/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.009793]  [<ffffffff8106dc8c>] kthread+0xfc/0x120
Dec 20 15:14:05 xanatos kernel: [   49.009797]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.009800]  [<ffffffff81669cac>] ret_from_fork+0x7c/0xb0
Dec 20 15:14:05 xanatos kernel: [   49.009807]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.009811] ---[ end trace 9806a4327f2ac459 ]---
Dec 20 15:14:05 xanatos kernel: [   49.009991] ------------[ cut here ]------------
Dec 20 15:14:05 xanatos kernel: [   49.009996] WARNING: CPU: 3 PID: 34 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
Dec 20 15:14:05 xanatos kernel: [   49.009998] sysfs group ffffffff81ca3240 not found for kobject '6:0:0:0'
Dec 20 15:14:05 xanatos kernel: [   49.009999] Modules linked in: nls_iso8859_1 uas usb_storage cuse dm_crypt uvcvideo x86_pkg_temp_thermal coretemp ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core videodev aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd arc4 snd_hda_codec_hdmi iwldvm mac80211 microcode psmouse snd_usb_audio thinkpad_acpi iwlwifi snd_usbmidi_lib snd_hda_codec_realtek nvram serio_raw snd_seq_midi snd_seq_midi_event snd_hda_intel snd_rawmidi joydev snd_seq snd_hda_codec cfg80211 snd_hwdep snd_pcm bnep rfcomm snd_page_alloc ehci_pci lpc_ich bluetooth ehci_hcd snd_seq_device snd_timer snd soundcore tpm_tis binfmt_misc btrfs libcrc32c xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper drm e1000e ahci sdhci_pci libahci sd
 hci ptp xhci_hcd pps_core video
Dec 20 15:14:05 xanatos kernel: [   49.010049] CPU: 3 PID: 34 Comm: khubd Tainted: G        W    3.13.0-rc1+ #153
Dec 20 15:14:05 xanatos kernel: [   49.010050] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Dec 20 15:14:05 xanatos kernel: [   49.010052]  0000000000000009 ffff8801179f9a40 ffffffff81658a4e ffff8801179f9a88
Dec 20 15:14:05 xanatos kernel: [   49.010056]  ffff8801179f9a78 ffffffff81048c3d 0000000000000000 ffffffff81ca3240
Dec 20 15:14:05 xanatos kernel: [   49.010059]  ffff88010ab481b0 ffff8800c36f6828 ffff8800c5674800 ffff8801179f9ad8
Dec 20 15:14:05 xanatos kernel: [   49.010062] Call Trace:
Dec 20 15:14:05 xanatos kernel: [   49.010065]  [<ffffffff81658a4e>] dump_stack+0x4d/0x66
Dec 20 15:14:05 xanatos kernel: [   49.010069]  [<ffffffff81048c3d>] warn_slowpath_common+0x7d/0xa0
Dec 20 15:14:05 xanatos kernel: [   49.010072]  [<ffffffff81048cac>] warn_slowpath_fmt+0x4c/0x50
Dec 20 15:14:05 xanatos kernel: [   49.010075]  [<ffffffff8165f6ce>] ? mutex_unlock+0xe/0x10
Dec 20 15:14:05 xanatos kernel: [   49.010078]  [<ffffffff81223550>] ? sysfs_get_dirent_ns+0x50/0x70
Dec 20 15:14:05 xanatos kernel: [   49.010082]  [<ffffffff81224896>] sysfs_remove_group+0xc6/0xd0
Dec 20 15:14:05 xanatos kernel: [   49.010085]  [<ffffffff81430483>] dpm_sysfs_remove+0x43/0x50
Dec 20 15:14:05 xanatos kernel: [   49.010088]  [<ffffffff81426235>] device_del+0x45/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.010092]  [<ffffffff8145c025>] __scsi_remove_device+0xd5/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.010095]  [<ffffffff8145a5af>] scsi_forget_host+0x6f/0x80
Dec 20 15:14:05 xanatos kernel: [   49.010099]  [<ffffffff8144ee96>] scsi_remove_host+0x76/0x130
Dec 20 15:14:05 xanatos kernel: [   49.010103]  [<ffffffffa05ab07d>] uas_disconnect+0x7d/0xa0 [uas]
Dec 20 15:14:05 xanatos kernel: [   49.010106]  [<ffffffff814b7287>] usb_unbind_interface+0x77/0x2b0
Dec 20 15:14:05 xanatos kernel: [   49.010109]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.010113]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.010116]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.010119]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.010122]  [<ffffffff814b4b90>] usb_disable_device+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.010125]  [<ffffffff814a92e5>] usb_disconnect+0xb5/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.010128]  [<ffffffff814ac526>] hub_thread+0x616/0x1710
Dec 20 15:14:05 xanatos kernel: [   49.010131]  [<ffffffff8109812d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Dec 20 15:14:05 xanatos kernel: [   49.010135]  [<ffffffff8108eb10>] ? prepare_to_wait_event+0x100/0x100
Dec 20 15:14:05 xanatos kernel: [   49.010138]  [<ffffffff814abf10>] ? usb_reset_device+0x1d0/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.010141]  [<ffffffff8106dc8c>] kthread+0xfc/0x120
Dec 20 15:14:05 xanatos kernel: [   49.010145]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.010148]  [<ffffffff81669cac>] ret_from_fork+0x7c/0xb0
Dec 20 15:14:05 xanatos kernel: [   49.010152]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.010154] ---[ end trace 9806a4327f2ac45a ]---
Dec 20 15:14:05 xanatos kernel: [   49.010177] ------------[ cut here ]------------
Dec 20 15:14:05 xanatos kernel: [   49.010181] WARNING: CPU: 3 PID: 34 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
Dec 20 15:14:05 xanatos kernel: [   49.010183] sysfs group ffffffff81ca3240 not found for kobject '6:0:0:0'
Dec 20 15:14:05 xanatos kernel: [   49.010184] Modules linked in: nls_iso8859_1 uas usb_storage cuse dm_crypt uvcvideo x86_pkg_temp_thermal coretemp ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core videodev aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd arc4 snd_hda_codec_hdmi iwldvm mac80211 microcode psmouse snd_usb_audio thinkpad_acpi iwlwifi snd_usbmidi_lib snd_hda_codec_realtek nvram serio_raw snd_seq_midi snd_seq_midi_event snd_hda_intel snd_rawmidi joydev snd_seq snd_hda_codec cfg80211 snd_hwdep snd_pcm bnep rfcomm snd_page_alloc ehci_pci lpc_ich bluetooth ehci_hcd snd_seq_device snd_timer snd soundcore tpm_tis binfmt_misc btrfs libcrc32c xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper drm e1000e ahci sdhci_pci libahci sd
 hci ptp xhci_hcd pps_core video
Dec 20 15:14:05 xanatos kernel: [   49.010238] CPU: 3 PID: 34 Comm: khubd Tainted: G        W    3.13.0-rc1+ #153
Dec 20 15:14:05 xanatos kernel: [   49.010240] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Dec 20 15:14:05 xanatos kernel: [   49.010241]  0000000000000009 ffff8801179f9978 ffffffff81658a4e ffff8801179f99c0
Dec 20 15:14:05 xanatos kernel: [   49.010245]  ffff8801179f99b0 ffffffff81048c3d 0000000000000000 ffffffff81ca3240
Dec 20 15:14:05 xanatos kernel: [   49.010249]  ffff8800c36f5020 ffff88010ab481a0 ffff8800c5674800 ffff8801179f9a10
Dec 20 15:14:05 xanatos kernel: [   49.010253] Call Trace:
Dec 20 15:14:05 xanatos kernel: [   49.010257]  [<ffffffff81658a4e>] dump_stack+0x4d/0x66
Dec 20 15:14:05 xanatos kernel: [   49.010260]  [<ffffffff81048c3d>] warn_slowpath_common+0x7d/0xa0
Dec 20 15:14:05 xanatos kernel: [   49.010263]  [<ffffffff81048cac>] warn_slowpath_fmt+0x4c/0x50
Dec 20 15:14:05 xanatos kernel: [   49.010266]  [<ffffffff8165f6ce>] ? mutex_unlock+0xe/0x10
Dec 20 15:14:05 xanatos kernel: [   49.010269]  [<ffffffff81223550>] ? sysfs_get_dirent_ns+0x50/0x70
Dec 20 15:14:05 xanatos kernel: [   49.010273]  [<ffffffff81224896>] sysfs_remove_group+0xc6/0xd0
Dec 20 15:14:05 xanatos kernel: [   49.010276]  [<ffffffff81430483>] dpm_sysfs_remove+0x43/0x50
Dec 20 15:14:05 xanatos kernel: [   49.010279]  [<ffffffff81426235>] device_del+0x45/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.010283]  [<ffffffff81463e5d>] sd_remove+0x6d/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.010286]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.010289]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.010293]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.010295]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.010299]  [<ffffffff8145c025>] __scsi_remove_device+0xd5/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.010302]  [<ffffffff8145a5af>] scsi_forget_host+0x6f/0x80
Dec 20 15:14:05 xanatos kernel: [   49.010306]  [<ffffffff8144ee96>] scsi_remove_host+0x76/0x130
Dec 20 15:14:05 xanatos kernel: [   49.010309]  [<ffffffffa05ab07d>] uas_disconnect+0x7d/0xa0 [uas]
Dec 20 15:14:05 xanatos kernel: [   49.010312]  [<ffffffff814b7287>] usb_unbind_interface+0x77/0x2b0
Dec 20 15:14:05 xanatos kernel: [   49.010316]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.010319]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.010322]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.010325]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.010328]  [<ffffffff814b4b90>] usb_disable_device+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.010331]  [<ffffffff814a92e5>] usb_disconnect+0xb5/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.010334]  [<ffffffff814ac526>] hub_thread+0x616/0x1710
Dec 20 15:14:05 xanatos kernel: [   49.010339]  [<ffffffff8109812d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Dec 20 15:14:05 xanatos kernel: [   49.010348]  [<ffffffff8108eb10>] ? prepare_to_wait_event+0x100/0x100
Dec 20 15:14:05 xanatos kernel: [   49.010356]  [<ffffffff814abf10>] ? usb_reset_device+0x1d0/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.010364]  [<ffffffff8106dc8c>] kthread+0xfc/0x120
Dec 20 15:14:05 xanatos kernel: [   49.010372]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.010381]  [<ffffffff81669cac>] ret_from_fork+0x7c/0xb0
Dec 20 15:14:05 xanatos kernel: [   49.010389]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.010393] ---[ end trace 9806a4327f2ac45b ]---
Dec 20 15:14:05 xanatos kernel: [   49.029886] ------------[ cut here ]------------
Dec 20 15:14:05 xanatos kernel: [   49.029896] WARNING: CPU: 3 PID: 34 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
Dec 20 15:14:05 xanatos kernel: [   49.029898] sysfs group ffffffff81ca3240 not found for kobject 'sdb4'
Dec 20 15:14:05 xanatos kernel: [   49.029900] Modules linked in: nls_iso8859_1 uas usb_storage cuse dm_crypt uvcvideo x86_pkg_temp_thermal coretemp ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core videodev aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd arc4 snd_hda_codec_hdmi iwldvm mac80211 microcode psmouse snd_usb_audio thinkpad_acpi iwlwifi snd_usbmidi_lib snd_hda_codec_realtek nvram serio_raw snd_seq_midi snd_seq_midi_event snd_hda_intel snd_rawmidi joydev snd_seq snd_hda_codec cfg80211 snd_hwdep snd_pcm bnep rfcomm snd_page_alloc ehci_pci lpc_ich bluetooth ehci_hcd snd_seq_device snd_timer snd soundcore tpm_tis binfmt_misc btrfs libcrc32c xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper drm e1000e ahci sdhci_pci libahci sd
 hci ptp xhci_hcd pps_core video
Dec 20 15:14:05 xanatos kernel: [   49.029962] CPU: 3 PID: 34 Comm: khubd Tainted: G        W    3.13.0-rc1+ #153
Dec 20 15:14:05 xanatos kernel: [   49.029965] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Dec 20 15:14:05 xanatos kernel: [   49.029968]  0000000000000009 ffff8801179f9920 ffffffff81658a4e ffff8801179f9968
Dec 20 15:14:05 xanatos kernel: [   49.029974]  ffff8801179f9958 ffffffff81048c3d 0000000000000000 ffffffff81ca3240
Dec 20 15:14:05 xanatos kernel: [   49.029978]  ffff8800c5670858 ffff8800c36f6090 ffff8800c5674800 ffff8801179f99b8
Dec 20 15:14:05 xanatos kernel: [   49.029982] Call Trace:
Dec 20 15:14:05 xanatos kernel: [   49.030010]  [<ffffffff81658a4e>] dump_stack+0x4d/0x66
Dec 20 15:14:05 xanatos kernel: [   49.030028]  [<ffffffff81048c3d>] warn_slowpath_common+0x7d/0xa0
Dec 20 15:14:05 xanatos kernel: [   49.030031]  [<ffffffff81048cac>] warn_slowpath_fmt+0x4c/0x50
Dec 20 15:14:05 xanatos kernel: [   49.030043]  [<ffffffff8165f6ce>] ? mutex_unlock+0xe/0x10
Dec 20 15:14:05 xanatos kernel: [   49.030049]  [<ffffffff81223550>] ? sysfs_get_dirent_ns+0x50/0x70
Dec 20 15:14:05 xanatos kernel: [   49.030052]  [<ffffffff81224896>] sysfs_remove_group+0xc6/0xd0
Dec 20 15:14:05 xanatos kernel: [   49.030066]  [<ffffffff81430483>] dpm_sysfs_remove+0x43/0x50
Dec 20 15:14:05 xanatos kernel: [   49.030081]  [<ffffffff81426235>] device_del+0x45/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.030100]  [<ffffffff8131dc88>] delete_partition+0x48/0x80
Dec 20 15:14:05 xanatos kernel: [   49.030105]  [<ffffffff8131c0a0>] del_gendisk+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.030123]  [<ffffffff81463e69>] sd_remove+0x79/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.030129]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.030132]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.030137]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.030140]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.030155]  [<ffffffff8145c025>] __scsi_remove_device+0xd5/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.030160]  [<ffffffff8145a5af>] scsi_forget_host+0x6f/0x80
Dec 20 15:14:05 xanatos kernel: [   49.030178]  [<ffffffff8144ee96>] scsi_remove_host+0x76/0x130
Dec 20 15:14:05 xanatos kernel: [   49.030190]  [<ffffffffa05ab07d>] uas_disconnect+0x7d/0xa0 [uas]
Dec 20 15:14:05 xanatos kernel: [   49.030205]  [<ffffffff814b7287>] usb_unbind_interface+0x77/0x2b0
Dec 20 15:14:05 xanatos kernel: [   49.030209]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.030212]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.030215]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.030218]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.030222]  [<ffffffff814b4b90>] usb_disable_device+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.030239]  [<ffffffff814a92e5>] usb_disconnect+0xb5/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.030243]  [<ffffffff814ac526>] hub_thread+0x616/0x1710
Dec 20 15:14:05 xanatos kernel: [   49.030251]  [<ffffffff8109812d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Dec 20 15:14:05 xanatos kernel: [   49.030265]  [<ffffffff8108eb10>] ? prepare_to_wait_event+0x100/0x100
Dec 20 15:14:05 xanatos kernel: [   49.030268]  [<ffffffff814abf10>] ? usb_reset_device+0x1d0/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.030284]  [<ffffffff8106dc8c>] kthread+0xfc/0x120
Dec 20 15:14:05 xanatos kernel: [   49.030288]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.030295]  [<ffffffff81669cac>] ret_from_fork+0x7c/0xb0
Dec 20 15:14:05 xanatos kernel: [   49.030298]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.030300] ---[ end trace 9806a4327f2ac45c ]---
Dec 20 15:14:05 xanatos kernel: [   49.030573] ------------[ cut here ]------------
Dec 20 15:14:05 xanatos kernel: [   49.030588] WARNING: CPU: 3 PID: 34 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
Dec 20 15:14:05 xanatos kernel: [   49.030589] sysfs group ffffffff81c548e0 not found for kobject 'sdb4'
Dec 20 15:14:05 xanatos kernel: [   49.030590] Modules linked in: nls_iso8859_1 uas usb_storage cuse dm_crypt uvcvideo x86_pkg_temp_thermal coretemp ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core videodev aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd arc4 snd_hda_codec_hdmi iwldvm mac80211 microcode psmouse snd_usb_audio thinkpad_acpi iwlwifi snd_usbmidi_lib snd_hda_codec_realtek nvram serio_raw snd_seq_midi snd_seq_midi_event snd_hda_intel snd_rawmidi joydev snd_seq snd_hda_codec cfg80211 snd_hwdep snd_pcm bnep rfcomm snd_page_alloc ehci_pci lpc_ich bluetooth ehci_hcd snd_seq_device snd_timer snd soundcore tpm_tis binfmt_misc btrfs libcrc32c xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper drm e1000e ahci sdhci_pci libahci sd
 hci ptp xhci_hcd pps_core video
Dec 20 15:14:05 xanatos kernel: [   49.030644] CPU: 3 PID: 34 Comm: khubd Tainted: G        W    3.13.0-rc1+ #153
Dec 20 15:14:05 xanatos kernel: [   49.030646] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Dec 20 15:14:05 xanatos kernel: [   49.030647]  0000000000000009 ffff8801179f98e0 ffffffff81658a4e ffff8801179f9928
Dec 20 15:14:05 xanatos kernel: [   49.030650]  ffff8801179f9918 ffffffff81048c3d 0000000000000000 ffffffff81c548e0
Dec 20 15:14:05 xanatos kernel: [   49.030653]  ffff8800c5670858 ffffffff81c89220 ffff8800c5674800 ffff8801179f9978
Dec 20 15:14:05 xanatos kernel: [   49.030658] Call Trace:
Dec 20 15:14:05 xanatos kernel: [   49.030663]  [<ffffffff81658a4e>] dump_stack+0x4d/0x66
Dec 20 15:14:05 xanatos kernel: [   49.030668]  [<ffffffff81048c3d>] warn_slowpath_common+0x7d/0xa0
Dec 20 15:14:05 xanatos kernel: [   49.030671]  [<ffffffff81048cac>] warn_slowpath_fmt+0x4c/0x50
Dec 20 15:14:05 xanatos kernel: [   49.030674]  [<ffffffff8165f6ce>] ? mutex_unlock+0xe/0x10
Dec 20 15:14:05 xanatos kernel: [   49.030682]  [<ffffffff81223550>] ? sysfs_get_dirent_ns+0x50/0x70
Dec 20 15:14:05 xanatos kernel: [   49.030686]  [<ffffffff81224896>] sysfs_remove_group+0xc6/0xd0
Dec 20 15:14:05 xanatos kernel: [   49.030690]  [<ffffffff81224973>] sysfs_remove_groups+0x33/0x50
Dec 20 15:14:05 xanatos kernel: [   49.030694]  [<ffffffff8142577e>] device_remove_attrs+0x5e/0x80
Dec 20 15:14:05 xanatos kernel: [   49.030697]  [<ffffffff8142631e>] device_del+0x12e/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.030700]  [<ffffffff8131dc88>] delete_partition+0x48/0x80
Dec 20 15:14:05 xanatos kernel: [   49.030703]  [<ffffffff8131c0a0>] del_gendisk+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.030716]  [<ffffffff81463e69>] sd_remove+0x79/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.030721]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.030724]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.030727]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.030729]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.030734]  [<ffffffff8145c025>] __scsi_remove_device+0xd5/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.030737]  [<ffffffff8145a5af>] scsi_forget_host+0x6f/0x80
Dec 20 15:14:05 xanatos kernel: [   49.030744]  [<ffffffff8144ee96>] scsi_remove_host+0x76/0x130
Dec 20 15:14:05 xanatos kernel: [   49.030749]  [<ffffffffa05ab07d>] uas_disconnect+0x7d/0xa0 [uas]
Dec 20 15:14:05 xanatos kernel: [   49.030754]  [<ffffffff814b7287>] usb_unbind_interface+0x77/0x2b0
Dec 20 15:14:05 xanatos kernel: [   49.030758]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.030762]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.030765]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.030767]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.030771]  [<ffffffff814b4b90>] usb_disable_device+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.030774]  [<ffffffff814a92e5>] usb_disconnect+0xb5/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.030776]  [<ffffffff814ac526>] hub_thread+0x616/0x1710
Dec 20 15:14:05 xanatos kernel: [   49.030779]  [<ffffffff8109812d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Dec 20 15:14:05 xanatos kernel: [   49.030783]  [<ffffffff8108eb10>] ? prepare_to_wait_event+0x100/0x100
Dec 20 15:14:05 xanatos kernel: [   49.030785]  [<ffffffff814abf10>] ? usb_reset_device+0x1d0/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.030789]  [<ffffffff8106dc8c>] kthread+0xfc/0x120
Dec 20 15:14:05 xanatos kernel: [   49.030793]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.030796]  [<ffffffff81669cac>] ret_from_fork+0x7c/0xb0
Dec 20 15:14:05 xanatos kernel: [   49.030799]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.030801] ---[ end trace 9806a4327f2ac45d ]---
Dec 20 15:14:05 xanatos kernel: [   49.031386] end_request: I/O error, dev sdb, sector 0
Dec 20 15:14:05 xanatos kernel: [   49.033277] ------------[ cut here ]------------
Dec 20 15:14:05 xanatos kernel: [   49.033287] WARNING: CPU: 0 PID: 34 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
Dec 20 15:14:05 xanatos kernel: [   49.033289] sysfs group ffffffff81ca3240 not found for kobject 'sdb2'
Dec 20 15:14:05 xanatos kernel: [   49.033290] Modules linked in: nls_iso8859_1 uas usb_storage cuse dm_crypt uvcvideo x86_pkg_temp_thermal coretemp ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core videodev aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd arc4 snd_hda_codec_hdmi iwldvm mac80211 microcode psmouse snd_usb_audio thinkpad_acpi iwlwifi snd_usbmidi_lib snd_hda_codec_realtek nvram serio_raw snd_seq_midi snd_seq_midi_event snd_hda_intel snd_rawmidi joydev snd_seq snd_hda_codec cfg80211 snd_hwdep snd_pcm bnep rfcomm snd_page_alloc ehci_pci lpc_ich bluetooth ehci_hcd snd_seq_device snd_timer snd soundcore tpm_tis binfmt_misc btrfs libcrc32c xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper drm e1000e ahci sdhci_pci libahci sd
 hci ptp xhci_hcd pps_core video
Dec 20 15:14:05 xanatos kernel: [   49.033355] CPU: 0 PID: 34 Comm: khubd Tainted: G        W    3.13.0-rc1+ #153
Dec 20 15:14:05 xanatos kernel: [   49.033357] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Dec 20 15:14:05 xanatos kernel: [   49.033359]  0000000000000009 ffff8801179f9920 ffffffff81658a4e ffff8801179f9968
Dec 20 15:14:05 xanatos kernel: [   49.033363]  ffff8801179f9958 ffffffff81048c3d 0000000000000000 ffffffff81ca3240
Dec 20 15:14:05 xanatos kernel: [   49.033366]  ffff8800c5672858 ffff8800c36f6090 ffff8800c5674800 ffff8801179f99b8
Dec 20 15:14:05 xanatos kernel: [   49.033371] Call Trace:
Dec 20 15:14:05 xanatos kernel: [   49.033376]  [<ffffffff81658a4e>] dump_stack+0x4d/0x66
Dec 20 15:14:05 xanatos kernel: [   49.033381]  [<ffffffff81048c3d>] warn_slowpath_common+0x7d/0xa0
Dec 20 15:14:05 xanatos kernel: [   49.033385]  [<ffffffff81048cac>] warn_slowpath_fmt+0x4c/0x50
Dec 20 15:14:05 xanatos kernel: [   49.033388]  [<ffffffff8165f6ce>] ? mutex_unlock+0xe/0x10
Dec 20 15:14:05 xanatos kernel: [   49.033391]  [<ffffffff81223550>] ? sysfs_get_dirent_ns+0x50/0x70
Dec 20 15:14:05 xanatos kernel: [   49.033394]  [<ffffffff81224896>] sysfs_remove_group+0xc6/0xd0
Dec 20 15:14:05 xanatos kernel: [   49.033399]  [<ffffffff81430483>] dpm_sysfs_remove+0x43/0x50
Dec 20 15:14:05 xanatos kernel: [   49.033402]  [<ffffffff81426235>] device_del+0x45/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.033407]  [<ffffffff8131dc88>] delete_partition+0x48/0x80
Dec 20 15:14:05 xanatos kernel: [   49.033410]  [<ffffffff8131c0a0>] del_gendisk+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.033414]  [<ffffffff81463e69>] sd_remove+0x79/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.033418]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.033421]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.033424]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.033426]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.033431]  [<ffffffff8145c025>] __scsi_remove_device+0xd5/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.033434]  [<ffffffff8145a5af>] scsi_forget_host+0x6f/0x80
Dec 20 15:14:05 xanatos kernel: [   49.033439]  [<ffffffff8144ee96>] scsi_remove_host+0x76/0x130
Dec 20 15:14:05 xanatos kernel: [   49.033443]  [<ffffffffa05ab07d>] uas_disconnect+0x7d/0xa0 [uas]
Dec 20 15:14:05 xanatos kernel: [   49.033447]  [<ffffffff814b7287>] usb_unbind_interface+0x77/0x2b0
Dec 20 15:14:05 xanatos kernel: [   49.033450]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.033453]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.033456]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.033459]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.033461]  [<ffffffff814b4b90>] usb_disable_device+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.033465]  [<ffffffff814a92e5>] usb_disconnect+0xb5/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.033469]  [<ffffffff814ac526>] hub_thread+0x616/0x1710
Dec 20 15:14:05 xanatos kernel: [   49.033472]  [<ffffffff8109812d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Dec 20 15:14:05 xanatos kernel: [   49.033476]  [<ffffffff8108eb10>] ? prepare_to_wait_event+0x100/0x100
Dec 20 15:14:05 xanatos kernel: [   49.033479]  [<ffffffff814abf10>] ? usb_reset_device+0x1d0/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.033483]  [<ffffffff8106dc8c>] kthread+0xfc/0x120
Dec 20 15:14:05 xanatos kernel: [   49.033487]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.033490]  [<ffffffff81669cac>] ret_from_fork+0x7c/0xb0
Dec 20 15:14:05 xanatos kernel: [   49.033494]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.033497] ---[ end trace 9806a4327f2ac45e ]---
Dec 20 15:14:05 xanatos kernel: [   49.033626] ------------[ cut here ]------------
Dec 20 15:14:05 xanatos kernel: [   49.033630] WARNING: CPU: 0 PID: 34 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
Dec 20 15:14:05 xanatos kernel: [   49.033632] sysfs group ffffffff81c548e0 not found for kobject 'sdb2'
Dec 20 15:14:05 xanatos kernel: [   49.033634] Modules linked in: nls_iso8859_1 uas usb_storage cuse dm_crypt uvcvideo x86_pkg_temp_thermal coretemp ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core videodev aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd arc4 snd_hda_codec_hdmi iwldvm mac80211 microcode psmouse snd_usb_audio thinkpad_acpi iwlwifi snd_usbmidi_lib snd_hda_codec_realtek nvram serio_raw snd_seq_midi snd_seq_midi_event snd_hda_intel snd_rawmidi joydev snd_seq snd_hda_codec cfg80211 snd_hwdep snd_pcm bnep rfcomm snd_page_alloc ehci_pci lpc_ich bluetooth ehci_hcd snd_seq_device snd_timer snd soundcore tpm_tis binfmt_misc btrfs libcrc32c xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper drm e1000e ahci sdhci_pci libahci sd
 hci ptp xhci_hcd pps_core video
Dec 20 15:14:05 xanatos kernel: [   49.033690] CPU: 0 PID: 34 Comm: khubd Tainted: G        W    3.13.0-rc1+ #153
Dec 20 15:14:05 xanatos kernel: [   49.033691] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Dec 20 15:14:05 xanatos kernel: [   49.033693]  0000000000000009 ffff8801179f98e0 ffffffff81658a4e ffff8801179f9928
Dec 20 15:14:05 xanatos kernel: [   49.033697]  ffff8801179f9918 ffffffff81048c3d 0000000000000000 ffffffff81c548e0
Dec 20 15:14:05 xanatos kernel: [   49.033701]  ffff8800c5672858 ffffffff81c89220 ffff8800c5674800 ffff8801179f9978
Dec 20 15:14:05 xanatos kernel: [   49.033705] Call Trace:
Dec 20 15:14:05 xanatos kernel: [   49.033709]  [<ffffffff81658a4e>] dump_stack+0x4d/0x66
Dec 20 15:14:05 xanatos kernel: [   49.033713]  [<ffffffff81048c3d>] warn_slowpath_common+0x7d/0xa0
Dec 20 15:14:05 xanatos kernel: [   49.033716]  [<ffffffff81048cac>] warn_slowpath_fmt+0x4c/0x50
Dec 20 15:14:05 xanatos kernel: [   49.033720]  [<ffffffff8165f6ce>] ? mutex_unlock+0xe/0x10
Dec 20 15:14:05 xanatos kernel: [   49.033723]  [<ffffffff81223550>] ? sysfs_get_dirent_ns+0x50/0x70
Dec 20 15:14:05 xanatos kernel: [   49.033726]  [<ffffffff81224896>] sysfs_remove_group+0xc6/0xd0
Dec 20 15:14:05 xanatos kernel: [   49.033730]  [<ffffffff81224973>] sysfs_remove_groups+0x33/0x50
Dec 20 15:14:05 xanatos kernel: [   49.033733]  [<ffffffff8142577e>] device_remove_attrs+0x5e/0x80
Dec 20 15:14:05 xanatos kernel: [   49.033736]  [<ffffffff8142631e>] device_del+0x12e/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.033740]  [<ffffffff8131dc88>] delete_partition+0x48/0x80
Dec 20 15:14:05 xanatos kernel: [   49.033744]  [<ffffffff8131c0a0>] del_gendisk+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.033748]  [<ffffffff81463e69>] sd_remove+0x79/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.033751]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.033755]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.033758]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.033762]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.033765]  [<ffffffff8145c025>] __scsi_remove_device+0xd5/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.033769]  [<ffffffff8145a5af>] scsi_forget_host+0x6f/0x80
Dec 20 15:14:05 xanatos kernel: [   49.033772]  [<ffffffff8144ee96>] scsi_remove_host+0x76/0x130
Dec 20 15:14:05 xanatos kernel: [   49.033776]  [<ffffffffa05ab07d>] uas_disconnect+0x7d/0xa0 [uas]
Dec 20 15:14:05 xanatos kernel: [   49.033780]  [<ffffffff814b7287>] usb_unbind_interface+0x77/0x2b0
Dec 20 15:14:05 xanatos kernel: [   49.033783]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.033787]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.033790]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.033793]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.033796]  [<ffffffff814b4b90>] usb_disable_device+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.033800]  [<ffffffff814a92e5>] usb_disconnect+0xb5/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.033803]  [<ffffffff814ac526>] hub_thread+0x616/0x1710
Dec 20 15:14:05 xanatos kernel: [   49.033806]  [<ffffffff8109812d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Dec 20 15:14:05 xanatos kernel: [   49.033810]  [<ffffffff8108eb10>] ? prepare_to_wait_event+0x100/0x100
Dec 20 15:14:05 xanatos kernel: [   49.033813]  [<ffffffff814abf10>] ? usb_reset_device+0x1d0/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.033817]  [<ffffffff8106dc8c>] kthread+0xfc/0x120
Dec 20 15:14:05 xanatos kernel: [   49.033821]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.033825]  [<ffffffff81669cac>] ret_from_fork+0x7c/0xb0
Dec 20 15:14:05 xanatos kernel: [   49.033828]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.033830] ---[ end trace 9806a4327f2ac45f ]---
Dec 20 15:14:05 xanatos kernel: [   49.036741] ------------[ cut here ]------------
Dec 20 15:14:05 xanatos kernel: [   49.036751] WARNING: CPU: 0 PID: 34 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
Dec 20 15:14:05 xanatos kernel: [   49.036754] sysfs group ffffffff81ca3240 not found for kobject 'sdb1'
Dec 20 15:14:05 xanatos kernel: [   49.036755] Modules linked in: nls_iso8859_1 uas usb_storage cuse dm_crypt uvcvideo x86_pkg_temp_thermal coretemp ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core videodev aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd arc4 snd_hda_codec_hdmi iwldvm mac80211 microcode psmouse snd_usb_audio thinkpad_acpi iwlwifi snd_usbmidi_lib snd_hda_codec_realtek nvram serio_raw snd_seq_midi snd_seq_midi_event snd_hda_intel snd_rawmidi joydev snd_seq snd_hda_codec cfg80211 snd_hwdep snd_pcm bnep rfcomm snd_page_alloc ehci_pci lpc_ich bluetooth ehci_hcd snd_seq_device snd_timer snd soundcore tpm_tis binfmt_misc btrfs libcrc32c xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper drm e1000e ahci sdhci_pci libahci sd
 hci ptp xhci_hcd pps_core video
Dec 20 15:14:05 xanatos kernel: [   49.036820] CPU: 0 PID: 34 Comm: khubd Tainted: G        W    3.13.0-rc1+ #153
Dec 20 15:14:05 xanatos kernel: [   49.036822] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Dec 20 15:14:05 xanatos kernel: [   49.036824]  0000000000000009 ffff8801179f9920 ffffffff81658a4e ffff8801179f9968
Dec 20 15:14:05 xanatos kernel: [   49.036829]  ffff8801179f9958 ffffffff81048c3d 0000000000000000 ffffffff81ca3240
Dec 20 15:14:05 xanatos kernel: [   49.036833]  ffff8800c5673058 ffff8800c36f6090 ffff8800c5674800 ffff8801179f99b8
Dec 20 15:14:05 xanatos kernel: [   49.036837] Call Trace:
Dec 20 15:14:05 xanatos kernel: [   49.036842]  [<ffffffff81658a4e>] dump_stack+0x4d/0x66
Dec 20 15:14:05 xanatos kernel: [   49.036848]  [<ffffffff81048c3d>] warn_slowpath_common+0x7d/0xa0
Dec 20 15:14:05 xanatos kernel: [   49.036851]  [<ffffffff81048cac>] warn_slowpath_fmt+0x4c/0x50
Dec 20 15:14:05 xanatos kernel: [   49.036855]  [<ffffffff8165f6ce>] ? mutex_unlock+0xe/0x10
Dec 20 15:14:05 xanatos kernel: [   49.036859]  [<ffffffff81223550>] ? sysfs_get_dirent_ns+0x50/0x70
Dec 20 15:14:05 xanatos kernel: [   49.036862]  [<ffffffff81224896>] sysfs_remove_group+0xc6/0xd0
Dec 20 15:14:05 xanatos kernel: [   49.036867]  [<ffffffff81430483>] dpm_sysfs_remove+0x43/0x50
Dec 20 15:14:05 xanatos kernel: [   49.036871]  [<ffffffff81426235>] device_del+0x45/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.036875]  [<ffffffff8131dc88>] delete_partition+0x48/0x80
Dec 20 15:14:05 xanatos kernel: [   49.036879]  [<ffffffff8131c0a0>] del_gendisk+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.036884]  [<ffffffff81463e69>] sd_remove+0x79/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.036888]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.036892]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.036895]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.036898]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.036926]  [<ffffffff8145c025>] __scsi_remove_device+0xd5/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.036930]  [<ffffffff8145a5af>] scsi_forget_host+0x6f/0x80
Dec 20 15:14:05 xanatos kernel: [   49.036935]  [<ffffffff8144ee96>] scsi_remove_host+0x76/0x130
Dec 20 15:14:05 xanatos kernel: [   49.036940]  [<ffffffffa05ab07d>] uas_disconnect+0x7d/0xa0 [uas]
Dec 20 15:14:05 xanatos kernel: [   49.036943]  [<ffffffff814b7287>] usb_unbind_interface+0x77/0x2b0
Dec 20 15:14:05 xanatos kernel: [   49.036947]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.036950]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.036953]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.036955]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.036958]  [<ffffffff814b4b90>] usb_disable_device+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.036962]  [<ffffffff814a92e5>] usb_disconnect+0xb5/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.036965]  [<ffffffff814ac526>] hub_thread+0x616/0x1710
Dec 20 15:14:05 xanatos kernel: [   49.036969]  [<ffffffff8109812d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Dec 20 15:14:05 xanatos kernel: [   49.036973]  [<ffffffff8108eb10>] ? prepare_to_wait_event+0x100/0x100
Dec 20 15:14:05 xanatos kernel: [   49.036976]  [<ffffffff814abf10>] ? usb_reset_device+0x1d0/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.036980]  [<ffffffff8106dc8c>] kthread+0xfc/0x120
Dec 20 15:14:05 xanatos kernel: [   49.036984]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.036987]  [<ffffffff81669cac>] ret_from_fork+0x7c/0xb0
Dec 20 15:14:05 xanatos kernel: [   49.036991]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.036993] ---[ end trace 9806a4327f2ac460 ]---
Dec 20 15:14:05 xanatos kernel: [   49.037757] ------------[ cut here ]------------
Dec 20 15:14:05 xanatos kernel: [   49.037763] WARNING: CPU: 0 PID: 34 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
Dec 20 15:14:05 xanatos kernel: [   49.037765] sysfs group ffffffff81c548e0 not found for kobject 'sdb1'
Dec 20 15:14:05 xanatos kernel: [   49.037767] Modules linked in: nls_iso8859_1 uas usb_storage cuse dm_crypt uvcvideo x86_pkg_temp_thermal coretemp ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core videodev aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd arc4 snd_hda_codec_hdmi iwldvm mac80211 microcode psmouse snd_usb_audio thinkpad_acpi iwlwifi snd_usbmidi_lib snd_hda_codec_realtek nvram serio_raw snd_seq_midi snd_seq_midi_event snd_hda_intel snd_rawmidi joydev snd_seq snd_hda_codec cfg80211 snd_hwdep snd_pcm bnep rfcomm snd_page_alloc ehci_pci lpc_ich bluetooth ehci_hcd snd_seq_device snd_timer snd soundcore tpm_tis binfmt_misc btrfs libcrc32c xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper drm e1000e ahci sdhci_pci libahci sd
 hci ptp xhci_hcd pps_core video
Dec 20 15:14:05 xanatos kernel: [   49.037829] CPU: 0 PID: 34 Comm: khubd Tainted: G        W    3.13.0-rc1+ #153
Dec 20 15:14:05 xanatos kernel: [   49.037831] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Dec 20 15:14:05 xanatos kernel: [   49.037832]  0000000000000009 ffff8801179f98e0 ffffffff81658a4e ffff8801179f9928
Dec 20 15:14:05 xanatos kernel: [   49.037837]  ffff8801179f9918 ffffffff81048c3d 0000000000000000 ffffffff81c548e0
Dec 20 15:14:05 xanatos kernel: [   49.037842]  ffff8800c5673058 ffffffff81c89220 ffff8800c5674800 ffff8801179f9978
Dec 20 15:14:05 xanatos kernel: [   49.037846] Call Trace:
Dec 20 15:14:05 xanatos kernel: [   49.037851]  [<ffffffff81658a4e>] dump_stack+0x4d/0x66
Dec 20 15:14:05 xanatos kernel: [   49.037856]  [<ffffffff81048c3d>] warn_slowpath_common+0x7d/0xa0
Dec 20 15:14:05 xanatos kernel: [   49.037860]  [<ffffffff81048cac>] warn_slowpath_fmt+0x4c/0x50
Dec 20 15:14:05 xanatos kernel: [   49.037863]  [<ffffffff8165f6ce>] ? mutex_unlock+0xe/0x10
Dec 20 15:14:05 xanatos kernel: [   49.037867]  [<ffffffff81223550>] ? sysfs_get_dirent_ns+0x50/0x70
Dec 20 15:14:05 xanatos kernel: [   49.037870]  [<ffffffff81224896>] sysfs_remove_group+0xc6/0xd0
Dec 20 15:14:05 xanatos kernel: [   49.037874]  [<ffffffff81224973>] sysfs_remove_groups+0x33/0x50
Dec 20 15:14:05 xanatos kernel: [   49.037878]  [<ffffffff8142577e>] device_remove_attrs+0x5e/0x80
Dec 20 15:14:05 xanatos kernel: [   49.037881]  [<ffffffff8142631e>] device_del+0x12e/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.037886]  [<ffffffff8131dc88>] delete_partition+0x48/0x80
Dec 20 15:14:05 xanatos kernel: [   49.037890]  [<ffffffff8131c0a0>] del_gendisk+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.037894]  [<ffffffff81463e69>] sd_remove+0x79/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.037898]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.037901]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.037905]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.037908]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.037913]  [<ffffffff8145c025>] __scsi_remove_device+0xd5/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.037916]  [<ffffffff8145a5af>] scsi_forget_host+0x6f/0x80
Dec 20 15:14:05 xanatos kernel: [   49.037921]  [<ffffffff8144ee96>] scsi_remove_host+0x76/0x130
Dec 20 15:14:05 xanatos kernel: [   49.037925]  [<ffffffffa05ab07d>] uas_disconnect+0x7d/0xa0 [uas]
Dec 20 15:14:05 xanatos kernel: [   49.037929]  [<ffffffff814b7287>] usb_unbind_interface+0x77/0x2b0
Dec 20 15:14:05 xanatos kernel: [   49.037933]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.037936]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.037940]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.037943]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.037946]  [<ffffffff814b4b90>] usb_disable_device+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.037949]  [<ffffffff814a92e5>] usb_disconnect+0xb5/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.037953]  [<ffffffff814ac526>] hub_thread+0x616/0x1710
Dec 20 15:14:05 xanatos kernel: [   49.037956]  [<ffffffff8109812d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Dec 20 15:14:05 xanatos kernel: [   49.037960]  [<ffffffff8108eb10>] ? prepare_to_wait_event+0x100/0x100
Dec 20 15:14:05 xanatos kernel: [   49.037964]  [<ffffffff814abf10>] ? usb_reset_device+0x1d0/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.037968]  [<ffffffff8106dc8c>] kthread+0xfc/0x120
Dec 20 15:14:05 xanatos kernel: [   49.037972]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.037976]  [<ffffffff81669cac>] ret_from_fork+0x7c/0xb0
Dec 20 15:14:05 xanatos kernel: [   49.037980]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.037982] ---[ end trace 9806a4327f2ac461 ]---
Dec 20 15:14:05 xanatos kernel: [   49.043545] ------------[ cut here ]------------
Dec 20 15:14:05 xanatos kernel: [   49.043555] WARNING: CPU: 0 PID: 34 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
Dec 20 15:14:05 xanatos kernel: [   49.043557] sysfs group ffffffff81c548e0 not found for kobject 'sdb'
Dec 20 15:14:05 xanatos kernel: [   49.043559] Modules linked in: nls_iso8859_1 uas usb_storage cuse dm_crypt uvcvideo x86_pkg_temp_thermal coretemp ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core videodev aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd arc4 snd_hda_codec_hdmi iwldvm mac80211 microcode psmouse snd_usb_audio thinkpad_acpi iwlwifi snd_usbmidi_lib snd_hda_codec_realtek nvram serio_raw snd_seq_midi snd_seq_midi_event snd_hda_intel snd_rawmidi joydev snd_seq snd_hda_codec cfg80211 snd_hwdep snd_pcm bnep rfcomm snd_page_alloc ehci_pci lpc_ich bluetooth ehci_hcd snd_seq_device snd_timer snd soundcore tpm_tis binfmt_misc btrfs libcrc32c xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper drm e1000e ahci sdhci_pci libahci sd
 hci ptp xhci_hcd pps_core video
Dec 20 15:14:05 xanatos kernel: [   49.043621] CPU: 0 PID: 34 Comm: khubd Tainted: G        W    3.13.0-rc1+ #153
Dec 20 15:14:05 xanatos kernel: [   49.043623] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Dec 20 15:14:05 xanatos kernel: [   49.043625]  0000000000000009 ffff8801179f9950 ffffffff81658a4e ffff8801179f9998
Dec 20 15:14:05 xanatos kernel: [   49.043629]  ffff8801179f9988 ffffffff81048c3d 0000000000000000 ffffffff81c548e0
Dec 20 15:14:05 xanatos kernel: [   49.043633]  ffff8800c36f60a0 0000000000800010 ffff8800c5674800 ffff8801179f99e8
Dec 20 15:14:05 xanatos kernel: [   49.043637] Call Trace:
Dec 20 15:14:05 xanatos kernel: [   49.043643]  [<ffffffff81658a4e>] dump_stack+0x4d/0x66
Dec 20 15:14:05 xanatos kernel: [   49.043648]  [<ffffffff81048c3d>] warn_slowpath_common+0x7d/0xa0
Dec 20 15:14:05 xanatos kernel: [   49.043651]  [<ffffffff81048cac>] warn_slowpath_fmt+0x4c/0x50
Dec 20 15:14:05 xanatos kernel: [   49.043655]  [<ffffffff8165f6ce>] ? mutex_unlock+0xe/0x10
Dec 20 15:14:05 xanatos kernel: [   49.043658]  [<ffffffff81223550>] ? sysfs_get_dirent_ns+0x50/0x70
Dec 20 15:14:05 xanatos kernel: [   49.043662]  [<ffffffff81224896>] sysfs_remove_group+0xc6/0xd0
Dec 20 15:14:05 xanatos kernel: [   49.043666]  [<ffffffff81119c54>] blk_trace_remove_sysfs+0x14/0x20
Dec 20 15:14:05 xanatos kernel: [   49.043670]  [<ffffffff813103a8>] blk_unregister_queue+0x68/0x90
Dec 20 15:14:05 xanatos kernel: [   49.043674]  [<ffffffff8131c111>] del_gendisk+0x121/0x290
Dec 20 15:14:05 xanatos kernel: [   49.043678]  [<ffffffff81463e69>] sd_remove+0x79/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.043682]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.043685]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.043688]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.043691]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.043695]  [<ffffffff8145c025>] __scsi_remove_device+0xd5/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.043698]  [<ffffffff8145a5af>] scsi_forget_host+0x6f/0x80
Dec 20 15:14:05 xanatos kernel: [   49.043702]  [<ffffffff8144ee96>] scsi_remove_host+0x76/0x130
Dec 20 15:14:05 xanatos kernel: [   49.043707]  [<ffffffffa05ab07d>] uas_disconnect+0x7d/0xa0 [uas]
Dec 20 15:14:05 xanatos kernel: [   49.043710]  [<ffffffff814b7287>] usb_unbind_interface+0x77/0x2b0
Dec 20 15:14:05 xanatos kernel: [   49.043713]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.043717]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.043720]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.043722]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.043725]  [<ffffffff814b4b90>] usb_disable_device+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.043729]  [<ffffffff814a92e5>] usb_disconnect+0xb5/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.043732]  [<ffffffff814ac526>] hub_thread+0x616/0x1710
Dec 20 15:14:05 xanatos kernel: [   49.043735]  [<ffffffff8109812d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Dec 20 15:14:05 xanatos kernel: [   49.043739]  [<ffffffff8108eb10>] ? prepare_to_wait_event+0x100/0x100
Dec 20 15:14:05 xanatos kernel: [   49.043742]  [<ffffffff814abf10>] ? usb_reset_device+0x1d0/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.043746]  [<ffffffff8106dc8c>] kthread+0xfc/0x120
Dec 20 15:14:05 xanatos kernel: [   49.043750]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.043754]  [<ffffffff81669cac>] ret_from_fork+0x7c/0xb0
Dec 20 15:14:05 xanatos kernel: [   49.043757]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.043760] ---[ end trace 9806a4327f2ac462 ]---
Dec 20 15:14:05 xanatos kernel: [   49.043789] ------------[ cut here ]------------
Dec 20 15:14:05 xanatos kernel: [   49.043793] WARNING: CPU: 0 PID: 34 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
Dec 20 15:14:05 xanatos kernel: [   49.043794] sysfs group ffffffff81ca3240 not found for kobject 'sdb'
Dec 20 15:14:05 xanatos kernel: [   49.043795] Modules linked in: nls_iso8859_1 uas usb_storage cuse dm_crypt uvcvideo x86_pkg_temp_thermal coretemp ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core videodev aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd arc4 snd_hda_codec_hdmi iwldvm mac80211 microcode psmouse snd_usb_audio thinkpad_acpi iwlwifi snd_usbmidi_lib snd_hda_codec_realtek nvram serio_raw snd_seq_midi snd_seq_midi_event snd_hda_intel snd_rawmidi joydev snd_seq snd_hda_codec cfg80211 snd_hwdep snd_pcm bnep rfcomm snd_page_alloc ehci_pci lpc_ich bluetooth ehci_hcd snd_seq_device snd_timer snd soundcore tpm_tis binfmt_misc btrfs libcrc32c xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper drm e1000e ahci sdhci_pci libahci sd
 hci ptp xhci_hcd pps_core video
Dec 20 15:14:05 xanatos kernel: [   49.043852] CPU: 0 PID: 34 Comm: khubd Tainted: G        W    3.13.0-rc1+ #153
Dec 20 15:14:05 xanatos kernel: [   49.043854] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Dec 20 15:14:05 xanatos kernel: [   49.043855]  0000000000000009 ffff8801179f9938 ffffffff81658a4e ffff8801179f9980
Dec 20 15:14:05 xanatos kernel: [   49.043859]  ffff8801179f9970 ffffffff81048c3d 0000000000000000 ffffffff81ca3240
Dec 20 15:14:05 xanatos kernel: [   49.043863]  ffff8800c36f60a0 ffff88010ab481a0 ffff8800c5674800 ffff8801179f99d0
Dec 20 15:14:05 xanatos kernel: [   49.043866] Call Trace:
Dec 20 15:14:05 xanatos kernel: [   49.043871]  [<ffffffff81658a4e>] dump_stack+0x4d/0x66
Dec 20 15:14:05 xanatos kernel: [   49.043875]  [<ffffffff81048c3d>] warn_slowpath_common+0x7d/0xa0
Dec 20 15:14:05 xanatos kernel: [   49.043878]  [<ffffffff81048cac>] warn_slowpath_fmt+0x4c/0x50
Dec 20 15:14:05 xanatos kernel: [   49.043882]  [<ffffffff8165f6ce>] ? mutex_unlock+0xe/0x10
Dec 20 15:14:05 xanatos kernel: [   49.043885]  [<ffffffff81223550>] ? sysfs_get_dirent_ns+0x50/0x70
Dec 20 15:14:05 xanatos kernel: [   49.043888]  [<ffffffff81224896>] sysfs_remove_group+0xc6/0xd0
Dec 20 15:14:05 xanatos kernel: [   49.043892]  [<ffffffff81430483>] dpm_sysfs_remove+0x43/0x50
Dec 20 15:14:05 xanatos kernel: [   49.043895]  [<ffffffff81426235>] device_del+0x45/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.043900]  [<ffffffff8131c24f>] del_gendisk+0x25f/0x290
Dec 20 15:14:05 xanatos kernel: [   49.043904]  [<ffffffff81463e69>] sd_remove+0x79/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.043907]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.043910]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.043914]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.043916]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.043920]  [<ffffffff8145c025>] __scsi_remove_device+0xd5/0xe0
Dec 20 15:14:05 xanatos kernel: [   49.043923]  [<ffffffff8145a5af>] scsi_forget_host+0x6f/0x80
Dec 20 15:14:05 xanatos kernel: [   49.043928]  [<ffffffff8144ee96>] scsi_remove_host+0x76/0x130
Dec 20 15:14:05 xanatos kernel: [   49.043931]  [<ffffffffa05ab07d>] uas_disconnect+0x7d/0xa0 [uas]
Dec 20 15:14:05 xanatos kernel: [   49.043935]  [<ffffffff814b7287>] usb_unbind_interface+0x77/0x2b0
Dec 20 15:14:05 xanatos kernel: [   49.043938]  [<ffffffff8142a03f>] __device_release_driver+0x7f/0xf0
Dec 20 15:14:05 xanatos kernel: [   49.043942]  [<ffffffff8142a0d5>] device_release_driver+0x25/0x40
Dec 20 15:14:05 xanatos kernel: [   49.043945]  [<ffffffff8142993c>] bus_remove_device+0x11c/0x1a0
Dec 20 15:14:05 xanatos kernel: [   49.043948]  [<ffffffff81426326>] device_del+0x136/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.043951]  [<ffffffff814b4b90>] usb_disable_device+0xb0/0x290
Dec 20 15:14:05 xanatos kernel: [   49.043955]  [<ffffffff814a92e5>] usb_disconnect+0xb5/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.043958]  [<ffffffff814ac526>] hub_thread+0x616/0x1710
Dec 20 15:14:05 xanatos kernel: [   49.043961]  [<ffffffff8109812d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Dec 20 15:14:05 xanatos kernel: [   49.043965]  [<ffffffff8108eb10>] ? prepare_to_wait_event+0x100/0x100
Dec 20 15:14:05 xanatos kernel: [   49.043968]  [<ffffffff814abf10>] ? usb_reset_device+0x1d0/0x1d0
Dec 20 15:14:05 xanatos kernel: [   49.043972]  [<ffffffff8106dc8c>] kthread+0xfc/0x120
Dec 20 15:14:05 xanatos kernel: [   49.043976]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.043980]  [<ffffffff81669cac>] ret_from_fork+0x7c/0xb0
Dec 20 15:14:05 xanatos kernel: [   49.043983]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
Dec 20 15:14:05 xanatos kernel: [   49.043985] ---[ end trace 9806a4327f2ac463 ]---
Dec 20 15:14:05 xanatos kernel: [   49.044151] sd 6:0:0:0: [sdb] Synchronizing SCSI cache
Dec 20 15:14:05 xanatos kernel: [   49.069556] EXT3-fs (sdb1): I/O error while writing superblock
Dec 20 15:14:05 xanatos kernel: [   49.113015] end_request: I/O error, dev sdb, sector 0
Dec 20 15:14:05 xanatos kernel: [   49.113424] JBD2: Error -5 detected when updating journal superblock for sdb2-8.
Dec 20 15:14:05 xanatos kernel: [   49.149033] sd 6:0:0:0: [sdb]  
Dec 20 15:14:05 xanatos kernel: [   49.149038] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
Dec 20 15:14:05 xanatos kernel: [   49.149884] usb 2-2: usb_set_device_initiated_lpm: Can't enable U1 state for unconfigured device.
Dec 20 15:14:05 xanatos kernel: [   49.149943] usb 2-2: usb_set_device_initiated_lpm: Can't enable U2 state for unconfigured device.
Dec 20 15:14:05 xanatos kernel: [   49.150028] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
Dec 20 15:14:05 xanatos kernel: [   49.150059] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
Dec 20 15:14:05 xanatos kernel: [   49.150082] usb 2-2: usb_disable_device nuking all URBs
Dec 20 15:14:05 xanatos kernel: [   49.279627] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x2a0
Dec 20 15:14:05 xanatos kernel: [   49.279635] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
Dec 20 15:14:05 xanatos kernel: [   49.279784] hub 2-0:1.0: hub_suspend
Dec 20 15:14:05 xanatos kernel: [   49.279795] usb usb2: bus auto-suspend, wakeup 1

Sarah Sharp
