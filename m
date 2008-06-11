From: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Wed, 11 Jun 2008 18:58:05 +0000
Message-ID: <200806111858.05114.chris2553@googlemail.com>
References: <200806010415.05290.chris2553@googlemail.com> <1212950276.3574.7.camel@localhost.localdomain> <200806102206.26818.chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_9ACUIUqnjbSMlTr"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:16354 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250AbYFKTAp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2008 15:00:45 -0400
Received: by ug-out-1314.google.com with SMTP id h2so171893ugf.16
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2008 12:00:42 -0700 (PDT)
In-Reply-To: <200806102206.26818.chris2553@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

--Boundary-00=_9ACUIUqnjbSMlTr
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi everyone,

[snip]

> > I'm starting to think this might be a distribution problem.  I tried
> > booting my laptop on your config (only system I have with ata_piix)
> > without an initrd (bit painful for fedora 9) and I didn't see any slow
> > downs (in fact it was a lot faster than previously; makes note to file
> > bug with redhat about their initramfs).

[snip]

> I'll do so more poking about tomorrow night, but if anyone has any ideas in
> the meantime, I'd be very grateful.
>

I've done that poking around and found something that to me looks interesting.

Before plugging in a usb stick, I changed udev's log_priority to "debug" (using 
udevcontrol). Attached is the snippet from /var/log/messages that shows all the 
diagnostics emitted by udev when the stick was plugged in. (This is with 
2.6.26-rc5-git5). You will see that there are several instances of a message 
about udev unsuccesfully waiting for a file ioerr_cnt to appear deep down in 
the guts of /sys. Eventually, it does appear, but only after 21 seconds have 
elapsed. On 2.6.25.6, the file appears almost as soon as udev starts looking 
for it. The log extract showing this is also attached as is an extract from the 
kernel log for 2.6.26-rc5-git5.

By the way, the main udev-rules file that is installed is the one for slackware 
that comes with the udev package from kernel.org.  So the file these tests were 
run with are that from udev-122, which I upgraded to earlier this evening (more 
in hope than expectation :-)




-- 
Beauty is in the eye of the beerholder.

--Boundary-00=_9ACUIUqnjbSMlTr
Content-Type: text/x-log;
  charset="utf-8";
  name="udevdebug-pluginusb-2.6.25.6.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="udevdebug-pluginusb-2.6.25.6.log"

