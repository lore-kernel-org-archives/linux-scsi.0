From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: BTRFS doesn't handle USB device disconnect
Date: Tue, 10 Dec 2013 17:17:55 -0800
Message-ID: <20131211011755.GA3574@xanatos>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab3LKBSD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 20:18:03 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-usb@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, linux-scsi@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In order to stress test the uas driver (next-gen USB storage driver), I
decided to run some tests with a USB 3.0 storage device with four 10GB
partitions: BTRFS, ext3, ext4, and fat32.

It seems that BTRFS doesn't handle unexpected USB disconnect very well.
Is that expected behavior?

The BTRFS partition was created on an Ubuntu 13.10 system, with
btrfs-tools version 0.19+20130705-1.

On 3.12-rc6, if all partitions are mounted, and I yank the USB cable,
the BTRFS filesystem still shows up as mounted.  If I yank it multiple
times, sometimes it's listed twice when the device is disconnected:

/dev/sdb3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e4 type btrfs (rw,nosuid,nodev,uhelper=udisks2)
/dev/sdc3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e41 type btrfs (rw,nosuid,nodev,uhelper=udisks2)

Sometimes (but not always) when I plug it back in, I can get /dev/sdc3
listed twice:

/dev/sdb3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e4 type btrfs (rw,nosuid,nodev,uhelper=udisks2)
/dev/sdc3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e42 type btrfs (rw,nosuid,nodev,uhelper=udisks2)
/dev/sdc1 on /media/sarah/ext3-part type ext3 (rw,nosuid,nodev,uhelper=udisks2)
/dev/sdc2 on /media/sarah/ext4-part type ext4 (rw,nosuid,nodev,uhelper=udisks2)
/dev/sdc4 on /media/sarah/fat32-part type vfat (rw,nosuid,nodev,uid=1000,gid=1000,shortname=mixed,dmask=0077,utf8=1,showexec,flush,uhelper=udisks2)
/dev/sdc3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e41 type btrfs (rw,nosuid,nodev,uhelper=udisks2)

On 3.13-rc1, the btrfs partion from the disconnected USB device
continues to be listed as mounted.  Yanking the cable produces some
additional oops messages.  It also produced a couple hard-hangs.
Unfortunately, I didn't capture the dmesg during the hard-hangs, so I
can't tell for sure which driver is to blame (uas, btrfs, or xhci).

dmesg from 3.12-rc6 and 3.13-rc1 is attached.

Sarah Sharp

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="log2-3.13-rc1.txt"

[   74.480119] netpoll: netconsole: local port 6665
[   74.480125] netpoll: netconsole: local IPv4 address 0.0.0.0
[   74.480127] netpoll: netconsole: interface 'eth1'
[   74.480129] netpoll: netconsole: remote port 6666
[   74.480132] netpoll: netconsole: remote IPv4 address 10.7.201.41
[   74.480135] netpoll: netconsole: remote ethernet address 00:05:1b:72:1f:e1
[   74.480139] netpoll: netconsole: local IP 10.7.201.20
[   74.480997] console [netcon0] enabled
[   74.481019] netconsole: network logging started
[  106.438283] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  106.438658] hub 2-0:1.0: warm reset port 2
[  106.491949] hub 2-0:1.0: port 2 not warm reset yet, waiting 50ms
[  106.548723] hub 2-0:1.0: port 2, status 02c0, change 0041, 5.0 Gb/s
[  106.548775] usb 2-2: USB disconnect, device number 2
[  106.548807] usb 2-2: unregistering device
[  106.548854] usb 2-2: unregistering interface 2-2:1.0
[  106.549205] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[  106.549341] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  106.551745] sd 6:0:0:0: [sdb] Synchronizing SCSI cache
[  106.672014] sd 6:0:0:0: [sdb]  
[  106.672064] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[  106.673165] usb 2-2: usb_set_device_initiated_lpm: Can't enable U1 state for unconfigured device.
[  106.673256] usb 2-2: usb_set_device_initiated_lpm: Can't enable U2 state for unconfigured device.
[  106.673509] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[  106.673562] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  106.674181] usb 2-2: usb_disable_device nuking all URBs
[  106.800009] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x2a0
[  106.800033] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  106.800162] hub 2-0:1.0: hub_suspend
[  106.800186] usb usb2: bus auto-suspend, wakeup 1
[  244.597528] waiting module removal not supported: please upgrade
[  244.597557] usbcore: deregistering interface driver uas
[  244.597961] waiting module removal not supported: please upgrade
[  244.597983] usbcore: deregistering interface driver usb-storage
[  459.958998] usbcore: registered new interface driver usb-storage
[  471.531422] usb usb2: usb wakeup-resume
[  471.531479] usb usb2: usb auto-resume
[  471.531526] hub 2-0:1.0: hub_resume
[  471.531684] hub 2-0:1.0: port 2: status 0203 change 0001
[  471.634889] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0000
[  471.635074] hub 2-0:1.0: port 2, status 0203, change 0000, 5.0 Gb/s
[  471.747507] usb 2-2: new SuperSpeed USB device number 3 using xhci_hcd
[  471.764022] usb 2-2: skipped 1 descriptor after endpoint
[  471.764071] usb 2-2: skipped 1 descriptor after endpoint
[  471.764111] usb 2-2: skipped 2 descriptors after endpoint
[  471.764140] usb 2-2: skipped 2 descriptors after endpoint
[  471.764177] usb 2-2: skipped 2 descriptors after endpoint
[  471.764207] usb 2-2: skipped 2 descriptors after endpoint
[  471.764372] usb 2-2: default language 0x0409
[  471.764936] usb 2-2: udev 3, busnum 2, minor = 130
[  471.764976] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
[  471.765004] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[  471.765031] usb 2-2: Product: Plugable USB3-SATA-UASP1
[  471.765058] usb 2-2: Manufacturer: ASM1053E
[  471.765087] usb 2-2: SerialNumber: 123456789045
[  471.765832] usb 2-2: usb_probe_device
[  471.765879] usb 2-2: configuration #1 chosen from 1 choice
[  471.766867] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[  471.767280] usb-storage 2-2:1.0: usb_probe_interface
[  471.767334] usb-storage 2-2:1.0: usb_probe_interface - got id
[  471.767724] usb-storage 2-2:1.0: USB Mass Storage device detected
[  471.768378] usb-storage 2-2:1.0: Quirks match for vid 174c pid 55aa: c00000
[  471.769082] scsi7 : usb-storage 2-2:1.0
[  472.768980] scsi 7:0:0:0: Direct-Access     ASM1053E Plugable USB3-SA 0    PQ: 0 ANSI: 6
[  472.772088] sd 7:0:0:0: Attached scsi generic sg1 type 0
[  472.782456] sd 7:0:0:0: [sdb] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[  472.782755] sd 7:0:0:0: [sdb] Write Protect is off
[  472.782784] sd 7:0:0:0: [sdb] Mode Sense: 43 00 00 00
[  472.783105] sd 7:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  472.785034]  sdb: sdb1 sdb2 sdb3 sdb4
[  472.788001] sd 7:0:0:0: [sdb] Attached SCSI disk
[  472.938397] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdb3
[  472.950921] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdb3
[  472.983920] kjournald starting.  Commit interval 5 seconds
[  472.984613] EXT3-fs (sdb1): using internal journal
[  472.984669] EXT3-fs (sdb1): mounted filesystem with ordered data mode
[  472.996991] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdb3
[  472.999359] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[  473.005278] btrfs: disk space caching is enabled
[  473.040057] FAT-fs (sdb4): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[  473.264142] systemd-hostnamed[3353]: Warning: nss-myhostname is not installed. Changing the local hostname might make it unresolveable. Please install nss-myhostname!
[  480.728047] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  480.728395] hub 2-0:1.0: warm reset port 2
[  480.780956] hub 2-0:1.0: port 2 not warm reset yet, waiting 50ms
[  480.837723] hub 2-0:1.0: port 2, status 02c0, change 0041, 5.0 Gb/s
[  480.837778] usb 2-2: USB disconnect, device number 3
[  480.837808] usb 2-2: unregistering device
[  480.837844] usb 2-2: unregistering interface 2-2:1.0
[  480.838137] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[  480.838269] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  480.854008] end_request: I/O error, dev sdb, sector 0
[  480.857922] sd 7:0:0:0: [sdb] Synchronizing SCSI cache
[  480.858094] sd 7:0:0:0: [sdb]  
[  480.858118] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  480.858509] usb 2-2: usb_set_device_initiated_lpm: Can't enable U1 state for unconfigured device.
[  480.858585] usb 2-2: usb_set_device_initiated_lpm: Can't enable U2 state for unconfigured device.
[  480.858729] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[  480.858778] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  480.858822] usb 2-2: usb_disable_device nuking all URBs
[  480.905137] Buffer I/O error on device sdb1, logical block 0
[  480.905160] lost page write due to I/O error on sdb1
[  480.905177] EXT3-fs (sdb1): I/O error while writing superblock
[  480.933003] Buffer I/O error on device sdb2, logical block 1081344
[  480.933024] lost page write due to I/O error on sdb2
[  480.933037] JBD2: Error -5 detected when updating journal superblock for sdb2-8.
[  480.989028] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x2a0
[  480.989087] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  480.989275] hub 2-0:1.0: hub_suspend
[  480.989312] usb usb2: bus auto-suspend, wakeup 1
[  485.835451] usb usb2: usb wakeup-resume
[  485.835508] usb usb2: usb auto-resume
[  485.835553] hub 2-0:1.0: hub_resume
[  485.835703] hub 2-0:1.0: port 2: status 0203 change 0001
[  485.936217] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0000
[  485.936391] hub 2-0:1.0: port 2, status 0203, change 0000, 5.0 Gb/s
[  486.048837] usb 2-2: new SuperSpeed USB device number 4 using xhci_hcd
[  486.065471] usb 2-2: skipped 1 descriptor after endpoint
[  486.065521] usb 2-2: skipped 1 descriptor after endpoint
[  486.065560] usb 2-2: skipped 2 descriptors after endpoint
[  486.065589] usb 2-2: skipped 2 descriptors after endpoint
[  486.065620] usb 2-2: skipped 2 descriptors after endpoint
[  486.065653] usb 2-2: skipped 2 descriptors after endpoint
[  486.065817] usb 2-2: default language 0x0409
[  486.066349] usb 2-2: udev 4, busnum 2, minor = 131
[  486.066388] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
[  486.066417] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[  486.066443] usb 2-2: Product: Plugable USB3-SATA-UASP1
[  486.066470] usb 2-2: Manufacturer: ASM1053E
[  486.066501] usb 2-2: SerialNumber: 123456789045
[  486.067257] usb 2-2: usb_probe_device
[  486.067301] usb 2-2: configuration #1 chosen from 1 choice
[  486.068343] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[  486.068724] usb-storage 2-2:1.0: usb_probe_interface
[  486.068771] usb-storage 2-2:1.0: usb_probe_interface - got id
[  486.069171] usb-storage 2-2:1.0: USB Mass Storage device detected
[  486.069407] usb-storage 2-2:1.0: Quirks match for vid 174c pid 55aa: c00000
[  486.069557] scsi8 : usb-storage 2-2:1.0
[  487.070434] scsi 8:0:0:0: Direct-Access     ASM1053E Plugable USB3-SA 0    PQ: 0 ANSI: 6
[  487.073310] sd 8:0:0:0: Attached scsi generic sg1 type 0
[  487.084100] sd 8:0:0:0: [sdc] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[  487.084535] sd 8:0:0:0: [sdc] Write Protect is off
[  487.084559] sd 8:0:0:0: [sdc] Mode Sense: 43 00 00 00
[  487.084893] sd 8:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  487.086840]  sdc: sdc1 sdc2 sdc3 sdc4
[  487.089458] sd 8:0:0:0: [sdc] Attached SCSI disk
[  487.237510] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdc3
[  487.250928] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdc3
[  487.305097] kjournald starting.  Commit interval 5 seconds
[  487.307022] EXT3-fs (sdc1): using internal journal
[  487.307046] EXT3-fs (sdc1): recovery complete
[  487.307061] EXT3-fs (sdc1): mounted filesystem with ordered data mode
[  487.312546] FAT-fs (sdc4): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[  487.329415] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdc3
[  487.329991] EXT4-fs (sdc2): recovery complete
[  487.330781] EXT4-fs (sdc2): mounted filesystem with ordered data mode. Opts: (null)
[  498.409839] usb 2-2: Disable of device-initiated U1 failed.
[  498.413327] usb 2-2: Disable of device-initiated U2 failed.
[  498.415132] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  498.460348] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  498.468373] hub 2-0:1.0: port 2 not reset yet, waiting 50ms
[  498.524776] hub 2-0:1.0: logical disconnect on port 2
[  498.525108] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0004
[  498.525197] hub 2-0:1.0: port 2, status 02a0, change 0000, 5.0 Gb/s
[  498.525224] usb 2-2: USB disconnect, device number 4
[  498.525244] usb 2-2: unregistering device
[  498.525280] usb 2-2: unregistering interface 2-2:1.0
[  498.529025] sd 8:0:0:0: [sdc] Unhandled error code
[  498.529063] sd 8:0:0:0: [sdc]  
[  498.529088] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  498.529099] sd 8:0:0:0: [sdc] CDB: 
[  498.529122] end_request: I/O error, dev sdc, sector 21258976
[  498.529188] sd 8:0:0:0: [sdc] Unhandled error code
[  498.529209] sd 8:0:0:0: [sdc]  
[  498.529229] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  498.529245] sd 8:0:0:0: [sdc] CDB: 
[  498.529263] end_request: I/O error, dev sdc, sector 21259216
[  498.539875] Aborting journal on device sdc2-8.
[  498.539959] JBD2: Error -5 detected when updating journal superblock for sdc2-8.
[  498.539973] journal commit I/O error
[  498.546798] sd 8:0:0:0: [sdc] Synchronizing SCSI cache
[  498.546950] sd 8:0:0:0: [sdc]  
[  498.546966] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  498.547233] usb 2-2: usb_disable_device nuking all URBs
[  498.551236] hub 2-0:1.0: hub_suspend
[  498.551268] usb usb2: bus auto-suspend, wakeup 1
[  498.593459] EXT4-fs error (device sdc2): ext4_put_super:791: Couldn't clean up the journal
[  498.593497] EXT4-fs (sdc2): Remounting filesystem read-only
[  498.624330] Buffer I/O error on device sdc1, logical block 0
[  498.624355] lost page write due to I/O error on sdc1
[  498.624369] EXT3-fs (sdc1): I/O error while writing superblock
[  498.624500] ------------[ cut here ]------------
[  498.624521] WARNING: CPU: 0 PID: 3460 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  498.624539] sysfs group ffffffff81c927a0 not found for kobject 'target8:0:0'
[  498.624596] CPU: 0 PID: 3460 Comm: umount Not tainted 3.13.0-rc1+ #126
[  498.624613] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
[  498.624637] Call Trace:
[  498.624656]  [<ffffffff81611853>] dump_stack+0x45/0x56
[  498.624742]  [<ffffffff8104744d>] warn_slowpath_common+0x7d/0xa0
[  498.624761]  [<ffffffff810474bc>] warn_slowpath_fmt+0x4c/0x50
[  498.624780]  [<ffffffff8120202e>] ? sysfs_get_dirent_ns+0x4e/0x70
[  498.624800]  [<ffffffff812032f6>] sysfs_remove_group+0xc6/0xd0
[  498.624817]  [<ffffffff814029c3>] dpm_sysfs_remove+0x43/0x50
[  498.624837]  [<ffffffff813f89e5>] device_del+0x45/0x1c0
[  498.624854]  [<ffffffff81429487>] scsi_target_reap_usercontext+0x27/0x40
[  498.624871]  [<ffffffff81061b37>] execute_in_process_context+0x67/0x70
[  498.624938]  [<ffffffff8142c83c>] scsi_device_dev_release+0x1c/0x20
[  498.625214]  [<ffffffff81620516>] system_call_fastpath+0x1a/0x1f
[  601.745405] nautilus[2244]: segfault at 8 ip 00007f96deeb32d9 sp 00007fffe04f4020 error 4 in libglib-2.0.so.0.3800.1[7f96dee50000+fe000]
[  669.388888] init: tty4 main process (798) killed by TERM signal
[  669.389346] init: tty5 main process (805) killed by TERM signal
[  669.389817] init: tty2 main process (821) killed by TERM signal
[  669.390651] init: tty3 main process (822) killed by TERM signal
[  669.391118] init: tty6 main process (826) killed by TERM signal
[  669.391956] init: cron main process (902) killed by TERM signal
[  669.393821] init: irqbalance main process (966) killed by TERM signal
[  669.395167] init: tty1 main process (1285) killed by TERM signal
[  669.404929] init: plymouth-upstart-bridge main process (3663) terminated with status 1
[  671.119124] init: plymouth-ready (started) main process (3792) terminated with status 143
[  681.991627] init: systemd-logind main process (490) killed by TERM signal
[  681.998152] init: Disconnected from system bus
[  682.227171] btrfs: error reading free space cache
[  682.227271] BTRFS error (device sdb3): failed to load free space cache for block group 29360128
[  682.234503] btrfs: bdev /dev/sdc3 errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
[  682.234526] BTRFS error (device sdb3) in write_all_supers:3378: errno=-5 IO failure (errors while submitting device barriers.)
[  682.234547] BTRFS info (device sdb3): forced readonly
[  682.234569] BTRFS warning (device sdb3): Skipping commit of aborted transaction.
[  682.234590] ------------[ cut here ]------------
[  682.234623] WARNING: CPU: 2 PID: 4105 at fs/btrfs/super.c:254 __btrfs_abort_transaction+0x50/0x110 [btrfs]()
[  682.234647] btrfs: Transaction aborted (error -5)
[  682.234694] CPU: 2 PID: 4105 Comm: umount Tainted: G        W    3.13.0-rc1+ #126
[  682.234715] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
[  682.234743] Call Trace:
[  682.234765]  [<ffffffff81611853>] dump_stack+0x45/0x56
[  682.234793]  [<ffffffff8104744d>] warn_slowpath_common+0x7d/0xa0
[  682.234815]  [<ffffffff810474bc>] warn_slowpath_fmt+0x4c/0x50
[  682.234844]  [<ffffffffa0245a50>] __btrfs_abort_transaction+0x50/0x110 [btrfs]
[  682.234877]  [<ffffffffa026f1ae>] cleanup_transaction+0x6e/0x290 [btrfs]
[  682.234905]  [<ffffffff81088390>] ? prepare_to_wait_event+0x100/0x100
[  682.234937]  [<ffffffffa02700e2>] btrfs_commit_transaction+0x6d2/0x940 [btrfs]
[  682.235079]  [<ffffffffa02428e9>] btrfs_put_super+0x19/0x20 [btrfs]
[  682.235421] btrfs: commit super ret -5
[  682.276859] ------------[ cut here ]------------
[  682.276917] WARNING: CPU: 1 PID: 3270 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  682.276956] sysfs group ffffffff81c927a0 not found for kobject 'target7:0:0'
[  682.277047] CPU: 1 PID: 3270 Comm: kworker/1:2 Tainted: G        W    3.13.0-rc1+ #126
[  682.277080] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
[  682.277147] Call Trace:
[  682.277183]  [<ffffffff81611853>] dump_stack+0x45/0x56
[  682.277223]  [<ffffffff8104744d>] warn_slowpath_common+0x7d/0xa0
[  682.277261]  [<ffffffff810474bc>] warn_slowpath_fmt+0x4c/0x50
[  682.277298]  [<ffffffff8120202e>] ? sysfs_get_dirent_ns+0x4e/0x70
[  682.277335]  [<ffffffff812032f6>] sysfs_remove_group+0xc6/0xd0
[  682.277372]  [<ffffffff814029c3>] dpm_sysfs_remove+0x43/0x50
[  682.277411]  [<ffffffff813f89e5>] device_del+0x45/0x1c0
[  682.277451]  [<ffffffff81429487>] scsi_target_reap_usercontext+0x27/0x40
[  682.277486]  [<ffffffff81061b37>] execute_in_process_context+0x67/0x70
[  682.277521]  [<ffffffff8142a924>] scsi_target_reap+0xc4/0xf0
[  682.277559]  [<ffffffff8142c9c8>] scsi_device_dev_release_usercontext+0x188/0x1c0
[  682.277595]  [<ffffffff81061b37>] execute_in_process_context+0x67/0x70
[  682.277631]  [<ffffffff8142c83c>] scsi_device_dev_release+0x1c/0x20
[  682.277669]  [<ffffffff813f8032>] device_release+0x32/0xa0
[  682.277777]  [<ffffffff813f8327>] put_device+0x17/0x20
[  682.277921]  [<ffffffff811c4a4c>] __blkdev_put+0x17c/0x1b0
[  682.278043]  [<ffffffffa029146d>] __free_device+0x2d/0x50 [btrfs]
[  682.278201]  [<ffffffff810692b2>] kthread+0xd2/0xf0
[  682.278346] ---[ end trace dbd540e734575281 ]---
[  682.627937] sd 0:0:0:0: [sda] Synchronizing SCSI cache

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="log-3.12-rc6.txt"

