From: Fabio Coatti <cova@ferrara.linux.it>
Subject: Re: Fw: Re: 2.6.10-rc2-mm3
Date: Wed, 24 Nov 2004 22:01:13 +0100
Message-ID: <200411242201.13815.cova@ferrara.linux.it>
References: <20041122162206.0d43cd30.akpm@osdl.org> <200411240128.14911.cova@ferrara.linux.it> <200411231816.38235.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <200411231816.38235.david-b@pacbell.net>
Content-Disposition: inline
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: David Brownell <david-b@pacbell.net>, linux-scsi@vger.kernel.org
Cc: linux-usb-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org

Alle 03:16, mercoledì 24 novembre 2004, David Brownell ha scritto:

> OK, so there may be two different problems then.  The one
> producing the stack backtraces from SCSI/kobject stuff;
> and a change in behavior related to USB.
>
> What happens if you set the "old_scheme_first" usbcore
> parameter?  One thing that changed since that kernel
> was that enumeration works a bit more like one of the
> schemes MS-Windows uses.

Ok, it seems that now the device is detected without problems at first try; 
I've tried several times with this setup in modprobe.conf:
options usbcore old_scheme_first=1
and I'm unable to reproduce the behaviour of missed detection of usb device, 
no matter how many times I can try, so I think you have hit the point, many 
thanks :)

As expected, the faulty behaviour of kobject is still here (double 
registration..), but now the device is working on first try, so half the 
problem is gone away :)
I get some scsi errors about unit not ready, but the driver seems to handle 
this quite well.
If this can be a useful information, on this box are present 5 different 
scsi-like devices: cdrom,cdwriter and scanner attached to aic7xxx controller, 
SATA disk on ich5/abit ic-7g builtin controller and flash usb key. So far the 
only strange behaviour is with usb flash key.

Below you can find as usual the full syslog report..

Many thanks for your help.