Jun 11 17:38:03 upstairs udevd[695]: msg_queue_insert: seq 1435 queued, 'add' 'usb' 
Jun 11 17:38:03 upstairs udevd[695]: udev_event_run: seq 1435 forked, pid [4575], 'add' 'usb', 0 seconds old 
Jun 11 17:38:03 upstairs udevd[695]: msg_queue_insert: seq 1436 queued, 'add' 'usb_endpoint' 
Jun 11 17:38:03 upstairs udevd[695]: msg_queue_insert: seq 1437 queued, 'add' 'usb' 
Jun 11 17:38:03 upstairs udevd[695]: udev_done: seq 1435, pid [4575] exit with 0, 0 seconds old 
Jun 11 17:38:03 upstairs udevd[695]: udev_event_run: seq 1436 forked, pid [4578], 'add' 'usb_endpoint', 0 seconds old 
Jun 11 17:38:03 upstairs udevd[695]: udev_event_run: seq 1437 forked, pid [4579], 'add' 'usb', 0 seconds old 
Jun 11 17:38:03 upstairs udevd[695]: msg_queue_insert: seq 1438 queued, 'add' 'scsi_host' 
Jun 11 17:38:03 upstairs udevd[695]: udev_done: seq 1436, pid [4578] exit with 0, 0 seconds old 
Jun 11 17:38:03 upstairs udevd[695]: msg_queue_insert: seq 1439 queued, 'add' 'usb_endpoint' 
Jun 11 17:38:03 upstairs udevd[695]: msg_queue_insert: seq 1440 queued, 'add' 'usb_endpoint' 
Jun 11 17:38:03 upstairs udevd[695]: udev_done: seq 1437, pid [4579] exit with 0, 0 seconds old 
Jun 11 17:38:03 upstairs udevd[695]: udev_event_run: seq 1438 forked, pid [4582], 'add' 'scsi_host', 0 seconds old 
Jun 11 17:38:03 upstairs udevd[695]: udev_event_run: seq 1439 forked, pid [4583], 'add' 'usb_endpoint', 0 seconds old 
Jun 11 17:38:03 upstairs udevd-event[4575]: udev_rules_get_name: no node name set, will use kernel name '11-2' 
Jun 11 17:38:03 upstairs udevd-event[4575]: udev_db_get_device: no db file to read /dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2: No such file or directory 
Jun 11 17:38:03 upstairs udevd-event[4575]: udev_node_add: creating device node '/dev/11-2', major=189, minor=1283, mode=0660, uid=0, gid=0 
Jun 11 17:38:03 upstairs udevd-event[4575]: name_index: creating index: '/dev/.udev/names/11-2/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2' 
Jun 11 17:38:03 upstairs udevd-event[4575]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:38:03 upstairs udevd-event[4575]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:38:03 upstairs udevd-event[4575]: udev_event_run: seq 1435 finished with 0 
Jun 11 17:38:03 upstairs udevd[695]: udev_event_run: seq 1440 forked, pid [4584], 'add' 'usb_endpoint', 0 seconds old 
Jun 11 17:38:03 upstairs udevd[695]: udev_done: seq 1438, pid [4582] exit with 0, 0 seconds old 
Jun 11 17:38:03 upstairs udevd[695]: udev_done: seq 1439, pid [4583] exit with 0, 0 seconds old 
Jun 11 17:38:03 upstairs udevd[695]: udev_done: seq 1440, pid [4584] exit with 0, 0 seconds old 
Jun 11 17:38:03 upstairs udevd-event[4579]: run_program: '/sbin/modprobe usb:v0930p6545d0100dc00dsc00dp00ic08isc06ip50' 
Jun 11 17:38:03 upstairs udevd-event[4579]: run_program: '/sbin/modprobe' returned with status 0 
Jun 11 17:38:03 upstairs udevd-event[4579]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:38:03 upstairs udevd-event[4579]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:38:03 upstairs udevd-event[4579]: udev_event_run: seq 1437 finished with 0 
Jun 11 17:38:03 upstairs udevd-event[4578]: udev_rules_get_name: no node name set, will use kernel name 'usbdev11.4_ep00' 
Jun 11 17:38:03 upstairs udevd-event[4578]: udev_db_get_device: no db file to read /dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2fusb_endpoint\x2fusbdev11.4_ep00: No such file or directory 
Jun 11 17:38:03 upstairs udevd-event[4578]: udev_node_add: creating device node '/dev/usbdev11.4_ep00', major=254, minor=36, mode=0660, uid=0, gid=0 
Jun 11 17:38:03 upstairs udevd-event[4578]: name_index: creating index: '/dev/.udev/names/usbdev11.4_ep00/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2fusb_endpoint\x2fusbdev11.4_ep00' 
Jun 11 17:38:03 upstairs udevd-event[4578]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:38:03 upstairs udevd-event[4578]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:38:03 upstairs udevd-event[4578]: udev_event_run: seq 1436 finished with 0 
Jun 11 17:38:03 upstairs udevd-event[4582]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:38:03 upstairs udevd-event[4582]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:38:03 upstairs udevd-event[4582]: udev_event_run: seq 1438 finished with 0 
Jun 11 17:38:03 upstairs udevd-event[4583]: udev_rules_get_name: no node name set, will use kernel name 'usbdev11.4_ep81' 
Jun 11 17:38:03 upstairs udevd-event[4583]: udev_db_get_device: no db file to read /dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fusb_endpoint\x2fusbdev11.4_ep81: No such file or directory 
Jun 11 17:38:03 upstairs udevd-event[4583]: udev_node_add: creating device node '/dev/usbdev11.4_ep81', major=254, minor=37, mode=0660, uid=0, gid=0 
Jun 11 17:38:03 upstairs udevd-event[4583]: name_index: creating index: '/dev/.udev/names/usbdev11.4_ep81/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fusb_endpoint\x2fusbdev11.4_ep81' 
Jun 11 17:38:03 upstairs udevd-event[4583]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:38:03 upstairs udevd-event[4583]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:38:03 upstairs udevd-event[4583]: udev_event_run: seq 1439 finished with 0 
Jun 11 17:38:03 upstairs udevd-event[4584]: udev_rules_get_name: no node name set, will use kernel name 'usbdev11.4_ep02' 
Jun 11 17:38:03 upstairs udevd-event[4584]: udev_db_get_device: no db file to read /dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fusb_endpoint\x2fusbdev11.4_ep02: No such file or directory 
Jun 11 17:38:03 upstairs udevd-event[4584]: udev_node_add: creating device node '/dev/usbdev11.4_ep02', major=254, minor=38, mode=0660, uid=0, gid=0 
Jun 11 17:38:03 upstairs udevd-event[4584]: name_index: creating index: '/dev/.udev/names/usbdev11.4_ep02/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fusb_endpoint\x2fusbdev11.4_ep02' 
Jun 11 17:38:03 upstairs udevd-event[4584]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:38:03 upstairs udevd-event[4584]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:38:03 upstairs udevd-event[4584]: udev_event_run: seq 1440 finished with 0 
Jun 11 17:38:08 upstairs udevd[695]: msg_queue_insert: seq 1441 queued, 'add' 'scsi' 
Jun 11 17:38:08 upstairs udevd[695]: udev_event_run: seq 1441 forked, pid [4585], 'add' 'scsi', 0 seconds old 
Jun 11 17:38:08 upstairs udevd[695]: msg_queue_insert: seq 1442 queued, 'add' 'scsi_disk' 
Jun 11 17:38:08 upstairs udevd-event[4585]: wait_for_sysfs: file '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/ioerr_cnt' appeared after 0 loops 
Jun 11 17:38:08 upstairs udevd-event[4585]: run_program: '/sbin/modprobe scsi:t-0x00' 
Jun 11 17:38:08 upstairs udevd[695]: udev_done: seq 1441, pid [4585] exit with 0, 0 seconds old 
Jun 11 17:38:08 upstairs udevd-event[4585]: run_program: '/sbin/modprobe' (stderr) 'FATAL: Module scsi:t_0x00 not found.' 
Jun 11 17:38:08 upstairs udevd-event[4585]: run_program: '/sbin/modprobe' returned with status 1 
Jun 11 17:38:08 upstairs udevd-event[4585]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:38:08 upstairs udevd-event[4585]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:38:08 upstairs udevd-event[4585]: udev_event_run: seq 1441 finished with 0 
Jun 11 17:38:08 upstairs udevd[695]: udev_event_run: seq 1442 forked, pid [4587], 'add' 'scsi_disk', 0 seconds old 
Jun 11 17:38:08 upstairs udevd[695]: udev_done: seq 1442, pid [4587] exit with 0, 0 seconds old 
Jun 11 17:38:08 upstairs udevd-event[4587]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:38:08 upstairs udevd-event[4587]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:38:08 upstairs udevd-event[4587]: udev_event_run: seq 1442 finished with 0 
Jun 11 17:38:08 upstairs udevd[695]: msg_queue_insert: seq 1443 queued, 'change' 'scsi' 
Jun 11 17:38:08 upstairs udevd[695]: udev_event_run: seq 1443 forked, pid [4588], 'change' 'scsi', 0 seconds old 
Jun 11 17:38:08 upstairs udevd[695]: udev_done: seq 1443, pid [4588] exit with 0, 0 seconds old 
Jun 11 17:38:08 upstairs udevd[695]: msg_queue_insert: seq 1444 queued, 'add' 'block' 
Jun 11 17:38:08 upstairs udevd[695]: udev_event_run: seq 1444 forked, pid [4589], 'add' 'block', 0 seconds old 
Jun 11 17:38:08 upstairs udevd[695]: msg_queue_insert: seq 1445 queued, 'add' 'block' 
Jun 11 17:38:08 upstairs udevd-event[4588]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:38:08 upstairs udevd-event[4588]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:38:08 upstairs udevd-event[4588]: udev_event_run: seq 1443 finished with 0 
Jun 11 17:38:08 upstairs udevd[695]: msg_queue_insert: seq 1446 queued, 'add' 'scsi_device' 
Jun 11 17:38:08 upstairs udevd[695]: msg_queue_insert: seq 1447 queued, 'add' 'scsi_generic' 
Jun 11 17:38:08 upstairs udevd-event[4589]: udev_rules_get_name: rule applied, 'sdd' becomes 'sdd' 
Jun 11 17:38:08 upstairs udevd-event[4589]: run_program: '/lib/udev/usb_id -x' 
Jun 11 17:38:08 upstairs udevd-event[4589]: run_program: '/lib/udev/usb_id' (stdout) 'ID_VENDOR=0930' 
Jun 11 17:38:08 upstairs udevd-event[4589]: run_program: '/lib/udev/usb_id' (stdout) 'ID_MODEL=USB_Flash_Memory' 
Jun 11 17:38:08 upstairs udevd-event[4589]: run_program: '/lib/udev/usb_id' (stdout) 'ID_REVISION=5.00' 
Jun 11 17:38:08 upstairs udevd-event[4589]: run_program: '/lib/udev/usb_id' (stdout) 'ID_SERIAL=0930_USB_Flash_Memory_0EC065712361A91E-0:0' 
Jun 11 17:38:08 upstairs udevd-event[4589]: run_program: '/lib/udev/usb_id' (stdout) 'ID_SERIAL_SHORT=0EC065712361A91E' 
Jun 11 17:38:08 upstairs udevd-event[4589]: run_program: '/lib/udev/usb_id' (stdout) 'ID_TYPE=disk' 
Jun 11 17:38:08 upstairs udevd-event[4589]: run_program: '/lib/udev/usb_id' (stdout) 'ID_INSTANCE=0:0' 
Jun 11 17:38:08 upstairs udevd-event[4589]: run_program: '/lib/udev/usb_id' (stdout) 'ID_BUS=usb' 
Jun 11 17:38:08 upstairs udevd-event[4589]: run_program: '/lib/udev/usb_id' returned with status 0 
Jun 11 17:38:08 upstairs udevd-event[4589]: udev_rules_get_name: add symlink 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0' 
Jun 11 17:38:08 upstairs udevd-event[4589]: run_program: '/lib/udev/path_id /devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd' 
Jun 11 17:38:08 upstairs usb_id[4590]: usb_id: /devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0: if_class 8 protocol 6 
Jun 11 17:38:08 upstairs udevd-event[4589]: run_program: '/lib/udev/path_id' (stdout) 'ID_PATH=pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' 
Jun 11 17:38:08 upstairs udevd-event[4589]: run_program: '/lib/udev/path_id' returned with status 0 
Jun 11 17:38:08 upstairs udevd-event[4589]: udev_rules_get_name: add symlink 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' 
Jun 11 17:38:08 upstairs udevd[695]: udev_done: seq 1444, pid [4589] exit with 0, 0 seconds old 
Jun 11 17:38:08 upstairs udevd[695]: udev_event_run: seq 1445 forked, pid [4597], 'add' 'block', 0 seconds old 
Jun 11 17:38:08 upstairs udevd-event[4589]: udev_db_get_device: no db file to read /dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost5\x2ftarget5:0:0\x2f5:0:0:0\x2fblock\x2fsdd: No such file or directory 
Jun 11 17:38:08 upstairs udevd-event[4589]: udev_node_add: creating device node '/dev/sdd', major=8, minor=48, mode=0660, uid=0, gid=6 
Jun 11 17:38:08 upstairs udevd-event[4589]: name_index: creating index: '/dev/.udev/names/disk\x2fby-id\x2fusb-0930_USB_Flash_Memory_0EC065712361A91E-0:0/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost5\x2ftarget5:0:0\x2f5:0:0:0\x2fblock\x2fsdd' 
Jun 11 17:38:08 upstairs udevd-event[4589]: name_index: creating index: '/dev/.udev/names/disk\x2fby-path\x2fpci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost5\x2ftarget5:0:0\x2f5:0:0:0\x2fblock\x2fsdd' 
Jun 11 17:38:08 upstairs udevd-event[4589]: name_index: creating index: '/dev/.udev/names/sdd/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost5\x2ftarget5:0:0\x2f5:0:0:0\x2fblock\x2fsdd' 
Jun 11 17:38:08 upstairs udevd-event[4589]: udev_node_update_symlinks: update symlink 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0' of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd' 
Jun 11 17:38:08 upstairs udevd-event[4589]: udev_db_get_devices_by_name: found index directory '/dev/.udev/names/disk\x2fby-id\x2fusb-0930_USB_Flash_Memory_0EC065712361A91E-0:0' 
Jun 11 17:38:08 upstairs udevd-event[4589]: update_link: found 1 devices with name 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0' 
Jun 11 17:38:08 upstairs udevd-event[4589]: update_link: found '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd' for 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0' 
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_rules_get_name: add symlink 'usbstickc1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_rules_get_name: rule applied, 'sdd1' becomes 'sdd1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_rules_get_name: add symlink 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_rules_get_name: add symlink 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: run_program: '/lib/udev/vol_id --export /dev/.tmp-8-49' 
Jun 11 17:38:08 upstairs udevd-event[4589]: update_link: compare (our own) priority of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd' 0 >= 0 
Jun 11 17:38:08 upstairs udevd-event[4589]: update_link: 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0' with target 'sdd' has the highest priority 0, create it 
Jun 11 17:38:08 upstairs udevd-event[4589]: node_symlink: creating symlink '/dev/disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0' to '../../sdd' 
Jun 11 17:38:08 upstairs udevd-event[4589]: udev_node_update_symlinks: update symlink 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd' 
Jun 11 17:38:08 upstairs udevd-event[4589]: udev_db_get_devices_by_name: found index directory '/dev/.udev/names/disk\x2fby-path\x2fpci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' 
Jun 11 17:38:08 upstairs udevd-event[4589]: update_link: found 1 devices with name 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x0(0), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:369 read sbbuf len:0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x0(0), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: volume_id.c:362 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:38:08 upstairs vol_id[4598]: linux_raid.c:71 probing at offset 0x3d6e0000, size 0x3d6fc000 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6e0000(1030619136), len 0x800 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:405 read seekbuf off:0x3d6e0000 len:0x800 
Jun 11 17:38:08 upstairs udevd-event[4589]: update_link: found '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd' for 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' 
Jun 11 17:38:08 upstairs udevd-event[4589]: update_link: compare (our own) priority of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd' 0 >= 0 
Jun 11 17:38:08 upstairs udevd-event[4589]: update_link: 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' with target 'sdd' has the highest priority 0, create it 
Jun 11 17:38:08 upstairs udevd-event[4589]: node_symlink: creating symlink '/dev/disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' to '../../sdd' 
Jun 11 17:38:08 upstairs udevd-event[4589]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:38:08 upstairs udevd-event[4589]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:38:08 upstairs udevd-event[4589]: udev_event_run: seq 1444 finished with 0 
Jun 11 17:38:08 upstairs vol_id[4598]: linux_raid.c:126 probing at offset 0x3d6fa000, size 0x3d6fc000 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6fa000(1030725632), len 0x800 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:405 read seekbuf off:0x3d6fa000 len:0x800 
Jun 11 17:38:08 upstairs vol_id[4598]: linux_raid.c:126 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x0(0), len 0x800 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:369 read sbbuf len:0x800 
Jun 11 17:38:08 upstairs vol_id[4598]: linux_raid.c:126 probing at offset 0x1000, size 0x3d6fc000 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x1000(4096), len 0x800 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:369 read sbbuf len:0x1800 
Jun 11 17:38:08 upstairs vol_id[4598]: ddf_raid.c:49 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6fbe00(1030733312), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:405 read seekbuf off:0x3d6fbe00 len:0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: isw_raid.c:47 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6fbc00(1030732800), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:405 read seekbuf off:0x3d6fbc00 len:0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: lsi_raid.c:42 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6fbe00(1030733312), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:405 read seekbuf off:0x3d6fbe00 len:0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6fbe00(1030733312), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: silicon_raid.c:57 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6fbe00(1030733312), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: nvidia_raid.c:45 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6fbc00(1030732800), len 0x200 
Jun 11 17:38:08 upstairs udevd-event[4597]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_USAGE=filesystem' 
Jun 11 17:38:08 upstairs udevd-event[4597]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_TYPE=vfat' 
Jun 11 17:38:08 upstairs udevd-event[4597]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_VERSION=FAT16' 
Jun 11 17:38:08 upstairs udevd-event[4597]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_UUID=B4EE-B432' 
Jun 11 17:38:08 upstairs udevd-event[4597]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_UUID_ENC=B4EE-B432' 
Jun 11 17:38:08 upstairs udevd-event[4597]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_LABEL=' 
Jun 11 17:38:08 upstairs udevd-event[4597]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_LABEL_ENC=' 
Jun 11 17:38:08 upstairs udevd-event[4597]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_LABEL_SAFE=' 
Jun 11 17:38:08 upstairs udevd-event[4597]: run_program: '/lib/udev/vol_id' returned with status 0 
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_rules_get_name: add symlink 'disk/by-uuid/B4EE-B432' 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:405 read seekbuf off:0x3d6fbc00 len:0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: promise_raid.c:46 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6f4200(1030701568), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:405 read seekbuf off:0x3d6f4200 len:0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6dc200(1030603264), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:405 read seekbuf off:0x3d6dc200 len:0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6dc000(1030602752), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:405 read seekbuf off:0x3d6dc000 len:0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6fa000(1030725632), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:405 read seekbuf off:0x3d6fa000 len:0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6ca200(1030529536), len 0x200 
Jun 11 17:38:08 upstairs udevd[695]: udev_done: seq 1445, pid [4597] exit with 0, 0 seconds old 
Jun 11 17:38:08 upstairs udevd[695]: udev_event_run: seq 1446 forked, pid [4609], 'add' 'scsi_device', 0 seconds old 
Jun 11 17:38:08 upstairs udevd[695]: udev_event_run: seq 1447 forked, pid [4610], 'add' 'scsi_generic', 0 seconds old 
Jun 11 17:38:08 upstairs udevd[695]: udev_done: seq 1447, pid [4610] exit with 0, 0 seconds old 
Jun 11 17:38:08 upstairs udevd[695]: udev_done: seq 1446, pid [4609] exit with 1, 0 seconds old 
Jun 11 17:38:08 upstairs logger: udevshowicon: starting to get icon name
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_db_get_device: no db file to read /dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost5\x2ftarget5:0:0\x2f5:0:0:0\x2fblock\x2fsdd\x2fsdd1: No such file or directory 
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_node_add: creating device node '/dev/sdd1', major=8, minor=49, mode=0666, uid=0, gid=6 
Jun 11 17:38:08 upstairs udevd-event[4597]: name_index: creating index: '/dev/.udev/names/usbstickc1/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost5\x2ftarget5:0:0\x2f5:0:0:0\x2fblock\x2fsdd\x2fsdd1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: name_index: creating index: '/dev/.udev/names/disk\x2fby-id\x2fusb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost5\x2ftarget5:0:0\x2f5:0:0:0\x2fblock\x2fsdd\x2fsdd1' 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:405 read seekbuf off:0x3d6ca200 len:0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6faa00(1030728192), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:405 read seekbuf off:0x3d6faa00 len:0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: adaptec_raid.c:90 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6fbe00(1030733312), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:405 read seekbuf off:0x3d6fbe00 len:0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: jmicron_raid.c:43 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3d6fbe00(1030733312), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: lvm.c:54 probing at offset 0x0 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x400(1024), len 0x800 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x0(0), len 0x800 
Jun 11 17:38:08 upstairs vol_id[4598]: highpoint.c:52 probing at offset 0x0 
Jun 11 17:38:08 upstairs udevd-event[4597]: name_index: creating index: '/dev/.udev/names/disk\x2fby-path\x2fpci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost5\x2ftarget5:0:0\x2f5:0:0:0\x2fblock\x2fsdd\x2fsdd1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: name_index: creating index: '/dev/.udev/names/disk\x2fby-uuid\x2fB4EE-B432/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost5\x2ftarget5:0:0\x2f5:0:0:0\x2fblock\x2fsdd\x2fsdd1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: name_index: creating index: '/dev/.udev/names/sdd1/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost5\x2ftarget5:0:0\x2f5:0:0:0\x2fblock\x2fsdd\x2fsdd1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_node_update_symlinks: update symlink 'usbstickc1' of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd/sdd1' 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x1200(4608), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x0(0), len 0x200 
Jun 11 17:38:08 upstairs vol_id[4598]: volume_id.c:396 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:38:08 upstairs vol_id[4598]: fat.c:273 probing at offset 0x0 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x0(0), len 0x400 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x3da00(252416), len 0x4000 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:405 read seekbuf off:0x3da00 len:0x4000 
Jun 11 17:38:08 upstairs vol_id[4598]: util.c:356 get buffer off 0x0(0), len 0x200 
Jun 11 17:38:08 upstairs logger: udevshowicon: about to show usbstickc1
Jun 11 17:38:08 upstairs udevd-event[4610]: udev_rules_get_name: no node name set, will use kernel name 'sg5' 
Jun 11 17:38:08 upstairs udevd-event[4610]: udev_db_get_device: no db file to read /dev/.udev/db/\x2fclass\x2fscsi_generic\x2fsg5: No such file or directory 
Jun 11 17:38:08 upstairs udevd-event[4610]: udev_node_add: creating device node '/dev/sg5', major=21, minor=5, mode=0660, uid=0, gid=0 
Jun 11 17:38:08 upstairs udevd-event[4610]: name_index: creating index: '/dev/.udev/names/sg5/\x2fclass\x2fscsi_generic\x2fsg5' 
Jun 11 17:38:08 upstairs udevd-event[4610]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:38:08 upstairs udevd-event[4610]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:38:08 upstairs udevd-event[4610]: udev_event_run: seq 1447 finished with 0 
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_db_get_devices_by_name: found index directory '/dev/.udev/names/usbstickc1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: found 1 devices with name 'usbstickc1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: found '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd/sdd1' for 'usbstickc1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: compare (our own) priority of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd/sdd1' 0 >= 0 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: 'usbstickc1' with target 'sdd1' has the highest priority 0, create it 
Jun 11 17:38:08 upstairs udevd-event[4597]: node_symlink: creating symlink '/dev/usbstickc1' to 'sdd1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_node_update_symlinks: update symlink 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1' of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd/sdd1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_db_get_devices_by_name: found index directory '/dev/.udev/names/disk\x2fby-id\x2fusb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: found 1 devices with name 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: found '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd/sdd1' for 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: compare (our own) priority of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd/sdd1' 0 >= 0 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1' with target 'sdd1' has the highest priority 0, create it 
Jun 11 17:38:08 upstairs udevd-event[4609]: run_program: '/sbin/modprobe sd_mod' 
Jun 11 17:38:08 upstairs udevd-event[4609]: run_program: '/sbin/modprobe' (stderr) 'FATAL: Module sd_mod not found.' 
Jun 11 17:38:08 upstairs udevd-event[4609]: run_program: '/sbin/modprobe' returned with status 1 
Jun 11 17:38:08 upstairs udevd-event[4609]: run_program: '/sbin/modprobe sg' 
Jun 11 17:38:08 upstairs udevd-event[4609]: run_program: '/sbin/modprobe' returned with status 0 
Jun 11 17:38:08 upstairs udevd-event[4609]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:38:08 upstairs udevd-event[4609]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:38:08 upstairs udevd-event[4609]: udev_event_run: seq 1446 finished with -1 
Jun 11 17:38:08 upstairs udevd-event[4597]: node_symlink: creating symlink '/dev/disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1' to '../../sdd1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_node_update_symlinks: update symlink 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1' of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd/sdd1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_db_get_devices_by_name: found index directory '/dev/.udev/names/disk\x2fby-path\x2fpci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: found 1 devices with name 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: found '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd/sdd1' for 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: compare (our own) priority of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd/sdd1' 0 >= 0 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1' with target 'sdd1' has the highest priority 0, create it 
Jun 11 17:38:08 upstairs udevd-event[4597]: node_symlink: creating symlink '/dev/disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1' to '../../sdd1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_node_update_symlinks: update symlink 'disk/by-uuid/B4EE-B432' of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd/sdd1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_db_get_devices_by_name: found index directory '/dev/.udev/names/disk\x2fby-uuid\x2fB4EE-B432' 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: found 1 devices with name 'disk/by-uuid/B4EE-B432' 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: found '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd/sdd1' for 'disk/by-uuid/B4EE-B432' 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: compare (our own) priority of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host5/target5:0:0/5:0:0:0/block/sdd/sdd1' 0 >= 0 
Jun 11 17:38:08 upstairs udevd-event[4597]: update_link: 'disk/by-uuid/B4EE-B432' with target 'sdd1' has the highest priority 0, create it 
Jun 11 17:38:08 upstairs udevd-event[4597]: node_symlink: creating symlink '/dev/disk/by-uuid/B4EE-B432' to '../../sdd1' 
Jun 11 17:38:08 upstairs udevd-event[4597]: run_program: '/usr/bin/udevshowicon.sh' 
Jun 11 17:38:08 upstairs udevd-event[4597]: run_program: '/usr/bin/udevshowicon.sh' returned with status 0 
Jun 11 17:38:08 upstairs udevd-event[4597]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:38:08 upstairs udevd-event[4597]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:38:08 upstairs udevd-event[4597]: udev_event_run: seq 1445 finished with 0 