[   35.007399] netpoll: netconsole: local port 6665
[   35.007402] netpoll: netconsole: local IPv4 address 0.0.0.0
[   35.007403] netpoll: netconsole: interface 'eth1'
[   35.007404] netpoll: netconsole: remote port 6666
[   35.007405] netpoll: netconsole: remote IPv4 address 10.7.201.41
[   35.007406] netpoll: netconsole: remote ethernet address 00:05:1b:72:1f:e1
[   35.007408] netpoll: netconsole: local IP 10.7.201.20
[   35.007867] console [netcon0] enabled
[   35.007889] netconsole: network logging started
[   41.548479] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[   41.548562] xhci_hcd 0000:00:14.0: resume root hub
[   41.548584] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[   41.548646] usb usb2: usb wakeup-resume
[   41.548666] usb usb2: usb auto-resume
[   41.548730] hub 2-0:1.0: hub_resume
[   41.548786] xhci_hcd 0000:00:14.0: get port status, actual port 0 status  = 0x2a0
[   41.548831] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   41.548915] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x21203
[   41.548937] xhci_hcd 0000:00:14.0: Get port status returned 0x10203
[   41.548961] hub 2-0:1.0: port 2: status 0203 change 0001
[   41.548993] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x1203
[   41.549038] xhci_hcd 0000:00:14.0: get port status, actual port 2 status  = 0x2a0
[   41.549056] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   41.549090] xhci_hcd 0000:00:14.0: get port status, actual port 3 status  = 0x2a0
[   41.549108] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   41.594339] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[   41.650443] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0000
[   41.650501] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x1203
[   41.650539] xhci_hcd 0000:00:14.0: Get port status returned 0x203
[   41.650592] hub 2-0:1.0: port 2, status 0203, change 0000, 5.0 Gb/s
[   41.650629] xhci_hcd 0000:00:14.0: // Ding dong!
[   41.650675] xhci_hcd 0000:00:14.0: Adding 1 ep ctx, 10 now active.
[   41.650719] xhci_hcd 0000:00:14.0: Slot 5 output ctx = 0x9892c000 (dma)
[   41.650750] xhci_hcd 0000:00:14.0: Slot 5 input ctx = 0x9892d000 (dma)
[   41.650804] xhci_hcd 0000:00:14.0: Set slot id 5 dcbaa entry ffff8800317ad028 to 0x9892c000
[   41.650849] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x1203
[   41.650865] xhci_hcd 0000:00:14.0: Get port status returned 0x203
[   41.650961] xhci_hcd 0000:00:14.0: set port reset, actual port 1 status  = 0x1311
[   41.650993] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[   41.651024] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[   41.706485] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x281203
[   41.706525] xhci_hcd 0000:00:14.0: Get port status returned 0x300203
[   41.762513] xhci_hcd 0000:00:14.0: clear port reset change, actual port 1 status  = 0x81203
[   41.762640] xhci_hcd 0000:00:14.0: clear port warm(BH) reset change, actual port 1 status  = 0x1203
[   41.762756] xhci_hcd 0000:00:14.0: clear port link state change, actual port 1 status  = 0x1203
[   41.762852] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x1203
[   41.762964] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x1203
[   41.763000] xhci_hcd 0000:00:14.0: Get port status returned 0x203
[   41.763071] xhci_hcd 0000:00:14.0: Set root hub portnum to 6
[   41.763096] xhci_hcd 0000:00:14.0: Set fake root hub portnum to 2
[   41.763114] xhci_hcd 0000:00:14.0: udev->tt =           (null)
[   41.763129] xhci_hcd 0000:00:14.0: udev->ttport = 0x0
[   41.763146] xhci_hcd 0000:00:14.0: Slot ID 5 Input Context:
[   41.763160] xhci_hcd 0000:00:14.0: @ffff88009892d000 (virt) @9892d000 (dma) 0x000000 - drop flags
[   41.763178] xhci_hcd 0000:00:14.0: @ffff88009892d004 (virt) @9892d004 (dma) 0x000003 - add flags
[   41.763197] xhci_hcd 0000:00:14.0: @ffff88009892d008 (virt) @9892d008 (dma) 0x000000 - rsvd2[0]
[   41.763214] xhci_hcd 0000:00:14.0: @ffff88009892d00c (virt) @9892d00c (dma) 0x000000 - rsvd2[1]
[   41.763231] xhci_hcd 0000:00:14.0: @ffff88009892d010 (virt) @9892d010 (dma) 0x000000 - rsvd2[2]
[   41.763247] xhci_hcd 0000:00:14.0: @ffff88009892d014 (virt) @9892d014 (dma) 0x000000 - rsvd2[3]
[   41.763265] xhci_hcd 0000:00:14.0: @ffff88009892d018 (virt) @9892d018 (dma) 0x000000 - rsvd2[4]
[   41.763279] xhci_hcd 0000:00:14.0: @ffff88009892d01c (virt) @9892d01c (dma) 0x000000 - rsvd2[5]
[   41.763347] xhci_hcd 0000:00:14.0: @ffff88009892d028 (virt) @9892d028 (dma) 0x000000 - tt_info
[   41.763548] xhci_hcd 0000:00:14.0: @ffff88009892d058 (virt) @9892d058 (dma) 0x000000 - rsvd[1]
[   41.763697] xhci_hcd 0000:00:14.0: @ffff88009892d07c (virt) @9892d07c (dma) 0x000000 - rsvd[2]
[   41.763849] xhci_hcd 0000:00:14.0: // Ding dong!
[   41.764010] xhci_hcd 0000:00:14.0: @ffff88009892d004 (virt) @9892d004 (dma) 0x000003 - add flags
[   41.764140] xhci_hcd 0000:00:14.0: Slot Context:
[   41.764368] xhci_hcd 0000:00:14.0: @ffff88009892d048 (virt) @9892d048 (dma) 0x9892e001 - deq
[   41.764519] xhci_hcd 0000:00:14.0: @ffff88009892d068 (virt) @9892d068 (dma) 0x000000 - deq
[   41.764688] xhci_hcd 0000:00:14.0: @ffff88009892d090 (virt) @9892d090 (dma) 0x000000 - tx_info
[   41.764865] xhci_hcd 0000:00:14.0: @ffff88009892c010 (virt) @9892c010 (dma) 0x000000 - rsvd[0]
[   41.765050] xhci_hcd 0000:00:14.0: @ffff88009892c038 (virt) @9892c038 (dma) 0x000000 - rsvd[1]
[   41.765234] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
[   41.779189] usb 2-2: skipped 1 descriptor after endpoint
[   41.779223] usb 2-2: skipped 1 descriptor after endpoint
[   41.779266] usb 2-2: skipped 2 descriptors after endpoint
[   41.779277] usb 2-2: skipped 2 descriptors after endpoint
[   41.779288] usb 2-2: skipped 2 descriptors after endpoint
[   41.779300] usb 2-2: skipped 2 descriptors after endpoint
[   41.779370] xhci_hcd 0000:00:14.0: Waiting for status stage event
[   41.779422] usb 2-2: default language 0x0409
[   41.779539] xhci_hcd 0000:00:14.0: Waiting for status stage event
[   41.779658] xhci_hcd 0000:00:14.0: Waiting for status stage event
[   41.779765] xhci_hcd 0000:00:14.0: Waiting for status stage event
[   41.779813] usb 2-2: udev 2, busnum 2, minor = 129
[   41.779832] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
[   41.779843] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[   41.779852] usb 2-2: Product: Plugable USB3-SATA-UASP1
[   41.779861] usb 2-2: Manufacturer: ASM1053E
[   41.779870] usb 2-2: SerialNumber: 123456789045
[   41.780213] usb 2-2: usb_probe_device
[   41.780232] usb 2-2: configuration #1 chosen from 1 choice
[   41.780295] xhci_hcd 0000:00:14.0: add ep 0x81, slot id 5, new drop flags = 0x0, new add flags = 0x8, new slot info = 0x18400000
[   41.780336] xhci_hcd 0000:00:14.0: add ep 0x2, slot id 5, new drop flags = 0x0, new add flags = 0x18, new slot info = 0x20400000
[   41.780359] xhci_hcd 0000:00:14.0: xhci_check_bandwidth called for udev ffff88009a3c8800
[   41.780398] xhci_hcd 0000:00:14.0: @ffff88009892d000 (virt) @9892d000 (dma) 0x000000 - drop flags
[   41.780527] xhci_hcd 0000:00:14.0: @ffff88009892d018 (virt) @9892d018 (dma) 0x000000 - rsvd2[4]
[   41.780660] xhci_hcd 0000:00:14.0: @ffff88009892d02c (virt) @9892d02c (dma) 0x000000 - dev_state
[   41.780810] xhci_hcd 0000:00:14.0: @ffff88009892d044 (virt) @9892d044 (dma) 0x2000026 - ep_info2
[   41.780962] xhci_hcd 0000:00:14.0: @ffff88009892d060 (virt) @9892d060 (dma) 0x000000 - ep_info
[   41.781089] xhci_hcd 0000:00:14.0: @ffff88009892d07c (virt) @9892d07c (dma) 0x000000 - rsvd[2]
[   41.781244] xhci_hcd 0000:00:14.0: @ffff88009892d098 (virt) @9892d098 (dma) 0x000000 - rsvd[1]
[   41.781460] xhci_hcd 0000:00:14.0: Adding 2 ep ctxs, 12 now active.
[   41.781586] xhci_hcd 0000:00:14.0: Completed config ep cmd
[   41.781715] xhci_hcd 0000:00:14.0: Slot Context:
[   41.781859] xhci_hcd 0000:00:14.0: @ffff88009892c018 (virt) @9892c018 (dma) 0x000000 - rsvd[2]
[   41.781981] xhci_hcd 0000:00:14.0: @ffff88009892c030 (virt) @9892c030 (dma) 0x000000 - tx_info
[   41.782125] xhci_hcd 0000:00:14.0: @ffff88009892c048 (virt) @9892c048 (dma) 0x000000 - deq
[   41.782378] xhci_hcd 0000:00:14.0: OUT Endpoint 02 Context (ep_index 03):
[   41.782573] xhci_hcd 0000:00:14.0: Endpoint 0x2 not halted, refusing to reset.
[   41.782741] xhci_hcd 0000:00:14.0: Slot 5 Input Context:
[   41.782936] xhci_hcd 0000:00:14.0: @ffff8800317ab01c (virt) @317ab01c (dma) 0x000000 - rsvd2[5]
[   41.783087] xhci_hcd 0000:00:14.0: @ffff8800317ab030 (virt) @317ab030 (dma) 0x000000 - rsvd[0]
[   41.783262] xhci_hcd 0000:00:14.0: @ffff8800317ab048 (virt) @317ab048 (dma) 0x000000 - deq
[   41.783472] xhci_hcd 0000:00:14.0: Slot 5 Output Context:
[   41.783638] xhci_hcd 0000:00:14.0: @ffff88009892c014 (virt) @9892c014 (dma) 0x000000 - rsvd[1]
[   41.783806] xhci_hcd 0000:00:14.0: @ffff88009892c030 (virt) @9892c030 (dma) 0x000000 - tx_info
[   41.784028] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[   41.784129] xhci_hcd 0000:00:14.0: @ffff8800317ab008 (virt) @317ab008 (dma) 0x000000 - rsvd2[0]
[   41.784279] xhci_hcd 0000:00:14.0: Slot Context:
[   41.784458] xhci_hcd 0000:00:14.0: @ffff8800317ab038 (virt) @317ab038 (dma) 0x000000 - rsvd[2]
[   41.784632] xhci_hcd 0000:00:14.0: @ffff8800317ab054 (virt) @317ab054 (dma) 0x000000 - rsvd[0]
[   41.784829] xhci_hcd 0000:00:14.0: @ffff88009892c000 (virt) @9892c000 (dma) 0x20400000 - dev_info
[   41.785024] xhci_hcd 0000:00:14.0: @ffff88009892c020 (virt) @9892c020 (dma) 0x000001 - ep_info
[   41.785258] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[   41.785646] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[   41.785671] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x1203
[   41.808425] usb-storage 2-2:1.0: usb_probe_interface
[   41.808450] usb-storage 2-2:1.0: usb_probe_interface - got id
[   41.808624] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[   41.808648] xhci_hcd 0000:00:14.0: Slot 5 Input Context:
[   41.808669] xhci_hcd 0000:00:14.0: @ffff8800317ab000 (virt) @317ab000 (dma) 0x000000 - drop flags
[   41.808697] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[   41.808719] xhci_hcd 0000:00:14.0: @ffff8800317ab008 (virt) @317ab008 (dma) 0x000000 - rsvd2[0]
[   41.808743] xhci_hcd 0000:00:14.0: @ffff8800317ab00c (virt) @317ab00c (dma) 0x000000 - rsvd2[1]
[   41.808766] xhci_hcd 0000:00:14.0: @ffff8800317ab010 (virt) @317ab010 (dma) 0x000000 - rsvd2[2]
[   41.808793] xhci_hcd 0000:00:14.0: @ffff8800317ab014 (virt) @317ab014 (dma) 0x000000 - rsvd2[3]
[   41.808815] xhci_hcd 0000:00:14.0: @ffff8800317ab018 (virt) @317ab018 (dma) 0x000000 - rsvd2[4]
[   41.808841] xhci_hcd 0000:00:14.0: @ffff8800317ab01c (virt) @317ab01c (dma) 0x000000 - rsvd2[5]
[   41.808863] xhci_hcd 0000:00:14.0: Slot Context:
[   41.808892] xhci_hcd 0000:00:14.0: @ffff8800317ab020 (virt) @317ab020 (dma) 0x20400000 - dev_info
[   41.808914] xhci_hcd 0000:00:14.0: @ffff8800317ab024 (virt) @317ab024 (dma) 0x060000 - dev_info2
[   41.808933] xhci_hcd 0000:00:14.0: @ffff8800317ab028 (virt) @317ab028 (dma) 0x000000 - tt_info
[   41.808960] xhci_hcd 0000:00:14.0: @ffff8800317ab02c (virt) @317ab02c (dma) 0x18000005 - dev_state
[   41.808983] xhci_hcd 0000:00:14.0: @ffff8800317ab030 (virt) @317ab030 (dma) 0x000000 - rsvd[0]
[   41.809012] xhci_hcd 0000:00:14.0: @ffff8800317ab034 (virt) @317ab034 (dma) 0x000000 - rsvd[1]
[   41.809110] xhci_hcd 0000:00:14.0: @ffff8800317ab040 (virt) @317ab040 (dma) 0x000000 - ep_info
[   41.809384] xhci_hcd 0000:00:14.0: Slot Context:
[   41.809619] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[   41.809817] xhci_hcd 0000:00:14.0: @ffff88009892c03c (virt) @9892c03c (dma) 0x000000 - rsvd[2]
[   41.810017] scsi6 : usb-storage 2-2:1.0
[   41.810436] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[   41.810467] xhci_hcd 0000:00:14.0: Slot 5 Input Context:
[   41.810622] xhci_hcd 0000:00:14.0: @ffff8800317ab014 (virt) @317ab014 (dma) 0x000000 - rsvd2[3]
[   41.810776] xhci_hcd 0000:00:14.0: @ffff8800317ab028 (virt) @317ab028 (dma) 0x000000 - tt_info
[   41.810910] xhci_hcd 0000:00:14.0: @ffff8800317ab03c (virt) @317ab03c (dma) 0x000000 - rsvd[3]
[   41.811084] xhci_hcd 0000:00:14.0: @ffff8800317ab058 (virt) @317ab058 (dma) 0x000000 - rsvd[1]
[   41.811274] xhci_hcd 0000:00:14.0: @ffff88009892c000 (virt) @9892c000 (dma) 0x20400000 - dev_info
[   41.811490] xhci_hcd 0000:00:14.0: @ffff88009892c020 (virt) @9892c020 (dma) 0x000001 - ep_info
[   41.811797] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[   41.811844] xhci_hcd 0000:00:14.0: @ffff8800317ab000 (virt) @317ab000 (dma) 0x000000 - drop flags
[   41.812019] xhci_hcd 0000:00:14.0: @ffff8800317ab01c (virt) @317ab01c (dma) 0x000000 - rsvd2[5]
[   41.812168] xhci_hcd 0000:00:14.0: @ffff8800317ab030 (virt) @317ab030 (dma) 0x000000 - rsvd[0]
[   41.812410] xhci_hcd 0000:00:14.0: @ffff8800317ab058 (virt) @317ab058 (dma) 0x000000 - rsvd[1]
[   41.812572] xhci_hcd 0000:00:14.0: Slot Context:
[   41.812787] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[   41.812929] xhci_hcd 0000:00:14.0: @ffff88009892c038 (virt) @9892c038 (dma) 0x000000 - rsvd[1]
[   41.813107] usbcore: registered new interface driver usb-storage
[   41.842495] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[   42.807944] scsi 6:0:0:0: Direct-Access     ASM1053E Plugable USB3-SA 0    PQ: 0 ANSI: 6
[   42.809026] sd 6:0:0:0: Attached scsi generic sg1 type 0
[   42.820245] sd 6:0:0:0: [sdb] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[   42.820418] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[   42.820444] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acd5b3c0, len = 68, expected = 192, status = -121
[   42.820497] xhci_hcd 0000:00:14.0: Stalled endpoint
[   42.820525] xhci_hcd 0000:00:14.0: Giveback URB ffff8800b113e6c0, len = 0, expected = 13, status = -32
[   42.820614] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   42.820642] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   42.820671] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   42.820699] xhci_hcd 0000:00:14.0: Finding endpoint context
[   42.820729] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   42.820759] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[   42.820789] xhci_hcd 0000:00:14.0: New dequeue segment = ffff88009a08b960 (virtual)
[   42.820814] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x9892e870 (DMA)
[   42.820837] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   42.820862] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff88009a08b960 (0x9892e800 dma), new deq ptr = ffff88009892e870 (0x9892e870 dma), new cycle = 1
[   42.820956] xhci_hcd 0000:00:14.0: // Ding dong!
[   42.820985] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   42.821015] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @9892e871
[   42.821065] sd 6:0:0:0: [sdb] Write Protect is off
[   42.821079] sd 6:0:0:0: [sdb] Mode Sense: 43 00 00 00
[   42.821184] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[   42.821268] xhci_hcd 0000:00:14.0: Stalled endpoint
[   42.821414] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   42.821587] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   42.821723] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @9892e8a1
[   42.822570] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[   42.822594] xhci_hcd 0000:00:14.0: Giveback URB ffff8800c7d0c540, len = 68, expected = 192, status = -121
[   42.822638] xhci_hcd 0000:00:14.0: Stalled endpoint
[   42.822662] xhci_hcd 0000:00:14.0: Giveback URB ffff8800b113e6c0, len = 0, expected = 13, status = -32
[   42.822748] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   42.822771] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   42.822892] xhci_hcd 0000:00:14.0: New dequeue segment = ffff88009a08b960 (virtual)
[   42.823048] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   42.824049] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[   42.824068] xhci_hcd 0000:00:14.0: Giveback URB ffff8800c7d0c540, len = 68, expected = 192, status = -121
[   42.824112] xhci_hcd 0000:00:14.0: Stalled endpoint
[   42.824135] xhci_hcd 0000:00:14.0: Giveback URB ffff8800b113e6c0, len = 0, expected = 13, status = -32
[   42.824193] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   42.824213] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   42.824236] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   42.824380] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   42.824779]  sdb: sdb1 sdb2 sdb3 sdb4
[   42.826199] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[   42.826223] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acd5bd80, len = 68, expected = 192, status = -121
[   42.826275] xhci_hcd 0000:00:14.0: Stalled endpoint
[   42.826299] xhci_hcd 0000:00:14.0: Giveback URB ffff8800b113e6c0, len = 0, expected = 13, status = -32
[   42.826362] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   42.826388] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   42.826417] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   42.826447] xhci_hcd 0000:00:14.0: Finding endpoint context
[   42.826477] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   42.826507] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[   42.826563] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x9892e9c0 (DMA)
[   42.826683] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   42.826906] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[   42.827051] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   42.827224] xhci_hcd 0000:00:14.0: New dequeue segment = ffff88009a08b960 (virtual)
[   42.827377] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   42.829818] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   42.829840] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acd5bd80, len = 22, expected = 96, status = -121
[   42.829884] xhci_hcd 0000:00:14.0: Stalled endpoint
[   42.829902] xhci_hcd 0000:00:14.0: Giveback URB ffff8800b113e6c0, len = 0, expected = 13, status = -32
[   42.829954] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   42.829972] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   42.829993] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   42.830017] xhci_hcd 0000:00:14.0: Finding endpoint context
[   42.830043] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   42.830067] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[   42.830092] xhci_hcd 0000:00:14.0: New dequeue segment = ffff88009a08b960 (virtual)
[   42.830115] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x9892ea60 (DMA)
[   42.830140] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   42.830164] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff88009a08b960 (0x9892e800 dma), new deq ptr = ffff88009892ea60 (0x9892ea60 dma), new cycle = 1
[   42.830192] xhci_hcd 0000:00:14.0: // Ding dong!
[   42.830217] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   42.859976] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   42.860017] xhci_hcd 0000:00:14.0: Giveback URB ffff88002fbb2000, len = 22, expected = 96, status = -121
[   42.860099] xhci_hcd 0000:00:14.0: Stalled endpoint
[   42.860133] xhci_hcd 0000:00:14.0: Giveback URB ffff8800b113e6c0, len = 0, expected = 13, status = -32
[   42.860257] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   42.860290] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   42.860317] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   42.860343] xhci_hcd 0000:00:14.0: Finding endpoint context
[   42.860365] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   42.860405] xhci_hcd 0000:00:14.0: Cycle state = 0x0
[   42.860436] xhci_hcd 0000:00:14.0: New dequeue segment = ffff88009a08b580 (virtual)
[   42.860466] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530370 (DMA)
[   42.860487] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   42.860513] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff88009a08b580 (0x30530000 dma), new deq ptr = ffff880030530370 (0x30530370 dma), new cycle = 0
[   42.860542] xhci_hcd 0000:00:14.0: // Ding dong!
[   42.860569] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   42.860601] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530370
[   42.869845] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   42.869871] xhci_hcd 0000:00:14.0: Giveback URB ffff880031df7600, len = 22, expected = 96, status = -121
[   42.869927] xhci_hcd 0000:00:14.0: Stalled endpoint
[   42.869951] xhci_hcd 0000:00:14.0: Giveback URB ffff8800b113e6c0, len = 0, expected = 13, status = -32
[   42.870025] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   42.870052] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   42.870081] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   42.870112] xhci_hcd 0000:00:14.0: Finding endpoint context
[   42.870141] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   42.870168] xhci_hcd 0000:00:14.0: Cycle state = 0x0
[   42.870190] xhci_hcd 0000:00:14.0: New dequeue segment = ffff88009a08b580 (virtual)
[   42.870216] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x305303d0 (DMA)
[   42.870239] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   42.870267] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff88009a08b580 (0x30530000 dma), new deq ptr = ffff8800305303d0 (0x305303d0 dma), new cycle = 0
[   42.870300] xhci_hcd 0000:00:14.0: // Ding dong!
[   42.870330] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   42.870362] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @305303d0
[   42.879874] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   42.879902] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acd5b3c0, len = 22, expected = 96, status = -121
[   42.879949] xhci_hcd 0000:00:14.0: Stalled endpoint
[   42.879971] xhci_hcd 0000:00:14.0: Giveback URB ffff8800b113e6c0, len = 0, expected = 13, status = -32
[   42.880028] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   42.880054] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   42.880078] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   42.880101] xhci_hcd 0000:00:14.0: Finding endpoint context
[   42.880125] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   42.880147] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[   42.880172] xhci_hcd 0000:00:14.0: New dequeue segment = ffff88009a08b960 (virtual)
[   42.880194] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x9892e960 (DMA)
[   42.880219] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   42.880241] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff88009a08b960 (0x9892e800 dma), new deq ptr = ffff88009892e960 (0x9892e960 dma), new cycle = 1
[   42.880267] xhci_hcd 0000:00:14.0: // Ding dong!
[   42.880296] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   42.880325] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @9892e961
[   42.881318] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   42.881340] xhci_hcd 0000:00:14.0: Giveback URB ffff880031df7d80, len = 22, expected = 96, status = -121
[   42.881387] xhci_hcd 0000:00:14.0: Stalled endpoint
[   42.881409] xhci_hcd 0000:00:14.0: Giveback URB ffff8800b113e6c0, len = 0, expected = 13, status = -32
[   42.881464] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   42.881485] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   42.881506] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   42.881529] xhci_hcd 0000:00:14.0: Finding endpoint context
[   42.881627] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x9892ea20 (DMA)
[   42.889980] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   42.890052] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acd5b3c0, len = 22, expected = 96, status = -121
[   42.890117] xhci_hcd 0000:00:14.0: Stalled endpoint
[   42.890142] xhci_hcd 0000:00:14.0: Giveback URB ffff8800b113e6c0, len = 0, expected = 13, status = -32
[   42.890205] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   42.890233] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   42.890259] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   42.890282] xhci_hcd 0000:00:14.0: Finding endpoint context
[   42.890307] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   42.890332] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[   42.890357] xhci_hcd 0000:00:14.0: New dequeue segment = ffff88009a08b960 (virtual)
[   42.890380] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x9892eaf0 (DMA)
[   42.890405] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   42.890431] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff88009a08b960 (0x9892e800 dma), new deq ptr = ffff88009892eaf0 (0x9892eaf0 dma), new cycle = 1
[   42.890458] xhci_hcd 0000:00:14.0: // Ding dong!
[   42.890487] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   42.890516] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @9892eaf1
[   42.899893] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   42.899921] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acd5b9c0, len = 22, expected = 96, status = -121
[   42.899984] xhci_hcd 0000:00:14.0: Stalled endpoint
[   42.900010] xhci_hcd 0000:00:14.0: Giveback URB ffff8800b113e6c0, len = 0, expected = 13, status = -32
[   42.900090] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   42.900117] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   42.900143] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   42.900170] xhci_hcd 0000:00:14.0: Finding endpoint context
[   42.900195] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   42.900217] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[   42.900242] xhci_hcd 0000:00:14.0: New dequeue segment = ffff88009a08b960 (virtual)
[   42.900263] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x9892ebc0 (DMA)
[   42.900287] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   42.900310] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff88009a08b960 (0x9892e800 dma), new deq ptr = ffff88009892ebc0 (0x9892ebc0 dma), new cycle = 1
[   42.900336] xhci_hcd 0000:00:14.0: // Ding dong!
[   42.900366] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   42.900393] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @9892ebc1
[   42.902373] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   42.902391] xhci_hcd 0000:00:14.0: Giveback URB ffff880031df7540, len = 22, expected = 96, status = -121
[   42.902436] xhci_hcd 0000:00:14.0: Stalled endpoint
[   42.902458] xhci_hcd 0000:00:14.0: Giveback URB ffff8800b113e6c0, len = 0, expected = 13, status = -32
[   42.902510] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   42.902532] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   42.902555] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   42.902578] xhci_hcd 0000:00:14.0: Finding endpoint context
[   42.902604] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   42.902626] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[   42.902651] xhci_hcd 0000:00:14.0: New dequeue segment = ffff88009a08b580 (virtual)
[   42.902675] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530090 (DMA)
[   42.902701] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   42.902724] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff88009a08b580 (0x30530000 dma), new deq ptr = ffff880030530090 (0x30530090 dma), new cycle = 1
[   42.955188] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdb3
[   42.972640] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdb3
[   42.993923] kjournald starting.  Commit interval 5 seconds
[   42.994177] EXT3-fs (sdb1): using internal journal
[   42.994200] EXT3-fs (sdb1): recovery complete
[   42.994219] EXT3-fs (sdb1): mounted filesystem with ordered data mode
[   43.009586] FAT-fs (sdb4): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[   43.015058] EXT4-fs (sdb2): recovery complete
[   43.018964] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[   43.042505] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdb3
[   43.049746] btrfs: disk space caching is enabled
[   43.111480] systemd-hostnamed[2738]: Warning: nss-myhostname is not installed. Changing the local hostname might make it unresolveable. Please install nss-myhostname!
[   51.238956] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[   51.239044] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[   51.239143] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[   51.239197] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x4202c0
[   51.239237] xhci_hcd 0000:00:14.0: Get port status returned 0x4102c0
[   51.239336] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x4002c0
[   51.239385] xhci_hcd 0000:00:14.0: clear port link state change, actual port 1 status  = 0x2c0
[   51.239418] hub 2-0:1.0: warm reset port 2
[   51.272695] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[   51.292809] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2b0
[   51.292849] xhci_hcd 0000:00:14.0: Get port status returned 0x2b0
[   51.292916] hub 2-0:1.0: port 2 not warm reset yet, waiting 50ms
[   51.338356] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[   51.338442] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[   51.348819] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2802a0
[   51.348871] xhci_hcd 0000:00:14.0: Get port status returned 0x3002a0
[   51.348981] xhci_hcd 0000:00:14.0: clear port reset change, actual port 1 status  = 0x802a0
[   51.349102] xhci_hcd 0000:00:14.0: clear port warm(BH) reset change, actual port 1 status  = 0x2a0
[   51.349188] xhci_hcd 0000:00:14.0: clear port link state change, actual port 1 status  = 0x2a0
[   51.349270] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x2a0
[   51.349339] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[   51.349363] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   51.349424] xhci_hcd 0000:00:14.0: Disable port 1
[   51.349497] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x280
[   51.349519] xhci_hcd 0000:00:14.0: Get port status returned 0x280
[   51.349568] xhci_hcd 0000:00:14.0: Enable port 1
[   51.349631] hub 2-0:1.0: port 2, status 02c0, change 0041, 5.0 Gb/s
[   51.349646] usb 2-2: USB disconnect, device number 2
[   51.349660] usb 2-2: unregistering device
[   51.349670] usb 2-2: unregistering interface 2-2:1.0
[   51.349790] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[   51.349874] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[   51.350034] xhci_hcd 0000:00:14.0: @ffff8800317ab010 (virt) @317ab010 (dma) 0x000000 - rsvd2[2]
[   51.350369] xhci_hcd 0000:00:14.0: @ffff8800317ab048 (virt) @317ab048 (dma) 0x000000 - deq
[   51.350737] xhci_hcd 0000:00:14.0: @ffff88009892c01c (virt) @9892c01c (dma) 0x000000 - rsvd[3]
[   51.359549] end_request: I/O error, dev sdb, sector 0
[   51.364227] sd 6:0:0:0: [sdb] Synchronizing SCSI cache
[   51.364346] sd 6:0:0:0: [sdb]  
[   51.364365] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[   51.367589] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[   51.367636] xhci_hcd 0000:00:14.0: Slot 5 Input Context:
[   51.367662] xhci_hcd 0000:00:14.0: @ffff8800317ab000 (virt) @317ab000 (dma) 0x000000 - drop flags
[   51.367705] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[   51.367733] xhci_hcd 0000:00:14.0: @ffff8800317ab008 (virt) @317ab008 (dma) 0x000000 - rsvd2[0]
[   51.367760] xhci_hcd 0000:00:14.0: @ffff8800317ab00c (virt) @317ab00c (dma) 0x000000 - rsvd2[1]
[   51.367793] xhci_hcd 0000:00:14.0: @ffff8800317ab010 (virt) @317ab010 (dma) 0x000000 - rsvd2[2]
[   51.367819] xhci_hcd 0000:00:14.0: @ffff8800317ab014 (virt) @317ab014 (dma) 0x000000 - rsvd2[3]
[   51.367850] xhci_hcd 0000:00:14.0: @ffff8800317ab018 (virt) @317ab018 (dma) 0x000000 - rsvd2[4]
[   51.367881] xhci_hcd 0000:00:14.0: @ffff8800317ab01c (virt) @317ab01c (dma) 0x000000 - rsvd2[5]
[   51.367906] xhci_hcd 0000:00:14.0: Slot Context:
[   51.367939] xhci_hcd 0000:00:14.0: @ffff8800317ab020 (virt) @317ab020 (dma) 0x20400000 - dev_info
[   51.367965] xhci_hcd 0000:00:14.0: @ffff8800317ab024 (virt) @317ab024 (dma) 0x06000a - dev_info2
[   51.367998] xhci_hcd 0000:00:14.0: @ffff8800317ab028 (virt) @317ab028 (dma) 0x000000 - tt_info
[   51.368027] xhci_hcd 0000:00:14.0: @ffff8800317ab02c (virt) @317ab02c (dma) 0x18000005 - dev_state
[   51.368052] xhci_hcd 0000:00:14.0: @ffff8800317ab030 (virt) @317ab030 (dma) 0x000000 - rsvd[0]
[   51.368083] xhci_hcd 0000:00:14.0: @ffff8800317ab034 (virt) @317ab034 (dma) 0x000000 - rsvd[1]
[   51.368109] xhci_hcd 0000:00:14.0: @ffff8800317ab038 (virt) @317ab038 (dma) 0x000000 - rsvd[2]
[   51.368312] xhci_hcd 0000:00:14.0: @ffff8800317ab054 (virt) @317ab054 (dma) 0x000000 - rsvd[0]
[   51.368688] xhci_hcd 0000:00:14.0: @ffff88009892c014 (virt) @9892c014 (dma) 0x000000 - rsvd[1]
[   51.370521] usb 2-2: usb_set_device_initiated_lpm: Can't enable U1 state for unconfigured device.
[   51.370548] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[   51.370594] xhci_hcd 0000:00:14.0: Slot 5 Input Context:
[   51.370619] xhci_hcd 0000:00:14.0: @ffff8800317ab000 (virt) @317ab000 (dma) 0x000000 - drop flags
[   51.370647] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[   51.370819] xhci_hcd 0000:00:14.0: @ffff8800317ab01c (virt) @317ab01c (dma) 0x000000 - rsvd2[5]
[   51.371112] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[   51.371439] xhci_hcd 0000:00:14.0: Slot 5 Output Context:
[   51.371762] xhci_hcd 0000:00:14.0: @ffff88009892c024 (virt) @9892c024 (dma) 0x2000026 - ep_info2
[   51.372189] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[   51.372705] xhci_hcd 0000:00:14.0: @ffff8800317ab050 (virt) @317ab050 (dma) 0x000000 - tx_info
[   51.373114] xhci_hcd 0000:00:14.0: @ffff88009892c018 (virt) @9892c018 (dma) 0x000000 - rsvd[2]
[   51.373702] xhci_hcd 0000:00:14.0: @ffff88009892d018 (virt) @9892d018 (dma) 0x000000 - rsvd2[4]
[   51.374129] xhci_hcd 0000:00:14.0: @ffff88009892d05c (virt) @9892d05c (dma) 0x000000 - rsvd[2]
[   51.375254] xhci_hcd 0000:00:14.0: Successful Endpoint Configure command
[   51.375290] xhci_hcd 0000:00:14.0: Removing 2 dropped ep ctxs, 10 now active.
[   51.375417] xhci_hcd 0000:00:14.0: @ffff88009892c008 (virt) @9892c008 (dma) 0x000000 - tt_info
[   51.375701] xhci_hcd 0000:00:14.0: @ffff88009892c038 (virt) @9892c038 (dma) 0x000000 - rsvd[1]
[   51.376314] xhci_hcd 0000:00:14.0: // Ding dong!
[   51.381027] Buffer I/O error on device sdb2, logical block 1081344
[   51.381052] lost page write due to I/O error on sdb2
[   51.381068] JBD2: Error -5 detected when updating journal superblock for sdb2-8.
[   51.391638] Buffer I/O error on device sdb1, logical block 0
[   51.391661] lost page write due to I/O error on sdb1
[   51.391677] EXT3-fs (sdb1): I/O error while writing superblock
[   51.404751] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[   51.404792] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   51.436777] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[   51.436819] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   51.468806] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[   51.468831] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   51.500819] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[   51.500847] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   51.500879] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x2a0
[   51.500898] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[   51.500925] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[   51.500947] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   51.501000] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
[   51.501040] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
[   51.501080] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 2 status  = 0xe0002a0
[   51.501111] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 3 status  = 0xe0002a0
[   51.501139] hub 2-0:1.0: hub_suspend
[   51.501163] usb usb2: bus auto-suspend, wakeup 1
[   51.501186] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[   51.520810] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[   55.200631] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[   55.200716] xhci_hcd 0000:00:14.0: resume root hub
[   55.200743] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[   55.200793] usb usb2: usb wakeup-resume
[   55.200807] usb usb2: usb auto-resume
[   55.200837] hub 2-0:1.0: hub_resume
[   55.200878] xhci_hcd 0000:00:14.0: get port status, actual port 0 status  = 0x2a0
[   55.200910] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   55.200965] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x21203
[   55.200995] xhci_hcd 0000:00:14.0: Get port status returned 0x10203
[   55.201025] hub 2-0:1.0: port 2: status 0203 change 0001
[   55.201052] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x1203
[   55.201086] xhci_hcd 0000:00:14.0: get port status, actual port 2 status  = 0x2a0
[   55.201106] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   55.201139] xhci_hcd 0000:00:14.0: get port status, actual port 3 status  = 0x2a0
[   55.201158] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   55.243289] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[   55.303402] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0000
[   55.303461] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x1203
[   55.303491] xhci_hcd 0000:00:14.0: Get port status returned 0x203
[   55.303587] hub 2-0:1.0: port 2, status 0203, change 0000, 5.0 Gb/s
[   55.303625] xhci_hcd 0000:00:14.0: // Ding dong!
[   55.303672] xhci_hcd 0000:00:14.0: Adding 1 ep ctx, 10 now active.
[   55.303727] xhci_hcd 0000:00:14.0: Slot 6 output ctx = 0x9892d000 (dma)
[   55.303754] xhci_hcd 0000:00:14.0: Slot 6 input ctx = 0x9892c000 (dma)
[   55.303794] xhci_hcd 0000:00:14.0: Set slot id 6 dcbaa entry ffff8800317ad030 to 0x9892d000
[   55.303836] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x1203
[   55.303852] xhci_hcd 0000:00:14.0: Get port status returned 0x203
[   55.303921] xhci_hcd 0000:00:14.0: set port reset, actual port 1 status  = 0x1311
[   55.303950] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[   55.303982] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[   55.359431] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x201203
[   55.359470] xhci_hcd 0000:00:14.0: Get port status returned 0x100203
[   55.415475] xhci_hcd 0000:00:14.0: clear port reset change, actual port 1 status  = 0x1203
[   55.415607] xhci_hcd 0000:00:14.0: clear port warm(BH) reset change, actual port 1 status  = 0x1203
[   55.415727] xhci_hcd 0000:00:14.0: clear port link state change, actual port 1 status  = 0x1203
[   55.415840] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x1203
[   55.415951] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x1203
[   55.415975] xhci_hcd 0000:00:14.0: Get port status returned 0x203
[   55.416036] xhci_hcd 0000:00:14.0: Set root hub portnum to 6
[   55.416061] xhci_hcd 0000:00:14.0: Set fake root hub portnum to 2
[   55.416081] xhci_hcd 0000:00:14.0: udev->tt =           (null)
[   55.416099] xhci_hcd 0000:00:14.0: udev->ttport = 0x0
[   55.416114] xhci_hcd 0000:00:14.0: Slot ID 6 Input Context:
[   55.416129] xhci_hcd 0000:00:14.0: @ffff88009892c000 (virt) @9892c000 (dma) 0x000000 - drop flags
[   55.416147] xhci_hcd 0000:00:14.0: @ffff88009892c004 (virt) @9892c004 (dma) 0x000003 - add flags
[   55.416165] xhci_hcd 0000:00:14.0: @ffff88009892c008 (virt) @9892c008 (dma) 0x000000 - rsvd2[0]
[   55.416181] xhci_hcd 0000:00:14.0: @ffff88009892c00c (virt) @9892c00c (dma) 0x000000 - rsvd2[1]
[   55.416199] xhci_hcd 0000:00:14.0: @ffff88009892c010 (virt) @9892c010 (dma) 0x000000 - rsvd2[2]
[   55.416218] xhci_hcd 0000:00:14.0: @ffff88009892c014 (virt) @9892c014 (dma) 0x000000 - rsvd2[3]
[   55.416234] xhci_hcd 0000:00:14.0: @ffff88009892c018 (virt) @9892c018 (dma) 0x000000 - rsvd2[4]
[   55.416370] xhci_hcd 0000:00:14.0: @ffff88009892c034 (virt) @9892c034 (dma) 0x000000 - rsvd[1]
[   55.416641] xhci_hcd 0000:00:14.0: @ffff88009892c074 (virt) @9892c074 (dma) 0x000000 - rsvd[0]
[   55.417029] xhci_hcd 0000:00:14.0: @ffff88009892c004 (virt) @9892c004 (dma) 0x000003 - add flags
[   55.417336] xhci_hcd 0000:00:14.0: @ffff88009892c040 (virt) @9892c040 (dma) 0x000000 - ep_info
[   55.417632] xhci_hcd 0000:00:14.0: @ffff88009892c080 (virt) @9892c080 (dma) 0x000000 - ep_info
[   55.417935] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[   55.418320] xhci_hcd 0000:00:14.0: @ffff88009892d074 (virt) @9892d074 (dma) 0x000000 - rsvd[0]
[   55.432655] usb 2-2: skipped 1 descriptor after endpoint
[   55.432689] usb 2-2: skipped 1 descriptor after endpoint
[   55.432705] usb 2-2: skipped 2 descriptors after endpoint
[   55.432716] usb 2-2: skipped 2 descriptors after endpoint
[   55.432726] usb 2-2: skipped 2 descriptors after endpoint
[   55.432738] usb 2-2: skipped 2 descriptors after endpoint
[   55.432804] xhci_hcd 0000:00:14.0: Waiting for status stage event
[   55.432856] usb 2-2: default language 0x0409
[   55.432960] xhci_hcd 0000:00:14.0: Waiting for status stage event
[   55.433089] xhci_hcd 0000:00:14.0: Waiting for status stage event
[   55.433180] xhci_hcd 0000:00:14.0: Waiting for status stage event
[   55.433240] usb 2-2: udev 3, busnum 2, minor = 130
[   55.433268] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
[   55.433291] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[   55.433315] usb 2-2: Product: Plugable USB3-SATA-UASP1
[   55.433343] usb 2-2: Manufacturer: ASM1053E
[   55.433360] usb 2-2: SerialNumber: 123456789045
[   55.433652] usb 2-2: usb_probe_device
[   55.433669] usb 2-2: configuration #1 chosen from 1 choice
[   55.433715] xhci_hcd 0000:00:14.0: add ep 0x81, slot id 6, new drop flags = 0x0, new add flags = 0x8, new slot info = 0x18400000
[   55.433755] xhci_hcd 0000:00:14.0: add ep 0x2, slot id 6, new drop flags = 0x0, new add flags = 0x18, new slot info = 0x20400000
[   55.433913] xhci_hcd 0000:00:14.0: @ffff88009892c014 (virt) @9892c014 (dma) 0x000000 - rsvd2[3]
[   55.434124] xhci_hcd 0000:00:14.0: @ffff88009892c03c (virt) @9892c03c (dma) 0x000000 - rsvd[3]
[   55.434319] xhci_hcd 0000:00:14.0: @ffff88009892c060 (virt) @9892c060 (dma) 0x000000 - ep_info
[   55.434513] xhci_hcd 0000:00:14.0: @ffff88009892c088 (virt) @9892c088 (dma) 0x30530001 - deq
[   55.434704] xhci_hcd 0000:00:14.0: @ffff88009892c0b4 (virt) @9892c0b4 (dma) 0x000000 - rsvd[0]
[   55.434875] xhci_hcd 0000:00:14.0: Completed config ep cmd
[   55.435058] xhci_hcd 0000:00:14.0: @ffff88009892d00c (virt) @9892d00c (dma) 0x18000006 - dev_state
[   55.435343] xhci_hcd 0000:00:14.0: @ffff88009892d044 (virt) @9892d044 (dma) 0x000000 - ep_info2
[   55.435608] xhci_hcd 0000:00:14.0: @ffff88009892d07c (virt) @9892d07c (dma) 0x000000 - rsvd[2]
[   55.435940] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[   55.436143] xhci_hcd 0000:00:14.0: @ffff8800317ab01c (virt) @317ab01c (dma) 0x000000 - rsvd2[5]
[   55.436369] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[   55.436573] xhci_hcd 0000:00:14.0: // Ding dong!
[   55.436779] xhci_hcd 0000:00:14.0: @ffff88009892d014 (virt) @9892d014 (dma) 0x000000 - rsvd[1]
[   55.437134] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[   55.437384] xhci_hcd 0000:00:14.0: @ffff8800317ab020 (virt) @317ab020 (dma) 0x20400000 - dev_info
[   55.437645] xhci_hcd 0000:00:14.0: @ffff8800317ab048 (virt) @317ab048 (dma) 0x000000 - deq
[   55.437886] xhci_hcd 0000:00:14.0: @ffff88009892d000 (virt) @9892d000 (dma) 0x20400000 - dev_info
[   55.438136] xhci_hcd 0000:00:14.0: @ffff88009892d030 (virt) @9892d030 (dma) 0x000000 - tx_info
[   55.438425] usb-storage 2-2:1.0: usb_probe_interface
[   55.438677] xhci_hcd 0000:00:14.0: @ffff8800317ab008 (virt) @317ab008 (dma) 0x000000 - rsvd2[0]
[   55.438899] xhci_hcd 0000:00:14.0: @ffff8800317ab02c (virt) @317ab02c (dma) 0x18000006 - dev_state
[   55.439146] xhci_hcd 0000:00:14.0: @ffff8800317ab058 (virt) @317ab058 (dma) 0x000000 - rsvd[1]
[   55.439392] xhci_hcd 0000:00:14.0: @ffff88009892d00c (virt) @9892d00c (dma) 0x18000006 - dev_state
[   55.439616] xhci_hcd 0000:00:14.0: @ffff88009892d034 (virt) @9892d034 (dma) 0x000000 - rsvd[0]
[   55.439867] usb-storage 2-2:1.0: Quirks match for vid 174c pid 55aa: 400000
[   55.440329] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[   55.440355] xhci_hcd 0000:00:14.0: Slot 6 Input Context:
[   55.440449] xhci_hcd 0000:00:14.0: @ffff8800317ab00c (virt) @317ab00c (dma) 0x000000 - rsvd2[1]
[   55.440640] xhci_hcd 0000:00:14.0: @ffff8800317ab028 (virt) @317ab028 (dma) 0x000000 - tt_info
[   55.440835] xhci_hcd 0000:00:14.0: @ffff8800317ab044 (virt) @317ab044 (dma) 0x000000 - ep_info2
[   55.441038] xhci_hcd 0000:00:14.0: Successful evaluate context command
[   55.441318] xhci_hcd 0000:00:14.0: @ffff88009892d020 (virt) @9892d020 (dma) 0x000001 - ep_info
[   55.441597] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[   55.441741] xhci_hcd 0000:00:14.0: @ffff8800317ab010 (virt) @317ab010 (dma) 0x000000 - rsvd2[2]
[   55.441908] xhci_hcd 0000:00:14.0: @ffff8800317ab028 (virt) @317ab028 (dma) 0x000000 - tt_info
[   55.442100] xhci_hcd 0000:00:14.0: @ffff8800317ab044 (virt) @317ab044 (dma) 0x000000 - ep_info2
[   55.442372] xhci_hcd 0000:00:14.0: @ffff88009892d000 (virt) @9892d000 (dma) 0x20400000 - dev_info
[   55.442559] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[   55.491460] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[   56.440809] scsi 7:0:0:0: Direct-Access     ASM1053E Plugable USB3-SA 0    PQ: 0 ANSI: 6
[   56.441858] sd 7:0:0:0: Attached scsi generic sg1 type 0
[   56.452916] sd 7:0:0:0: [sdc] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[   56.453087] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[   56.453114] xhci_hcd 0000:00:14.0: Giveback URB ffff880104ea0780, len = 68, expected = 192, status = -121
[   56.453159] xhci_hcd 0000:00:14.0: Stalled endpoint
[   56.453186] xhci_hcd 0000:00:14.0: Giveback URB ffff88008d4576c0, len = 0, expected = 13, status = -32
[   56.453256] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   56.453284] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   56.453312] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   56.453342] xhci_hcd 0000:00:14.0: Finding endpoint context
[   56.453372] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   56.453403] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[   56.453433] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617000 (virtual)
[   56.453460] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530070 (DMA)
[   56.453485] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   56.453510] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617000 (0x30530000 dma), new deq ptr = ffff880030530070 (0x30530070 dma), new cycle = 1
[   56.453537] xhci_hcd 0000:00:14.0: // Ding dong!
[   56.453566] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   56.453595] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530071
[   56.453877] xhci_hcd 0000:00:14.0: Giveback URB ffff88008d4576c0, len = 0, expected = 13, status = -32
[   56.454173] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   56.455417] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[   56.455444] xhci_hcd 0000:00:14.0: Giveback URB ffff88008d457a80, len = 68, expected = 192, status = -121
[   56.455520] xhci_hcd 0000:00:14.0: Stalled endpoint
[   56.455547] xhci_hcd 0000:00:14.0: Giveback URB ffff88008d4576c0, len = 0, expected = 13, status = -32
[   56.455729] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   56.456154] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[   56.456480] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   56.456892]  sdc: sdc1 sdc2 sdc3 sdc4
[   56.458305] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[   56.458330] xhci_hcd 0000:00:14.0: Giveback URB ffff88008d457a80, len = 68, expected = 192, status = -121
[   56.458383] xhci_hcd 0000:00:14.0: Stalled endpoint
[   56.458408] xhci_hcd 0000:00:14.0: Giveback URB ffff88008d4576c0, len = 0, expected = 13, status = -32
[   56.458473] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   56.458562] xhci_hcd 0000:00:14.0: Finding endpoint context
[   56.459030] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[   56.459233] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   56.459491] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   56.462742] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   56.462771] xhci_hcd 0000:00:14.0: Giveback URB ffff880104ea03c0, len = 22, expected = 96, status = -121
[   56.462821] xhci_hcd 0000:00:14.0: Stalled endpoint
[   56.462847] xhci_hcd 0000:00:14.0: Giveback URB ffff88008d4576c0, len = 0, expected = 13, status = -32
[   56.462910] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   56.462933] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   56.462957] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   56.462979] xhci_hcd 0000:00:14.0: Finding endpoint context
[   56.463004] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   56.463026] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[   56.463051] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617000 (virtual)
[   56.463073] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530260 (DMA)
[   56.463098] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   56.463123] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617000 (0x30530000 dma), new deq ptr = ffff880030530260 (0x30530260 dma), new cycle = 1
[   56.463148] xhci_hcd 0000:00:14.0: // Ding dong!
[   56.463176] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   56.463205] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530261
[   56.492575] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   56.492607] xhci_hcd 0000:00:14.0: Giveback URB ffff880104ea0780, len = 22, expected = 96, status = -121
[   56.492655] xhci_hcd 0000:00:14.0: Stalled endpoint
[   56.492679] xhci_hcd 0000:00:14.0: Giveback URB ffff88008d4576c0, len = 0, expected = 13, status = -32
[   56.492740] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   56.492766] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   56.492790] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   56.492813] xhci_hcd 0000:00:14.0: Finding endpoint context
[   56.492836] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   56.492858] xhci_hcd 0000:00:14.0: Cycle state = 0x0
[   56.492884] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617020 (virtual)
[   56.492905] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x9892eb70 (DMA)
[   56.492931] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   56.492955] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617020 (0x9892e800 dma), new deq ptr = ffff88009892eb70 (0x9892eb70 dma), new cycle = 0
[   56.492980] xhci_hcd 0000:00:14.0: // Ding dong!
[   56.493019] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   56.493053] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @9892eb70
[   56.502556] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   56.502584] xhci_hcd 0000:00:14.0: Giveback URB ffff880104a89300, len = 22, expected = 96, status = -121
[   56.502634] xhci_hcd 0000:00:14.0: Stalled endpoint
[   56.502659] xhci_hcd 0000:00:14.0: Giveback URB ffff88008d4576c0, len = 0, expected = 13, status = -32
[   56.502720] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   56.502743] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   56.502768] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   56.502791] xhci_hcd 0000:00:14.0: Finding endpoint context
[   56.502815] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   56.502838] xhci_hcd 0000:00:14.0: Cycle state = 0x0
[   56.502863] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617020 (virtual)
[   56.502886] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x9892ebd0 (DMA)
[   56.502910] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   56.502932] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617020 (0x9892e800 dma), new deq ptr = ffff88009892ebd0 (0x9892ebd0 dma), new cycle = 0
[   56.502960] xhci_hcd 0000:00:14.0: // Ding dong!
[   56.502986] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   56.503017] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @9892ebd0
[   56.512573] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   56.512600] xhci_hcd 0000:00:14.0: Giveback URB ffff880104a89780, len = 22, expected = 96, status = -121
[   56.512646] xhci_hcd 0000:00:14.0: Stalled endpoint
[   56.512673] xhci_hcd 0000:00:14.0: Giveback URB ffff88008d4576c0, len = 0, expected = 13, status = -32
[   56.512730] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   56.512754] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   56.512778] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   56.512800] xhci_hcd 0000:00:14.0: Finding endpoint context
[   56.512824] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   56.512846] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[   56.512870] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617000 (virtual)
[   56.512892] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530120 (DMA)
[   56.512916] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   56.512941] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617000 (0x30530000 dma), new deq ptr = ffff880030530120 (0x30530120 dma), new cycle = 1
[   56.512969] xhci_hcd 0000:00:14.0: // Ding dong!
[   56.512997] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   56.513030] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530121
[   56.513931] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   56.513950] xhci_hcd 0000:00:14.0: Giveback URB ffff880104a89f00, len = 22, expected = 96, status = -121
[   56.513989] xhci_hcd 0000:00:14.0: Stalled endpoint
[   56.514008] xhci_hcd 0000:00:14.0: Giveback URB ffff88008d4576c0, len = 0, expected = 13, status = -32
[   56.514058] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   56.514215] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x305301e0 (DMA)
[   56.522581] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   56.522608] xhci_hcd 0000:00:14.0: Giveback URB ffff880104a89780, len = 22, expected = 96, status = -121
[   56.522656] xhci_hcd 0000:00:14.0: Stalled endpoint
[   56.522678] xhci_hcd 0000:00:14.0: Giveback URB ffff88008d4576c0, len = 0, expected = 13, status = -32
[   56.522736] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   56.522757] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   56.522781] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   56.522804] xhci_hcd 0000:00:14.0: Finding endpoint context
[   56.522828] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   56.522849] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[   56.522871] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617000 (virtual)
[   56.522896] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x305302b0 (DMA)
[   56.522921] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   56.522945] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617000 (0x30530000 dma), new deq ptr = ffff8800305302b0 (0x305302b0 dma), new cycle = 1
[   56.522973] xhci_hcd 0000:00:14.0: // Ding dong!
[   56.523002] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   56.523031] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @305302b1
[   56.532740] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   56.532770] xhci_hcd 0000:00:14.0: Giveback URB ffff880104a89240, len = 22, expected = 96, status = -121
[   56.532821] xhci_hcd 0000:00:14.0: Stalled endpoint
[   56.532845] xhci_hcd 0000:00:14.0: Giveback URB ffff88008d4576c0, len = 0, expected = 13, status = -32
[   56.532909] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   56.532937] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   56.532964] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   56.532988] xhci_hcd 0000:00:14.0: Finding endpoint context
[   56.533012] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   56.533034] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[   56.533059] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617000 (virtual)
[   56.533081] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530380 (DMA)
[   56.533105] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   56.533127] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617000 (0x30530000 dma), new deq ptr = ffff880030530380 (0x30530380 dma), new cycle = 1
[   56.533155] xhci_hcd 0000:00:14.0: // Ding dong!
[   56.533184] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[   56.533212] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530381
[   56.535166] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[   56.535189] xhci_hcd 0000:00:14.0: Giveback URB ffff880104a89240, len = 22, expected = 96, status = -121
[   56.535232] xhci_hcd 0000:00:14.0: Stalled endpoint
[   56.535252] xhci_hcd 0000:00:14.0: Giveback URB ffff88008d4576c0, len = 0, expected = 13, status = -32
[   56.535303] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[   56.535325] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[   56.535348] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   56.535371] xhci_hcd 0000:00:14.0: Finding endpoint context
[   56.535395] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   56.535417] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[   56.535441] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617020 (virtual)
[   56.535465] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x9892e850 (DMA)
[   56.535489] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[   56.535512] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617020 (0x9892e800 dma), new deq ptr = ffff88009892e850 (0x9892e850 dma), new cycle = 1
[   56.535536] xhci_hcd 0000:00:14.0: // Ding dong!
[   56.588890] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdc3
[   56.601777] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdc3
[   56.636752] kjournald starting.  Commit interval 5 seconds
[   56.637026] EXT3-fs (sdc1): using internal journal
[   56.637047] EXT3-fs (sdc1): recovery complete
[   56.637059] EXT3-fs (sdc1): mounted filesystem with ordered data mode
[   56.660782] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdc3
[   56.662907] FAT-fs (sdc4): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[   56.668505] EXT4-fs (sdc2): recovery complete
[   56.670824] EXT4-fs (sdc2): mounted filesystem with ordered data mode. Opts: (null)
[   63.500610] xhci_hcd 0000:00:14.0: add ep 0x1, slot id 2, new drop flags = 0x0, new add flags = 0x4, new slot info = 0x12100001
[   63.500646] xhci_hcd 0000:00:14.0: xhci_check_bandwidth called for udev ffff880030113800
[   63.500686] xhci_hcd 0000:00:14.0: New Input Control Context:
[   63.500713] xhci_hcd 0000:00:14.0: @ffff880031749000 (virt) @31749000 (dma) 0x000000 - drop flags
[   63.500742] xhci_hcd 0000:00:14.0: @ffff880031749004 (virt) @31749004 (dma) 0x000005 - add flags
[   63.500767] xhci_hcd 0000:00:14.0: @ffff880031749008 (virt) @31749008 (dma) 0x000000 - rsvd2[0]
[   63.500794] xhci_hcd 0000:00:14.0: @ffff88003174900c (virt) @3174900c (dma) 0x000000 - rsvd2[1]
[   63.500820] xhci_hcd 0000:00:14.0: @ffff880031749010 (virt) @31749010 (dma) 0x000000 - rsvd2[2]
[   63.500847] xhci_hcd 0000:00:14.0: @ffff880031749014 (virt) @31749014 (dma) 0x000000 - rsvd2[3]
[   63.500874] xhci_hcd 0000:00:14.0: @ffff880031749018 (virt) @31749018 (dma) 0x000000 - rsvd2[4]
[   63.500902] xhci_hcd 0000:00:14.0: @ffff88003174901c (virt) @3174901c (dma) 0x000000 - rsvd2[5]
[   63.500929] xhci_hcd 0000:00:14.0: Slot Context:
[   63.500956] xhci_hcd 0000:00:14.0: @ffff880031749020 (virt) @31749020 (dma) 0x12100001 - dev_info
[   63.500980] xhci_hcd 0000:00:14.0: @ffff880031749024 (virt) @31749024 (dma) 0x010000 - dev_info2
[   63.501008] xhci_hcd 0000:00:14.0: @ffff880031749028 (virt) @31749028 (dma) 0x000101 - tt_info
[   63.501033] xhci_hcd 0000:00:14.0: @ffff88003174902c (virt) @3174902c (dma) 0x000000 - dev_state
[   63.501060] xhci_hcd 0000:00:14.0: @ffff880031749030 (virt) @31749030 (dma) 0x000000 - rsvd[0]
[   63.501114] xhci_hcd 0000:00:14.0: @ffff880031749038 (virt) @31749038 (dma) 0x000000 - rsvd[2]
[   63.501372] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
[   63.501734] xhci_hcd 0000:00:14.0: // Ding dong!
[   63.502160] xhci_hcd 0000:00:14.0: @ffff880031196020 (virt) @31196020 (dma) 0x000001 - ep_info
[   63.502673] xhci_hcd 0000:00:14.0: Endpoint 0x1 not halted, refusing to reset.
[   63.727771] xhci_hcd 0000:00:14.0: Cancel URB ffff8800ca08ee00, dev 1.1, ep 0x1, starting at offset 0x8d45b730
[   63.727811] xhci_hcd 0000:00:14.0: // Ding dong!
[   63.727843] xhci_hcd 0000:00:14.0: Cancel URB ffff8800ca08f000, dev 1.1, ep 0x1, starting at offset 0x8d45b630
[   63.727869] xhci_hcd 0000:00:14.0: Cancel URB ffff8800ca08dc00, dev 1.1, ep 0x1, starting at offset 0x8d45b6b0
[   63.729735] xhci_hcd 0000:00:14.0: Stopped on Transfer TRB
[   63.729768] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b730 (dma).
[   63.729797] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b730
[   63.729829] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b740 (dma).
[   63.729860] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b740
[   63.729890] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b750 (dma).
[   63.729917] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b750
[   63.729948] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b760 (dma).
[   63.729974] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b760
[   63.730004] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b770 (dma).
[   63.730033] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b770
[   63.730064] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b780 (dma).
[   63.730093] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b780
[   63.730123] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b790 (dma).
[   63.730150] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b790
[   63.730179] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b7a0 (dma).
[   63.730208] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b7a0
[   63.730293] xhci_hcd 0000:00:14.0: Finding endpoint context
[   63.730553] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b660 (dma).
[   63.730961] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b6d0 (dma).
[   63.731308] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617580 (0x8d45b400 dma), new deq ptr = ffff88008d45b640 (0x8d45b640 dma), new cycle = 0
[   63.732890] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff880030113800
[   63.732930] xhci_hcd 0000:00:14.0: drop ep 0x1, slot id 2, new drop flags = 0x4, new add flags = 0x0, new slot info = 0xa100001
[   63.732952] xhci_hcd 0000:00:14.0: xhci_check_bandwidth called for udev ffff880030113800
[   63.732974] xhci_hcd 0000:00:14.0: New Input Control Context:
[   63.732996] xhci_hcd 0000:00:14.0: @ffff880031749000 (virt) @31749000 (dma) 0x000004 - drop flags
[   63.733355] xhci_hcd 0000:00:14.0: @ffff880031749038 (virt) @31749038 (dma) 0x000000 - rsvd[2]
[   63.733656] xhci_hcd 0000:00:14.0: Recalculating BW for TT slot 1 port 1
[   63.734010] xhci_hcd 0000:00:14.0: @ffff880031196010 (virt) @31196010 (dma) 0x000000 - rsvd[0]
[   63.736691] xhci_hcd 0000:00:14.0: add ep 0x1, slot id 2, new drop flags = 0x0, new add flags = 0x4, new slot info = 0x12100001
[   63.736731] xhci_hcd 0000:00:14.0: xhci_check_bandwidth called for udev ffff880030113800
[   63.736756] xhci_hcd 0000:00:14.0: New Input Control Context:
[   63.736775] xhci_hcd 0000:00:14.0: @ffff880031749000 (virt) @31749000 (dma) 0x000000 - drop flags
[   63.736796] xhci_hcd 0000:00:14.0: @ffff880031749004 (virt) @31749004 (dma) 0x000005 - add flags
[   63.736837] xhci_hcd 0000:00:14.0: @ffff880031749008 (virt) @31749008 (dma) 0x000000 - rsvd2[0]
[   63.736866] xhci_hcd 0000:00:14.0: @ffff88003174900c (virt) @3174900c (dma) 0x000000 - rsvd2[1]
[   63.736894] xhci_hcd 0000:00:14.0: @ffff880031749010 (virt) @31749010 (dma) 0x000000 - rsvd2[2]
[   63.737419] xhci_hcd 0000:00:14.0: @ffff880031749058 (virt) @31749058 (dma) 0x000000 - rsvd[1]
[   63.737759] xhci_hcd 0000:00:14.0: Recalculating BW for TT slot 1 port 1
[   63.737960] xhci_hcd 0000:00:14.0: Completed config ep cmd
[   63.738166] xhci_hcd 0000:00:14.0: @ffff880031196000 (virt) @31196000 (dma) 0x12100001 - dev_info
[   63.738406] xhci_hcd 0000:00:14.0: @ffff880031196020 (virt) @31196020 (dma) 0x000001 - ep_info
[   63.738650] xhci_hcd 0000:00:14.0: @ffff880031196044 (virt) @31196044 (dma) 0xc80008 - ep_info2
[   63.738942] xhci_hcd 0000:00:14.0: Endpoint 0x1 not halted, refusing to reset.
[   65.873840] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[   65.873892] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[   65.873972] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[   65.874014] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x4202c0
[   65.874041] xhci_hcd 0000:00:14.0: Get port status returned 0x4102c0
[   65.874087] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x4002c0
[   65.874125] xhci_hcd 0000:00:14.0: clear port link state change, actual port 1 status  = 0x2c0
[   65.874153] hub 2-0:1.0: warm reset port 2
[   65.914268] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[   65.926320] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2b0
[   65.926361] xhci_hcd 0000:00:14.0: Get port status returned 0x2b0
[   65.926462] hub 2-0:1.0: port 2 not warm reset yet, waiting 50ms
[   65.973226] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[   65.973335] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[   65.982355] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2802a0
[   65.982402] xhci_hcd 0000:00:14.0: Get port status returned 0x3002a0
[   65.982477] xhci_hcd 0000:00:14.0: clear port reset change, actual port 1 status  = 0x802a0
[   65.982551] xhci_hcd 0000:00:14.0: clear port warm(BH) reset change, actual port 1 status  = 0x2a0
[   65.982626] xhci_hcd 0000:00:14.0: clear port link state change, actual port 1 status  = 0x2a0
[   65.982699] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x2a0
[   65.982781] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[   65.982807] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   65.982851] xhci_hcd 0000:00:14.0: Disable port 1
[   65.982891] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x280
[   65.982911] xhci_hcd 0000:00:14.0: Get port status returned 0x280
[   65.982959] xhci_hcd 0000:00:14.0: Enable port 1
[   65.983002] hub 2-0:1.0: port 2, status 02c0, change 0041, 5.0 Gb/s
[   65.983019] usb 2-2: USB disconnect, device number 3
[   65.983033] usb 2-2: unregistering device
[   65.983045] usb 2-2: unregistering interface 2-2:1.0
[   65.983169] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[   65.983208] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[   65.983226] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[   65.983248] xhci_hcd 0000:00:14.0: Slot 6 Input Context:
[   65.983463] xhci_hcd 0000:00:14.0: @ffff8800317ab020 (virt) @317ab020 (dma) 0x20400000 - dev_info
[   65.983785] xhci_hcd 0000:00:14.0: @ffff8800317ab05c (virt) @317ab05c (dma) 0x000000 - rsvd[2]
[   65.984000] xhci_hcd 0000:00:14.0: @ffff88009892d008 (virt) @9892d008 (dma) 0x000000 - tt_info
[   65.984205] xhci_hcd 0000:00:14.0: @ffff88009892d030 (virt) @9892d030 (dma) 0x000000 - tx_info
[   65.993562] Aborting journal on device sdc2-8.
[   65.993594] JBD2: Error -5 detected when updating journal superblock for sdc2-8.
[   65.993611] journal commit I/O error
[   65.998044] sd 7:0:0:0: [sdc] Synchronizing SCSI cache
[   65.998172] sd 7:0:0:0: [sdc]  
[   65.998193] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[   65.998466] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[   65.998508] xhci_hcd 0000:00:14.0: Slot 6 Input Context:
[   65.998533] xhci_hcd 0000:00:14.0: @ffff8800317ab000 (virt) @317ab000 (dma) 0x000000 - drop flags
[   65.998559] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[   65.998587] xhci_hcd 0000:00:14.0: @ffff8800317ab008 (virt) @317ab008 (dma) 0x000000 - rsvd2[0]
[   65.998613] xhci_hcd 0000:00:14.0: @ffff8800317ab00c (virt) @317ab00c (dma) 0x000000 - rsvd2[1]
[   65.998639] xhci_hcd 0000:00:14.0: @ffff8800317ab010 (virt) @317ab010 (dma) 0x000000 - rsvd2[2]
[   65.998667] xhci_hcd 0000:00:14.0: @ffff8800317ab014 (virt) @317ab014 (dma) 0x000000 - rsvd2[3]
[   65.998695] xhci_hcd 0000:00:14.0: @ffff8800317ab018 (virt) @317ab018 (dma) 0x000000 - rsvd2[4]
[   65.998723] xhci_hcd 0000:00:14.0: @ffff8800317ab01c (virt) @317ab01c (dma) 0x000000 - rsvd2[5]
[   65.998750] xhci_hcd 0000:00:14.0: Slot Context:
[   65.998773] xhci_hcd 0000:00:14.0: @ffff8800317ab020 (virt) @317ab020 (dma) 0x20400000 - dev_info
[   65.998799] xhci_hcd 0000:00:14.0: @ffff8800317ab024 (virt) @317ab024 (dma) 0x06000a - dev_info2
[   65.998825] xhci_hcd 0000:00:14.0: @ffff8800317ab028 (virt) @317ab028 (dma) 0x000000 - tt_info
[   65.998853] xhci_hcd 0000:00:14.0: @ffff8800317ab02c (virt) @317ab02c (dma) 0x18000006 - dev_state
[   65.998882] xhci_hcd 0000:00:14.0: @ffff8800317ab030 (virt) @317ab030 (dma) 0x000000 - rsvd[0]
[   65.998911] xhci_hcd 0000:00:14.0: @ffff8800317ab034 (virt) @317ab034 (dma) 0x000000 - rsvd[1]
[   65.998968] xhci_hcd 0000:00:14.0: @ffff8800317ab03c (virt) @317ab03c (dma) 0x000000 - rsvd[3]
[   65.999189] xhci_hcd 0000:00:14.0: @ffff8800317ab05c (virt) @317ab05c (dma) 0x000000 - rsvd[2]
[   65.999410] xhci_hcd 0000:00:14.0: @ffff88009892d004 (virt) @9892d004 (dma) 0x06000a - dev_info2
[   65.999831] usb 2-2: usb_set_device_initiated_lpm: Can't enable U1 state for unconfigured device.
[   66.000110] xhci_hcd 0000:00:14.0: Slot Context:
[   66.000406] xhci_hcd 0000:00:14.0: @ffff8800317ab044 (virt) @317ab044 (dma) 0x000000 - ep_info2
[   66.001457] xhci_hcd 0000:00:14.0: Successful evaluate context command
[   66.001500] xhci_hcd 0000:00:14.0: Slot 6 Output Context:
[   66.001526] xhci_hcd 0000:00:14.0: Slot Context:
[   66.001551] xhci_hcd 0000:00:14.0: @ffff88009892d000 (virt) @9892d000 (dma) 0x20400000 - dev_info
[   66.001813] xhci_hcd 0000:00:14.0: @ffff88009892d024 (virt) @9892d024 (dma) 0x2000026 - ep_info2
[   66.002130] usb 2-2: usb_set_device_initiated_lpm: Can't enable U2 state for unconfigured device.
[   66.002317] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[   66.002577] xhci_hcd 0000:00:14.0: @ffff8800317ab018 (virt) @317ab018 (dma) 0x000000 - rsvd2[4]
[   66.002853] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[   66.003212] xhci_hcd 0000:00:14.0: Successful evaluate context command
[   66.003446] xhci_hcd 0000:00:14.0: @ffff88009892d018 (virt) @9892d018 (dma) 0x000000 - rsvd[2]
[   66.003803] xhci_hcd 0000:00:14.0: drop ep 0x2, slot id 6, new drop flags = 0x18, new add flags = 0x0, new slot info = 0x8400000
[   66.004170] xhci_hcd 0000:00:14.0: @ffff88009892c034 (virt) @9892c034 (dma) 0x000000 - rsvd[1]
[   66.004557] xhci_hcd 0000:00:14.0: Successful Endpoint Configure command
[   66.004870] xhci_hcd 0000:00:14.0: @ffff88009892d024 (virt) @9892d024 (dma) 0x2000026 - ep_info2
[   66.005236] xhci_hcd 0000:00:14.0: // Ding dong!
[   66.034186] Buffer I/O error on device sdc1, logical block 0
[   66.034210] lost page write due to I/O error on sdc1
[   66.034226] EXT3-fs (sdc1): I/O error while writing superblock
[   66.034354] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[   66.034391] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   66.066379] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[   66.066412] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   66.098403] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[   66.098448] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   66.130436] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[   66.130480] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   66.130545] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x2a0
[   66.130567] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[   66.130593] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[   66.130612] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[   66.130684] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
[   66.130731] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
[   66.130780] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 2 status  = 0xe0002a0
[   66.130831] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 3 status  = 0xe0002a0
[   66.130865] hub 2-0:1.0: hub_suspend
[   66.130889] usb usb2: bus auto-suspend, wakeup 1
[   66.130923] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[   66.162431] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[   66.209786] EXT4-fs error (device sdc2): ext4_put_super:772: Couldn't clean up the journal
[   66.209857] EXT4-fs (sdc2): Remounting filesystem read-only
[   71.199280] xhci_hcd 0000:00:14.0: Cancel URB ffff8800ca08dc00, dev 1.1, ep 0x1, starting at offset 0x8d45b940
[   71.199366] xhci_hcd 0000:00:14.0: // Ding dong!
[   71.199435] xhci_hcd 0000:00:14.0: Cancel URB ffff8800ca08f000, dev 1.1, ep 0x1, starting at offset 0x8d45b9c0
[   71.199508] xhci_hcd 0000:00:14.0: Cancel URB ffff8800ca08ee00, dev 1.1, ep 0x1, starting at offset 0x8d45ba40
[   71.201433] xhci_hcd 0000:00:14.0: Stopped on Transfer TRB
[   71.201519] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b950 (dma).
[   71.201578] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[   71.201644] xhci_hcd 0000:00:14.0: Finding endpoint context
[   71.201704] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[   71.201771] xhci_hcd 0000:00:14.0: Cycle state = 0x0
[   71.201832] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617a60 (virtual)
[   71.201895] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x8d45b960 (DMA)
[   71.201953] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b960 (dma).
[   71.202014] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b960
[   71.202073] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b970 (dma).
[   71.202137] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b970
[   71.202197] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b980 (dma).
[   71.202261] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b980
[   71.202320] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b990 (dma).
[   71.202378] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b990
[   71.202442] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b9a0 (dma).
[   71.202503] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b9a0
[   71.202565] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45b9b0 (dma).
[   71.202626] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b9b0
[   71.202866] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45b9d0
[   71.203169] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45ba00 (dma).
[   71.203462] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45ba20
[   71.203876] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x8d45ba60 (dma).
[   71.204291] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45ba90
[   71.204530] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x8d45bab0
[   71.204945] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff880030113800
[   71.205123] xhci_hcd 0000:00:14.0: @ffff880031749000 (virt) @31749000 (dma) 0x000004 - drop flags
[   71.205444] xhci_hcd 0000:00:14.0: @ffff88003174901c (virt) @3174901c (dma) 0x000000 - rsvd2[5]
[   71.205660] xhci_hcd 0000:00:14.0: @ffff88003174902c (virt) @3174902c (dma) 0x000000 - dev_state
[   71.205954] xhci_hcd 0000:00:14.0: @ffff880031749040 (virt) @31749040 (dma) 0x000000 - ep_info
[   71.206259] xhci_hcd 0000:00:14.0: Adding 0 ep ctxs, 10 now active.
[   71.206544] xhci_hcd 0000:00:14.0: // Ding dong!
[   71.206877] xhci_hcd 0000:00:14.0: @ffff880031196000 (virt) @31196000 (dma) 0xa100001 - dev_info
[   71.207319] xhci_hcd 0000:00:14.0: Cached old ring, 18 rings cached
[  145.141631] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[  145.141716] xhci_hcd 0000:00:14.0: resume root hub
[  145.141769] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[  145.141860] usb usb2: usb wakeup-resume
[  145.141908] usb usb2: usb auto-resume
[  145.141975] hub 2-0:1.0: hub_resume
[  145.142084] xhci_hcd 0000:00:14.0: get port status, actual port 0 status  = 0x2a0
[  145.142147] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  145.142353] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x21203
[  145.142425] xhci_hcd 0000:00:14.0: Get port status returned 0x10203
[  145.142514] hub 2-0:1.0: port 2: status 0203 change 0001
[  145.142592] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x1203
[  145.142684] xhci_hcd 0000:00:14.0: get port status, actual port 2 status  = 0x2a0
[  145.142728] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  145.142803] xhci_hcd 0000:00:14.0: get port status, actual port 3 status  = 0x2a0
[  145.142846] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  145.246438] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0000
[  145.246528] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x1203
[  145.246582] xhci_hcd 0000:00:14.0: Get port status returned 0x203
[  145.246719] hub 2-0:1.0: port 2, status 0203, change 0000, 5.0 Gb/s
[  145.246773] xhci_hcd 0000:00:14.0: // Ding dong!
[  145.246866] xhci_hcd 0000:00:14.0: Adding 1 ep ctx, 10 now active.
[  145.246960] xhci_hcd 0000:00:14.0: Slot 7 output ctx = 0x9892d000 (dma)
[  145.247014] xhci_hcd 0000:00:14.0: Slot 7 input ctx = 0x9892c000 (dma)
[  145.247116] xhci_hcd 0000:00:14.0: Set slot id 7 dcbaa entry ffff8800317ad038 to 0x9892d000
[  145.247210] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x1203
[  145.247257] xhci_hcd 0000:00:14.0: Get port status returned 0x203
[  145.247416] xhci_hcd 0000:00:14.0: set port reset, actual port 1 status  = 0x1311
[  145.247493] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[  145.247577] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[  145.302478] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x201203
[  145.302554] xhci_hcd 0000:00:14.0: Get port status returned 0x100203
[  145.358532] xhci_hcd 0000:00:14.0: clear port reset change, actual port 1 status  = 0x1203
[  145.358721] xhci_hcd 0000:00:14.0: clear port warm(BH) reset change, actual port 1 status  = 0x1203
[  145.358903] xhci_hcd 0000:00:14.0: clear port link state change, actual port 1 status  = 0x1203
[  145.359069] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x1203
[  145.359242] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x1203
[  145.359306] xhci_hcd 0000:00:14.0: Get port status returned 0x203
[  145.359431] xhci_hcd 0000:00:14.0: Set root hub portnum to 6
[  145.359495] xhci_hcd 0000:00:14.0: Set fake root hub portnum to 2
[  145.359534] xhci_hcd 0000:00:14.0: udev->tt =           (null)
[  145.359576] xhci_hcd 0000:00:14.0: udev->ttport = 0x0
[  145.359616] xhci_hcd 0000:00:14.0: Slot ID 7 Input Context:
[  145.359654] xhci_hcd 0000:00:14.0: @ffff88009892c000 (virt) @9892c000 (dma) 0x000000 - drop flags
[  145.359697] xhci_hcd 0000:00:14.0: @ffff88009892c004 (virt) @9892c004 (dma) 0x000003 - add flags
[  145.359740] xhci_hcd 0000:00:14.0: @ffff88009892c008 (virt) @9892c008 (dma) 0x000000 - rsvd2[0]
[  145.359782] xhci_hcd 0000:00:14.0: @ffff88009892c00c (virt) @9892c00c (dma) 0x000000 - rsvd2[1]
[  145.359825] xhci_hcd 0000:00:14.0: @ffff88009892c010 (virt) @9892c010 (dma) 0x000000 - rsvd2[2]
[  145.359866] xhci_hcd 0000:00:14.0: @ffff88009892c014 (virt) @9892c014 (dma) 0x000000 - rsvd2[3]
[  145.359904] xhci_hcd 0000:00:14.0: @ffff88009892c018 (virt) @9892c018 (dma) 0x000000 - rsvd2[4]
[  145.359945] xhci_hcd 0000:00:14.0: @ffff88009892c01c (virt) @9892c01c (dma) 0x000000 - rsvd2[5]
[  145.359985] xhci_hcd 0000:00:14.0: Slot Context:
[  145.360104] xhci_hcd 0000:00:14.0: @ffff88009892c028 (virt) @9892c028 (dma) 0x000000 - tt_info
[  145.360384] xhci_hcd 0000:00:14.0: @ffff88009892c040 (virt) @9892c040 (dma) 0x000000 - ep_info
[  145.360624] xhci_hcd 0000:00:14.0: @ffff88009892c05c (virt) @9892c05c (dma) 0x000000 - rsvd[2]
[  145.360901] xhci_hcd 0000:00:14.0: @ffff88009892c078 (virt) @9892c078 (dma) 0x000000 - rsvd[1]
[  145.361179] xhci_hcd 0000:00:14.0: @ffff88009892c094 (virt) @9892c094 (dma) 0x000000 - rsvd[0]
[  145.361486] xhci_hcd 0000:00:14.0: Slot ID 7 dcbaa entry @ffff8800317ad038 = 0x0000009892d000
[  145.361738] xhci_hcd 0000:00:14.0: @ffff88009892c00c (virt) @9892c00c (dma) 0x000000 - rsvd2[1]
[  145.362070] xhci_hcd 0000:00:14.0: @ffff88009892c028 (virt) @9892c028 (dma) 0x000000 - tt_info
[  145.362375] xhci_hcd 0000:00:14.0: @ffff88009892c040 (virt) @9892c040 (dma) 0x000000 - ep_info
[  145.362703] xhci_hcd 0000:00:14.0: @ffff88009892c05c (virt) @9892c05c (dma) 0x000000 - rsvd[2]
[  145.363072] xhci_hcd 0000:00:14.0: @ffff88009892c078 (virt) @9892c078 (dma) 0x000000 - rsvd[1]
[  145.363352] xhci_hcd 0000:00:14.0: @ffff88009892c090 (virt) @9892c090 (dma) 0x000000 - tx_info
[  145.363598] xhci_hcd 0000:00:14.0: @ffff88009892d000 (virt) @9892d000 (dma) 0x8400000 - dev_info
[  145.363858] xhci_hcd 0000:00:14.0: @ffff88009892d018 (virt) @9892d018 (dma) 0x000000 - rsvd[2]
[  145.364155] xhci_hcd 0000:00:14.0: @ffff88009892d034 (virt) @9892d034 (dma) 0x000000 - rsvd[0]
[  145.364416] xhci_hcd 0000:00:14.0: @ffff88009892d048 (virt) @9892d048 (dma) 0x000000 - deq
[  145.364674] xhci_hcd 0000:00:14.0: @ffff88009892d060 (virt) @9892d060 (dma) 0x000000 - ep_info
[  145.379467] usb 2-2: skipped 1 descriptor after endpoint
[  145.379504] usb 2-2: skipped 1 descriptor after endpoint
[  145.379539] usb 2-2: skipped 2 descriptors after endpoint
[  145.379566] usb 2-2: skipped 2 descriptors after endpoint
[  145.379599] usb 2-2: skipped 2 descriptors after endpoint
[  145.379626] usb 2-2: skipped 2 descriptors after endpoint
[  145.379745] xhci_hcd 0000:00:14.0: Waiting for status stage event
[  145.379814] usb 2-2: default language 0x0409
[  145.379958] xhci_hcd 0000:00:14.0: Waiting for status stage event
[  145.380171] xhci_hcd 0000:00:14.0: Waiting for status stage event
[  145.380353] xhci_hcd 0000:00:14.0: Waiting for status stage event
[  145.380416] usb 2-2: udev 4, busnum 2, minor = 131
[  145.380439] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
[  145.380464] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[  145.380487] usb 2-2: Product: Plugable USB3-SATA-UASP1
[  145.380508] usb 2-2: Manufacturer: ASM1053E
[  145.380532] usb 2-2: SerialNumber: 123456789045
[  145.381189] usb 2-2: usb_probe_device
[  145.381232] usb 2-2: configuration #1 chosen from 1 choice
[  145.381331] xhci_hcd 0000:00:14.0: add ep 0x81, slot id 7, new drop flags = 0x0, new add flags = 0x8, new slot info = 0x18400000
[  145.381430] xhci_hcd 0000:00:14.0: add ep 0x2, slot id 7, new drop flags = 0x0, new add flags = 0x18, new slot info = 0x20400000
[  145.381478] xhci_hcd 0000:00:14.0: xhci_check_bandwidth called for udev ffff8800b7a3c800
[  145.381525] xhci_hcd 0000:00:14.0: New Input Control Context:
[  145.381566] xhci_hcd 0000:00:14.0: @ffff88009892c000 (virt) @9892c000 (dma) 0x000000 - drop flags
[  145.381612] xhci_hcd 0000:00:14.0: @ffff88009892c004 (virt) @9892c004 (dma) 0x000019 - add flags
[  145.381659] xhci_hcd 0000:00:14.0: @ffff88009892c008 (virt) @9892c008 (dma) 0x000000 - rsvd2[0]
[  145.381706] xhci_hcd 0000:00:14.0: @ffff88009892c00c (virt) @9892c00c (dma) 0x000000 - rsvd2[1]
[  145.381755] xhci_hcd 0000:00:14.0: @ffff88009892c010 (virt) @9892c010 (dma) 0x000000 - rsvd2[2]
[  145.381886] xhci_hcd 0000:00:14.0: @ffff88009892c01c (virt) @9892c01c (dma) 0x000000 - rsvd2[5]
[  145.382108] xhci_hcd 0000:00:14.0: @ffff88009892c02c (virt) @9892c02c (dma) 0x000000 - dev_state
[  145.382292] xhci_hcd 0000:00:14.0: @ffff88009892c03c (virt) @9892c03c (dma) 0x000000 - rsvd[3]
[  145.382389] xhci_hcd 0000:00:14.0: @ffff88009892c040 (virt) @9892c040 (dma) 0x000000 - ep_info
[  145.382576] xhci_hcd 0000:00:14.0: @ffff88009892c050 (virt) @9892c050 (dma) 0x000000 - tx_info
[  145.382696] xhci_hcd 0000:00:14.0: @ffff88009892c058 (virt) @9892c058 (dma) 0x000000 - rsvd[1]
[  145.382904] xhci_hcd 0000:00:14.0: @ffff88009892c064 (virt) @9892c064 (dma) 0x000000 - ep_info2
[  145.383220] xhci_hcd 0000:00:14.0: @ffff88009892c080 (virt) @9892c080 (dma) 0x000000 - ep_info
[  145.383475] xhci_hcd 0000:00:14.0: @ffff88009892c098 (virt) @9892c098 (dma) 0x000000 - rsvd[1]
[  145.383803] xhci_hcd 0000:00:14.0: @ffff88009892c0b4 (virt) @9892c0b4 (dma) 0x000000 - rsvd[0]
[  145.384140] xhci_hcd 0000:00:14.0: Completed config ep cmd
[  145.384419] xhci_hcd 0000:00:14.0: @ffff88009892d004 (virt) @9892d004 (dma) 0x060000 - dev_info2
[  145.384689] xhci_hcd 0000:00:14.0: @ffff88009892d01c (virt) @9892d01c (dma) 0x000000 - rsvd[3]
[  145.385043] xhci_hcd 0000:00:14.0: @ffff88009892d03c (virt) @9892d03c (dma) 0x000000 - rsvd[2]
[  145.385355] xhci_hcd 0000:00:14.0: @ffff88009892d058 (virt) @9892d058 (dma) 0x000000 - rsvd[1]
[  145.385587] xhci_hcd 0000:00:14.0: @ffff88009892d068 (virt) @9892d068 (dma) 0x30530001 - deq
[  145.385855] xhci_hcd 0000:00:14.0: @ffff88009892d080 (virt) @9892d080 (dma) 0x000001 - ep_info
[  145.386122] xhci_hcd 0000:00:14.0: @ffff88009892d09c (virt) @9892d09c (dma) 0x000000 - rsvd[2]
[  145.386542] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[  145.386663] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[  145.387032] xhci_hcd 0000:00:14.0: @ffff8800317ab030 (virt) @317ab030 (dma) 0x000000 - rsvd[0]
[  145.387463] xhci_hcd 0000:00:14.0: Successful evaluate context command
[  145.387810] xhci_hcd 0000:00:14.0: @ffff88009892d010 (virt) @9892d010 (dma) 0x000000 - rsvd[0]
[  145.388189] xhci_hcd 0000:00:14.0: @ffff88009892d030 (virt) @9892d030 (dma) 0x000000 - tx_info
[  145.388605] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[  145.388911] xhci_hcd 0000:00:14.0: Slot Context:
[  145.389145] xhci_hcd 0000:00:14.0: @ffff8800317ab03c (virt) @317ab03c (dma) 0x000000 - rsvd[3]
[  145.389480] xhci_hcd 0000:00:14.0: Successful evaluate context command
[  145.389729] xhci_hcd 0000:00:14.0: @ffff88009892d008 (virt) @9892d008 (dma) 0x000000 - tt_info
[  145.390062] xhci_hcd 0000:00:14.0: @ffff88009892d020 (virt) @9892d020 (dma) 0x000001 - ep_info
[  145.390520] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[  145.390764] usb-storage 2-2:1.0: usb_probe_interface
[  145.391144] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[  145.391295] xhci_hcd 0000:00:14.0: @ffff8800317ab00c (virt) @317ab00c (dma) 0x000000 - rsvd2[1]
[  145.391608] xhci_hcd 0000:00:14.0: @ffff8800317ab034 (virt) @317ab034 (dma) 0x000000 - rsvd[1]
[  145.391870] xhci_hcd 0000:00:14.0: @ffff8800317ab058 (virt) @317ab058 (dma) 0x000000 - rsvd[1]
[  145.392162] xhci_hcd 0000:00:14.0: @ffff88009892d000 (virt) @9892d000 (dma) 0x20400000 - dev_info
[  145.392493] xhci_hcd 0000:00:14.0: @ffff88009892d01c (virt) @9892d01c (dma) 0x000000 - rsvd[3]
[  145.392783] xhci_hcd 0000:00:14.0: @ffff88009892d034 (virt) @9892d034 (dma) 0x000000 - rsvd[0]
[  145.393189] scsi8 : usb-storage 2-2:1.0
[  145.394127] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[  145.394185] xhci_hcd 0000:00:14.0: Slot 7 Input Context:
[  145.394231] xhci_hcd 0000:00:14.0: @ffff8800317ab000 (virt) @317ab000 (dma) 0x000000 - drop flags
[  145.394282] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[  145.394471] xhci_hcd 0000:00:14.0: @ffff8800317ab010 (virt) @317ab010 (dma) 0x000000 - rsvd2[2]
[  145.394758] xhci_hcd 0000:00:14.0: @ffff8800317ab028 (virt) @317ab028 (dma) 0x000000 - tt_info
[  145.395125] xhci_hcd 0000:00:14.0: @ffff8800317ab040 (virt) @317ab040 (dma) 0x000000 - ep_info
[  145.395436] xhci_hcd 0000:00:14.0: @ffff8800317ab05c (virt) @317ab05c (dma) 0x000000 - rsvd[2]
[  145.395741] xhci_hcd 0000:00:14.0: @ffff88009892d000 (virt) @9892d000 (dma) 0x20400000 - dev_info
[  145.396086] xhci_hcd 0000:00:14.0: @ffff88009892d030 (virt) @9892d030 (dma) 0x000000 - tx_info
[  145.396404] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[  145.396713] xhci_hcd 0000:00:14.0: @ffff8800317ab010 (virt) @317ab010 (dma) 0x000000 - rsvd2[2]
[  145.397017] xhci_hcd 0000:00:14.0: @ffff8800317ab024 (virt) @317ab024 (dma) 0x0607ff - dev_info2
[  145.397375] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[  145.397633] xhci_hcd 0000:00:14.0: @ffff8800317ab054 (virt) @317ab054 (dma) 0x000000 - rsvd[0]
[  145.397850] xhci_hcd 0000:00:14.0: // Ding dong!
[  145.398154] xhci_hcd 0000:00:14.0: @ffff88009892d010 (virt) @9892d010 (dma) 0x000000 - rsvd[0]
[  145.398385] xhci_hcd 0000:00:14.0: @ffff88009892d030 (virt) @9892d030 (dma) 0x000000 - tx_info
[  145.574594] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[  146.392432] scsi 8:0:0:0: Direct-Access     ASM1053E Plugable USB3-SA 0    PQ: 0 ANSI: 6
[  146.395031] sd 8:0:0:0: Attached scsi generic sg1 type 0
[  146.396629] sd 8:0:0:0: [sdc] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[  146.396930] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[  146.396990] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144bb40, len = 68, expected = 192, status = -121
[  146.397086] xhci_hcd 0000:00:14.0: Stalled endpoint
[  146.397141] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144b3c0, len = 0, expected = 13, status = -32
[  146.397353] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  146.397412] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  146.397475] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  146.397542] xhci_hcd 0000:00:14.0: Finding endpoint context
[  146.397610] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  146.397673] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  146.397737] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617f40 (virtual)
[  146.397799] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530070 (DMA)
[  146.397859] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  146.397923] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617f40 (0x30530000 dma), new deq ptr = ffff880030530070 (0x30530070 dma), new cycle = 1
[  146.397992] xhci_hcd 0000:00:14.0: // Ding dong!
[  146.398070] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  146.398137] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530071
[  146.398251] sd 8:0:0:0: [sdc] Write Protect is off
[  146.398294] sd 8:0:0:0: [sdc] Mode Sense: 43 00 00 00
[  146.400741] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[  146.400807] xhci_hcd 0000:00:14.0: Giveback URB ffff880030a32540, len = 68, expected = 192, status = -121
[  146.400908] xhci_hcd 0000:00:14.0: Stalled endpoint
[  146.400959] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144b3c0, len = 0, expected = 13, status = -32
[  146.401081] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  146.401139] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  146.401203] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  146.401257] xhci_hcd 0000:00:14.0: Finding endpoint context
[  146.401307] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  146.401360] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  146.401411] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617f40 (virtual)
[  146.401625] xhci_hcd 0000:00:14.0: // Ding dong!
[  146.401967] sd 8:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  146.404131] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[  146.404195] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144bcc0, len = 68, expected = 192, status = -121
[  146.404348] xhci_hcd 0000:00:14.0: Stalled endpoint
[  146.404405] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144b3c0, len = 0, expected = 13, status = -32
[  146.404570] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  146.404628] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  146.404693] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  146.404757] xhci_hcd 0000:00:14.0: Finding endpoint context
[  146.404824] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  146.404891] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  146.404954] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617f40 (virtual)
[  146.405222] xhci_hcd 0000:00:14.0: // Ding dong!
[  146.405763] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[  146.405818] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144bcc0, len = 68, expected = 192, status = -121
[  146.407825] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  146.407857] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  146.407886] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  146.407916] xhci_hcd 0000:00:14.0: Finding endpoint context
[  146.407945] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  146.407974] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  146.408001] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617f40 (virtual)
[  146.408030] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530130 (DMA)
[  146.408511]  sdc: sdc1 sdc2 sdc3 sdc4
[  146.410089] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[  146.410119] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144b6c0, len = 68, expected = 192, status = -121
[  146.410165] xhci_hcd 0000:00:14.0: Stalled endpoint
[  146.410189] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144b3c0, len = 0, expected = 13, status = -32
[  146.410247] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  146.410273] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  146.410302] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  146.410570] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  146.410903] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  146.411158] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617f40 (0x30530000 dma), new deq ptr = ffff8800305301f0 (0x305301f0 dma), new cycle = 1
[  146.415834] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  146.415858] xhci_hcd 0000:00:14.0: Giveback URB ffff880030a323c0, len = 22, expected = 96, status = -121
[  146.415904] xhci_hcd 0000:00:14.0: Stalled endpoint
[  146.415931] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144b3c0, len = 0, expected = 13, status = -32
[  146.415988] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  146.416011] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  146.416035] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  146.416057] xhci_hcd 0000:00:14.0: Finding endpoint context
[  146.416082] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  146.416104] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  146.416129] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617f40 (virtual)
[  146.416151] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530260 (DMA)
[  146.416176] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  146.416200] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617f40 (0x30530000 dma), new deq ptr = ffff880030530260 (0x30530260 dma), new cycle = 1
[  146.416228] xhci_hcd 0000:00:14.0: // Ding dong!
[  146.416255] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  146.416283] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530261
[  146.445909] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  146.445973] xhci_hcd 0000:00:14.0: Giveback URB ffff880030315300, len = 22, expected = 96, status = -121
[  146.446077] xhci_hcd 0000:00:14.0: Stalled endpoint
[  146.446145] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144b3c0, len = 0, expected = 13, status = -32
[  146.446383] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  146.446437] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  146.446476] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  146.446522] xhci_hcd 0000:00:14.0: Finding endpoint context
[  146.446565] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  146.446606] xhci_hcd 0000:00:14.0: Cycle state = 0x0
[  146.446644] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617f60 (virtual)
[  146.446687] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530770 (DMA)
[  146.446729] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  146.446768] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617f60 (0x30530400 dma), new deq ptr = ffff880030530770 (0x30530770 dma), new cycle = 0
[  146.446815] xhci_hcd 0000:00:14.0: // Ding dong!
[  146.446860] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  146.446907] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530770
[  146.465934] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  146.465986] xhci_hcd 0000:00:14.0: Giveback URB ffff880030a32a80, len = 22, expected = 96, status = -121
[  146.466068] xhci_hcd 0000:00:14.0: Stalled endpoint
[  146.466107] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144b3c0, len = 0, expected = 13, status = -32
[  146.466193] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  146.466236] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  146.466282] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  146.466330] xhci_hcd 0000:00:14.0: Finding endpoint context
[  146.466378] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  146.466428] xhci_hcd 0000:00:14.0: Cycle state = 0x0
[  146.466478] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617f60 (virtual)
[  146.466529] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x305307d0 (DMA)
[  146.466587] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  146.466651] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617f60 (0x30530400 dma), new deq ptr = ffff8800305307d0 (0x305307d0 dma), new cycle = 0
[  146.466711] xhci_hcd 0000:00:14.0: // Ding dong!
[  146.466766] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  146.466830] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @305307d0
[  146.475901] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  146.475933] xhci_hcd 0000:00:14.0: Giveback URB ffff880030a326c0, len = 22, expected = 96, status = -121
[  146.475986] xhci_hcd 0000:00:14.0: Stalled endpoint
[  146.476017] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144b3c0, len = 0, expected = 13, status = -32
[  146.476103] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  146.476140] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  146.476175] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  146.476212] xhci_hcd 0000:00:14.0: Finding endpoint context
[  146.476249] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  146.476287] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  146.476319] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617f40 (virtual)
[  146.476346] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x305301a0 (DMA)
[  146.476374] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  146.476404] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617f40 (0x30530000 dma), new deq ptr = ffff8800305301a0 (0x305301a0 dma), new cycle = 1
[  146.476437] xhci_hcd 0000:00:14.0: // Ding dong!
[  146.476472] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  146.476506] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @305301a1
[  146.477537] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  146.477568] xhci_hcd 0000:00:14.0: Giveback URB ffff880030315240, len = 22, expected = 96, status = -121
[  146.477621] xhci_hcd 0000:00:14.0: Stalled endpoint
[  146.477649] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144b3c0, len = 0, expected = 13, status = -32
[  146.477715] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  146.477746] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  146.477780] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  146.477816] xhci_hcd 0000:00:14.0: Finding endpoint context
[  146.477852] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  146.477888] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  146.477961] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530260 (DMA)
[  146.478115] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  146.485932] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  146.485988] xhci_hcd 0000:00:14.0: Giveback URB ffff880030a326c0, len = 22, expected = 96, status = -121
[  146.486090] xhci_hcd 0000:00:14.0: Stalled endpoint
[  146.486127] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144b3c0, len = 0, expected = 13, status = -32
[  146.486199] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  146.486218] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  146.486265] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  146.486320] xhci_hcd 0000:00:14.0: Finding endpoint context
[  146.486374] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  146.486457] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  146.486497] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617f40 (virtual)
[  146.486538] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530330 (DMA)
[  146.486580] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  146.486622] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617f40 (0x30530000 dma), new deq ptr = ffff880030530330 (0x30530330 dma), new cycle = 1
[  146.486664] xhci_hcd 0000:00:14.0: // Ding dong!
[  146.486710] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  146.486756] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530331
[  146.495925] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  146.495974] xhci_hcd 0000:00:14.0: Giveback URB ffff880030315780, len = 22, expected = 96, status = -121
[  146.496060] xhci_hcd 0000:00:14.0: Stalled endpoint
[  146.496121] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144b3c0, len = 0, expected = 13, status = -32
[  146.496261] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  146.496312] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  146.496364] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  146.496462] xhci_hcd 0000:00:14.0: Finding endpoint context
[  146.496516] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  146.496614] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  146.496680] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617f60 (virtual)
[  146.496755] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530410 (DMA)
[  146.496801] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  146.496847] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617f60 (0x30530400 dma), new deq ptr = ffff880030530410 (0x30530410 dma), new cycle = 1
[  146.496899] xhci_hcd 0000:00:14.0: // Ding dong!
[  146.496953] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  146.497013] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530411
[  146.499010] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  146.499052] xhci_hcd 0000:00:14.0: Giveback URB ffff880030315780, len = 22, expected = 96, status = -121
[  146.499124] xhci_hcd 0000:00:14.0: Stalled endpoint
[  146.499162] xhci_hcd 0000:00:14.0: Giveback URB ffff88003144b3c0, len = 0, expected = 13, status = -32
[  146.499281] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  146.499320] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  146.499344] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  146.499366] xhci_hcd 0000:00:14.0: Finding endpoint context
[  146.499388] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  146.499412] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  146.499437] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880093617f60 (virtual)
[  146.499483] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x305304d0 (DMA)
[  146.499531] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  146.499578] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880093617f60 (0x30530400 dma), new deq ptr = ffff8800305304d0 (0x305304d0 dma), new cycle = 1
[  146.499630] xhci_hcd 0000:00:14.0: // Ding dong!
[  146.499685] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  146.499743] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @305304d1
[  146.551815] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdc3
[  146.568032] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdc3
[  146.606507] kjournald starting.  Commit interval 5 seconds
[  146.606995] EXT3-fs (sdc1): using internal journal
[  146.607040] EXT3-fs (sdc1): recovery complete
[  146.607058] EXT3-fs (sdc1): mounted filesystem with ordered data mode
[  146.619820] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdc3
[  146.626237] FAT-fs (sdc4): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[  146.633042] EXT4-fs (sdc2): recovery complete
[  146.635922] EXT4-fs (sdc2): mounted filesystem with ordered data mode. Opts: (null)
[  149.558611] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[  149.558699] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[  149.558815] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  149.558915] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x4202c0
[  149.559005] xhci_hcd 0000:00:14.0: Get port status returned 0x4102c0
[  149.559205] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x4002c0
[  149.559372] xhci_hcd 0000:00:14.0: clear port link state change, actual port 1 status  = 0x2c0
[  149.559500] hub 2-0:1.0: warm reset port 2
[  149.613322] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2b0
[  149.613395] xhci_hcd 0000:00:14.0: Get port status returned 0x2b0
[  149.613519] hub 2-0:1.0: port 2 not warm reset yet, waiting 50ms
[  149.659008] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[  149.659097] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[  149.669337] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2802a0
[  149.669414] xhci_hcd 0000:00:14.0: Get port status returned 0x3002a0
[  149.669574] xhci_hcd 0000:00:14.0: clear port reset change, actual port 1 status  = 0x802a0
[  149.669744] xhci_hcd 0000:00:14.0: clear port warm(BH) reset change, actual port 1 status  = 0x2a0
[  149.669913] xhci_hcd 0000:00:14.0: clear port link state change, actual port 1 status  = 0x2a0
[  149.670077] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x2a0
[  149.670252] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[  149.670314] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  149.670470] xhci_hcd 0000:00:14.0: Disable port 1
[  149.670625] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x280
[  149.670678] xhci_hcd 0000:00:14.0: Get port status returned 0x280
[  149.670810] xhci_hcd 0000:00:14.0: Enable port 1
[  149.670929] hub 2-0:1.0: port 2, status 02c0, change 0041, 5.0 Gb/s
[  149.670970] usb 2-2: USB disconnect, device number 4
[  149.670997] usb 2-2: unregistering device
[  149.671022] usb 2-2: unregistering interface 2-2:1.0
[  149.671270] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[  149.671392] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  149.671438] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[  149.671495] xhci_hcd 0000:00:14.0: Slot 7 Input Context:
[  149.671544] xhci_hcd 0000:00:14.0: @ffff8800317ab000 (virt) @317ab000 (dma) 0x000000 - drop flags
[  149.671597] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[  149.671649] xhci_hcd 0000:00:14.0: @ffff8800317ab008 (virt) @317ab008 (dma) 0x000000 - rsvd2[0]
[  149.671904] xhci_hcd 0000:00:14.0: @ffff8800317ab01c (virt) @317ab01c (dma) 0x000000 - rsvd2[5]
[  149.672155] xhci_hcd 0000:00:14.0: @ffff8800317ab02c (virt) @317ab02c (dma) 0x18000007 - dev_state
[  149.672508] xhci_hcd 0000:00:14.0: @ffff8800317ab044 (virt) @317ab044 (dma) 0x000000 - ep_info2
[  149.672807] xhci_hcd 0000:00:14.0: Adding 0 ep ctxs, 12 now active.
[  149.672987] xhci_hcd 0000:00:14.0: Successful evaluate context command
[  149.673275] xhci_hcd 0000:00:14.0: @ffff88009892d008 (virt) @9892d008 (dma) 0x000000 - tt_info
[  149.673495] xhci_hcd 0000:00:14.0: @ffff88009892d018 (virt) @9892d018 (dma) 0x000000 - rsvd[2]
[  149.673790] xhci_hcd 0000:00:14.0: @ffff88009892d028 (virt) @9892d028 (dma) 0x8d68a401 - deq
[  149.674029] xhci_hcd 0000:00:14.0: @ffff88009892d03c (virt) @9892d03c (dma) 0x000000 - rsvd[2]
[  149.687673] JBD2: Error -5 detected when updating journal superblock for sdc2-8.
[  149.687732] Aborting journal on device sdc2-8.
[  149.687753] JBD2: Error -5 detected when updating journal superblock for sdc2-8.
[  149.687771] journal commit I/O error
[  149.693034] sd 8:0:0:0: [sdc] Synchronizing SCSI cache
[  149.693198] sd 8:0:0:0: [sdc]  
[  149.693216] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  149.693640] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[  149.693684] xhci_hcd 0000:00:14.0: Slot 7 Input Context:
[  149.693710] xhci_hcd 0000:00:14.0: @ffff8800317ab000 (virt) @317ab000 (dma) 0x000000 - drop flags
[  149.693740] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[  149.693770] xhci_hcd 0000:00:14.0: @ffff8800317ab008 (virt) @317ab008 (dma) 0x000000 - rsvd2[0]
[  149.693800] xhci_hcd 0000:00:14.0: @ffff8800317ab00c (virt) @317ab00c (dma) 0x000000 - rsvd2[1]
[  149.693826] xhci_hcd 0000:00:14.0: @ffff8800317ab010 (virt) @317ab010 (dma) 0x000000 - rsvd2[2]
[  149.693856] xhci_hcd 0000:00:14.0: @ffff8800317ab014 (virt) @317ab014 (dma) 0x000000 - rsvd2[3]
[  149.693885] xhci_hcd 0000:00:14.0: @ffff8800317ab018 (virt) @317ab018 (dma) 0x000000 - rsvd2[4]
[  149.693914] xhci_hcd 0000:00:14.0: @ffff8800317ab01c (virt) @317ab01c (dma) 0x000000 - rsvd2[5]
[  149.693942] xhci_hcd 0000:00:14.0: Slot Context:
[  149.693967] xhci_hcd 0000:00:14.0: @ffff8800317ab020 (virt) @317ab020 (dma) 0x20400000 - dev_info
[  149.693993] xhci_hcd 0000:00:14.0: @ffff8800317ab024 (virt) @317ab024 (dma) 0x06000a - dev_info2
[  149.694020] xhci_hcd 0000:00:14.0: @ffff8800317ab028 (virt) @317ab028 (dma) 0x000000 - tt_info
[  149.694048] xhci_hcd 0000:00:14.0: @ffff8800317ab02c (virt) @317ab02c (dma) 0x18000007 - dev_state
[  149.694076] xhci_hcd 0000:00:14.0: @ffff8800317ab030 (virt) @317ab030 (dma) 0x000000 - rsvd[0]
[  149.694105] xhci_hcd 0000:00:14.0: @ffff8800317ab034 (virt) @317ab034 (dma) 0x000000 - rsvd[1]
[  149.694133] xhci_hcd 0000:00:14.0: @ffff8800317ab038 (virt) @317ab038 (dma) 0x000000 - rsvd[2]
[  149.694161] xhci_hcd 0000:00:14.0: @ffff8800317ab03c (virt) @317ab03c (dma) 0x000000 - rsvd[3]
[  149.694295] xhci_hcd 0000:00:14.0: @ffff8800317ab050 (virt) @317ab050 (dma) 0x000000 - tx_info
[  149.694670] xhci_hcd 0000:00:14.0: Successful evaluate context command
[  149.694834] xhci_hcd 0000:00:14.0: @ffff88009892d00c (virt) @9892d00c (dma) 0x18000007 - dev_state
[  149.695120] xhci_hcd 0000:00:14.0: @ffff88009892d038 (virt) @9892d038 (dma) 0x000000 - rsvd[1]
[  149.695347] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[  149.695613] xhci_hcd 0000:00:14.0: @ffff8800317ab028 (virt) @317ab028 (dma) 0x000000 - tt_info
[  149.695862] xhci_hcd 0000:00:14.0: @ffff8800317ab048 (virt) @317ab048 (dma) 0x000000 - deq
[  149.696078] xhci_hcd 0000:00:14.0: Successful evaluate context command
[  149.696341] xhci_hcd 0000:00:14.0: @ffff88009892d01c (virt) @9892d01c (dma) 0x000000 - rsvd[3]
[  149.696621] usb 2-2: usb_set_device_initiated_lpm: Can't enable U2 state for unconfigured device.
[  149.696889] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[  149.697166] xhci_hcd 0000:00:14.0: @ffff8800317ab02c (virt) @317ab02c (dma) 0x18000007 - dev_state
[  149.697478] xhci_hcd 0000:00:14.0: Adding 0 ep ctxs, 12 now active.
[  149.697838] xhci_hcd 0000:00:14.0: Successful evaluate context command
[  149.697977] xhci_hcd 0000:00:14.0: @ffff88009892d00c (virt) @9892d00c (dma) 0x18000007 - dev_state
[  149.698258] usb 2-2: usb_disable_device nuking all URBs
[  149.698567] xhci_hcd 0000:00:14.0: @ffff88009892c018 (virt) @9892c018 (dma) 0x000000 - rsvd2[4]
[  149.698816] xhci_hcd 0000:00:14.0: @ffff88009892c038 (virt) @9892c038 (dma) 0x000000 - rsvd[2]
[  149.699069] xhci_hcd 0000:00:14.0: @ffff88009892c05c (virt) @9892c05c (dma) 0x000000 - rsvd[2]
[  149.699342] xhci_hcd 0000:00:14.0: Slot Context:
[  149.699616] xhci_hcd 0000:00:14.0: @ffff88009892d020 (virt) @9892d020 (dma) 0x000001 - ep_info
[  149.700190] xhci_hcd 0000:00:14.0: // Ding dong!
[  149.700232] xhci_hcd 0000:00:14.0: Dropped 1 ep ctxs, flags = 0x1, 9 now active.
[  149.713201] Buffer I/O error on device sdc1, logical block 0
[  149.713224] lost page write due to I/O error on sdc1
[  149.713241] EXT3-fs (sdc1): I/O error while writing superblock
[  149.729297] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[  149.729338] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  149.734294] EXT4-fs error (device sdc2): ext4_put_super:772: Couldn't clean up the journal
[  149.734334] EXT4-fs (sdc2): Remounting filesystem read-only
[  149.761309] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[  149.761347] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  149.793313] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[  149.793361] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[  149.793389] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  149.825365] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[  149.825405] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  149.825436] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x2a0
[  149.825453] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  149.825478] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[  149.825495] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  149.825542] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
[  149.825583] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
[  149.825620] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 2 status  = 0xe0002a0
[  149.825656] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 3 status  = 0xe0002a0
[  149.825676] hub 2-0:1.0: hub_suspend
[  149.825696] usb usb2: bus auto-suspend, wakeup 1
[  149.825721] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[  169.536204] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[  169.536288] xhci_hcd 0000:00:14.0: resume root hub
[  169.536343] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[  169.536431] usb usb2: usb wakeup-resume
[  169.536464] usb usb2: usb auto-resume
[  169.536512] hub 2-0:1.0: hub_resume
[  169.536597] xhci_hcd 0000:00:14.0: get port status, actual port 0 status  = 0x2a0
[  169.536661] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  169.536787] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x21203
[  169.536848] xhci_hcd 0000:00:14.0: Get port status returned 0x10203
[  169.536922] hub 2-0:1.0: port 2: status 0203 change 0001
[  169.536992] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x1203
[  169.537098] xhci_hcd 0000:00:14.0: get port status, actual port 2 status  = 0x2a0
[  169.537150] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  169.537231] xhci_hcd 0000:00:14.0: get port status, actual port 3 status  = 0x2a0
[  169.537274] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  169.638455] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0000
[  169.638543] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x1203
[  169.638617] xhci_hcd 0000:00:14.0: Get port status returned 0x203
[  169.638745] hub 2-0:1.0: port 2, status 0203, change 0000, 5.0 Gb/s
[  169.638799] xhci_hcd 0000:00:14.0: // Ding dong!
[  169.638894] xhci_hcd 0000:00:14.0: Adding 1 ep ctx, 10 now active.
[  169.638987] xhci_hcd 0000:00:14.0: Slot 8 output ctx = 0x9892d000 (dma)
[  169.639046] xhci_hcd 0000:00:14.0: Slot 8 input ctx = 0x9892c000 (dma)
[  169.639149] xhci_hcd 0000:00:14.0: Set slot id 8 dcbaa entry ffff8800317ad040 to 0x9892d000
[  169.639248] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x1203
[  169.639290] xhci_hcd 0000:00:14.0: Get port status returned 0x203
[  169.639420] xhci_hcd 0000:00:14.0: set port reset, actual port 1 status  = 0x1311
[  169.639496] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[  169.639579] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[  169.694518] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x201203
[  169.694595] xhci_hcd 0000:00:14.0: Get port status returned 0x100203
[  169.750528] xhci_hcd 0000:00:14.0: clear port reset change, actual port 1 status  = 0x1203
[  169.750724] xhci_hcd 0000:00:14.0: clear port warm(BH) reset change, actual port 1 status  = 0x1203
[  169.750892] xhci_hcd 0000:00:14.0: clear port link state change, actual port 1 status  = 0x1203
[  169.751076] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x1203
[  169.751240] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x1203
[  169.751303] xhci_hcd 0000:00:14.0: Get port status returned 0x203
[  169.751402] xhci_hcd 0000:00:14.0: Set root hub portnum to 6
[  169.751467] xhci_hcd 0000:00:14.0: Set fake root hub portnum to 2
[  169.751508] xhci_hcd 0000:00:14.0: udev->tt =           (null)
[  169.751560] xhci_hcd 0000:00:14.0: udev->ttport = 0x0
[  169.751605] xhci_hcd 0000:00:14.0: Slot ID 8 Input Context:
[  169.751658] xhci_hcd 0000:00:14.0: @ffff88009892c000 (virt) @9892c000 (dma) 0x000000 - drop flags
[  169.751708] xhci_hcd 0000:00:14.0: @ffff88009892c004 (virt) @9892c004 (dma) 0x000003 - add flags
[  169.751766] xhci_hcd 0000:00:14.0: @ffff88009892c008 (virt) @9892c008 (dma) 0x000000 - rsvd2[0]
[  169.751820] xhci_hcd 0000:00:14.0: @ffff88009892c00c (virt) @9892c00c (dma) 0x000000 - rsvd2[1]
[  169.751869] xhci_hcd 0000:00:14.0: @ffff88009892c010 (virt) @9892c010 (dma) 0x000000 - rsvd2[2]
[  169.751914] xhci_hcd 0000:00:14.0: @ffff88009892c014 (virt) @9892c014 (dma) 0x000000 - rsvd2[3]
[  169.751961] xhci_hcd 0000:00:14.0: @ffff88009892c018 (virt) @9892c018 (dma) 0x000000 - rsvd2[4]
[  169.752007] xhci_hcd 0000:00:14.0: @ffff88009892c01c (virt) @9892c01c (dma) 0x000000 - rsvd2[5]
[  169.752056] xhci_hcd 0000:00:14.0: Slot Context:
[  169.752107] xhci_hcd 0000:00:14.0: @ffff88009892c020 (virt) @9892c020 (dma) 0x8400000 - dev_info
[  169.752357] xhci_hcd 0000:00:14.0: @ffff88009892c034 (virt) @9892c034 (dma) 0x000000 - rsvd[1]
[  169.752656] xhci_hcd 0000:00:14.0: @ffff88009892c048 (virt) @9892c048 (dma) 0x8d68a401 - deq
[  169.752960] xhci_hcd 0000:00:14.0: @ffff88009892c064 (virt) @9892c064 (dma) 0x000000 - ep_info2
[  169.753256] xhci_hcd 0000:00:14.0: @ffff88009892c080 (virt) @9892c080 (dma) 0x000000 - ep_info
[  169.753549] xhci_hcd 0000:00:14.0: // Ding dong!
[  169.753841] xhci_hcd 0000:00:14.0: Slot ID 8 Input Context:
[  169.754154] xhci_hcd 0000:00:14.0: @ffff88009892c018 (virt) @9892c018 (dma) 0x000000 - rsvd2[4]
[  169.754582] xhci_hcd 0000:00:14.0: @ffff88009892c038 (virt) @9892c038 (dma) 0x000000 - rsvd[2]
[  169.754940] xhci_hcd 0000:00:14.0: @ffff88009892c054 (virt) @9892c054 (dma) 0x000000 - rsvd[0]
[  169.755199] xhci_hcd 0000:00:14.0: @ffff88009892c064 (virt) @9892c064 (dma) 0x000000 - ep_info2
[  169.755509] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
[  169.755820] xhci_hcd 0000:00:14.0: @ffff88009892c098 (virt) @9892c098 (dma) 0x000000 - rsvd[1]
[  169.756125] xhci_hcd 0000:00:14.0: @ffff88009892d008 (virt) @9892d008 (dma) 0x000000 - tt_info
[  169.756383] xhci_hcd 0000:00:14.0: @ffff88009892d01c (virt) @9892d01c (dma) 0x000000 - rsvd[3]
[  169.756641] xhci_hcd 0000:00:14.0: @ffff88009892d030 (virt) @9892d030 (dma) 0x000000 - tx_info
[  169.756901] xhci_hcd 0000:00:14.0: @ffff88009892d040 (virt) @9892d040 (dma) 0x000000 - ep_info
[  169.757210] xhci_hcd 0000:00:14.0: @ffff88009892d05c (virt) @9892d05c (dma) 0x000000 - rsvd[2]
[  169.757573] xhci_hcd 0000:00:14.0: @ffff88009892d078 (virt) @9892d078 (dma) 0x000000 - rsvd[1]
[  169.771410] usb 2-2: skipped 1 descriptor after endpoint
[  169.771445] usb 2-2: skipped 1 descriptor after endpoint
[  169.771478] usb 2-2: skipped 2 descriptors after endpoint
[  169.771510] usb 2-2: skipped 2 descriptors after endpoint
[  169.771537] usb 2-2: skipped 2 descriptors after endpoint
[  169.771568] usb 2-2: skipped 2 descriptors after endpoint
[  169.771705] xhci_hcd 0000:00:14.0: Waiting for status stage event
[  169.771793] usb 2-2: default language 0x0409
[  169.771950] xhci_hcd 0000:00:14.0: Waiting for status stage event
[  169.772067] xhci_hcd 0000:00:14.0: Waiting for status stage event
[  169.772182] xhci_hcd 0000:00:14.0: Waiting for status stage event
[  169.772216] usb 2-2: udev 5, busnum 2, minor = 132
[  169.772247] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
[  169.772270] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[  169.772286] usb 2-2: Product: Plugable USB3-SATA-UASP1
[  169.772298] usb 2-2: Manufacturer: ASM1053E
[  169.772313] usb 2-2: SerialNumber: 123456789045
[  169.772818] usb 2-2: usb_probe_device
[  169.772863] usb 2-2: configuration #1 chosen from 1 choice
[  169.772914] xhci_hcd 0000:00:14.0: add ep 0x81, slot id 8, new drop flags = 0x0, new add flags = 0x8, new slot info = 0x18400000
[  169.772963] xhci_hcd 0000:00:14.0: add ep 0x2, slot id 8, new drop flags = 0x0, new add flags = 0x18, new slot info = 0x20400000
[  169.772984] xhci_hcd 0000:00:14.0: xhci_check_bandwidth called for udev ffff8800b7a3b800
[  169.773010] xhci_hcd 0000:00:14.0: New Input Control Context:
[  169.773054] xhci_hcd 0000:00:14.0: @ffff88009892c004 (virt) @9892c004 (dma) 0x000019 - add flags
[  169.773280] xhci_hcd 0000:00:14.0: @ffff88009892c028 (virt) @9892c028 (dma) 0x000000 - tt_info
[  169.773579] xhci_hcd 0000:00:14.0: @ffff88009892c05c (virt) @9892c05c (dma) 0x000000 - rsvd[2]
[  169.773786] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
[  169.773952] xhci_hcd 0000:00:14.0: @ffff88009892c090 (virt) @9892c090 (dma) 0x000000 - tx_info
[  169.774195] xhci_hcd 0000:00:14.0: @ffff88009892c0a0 (virt) @9892c0a0 (dma) 0x000000 - ep_info
[  169.774470] xhci_hcd 0000:00:14.0: @ffff88009892c0b8 (virt) @9892c0b8 (dma) 0x000000 - rsvd[1]
[  169.774776] xhci_hcd 0000:00:14.0: Successful Endpoint Configure command
[  169.774996] xhci_hcd 0000:00:14.0: @ffff88009892d018 (virt) @9892d018 (dma) 0x000000 - rsvd[2]
[  169.775159] xhci_hcd 0000:00:14.0: @ffff88009892d034 (virt) @9892d034 (dma) 0x000000 - rsvd[0]
[  169.775355] xhci_hcd 0000:00:14.0: @ffff88009892d054 (virt) @9892d054 (dma) 0x000000 - rsvd[0]
[  169.775566] xhci_hcd 0000:00:14.0: @ffff88009892d078 (virt) @9892d078 (dma) 0x000000 - rsvd[1]
[  169.775811] xhci_hcd 0000:00:14.0: Endpoint 0x81 not halted, refusing to reset.
[  169.776068] xhci_hcd 0000:00:14.0: Slot 8 Input Context:
[  169.776301] xhci_hcd 0000:00:14.0: @ffff8800317ab020 (virt) @317ab020 (dma) 0x20400000 - dev_info
[  169.776576] xhci_hcd 0000:00:14.0: @ffff8800317ab050 (virt) @317ab050 (dma) 0x000000 - tx_info
[  169.776790] xhci_hcd 0000:00:14.0: @ffff88009892d000 (virt) @9892d000 (dma) 0x20400000 - dev_info
[  169.776998] xhci_hcd 0000:00:14.0: @ffff88009892d014 (virt) @9892d014 (dma) 0x000000 - rsvd[1]
[  169.777247] xhci_hcd 0000:00:14.0: @ffff88009892d024 (virt) @9892d024 (dma) 0x2000026 - ep_info2
[  169.777494] xhci_hcd 0000:00:14.0: @ffff88009892d03c (virt) @9892d03c (dma) 0x000000 - rsvd[2]
[  169.777817] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[  169.778045] xhci_hcd 0000:00:14.0: @ffff8800317ab008 (virt) @317ab008 (dma) 0x000000 - rsvd2[0]
[  169.778252] xhci_hcd 0000:00:14.0: @ffff8800317ab018 (virt) @317ab018 (dma) 0x000000 - rsvd2[4]
[  169.778538] xhci_hcd 0000:00:14.0: @ffff8800317ab028 (virt) @317ab028 (dma) 0x000000 - tt_info
[  169.778783] xhci_hcd 0000:00:14.0: @ffff8800317ab040 (virt) @317ab040 (dma) 0x000000 - ep_info
[  169.779018] xhci_hcd 0000:00:14.0: @ffff8800317ab05c (virt) @317ab05c (dma) 0x000000 - rsvd[2]
[  169.779219] xhci_hcd 0000:00:14.0: Successful evaluate context command
[  169.779528] xhci_hcd 0000:00:14.0: @ffff88009892d00c (virt) @9892d00c (dma) 0x18000008 - dev_state
[  169.779776] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[  169.779977] xhci_hcd 0000:00:14.0: @ffff88009892d030 (virt) @9892d030 (dma) 0x000000 - tx_info
[  169.780328] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[  169.780673] usb-storage 2-2:1.0: usb_probe_interface
[  169.781020] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[  169.781086] xhci_hcd 0000:00:14.0: Slot 8 Input Context:
[  169.781238] xhci_hcd 0000:00:14.0: @ffff8800317ab008 (virt) @317ab008 (dma) 0x000000 - rsvd2[0]
[  169.781601] xhci_hcd 0000:00:14.0: @ffff8800317ab020 (virt) @317ab020 (dma) 0x20400000 - dev_info
[  169.781809] xhci_hcd 0000:00:14.0: @ffff8800317ab030 (virt) @317ab030 (dma) 0x000000 - rsvd[0]
[  169.782015] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[  169.782277] xhci_hcd 0000:00:14.0: @ffff8800317ab054 (virt) @317ab054 (dma) 0x000000 - rsvd[0]
[  169.782541] xhci_hcd 0000:00:14.0: // Ding dong!
[  169.782746] xhci_hcd 0000:00:14.0: Slot 8 Output Context:
[  169.782973] xhci_hcd 0000:00:14.0: @ffff88009892d008 (virt) @9892d008 (dma) 0x000000 - tt_info
[  169.783174] xhci_hcd 0000:00:14.0: @ffff88009892d018 (virt) @9892d018 (dma) 0x000000 - rsvd[2]
[  169.783373] xhci_hcd 0000:00:14.0: @ffff88009892d024 (virt) @9892d024 (dma) 0x2000026 - ep_info2
[  169.783568] xhci_hcd 0000:00:14.0: @ffff88009892d038 (virt) @9892d038 (dma) 0x000000 - rsvd[1]
[  169.783867] usb-storage 2-2:1.0: Quirks match for vid 174c pid 55aa: 400000
[  169.783999] scsi9 : usb-storage 2-2:1.0
[  169.784938] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[  169.785001] xhci_hcd 0000:00:14.0: Slot 8 Input Context:
[  169.785052] xhci_hcd 0000:00:14.0: @ffff8800317ab000 (virt) @317ab000 (dma) 0x000000 - drop flags
[  169.785110] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[  169.785170] xhci_hcd 0000:00:14.0: @ffff8800317ab008 (virt) @317ab008 (dma) 0x000000 - rsvd2[0]
[  169.785237] xhci_hcd 0000:00:14.0: @ffff8800317ab00c (virt) @317ab00c (dma) 0x000000 - rsvd2[1]
[  169.785309] xhci_hcd 0000:00:14.0: @ffff8800317ab010 (virt) @317ab010 (dma) 0x000000 - rsvd2[2]
[  169.785368] xhci_hcd 0000:00:14.0: @ffff8800317ab014 (virt) @317ab014 (dma) 0x000000 - rsvd2[3]
[  169.785426] xhci_hcd 0000:00:14.0: @ffff8800317ab018 (virt) @317ab018 (dma) 0x000000 - rsvd2[4]
[  169.785484] xhci_hcd 0000:00:14.0: @ffff8800317ab01c (virt) @317ab01c (dma) 0x000000 - rsvd2[5]
[  169.785598] xhci_hcd 0000:00:14.0: @ffff8800317ab020 (virt) @317ab020 (dma) 0x20400000 - dev_info
[  169.785771] xhci_hcd 0000:00:14.0: @ffff8800317ab02c (virt) @317ab02c (dma) 0x18000008 - dev_state
[  169.785944] xhci_hcd 0000:00:14.0: @ffff8800317ab038 (virt) @317ab038 (dma) 0x000000 - rsvd[2]
[  169.786060] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[  169.786240] xhci_hcd 0000:00:14.0: @ffff8800317ab048 (virt) @317ab048 (dma) 0x000000 - deq
[  169.786356] xhci_hcd 0000:00:14.0: @ffff8800317ab054 (virt) @317ab054 (dma) 0x000000 - rsvd[0]
[  169.786596] xhci_hcd 0000:00:14.0: Adding 0 ep ctxs, 12 now active.
[  169.786731] xhci_hcd 0000:00:14.0: Slot 8 Output Context:
[  169.786886] xhci_hcd 0000:00:14.0: @ffff88009892d008 (virt) @9892d008 (dma) 0x000000 - tt_info
[  169.787078] xhci_hcd 0000:00:14.0: @ffff88009892d01c (virt) @9892d01c (dma) 0x000000 - rsvd[3]
[  169.787238] xhci_hcd 0000:00:14.0: @ffff88009892d028 (virt) @9892d028 (dma) 0x8d68a401 - deq
[  169.787392] xhci_hcd 0000:00:14.0: @ffff88009892d03c (virt) @9892d03c (dma) 0x000000 - rsvd[2]
[  169.787663] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[  169.787788] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[  169.787954] xhci_hcd 0000:00:14.0: @ffff8800317ab014 (virt) @317ab014 (dma) 0x000000 - rsvd2[3]
[  169.788156] xhci_hcd 0000:00:14.0: @ffff8800317ab024 (virt) @317ab024 (dma) 0x0607ff - dev_info2
[  169.788323] xhci_hcd 0000:00:14.0: @ffff8800317ab034 (virt) @317ab034 (dma) 0x000000 - rsvd[1]
[  169.788572] xhci_hcd 0000:00:14.0: @ffff8800317ab048 (virt) @317ab048 (dma) 0x000000 - deq
[  169.788734] xhci_hcd 0000:00:14.0: @ffff8800317ab05c (virt) @317ab05c (dma) 0x000000 - rsvd[2]
[  169.788886] xhci_hcd 0000:00:14.0: Successful evaluate context command
[  169.789057] xhci_hcd 0000:00:14.0: @ffff88009892d004 (virt) @9892d004 (dma) 0x0607ff - dev_info2
[  169.789209] xhci_hcd 0000:00:14.0: @ffff88009892d014 (virt) @9892d014 (dma) 0x000000 - rsvd[1]
[  169.789367] xhci_hcd 0000:00:14.0: @ffff88009892d020 (virt) @9892d020 (dma) 0x000001 - ep_info
[  169.789564] xhci_hcd 0000:00:14.0: @ffff88009892d038 (virt) @9892d038 (dma) 0x000000 - rsvd[1]
[  169.894549] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[  170.784442] scsi 9:0:0:0: Direct-Access     ASM1053E Plugable USB3-SA 0    PQ: 0 ANSI: 6
[  170.786973] sd 9:0:0:0: Attached scsi generic sg1 type 0
[  170.789275] sd 9:0:0:0: [sdc] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[  170.789547] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[  170.789609] xhci_hcd 0000:00:14.0: Giveback URB ffff8800936066c0, len = 68, expected = 192, status = -121
[  170.789710] xhci_hcd 0000:00:14.0: Stalled endpoint
[  170.789765] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acfcf9c0, len = 0, expected = 13, status = -32
[  170.789894] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  170.789962] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  170.790027] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  170.790099] xhci_hcd 0000:00:14.0: Finding endpoint context
[  170.790168] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  170.790227] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  170.790281] xhci_hcd 0000:00:14.0: New dequeue segment = ffff8800ace27740 (virtual)
[  170.790338] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530870 (DMA)
[  170.790392] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  170.790449] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff8800ace27740 (0x30530800 dma), new deq ptr = ffff880030530870 (0x30530870 dma), new cycle = 1
[  170.790514] xhci_hcd 0000:00:14.0: // Ding dong!
[  170.790578] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  170.790654] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530871
[  170.790785] sd 9:0:0:0: [sdc] Write Protect is off
[  170.790822] sd 9:0:0:0: [sdc] Mode Sense: 43 00 00 00
[  170.791082] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[  170.791138] xhci_hcd 0000:00:14.0: Giveback URB ffff8800a241cf00, len = 68, expected = 192, status = -121
[  170.791490] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acfcf9c0, len = 0, expected = 13, status = -32
[  170.793894] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  170.793959] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  170.794024] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  170.794092] xhci_hcd 0000:00:14.0: Finding endpoint context
[  170.794160] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  170.794228] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  170.794296] xhci_hcd 0000:00:14.0: New dequeue segment = ffff8800ace27740 (virtual)
[  170.794361] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x305308a0 (DMA)
[  170.794430] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  170.794644] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  170.796856] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[  170.796895] xhci_hcd 0000:00:14.0: Giveback URB ffff8800a241c540, len = 68, expected = 192, status = -121
[  170.797119] xhci_hcd 0000:00:14.0: Stalled endpoint
[  170.797147] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acfcf9c0, len = 0, expected = 13, status = -32
[  170.797226] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  170.797261] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  170.797298] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  170.797337] xhci_hcd 0000:00:14.0: Finding endpoint context
[  170.797371] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  170.797408] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  170.797633] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  170.797871] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[  170.797953] xhci_hcd 0000:00:14.0: Stalled endpoint
[  170.798100] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  170.798327] xhci_hcd 0000:00:14.0: // Ding dong!
[  170.798736]  sdc: sdc1 sdc2 sdc3 sdc4
[  170.800896] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[  170.800931] xhci_hcd 0000:00:14.0: Giveback URB ffff8800936060c0, len = 68, expected = 192, status = -121
[  170.800998] xhci_hcd 0000:00:14.0: Stalled endpoint
[  170.801036] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acfcf9c0, len = 0, expected = 13, status = -32
[  170.801114] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  170.801142] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  170.801170] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  170.801198] xhci_hcd 0000:00:14.0: Finding endpoint context
[  170.801228] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  170.801258] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  170.801285] xhci_hcd 0000:00:14.0: New dequeue segment = ffff8800ace27740 (virtual)
[  170.801316] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x305309c0 (DMA)
[  170.801343] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  170.801373] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff8800ace27740 (0x30530800 dma), new deq ptr = ffff8800305309c0 (0x305309c0 dma), new cycle = 1
[  170.801407] xhci_hcd 0000:00:14.0: // Ding dong!
[  170.801441] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  170.802166] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 192 bytes, 124 bytes untransferred
[  170.802193] xhci_hcd 0000:00:14.0: Giveback URB ffff8800a241cd80, len = 68, expected = 192, status = -121
[  170.802244] xhci_hcd 0000:00:14.0: Stalled endpoint
[  170.802277] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acfcf9c0, len = 0, expected = 13, status = -32
[  170.802351] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  170.802406] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  170.802585] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  170.803131] sd 9:0:0:0: [sdc] Attached SCSI disk
[  170.808878] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  170.808908] xhci_hcd 0000:00:14.0: Giveback URB ffff8800a241cd80, len = 22, expected = 96, status = -121
[  170.808954] xhci_hcd 0000:00:14.0: Stalled endpoint
[  170.808977] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acfcf9c0, len = 0, expected = 13, status = -32
[  170.809034] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  170.809060] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  170.809089] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  170.809119] xhci_hcd 0000:00:14.0: Finding endpoint context
[  170.809149] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  170.809179] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  170.809208] xhci_hcd 0000:00:14.0: New dequeue segment = ffff8800ace27740 (virtual)
[  170.809238] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530a60 (DMA)
[  170.809268] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  170.809295] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff8800ace27740 (0x30530800 dma), new deq ptr = ffff880030530a60 (0x30530a60 dma), new cycle = 1
[  170.809327] xhci_hcd 0000:00:14.0: // Ding dong!
[  170.809361] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  170.809399] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530a61
[  170.848995] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  170.849056] xhci_hcd 0000:00:14.0: Giveback URB ffff880031ea4180, len = 22, expected = 96, status = -121
[  170.849156] xhci_hcd 0000:00:14.0: Stalled endpoint
[  170.849207] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acfcf9c0, len = 0, expected = 13, status = -32
[  170.849322] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  170.849388] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  170.849458] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  170.849529] xhci_hcd 0000:00:14.0: Finding endpoint context
[  170.849601] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  170.849673] xhci_hcd 0000:00:14.0: Cycle state = 0x0
[  170.849747] xhci_hcd 0000:00:14.0: New dequeue segment = ffff8800ace27720 (virtual)
[  170.849816] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530370 (DMA)
[  170.849876] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  170.849934] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff8800ace27720 (0x30530000 dma), new deq ptr = ffff880030530370 (0x30530370 dma), new cycle = 0
[  170.849996] xhci_hcd 0000:00:14.0: // Ding dong!
[  170.850060] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  170.850129] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530370
[  170.868901] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  170.868939] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acec5a80, len = 22, expected = 96, status = -121
[  170.868991] xhci_hcd 0000:00:14.0: Stalled endpoint
[  170.869018] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acfcf9c0, len = 0, expected = 13, status = -32
[  170.869152] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  170.869180] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  170.869213] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  170.869247] xhci_hcd 0000:00:14.0: Finding endpoint context
[  170.869277] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  170.869329] xhci_hcd 0000:00:14.0: Cycle state = 0x0
[  170.869386] xhci_hcd 0000:00:14.0: New dequeue segment = ffff8800ace27720 (virtual)
[  170.869444] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x305303d0 (DMA)
[  170.869502] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  170.869547] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff8800ace27720 (0x30530000 dma), new deq ptr = ffff8800305303d0 (0x305303d0 dma), new cycle = 0
[  170.869584] xhci_hcd 0000:00:14.0: // Ding dong!
[  170.869622] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  170.869658] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @305303d0
[  170.878909] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  170.878945] xhci_hcd 0000:00:14.0: Giveback URB ffff8800c9f0a180, len = 22, expected = 96, status = -121
[  170.879005] xhci_hcd 0000:00:14.0: Stalled endpoint
[  170.879032] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acfcf9c0, len = 0, expected = 13, status = -32
[  170.879117] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  170.879172] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  170.879214] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  170.879256] xhci_hcd 0000:00:14.0: Finding endpoint context
[  170.879300] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  170.879342] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  170.879387] xhci_hcd 0000:00:14.0: New dequeue segment = ffff8800ace27740 (virtual)
[  170.879429] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530980 (DMA)
[  170.879472] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  170.879516] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff8800ace27740 (0x30530800 dma), new deq ptr = ffff880030530980 (0x30530980 dma), new cycle = 1
[  170.879557] xhci_hcd 0000:00:14.0: // Ding dong!
[  170.879597] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  170.879641] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530981
[  170.880740] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  170.880771] xhci_hcd 0000:00:14.0: Giveback URB ffff8800c9f0a180, len = 22, expected = 96, status = -121
[  170.880828] xhci_hcd 0000:00:14.0: Stalled endpoint
[  170.880857] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acfcf9c0, len = 0, expected = 13, status = -32
[  170.880940] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  170.880982] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  170.881022] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  170.881066] xhci_hcd 0000:00:14.0: Finding endpoint context
[  170.881109] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  170.881152] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  170.881189] xhci_hcd 0000:00:14.0: New dequeue segment = ffff8800ace27740 (virtual)
[  170.881224] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530a40 (DMA)
[  170.888906] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  170.888928] xhci_hcd 0000:00:14.0: Giveback URB ffff8800c9f0a180, len = 22, expected = 96, status = -121
[  170.888968] xhci_hcd 0000:00:14.0: Stalled endpoint
[  170.888988] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acfcf9c0, len = 0, expected = 13, status = -32
[  170.889099] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  170.889149] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  170.889200] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  170.889255] xhci_hcd 0000:00:14.0: Finding endpoint context
[  170.889291] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  170.889316] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  170.889340] xhci_hcd 0000:00:14.0: New dequeue segment = ffff8800ace27740 (virtual)
[  170.889365] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530b10 (DMA)
[  170.889390] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  170.889415] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff8800ace27740 (0x30530800 dma), new deq ptr = ffff880030530b10 (0x30530b10 dma), new cycle = 1
[  170.889441] xhci_hcd 0000:00:14.0: // Ding dong!
[  170.889469] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  170.889498] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530b11
[  170.898919] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  170.898943] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acec5a80, len = 22, expected = 96, status = -121
[  170.898984] xhci_hcd 0000:00:14.0: Stalled endpoint
[  170.899001] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acfcf9c0, len = 0, expected = 13, status = -32
[  170.899090] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  170.899141] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  170.899197] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  170.899254] xhci_hcd 0000:00:14.0: Finding endpoint context
[  170.899307] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  170.899362] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  170.899419] xhci_hcd 0000:00:14.0: New dequeue segment = ffff8800ace27740 (virtual)
[  170.899478] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x30530be0 (DMA)
[  170.899544] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  170.899569] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff8800ace27740 (0x30530800 dma), new deq ptr = ffff880030530be0 (0x30530be0 dma), new cycle = 1
[  170.899596] xhci_hcd 0000:00:14.0: // Ding dong!
[  170.899624] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  170.899655] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @30530be1
[  170.901673] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 74 bytes untransferred
[  170.901701] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acec5000, len = 22, expected = 96, status = -121
[  170.901752] xhci_hcd 0000:00:14.0: Stalled endpoint
[  170.901775] xhci_hcd 0000:00:14.0: Giveback URB ffff8800acfcf9c0, len = 0, expected = 13, status = -32
[  170.901862] xhci_hcd 0000:00:14.0: Queueing reset endpoint command
[  170.901891] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[  170.901918] xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
[  170.901940] xhci_hcd 0000:00:14.0: Finding endpoint context
[  170.901965] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
[  170.901987] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[  170.902011] xhci_hcd 0000:00:14.0: New dequeue segment = ffff8800ace27720 (virtual)
[  170.902033] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x305300b0 (DMA)
[  170.902057] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[  170.902080] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff8800ace27720 (0x30530000 dma), new deq ptr = ffff8800305300b0 (0x305300b0 dma), new cycle = 1
[  170.902105] xhci_hcd 0000:00:14.0: // Ding dong!
[  170.902135] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[  170.955136] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdc3
[  170.968966] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdc3
[  171.004274] kjournald starting.  Commit interval 5 seconds
[  171.004560] EXT3-fs (sdc1): using internal journal
[  171.004580] EXT3-fs (sdc1): recovery complete
[  171.004594] EXT3-fs (sdc1): mounted filesystem with ordered data mode
[  171.036032] EXT4-fs (sdc2): recovery complete
[  171.036054] EXT4-fs (sdc2): mounted filesystem with ordered data mode. Opts: (null)
[  171.037020] FAT-fs (sdc4): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[  171.059699] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 7 /dev/sdc3
[  200.435577] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[  200.435661] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[  200.435771] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  200.435902] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x4202c0
[  200.435981] xhci_hcd 0000:00:14.0: Get port status returned 0x4102c0
[  200.436125] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x4002c0
[  200.436317] xhci_hcd 0000:00:14.0: clear port link state change, actual port 1 status  = 0x2c0
[  200.436453] hub 2-0:1.0: warm reset port 2
[  200.490720] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2b0
[  200.490795] xhci_hcd 0000:00:14.0: Get port status returned 0x2b0
[  200.490938] hub 2-0:1.0: port 2 not warm reset yet, waiting 50ms
[  200.535973] xhci_hcd 0000:00:14.0: Port Status Change Event for port 6
[  200.536059] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[  200.546724] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2802a0
[  200.546800] xhci_hcd 0000:00:14.0: Get port status returned 0x3002a0
[  200.546964] xhci_hcd 0000:00:14.0: clear port reset change, actual port 1 status  = 0x802a0
[  200.547139] xhci_hcd 0000:00:14.0: clear port warm(BH) reset change, actual port 1 status  = 0x2a0
[  200.547299] xhci_hcd 0000:00:14.0: clear port link state change, actual port 1 status  = 0x2a0
[  200.547484] xhci_hcd 0000:00:14.0: clear port connect change, actual port 1 status  = 0x2a0
[  200.547651] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[  200.547713] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  200.547831] xhci_hcd 0000:00:14.0: Disable port 1
[  200.547973] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x280
[  200.548031] xhci_hcd 0000:00:14.0: Get port status returned 0x280
[  200.548161] xhci_hcd 0000:00:14.0: Enable port 1
[  200.548273] hub 2-0:1.0: port 2, status 02c0, change 0041, 5.0 Gb/s
[  200.548311] usb 2-2: USB disconnect, device number 5
[  200.548338] usb 2-2: unregistering device
[  200.548363] usb 2-2: unregistering interface 2-2:1.0
[  200.548603] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[  200.548735] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  200.548780] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[  200.548839] xhci_hcd 0000:00:14.0: Slot 8 Input Context:
[  200.548884] xhci_hcd 0000:00:14.0: @ffff8800317ab000 (virt) @317ab000 (dma) 0x000000 - drop flags
[  200.548933] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[  200.548980] xhci_hcd 0000:00:14.0: @ffff8800317ab008 (virt) @317ab008 (dma) 0x000000 - rsvd2[0]
[  200.549079] xhci_hcd 0000:00:14.0: @ffff8800317ab010 (virt) @317ab010 (dma) 0x000000 - rsvd2[2]
[  200.549364] xhci_hcd 0000:00:14.0: @ffff8800317ab024 (virt) @317ab024 (dma) 0x060000 - dev_info2
[  200.549661] xhci_hcd 0000:00:14.0: @ffff8800317ab03c (virt) @317ab03c (dma) 0x000000 - rsvd[3]
[  200.549993] xhci_hcd 0000:00:14.0: @ffff8800317ab058 (virt) @317ab058 (dma) 0x000000 - rsvd[1]
[  200.550248] xhci_hcd 0000:00:14.0: Successful evaluate context command
[  200.550445] xhci_hcd 0000:00:14.0: @ffff88009892d004 (virt) @9892d004 (dma) 0x060000 - dev_info2
[  200.550715] xhci_hcd 0000:00:14.0: @ffff88009892d018 (virt) @9892d018 (dma) 0x000000 - rsvd[2]
[  200.551049] xhci_hcd 0000:00:14.0: @ffff88009892d034 (virt) @9892d034 (dma) 0x000000 - rsvd[0]
[  200.565568] end_request: I/O error, dev sdc, sector 0
[  200.566854] sd 9:0:0:0: [sdc] Synchronizing SCSI cache
[  200.567036] sd 9:0:0:0: [sdc]  
[  200.567066] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  200.567421] xhci_hcd 0000:00:14.0: Set up evaluate context for LPM MEL change.
[  200.567481] xhci_hcd 0000:00:14.0: Slot 8 Input Context:
[  200.567519] xhci_hcd 0000:00:14.0: @ffff8800317ab000 (virt) @317ab000 (dma) 0x000000 - drop flags
[  200.567565] xhci_hcd 0000:00:14.0: @ffff8800317ab004 (virt) @317ab004 (dma) 0x000001 - add flags
[  200.567613] xhci_hcd 0000:00:14.0: @ffff8800317ab008 (virt) @317ab008 (dma) 0x000000 - rsvd2[0]
[  200.567661] xhci_hcd 0000:00:14.0: @ffff8800317ab00c (virt) @317ab00c (dma) 0x000000 - rsvd2[1]
[  200.567709] xhci_hcd 0000:00:14.0: @ffff8800317ab010 (virt) @317ab010 (dma) 0x000000 - rsvd2[2]
[  200.567754] xhci_hcd 0000:00:14.0: @ffff8800317ab014 (virt) @317ab014 (dma) 0x000000 - rsvd2[3]
[  200.567800] xhci_hcd 0000:00:14.0: @ffff8800317ab018 (virt) @317ab018 (dma) 0x000000 - rsvd2[4]
[  200.567844] xhci_hcd 0000:00:14.0: @ffff8800317ab01c (virt) @317ab01c (dma) 0x000000 - rsvd2[5]
[  200.567885] xhci_hcd 0000:00:14.0: Slot Context:
[  200.567932] xhci_hcd 0000:00:14.0: @ffff8800317ab020 (virt) @317ab020 (dma) 0x20400000 - dev_info
[  200.567978] xhci_hcd 0000:00:14.0: @ffff8800317ab024 (virt) @317ab024 (dma) 0x06000a - dev_info2
[  200.568025] xhci_hcd 0000:00:14.0: @ffff8800317ab028 (virt) @317ab028 (dma) 0x000000 - tt_info
[  200.568072] xhci_hcd 0000:00:14.0: @ffff8800317ab02c (virt) @317ab02c (dma) 0x18000008 - dev_state
[  200.568114] xhci_hcd 0000:00:14.0: @ffff8800317ab030 (virt) @317ab030 (dma) 0x000000 - rsvd[0]
[  200.568159] xhci_hcd 0000:00:14.0: @ffff8800317ab034 (virt) @317ab034 (dma) 0x000000 - rsvd[1]
[  200.568205] xhci_hcd 0000:00:14.0: @ffff8800317ab038 (virt) @317ab038 (dma) 0x000000 - rsvd[2]
[  200.568249] xhci_hcd 0000:00:14.0: @ffff8800317ab03c (virt) @317ab03c (dma) 0x000000 - rsvd[3]
[  200.568297] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[  200.568340] xhci_hcd 0000:00:14.0: @ffff8800317ab040 (virt) @317ab040 (dma) 0x000000 - ep_info
[  200.568512] xhci_hcd 0000:00:14.0: @ffff8800317ab054 (virt) @317ab054 (dma) 0x000000 - rsvd[0]
[  200.568647] xhci_hcd 0000:00:14.0: Adding 0 ep ctxs, 12 now active.
[  200.568813] xhci_hcd 0000:00:14.0: Slot 8 Output Context:
[  200.569056] xhci_hcd 0000:00:14.0: @ffff88009892d010 (virt) @9892d010 (dma) 0x000000 - rsvd[0]
[  200.569221] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[  200.569352] xhci_hcd 0000:00:14.0: @ffff88009892d028 (virt) @9892d028 (dma) 0x8d68a401 - deq
[  200.569515] xhci_hcd 0000:00:14.0: @ffff88009892d03c (virt) @9892d03c (dma) 0x000000 - rsvd[2]
[  200.569678] xhci_hcd 0000:00:14.0: Slot 8 Input Context:
[  200.569851] xhci_hcd 0000:00:14.0: @ffff8800317ab00c (virt) @317ab00c (dma) 0x000000 - rsvd2[1]
[  200.570065] xhci_hcd 0000:00:14.0: Slot Context:
[  200.570240] xhci_hcd 0000:00:14.0: @ffff8800317ab02c (virt) @317ab02c (dma) 0x18000008 - dev_state
[  200.570367] xhci_hcd 0000:00:14.0: @ffff8800317ab038 (virt) @317ab038 (dma) 0x000000 - rsvd[2]
[  200.570543] xhci_hcd 0000:00:14.0: @ffff8800317ab044 (virt) @317ab044 (dma) 0x000000 - ep_info2
[  200.570726] xhci_hcd 0000:00:14.0: @ffff8800317ab058 (virt) @317ab058 (dma) 0x000000 - rsvd[1]
[  200.571002] xhci_hcd 0000:00:14.0: Successful evaluate context command
[  200.571132] xhci_hcd 0000:00:14.0: @ffff88009892d000 (virt) @9892d000 (dma) 0x20400000 - dev_info
[  200.571267] xhci_hcd 0000:00:14.0: @ffff88009892d00c (virt) @9892d00c (dma) 0x18000008 - dev_state
[  200.571438] xhci_hcd 0000:00:14.0: @ffff88009892d01c (virt) @9892d01c (dma) 0x000000 - rsvd[3]
[  200.571567] xhci_hcd 0000:00:14.0: @ffff88009892d024 (virt) @9892d024 (dma) 0x2000026 - ep_info2
[  200.571773] xhci_hcd 0000:00:14.0: @ffff88009892d03c (virt) @9892d03c (dma) 0x000000 - rsvd[2]
[  200.572004] usb 2-2: usb_set_device_initiated_lpm: Can't enable U2 state for unconfigured device.
[  200.572216] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  200.572314] xhci_hcd 0000:00:14.0: @ffff8800317ab000 (virt) @317ab000 (dma) 0x000000 - drop flags
[  200.572477] xhci_hcd 0000:00:14.0: @ffff8800317ab010 (virt) @317ab010 (dma) 0x000000 - rsvd2[2]
[  200.572635] xhci_hcd 0000:00:14.0: Slot Context:
[  200.572795] xhci_hcd 0000:00:14.0: @ffff8800317ab02c (virt) @317ab02c (dma) 0x18000008 - dev_state
[  200.572956] xhci_hcd 0000:00:14.0: @ffff8800317ab03c (virt) @317ab03c (dma) 0x000000 - rsvd[3]
[  200.573155] xhci_hcd 0000:00:14.0: @ffff8800317ab050 (virt) @317ab050 (dma) 0x000000 - tx_info
[  200.573363] xhci_hcd 0000:00:14.0: // Ding dong!
[  200.573503] xhci_hcd 0000:00:14.0: Slot Context:
[  200.573657] xhci_hcd 0000:00:14.0: @ffff88009892d00c (virt) @9892d00c (dma) 0x18000008 - dev_state
[  200.573851] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[  200.574081] xhci_hcd 0000:00:14.0: @ffff88009892d038 (virt) @9892d038 (dma) 0x000000 - rsvd[1]
[  200.574247] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff8800b7a3b800
[  200.574412] xhci_hcd 0000:00:14.0: @ffff88009892c004 (virt) @9892c004 (dma) 0x000001 - add flags
[  200.574588] xhci_hcd 0000:00:14.0: @ffff88009892c018 (virt) @9892c018 (dma) 0x000000 - rsvd2[4]
[  200.574769] xhci_hcd 0000:00:14.0: @ffff88009892c028 (virt) @9892c028 (dma) 0x000000 - tt_info
[  200.574975] xhci_hcd 0000:00:14.0: @ffff88009892c048 (virt) @9892c048 (dma) 0x8d68a401 - deq
[  200.575187] xhci_hcd 0000:00:14.0: Completed config ep cmd
[  200.575354] xhci_hcd 0000:00:14.0: @ffff88009892d008 (virt) @9892d008 (dma) 0x000000 - tt_info
[  200.575492] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[  200.575649] xhci_hcd 0000:00:14.0: @ffff88009892d03c (virt) @9892d03c (dma) 0x000000 - rsvd[2]
[  200.576026] xhci_hcd 0000:00:14.0: // Ding dong!
[  200.576066] xhci_hcd 0000:00:14.0: Dropped 1 ep ctxs, flags = 0x1, 9 now active.
[  200.600085] Buffer I/O error on device sdc1, logical block 0
[  200.600109] lost page write due to I/O error on sdc1
[  200.600125] EXT3-fs (sdc1): I/O error while writing superblock
[  200.606694] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[  200.606736] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  200.608207] Buffer I/O error on device sdc2, logical block 1081344
[  200.608230] lost page write due to I/O error on sdc2
[  200.608246] JBD2: Error -5 detected when updating journal superblock for sdc2-8.
[  200.638706] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[  200.638736] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  200.666717] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[  200.670725] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[  200.670754] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  200.702754] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[  200.702793] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  200.702840] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x2a0
[  200.702864] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  200.702894] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[  200.702916] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[  200.702968] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
[  200.703011] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
[  200.703054] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 2 status  = 0xe0002a0
[  200.703090] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 3 status  = 0xe0002a0
[  200.703112] hub 2-0:1.0: hub_suspend
[  200.703131] usb usb2: bus auto-suspend, wakeup 1
[  200.703153] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="log-3.13-rc1.txt"