Nov 24 21:38:04 kefk kernel: hub 5-0:1.0: state 5 ports 8 chg ff00 evt 0008
Nov 24 21:38:04 kefk kernel: ehci_hcd 0000:00:1d.7: GetStatus port 3 status 
001803 POWER sig=j  CSC CONNECT
Nov 24 21:38:04 kefk kernel: hub 5-0:1.0: port 3, status 0501, change 0001, 
480 Mb/s
Nov 24 21:38:04 kefk kernel: hub 5-0:1.0: debounce: port 3: total 100ms stable 
100ms status 0x501
Nov 24 21:38:04 kefk kernel: ehci_hcd 0000:00:1d.7: port 3 high speed
Nov 24 21:38:04 kefk kernel: ehci_hcd 0000:00:1d.7: GetStatus port 3 status 
001005 POWER sig=se0  PE CONNECT
Nov 24 21:38:04 kefk kernel: usb 5-3: new high speed USB device using ehci_hcd 
and address 3
Nov 24 21:38:04 kefk kernel: usb 5-3: new device strings: Mfr=1, Product=2, 
SerialNumber=3
Nov 24 21:38:04 kefk kernel: usb 5-3: default language 0x0409
Nov 24 21:38:04 kefk kernel: usb 5-3: Product: Mass storage
Nov 24 21:38:04 kefk kernel: usb 5-3: Manufacturer: USB
Nov 24 21:38:04 kefk kernel: usb 5-3: SerialNumber: 142E19413C2FCA34
Nov 24 21:38:04 kefk kernel: usb 5-3: hotplug
Nov 24 21:38:04 kefk kernel: usb 5-3: adding 5-3:1.0 (config #1, interface 0)
Nov 24 21:38:04 kefk kernel: usb 5-3:1.0: hotplug
Nov 24 21:38:04 kefk kernel: Initializing USB Mass Storage driver...
Nov 24 21:38:04 kefk kernel: usb-storage 5-3:1.0: usb_probe_interface
Nov 24 21:38:04 kefk kernel: usb-storage 5-3:1.0: usb_probe_interface - got id
Nov 24 21:38:04 kefk kernel: scsi3 : SCSI emulation for USB Mass Storage 
devices
Nov 24 21:38:04 kefk kernel: usbcore: registered new driver usb-storage
Nov 24 21:38:04 kefk kernel: USB Mass Storage support registered.
Nov 24 21:38:04 kefk kernel: usb-storage: device found at 3
Nov 24 21:38:04 kefk kernel: usb-storage: waiting for device to settle before 
scanning
Nov 24 21:38:09 kefk kernel:   Vendor: 512MB     Model: USB2.0FlashDrive  Rev: 
2.00
Nov 24 21:38:09 kefk kernel:   Type:   Direct-Access                      ANSI 
SCSI revision: 02
Nov 24 21:38:09 kefk kernel: sdb: Unit Not Ready, sense:
Nov 24 21:38:09 kefk kernel: : Current: sense key=0x6
Nov 24 21:38:09 kefk kernel:     ASC=0x28 ASCQ=0x0
Nov 24 21:38:09 kefk kernel: sdb : READ CAPACITY failed.
Nov 24 21:38:09 kefk kernel: sdb : status=1, message=00, host=0, driver=08
Nov 24 21:38:09 kefk kernel: sd: Current: sense key=0x6
Nov 24 21:38:09 kefk kernel:     ASC=0x28 ASCQ=0x0
Nov 24 21:38:09 kefk kernel: sdb: test WP failed, assume Write Enabled
Nov 24 21:38:09 kefk kernel: sdb: assuming drive cache: write through
Nov 24 21:38:09 kefk kernel: sdb: Unit Not Ready, sense:
Nov 24 21:38:09 kefk kernel: : Current: sense key=0x6
Nov 24 21:38:09 kefk kernel:     ASC=0x28 ASCQ=0x0
Nov 24 21:38:09 kefk kernel: SCSI device sdb: 1024000 512-byte hdwr sectors 
(524 MB)
Nov 24 21:38:09 kefk kernel: sdb: Write Protect is off
Nov 24 21:38:09 kefk kernel: sdb: Mode Sense: 03 00 00 00
Nov 24 21:38:09 kefk kernel: sdb: assuming drive cache: write through
Nov 24 21:38:09 kefk kernel: SCSI device sdb: 1024000 512-byte hdwr sectors 
(524 MB)
Nov 24 21:38:09 kefk kernel: sdb: Write Protect is off
Nov 24 21:38:09 kefk kernel: sdb: Mode Sense: 03 00 00 00
Nov 24 21:38:09 kefk kernel: sdb: assuming drive cache: write through
Nov 24 21:38:09 kefk kernel:  sdb: sdb1
Nov 24 21:38:09 kefk kernel:  sdb: sdb1
Nov 24 21:38:09 kefk kernel: kobject_register failed for sdb1 (-17)
Nov 24 21:38:09 kefk kernel:  [bitmap_scnlistprintf+191/292] 
kobject_register+0x51/0x5f
Nov 24 21:38:09 kefk kernel:  [<c01f28eb>] kobject_register+0x51/0x5f
Nov 24 21:38:09 kefk kernel:  [stat_open+45/154] add_partition+0xbb/0xf0
Nov 24 21:38:09 kefk kernel:  [<c0185208>] add_partition+0xbb/0xf0
Nov 24 21:38:09 kefk kernel:  [cmdline_read_proc+9/103] 
register_disk+0xee/0x11d
Nov 24 21:38:09 kefk kernel:  [<c0185380>] register_disk+0xee/0x11d
Nov 24 21:38:09 kefk kernel:  [unregister_blkdev+144/232] add_disk+0x36/0x41
Nov 24 21:38:09 kefk kernel:  [<c02577d6>] add_disk+0x36/0x41
Nov 24 21:38:09 kefk kernel:  [unregister_blkdev+70/232] exact_match+0x0/0x7
Nov 24 21:38:09 kefk kernel:  [<c025778c>] exact_match+0x0/0x7
Nov 24 21:38:09 kefk kernel:  [unregister_blkdev+77/232] exact_lock+0x0/0xd
Nov 24 21:38:09 kefk kernel:  [<c0257793>] exact_lock+0x0/0xd
Nov 24 21:38:09 kefk kernel:  [sd_remove+76/82] sd_probe+0x224/0x32f
Nov 24 21:38:09 kefk kernel:  [<c02982c5>] sd_probe+0x224/0x32f
Nov 24 21:38:09 kefk kernel:  [msdos_partition+391/804] 
sysfs_make_dirent+0x1c/0x89
Nov 24 21:38:09 kefk kernel:  [<c0186927>] sysfs_make_dirent+0x1c/0x89
Nov 24 21:38:09 kefk kernel:  [msdos_partition+391/804] 
sysfs_make_dirent+0x1c/0x89
Nov 24 21:38:09 kefk kernel:  [<c0186927>] sysfs_make_dirent+0x1c/0x89
Nov 24 21:38:09 kefk kernel:  [__bus_for_each_drv+81/114] 
driver_probe_device+0x29/0x6a
Nov 24 21:38:09 kefk kernel:  [<c024efa0>] driver_probe_device+0x29/0x6a
Nov 24 21:38:09 kefk kernel:  [bus_for_each_drv+28/74] device_attach+0x46/0xaa
Nov 24 21:38:09 kefk kernel:  [<c024f027>] device_attach+0x46/0xaa
Nov 24 21:38:09 kefk kernel:  [fcntl_setlk+333/707] dput+0x76/0x209
Nov 24 21:38:09 kefk kernel:  [<c0168de2>] dput+0x76/0x209
Nov 24 21:38:09 kefk kernel:  [device_add_attrs+32/161] 
bus_add_device+0x55/0x97
Nov 24 21:38:09 kefk kernel:  [<c024f2ee>] bus_add_device+0x55/0x97
Nov 24 21:38:09 kefk kernel:  [device_remove_file+12/61] device_add+0xb9/0x15c
Nov 24 21:38:09 kefk kernel:  [<c024e2ee>] device_add+0xb9/0x15c
Nov 24 21:38:09 kefk kernel:  [scsi_sysfs_add_sdev+651/777] 
scsi_sysfs_add_sdev+0xa0/0x309
Nov 24 21:38:09 kefk kernel:  [<c0276649>] scsi_sysfs_add_sdev+0xa0/0x309
Nov 24 21:38:09 kefk kernel:  [scsi_probe_and_add_lun+292/425] 
scsi_add_lun+0x2d9/0x32f
Nov 24 21:38:09 kefk kernel:  [<c02751fc>] scsi_add_lun+0x2d9/0x32f
Nov 24 21:38:09 kefk kernel:  [scsi_sequential_lun_scan+142/239] 
scsi_probe_and_add_lun+0xbd/0x1c2
Nov 24 21:38:09 kefk kernel:  [<c027530f>] scsi_probe_and_add_lun+0xbd/0x1c2
Nov 24 21:38:09 kefk kernel:  [scsi_scan_host_selected+180/199] 
scsi_scan_target+0x9a/0x106
Nov 24 21:38:09 kefk kernel:  [<c0275a89>] scsi_scan_target+0x9a/0x106
Nov 24 21:38:09 kefk kernel:  [scsi_free_host_dev+51/64] 
scsi_scan_channel+0x7c/0x9a
Nov 24 21:38:09 kefk kernel:  [<c0275b71>] scsi_scan_channel+0x7c/0x9a
Nov 24 21:38:09 kefk kernel:  [check_set+39/139] 
scsi_scan_host_selected+0x6e/0xc7
Nov 24 21:38:09 kefk kernel:  [<c0275bfd>] scsi_scan_host_selected+0x6e/0xc7
Nov 24 21:38:09 kefk kernel:  [scsi_scan+22/193] scsi_scan_host+0x21/0x25
Nov 24 21:38:09 kefk kernel:  [<c0275c77>] scsi_scan_host+0x21/0x25
Nov 24 21:38:09 kefk kernel:  [pg0+946681578/1069159424] 
usb_stor_scan_thread+0x13a/0x14b [usb_storage]
Nov 24 21:38:09 kefk kernel:  [<f8b306ea>] usb_stor_scan_thread+0x13a/0x14b 
[usb_storage]
Nov 24 21:38:09 kefk kernel:  [do_timer_gettime+232/297] 
autoremove_wake_function+0x0/0x43
Nov 24 21:38:09 kefk kernel:  [<c012d031>] autoremove_wake_function+0x0/0x43
Nov 24 21:38:09 kefk kernel:  [copy_thread+542/592] ret_from_fork+0x6/0x14
Nov 24 21:38:09 kefk kernel:  [<c0102506>] ret_from_fork+0x6/0x14
Nov 24 21:38:09 kefk kernel:  [do_timer_gettime+232/297] 
autoremove_wake_function+0x0/0x43
Nov 24 21:38:09 kefk kernel:  [<c012d031>] autoremove_wake_function+0x0/0x43
Nov 24 21:38:09 kefk kernel:  [pg0+946681264/1069159424] 
usb_stor_scan_thread+0x0/0x14b [usb_storage]
Nov 24 21:38:09 kefk kernel:  [<f8b305b0>] usb_stor_scan_thread+0x0/0x14b 
[usb_storage]
Nov 24 21:38:09 kefk kernel:  [huft_build+637/1249] 
kernel_thread_helper+0x5/0xb
Nov 24 21:38:09 kefk kernel:  [<c01008a5>] kernel_thread_helper+0x5/0xb
Nov 24 21:38:09 kefk kernel: Attached scsi removable disk sdb at scsi3, 
channel 0, id 0, lun 0
Nov 24 21:38:09 kefk kernel: Attached scsi generic sg4 at scsi3, channel 0, id 
0, lun 0,  type 0
Nov 24 21:38:09 kefk kernel: usb-storage: device scan complete
Nov 24 21:38:09 kefk scsi.agent[7594]: disk 
at /devices/pci0000:00/0000:00:1d.7/usb5/5-3/5-3:1.0/host3/target3:0:0/3:0:0:0

after this, i can mount the device as sdb1 and use it without problems. On 
removal, this is the behaviour

Nov 24 21:40:11 kefk kernel: hub 5-0:1.0: state 5 ports 8 chg ff00 evt 0008
Nov 24 21:40:11 kefk kernel: ehci_hcd 0000:00:1d.7: GetStatus port 3 status 
001002 POWER sig=se0  CSC
Nov 24 21:40:11 kefk kernel: hub 5-0:1.0: port 3, status 0100, change 0001, 12 
Mb/s
Nov 24 21:40:11 kefk kernel: usb 5-3: USB disconnect, address 3
Nov 24 21:40:11 kefk kernel: usb 5-3: usb_disable_device nuking all URBs
Nov 24 21:40:11 kefk kernel: usb 5-3: unregistering interface 5-3:1.0
Nov 24 21:40:11 kefk kernel: BUG: atomic counter underflow at:
Nov 24 21:40:11 kefk kernel:  [create_dir+25/68] kref_put+0x48/0x92
Nov 24 21:40:11 kefk kernel:  [<c01f33aa>] kref_put+0x48/0x92
Nov 24 21:40:11 kefk kernel:  [storenote+15/185] del_gendisk+0x1d/0xd5
Nov 24 21:40:11 kefk kernel:  [<c0185588>] del_gendisk+0x1d/0xd5
Nov 24 21:40:11 kefk kernel:  [sr_media_change+27/157] sd_remove+0x17/0x52
Nov 24 21:40:11 kefk kernel:  [<c02983e7>] sd_remove+0x17/0x52
Nov 24 21:40:11 kefk kernel:  [device_attach+108/170] 
device_release_driver+0x6d/0x6f
Nov 24 21:40:11 kefk kernel:  [<c024f17d>] device_release_driver+0x6d/0x6f
Nov 24 21:40:11 kefk kernel:  [device_remove_attrs+20/90] 
bus_remove_device+0x53/0x90
Nov 24 21:40:11 kefk kernel:  [<c024f383>] bus_remove_device+0x53/0x90
Nov 24 21:40:11 kefk kernel:  [device_add+177/348] device_del+0x54/0x91
Nov 24 21:40:11 kefk kernel:  [<c024e416>] device_del+0x54/0x91
Nov 24 21:40:11 kefk kernel:  [scsi_sysfs_add_host+233/303] 
scsi_remove_device+0x4e/0xab
Nov 24 21:40:11 kefk kernel:  [<c0276900>] scsi_remove_device+0x4e/0xab
Nov 24 21:40:11 kefk kernel:  [scsi_scan+71/193] scsi_forget_host+0x2d/0x4f
Nov 24 21:40:11 kefk kernel:  [<c0275ca8>] scsi_forget_host+0x2d/0x4f
Nov 24 21:40:11 kefk kernel:  [scsi_device_lookup+63/106] 
scsi_remove_host+0x8/0x7c
Nov 24 21:40:11 kefk kernel:  [<c026fbbb>] scsi_remove_host+0x8/0x7c
Nov 24 21:40:11 kefk kernel:  [pg0+946682259/1069159424] 
storage_disconnect+0x7b/0x8d [usb_storage]
Nov 24 21:40:11 kefk kernel:  [<f8b30993>] storage_disconnect+0x7b/0x8d 
[usb_storage]
Nov 24 21:40:11 kefk kernel:  [pg0+944152901/1069159424] 
usb_unbind_interface+0x5e/0x60 [usbcore]
Nov 24 21:40:11 kefk kernel:  [<f88c7145>] usb_unbind_interface+0x5e/0x60 
[usbcore]
Nov 24 21:40:11 kefk kernel:  [device_attach+108/170] 
device_release_driver+0x6d/0x6f
Nov 24 21:40:11 kefk kernel:  [<c024f17d>] device_release_driver+0x6d/0x6f
Nov 24 21:40:11 kefk kernel:  [device_remove_attrs+20/90] 
bus_remove_device+0x53/0x90
Nov 24 21:40:11 kefk kernel:  [<c024f383>] bus_remove_device+0x53/0x90
Nov 24 21:40:11 kefk kernel:  [device_add+177/348] device_del+0x54/0x91
Nov 24 21:40:11 kefk kernel:  [<c024e416>] device_del+0x54/0x91
Nov 24 21:40:11 kefk kernel:  [pg0+944185103/1069159424] 
usb_disable_device+0xda/0x147 [usbcore]
Nov 24 21:40:11 kefk kernel:  [<f88cef0f>] usb_disable_device+0xda/0x147 
[usbcore]
Nov 24 21:40:11 kefk kernel:  [pg0+944163153/1069159424] 
usb_disconnect+0xa8/0x188 [usbcore]
Nov 24 21:40:11 kefk kernel:  [<f88c9951>] usb_disconnect+0xa8/0x188 [usbcore]
Nov 24 21:40:11 kefk kernel:  [pg0+944168454/1069159424] 
hub_port_connect_change+0x344/0x477 [usbcore]
Nov 24 21:40:11 kefk kernel:  [<f88cae06>] hub_port_connect_change+0x344/0x477 
[usbcore]
Nov 24 21:40:11 kefk kernel:  [pg0+944156904/1069159424] 
clear_port_feature+0x48/0x4d [usbcore]
Nov 24 21:40:11 kefk kernel:  [<f88c80e8>] clear_port_feature+0x48/0x4d 
[usbcore]
Nov 24 21:40:11 kefk kernel:  [pg0+944169571/1069159424] 
hub_events+0x32a/0x4f6 [usbcore]
Nov 24 21:40:11 kefk kernel:  [<f88cb263>] hub_events+0x32a/0x4f6 [usbcore]
Nov 24 21:40:11 kefk kernel:  [pg0+944170084/1069159424] hub_thread+0x35/0x10e 
[usbcore]
Nov 24 21:40:11 kefk kernel:  [<f88cb464>] hub_thread+0x35/0x10e [usbcore]
Nov 24 21:40:11 kefk kernel:  [do_timer_gettime+232/297] 
autoremove_wake_function+0x0/0x43
Nov 24 21:40:11 kefk kernel:  [<c012d031>] autoremove_wake_function+0x0/0x43
Nov 24 21:40:11 kefk kernel:  [copy_thread+542/592] ret_from_fork+0x6/0x14
Nov 24 21:40:11 kefk kernel:  [<c0102506>] ret_from_fork+0x6/0x14
Nov 24 21:40:11 kefk kernel:  [do_timer_gettime+232/297] 
autoremove_wake_function+0x0/0x43
Nov 24 21:40:11 kefk kernel:  [<c012d031>] autoremove_wake_function+0x0/0x43
Nov 24 21:40:11 kefk kernel:  [pg0+944170031/1069159424] hub_thread+0x0/0x10e 
[usbcore]
Nov 24 21:40:11 kefk kernel:  [<f88cb42f>] hub_thread+0x0/0x10e [usbcore]
Nov 24 21:40:11 kefk kernel:  [huft_build+637/1249] 
kernel_thread_helper+0x5/0xb
Nov 24 21:40:11 kefk kernel:  [<c01008a5>] kernel_thread_helper+0x5/0xb
Nov 24 21:40:11 kefk kernel: usb 5-3:1.0: hotplug
Nov 24 21:40:11 kefk kernel: usb 5-3: unregistering device
Nov 24 21:40:11 kefk kernel: usb 5-3: hotplug
Nov 24 21:40:11 kefk kernel: hub 5-0:1.0: debounce: port 3: total 100ms stable 
100ms status 0x100




-- 
Fabio Coatti       http://members.ferrara.linux.it/cova     
Ferrara Linux Users Group           http://ferrara.linux.it
GnuPG fp:9765 A5B6 6843 17BC A646  BE8C FA56 373A 5374 C703
Old SysOps never die... they simply forget their password.


-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now. 
http://productguide.itmanagersjournal.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