--Boundary-00=_9ACUIUqnjbSMlTr
Content-Type: text/x-log;
  charset="utf-8";
  name="udevdebug-pluginusb-2.6.26-rc5-git5.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="udevdebug-pluginusb-2.6.26-rc5-git5.log"

Jun 11 17:48:13 upstairs udevd[74]: msg_queue_insert: seq 1403 queued, 'add' 'usb' 
Jun 11 17:48:13 upstairs udevd[74]: udev_event_run: seq 1403 forked, pid [1444], 'add' 'usb', 0 seconds old 
Jun 11 17:48:13 upstairs udevd[74]: msg_queue_insert: seq 1404 queued, 'add' 'usb' 
Jun 11 17:48:13 upstairs udevd[74]: msg_queue_insert: seq 1405 queued, 'add' 'usb_endpoint' 
Jun 11 17:48:13 upstairs udevd[74]: msg_queue_insert: seq 1406 queued, 'add' 'usb_endpoint' 
Jun 11 17:48:13 upstairs udevd[74]: msg_queue_insert: seq 1407 queued, 'add' 'usb_endpoint' 
Jun 11 17:48:13 upstairs udevd[74]: udev_done: seq 1403, pid [1444] exit with 0, 0 seconds old 
Jun 11 17:48:13 upstairs udevd[74]: udev_event_run: seq 1404 forked, pid [1445], 'add' 'usb', 0 seconds old 
Jun 11 17:48:13 upstairs udevd[74]: udev_event_run: seq 1407 forked, pid [1447], 'add' 'usb_endpoint', 0 seconds old 
Jun 11 17:48:13 upstairs udevd[74]: udev_done: seq 1407, pid [1447] exit with 0, 0 seconds old 
Jun 11 17:48:13 upstairs udevd[74]: msg_queue_insert: seq 1408 queued, 'add' 'module' 
Jun 11 17:48:13 upstairs udevd[74]: udev_event_run: seq 1408 forked, pid [1450], 'add' 'module', 0 seconds old 
Jun 11 17:48:13 upstairs udevd[74]: udev_done: seq 1408, pid [1450] exit with 0, 0 seconds old 
Jun 11 17:48:13 upstairs udevd[74]: msg_queue_insert: seq 1409 queued, 'add' 'scsi' 
Jun 11 17:48:13 upstairs udevd[74]: msg_queue_insert: seq 1410 queued, 'add' 'scsi_host' 
Jun 11 17:48:13 upstairs udevd[74]: msg_queue_insert: seq 1411 queued, 'add' 'drivers' 
Jun 11 17:48:13 upstairs udevd[74]: udev_event_run: seq 1411 forked, pid [1454], 'add' 'drivers', 0 seconds old 
Jun 11 17:48:13 upstairs udevd[74]: udev_done: seq 1411, pid [1454] exit with 0, 0 seconds old 
Jun 11 17:48:13 upstairs udevd[74]: udev_done: seq 1404, pid [1445] exit with 0, 0 seconds old 
Jun 11 17:48:13 upstairs udevd[74]: udev_event_run: seq 1405 forked, pid [1455], 'add' 'usb_endpoint', 0 seconds old 
Jun 11 17:48:13 upstairs udevd[74]: udev_event_run: seq 1406 forked, pid [1456], 'add' 'usb_endpoint', 0 seconds old 
Jun 11 17:48:13 upstairs udevd-event[1444]: udev_rules_get_name: no node name set, will use kernel name '11-2' 
Jun 11 17:48:13 upstairs udevd-event[1444]: udev_db_get_device: no db file to read /dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2: No such file or directory 
Jun 11 17:48:13 upstairs udevd-event[1444]: udev_node_add: creating device node '/dev/11-2', major=189, minor=1282, mode=0660, uid=0, gid=0 
Jun 11 17:48:13 upstairs udevd-event[1444]: name_index: creating index: '/dev/.udev/names/11-2/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2' 
Jun 11 17:48:13 upstairs udevd-event[1444]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:13 upstairs udevd-event[1444]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:13 upstairs udevd-event[1444]: udev_event_run: seq 1403 finished with 0 
Jun 11 17:48:13 upstairs udevd[74]: udev_event_run: seq 1409 forked, pid [1457], 'add' 'scsi', 0 seconds old 
Jun 11 17:48:13 upstairs udevd[74]: udev_done: seq 1405, pid [1455] exit with 0, 0 seconds old 
Jun 11 17:48:13 upstairs udevd[74]: udev_done: seq 1406, pid [1456] exit with 0, 0 seconds old 
Jun 11 17:48:13 upstairs udevd-event[1445]: run_program: '/sbin/modprobe usb:v0930p6545d0100dc00dsc00dp00ic08isc06ip50' 
Jun 11 17:48:13 upstairs udevd-event[1445]: run_program: '/sbin/modprobe' returned with status 0 
Jun 11 17:48:13 upstairs udevd-event[1445]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:13 upstairs udevd-event[1445]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:13 upstairs udevd-event[1445]: udev_event_run: seq 1404 finished with 0 
Jun 11 17:48:13 upstairs udevd-event[1447]: udev_rules_get_name: no node name set, will use kernel name 'usbdev11.3_ep00' 
Jun 11 17:48:13 upstairs udevd-event[1447]: udev_db_get_device: no db file to read /dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2fusb_endpoint\x2fusbdev11.3_ep00: No such file or directory 
Jun 11 17:48:13 upstairs udevd-event[1447]: udev_node_add: creating device node '/dev/usbdev11.3_ep00', major=254, minor=25, mode=0660, uid=0, gid=0 
Jun 11 17:48:13 upstairs udevd-event[1447]: name_index: creating index: '/dev/.udev/names/usbdev11.3_ep00/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2fusb_endpoint\x2fusbdev11.3_ep00' 
Jun 11 17:48:13 upstairs udevd-event[1447]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:13 upstairs udevd-event[1447]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:13 upstairs udevd-event[1447]: udev_event_run: seq 1407 finished with 0 
Jun 11 17:48:13 upstairs udevd-event[1450]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:13 upstairs udevd-event[1450]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:13 upstairs udevd-event[1450]: udev_event_run: seq 1408 finished with 0 
Jun 11 17:48:13 upstairs udevd-event[1454]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:13 upstairs udevd-event[1454]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:13 upstairs udevd-event[1454]: udev_event_run: seq 1411 finished with 0 
Jun 11 17:48:13 upstairs udevd-event[1455]: udev_rules_get_name: no node name set, will use kernel name 'usbdev11.3_ep81' 
Jun 11 17:48:13 upstairs udevd-event[1455]: udev_db_get_device: no db file to read /dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fusb_endpoint\x2fusbdev11.3_ep81: No such file or directory 
Jun 11 17:48:13 upstairs udevd-event[1455]: udev_node_add: creating device node '/dev/usbdev11.3_ep81', major=254, minor=23, mode=0660, uid=0, gid=0 
Jun 11 17:48:13 upstairs udevd-event[1455]: name_index: creating index: '/dev/.udev/names/usbdev11.3_ep81/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fusb_endpoint\x2fusbdev11.3_ep81' 
Jun 11 17:48:13 upstairs udevd-event[1455]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:13 upstairs udevd-event[1455]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:13 upstairs udevd-event[1456]: udev_rules_get_name: no node name set, will use kernel name 'usbdev11.3_ep02' 
Jun 11 17:48:13 upstairs udevd-event[1456]: udev_db_get_device: no db file to read /dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fusb_endpoint\x2fusbdev11.3_ep02: No such file or directory 
Jun 11 17:48:13 upstairs udevd-event[1456]: udev_node_add: creating device node '/dev/usbdev11.3_ep02', major=254, minor=24, mode=0660, uid=0, gid=0 
Jun 11 17:48:13 upstairs udevd-event[1456]: name_index: creating index: '/dev/.udev/names/usbdev11.3_ep02/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fusb_endpoint\x2fusbdev11.3_ep02' 
Jun 11 17:48:13 upstairs udevd-event[1456]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:13 upstairs udevd-event[1456]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:13 upstairs udevd-event[1455]: udev_event_run: seq 1405 finished with 0 
Jun 11 17:48:13 upstairs udevd-event[1456]: udev_event_run: seq 1406 finished with 0 
Jun 11 17:48:13 upstairs udevd-event[1457]: wait_for_sysfs: wait for '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/ioerr_cnt' for 20 mseconds 
Jun 11 17:48:18 upstairs last message repeated 236 times
Jun 11 17:48:18 upstairs udevd[74]: msg_queue_insert: seq 1412 queued, 'add' 'scsi' 
Jun 11 17:48:18 upstairs udevd[74]: msg_queue_insert: seq 1413 queued, 'add' 'scsi' 
Jun 11 17:48:18 upstairs udevd[74]: msg_queue_insert: seq 1414 queued, 'add' 'scsi_disk' 
Jun 11 17:48:18 upstairs udevd-event[1457]: wait_for_sysfs: wait for '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/ioerr_cnt' for 20 mseconds 
Jun 11 17:48:18 upstairs last message repeated 10 times
Jun 11 17:48:18 upstairs udevd[74]: msg_queue_insert: seq 1415 queued, 'change' 'scsi' 
Jun 11 17:48:18 upstairs udevd[74]: msg_queue_insert: seq 1416 queued, 'add' 'block' 
Jun 11 17:48:18 upstairs udevd[74]: msg_queue_insert: seq 1417 queued, 'add' 'block' 
Jun 11 17:48:18 upstairs udevd[74]: msg_queue_insert: seq 1418 queued, 'add' 'bdi' 
Jun 11 17:48:18 upstairs udevd[74]: udev_event_run: seq 1418 forked, pid [1458], 'add' 'bdi', 0 seconds old 
Jun 11 17:48:18 upstairs udevd[74]: msg_queue_insert: seq 1419 queued, 'add' 'scsi_device' 
Jun 11 17:48:18 upstairs udevd[74]: udev_done: seq 1418, pid [1458] exit with 0, 0 seconds old 
Jun 11 17:48:18 upstairs udevd-event[1458]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:18 upstairs udevd-event[1458]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:18 upstairs udevd-event[1458]: udev_event_run: seq 1418 finished with 0 
Jun 11 17:48:18 upstairs udevd-event[1457]: wait_for_sysfs: wait for '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/ioerr_cnt' for 20 mseconds 
Jun 11 17:48:24 upstairs last message repeated 250 times
Jun 11 17:48:24 upstairs udevd-event[1457]: wait_for_sysfs: waiting for '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/ioerr_cnt' failed 
Jun 11 17:48:24 upstairs udevd[74]: udev_done: seq 1409, pid [1457] exit with 0, 11 seconds old 
Jun 11 17:48:24 upstairs udevd[74]: udev_event_run: seq 1410 forked, pid [1459], 'add' 'scsi_host', 11 seconds old 
Jun 11 17:48:24 upstairs udevd-event[1457]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:24 upstairs udevd-event[1457]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:24 upstairs udevd-event[1457]: udev_event_run: seq 1409 finished with 0 
Jun 11 17:48:24 upstairs udevd[74]: udev_event_run: seq 1412 forked, pid [1460], 'add' 'scsi', 6 seconds old 
Jun 11 17:48:24 upstairs udevd[74]: udev_done: seq 1410, pid [1459] exit with 0, 11 seconds old 
Jun 11 17:48:24 upstairs udevd-event[1459]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:24 upstairs udevd-event[1459]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:24 upstairs udevd-event[1459]: udev_event_run: seq 1410 finished with 0 
Jun 11 17:48:24 upstairs udevd-event[1460]: wait_for_sysfs: wait for '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/ioerr_cnt' for 20 mseconds 
Jun 11 17:48:34 upstairs last message repeated 498 times
Jun 11 17:48:34 upstairs udevd-event[1460]: wait_for_sysfs: waiting for '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/ioerr_cnt' failed 
Jun 11 17:48:34 upstairs udevd[74]: udev_done: seq 1412, pid [1460] exit with 0, 16 seconds old 
Jun 11 17:48:34 upstairs udevd[74]: udev_event_run: seq 1413 forked, pid [1461], 'add' 'scsi', 16 seconds old 
Jun 11 17:48:34 upstairs udevd-event[1460]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:34 upstairs udevd-event[1460]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:34 upstairs udevd-event[1460]: udev_event_run: seq 1412 finished with 0 
Jun 11 17:48:34 upstairs udevd-event[1461]: wait_for_sysfs: file '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/ioerr_cnt' appeared after 0 loops 
Jun 11 17:48:34 upstairs udevd-event[1461]: run_program: '/sbin/modprobe scsi:t-0x00' 
Jun 11 17:48:34 upstairs udevd-event[1461]: run_program: '/sbin/modprobe' (stderr) 'FATAL: Module scsi:t_0x00 not found.' 
Jun 11 17:48:34 upstairs udevd[74]: udev_done: seq 1413, pid [1461] exit with 0, 16 seconds old 
Jun 11 17:48:34 upstairs udevd[74]: udev_event_run: seq 1414 forked, pid [1463], 'add' 'scsi_disk', 16 seconds old 
Jun 11 17:48:34 upstairs udevd-event[1461]: run_program: '/sbin/modprobe' returned with status 1 
Jun 11 17:48:34 upstairs udevd-event[1461]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:34 upstairs udevd-event[1461]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:34 upstairs udevd-event[1461]: udev_event_run: seq 1413 finished with 0 
Jun 11 17:48:34 upstairs udevd[74]: udev_done: seq 1414, pid [1463] exit with 0, 16 seconds old 
Jun 11 17:48:34 upstairs udevd[74]: udev_event_run: seq 1415 forked, pid [1464], 'change' 'scsi', 16 seconds old 
Jun 11 17:48:34 upstairs udevd[74]: udev_done: seq 1415, pid [1464] exit with 0, 16 seconds old 
Jun 11 17:48:34 upstairs udevd[74]: udev_event_run: seq 1416 forked, pid [1465], 'add' 'block', 16 seconds old 
Jun 11 17:48:34 upstairs udevd[74]: udev_event_run: seq 1419 forked, pid [1467], 'add' 'scsi_device', 16 seconds old 
Jun 11 17:48:34 upstairs udevd-event[1463]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:34 upstairs udevd-event[1463]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:34 upstairs udevd-event[1463]: udev_event_run: seq 1414 finished with 0 
Jun 11 17:48:34 upstairs udevd[74]: udev_done: seq 1419, pid [1467] exit with 1, 16 seconds old 
Jun 11 17:48:34 upstairs udevd-event[1464]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:34 upstairs udevd-event[1464]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:34 upstairs udevd-event[1464]: udev_event_run: seq 1415 finished with 0 
Jun 11 17:48:34 upstairs udevd[74]: udev_done: seq 1416, pid [1465] exit with 0, 16 seconds old 
Jun 11 17:48:34 upstairs udevd-event[1465]: udev_rules_get_name: rule applied, 'sdd' becomes 'sdd' 
Jun 11 17:48:34 upstairs udevd-event[1465]: run_program: '/lib/udev/usb_id -x' 
Jun 11 17:48:34 upstairs udevd-event[1465]: run_program: '/lib/udev/usb_id' (stdout) 'ID_VENDOR=0930' 
Jun 11 17:48:34 upstairs udevd-event[1465]: run_program: '/lib/udev/usb_id' (stdout) 'ID_MODEL=USB_Flash_Memory' 
Jun 11 17:48:34 upstairs udevd-event[1465]: run_program: '/lib/udev/usb_id' (stdout) 'ID_REVISION=5.00' 
Jun 11 17:48:34 upstairs udevd-event[1465]: run_program: '/lib/udev/usb_id' (stdout) 'ID_SERIAL=0930_USB_Flash_Memory_0EC065712361A91E-0:0' 
Jun 11 17:48:34 upstairs udevd-event[1465]: run_program: '/lib/udev/usb_id' (stdout) 'ID_SERIAL_SHORT=0EC065712361A91E' 
Jun 11 17:48:34 upstairs udevd-event[1465]: run_program: '/lib/udev/usb_id' (stdout) 'ID_TYPE=disk' 
Jun 11 17:48:34 upstairs udevd-event[1465]: run_program: '/lib/udev/usb_id' (stdout) 'ID_INSTANCE=0:0' 
Jun 11 17:48:34 upstairs udevd-event[1465]: run_program: '/lib/udev/usb_id' (stdout) 'ID_BUS=usb' 
Jun 11 17:48:34 upstairs udevd[74]: udev_event_run: seq 1417 forked, pid [1476], 'add' 'block', 16 seconds old 
Jun 11 17:48:34 upstairs udevd-event[1467]: run_program: '/sbin/modprobe sd_mod' 
Jun 11 17:48:34 upstairs udevd-event[1467]: run_program: '/sbin/modprobe' (stderr) 'FATAL: Module sd_mod not found.' 
Jun 11 17:48:34 upstairs udevd-event[1467]: run_program: '/sbin/modprobe' returned with status 1 
Jun 11 17:48:34 upstairs udevd-event[1467]: run_program: '/sbin/modprobe sg' 
Jun 11 17:48:34 upstairs udevd-event[1467]: run_program: '/sbin/modprobe' (stderr) 'FATAL: Module sg not found.' 
Jun 11 17:48:34 upstairs udevd-event[1467]: run_program: '/sbin/modprobe' returned with status 1 
Jun 11 17:48:34 upstairs udevd-event[1467]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:34 upstairs udevd-event[1467]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:34 upstairs udevd-event[1467]: udev_event_run: seq 1419 finished with -1 
Jun 11 17:48:34 upstairs udevd-event[1465]: run_program: '/lib/udev/usb_id' returned with status 0 
Jun 11 17:48:34 upstairs udevd-event[1465]: udev_rules_get_name: add symlink 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0' 
Jun 11 17:48:34 upstairs udevd-event[1465]: run_program: '/lib/udev/path_id /devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd' 
Jun 11 17:48:34 upstairs udevd-event[1465]: run_program: '/lib/udev/path_id' (stdout) 'ID_PATH=pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' 
Jun 11 17:48:34 upstairs udevd-event[1465]: run_program: '/lib/udev/path_id' returned with status 0 
Jun 11 17:48:34 upstairs udevd-event[1465]: udev_rules_get_name: add symlink 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' 
Jun 11 17:48:34 upstairs udevd-event[1465]: udev_db_get_device: no db file to read /dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost4\x2ftarget4:0:0\x2f4:0:0:0\x2fblock\x2fsdd: No such file or directory 
Jun 11 17:48:34 upstairs udevd-event[1465]: udev_node_add: creating device node '/dev/sdd', major=8, minor=48, mode=0660, uid=0, gid=6 
Jun 11 17:48:34 upstairs udevd-event[1465]: name_index: creating index: '/dev/.udev/names/disk\x2fby-id\x2fusb-0930_USB_Flash_Memory_0EC065712361A91E-0:0/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost4\x2ftarget4:0:0\x2f4:0:0:0\x2fblock\x2fsdd' 
Jun 11 17:48:34 upstairs udevd-event[1465]: name_index: creating index: '/dev/.udev/names/disk\x2fby-path\x2fpci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost4\x2ftarget4:0:0\x2f4:0:0:0\x2fblock\x2fsdd' 
Jun 11 17:48:34 upstairs udevd-event[1465]: name_index: creating index: '/dev/.udev/names/sdd/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost4\x2ftarget4:0:0\x2f4:0:0:0\x2fblock\x2fsdd' 
Jun 11 17:48:34 upstairs usb_id[1466]: usb_id: /devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0: if_class 8 protocol 6 
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_rules_get_name: add symlink 'usbstickc1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_rules_get_name: rule applied, 'sdd1' becomes 'sdd1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_rules_get_name: add symlink 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_rules_get_name: add symlink 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: run_program: '/lib/udev/vol_id --export /dev/.tmp-8-49' 
Jun 11 17:48:34 upstairs udevd-event[1465]: udev_node_update_symlinks: update symlink 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0' of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd' 
Jun 11 17:48:34 upstairs udevd-event[1465]: udev_db_get_devices_by_name: found index directory '/dev/.udev/names/disk\x2fby-id\x2fusb-0930_USB_Flash_Memory_0EC065712361A91E-0:0' 
Jun 11 17:48:34 upstairs udevd-event[1465]: update_link: found 1 devices with name 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0' 
Jun 11 17:48:34 upstairs udevd-event[1465]: update_link: found '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd' for 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0' 
Jun 11 17:48:34 upstairs udevd-event[1465]: update_link: compare (our own) priority of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd' 0 >= 0 
Jun 11 17:48:34 upstairs udevd-event[1465]: update_link: 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0' with target 'sdd' has the highest priority 0, create it 
Jun 11 17:48:34 upstairs udevd-event[1465]: node_symlink: creating symlink '/dev/disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0' to '../../sdd' 
Jun 11 17:48:34 upstairs udevd-event[1465]: udev_node_update_symlinks: update symlink 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd' 
Jun 11 17:48:34 upstairs udevd-event[1465]: udev_db_get_devices_by_name: found index directory '/dev/.udev/names/disk\x2fby-path\x2fpci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' 
Jun 11 17:48:34 upstairs udevd-event[1465]: update_link: found 1 devices with name 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' 
Jun 11 17:48:34 upstairs udevd-event[1465]: update_link: found '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd' for 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x0(0), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:369 read sbbuf len:0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x0(0), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: volume_id.c:362 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:48:34 upstairs vol_id[1477]: linux_raid.c:71 probing at offset 0x3d6e0000, size 0x3d6fc000 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6e0000(1030619136), len 0x800 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:405 read seekbuf off:0x3d6e0000 len:0x800 
Jun 11 17:48:34 upstairs udevd-event[1465]: update_link: compare (our own) priority of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd' 0 >= 0 
Jun 11 17:48:34 upstairs udevd-event[1465]: update_link: 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' with target 'sdd' has the highest priority 0, create it 
Jun 11 17:48:34 upstairs udevd-event[1465]: node_symlink: creating symlink '/dev/disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0' to '../../sdd' 
Jun 11 17:48:34 upstairs udevd-event[1465]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:34 upstairs udevd-event[1465]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:34 upstairs udevd-event[1465]: udev_event_run: seq 1416 finished with 0 
Jun 11 17:48:34 upstairs vol_id[1477]: linux_raid.c:126 probing at offset 0x3d6fa000, size 0x3d6fc000 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6fa000(1030725632), len 0x800 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:405 read seekbuf off:0x3d6fa000 len:0x800 
Jun 11 17:48:34 upstairs vol_id[1477]: linux_raid.c:126 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x0(0), len 0x800 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:369 read sbbuf len:0x800 
Jun 11 17:48:34 upstairs vol_id[1477]: linux_raid.c:126 probing at offset 0x1000, size 0x3d6fc000 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x1000(4096), len 0x800 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:369 read sbbuf len:0x1800 
Jun 11 17:48:34 upstairs vol_id[1477]: ddf_raid.c:49 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6fbe00(1030733312), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:405 read seekbuf off:0x3d6fbe00 len:0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: isw_raid.c:47 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6fbc00(1030732800), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:405 read seekbuf off:0x3d6fbc00 len:0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: lsi_raid.c:42 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6fbe00(1030733312), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:405 read seekbuf off:0x3d6fbe00 len:0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6fbe00(1030733312), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: silicon_raid.c:57 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6fbe00(1030733312), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: nvidia_raid.c:45 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6fbc00(1030732800), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:405 read seekbuf off:0x3d6fbc00 len:0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: promise_raid.c:46 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6f4200(1030701568), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:405 read seekbuf off:0x3d6f4200 len:0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6dc200(1030603264), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:405 read seekbuf off:0x3d6dc200 len:0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6dc000(1030602752), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:405 read seekbuf off:0x3d6dc000 len:0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6fa000(1030725632), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:405 read seekbuf off:0x3d6fa000 len:0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6ca200(1030529536), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:405 read seekbuf off:0x3d6ca200 len:0x200 
Jun 11 17:48:34 upstairs udevd-event[1476]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_USAGE=filesystem' 
Jun 11 17:48:34 upstairs udevd-event[1476]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_TYPE=vfat' 
Jun 11 17:48:34 upstairs udevd-event[1476]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_VERSION=FAT16' 
Jun 11 17:48:34 upstairs udevd-event[1476]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_UUID=B4EE-B432' 
Jun 11 17:48:34 upstairs udevd-event[1476]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_UUID_ENC=B4EE-B432' 
Jun 11 17:48:34 upstairs udevd-event[1476]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_LABEL=' 
Jun 11 17:48:34 upstairs udevd-event[1476]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_LABEL_ENC=' 
Jun 11 17:48:34 upstairs udevd-event[1476]: run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_LABEL_SAFE=' 
Jun 11 17:48:34 upstairs udevd-event[1476]: run_program: '/lib/udev/vol_id' returned with status 0 
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_rules_get_name: add symlink 'disk/by-uuid/B4EE-B432' 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6faa00(1030728192), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:405 read seekbuf off:0x3d6faa00 len:0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: adaptec_raid.c:90 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6fbe00(1030733312), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:405 read seekbuf off:0x3d6fbe00 len:0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: jmicron_raid.c:43 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3d6fbe00(1030733312), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: lvm.c:54 probing at offset 0x0 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x400(1024), len 0x800 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x0(0), len 0x800 
Jun 11 17:48:34 upstairs vol_id[1477]: highpoint.c:52 probing at offset 0x0 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x1200(4608), len 0x200 
Jun 11 17:48:35 upstairs udevd[74]: udev_done: seq 1417, pid [1476] exit with 0, 17 seconds old 
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_db_get_device: no db file to read /dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost4\x2ftarget4:0:0\x2f4:0:0:0\x2fblock\x2fsdd\x2fsdd1: No such file or directory 
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_node_add: creating device node '/dev/sdd1', major=8, minor=49, mode=0666, uid=0, gid=6 
Jun 11 17:48:34 upstairs udevd-event[1476]: name_index: creating index: '/dev/.udev/names/usbstickc1/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost4\x2ftarget4:0:0\x2f4:0:0:0\x2fblock\x2fsdd\x2fsdd1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: name_index: creating index: '/dev/.udev/names/disk\x2fby-id\x2fusb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost4\x2ftarget4:0:0\x2f4:0:0:0\x2fblock\x2fsdd\x2fsdd1' 
Jun 11 17:48:34 upstairs logger: udevshowicon: starting to get icon name
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x0(0), len 0x200 
Jun 11 17:48:34 upstairs vol_id[1477]: volume_id.c:396 probing at offset 0x0, size 0x3d6fc000 
Jun 11 17:48:34 upstairs vol_id[1477]: fat.c:273 probing at offset 0x0 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x0(0), len 0x400 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x3da00(252416), len 0x4000 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:405 read seekbuf off:0x3da00 len:0x4000 
Jun 11 17:48:34 upstairs vol_id[1477]: util.c:356 get buffer off 0x0(0), len 0x200 
Jun 11 17:48:34 upstairs udevd-event[1476]: name_index: creating index: '/dev/.udev/names/disk\x2fby-path\x2fpci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost4\x2ftarget4:0:0\x2f4:0:0:0\x2fblock\x2fsdd\x2fsdd1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: name_index: creating index: '/dev/.udev/names/disk\x2fby-uuid\x2fB4EE-B432/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost4\x2ftarget4:0:0\x2f4:0:0:0\x2fblock\x2fsdd\x2fsdd1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: name_index: creating index: '/dev/.udev/names/sdd1/\x2fdevices\x2fpci0000:00\x2f0000:00:1e.0\x2f0000:02:0a.2\x2fusb11\x2f11-2\x2f11-2:1.0\x2fhost4\x2ftarget4:0:0\x2f4:0:0:0\x2fblock\x2fsdd\x2fsdd1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_node_update_symlinks: update symlink 'usbstickc1' of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd/sdd1' 
Jun 11 17:48:34 upstairs logger: udevshowicon: about to show usbstickc1
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_db_get_devices_by_name: found index directory '/dev/.udev/names/usbstickc1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: found 1 devices with name 'usbstickc1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: found '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd/sdd1' for 'usbstickc1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: compare (our own) priority of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd/sdd1' 0 >= 0 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: 'usbstickc1' with target 'sdd1' has the highest priority 0, create it 
Jun 11 17:48:34 upstairs udevd-event[1476]: node_symlink: creating symlink '/dev/usbstickc1' to 'sdd1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_node_update_symlinks: update symlink 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1' of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd/sdd1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_db_get_devices_by_name: found index directory '/dev/.udev/names/disk\x2fby-id\x2fusb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: found 1 devices with name 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: found '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd/sdd1' for 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: compare (our own) priority of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd/sdd1' 0 >= 0 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: 'disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1' with target 'sdd1' has the highest priority 0, create it 
Jun 11 17:48:34 upstairs udevd-event[1476]: node_symlink: creating symlink '/dev/disk/by-id/usb-0930_USB_Flash_Memory_0EC065712361A91E-0:0-part1' to '../../sdd1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_node_update_symlinks: update symlink 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1' of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd/sdd1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_db_get_devices_by_name: found index directory '/dev/.udev/names/disk\x2fby-path\x2fpci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: found 1 devices with name 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: found '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd/sdd1' for 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: compare (our own) priority of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd/sdd1' 0 >= 0 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: 'disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1' with target 'sdd1' has the highest priority 0, create it 
Jun 11 17:48:34 upstairs udevd-event[1476]: node_symlink: creating symlink '/dev/disk/by-path/pci-0000:02:0a.2-usb-0:2:1.0-scsi-0:0:0:0-part1' to '../../sdd1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_node_update_symlinks: update symlink 'disk/by-uuid/B4EE-B432' of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd/sdd1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: udev_db_get_devices_by_name: found index directory '/dev/.udev/names/disk\x2fby-uuid\x2fB4EE-B432' 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: found 1 devices with name 'disk/by-uuid/B4EE-B432' 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: found '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd/sdd1' for 'disk/by-uuid/B4EE-B432' 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: compare (our own) priority of '/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/target4:0:0/4:0:0:0/block/sdd/sdd1' 0 >= 0 
Jun 11 17:48:34 upstairs udevd-event[1476]: update_link: 'disk/by-uuid/B4EE-B432' with target 'sdd1' has the highest priority 0, create it 
Jun 11 17:48:34 upstairs udevd-event[1476]: node_symlink: creating symlink '/dev/disk/by-uuid/B4EE-B432' to '../../sdd1' 
Jun 11 17:48:34 upstairs udevd-event[1476]: run_program: '/usr/bin/udevshowicon.sh' 
Jun 11 17:48:35 upstairs udevd-event[1476]: run_program: '/usr/bin/udevshowicon.sh' returned with status 0 
Jun 11 17:48:35 upstairs udevd-event[1476]: pass_env_to_socket: passed -1 bytes to socket '/org/kernel/udev/monitor',  
Jun 11 17:48:35 upstairs udevd-event[1476]: pass_env_to_socket: passed -1 bytes to socket '/org/freedesktop/hal/udev_event',  
Jun 11 17:48:35 upstairs udevd-event[1476]: udev_event_run: seq 1417 finished with 0 