[  802.906044] netpoll: netconsole: local port 6665
[  802.906051] netpoll: netconsole: local IPv4 address 0.0.0.0
[  802.906053] netpoll: netconsole: interface 'eth1'
[  802.906055] netpoll: netconsole: remote port 6666
[  802.906058] netpoll: netconsole: remote IPv4 address 10.7.201.41
[  802.906060] netpoll: netconsole: remote ethernet address 00:05:1b:72:1f:e1
[  802.906064] netpoll: netconsole: local IP 10.7.201.20
[  802.906989] console [netcon0] enabled
[  802.907012] netconsole: network logging started
[  852.175710] usb usb2: usb wakeup-resume
[  852.175766] usb usb2: usb auto-resume
[  852.175809] hub 2-0:1.0: hub_resume
[  852.175971] hub 2-0:1.0: port 2: status 0203 change 0001
[  852.280309] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0000
[  852.280477] hub 2-0:1.0: port 2, status 0203, change 0000, 5.0 Gb/s
[  852.392949] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
[  852.409562] usb 2-2: skipped 1 descriptor after endpoint
[  852.409611] usb 2-2: skipped 1 descriptor after endpoint
[  852.409649] usb 2-2: skipped 2 descriptors after endpoint
[  852.409681] usb 2-2: skipped 2 descriptors after endpoint
[  852.409715] usb 2-2: skipped 2 descriptors after endpoint
[  852.409746] usb 2-2: skipped 2 descriptors after endpoint
[  852.409916] usb 2-2: default language 0x0409
[  852.410455] usb 2-2: udev 2, busnum 2, minor = 129
[  852.410497] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
[  852.410525] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[  852.410552] usb 2-2: Product: Plugable USB3-SATA-UASP1
[  852.410576] usb 2-2: Manufacturer: ASM1053E
[  852.410609] usb 2-2: SerialNumber: 123456789045
[  852.411372] usb 2-2: usb_probe_device
[  852.411423] usb 2-2: configuration #1 chosen from 1 choice
[  852.412450] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[  852.413250] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  852.437158] usb-storage 2-2:1.0: usb_probe_interface
[  852.437187] usb-storage 2-2:1.0: usb_probe_interface - got id
[  852.437917] usbcore: registered new interface driver usb-storage
[  852.441190] uas 2-2:1.0: usb_probe_interface
[  852.441214] uas 2-2:1.0: usb_probe_interface - got id
[  852.444636] scsi6 : uas
[  852.445540] usbcore: registered new interface driver uas
[  852.445928] scsi 6:0:0:0: Direct-Access     ASM1053E Plugable USB3-SA 0    PQ: 0 ANSI: 6
[  852.446945] sd 6:0:0:0: Attached scsi generic sg1 type 0
[  852.454427] sd 6:0:0:0: [sdb] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[  852.455422] sd 6:0:0:0: [sdb] Write Protect is off
[  852.455448] sd 6:0:0:0: [sdb] Mode Sense: 43 00 00 00
[  852.455900] sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  852.459774]  sdb: sdb1 sdb2 sdb3 sdb4
[  852.464898] sd 6:0:0:0: [sdb] Attached SCSI disk
[  853.020475] kjournald starting.  Commit interval 5 seconds
[  853.021345] EXT3-fs (sdb1): using internal journal
[  853.021397] EXT3-fs (sdb1): recovery complete
[  853.021415] EXT3-fs (sdb1): mounted filesystem with ordered data mode
[  853.033034] EXT4-fs (sdb2): recovery complete
[  853.033425] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[  853.051873] FAT-fs (sdb4): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[  853.070019] EXT2-fs (sdb3): warning: mounting unchecked fs, running e2fsck is recommended
[  853.184420] systemd-hostnamed[2810]: Warning: nss-myhostname is not installed. Changing the local hostname might make it unresolveable. Please install nss-myhostname!
[  858.304415] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  858.304739] hub 2-0:1.0: warm reset port 2
[  858.360377] hub 2-0:1.0: port 2 not warm reset yet, waiting 50ms
[  858.376078] sd 6:0:0:0: [sdb] uas_cmd_cmplt ffff88004fa45c00 tag 0, inflight: CMD OUT
[  858.376147] sd 6:0:0:0: [sdb] cmd cmplt err -71
[  858.379677] sd 6:0:0:0: [sdb] uas_cmd_cmplt ffff8800504f7600 tag 1, inflight: CMD OUT
[  858.379761] sd 6:0:0:0: [sdb] cmd cmplt err -71
[  858.417202] hub 2-0:1.0: port 2, status 02c0, change 0041, 5.0 Gb/s
[  858.417256] usb 2-2: USB disconnect, device number 2
[  858.417285] usb 2-2: unregistering device
[  858.417322] usb 2-2: unregistering interface 2-2:1.0
[  858.417699] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[  858.417833] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  858.417970] xhci_hcd 0000:00:14.0: shutdown urb ffff88004fbbc240 ep2out-bulk
[  858.417992] sd 6:0:0:0: [sdb] uas_data_cmplt ffff88004fa45c00 tag 0, inflight: CMD
[  858.417995] sd 6:0:0:0: [sdb] data cmplt err -108 stream 2
[  858.418070] xhci_hcd 0000:00:14.0: shutdown urb ffff880072ab43c0 ep2out-bulk
[  858.418164] sd 6:0:0:0: [sdb] uas_data_cmplt ffff8800504f7600 tag 1, inflight: CMD
[  858.418194] sd 6:0:0:0: [sdb] data cmplt err -108 stream 3
[  858.418245] xhci_hcd 0000:00:14.0: shutdown urb ffff88004fbbc780 ep3in-bulk
[  858.418255] usb 2-2: stat urb: status -108
[  858.418296] xhci_hcd 0000:00:14.0: shutdown urb ffff880072ab40c0 ep3in-bulk
[  858.421620] xhci_hcd 0000:00:14.0: ERROR Transfer event for disabled endpoint or incorrect stream ring
[  858.421673] xhci_hcd 0000:00:14.0: @00000000311854a0 00000000 00000000 04000000 05078001
[  858.421709] usb 2-2: stat urb: status -108
[  858.421743] sd 6:0:0:0: [sdb] uas_disconnect ffff88004fa45c00 tag 0, inflight: CMD
[  858.421803] sd 6:0:0:0: [sdb] uas_disconnect ffff8800504f7600 tag 1, inflight: CMD
[  858.421849] sd 6:0:0:0: [sdb] uas_zap_dead ffff88004fa45c00 tag 0, inflight: CMD abort
[  858.421896] sd 6:0:0:0: [sdb] abort completed
[  858.421944] sd 6:0:0:0: [sdb] uas_zap_dead ffff8800504f7600 tag 1, inflight: CMD abort
[  858.421989] sd 6:0:0:0: [sdb] abort completed
[  858.422105] sd 6:0:0:0: [sdb] Unhandled error code
[  858.422143] sd 6:0:0:0: [sdb]  
[  858.422177] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  858.422210] sd 6:0:0:0: [sdb] CDB: 
[  858.422255] end_request: I/O error, dev sdb, sector 29624320
[  858.422271] Buffer I/O error on device sdb2, logical block 1081344
[  858.422287] lost page write due to I/O error on sdb2
[  858.422307] JBD2: Error -5 detected when updating journal superblock for sdb2-8.
[  858.422320] sd 6:0:0:0: [sdb] Unhandled error code
[  858.422321] sd 6:0:0:0: [sdb]  
[  858.422396] Aborting journal on device sdb1.
[  858.430924] EXT2-fs (sdb3): previous I/O error to superblock detected
[  858.430924] 
[  858.431347] end_request: I/O error, dev sdb, sector 0
[  858.436076] sd 6:0:0:0: [sdb] Synchronizing SCSI cache
[  858.472462] EXT2-fs (sdb3): previous I/O error to superblock detected
[  858.472462] 
[  858.480520] EXT2-fs (sdb3): previous I/O error to superblock detected
[  858.480520] 
[  858.504997] EXT3-fs (sdb1): error: ext3_put_super: Couldn't clean up the journal
[  858.505020] EXT3-fs (sdb1): error: remounting filesystem read-only
[  858.528321] end_request: I/O error, dev sdb, sector 0
[  858.528430] EXT4-fs error (device sdb2): ext4_put_super:791: Couldn't clean up the journal
[  858.528470] EXT4-fs (sdb2): Remounting filesystem read-only
[  858.536348] sd 6:0:0:0: [sdb]  
[  858.536374] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[  858.538823] usb 2-2: usb_set_device_initiated_lpm: Can't enable U1 state for unconfigured device.
[  858.538883] usb 2-2: usb_set_device_initiated_lpm: Can't enable U2 state for unconfigured device.
[  858.538987] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[  858.539031] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  858.539080] usb 2-2: usb_disable_device nuking all URBs
[  858.664463] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x2a0
[  858.664491] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  858.664618] hub 2-0:1.0: hub_suspend
[  858.664640] usb usb2: bus auto-suspend, wakeup 1
[  870.602581] usb usb2: usb wakeup-resume
[  870.602635] usb usb2: usb auto-resume
[  870.602710] hub 2-0:1.0: hub_resume
[  870.602875] hub 2-0:1.0: port 2: status 0203 change 0001
[  870.704450] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0000
[  870.704604] hub 2-0:1.0: port 2, status 0203, change 0000, 5.0 Gb/s
[  870.817061] usb 2-2: new SuperSpeed USB device number 3 using xhci_hcd
[  870.833830] usb 2-2: skipped 1 descriptor after endpoint
[  870.833881] usb 2-2: skipped 1 descriptor after endpoint
[  870.833921] usb 2-2: skipped 2 descriptors after endpoint
[  870.833953] usb 2-2: skipped 2 descriptors after endpoint
[  870.833992] usb 2-2: skipped 2 descriptors after endpoint
[  870.834027] usb 2-2: skipped 2 descriptors after endpoint
[  870.834244] usb 2-2: default language 0x0409
[  870.834758] usb 2-2: udev 3, busnum 2, minor = 130
[  870.834801] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
[  870.834831] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[  870.834858] usb 2-2: Product: Plugable USB3-SATA-UASP1
[  870.834894] usb 2-2: Manufacturer: ASM1053E
[  870.834926] usb 2-2: SerialNumber: 123456789045
[  870.835656] usb 2-2: usb_probe_device
[  870.835695] usb 2-2: configuration #1 chosen from 1 choice
[  870.837971] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[  870.838356] usb-storage 2-2:1.0: usb_probe_interface
[  870.838399] usb-storage 2-2:1.0: usb_probe_interface - got id
[  870.839326] uas 2-2:1.0: usb_probe_interface
[  870.839363] uas 2-2:1.0: usb_probe_interface - got id
[  870.845104] scsi7 : uas
[  870.846711] scsi 7:0:0:0: Direct-Access     ASM1053E Plugable USB3-SA 0    PQ: 0 ANSI: 6
[  870.847843] sd 7:0:0:0: Attached scsi generic sg1 type 0
[  870.849056] sd 7:0:0:0: [sdb] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[  870.849891] sd 7:0:0:0: [sdb] Write Protect is off
[  870.849909] sd 7:0:0:0: [sdb] Mode Sense: 43 00 00 00
[  870.850260] sd 7:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  870.854224]  sdb: sdb1 sdb2 sdb3 sdb4
[  870.858204] sd 7:0:0:0: [sdb] Attached SCSI disk
[  871.515166] kjournald starting.  Commit interval 5 seconds
[  871.515524] EXT3-fs (sdb1): using internal journal
[  871.515543] EXT3-fs (sdb1): recovery complete
[  871.515558] EXT3-fs (sdb1): mounted filesystem with ordered data mode
[  871.540410] FAT-fs (sdb4): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[  871.545510] EXT2-fs (sdb3): warning: mounting unchecked fs, running e2fsck is recommended
[  871.550416] EXT4-fs (sdb2): recovery complete
[  871.550442] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[  880.754423] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  880.754531] hub 2-0:1.0: warm reset port 2
[  880.775863] sd 7:0:0:0: [sdb] uas_cmd_cmplt ffff88004b262d00 tag 0, inflight: CMD IN
[  880.775910] sd 7:0:0:0: [sdb] cmd cmplt err -71
[  880.779444] sd 7:0:0:0: [sdb] uas_cmd_cmplt ffff88004b263000 tag 1, inflight: CMD IN
[  880.779560] sd 7:0:0:0: [sdb] cmd cmplt err -71
[  880.807049] hub 2-0:1.0: port 2 not warm reset yet, waiting 50ms
[  880.863624] hub 2-0:1.0: port 2, status 02c0, change 0041, 5.0 Gb/s
[  880.863672] usb 2-2: USB disconnect, device number 3
[  880.863691] usb 2-2: unregistering device
[  880.863716] usb 2-2: unregistering interface 2-2:1.0
[  880.863975] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[  880.864042] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  880.864123] xhci_hcd 0000:00:14.0: shutdown urb ffff88004b216cc0 ep1in-bulk
[  880.864166] xhci_hcd 0000:00:14.0: shutdown urb ffff88004b216480 ep1in-bulk
[  880.864183] sd 7:0:0:0: [sdb] uas_data_cmplt ffff88004b262d00 tag 0, inflight: CMD
[  880.864186] sd 7:0:0:0: [sdb] data cmplt err -108 stream 2
[  880.864212] sd 7:0:0:0: [sdb] uas_data_cmplt ffff88004b263000 tag 1, inflight: CMD
[  880.864213] sd 7:0:0:0: [sdb] data cmplt err -108 stream 3
[  880.864266] xhci_hcd 0000:00:14.0: shutdown urb ffff88004b2163c0 ep3in-bulk
[  880.864276] usb 2-2: stat urb: status -108
[  880.864311] xhci_hcd 0000:00:14.0: shutdown urb ffff88004b216240 ep3in-bulk
[  880.867649] xhci_hcd 0000:00:14.0: ERROR Transfer event for disabled endpoint or incorrect stream ring
[  880.867684] xhci_hcd 0000:00:14.0: @0000000031185750 00000000 00000000 04000000 06078001
[  880.867712] usb 2-2: stat urb: status -108
[  880.867750] sd 7:0:0:0: [sdb] uas_disconnect ffff88004b262d00 tag 0, inflight: CMD
[  880.867770] sd 7:0:0:0: [sdb] uas_disconnect ffff88004b263000 tag 1, inflight: CMD
[  880.867788] sd 7:0:0:0: [sdb] uas_zap_dead ffff88004b262d00 tag 0, inflight: CMD abort
[  880.867809] sd 7:0:0:0: [sdb] abort completed
[  880.867828] sd 7:0:0:0: [sdb] uas_zap_dead ffff88004b263000 tag 1, inflight: CMD abort
[  880.867844] sd 7:0:0:0: [sdb] abort completed
[  880.867926] sd 7:0:0:0: [sdb] Unhandled error code
[  880.867942] sd 7:0:0:0: [sdb]  
[  880.867958] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  880.867973] sd 7:0:0:0: [sdb] CDB: 
[  880.867992] end_request: I/O error, dev sdb, sector 44077088
[  880.868024] sd 7:0:0:0: [sdb] Unhandled error code
[  880.868037] sd 7:0:0:0: [sdb]  
[  880.868049] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  880.877472] EXT2-fs (sdb3): previous I/O error to superblock detected
[  880.877472] 
[  880.884335] end_request: I/O error, dev sdb, sector 0
[  880.887467] sd 7:0:0:0: [sdb] Synchronizing SCSI cache
[  880.928361] JBD: Error -5 detected when updating journal superblock for sdb1.
[  880.928409] EXT3-fs (sdb1): I/O error while writing superblock
[  880.943684] EXT2-fs (sdb3): previous I/O error to superblock detected
[  880.943684] 
[  880.947195] EXT2-fs (sdb3): previous I/O error to superblock detected
[  880.947195] 
[  880.983284] end_request: I/O error, dev sdb, sector 0
[  880.983531] JBD2: Error -5 detected when updating journal superblock for sdb2-8.
[  880.995183] sd 7:0:0:0: [sdb]  
[  880.995211] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[  880.998041] usb 2-2: usb_set_device_initiated_lpm: Can't enable U1 state for unconfigured device.
[  880.999061] usb 2-2: usb_set_device_initiated_lpm: Can't enable U2 state for unconfigured device.
[  880.999192] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[  880.999236] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  880.999280] usb 2-2: usb_disable_device nuking all URBs
[  881.127245] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x2a0
[  881.127273] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  881.127396] hub 2-0:1.0: hub_suspend
[  881.127419] usb usb2: bus auto-suspend, wakeup 1
[  898.465375] usb usb2: usb wakeup-resume
[  898.465431] usb usb2: usb auto-resume
[  898.465478] hub 2-0:1.0: hub_resume
[  898.465646] hub 2-0:1.0: port 2: status 0203 change 0001
[  898.566789] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0000
[  898.566954] hub 2-0:1.0: port 2, status 0203, change 0000, 5.0 Gb/s
[  898.679398] usb 2-2: new SuperSpeed USB device number 4 using xhci_hcd
[  898.695978] usb 2-2: skipped 1 descriptor after endpoint
[  898.696028] usb 2-2: skipped 1 descriptor after endpoint
[  898.696071] usb 2-2: skipped 2 descriptors after endpoint
[  898.696099] usb 2-2: skipped 2 descriptors after endpoint
[  898.696134] usb 2-2: skipped 2 descriptors after endpoint
[  898.696167] usb 2-2: skipped 2 descriptors after endpoint
[  898.696332] usb 2-2: default language 0x0409
[  898.696870] usb 2-2: udev 4, busnum 2, minor = 131
[  898.696911] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
[  898.696940] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[  898.696966] usb 2-2: Product: Plugable USB3-SATA-UASP1
[  898.696993] usb 2-2: Manufacturer: ASM1053E
[  898.697022] usb 2-2: SerialNumber: 123456789045
[  898.697760] usb 2-2: usb_probe_device
[  898.697803] usb 2-2: configuration #1 chosen from 1 choice
[  898.698811] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[  898.699206] usb-storage 2-2:1.0: usb_probe_interface
[  898.699249] usb-storage 2-2:1.0: usb_probe_interface - got id
[  898.700432] uas 2-2:1.0: usb_probe_interface
[  898.700478] uas 2-2:1.0: usb_probe_interface - got id
[  898.706873] scsi8 : uas
[  898.709165] scsi 8:0:0:0: Direct-Access     ASM1053E Plugable USB3-SA 0    PQ: 0 ANSI: 6
[  898.710703] sd 8:0:0:0: Attached scsi generic sg1 type 0
[  898.711902] sd 8:0:0:0: [sdb] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[  898.713086] sd 8:0:0:0: [sdb] Write Protect is off
[  898.713118] sd 8:0:0:0: [sdb] Mode Sense: 43 00 00 00
[  898.713720] sd 8:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  898.718634]  sdb: sdb1 sdb2 sdb3 sdb4
[  898.723643] sd 8:0:0:0: [sdb] Attached SCSI disk
[  899.474583] kjournald starting.  Commit interval 5 seconds
[  899.475064] EXT3-fs (sdb1): using internal journal
[  899.475479] EXT3-fs (sdb1): recovery complete
[  899.475497] EXT3-fs (sdb1): mounted filesystem with ordered data mode
[  899.477401] FAT-fs (sdb4): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[  899.480273] EXT2-fs (sdb3): warning: mounting unchecked fs, running e2fsck is recommended
[  899.495845] EXT4-fs (sdb2): recovery complete
[  899.497765] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[  956.069799] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 4 /dev/sdb3
[  956.083298] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 4 /dev/sdb3
[  967.673600] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  967.673943] hub 2-0:1.0: warm reset port 2
[  967.728410] hub 2-0:1.0: port 2 not warm reset yet, waiting 50ms
[  967.785197] hub 2-0:1.0: port 2, status 02c0, change 0041, 5.0 Gb/s
[  967.785251] usb 2-2: USB disconnect, device number 4
[  967.785281] usb 2-2: unregistering device
[  967.785307] usb 2-2: unregistering interface 2-2:1.0
[  967.785694] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[  967.785845] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  967.787383] end_request: I/O error, dev sdb, sector 0
[  967.800661] sd 8:0:0:0: [sdb] Synchronizing SCSI cache
[  967.820727] EXT3-fs (sdb1): I/O error while writing superblock
[  967.840286] end_request: I/O error, dev sdb, sector 0
[  967.840421] JBD2: Error -5 detected when updating journal superblock for sdb2-8.
[  967.908354] sd 8:0:0:0: [sdb]  
[  967.908381] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[  967.909067] usb 2-2: usb_set_device_initiated_lpm: Can't enable U1 state for unconfigured device.
[  967.909137] usb 2-2: usb_set_device_initiated_lpm: Can't enable U2 state for unconfigured device.
[  967.909422] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[  967.909490] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  967.909555] usb 2-2: usb_disable_device nuking all URBs
[  968.036454] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x2a0
[  968.036483] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  968.036593] hub 2-0:1.0: hub_suspend
[  968.036615] usb usb2: bus auto-suspend, wakeup 1
[  971.015660] usb usb2: usb wakeup-resume
[  971.015719] usb usb2: usb auto-resume
[  971.015765] hub 2-0:1.0: hub_resume
[  971.015932] hub 2-0:1.0: port 2: status 0203 change 0001
[  971.118536] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0000
[  971.118684] hub 2-0:1.0: port 2, status 0203, change 0000, 5.0 Gb/s
[  971.231157] usb 2-2: new SuperSpeed USB device number 5 using xhci_hcd
[  971.247723] usb 2-2: skipped 1 descriptor after endpoint
[  971.247773] usb 2-2: skipped 1 descriptor after endpoint
[  971.247812] usb 2-2: skipped 2 descriptors after endpoint
[  971.247839] usb 2-2: skipped 2 descriptors after endpoint
[  971.247868] usb 2-2: skipped 2 descriptors after endpoint
[  971.247898] usb 2-2: skipped 2 descriptors after endpoint
[  971.248055] usb 2-2: default language 0x0409
[  971.248669] usb 2-2: udev 5, busnum 2, minor = 132
[  971.248711] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
[  971.248739] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[  971.248766] usb 2-2: Product: Plugable USB3-SATA-UASP1
[  971.248793] usb 2-2: Manufacturer: ASM1053E
[  971.248824] usb 2-2: SerialNumber: 123456789045
[  971.249599] usb 2-2: usb_probe_device
[  971.249653] usb 2-2: configuration #1 chosen from 1 choice
[  971.250678] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[  971.251138] usb-storage 2-2:1.0: usb_probe_interface
[  971.251194] usb-storage 2-2:1.0: usb_probe_interface - got id
[  971.252314] uas 2-2:1.0: usb_probe_interface
[  971.252354] uas 2-2:1.0: usb_probe_interface - got id
[  971.258098] scsi9 : uas
[  971.260485] scsi 9:0:0:0: Direct-Access     ASM1053E Plugable USB3-SA 0    PQ: 0 ANSI: 6
[  971.262382] sd 9:0:0:0: Attached scsi generic sg1 type 0
[  971.263341] sd 9:0:0:0: [sdb] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[  971.264615] sd 9:0:0:0: [sdb] Write Protect is off
[  971.264651] sd 9:0:0:0: [sdb] Mode Sense: 43 00 00 00
[  971.265248] sd 9:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  971.270821]  sdb: sdb1 sdb2 sdb3 sdb4
[  971.281098] sd 9:0:0:0: [sdb] Attached SCSI disk
[  971.689053] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 4 /dev/sdb3
[  971.704625] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 4 /dev/sdb3
[  971.831310] kjournald starting.  Commit interval 5 seconds
[  971.831843] EXT3-fs (sdb1): using internal journal
[  971.831873] EXT3-fs (sdb1): recovery complete
[  971.831893] EXT3-fs (sdb1): mounted filesystem with ordered data mode
[  971.845627] EXT4-fs (sdb2): recovery complete
[  971.846594] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[  971.855426] btrfs: device fsid 9f21ef28-0eac-4736-9964-db5378b877e4 devid 1 transid 4 /dev/sdb3
[  971.858570] btrfs: disk space caching is enabled
[  971.872340] btrfs: creating UUID tree
[  971.885633] FAT-fs (sdb4): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[  978.301455] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  978.301816] hub 2-0:1.0: warm reset port 2
[  978.355412] hub 2-0:1.0: port 2 not warm reset yet, waiting 50ms
[  978.412202] hub 2-0:1.0: port 2, status 02c0, change 0041, 5.0 Gb/s
[  978.412257] usb 2-2: USB disconnect, device number 5
[  978.412286] usb 2-2: unregistering device
[  978.412315] usb 2-2: unregistering interface 2-2:1.0
[  978.412664] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[  978.412812] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  978.429002] end_request: I/O error, dev sdb, sector 0
[  978.430689] sd 9:0:0:0: [sdb] Synchronizing SCSI cache
[  978.471372] btrfs: bdev /dev/sdb3 errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
[  978.475303] btrfs: bdev /dev/sdb3 errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
[  978.475337] btrfs: bdev /dev/sdb3 errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
[  978.475375] BTRFS error (device sdb3) in btrfs_commit_transaction:1890: errno=-5 IO failure (Error while writing out transaction)
[  978.475399] BTRFS info (device sdb3): forced readonly
[  978.475425] BTRFS warning (device sdb3): Skipping commit of aborted transaction.
[  978.475448] ------------[ cut here ]------------
[  978.475485] WARNING: CPU: 2 PID: 3330 at fs/btrfs/super.c:254 __btrfs_abort_transaction+0x50/0x110 [btrfs]()
[  978.475512] btrfs: Transaction aborted (error -5)
[  978.475567] CPU: 2 PID: 3330 Comm: umount Not tainted 3.13.0-rc1+ #126
[  978.475590] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
[  978.475618] Call Trace:
[  978.475640]  [<ffffffff81611853>] dump_stack+0x45/0x56
[  978.475664]  [<ffffffff8104744d>] warn_slowpath_common+0x7d/0xa0
[  978.475685]  [<ffffffff810474bc>] warn_slowpath_fmt+0x4c/0x50
[  978.475711]  [<ffffffffa024da50>] __btrfs_abort_transaction+0x50/0x110 [btrfs]
[  978.475742]  [<ffffffffa02771ae>] cleanup_transaction+0x6e/0x290 [btrfs]
[  978.475771]  [<ffffffff81088390>] ? prepare_to_wait_event+0x100/0x100
[  978.475798]  [<ffffffffa02780e2>] btrfs_commit_transaction+0x6d2/0x940 [btrfs]
[  978.475982]  [<ffffffff8118ed56>] deactivate_super+0x46/0x60
[  978.539548] sd 9:0:0:0: [sdb]  
[  978.539622] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[  978.541614] usb 2-2: usb_set_device_initiated_lpm: Can't enable U1 state for unconfigured device.
[  978.541689] usb 2-2: usb_set_device_initiated_lpm: Can't enable U2 state for unconfigured device.
[  978.541800] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[  978.541840] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[  978.541878] usb 2-2: usb_disable_device nuking all URBs
[  978.567688] Buffer I/O error on device sdb1, logical block 0
[  978.567712] lost page write due to I/O error on sdb1
[  978.567725] EXT3-fs (sdb1): I/O error while writing superblock
[  978.596095] Buffer I/O error on device sdb2, logical block 1081344
[  978.596118] lost page write due to I/O error on sdb2
[  978.596146] JBD2: Error -5 detected when updating journal superblock for sdb2-8.
[  978.596400] ------------[ cut here ]------------
[  978.596423] WARNING: CPU: 1 PID: 3333 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  978.596439] sysfs group ffffffff81c927a0 not found for kobject 'target9:0:0'
[  978.596502] CPU: 1 PID: 3333 Comm: umount Tainted: G        W    3.13.0-rc1+ #126
[  978.596522] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
[  978.596542] Call Trace:
[  978.596569]  [<ffffffff81611853>] dump_stack+0x45/0x56
[  978.596590]  [<ffffffff8104744d>] warn_slowpath_common+0x7d/0xa0
[  978.596616]  [<ffffffff810474bc>] warn_slowpath_fmt+0x4c/0x50
[  978.596631]  [<ffffffff8120202e>] ? sysfs_get_dirent_ns+0x4e/0x70
[  978.596650]  [<ffffffff812032f6>] sysfs_remove_group+0xc6/0xd0
[  978.596675]  [<ffffffff814029c3>] dpm_sysfs_remove+0x43/0x50
[  978.596693]  [<ffffffff813f89e5>] device_del+0x45/0x1c0
[  978.596719]  [<ffffffff81429487>] scsi_target_reap_usercontext+0x27/0x40
[  978.596735]  [<ffffffff81061b37>] execute_in_process_context+0x67/0x70
[  978.596754]  [<ffffffff8142a924>] scsi_target_reap+0xc4/0xf0
[  978.596926]  [<ffffffff8141efbb>] scsi_device_put+0x3b/0x50
[  978.597149]  [<ffffffff81620516>] system_call_fastpath+0x1a/0x1f
[  978.597376] invalid opcode: 0000 [#1]  configfs x86_pkg_temp_thermal lrw mac80211 snd_usb_audio cfg80211 snd_seq_device xor libahci drm[  978.599392] CPU: 1 PID: 3333 Comm: umount Tainted: G        W    3.13.0-rc1+ #126
[  978.599545] RIP: 0010:[<ffffffff812e6c94>] [  978.599730] RSP: 0018:ffff880045a1bbb0  EFLAGS: 00010246
[  978.599948] R13: ffff88003f9a1000 R14: ffff88003f12ec28 R15: ffff8800714b4000
[  978.600121] Stack:
[  978.600252]  ffff88003f9a1000[  978.600359]  ffffffff81c91b60[  978.600472] Call Trace:
[  978.600589]  [<ffffffff8130c837>] kobject_cleanup+0x77/0x1b0
[  978.600711]  [<ffffffff8142938f>] scsi_target_dev_release+0x1f/0x30
[  978.600838]  [<ffffffff8130c6f0>] kobject_put+0x30/0x60
[  978.600969]  [<ffffffff81061b37>] execute_in_process_context+0x67/0x70
[  978.601058]  [<ffffffff813f8032>] device_release+0x32/0xa0
[  978.601182]  [<ffffffff813f8327>] put_device+0x17/0x20
[  978.601264]  [<ffffffff81434000>] scsi_disk_put+0x30/0x50
[  978.601388]  [<ffffffff811c49e2>] __blkdev_put+0x112/0x1b0
[  978.602570]  [<ffffffff811c537c>] blkdev_put+0x4c/0x120
[  978.604905]  [<ffffffff8118e4e4>] kill_block_super+0x44/0x70
[  978.605953]  [<ffffffff8118e7ad>] deactivate_locked_super+0x3d/0x60
[  978.607006]  [<ffffffff8118ed56>] deactivate_super+0x46/0x60
[  978.608009]  [<ffffffff811aaa91>] mntput_no_expire+0xd1/0x160
[  978.608944]  [<ffffffff811abf3e>] SyS_umount+0x8e/0x100
[  978.609837]  [<ffffffff81620516>] system_call_fastpath+0x1a/0x1f
[  978.610690] Code: e8 b2 c2 e8 ff 5b b8 01 00 00 00 5d c3 0f 0b 1f 00 89 ff <0f> 84 00 00 00 00 00 0f 55 
[  978.613697] RIP  [<ffffffff812e6c94>] blk_free_tags+0x14/0x20
[  978.614583]  RSP <ffff880045a1bbb0>
[  978.621197] ---[ end trace f8229c0a7483dbed ]---
[  978.683521] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x2a0
[  978.683545] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  978.683670] hub 2-0:1.0: hub_suspend
[  978.683693] usb usb2: bus auto-suspend, wakeup 1
[ 1018.269005] usb usb2: usb wakeup-resume
[ 1018.269062] usb usb2: usb auto-resume
[ 1018.269110] hub 2-0:1.0: hub_resume
[ 1018.269280] hub 2-0:1.0: port 2: status 0203 change 0001
[ 1018.369655] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0000
[ 1018.369833] hub 2-0:1.0: port 2, status 0203, change 0000, 5.0 Gb/s
[ 1018.482248] usb 2-2: new SuperSpeed USB device number 6 using xhci_hcd
[ 1018.498846] usb 2-2: skipped 1 descriptor after endpoint
[ 1018.498900] usb 2-2: skipped 1 descriptor after endpoint
[ 1018.498939] usb 2-2: skipped 2 descriptors after endpoint
[ 1018.498969] usb 2-2: skipped 2 descriptors after endpoint
[ 1018.499003] usb 2-2: skipped 2 descriptors after endpoint
[ 1018.499036] usb 2-2: skipped 2 descriptors after endpoint
[ 1018.499194] usb 2-2: default language 0x0409
[ 1018.499752] usb 2-2: udev 6, busnum 2, minor = 133
[ 1018.499792] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
[ 1018.499821] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[ 1018.499849] usb 2-2: Product: Plugable USB3-SATA-UASP1
[ 1018.499873] usb 2-2: Manufacturer: ASM1053E
[ 1018.499902] usb 2-2: SerialNumber: 123456789045
[ 1018.500620] usb 2-2: usb_probe_device
[ 1018.500667] usb 2-2: configuration #1 chosen from 1 choice
[ 1018.501570] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[ 1018.502029] usb-storage 2-2:1.0: usb_probe_interface
[ 1018.502085] usb-storage 2-2:1.0: usb_probe_interface - got id
[ 1018.503204] uas 2-2:1.0: usb_probe_interface
[ 1018.503254] uas 2-2:1.0: usb_probe_interface - got id
[ 1018.509600] scsi10 : uas
[ 1018.511684] scsi 10:0:0:0: Direct-Access     ASM1053E Plugable USB3-SA 0    PQ: 0 ANSI: 6
[ 1018.513096] sd 10:0:0:0: Attached scsi generic sg1 type 0
[ 1018.514067] sd 10:0:0:0: [sdb] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[ 1018.514994] sd 10:0:0:0: [sdb] Write Protect is off
[ 1018.515015] sd 10:0:0:0: [sdb] Mode Sense: 43 00 00 00
[ 1018.515404] sd 10:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1060.590853] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[ 1060.591203] hub 2-0:1.0: warm reset port 2
[ 1060.645598] hub 2-0:1.0: port 2 not warm reset yet, waiting 50ms
[ 1060.702265] hub 2-0:1.0: port 2, status 02c0, change 0041, 5.0 Gb/s
[ 1060.702317] usb 2-2: USB disconnect, device number 6
[ 1060.702346] usb 2-2: unregistering device
[ 1060.702374] usb 2-2: unregistering interface 2-2:1.0
[ 1060.702718] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
[ 1060.702867] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
[ 1306.845928] waiting module removal not supported: please upgrade
[ 1306.845978] xhci_hcd 0000:00:14.0: remove, state 1
[ 1306.846036] xhci_hcd 0000:00:14.0: roothub graceful disconnect
[ 1306.846065] usb usb2: USB disconnect, device number 1

--pf9I7BMVVzbSWLtt--
