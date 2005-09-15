From: Greg KH <greg@kroah.com>
Subject: oops on usb storage device disconnect with 2.6.14-rc1
Date: Thu, 15 Sep 2005 12:03:38 -0700
Message-ID: <20050915190338.GA6807@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
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
To: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: mdharm-usb@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

Here's a nice oops I get when removing a usb-storage device with
2.6.14-rc1.  I've also created a bug for this for those who like to
track bugzilla:
	http://bugzilla.kernel.org/show_bug.cgi?id=5265

Any ideas?

thanks,

greg k-h

-----------------------

hub 1-3:1.0: state 5 ports 4 chg 0000 evt 0010
hub 1-3:1.0: port 4, status 0100, change 0001, 12 Mb/s
usb 1-3.4: USB disconnect, address 6
usb 1-3.4: usb_disable_device nuking all URBs
usb 1-3.4: unregistering interface 1-3.4:1.0
bus usb: remove device 1-3.4:1.0
CLASS: Unregistering class device. ID = '2:0:0:0'
CLASS: Unregistering class device. ID = 'sg1'
kobject_hotplug
fill_kobj_path: path = '/class/scsi_generic/sg1'
class_hotplug - name = sg1
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb1/1-3/1-3.4/1-3.4:1.0/host2/target2:0:0/2:0:0:0'
kobject_hotplug: /sbin/udevsend scsi_generic seq=995 HOME=/ PATH=/sbin:/bin:/usr/sbin:/usr/bin ACTION=remove DEVPATH=/class/scsi_generic/sg1 SUBSYSTEM=scsi_generic
kobject sg1: cleaning up
device class 'sg1': release.
kobject <NULL>: cleaning up
kobject <NULL>: cleaning up
kobject_hotplug
fill_kobj_path: path = '/class/scsi_device/2:0:0:0'
class_hotplug - name = 2:0:0:0
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb1/1-3/1-3.4/1-3.4:1.0/host2/target2:0:0/2:0:0:0'
kobject_hotplug: /sbin/udevsend scsi_device seq=996 HOME=/ PATH=/sbin:/bin:/usr/sbin:/usr/bin ACTION=remove DEVPATH=/class/scsi_device/2:0:0:0 SUBSYSTEM=scsi_device
kobject 2:0:0:0: cleaning up
device class '2:0:0:0': release.
bus scsi: remove device 2:0:0:0
kobject sdb1: unregistering
kobject_hotplug
fill_kobj_path: path = '/block/sdb/sdb1'
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb1/1-3/1-3.4/1-3.4:1.0/host2/target2:0:0/2:0:0:0'
kobject_hotplug: /sbin/udevsend block seq=997 HOME=/ PATH=/sbin:/bin:/usr/sbin:/usr/bin ACTION=remove DEVPATH=/block/sdb/sdb1 SUBSYSTEM=block
kobject sdb1: cleaning up
kobject iosched: unregistering
kobject iosched: cleaning up
kobject queue: unregistering
kobject queue: cleaning up
kobject_hotplug
fill_kobj_path: path = '/block/sdb'
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb1/1-3/1-3.4/1-3.4:1.0/host2/target2:0:0/2:0:0:0'
kobject_hotplug: /sbin/udevsend block seq=998 HOME=/ PATH=/sbin:/bin:/usr/sbin:/usr/bin ACTION=remove DEVPATH=/block/sdb SUBSYSTEM=block
kobject sdb: cleaning up
PM: Removing info for scsi:2:0:0:0
kobject_hotplug
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb1/1-3/1-3.4/1-3.4:1.0/host2/target2:0:0/2:0:0:0'
kobject_hotplug: /sbin/udevsend scsi seq=999 HOME=/ PATH=/sbin:/bin:/usr/sbin:/usr/bin ACTION=remove DEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-3/1-3.4/1-3.4:1.0/host2/target2:0:0/2:0:0:0 SUBSYSTEM=scsi
kobject 2:0:0:0: cleaning up
Unable to handle kernel paging request at virtual address 6b6b6b9b
 printing eip:
c028f8cc
*pde = 00000000
Oops: 0002 [#1]
SMP 
Modules linked in: ub usb_storage usbhid uhci_hcd ehci_hcd usbcore
CPU:    1
EIP:    0060:[<c028f8cc>]    Not tainted VLI
EFLAGS: 00010286   (2.6.14-rc1-g1619cca2) 
EIP is at scsi_remove_device+0x39/0x4f
eax: 00000001   ebx: f711b2ec   ecx: 00000000   edx: 6b6b6b6b
esi: f7a28e60   edi: f7a28e58   ebp: f6f480bc   esp: f7bf7dbc
ds: 007b   es: 007b   ss: 0068
Process khubd (pid: 1292, threadinfo=f7bf6000 task=f7ac0030)
Stack: f711b4f8 00000066 f711b2ec f7a28e60 c028f963 f711b2ec f7a28e64 f7a28e60 
       f7a28e64 f7a28e68 c028e739 f6f480bc f7a28e60 f8aaab00 f8aaab20 f7a29380 
       c02869c2 f7a28e60 00000003 f7a290dc f8aaab00 f8a9bcc0 f7a28e60 f79ee2c8 
Call Trace:
 [<c028f963>] __scsi_remove_target+0x81/0xa9
 [<c028e739>] scsi_forget_host+0x3b/0x61
 [<c02869c2>] scsi_remove_host+0x49/0x93
 [<f8a9bcc0>] storage_disconnect+0x19/0x26 [usb_storage]
 [<f88351c3>] usb_unbind_interface+0x7e/0x80 [usbcore]
 [<f8835145>] usb_unbind_interface+0x0/0x80 [usbcore]
 [<c025e52d>] __device_release_driver+0x9a/0xbc
 [<c025e580>] device_release_driver+0x31/0x43
 [<c025dbbb>] bus_remove_device+0x96/0xb0
 [<c025ca16>] device_del+0x2c/0x6e
 [<f883f21d>] usb_disable_device+0x12b/0x1a0 [usbcore]
 [<f8838006>] usb_disconnect+0xcc/0x1c5 [usbcore]
 [<f883a394>] hub_port_connect_change+0x39c/0x53c [usbcore]
 [<f883a92c>] hub_events+0x3f8/0x622 [usbcore]
 [<f883ab6f>] hub_thread+0x19/0x101 [usbcore]
 [<c013630a>] autoremove_wake_function+0x0/0x57
 [<c013630a>] autoremove_wake_function+0x0/0x57
 [<f883ab56>] hub_thread+0x0/0x101 [usbcore]
 [<c0135e54>] kthread+0xba/0xf0
 [<c0135d9a>] kthread+0x0/0xf0
 [<c0101469>] kernel_thread_helper+0x5/0xb
Code: 14 8b 33 c7 44 24 04 66 00 00 00 c7 04 24 48 57 34 c0 e8 30 e3 e8 ff f0 ff 4e 30 0f 88 20 04 00 00 89 1c 24 e8 36 ff ff ff 8b 13 <f0> ff 42 30 0f 8e 19 04 00 00 8b 5c 24 08 8b 74 24 0c 83 c4 10 
 


-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
