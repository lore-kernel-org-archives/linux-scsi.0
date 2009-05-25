From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs
 directories.
Date: Mon, 25 May 2009 20:19:56 +0200
Message-ID: <1243275596.2975.4.camel@poy>
References: <Pine.LNX.4.44L0.0905251144470.24294-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:47317 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZEYST7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 May 2009 14:19:59 -0400
In-Reply-To: <Pine.LNX.4.44L0.0905251144470.24294-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>

On Mon, 2009-05-25 at 11:49 -0400, Alan Stern wrote:
> Since this appears to be a bug in the SCSI layer, let's add some SCSI
> people to the CC: list.
> 
> To summarize the problem: The SCSI core tries to unregister a host 
> while its sysfs directory is still non-empty because the target hasn't 
> been unregistered yet.

> Can you provide more of the context?  I'd like to see the log starting 
> from when these devices were first registered.

I was able to trigger it with a USB storage device only, connected to a
hub, and I removed the hub from the host.

Kay


[21415.579166] usb 2-2: new high speed USB device using ehci_hcd and address 26
[21415.693822] kobject: '2-2' (ffff8801390c9128): kobject_add_internal: parent: 'usb2', set: 'devices'
[21415.694151] kobject: '2-2' (ffff8801390c9128): kobject_uevent_env
[21415.694186] kobject: '2-2' (ffff8801390c9128): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2'
[21415.694299] usb 2-2: configuration #1 chosen from 1 choice
[21415.695512] kobject: '2-2:1.0' (ffff8800b9716b48): kobject_add_internal: parent: '2-2', set: 'devices'
[21415.695612] kobject: '2-2:1.0' (ffff8800b9716b48): kobject_uevent_env
[21415.695645] kobject: '2-2:1.0' (ffff8800b9716b48): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0'
[21415.695750] hub 2-2:1.0: USB hub found
[21415.696415] hub 2-2:1.0: 4 ports detected
[21415.701428] kobject: 'usb_endpoint' (ffff8800b9648198): kobject_add_internal: parent: '2-2:1.0', set: '<NULL>'
[21415.701457] kobject: 'usbdev2.26_ep81' (ffff8800b96f56f0): kobject_add_internal: parent: 'usb_endpoint', set: 'devices'
[21415.701656] kobject: 'usbdev2.26_ep81' (ffff8800b96f56f0): kobject_uevent_env
[21415.701694] kobject: 'usbdev2.26_ep81' (ffff8800b96f56f0): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/usb_endpoint/usbdev2.26_ep81'
[21415.701826] kobject: 'usb_endpoint' (ffff8800b96486e8): kobject_add_internal: parent: '2-2', set: '<NULL>'
[21415.701847] kobject: 'usbdev2.26_ep00' (ffff8800b96f5dc8): kobject_add_internal: parent: 'usb_endpoint', set: 'devices'
[21415.701972] kobject: 'usbdev2.26_ep00' (ffff8800b96f5dc8): kobject_uevent_env
[21415.702030] kobject: 'usbdev2.26_ep00' (ffff8800b96f5dc8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/usb_endpoint/usbdev2.26_ep00'
[21415.974325] usb 2-2.4: new high speed USB device using ehci_hcd and address 27
[21416.060815] kobject: '2-2.4' (ffff88013422cb20): kobject_add_internal: parent: '2-2', set: 'devices'
[21416.061184] kobject: '2-2.4' (ffff88013422cb20): kobject_uevent_env
[21416.061218] kobject: '2-2.4' (ffff88013422cb20): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4'
[21416.061330] usb 2-2.4: configuration #1 chosen from 1 choice
[21416.063752] kobject: '2-2.4:1.0' (ffff88013a9cc908): kobject_add_internal: parent: '2-2.4', set: 'devices'
[21416.063862] kobject: '2-2.4:1.0' (ffff88013a9cc908): kobject_uevent_env
[21416.063897] kobject: '2-2.4:1.0' (ffff88013a9cc908): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0'
[21416.097456] scsi10 : SCSI emulation for USB Mass Storage devices
[21416.097474] kobject: 'host10' (ffff8801001592f8): kobject_add_internal: parent: '2-2.4:1.0', set: 'devices'
[21416.097520] kobject: 'host10' (ffff8801001592f8): kobject_uevent_env
[21416.097541] kobject: 'host10' (ffff8801001592f8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10'
[21416.097797] kobject: 'scsi_host' (ffff8801340d3880): kobject_add_internal: parent: 'host10', set: '<NULL>'
[21416.097808] kobject: 'host10' (ffff8801001594c8): kobject_add_internal: parent: 'scsi_host', set: 'devices'
[21416.097888] kobject: 'host10' (ffff8801001594c8): kobject_uevent_env
[21416.097908] kobject: 'host10' (ffff8801001594c8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/scsi_host/host10'
[21416.109077] kobject: 'usb_endpoint' (ffff8801340d3f68): kobject_add_internal: parent: '2-2.4:1.0', set: '<NULL>'
[21416.109096] kobject: 'usbdev2.27_ep81' (ffff8800b9668b88): kobject_add_internal: parent: 'usb_endpoint', set: 'devices'
[21416.109238] kobject: 'usbdev2.27_ep81' (ffff8800b9668b88): kobject_uevent_env
[21416.109259] kobject: 'usbdev2.27_ep81' (ffff8800b9668b88): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/usb_endpoint/usbdev2.27_ep81'
[21416.110897] kobject: 'usbdev2.27_ep02' (ffff8800b9668268): kobject_add_internal: parent: 'usb_endpoint', set: 'devices'
[21416.111007] kobject: 'usbdev2.27_ep02' (ffff8800b9668268): kobject_uevent_env
[21416.111027] kobject: 'usbdev2.27_ep02' (ffff8800b9668268): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/usb_endpoint/usbdev2.27_ep02'
[21416.112326] kobject: 'usb_endpoint' (ffff880115b54990): kobject_add_internal: parent: '2-2.4', set: '<NULL>'
[21416.112340] kobject: 'usbdev2.27_ep00' (ffff8800b9668dd0): kobject_add_internal: parent: 'usb_endpoint', set: 'devices'
[21416.112439] kobject: 'usbdev2.27_ep00' (ffff8800b9668dd0): kobject_uevent_env
[21416.112459] kobject: 'usbdev2.27_ep00' (ffff8800b9668dd0): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/usb_endpoint/usbdev2.27_ep00'
[21416.112675] usb-storage: device found at 27
[21416.112678] usb-storage: waiting for device to settle before scanning
[21421.113280] scsi 10:0:0:0: Direct-Access     SanDisk  U3 Cruzer Micro  8.02 PQ: 0 ANSI: 0 CCS
[21421.113304] kobject: 'target10:0:0' (ffff88013a9c9158): kobject_add_internal: parent: 'host10', set: 'devices'
[21421.113378] kobject: 'target10:0:0' (ffff88013a9c9158): kobject_uevent_env
[21421.113414] kobject: 'target10:0:0' (ffff88013a9c9158): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0'
[21421.113836] kobject: '10:0:0:0' (ffff88012bb87588): kobject_add_internal: parent: 'target10:0:0', set: 'devices'
[21421.118125] kobject: '10:0:0:0' (ffff88012bb87588): kobject_uevent_env
[21421.118200] kobject: '10:0:0:0' (ffff88012bb87588): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0'
[21421.120456] kobject: 'scsi_device' (ffff8801078d8220): kobject_add_internal: parent: '10:0:0:0', set: '<NULL>'
[21421.120476] kobject: '10:0:0:0' (ffff88012bb87758): kobject_add_internal: parent: 'scsi_device', set: 'devices'
[21421.120538] kobject: '10:0:0:0' (ffff88012bb87758): kobject_uevent_env
[21421.120575] kobject: '10:0:0:0' (ffff88012bb87758): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0/scsi_device/10:0:0:0'
[21421.121003] kobject: 'scsi_generic' (ffff8801388d55d8): kobject_add_internal: parent: '10:0:0:0', set: '<NULL>'
[21421.121022] kobject: 'sg3' (ffff8800b966a000): kobject_add_internal: parent: 'scsi_generic', set: 'devices'
[21421.121197] kobject: 'sg3' (ffff8800b966a000): kobject_uevent_env
[21421.121233] kobject: 'sg3' (ffff8800b966a000): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0/scsi_generic/sg3'
[21421.127335] sd 10:0:0:0: Attached scsi generic sg3 type 0
[21421.127393] kobject: 'bsg' (ffff8801388d56e8): kobject_add_internal: parent: '10:0:0:0', set: '<NULL>'
[21421.127412] kobject: '10:0:0:0' (ffff8800b966a248): kobject_add_internal: parent: 'bsg', set: 'devices'
[21421.127541] kobject: '10:0:0:0' (ffff8800b966a248): kobject_uevent_env
[21421.127581] kobject: '10:0:0:0' (ffff8800b966a248): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0/bsg/10:0:0:0'
[21421.128699] scsi 10:0:0:1: CD-ROM            SanDisk  U3 Cruzer Micro  8.02 PQ: 0 ANSI: 0
[21421.128720] kobject: '10:0:0:1' (ffff880139003b90): kobject_add_internal: parent: 'target10:0:0', set: 'devices'
[21421.128870] kobject: '10:0:0:1' (ffff880139003b90): kobject_uevent_env
[21421.128904] kobject: '10:0:0:1' (ffff880139003b90): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:1'
[21421.132180] sr0: scsi3-mmc drive: 48x/48x tray
[21421.132220] kobject: 'block' (ffff880139009d48): kobject_add_internal: parent: '10:0:0:1', set: '<NULL>'
[21421.132241] kobject: 'sr0' (ffff880138836fa8): kobject_add_internal: parent: 'block', set: 'devices'
[21421.132378] kobject: 'sr0' (ffff880138836fa8): kobject_uevent_env
[21421.132385] kobject: 'sr0' (ffff880138836fa8): kobject_uevent_env: uevent_suppress caused the event to drop!
[21421.132417] kobject: 'holders' (ffff880129f63440): kobject_add_internal: parent: 'sr0', set: '<NULL>'
[21421.132437] kobject: 'slaves' (ffff88013886c6e8): kobject_add_internal: parent: 'sr0', set: '<NULL>'
[21421.132450] kobject: 'sr0' (ffff880138836fa8): kobject_uevent_env
[21421.132485] kobject: 'sr0' (ffff880138836fa8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:1/block/sr0'
[21421.132837] kobject: 'queue' (ffff88013aea0ff0): kobject_add_internal: parent: 'sr0', set: '<NULL>'
[21421.132903] kobject: 'queue' (ffff88013aea0ff0): kobject_uevent_env
[21421.132910] kobject: 'queue' (ffff88013aea0ff0): kobject_uevent_env: filter function caused the event to drop!
[21421.132921] kobject: 'iosched' (ffff8801350a5c40): kobject_add_internal: parent: 'queue', set: '<NULL>'
[21421.136715] kobject: 'iosched' (ffff8801350a5c40): kobject_uevent_env
[21421.136721] kobject: 'iosched' (ffff8801350a5c40): kobject_uevent_env: filter function caused the event to drop!
[21421.136738] kobject: '11:0' (ffff8800b96696e0): kobject_add_internal: parent: 'bdi', set: 'devices'
[21421.136785] kobject: '11:0' (ffff8800b96696e0): kobject_uevent_env
[21421.136804] kobject: '11:0' (ffff8800b96696e0): fill_kobj_path: path = '/devices/virtual/bdi/11:0'
[21421.137067] sr 10:0:0:1: Attached scsi CD-ROM sr0
[21421.137086] kobject: 'scsi_device' (ffff880129c6a550): kobject_add_internal: parent: '10:0:0:1', set: '<NULL>'
[21421.137098] kobject: '10:0:0:1' (ffff880139003d60): kobject_add_internal: parent: 'scsi_device', set: 'devices'
[21421.137148] kobject: '10:0:0:1' (ffff880139003d60): kobject_uevent_env
[21421.137170] kobject: '10:0:0:1' (ffff880139003d60): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:1/scsi_device/10:0:0:1'
[21421.137369] kobject: 'scsi_generic' (ffff880129c6a6e8): kobject_add_internal: parent: '10:0:0:1', set: '<NULL>'
[21421.137380] kobject: 'sg4' (ffff8800b9669928): kobject_add_internal: parent: 'scsi_generic', set: 'devices'
[21421.137463] kobject: 'sg4' (ffff8800b9669928): kobject_uevent_env
[21421.137483] kobject: 'sg4' (ffff8800b9669928): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:1/scsi_generic/sg4'
[21421.137660] sr 10:0:0:1: Attached scsi generic sg4 type 5
[21421.137683] kobject: 'bsg' (ffff880129c6add0): kobject_add_internal: parent: '10:0:0:1', set: '<NULL>'
[21421.137692] kobject: '10:0:0:1' (ffff8800b96686e8): kobject_add_internal: parent: 'bsg', set: 'devices'
[21421.137746] kobject: '10:0:0:1' (ffff8800b96686e8): kobject_uevent_env
[21421.137766] kobject: '10:0:0:1' (ffff8800b96686e8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:1/bsg/10:0:0:1'
[21421.139671] kobject: '10:0:0:2' (ffff8801158df588): kobject_cleanup
[21421.139676] kobject: '10:0:0:2' (ffff8801158df588): calling ktype release
[21421.139696] kobject: '<NULL>' (ffff88013a9bbc40): kobject_cleanup
[21421.139700] kobject: '<NULL>' (ffff88013a9bbc40): calling ktype release
[21421.139708] kobject: '<NULL>' (ffff88013aea2730): kobject_cleanup
[21421.139712] kobject: '<NULL>' (ffff88013aea2730): calling ktype release
[21421.139737] kobject: '10:0:0:2': free name
[21421.139858] kobject: '10:0:1:0' (ffff8801158df588): kobject_cleanup
[21421.139862] kobject: '10:0:1:0' (ffff8801158df588): calling ktype release
[21421.139876] kobject: '<NULL>' (ffff880139385af8): kobject_cleanup
[21421.139880] kobject: '<NULL>' (ffff880139385af8): calling ktype release
[21421.139887] kobject: '<NULL>' (ffff88013aea2730): kobject_cleanup
[21421.139890] kobject: '<NULL>' (ffff88013aea2730): calling ktype release
[21421.139912] kobject: '10:0:1:0': free name
[21421.139918] kobject: 'target10:0:1' (ffff88013a9c99e8): kobject_cleanup
[21421.139922] kobject: 'target10:0:1' (ffff88013a9c99e8): calling ktype release
[21421.139928] kobject: 'target10:0:1': free name
[21421.140064] kobject: '10:0:2:0' (ffff8801158df588): kobject_cleanup
[21421.140068] kobject: '10:0:2:0' (ffff8801158df588): calling ktype release
[21421.140082] kobject: '<NULL>' (ffff880139385af8): kobject_cleanup
[21421.140086] kobject: '<NULL>' (ffff880139385af8): calling ktype release
[21421.140092] kobject: '<NULL>' (ffff88013aea2730): kobject_cleanup
[21421.140096] kobject: '<NULL>' (ffff88013aea2730): calling ktype release
[21421.140118] kobject: '10:0:2:0': free name
[21421.140124] kobject: 'target10:0:2' (ffff880124839158): kobject_cleanup
[21421.140142] kobject: 'target10:0:2' (ffff880124839158): calling ktype release
[21421.140149] kobject: 'target10:0:2': free name
[21421.140267] kobject: '10:0:3:0' (ffff8801158df588): kobject_cleanup
[21421.140271] kobject: '10:0:3:0' (ffff8801158df588): calling ktype release
[21421.140285] kobject: '<NULL>' (ffff880139385af8): kobject_cleanup
[21421.140289] kobject: '<NULL>' (ffff880139385af8): calling ktype release
[21421.140296] kobject: '<NULL>' (ffff88013aea2730): kobject_cleanup
[21421.140299] kobject: '<NULL>' (ffff88013aea2730): calling ktype release
[21421.140321] kobject: '10:0:3:0': free name
[21421.140329] kobject: 'target10:0:3' (ffff880121091158): kobject_cleanup
[21421.140332] kobject: 'target10:0:3' (ffff880121091158): calling ktype release
[21421.140338] kobject: 'target10:0:3': free name
[21421.140459] kobject: '10:0:4:0' (ffff8801158df588): kobject_cleanup
[21421.140463] kobject: '10:0:4:0' (ffff8801158df588): calling ktype release
[21421.140477] kobject: '<NULL>' (ffff880139385af8): kobject_cleanup
[21421.140481] kobject: '<NULL>' (ffff880139385af8): calling ktype release
[21421.140488] kobject: '<NULL>' (ffff88013aea2730): kobject_cleanup
[21421.140491] kobject: '<NULL>' (ffff88013aea2730): calling ktype release
[21421.140513] kobject: '10:0:4:0': free name
[21421.140520] kobject: 'target10:0:4' (ffff880121091158): kobject_cleanup
[21421.140524] kobject: 'target10:0:4' (ffff880121091158): calling ktype release
[21421.140529] kobject: 'target10:0:4': free name
[21421.140652] kobject: '10:0:5:0' (ffff8801158df588): kobject_cleanup
[21421.140655] kobject: '10:0:5:0' (ffff8801158df588): calling ktype release
[21421.140669] kobject: '<NULL>' (ffff880139385af8): kobject_cleanup
[21421.140673] kobject: '<NULL>' (ffff880139385af8): calling ktype release
[21421.140680] kobject: '<NULL>' (ffff88013aea2730): kobject_cleanup
[21421.140684] kobject: '<NULL>' (ffff88013aea2730): calling ktype release
[21421.140706] kobject: '10:0:5:0': free name
[21421.140713] kobject: 'target10:0:5' (ffff880121091158): kobject_cleanup
[21421.140716] kobject: 'target10:0:5' (ffff880121091158): calling ktype release
[21421.140722] kobject: 'target10:0:5': free name
[21421.140839] kobject: '10:0:6:0' (ffff8801158df588): kobject_cleanup
[21421.140843] kobject: '10:0:6:0' (ffff8801158df588): calling ktype release
[21421.140857] kobject: '<NULL>' (ffff880139385af8): kobject_cleanup
[21421.140861] kobject: '<NULL>' (ffff880139385af8): calling ktype release
[21421.140868] kobject: '<NULL>' (ffff88013aea2730): kobject_cleanup
[21421.140871] kobject: '<NULL>' (ffff88013aea2730): calling ktype release
[21421.140893] kobject: '10:0:6:0': free name
[21421.140900] kobject: 'target10:0:6' (ffff880121091158): kobject_cleanup
[21421.140904] kobject: 'target10:0:6' (ffff880121091158): calling ktype release
[21421.140909] kobject: 'target10:0:6': free name
[21421.141026] kobject: '10:0:7:0' (ffff8801158df588): kobject_cleanup
[21421.141030] kobject: '10:0:7:0' (ffff8801158df588): calling ktype release
[21421.141044] kobject: '<NULL>' (ffff880139385af8): kobject_cleanup
[21421.141048] kobject: '<NULL>' (ffff880139385af8): calling ktype release
[21421.141054] kobject: '<NULL>' (ffff88013aea2730): kobject_cleanup
[21421.141058] kobject: '<NULL>' (ffff88013aea2730): calling ktype release
[21421.141080] kobject: '10:0:7:0': free name
[21421.141086] kobject: 'target10:0:7' (ffff880121091158): kobject_cleanup
[21421.141090] kobject: 'target10:0:7' (ffff880121091158): calling ktype release
[21421.141095] kobject: 'target10:0:7': free name
[21421.141101] usb-storage: device scan complete
[21421.170592] kobject: 'scsi_disk' (ffff880134173770): kobject_add_internal: parent: '10:0:0:0', set: '<NULL>'
[21421.170611] kobject: '10:0:0:0' (ffff8800b9669dc8): kobject_add_internal: parent: 'scsi_disk', set: 'devices'
[21421.170684] kobject: '10:0:0:0' (ffff8800b9669dc8): kobject_uevent_env
[21421.170708] kobject: '10:0:0:0' (ffff8800b9669dc8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0/scsi_disk/10:0:0:0'
[21421.171628] sd 10:0:0:0: [sdd] 31777279 512-byte hardware sectors: (16.2 GB/15.1 GiB)
[21421.172223] sd 10:0:0:0: [sdd] Write Protect is off
[21421.172228] sd 10:0:0:0: [sdd] Mode Sense: 45 00 00 08
[21421.172231] sd 10:0:0:0: [sdd] Assuming drive cache: write through
[21421.172265] kobject: 'block' (ffff8800b14ae000): kobject_add_internal: parent: '10:0:0:0', set: '<NULL>'
[21421.172285] kobject: 'sdd' (ffff88013af24920): kobject_add_internal: parent: 'block', set: 'devices'
[21421.188631] kobject: 'sdd' (ffff88013af24920): kobject_uevent_env
[21421.188637] kobject: 'sdd' (ffff88013af24920): kobject_uevent_env: uevent_suppress caused the event to drop!
[21421.188658] kobject: 'holders' (ffff8800b9648880): kobject_add_internal: parent: 'sdd', set: '<NULL>'
[21421.188669] kobject: 'slaves' (ffff8800b9648908): kobject_add_internal: parent: 'sdd', set: '<NULL>'
[21421.189054] kobject: '10:0:0:0' (ffff88012bb87588): kobject_uevent_env
[21421.189077] kobject: '10:0:0:0' (ffff88012bb87588): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0'
[21421.190637] sd 10:0:0:0: [sdd] Assuming drive cache: write through
[21421.190671]  sdd: sdd1
[21421.191270] kobject: 'sdd' (ffff88013af24920): kobject_uevent_env
[21421.191275] kobject: 'sdd' (ffff88013af24920): kobject_uevent_env: uevent_suppress caused the event to drop!
[21421.191282] sdd: p1 size 31793076 limited to end of disk
[21421.191305] kobject: 'sdd1' (ffff8800b9711588): kobject_add_internal: parent: 'sdd', set: 'devices'
[21421.191397] kobject: 'sdd1' (ffff8800b9711588): kobject_uevent_env
[21421.191401] kobject: 'sdd1' (ffff8800b9711588): kobject_uevent_env: uevent_suppress caused the event to drop!
[21421.191412] kobject: 'holders' (ffff8800b9648a18): kobject_add_internal: parent: 'sdd1', set: '<NULL>'
[21421.191420] kobject: 'sdd1' (ffff8800b9711588): kobject_uevent_env
[21421.191441] kobject: 'sdd1' (ffff8800b9711588): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0/block/sdd/sdd1'
[21421.192001] kobject: 'sdd' (ffff88013af24920): kobject_uevent_env
[21421.192034] kobject: 'sdd' (ffff88013af24920): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0/block/sdd'
[21421.192209] kobject: 'sdd1' (ffff8800b9711588): kobject_uevent_env
[21421.192230] kobject: 'sdd1' (ffff8800b9711588): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0/block/sdd/sdd1'
[21421.192399] kobject: 'queue' (ffff88013aea1b90): kobject_add_internal: parent: 'sdd', set: '<NULL>'
[21421.192445] kobject: 'queue' (ffff88013aea1b90): kobject_uevent_env
[21421.192450] kobject: 'queue' (ffff88013aea1b90): kobject_uevent_env: filter function caused the event to drop!
[21421.192456] kobject: 'iosched' (ffff8801392a6158): kobject_add_internal: parent: 'queue', set: '<NULL>'
[21421.192488] kobject: 'iosched' (ffff8801392a6158): kobject_uevent_env
[21421.192492] kobject: 'iosched' (ffff8801392a6158): kobject_uevent_env: filter function caused the event to drop!
[21421.192505] kobject: '259:917504' (ffff8800b96f5498): kobject_add_internal: parent: 'bdi', set: 'devices'
[21421.192557] kobject: '259:917504' (ffff8800b96f5498): kobject_uevent_env
[21421.192575] kobject: '259:917504' (ffff8800b96f5498): fill_kobj_path: path = '/devices/virtual/bdi/259:917504'
[21421.192762] sd 10:0:0:0: [sdd] Attached SCSI removable disk
[21421.258331] kobject: 'sdd' (ffff88013af24920): kobject_uevent_env
[21421.258358] kobject: 'sdd' (ffff88013af24920): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0/block/sdd'
[21421.276118] kobject: '65534' (ffff88013ab522e8): kobject_add_internal: parent: 'uids', set: 'uids'
[21421.281107] kobject: '65534' (ffff88013ab522e8): kobject_uevent_env
[21421.281162] kobject: '65534' (ffff88013ab522e8): fill_kobj_path: path = '/kernel/uids/65534'
[21421.333642] kobject: '10:0:0:1' (ffff880139003b90): kobject_uevent_env
[21421.333667] kobject: '10:0:0:1' (ffff880139003b90): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:1'
[21421.335399] kobject: '65534' (ffff88013ab522e8): kobject_uevent_env
[21421.335420] kobject: '65534' (ffff88013ab522e8): fill_kobj_path: path = '/kernel/uids/65534'
[21421.335554] kobject: '65534' (ffff88013ab522e8): kobject_cleanup
[21421.335558] kobject: '65534' (ffff88013ab522e8): calling ktype release
[21421.335562] kobject: '65534': free name
[21421.340587] kobject: '65534' (ffff88013ab522e8): kobject_add_internal: parent: 'uids', set: 'uids'
[21421.340610] kobject: '65534' (ffff88013ab522e8): kobject_uevent_env
[21421.340631] kobject: '65534' (ffff88013ab522e8): fill_kobj_path: path = '/kernel/uids/65534'
[21421.361164] kobject: '65534' (ffff88013ab522e8): kobject_uevent_env
[21421.361185] kobject: '65534' (ffff88013ab522e8): fill_kobj_path: path = '/kernel/uids/65534'
[21421.361344] kobject: '65534' (ffff88013ab522e8): kobject_cleanup
[21421.361348] kobject: '65534' (ffff88013ab522e8): calling ktype release
[21421.361351] kobject: '65534': free name
[21421.425012] kobject: '65534' (ffff88013ab522e8): kobject_add_internal: parent: 'uids', set: 'uids'
[21421.425033] kobject: '65534' (ffff88013ab522e8): kobject_uevent_env
[21421.425051] kobject: '65534' (ffff88013ab522e8): fill_kobj_path: path = '/kernel/uids/65534'
[21421.447972] kobject: 'sr0' (ffff880138836fa8): kobject_uevent_env
[21421.448000] kobject: 'sr0' (ffff880138836fa8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:1/block/sr0'
[21421.462036] kobject: '65534' (ffff88013ab522e8): kobject_uevent_env
[21421.462058] kobject: '65534' (ffff88013ab522e8): fill_kobj_path: path = '/kernel/uids/65534'
[21421.462129] kobject: '65534' (ffff88013ab522e8): kobject_cleanup
[21421.462133] kobject: '65534' (ffff88013ab522e8): calling ktype release
[21421.462136] kobject: '65534': free name
[21421.508994] kobject: '65534' (ffff88013ab522e8): kobject_add_internal: parent: 'uids', set: 'uids'
[21421.509015] kobject: '65534' (ffff88013ab522e8): kobject_uevent_env
[21421.509034] kobject: '65534' (ffff88013ab522e8): fill_kobj_path: path = '/kernel/uids/65534'
[21421.538933] kobject: '65534' (ffff88013ab522e8): kobject_uevent_env
[21421.538955] kobject: '65534' (ffff88013ab522e8): fill_kobj_path: path = '/kernel/uids/65534'
[21421.539110] kobject: '65534' (ffff88013ab522e8): kobject_cleanup
[21421.539114] kobject: '65534' (ffff88013ab522e8): calling ktype release
[21421.539118] kobject: '65534': free name
[21421.548145] kobject: '65534' (ffff88013ab522e8): kobject_add_internal: parent: 'uids', set: 'uids'
[21421.548165] kobject: '65534' (ffff88013ab522e8): kobject_uevent_env
[21421.548184] kobject: '65534' (ffff88013ab522e8): fill_kobj_path: path = '/kernel/uids/65534'
[21421.588200] kobject: '65534' (ffff88013ab522e8): kobject_uevent_env
[21421.588221] kobject: '65534' (ffff88013ab522e8): fill_kobj_path: path = '/kernel/uids/65534'
[21421.588365] kobject: '65534' (ffff88013ab522e8): kobject_cleanup
[21421.588370] kobject: '65534' (ffff88013ab522e8): calling ktype release
[21421.588373] kobject: '65534': free name
[21421.722647] kobject: '65534' (ffff8801390f02e8): kobject_add_internal: parent: 'uids', set: 'uids'
[21421.722668] kobject: '65534' (ffff8801390f02e8): kobject_uevent_env
[21421.722687] kobject: '65534' (ffff8801390f02e8): fill_kobj_path: path = '/kernel/uids/65534'
[21421.756036] kobject: '65534' (ffff8801390f02e8): kobject_uevent_env
[21421.756057] kobject: '65534' (ffff8801390f02e8): fill_kobj_path: path = '/kernel/uids/65534'
[21421.756195] kobject: '65534' (ffff8801390f02e8): kobject_cleanup
[21421.756199] kobject: '65534' (ffff8801390f02e8): calling ktype release
[21421.756202] kobject: '65534': free name
[21423.065910] usb 2-2: USB disconnect, address 26
[21423.065915] usb 2-2.4: USB disconnect, address 27
[21423.066144] kobject: 'usbdev2.27_ep81' (ffff8800b9668b88): kobject_uevent_env
[21423.066168] kobject: 'usbdev2.27_ep81' (ffff8800b9668b88): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/usb_endpoint/usbdev2.27_ep81'
[21423.066227] kobject: 'usbdev2.27_ep81' (ffff8800b9668b88): kobject_cleanup
[21423.066231] kobject: 'usbdev2.27_ep81' (ffff8800b9668b88): calling ktype release
[21423.066245] kobject: 'usbdev2.27_ep81': free name
[21423.066363] kobject: 'usbdev2.27_ep02' (ffff8800b9668268): kobject_uevent_env
[21423.066383] kobject: 'usbdev2.27_ep02' (ffff8800b9668268): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/usb_endpoint/usbdev2.27_ep02'
[21423.066430] kobject: 'usb_endpoint' (ffff8801340d3f68): kobject_cleanup
[21423.066434] kobject: 'usb_endpoint' (ffff8801340d3f68): auto cleanup kobject_del
[21423.066453] kobject: 'usb_endpoint' (ffff8801340d3f68): calling ktype release
[21423.066457] kobject: (ffff8801340d3f68): dynamic_kobj_release
[21423.066462] kobject: 'usb_endpoint': free name
[21423.066466] kobject: 'usbdev2.27_ep02' (ffff8800b9668268): kobject_cleanup
[21423.066470] kobject: 'usbdev2.27_ep02' (ffff8800b9668268): calling ktype release
[21423.066476] kobject: 'usbdev2.27_ep02': free name
[21423.066708] kobject: '10:0:0:0' (ffff8800b966a248): kobject_uevent_env
[21423.066727] kobject: '10:0:0:0' (ffff8800b966a248): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0/bsg/10:0:0:0'
[21423.066773] kobject: 'bsg' (ffff8801388d56e8): kobject_cleanup
[21423.066776] kobject: 'bsg' (ffff8801388d56e8): auto cleanup kobject_del
[21423.066795] kobject: 'bsg' (ffff8801388d56e8): calling ktype release
[21423.066798] kobject: (ffff8801388d56e8): dynamic_kobj_release
[21423.066802] kobject: 'bsg': free name
[21423.066806] kobject: '10:0:0:0' (ffff8800b966a248): kobject_cleanup
[21423.066808] kobject: '10:0:0:0' (ffff8800b966a248): calling ktype release
[21423.066815] kobject: '10:0:0:0': free name
[21423.066928] kobject: 'sg3' (ffff8800b966a000): kobject_uevent_env
[21423.066945] kobject: 'sg3' (ffff8800b966a000): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0/scsi_generic/sg3'
[21423.066988] kobject: 'scsi_generic' (ffff8801388d55d8): kobject_cleanup
[21423.066991] kobject: 'scsi_generic' (ffff8801388d55d8): auto cleanup kobject_del
[21423.067020] kobject: 'scsi_generic' (ffff8801388d55d8): calling ktype release
[21423.067023] kobject: (ffff8801388d55d8): dynamic_kobj_release
[21423.067026] kobject: 'scsi_generic': free name
[21423.067030] kobject: 'sg3' (ffff8800b966a000): kobject_cleanup
[21423.067033] kobject: 'sg3' (ffff8800b966a000): calling ktype release
[21423.067038] kobject: 'sg3': free name
[21423.067045] kobject: '<NULL>' (ffff8800b154c578): kobject_cleanup
[21423.067048] kobject: '<NULL>' (ffff8800b154c578): calling ktype release
[21423.067056] kobject: '<NULL>' (ffff88013af21178): kobject_cleanup
[21423.067059] kobject: '<NULL>' (ffff88013af21178): calling ktype release
[21423.067077] kobject: '10:0:0:0' (ffff88012bb87758): kobject_uevent_env
[21423.067094] kobject: '10:0:0:0' (ffff88012bb87758): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0/scsi_device/10:0:0:0'
[21423.067144] kobject: 'scsi_device' (ffff8801078d8220): kobject_cleanup
[21423.067148] kobject: 'scsi_device' (ffff8801078d8220): auto cleanup kobject_del
[21423.067165] kobject: 'scsi_device' (ffff8801078d8220): calling ktype release
[21423.067169] kobject: (ffff8801078d8220): dynamic_kobj_release
[21423.067174] kobject: 'scsi_device': free name
[21423.067178] kobject: '10:0:0:0' (ffff88012bb87758): kobject_cleanup
[21423.067181] kobject: '10:0:0:0' (ffff88012bb87758): calling ktype release
[21423.067186] kobject: '10:0:0:0': free name
[21423.067469] kobject: '10:0:0:0' (ffff8800b9669dc8): kobject_uevent_env
[21423.067490] kobject: '10:0:0:0' (ffff8800b9669dc8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0/scsi_disk/10:0:0:0'
[21423.067543] kobject: 'scsi_disk' (ffff880134173770): kobject_cleanup
[21423.067546] kobject: 'scsi_disk' (ffff880134173770): auto cleanup kobject_del
[21423.067564] kobject: 'scsi_disk' (ffff880134173770): calling ktype release
[21423.067568] kobject: (ffff880134173770): dynamic_kobj_release
[21423.067573] kobject: 'scsi_disk': free name
[21423.106153] kobject: 'holders' (ffff8800b9648a18): kobject_cleanup
[21423.106159] kobject: 'holders' (ffff8800b9648a18): auto cleanup kobject_del
[21423.106178] kobject: 'holders' (ffff8800b9648a18): calling ktype release
[21423.106182] kobject: (ffff8800b9648a18): dynamic_kobj_release
[21423.106187] kobject: 'holders': free name
[21423.106327] kobject: 'sdd1' (ffff8800b9711588): kobject_uevent_env
[21423.106352] kobject: 'sdd1' (ffff8800b9711588): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0/block/sdd/sdd1'
[21423.106507] kobject: '259:917504' (ffff8800b96f5498): kobject_uevent_env
[21423.106526] kobject: '259:917504' (ffff8800b96f5498): fill_kobj_path: path = '/devices/virtual/bdi/259:917504'
[21423.106572] kobject: '259:917504' (ffff8800b96f5498): kobject_cleanup
[21423.106575] kobject: '259:917504' (ffff8800b96f5498): calling ktype release
[21423.106584] kobject: '259:917504': free name
[21423.106590] kobject: 'iosched' (ffff8801392a6158): kobject_uevent_env
[21423.106595] kobject: 'iosched' (ffff8801392a6158): kobject_uevent_env: filter function caused the event to drop!
[21423.106628] kobject: 'queue' (ffff88013aea1b90): kobject_uevent_env
[21423.106632] kobject: 'queue' (ffff88013aea1b90): kobject_uevent_env: filter function caused the event to drop!
[21423.106680] kobject: 'holders' (ffff8800b9648880): kobject_cleanup
[21423.106684] kobject: 'holders' (ffff8800b9648880): auto cleanup kobject_del
[21423.106694] kobject: 'holders' (ffff8800b9648880): calling ktype release
[21423.106698] kobject: (ffff8800b9648880): dynamic_kobj_release
[21423.106702] kobject: 'holders': free name
[21423.106706] kobject: 'slaves' (ffff8800b9648908): kobject_cleanup
[21423.106709] kobject: 'slaves' (ffff8800b9648908): auto cleanup kobject_del
[21423.106720] kobject: 'slaves' (ffff8800b9648908): calling ktype release
[21423.106724] kobject: (ffff8800b9648908): dynamic_kobj_release
[21423.106728] kobject: 'slaves': free name
[21423.106897] kobject: 'sdd' (ffff88013af24920): kobject_uevent_env
[21423.106918] kobject: 'sdd' (ffff88013af24920): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0/block/sdd'
[21423.106970] kobject: 'block' (ffff8800b14ae000): kobject_cleanup
[21423.106974] kobject: 'block' (ffff8800b14ae000): auto cleanup kobject_del
[21423.106995] kobject: 'block' (ffff8800b14ae000): calling ktype release
[21423.106999] kobject: (ffff8800b14ae000): dynamic_kobj_release
[21423.107023] kobject: 'block': free name
[21423.111501] kobject: '10:0:0:0' (ffff88012bb87588): kobject_uevent_env
[21423.111527] kobject: '10:0:0:0' (ffff88012bb87588): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:0'
[21423.111721] kobject: '10:0:0:1' (ffff8800b96686e8): kobject_uevent_env
[21423.111743] kobject: '10:0:0:1' (ffff8800b96686e8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:1/bsg/10:0:0:1'
[21423.111796] kobject: 'bsg' (ffff880129c6add0): kobject_cleanup
[21423.111800] kobject: 'bsg' (ffff880129c6add0): auto cleanup kobject_del
[21423.111821] kobject: 'bsg' (ffff880129c6add0): calling ktype release
[21423.111825] kobject: (ffff880129c6add0): dynamic_kobj_release
[21423.111831] kobject: 'bsg': free name
[21423.111835] kobject: '10:0:0:1' (ffff8800b96686e8): kobject_cleanup
[21423.111838] kobject: '10:0:0:1' (ffff8800b96686e8): calling ktype release
[21423.111847] kobject: '10:0:0:1': free name
[21423.112456] kobject: 'sg4' (ffff8800b9669928): kobject_uevent_env
[21423.112477] kobject: 'sg4' (ffff8800b9669928): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:1/scsi_generic/sg4'
[21423.112530] kobject: 'scsi_generic' (ffff880129c6a6e8): kobject_cleanup
[21423.112534] kobject: 'scsi_generic' (ffff880129c6a6e8): auto cleanup kobject_del
[21423.112553] kobject: 'scsi_generic' (ffff880129c6a6e8): calling ktype release
[21423.112556] kobject: (ffff880129c6a6e8): dynamic_kobj_release
[21423.112560] kobject: 'scsi_generic': free name
[21423.112565] kobject: 'sg4' (ffff8800b9669928): kobject_cleanup
[21423.112568] kobject: 'sg4' (ffff8800b9669928): calling ktype release
[21423.112574] kobject: 'sg4': free name
[21423.112581] kobject: '<NULL>' (ffff8800b154ced8): kobject_cleanup
[21423.112585] kobject: '<NULL>' (ffff8800b154ced8): calling ktype release
[21423.112594] kobject: '<NULL>' (ffff88013a9f2298): kobject_cleanup
[21423.112597] kobject: '<NULL>' (ffff88013a9f2298): calling ktype release
[21423.112618] kobject: '10:0:0:1' (ffff880139003d60): kobject_uevent_env
[21423.112638] kobject: '10:0:0:1' (ffff880139003d60): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:1/scsi_device/10:0:0:1'
[21423.112687] kobject: 'scsi_device' (ffff880129c6a550): kobject_cleanup
[21423.112690] kobject: 'scsi_device' (ffff880129c6a550): auto cleanup kobject_del
[21423.112709] kobject: 'scsi_device' (ffff880129c6a550): calling ktype release
[21423.112713] kobject: (ffff880129c6a550): dynamic_kobj_release
[21423.112717] kobject: 'scsi_device': free name
[21423.112722] kobject: '10:0:0:1' (ffff880139003d60): kobject_cleanup
[21423.112725] kobject: '10:0:0:1' (ffff880139003d60): calling ktype release
[21423.112730] kobject: '10:0:0:1': free name
[21423.113117] kobject: '11:0' (ffff8800b96696e0): kobject_uevent_env
[21423.113137] kobject: '11:0' (ffff8800b96696e0): fill_kobj_path: path = '/devices/virtual/bdi/11:0'
[21423.113187] kobject: '11:0' (ffff8800b96696e0): kobject_cleanup
[21423.113191] kobject: '11:0' (ffff8800b96696e0): calling ktype release
[21423.113197] kobject: '11:0': free name
[21423.113202] kobject: 'iosched' (ffff8801350a5c40): kobject_uevent_env
[21423.113206] kobject: 'iosched' (ffff8801350a5c40): kobject_uevent_env: filter function caused the event to drop!
[21423.113248] kobject: 'queue' (ffff88013aea0ff0): kobject_uevent_env
[21423.113252] kobject: 'queue' (ffff88013aea0ff0): kobject_uevent_env: filter function caused the event to drop!
[21423.113289] kobject: 'holders' (ffff880129f63440): kobject_cleanup
[21423.113292] kobject: 'holders' (ffff880129f63440): auto cleanup kobject_del
[21423.113303] kobject: 'holders' (ffff880129f63440): calling ktype release
[21423.113306] kobject: (ffff880129f63440): dynamic_kobj_release
[21423.113311] kobject: 'holders': free name
[21423.113315] kobject: 'slaves' (ffff88013886c6e8): kobject_cleanup
[21423.113319] kobject: 'slaves' (ffff88013886c6e8): auto cleanup kobject_del
[21423.113329] kobject: 'slaves' (ffff88013886c6e8): calling ktype release
[21423.113332] kobject: (ffff88013886c6e8): dynamic_kobj_release
[21423.113337] kobject: 'slaves': free name
[21423.113500] kobject: 'sr0' (ffff880138836fa8): kobject_uevent_env
[21423.113520] kobject: 'sr0' (ffff880138836fa8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:1/block/sr0'
[21423.113568] kobject: 'block' (ffff880139009d48): kobject_cleanup
[21423.113571] kobject: 'block' (ffff880139009d48): auto cleanup kobject_del
[21423.113606] kobject: 'block' (ffff880139009d48): calling ktype release
[21423.113610] kobject: (ffff880139009d48): dynamic_kobj_release
[21423.113615] kobject: 'block': free name
[21423.113755] kobject: 'sr0' (ffff880138836fa8): kobject_cleanup
[21423.113759] kobject: 'sr0' (ffff880138836fa8): calling ktype release
[21423.113770] kobject: 'sr0': free name
[21423.113780] kobject: '10:0:0:1' (ffff880139003b90): kobject_uevent_env
[21423.113800] kobject: '10:0:0:1' (ffff880139003b90): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/target10:0:0/10:0:0:1'
[21423.113878] kobject: '10:0:0:1' (ffff880139003b90): kobject_cleanup
[21423.113882] kobject: '10:0:0:1' (ffff880139003b90): calling ktype release
[21423.113905] kobject: 'iosched' (ffff8801350a5c40): kobject_cleanup
[21423.113908] kobject: 'iosched' (ffff8801350a5c40): calling ktype release
[21423.113916] kobject: 'iosched': free name
[21423.113921] kobject: 'queue' (ffff88013aea0ff0): kobject_cleanup
[21423.113925] kobject: 'queue' (ffff88013aea0ff0): calling ktype release
[21423.113949] kobject: 'queue': free name
[21423.113961] kobject: '10:0:0:1': free name
[21423.114098] kobject: 'host10' (ffff8801001594c8): kobject_uevent_env
[21423.114118] kobject: 'host10' (ffff8801001594c8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10/scsi_host/host10'
[21423.114164] kobject: 'scsi_host' (ffff8801340d3880): kobject_cleanup
[21423.114168] kobject: 'scsi_host' (ffff8801340d3880): auto cleanup kobject_del
[21423.114186] kobject: 'scsi_host' (ffff8801340d3880): calling ktype release
[21423.114190] kobject: (ffff8801340d3880): dynamic_kobj_release
[21423.114194] kobject: 'scsi_host': free name
[21423.114198] kobject: 'host10' (ffff8801001594c8): kobject_cleanup
[21423.114201] kobject: 'host10' (ffff8801001594c8): calling ktype release
[21423.114207] kobject: 'host10': free name
[21423.114258] kobject: 'host10' (ffff8801001592f8): kobject_uevent_env
[21423.114277] kobject: 'host10' (ffff8801001592f8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host10'
[21423.114310] ------------[ cut here ]------------
[21423.114319] WARNING: at fs/sysfs/dir.c:794 sysfs_remove_dir+0xb2/0xd0()
[21423.114322] Hardware name: 2776LEG
[21423.114325] XXX dir: host10/target10:0:0
[21423.114327] Modules linked in: sr_mod cdrom sit tunnel4 ipv6 tun aes_x86_64 aes_generic i915 drm i2c_algo_bit i2c_core acpi_cpufreq snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd pl2303 usbserial usblp fuse loop dm_mod usb_storage usbhid hid cdc_ether usbnet cdc_wdm cdc_acm uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 arc4 ecb snd_hda_codec_conexant snd_hda_intel kvm_intel snd_hda_codec snd_pcm iwlagn thinkpad_acpi kvm snd_timer iwlcore hwmon rfkill mac80211 backlight uhci_hcd joydev pcspkr evdev led_class snd sg cfg80211 battery nvram ehci_hcd ac soundcore e1000e usbcore snd_page_alloc thermal button processor intel_agp
[21423.114421] Pid: 213, comm: khubd Tainted: G        W  2.6.30-rc7-dirty #41
[21423.114425] Call Trace:
[21423.114433]  [<ffffffff8023c6a8>] warn_slowpath_common+0x78/0xb0
[21423.114438]  [<ffffffff8023c73c>] warn_slowpath_fmt+0x3c/0x40
[21423.114442]  [<ffffffff80322a16>] ? sysfs_addrm_start+0x76/0xd0
[21423.114447]  [<ffffffff80323032>] sysfs_remove_dir+0xb2/0xd0
[21423.114455]  [<ffffffff803e5056>] kobject_del+0x16/0x40
[21423.114461]  [<ffffffff80477665>] device_del+0x165/0x1a0
[21423.114467]  [<ffffffff8048258f>] scsi_remove_host+0xcf/0x120
[21423.114481]  [<ffffffffa02c93cb>] quiesce_and_remove_host+0x6b/0xb0 [usb_storage]
[21423.114492]  [<ffffffffa02c94f8>] usb_stor_disconnect+0x18/0x30 [usb_storage]
[21423.114514]  [<ffffffffa003ffae>] usb_unbind_interface+0x6e/0x140 [usbcore]
[21423.114523]  [<ffffffff80479e49>] __device_release_driver+0x59/0xa0
[21423.114528]  [<ffffffff80479f88>] device_release_driver+0x28/0x40
[21423.114533]  [<ffffffff8047929c>] bus_remove_device+0xac/0xe0
[21423.114538]  [<ffffffff80477627>] device_del+0x127/0x1a0
[21423.114557]  [<ffffffffa003cb77>] usb_disable_device+0xa7/0x130 [usbcore]
[21423.114575]  [<ffffffffa0037818>] usb_disconnect+0xc8/0x140 [usbcore]
[21423.114593]  [<ffffffffa0037804>] usb_disconnect+0xb4/0x140 [usbcore]
[21423.114611]  [<ffffffffa00388db>] hub_thread+0x50b/0x1230 [usbcore]
[21423.114617]  [<ffffffff80565a76>] ? _spin_unlock_irq+0x26/0x30
[21423.114623]  [<ffffffff80237d1e>] ? finish_task_switch+0x7e/0x140
[21423.114629]  [<ffffffff80237cdb>] ? finish_task_switch+0x3b/0x140
[21423.114635]  [<ffffffff802549e0>] ? autoremove_wake_function+0x0/0x40
[21423.114653]  [<ffffffffa00383d0>] ? hub_thread+0x0/0x1230 [usbcore]
[21423.114658]  [<ffffffff802545b5>] kthread+0x55/0xa0
[21423.114664]  [<ffffffff8020cf3a>] child_rip+0xa/0x20
[21423.114669]  [<ffffffff80254560>] ? kthread+0x0/0xa0
[21423.114674]  [<ffffffff8020cf30>] ? child_rip+0x0/0x20
[21423.114678] ---[ end trace 89cad9e6bbbcf701 ]---
[21423.114755] kobject: '2-2.4:1.0' (ffff88013a9cc908): kobject_uevent_env
[21423.114774] kobject: '2-2.4:1.0' (ffff88013a9cc908): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0'
[21423.114976] kobject: 'usbdev2.27_ep00' (ffff8800b9668dd0): kobject_uevent_env
[21423.114995] kobject: 'usbdev2.27_ep00' (ffff8800b9668dd0): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/usb_endpoint/usbdev2.27_ep00'
[21423.115059] kobject: 'usb_endpoint' (ffff880115b54990): kobject_cleanup
[21423.115063] kobject: 'usb_endpoint' (ffff880115b54990): auto cleanup kobject_del
[21423.115092] kobject: 'usb_endpoint' (ffff880115b54990): calling ktype release
[21423.115096] kobject: (ffff880115b54990): dynamic_kobj_release
[21423.115101] kobject: 'usb_endpoint': free name
[21423.115106] kobject: 'usbdev2.27_ep00' (ffff8800b9668dd0): kobject_cleanup
[21423.115109] kobject: 'usbdev2.27_ep00' (ffff8800b9668dd0): calling ktype release
[21423.115117] kobject: 'usbdev2.27_ep00': free name
[21423.115513] kobject: '2-2.4' (ffff88013422cb20): kobject_uevent_env
[21423.115532] kobject: '2-2.4' (ffff88013422cb20): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4'
[21423.115583] kobject: '2-2.4' (ffff88013422cb20): kobject_cleanup
[21423.115586] kobject: '2-2.4' (ffff88013422cb20): calling ktype release
[21423.115607] kobject: '2-2.4': free name
[21423.115808] kobject: 'usbdev2.26_ep81' (ffff8800b96f56f0): kobject_uevent_env
[21423.115828] kobject: 'usbdev2.26_ep81' (ffff8800b96f56f0): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/usb_endpoint/usbdev2.26_ep81'
[21423.115875] kobject: 'usb_endpoint' (ffff8800b9648198): kobject_cleanup
[21423.115879] kobject: 'usb_endpoint' (ffff8800b9648198): auto cleanup kobject_del
[21423.115898] kobject: 'usb_endpoint' (ffff8800b9648198): calling ktype release
[21423.115902] kobject: (ffff8800b9648198): dynamic_kobj_release
[21423.115907] kobject: 'usb_endpoint': free name
[21423.115912] kobject: 'usbdev2.26_ep81' (ffff8800b96f56f0): kobject_cleanup
[21423.115915] kobject: 'usbdev2.26_ep81' (ffff8800b96f56f0): calling ktype release
[21423.115924] kobject: 'usbdev2.26_ep81': free name
[21423.116154] kobject: '2-2:1.0' (ffff8800b9716b48): kobject_uevent_env
[21423.116173] kobject: '2-2:1.0' (ffff8800b9716b48): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0'
[21423.116224] kobject: '2-2:1.0' (ffff8800b9716b48): kobject_cleanup
[21423.116228] kobject: '2-2:1.0' (ffff8800b9716b48): calling ktype release
[21423.116235] kobject: '2-2:1.0': free name
[21423.116364] kobject: 'usbdev2.26_ep00' (ffff8800b96f5dc8): kobject_uevent_env
[21423.116383] kobject: 'usbdev2.26_ep00' (ffff8800b96f5dc8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/usb_endpoint/usbdev2.26_ep00'
[21423.116432] kobject: 'usb_endpoint' (ffff8800b96486e8): kobject_cleanup
[21423.116435] kobject: 'usb_endpoint' (ffff8800b96486e8): auto cleanup kobject_del
[21423.116455] kobject: 'usb_endpoint' (ffff8800b96486e8): calling ktype release
[21423.116459] kobject: (ffff8800b96486e8): dynamic_kobj_release
[21423.116463] kobject: 'usb_endpoint': free name
[21423.116468] kobject: 'usbdev2.26_ep00' (ffff8800b96f5dc8): kobject_cleanup
[21423.116472] kobject: 'usbdev2.26_ep00' (ffff8800b96f5dc8): calling ktype release
[21423.116478] kobject: 'usbdev2.26_ep00': free name
[21423.116830] kobject: '2-2' (ffff8801390c9128): kobject_uevent_env
[21423.116849] kobject: '2-2' (ffff8801390c9128): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2'
[21423.116897] kobject: '2-2' (ffff8801390c9128): kobject_cleanup
[21423.116901] kobject: '2-2' (ffff8801390c9128): calling ktype release
[21423.116917] kobject: '2-2': free name
[21423.269004] kobject: 'sdd1' (ffff8800b9711588): kobject_cleanup
[21423.269009] kobject: 'sdd1' (ffff8800b9711588): calling ktype release
[21423.269021] kobject: 'sdd1': free name
[21423.269040] kobject: '10:0:0:0' (ffff8800b9669dc8): kobject_cleanup
[21423.269044] kobject: '10:0:0:0' (ffff8800b9669dc8): calling ktype release
[21423.269055] kobject: '10:0:0:0': free name
[21423.269062] kobject: '10:0:0:0' (ffff88012bb87588): kobject_cleanup
[21423.269066] kobject: '10:0:0:0' (ffff88012bb87588): calling ktype release
[21423.269103] kobject: 'iosched' (ffff8801392a6158): kobject_cleanup
[21423.269106] kobject: 'iosched' (ffff8801392a6158): calling ktype release
[21423.269114] kobject: 'iosched': free name
[21423.269119] kobject: 'queue' (ffff88013aea1b90): kobject_cleanup
[21423.269123] kobject: 'queue' (ffff88013aea1b90): calling ktype release
[21423.272572] kobject: 'queue': free name
[21423.272654] kobject: 'target10:0:0' (ffff88013a9c9158): kobject_uevent_env
[21423.272674] kobject: 'target10:0:0' (ffff88013a9c9158): fill_kobj_path: path = '/host10/target10:0:0'
[21423.272864] kobject: 'target10:0:0' (ffff88013a9c9158): kobject_cleanup
[21423.272869] kobject: 'target10:0:0' (ffff88013a9c9158): calling ktype release
[21423.272876] kobject: 'host10' (ffff8801001592f8): kobject_cleanup
[21423.272879] kobject: 'host10' (ffff8801001592f8): calling ktype release
[21423.272936] kobject: '2-2.4:1.0' (ffff88013a9cc908): kobject_cleanup
[21423.272939] kobject: '2-2.4:1.0' (ffff88013a9cc908): calling ktype release
[21423.272954] kobject: '2-2.4:1.0': free name
[21423.272969] kobject: 'host10': free name
[21423.272984] kobject: 'target10:0:0': free name
[21423.272990] kobject: '10:0:0:0': free name
[21423.272995] kobject: 'sdd' (ffff88013af24920): kobject_cleanup
[21423.272998] kobject: 'sdd' (ffff88013af24920): calling ktype release
[21423.273011] kobject: 'sdd': free name

