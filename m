From: Oliver Neukum <oliver@neukum.org>
Subject: Oops unplugging USB stick
Date: Thu, 13 May 2004 18:03:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200405131803.52676.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.kontent.de ([81.88.34.36]:16051 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S264278AbUEMQEr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 12:04:47 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>

Hi,

a plugging/unplugging cycle generated this oops.
Linus BK tree of yesterday, uhci.

May 13 16:45:27 macbeth /etc/hotplug/usb.agent[20957]: need a device for this command
May 13 16:45:27 macbeth kernel: Initializing USB Mass Storage driver...
May 13 16:45:27 macbeth kernel: scsi1 : SCSI emulation for USB Mass Storage devices
May 13 16:45:27 macbeth kernel:   Vendor:           Model: USB DISK Pro      Rev: 2.00
May 13 16:45:27 macbeth kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
May 13 16:45:28 macbeth kernel: SCSI device sda: 250880 512-byte hdwr sectors (128 MB)
May 13 16:45:28 macbeth kernel: sda: assuming Write Enabled
May 13 16:45:28 macbeth kernel: sda: assuming drive cache: write through
May 13 16:45:28 macbeth kernel:  sda: sda1
May 13 16:45:28 macbeth kernel: Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
May 13 16:45:28 macbeth kernel: Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0
May 13 16:45:28 macbeth /etc/hotplug/scsi_device.agent[21043]: FATAL: Module sg not found.
May 13 16:45:28 macbeth kernel: USB Mass Storage device found at 2
May 13 16:45:28 macbeth kernel: usbcore: registered new driver usb-storage
May 13 16:45:28 macbeth kernel: USB Mass Storage support registered.
May 13 16:45:28 macbeth /etc/hotplug/block.agent[21042]: new block device /block/sda/sda1
May 13 16:45:28 macbeth /etc/hotplug/block.agent[21033]: waiting for /var/lock/block.agent.lock, process 21042 holds it
May 13 16:45:41 macbeth /etc/hotplug/block.agent[21042]: mount by-path/usb-storage-07441418065B:0:0:0p1
May 13 16:45:41 macbeth /etc/hotplug/block.agent[21042]: mount: fs type subfs not supported by kernel
May 13 16:45:41 macbeth /etc/hotplug/block.agent[21033]: new block device /block/sda
May 13 16:47:46 macbeth su: (to root) oliver on /dev/pts/70
May 13 16:47:46 macbeth su: pam_unix2: session started for user root, service su 
May 13 16:47:58 macbeth kernel: scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 0 lun 0
May 13 16:48:20 macbeth kernel: usb 1-1: USB disconnect, address 2
May 13 16:48:20 macbeth kernel: sd 1:0:0:0: Illegal state transition offline->cancel
May 13 16:48:20 macbeth kernel: Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1640
May 13 16:48:20 macbeth kernel: Call Trace:
May 13 16:48:20 macbeth kernel:  [<c0304bda>] scsi_device_set_state+0xea/0x140
May 13 16:48:20 macbeth kernel:  [<c02ff408>] scsi_device_cancel+0x28/0xfa
May 13 16:48:20 macbeth kernel:  [<c02ff520>] scsi_device_cancel_cb+0x0/0x20
May 13 16:48:20 macbeth kernel:  [<c02c312d>] device_for_each_child+0x3d/0x70
May 13 16:48:20 macbeth kernel:  [<c02ff57e>] scsi_host_cancel+0x3e/0xd0
May 13 16:48:20 macbeth kernel:  [<c02ff520>] scsi_device_cancel_cb+0x0/0x20
May 13 16:48:20 macbeth kernel:  [<c0343032>] usb_buffer_free+0x52/0x60
May 13 16:48:20 macbeth kernel:  [<c02ff626>] scsi_remove_host+0x16/0x60
May 13 16:48:20 macbeth kernel:  [<e1b63dd5>] storage_disconnect+0x35/0x40 [usb_storage]
May 13 16:48:20 macbeth kernel:  [<c0341d2a>] usb_unbind_interface+0x6a/0x70
May 13 16:48:20 macbeth kernel:  [<c02c4056>] device_release_driver+0x66/0x70
May 13 16:48:20 macbeth /etc/hotplug/usb.agent[21386]: need a device for this command
May 13 16:48:20 macbeth kernel:  [<c02c4195>] bus_remove_device+0x55/0xa0
May 13 16:48:20 macbeth kernel:  [<c02c3067>] device_del+0x57/0xc0
May 13 16:48:20 macbeth kernel:  [<c02c30e0>] device_unregister+0x10/0x20
May 13 16:48:20 macbeth kernel:  [<c0347e80>] usb_disable_device+0x90/0xc0
May 13 16:48:20 macbeth kernel:  [<c0342962>] usb_disconnect+0xa2/0xf0
May 13 16:48:20 macbeth kernel:  [<c03448ef>] hub_port_connect_change+0x8f/0x2d0
May 13 16:48:20 macbeth kernel:  [<c0344463>] hub_port_status+0x43/0xb0
May 13 16:48:20 macbeth kernel:  [<c0344da3>] hub_events+0x273/0x320
May 13 16:48:20 macbeth kernel:  [<c0344ea3>] hub_thread+0x53/0x100
May 13 16:48:20 macbeth kernel:  [<c0116ad0>] default_wake_function+0x0/0x20
May 13 16:48:20 macbeth kernel:  [<c0344e50>] hub_thread+0x0/0x100
May 13 16:48:20 macbeth kernel:  [<c01022ad>] kernel_thread_helper+0x5/0x18
May 13 16:48:20 macbeth kernel: 
May 13 16:48:20 macbeth kernel: sd 1:0:0:0: Illegal state transition offline->cancel
May 13 16:48:20 macbeth kernel: Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1640
May 13 16:48:20 macbeth kernel: Call Trace:
May 13 16:48:20 macbeth kernel:  [<c0304bda>] scsi_device_set_state+0xea/0x140
May 13 16:48:20 macbeth kernel:  [<c03071e0>] scsi_remove_device+0x20/0xc0
May 13 16:48:20 macbeth kernel:  [<c030653a>] scsi_forget_host+0x2a/0x50
May 13 16:48:20 macbeth kernel:  [<c02ff636>] scsi_remove_host+0x26/0x60
May 13 16:48:20 macbeth kernel:  [<e1b63dd5>] storage_disconnect+0x35/0x40 [usb_storage]
May 13 16:48:20 macbeth kernel:  [<c0341d2a>] usb_unbind_interface+0x6a/0x70
May 13 16:48:20 macbeth kernel:  [<c02c4056>] device_release_driver+0x66/0x70
May 13 16:48:20 macbeth kernel:  [<c02c4195>] bus_remove_device+0x55/0xa0
May 13 16:48:20 macbeth kernel:  [<c02c3067>] device_del+0x57/0xc0
May 13 16:48:20 macbeth kernel:  [<c02c30e0>] device_unregister+0x10/0x20
May 13 16:48:20 macbeth kernel:  [<c0347e80>] usb_disable_device+0x90/0xc0
May 13 16:48:20 macbeth kernel:  [<c0342962>] usb_disconnect+0xa2/0xf0
May 13 16:48:20 macbeth kernel:  [<c03448ef>] hub_port_connect_change+0x8f/0x2d0
May 13 16:48:20 macbeth kernel:  [<c0344463>] hub_port_status+0x43/0xb0
May 13 16:48:20 macbeth kernel:  [<c0344da3>] hub_events+0x273/0x320
May 13 16:48:20 macbeth kernel:  [<c0344ea3>] hub_thread+0x53/0x100
May 13 16:48:20 macbeth kernel:  [<c0116ad0>] default_wake_function+0x0/0x20
May 13 16:48:20 macbeth kernel:  [<c0344e50>] hub_thread+0x0/0x100
May 13 16:48:20 macbeth kernel:  [<c01022ad>] kernel_thread_helper+0x5/0x18