--Boundary-00=_9ACUIUqnjbSMlTr
Content-Type: text/x-log;
  charset="utf-8";
  name="udevdebug-pluginusb-2.6.26-rc5-git5-kernel.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="udevdebug-pluginusb-2.6.26-rc5-git5-kernel.log"

Jun 11 17:48:13 upstairs kernel: [  281.946544] hub 11-0:1.0: state 7 ports 5 chg 0000 evt 0004 
Jun 11 17:48:13 upstairs kernel: [  281.946569] ehci_hcd 0000:02:0a.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT 
Jun 11 17:48:13 upstairs kernel: [  281.946586] hub 11-0:1.0: port 2, status 0501, change 0001, 480 Mb/s 
Jun 11 17:48:13 upstairs kernel: [  282.050547] hub 11-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501 
Jun 11 17:48:13 upstairs kernel: [  282.101706] ehci_hcd 0000:02:0a.2: port 2 high speed 
Jun 11 17:48:13 upstairs kernel: [  282.101718] ehci_hcd 0000:02:0a.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT 
Jun 11 17:48:13 upstairs kernel: [  282.152549] usb 11-2: new high speed USB device using ehci_hcd and address 3 
Jun 11 17:48:13 upstairs kernel: [  282.167530] usb 11-2: default language 0x0409 
Jun 11 17:48:13 upstairs kernel: [  282.167530] device: '11-2': device_add 
Jun 11 17:48:13 upstairs kernel: [  282.167531] bus: 'usb': add device 11-2 
Jun 11 17:48:13 upstairs kernel: [  282.167531] PM: Adding info for usb:11-2 
Jun 11 17:48:13 upstairs kernel: [  282.167531] usb 11-2: uevent 
Jun 11 17:48:13 upstairs kernel: [  282.167531] bus: 'usb': driver_probe_device: matched device 11-2 with driver usb 
Jun 11 17:48:13 upstairs kernel: [  282.167531] bus: 'usb': really_probe: probing driver usb with device 11-2 
Jun 11 17:48:13 upstairs kernel: [  282.167531] usb 11-2: usb_probe_device 
Jun 11 17:48:13 upstairs kernel: [  282.167531] usb 11-2: configuration #1 chosen from 1 choice 
Jun 11 17:48:13 upstairs kernel: [  282.170915] usb 11-2: adding 11-2:1.0 (config #1, interface 0) 
Jun 11 17:48:13 upstairs kernel: [  282.170923] device: '11-2:1.0': device_add 
Jun 11 17:48:13 upstairs kernel: [  282.170947] bus: 'usb': add device 11-2:1.0 
Jun 11 17:48:13 upstairs kernel: [  282.170954] PM: Adding info for usb:11-2:1.0 
Jun 11 17:48:13 upstairs kernel: [  282.170971] usb 11-2:1.0: uevent 
Jun 11 17:48:13 upstairs kernel: [  282.171009] device: 'usbdev11.3_ep81': device_add 
Jun 11 17:48:13 upstairs kernel: [  282.171070] PM: Adding info for No Bus:usbdev11.3_ep81 
Jun 11 17:48:13 upstairs kernel: [  282.171101] device: 'usbdev11.3_ep02': device_add 
Jun 11 17:48:13 upstairs kernel: [  282.171137] PM: Adding info for No Bus:usbdev11.3_ep02 
Jun 11 17:48:13 upstairs kernel: [  282.171164] drivers/usb/core/inode.c: creating file '003' 
Jun 11 17:48:13 upstairs kernel: [  282.171182] driver: '11-2': driver_bound: bound to device 'usb' 
Jun 11 17:48:13 upstairs kernel: [  282.171188] bus: 'usb': really_probe: bound device 11-2 to driver usb 
Jun 11 17:48:13 upstairs kernel: [  282.171205] device: 'usbdev11.3_ep00': device_add 
Jun 11 17:48:13 upstairs kernel: [  282.171241] PM: Adding info for No Bus:usbdev11.3_ep00 
Jun 11 17:48:13 upstairs kernel: [  282.171267] usb 11-2: New USB device found, idVendor=0930, idProduct=6545 
Jun 11 17:48:13 upstairs kernel: [  282.171273] usb 11-2: New USB device strings: Mfr=0, Product=2, SerialNumber=3 
Jun 11 17:48:13 upstairs kernel: [  282.171279] usb 11-2: Product: USB Flash Memory 
Jun 11 17:48:13 upstairs kernel: [  282.171284] usb 11-2: SerialNumber: 0EC065712361A91E 
Jun 11 17:48:13 upstairs kernel: [  282.221262] Initializing USB Mass Storage driver... 
Jun 11 17:48:13 upstairs kernel: [  282.223207] bus: 'usb': add driver usb-storage 
Jun 11 17:48:13 upstairs kernel: [  282.223454] bus: 'usb': driver_probe_device: matched device 11-2:1.0 with driver usb-storage 
Jun 11 17:48:13 upstairs kernel: [  282.223504] bus: 'usb': really_probe: probing driver usb-storage with device 11-2:1.0 
Jun 11 17:48:13 upstairs kernel: [  282.223706] usb-storage 11-2:1.0: usb_probe_interface 
Jun 11 17:48:13 upstairs kernel: [  282.223754] usb-storage 11-2:1.0: usb_probe_interface - got id 
Jun 11 17:48:13 upstairs kernel: [  282.224232] scsi4 : SCSI emulation for USB Mass Storage devices 
Jun 11 17:48:13 upstairs kernel: [  282.224295] device: 'host4': device_add 
Jun 11 17:48:13 upstairs kernel: [  282.224464] bus: 'scsi': add device host4 
Jun 11 17:48:13 upstairs kernel: [  282.224519] PM: Adding info for scsi:host4 
Jun 11 17:48:13 upstairs kernel: [  282.224582] device: 'host4': device_add 
Jun 11 17:48:13 upstairs kernel: [  282.224931] PM: Adding info for No Bus:host4 
Jun 11 17:48:13 upstairs kernel: [  282.225631] driver: '11-2:1.0': driver_bound: bound to device 'usb-storage' 
Jun 11 17:48:13 upstairs kernel: [  282.226995] usb-storage: device found at 3 
Jun 11 17:48:13 upstairs kernel: [  282.226995] usb-storage: waiting for device to settle before scanning 
Jun 11 17:48:13 upstairs kernel: [  282.226995] bus: 'usb': really_probe: bound device 11-2:1.0 to driver usb-storage 
Jun 11 17:48:13 upstairs kernel: [  282.227187] usbcore: registered new interface driver usb-storage 
Jun 11 17:48:13 upstairs kernel: [  282.228224] USB Mass Storage support registered. 
Jun 11 17:48:18 upstairs kernel: [  287.227889] scsi 4:0:0:0: Direct-Access              USB Flash Memory 5.00 PQ: 0 ANSI: 0 CCS 
Jun 11 17:48:18 upstairs kernel: [  287.227889] device: 'target4:0:0': device_add 
Jun 11 17:48:18 upstairs kernel: [  287.227889] bus: 'scsi': add device target4:0:0 
Jun 11 17:48:18 upstairs kernel: [  287.229797] PM: Adding info for scsi:target4:0:0 
Jun 11 17:48:18 upstairs kernel: [  287.229797] device: '4:0:0:0': device_add 
Jun 11 17:48:18 upstairs kernel: [  287.229797] bus: 'scsi': add device 4:0:0:0 
Jun 11 17:48:18 upstairs kernel: [  287.229797] PM: Adding info for scsi:4:0:0:0 
Jun 11 17:48:18 upstairs kernel: [  287.229797] bus: 'scsi': driver_probe_device: matched device 4:0:0:0 with driver sd 
Jun 11 17:48:18 upstairs kernel: [  287.229797] bus: 'scsi': really_probe: probing driver sd with device 4:0:0:0 
Jun 11 17:48:18 upstairs kernel: [  287.229797] device: '4:0:0:0': device_add 
Jun 11 17:48:18 upstairs kernel: [  287.229797] PM: Adding info for No Bus:4:0:0:0 
Jun 11 17:48:18 upstairs kernel: [  287.450585] sd 4:0:0:0: [sdd] 2013184 512-byte hardware sectors (1031 MB) 
Jun 11 17:48:18 upstairs kernel: [  287.452792] sd 4:0:0:0: [sdd] Write Protect is off 
Jun 11 17:48:18 upstairs kernel: [  287.452792] sd 4:0:0:0: [sdd] Mode Sense: 23 00 00 00 
Jun 11 17:48:18 upstairs kernel: [  287.452792] sd 4:0:0:0: [sdd] Assuming drive cache: write through 
Jun 11 17:48:18 upstairs kernel: [  287.452792] device: 'sdd': device_add 
Jun 11 17:48:18 upstairs kernel: [  287.452792] PM: Adding info for No Bus:sdd 
Jun 11 17:48:18 upstairs kernel: [  287.455588] sd 4:0:0:0: [sdd] 2013184 512-byte hardware sectors (1031 MB) 
Jun 11 17:48:18 upstairs kernel: [  287.456198] sd 4:0:0:0: [sdd] Write Protect is off 
Jun 11 17:48:18 upstairs kernel: [  287.456206] sd 4:0:0:0: [sdd] Mode Sense: 23 00 00 00 
Jun 11 17:48:18 upstairs kernel: [  287.456211] sd 4:0:0:0: [sdd] Assuming drive cache: write through 
Jun 11 17:48:18 upstairs kernel: [  287.456213]  sdd: sdd1 
Jun 11 17:48:18 upstairs kernel: [  287.457062] device: 'sdd1': device_add 
Jun 11 17:48:18 upstairs kernel: [  287.457087] PM: Adding info for No Bus:sdd1 
Jun 11 17:48:18 upstairs kernel: [  287.457196] device: '8:48': device_add 
Jun 11 17:48:18 upstairs kernel: [  287.457222] PM: Adding info for No Bus:8:48 
Jun 11 17:48:18 upstairs kernel: [  287.457245] sd 4:0:0:0: [sdd] Attached SCSI removable disk 
Jun 11 17:48:18 upstairs kernel: [  287.457247] driver: '4:0:0:0': driver_bound: bound to device 'sd' 
Jun 11 17:48:18 upstairs kernel: [  287.457253] bus: 'scsi': really_probe: bound device 4:0:0:0 to driver sd 
Jun 11 17:48:18 upstairs kernel: [  287.457263] device: '4:0:0:0': device_add 
Jun 11 17:48:18 upstairs kernel: [  287.457290] PM: Adding info for No Bus:4:0:0:0 
Jun 11 17:48:18 upstairs kernel: [  287.458743] usb-storage: device scan complete 

--Boundary-00=_9ACUIUqnjbSMlTr--
