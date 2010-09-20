From: Michael Reed <mdr@sgi.com>
Subject: [PATCH] sd name space exhaustion causes system hang
Date: Mon, 20 Sep 2010 11:20:22 -0500
Message-ID: <4C9789C6.7080601@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:35435 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275Ab0ITQUX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2010 12:20:23 -0400
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D03708F8096
	for <linux-scsi@vger.kernel.org>; Mon, 20 Sep 2010 09:20:22 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, Tony Ernst <tee@sgi.com>

Following a site power outage which re-enabled all the ports on my FC
switches, my system subsequently booted with far too many luns!  I had
let it run hoping it would make multi-user.  It didn't.  :(  It hung solid
after exhausting the last sd device, sdzzz, and attempting to create sdaaaa
and beyond.  I was unable to get a dump.

Discovered using a 2.6.32.13 based system.

Patch at the bottom corrects this by detecting when the last index is
utilized and failing the sd probe of the device.  Patch applies to
scsi-misc-2.6.


Signed-off-by: Michael Reed <mdr@sgi.com>


------------[ cut here ]------------
WARNING: at /usr/src/packages/BUILD/kernel-default-2.6.32.13/linux-2.6.32/block/genhd.c:547 add_disk+0x150/0x3c0()
Modules linked in: dm_mod tpm_tis mptfc qla2xxx tpm mptscsih ide_cd_mod tpm_bios shpchp mptbase lpfc pci_hotplug scsi_transport_fc tg3 button scsi_tgt sg cdrom sd_mod crc_t10dif qla1280 scsi_mod xfs exportfs fan processor sgiioc4 ide_core ioc4 thermal thermal_sys hwmon
Supported: Yes

Call Trace:
 [<a000000100017a80>] show_stack+0x80/0xa0
                                sp=e00000346db7fbf0 bsp=e00000346db712b8
 [<a0000001008e2d30>] dump_stack+0x30/0x50
                                sp=e00000346db7fdc0 bsp=e00000346db712a0
 [<a0000001000b8440>] warn_slowpath_common+0xc0/0x120
                                sp=e00000346db7fdc0 bsp=e00000346db71268
 [<a0000001000b84d0>] warn_slowpath_null+0x30/0x60
                                sp=e00000346db7fdc0 bsp=e00000346db71240
 [<a0000001004393f0>] add_disk+0x150/0x3c0
                                sp=e00000346db7fdc0 bsp=e00000346db71210
 [<a000000204e7c310>] sd_probe_async+0x1f0/0x4a0 [sd_mod]
                                sp=e00000346db7fdd0 bsp=e00000346db711b8
 [<a000000100105180>] run_one_entry+0x180/0x4c0
                                sp=e00000346db7fdd0 bsp=e00000346db71170
 [<a0000001001055b0>] async_thread+0xf0/0x1c0
                                sp=e00000346db7fdd0 bsp=e00000346db71140
 [<a0000001000f51e0>] kthread+0x100/0x140
                                sp=e00000346db7fe00 bsp=e00000346db71108
 [<a0000001000154f0>] kernel_thread_helper+0xd0/0x100
                                sp=e00000346db7fe30 bsp=e00000346db710e0
 [<a00000010000a4c0>] start_kernel_thread+0x20/0x40
                                sp=e00000346db7fe30 bsp=e00000346db710e0
---[ end trace 509bba4ec4cded93 ]---
sd 12:0:42:25: Attached scsi generic sg31636 type 0
 sdzzz:
 sdaaaa: unknown partition table
 unknown partition table
sd 13:0:42:41: [sdaaab] 51200 512-byte logical blocks: (26.2 MB/25.0 MiB)
scsi 3:0:43:6: Direct-Access     Linux    (none)           0818 PQ: 0 ANSI: 5
sd 2:0:43:25: Attached scsi generic sg31637 type 0
sd 13:0:42:41: [sdaaab] Write Protect is off
sd 13:0:42:41: [sdaaab] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA

------------[ cut here ]------------
WARNING: at /usr/src/packages/BUILD/kernel-default-2.6.32.13/linux-2.6.32/fs/sysfs/dir.c:491 sysfs_add_one+0x150/0x180()
sysfs: cannot create duplicate filename '/devices/virtual/bdi/0:0'
Modules linked in: dm_mod tpm_tis mptfc qla2xxx tpm mptscsih ide_cd_mod tpm_bios shpchp mptbase lpfc pci_hotplug scsi_transport_fc tg3 button scsi_tgt sg cdrom sd_mod crc_t10dif qla1280 scsi_mod xfs exportfs fan processor sgiioc4 ide_core ioc4 thermal thermal_sys hwmon
Supported: Yes

Call Trace:
 [<a000000100017a80>] show_stack+0x80/0xa0
                                sp=e00000346db9fb10 bsp=e00000346db915d8
 [<a0000001008e2d30>] dump_stack+0x30/0x50
                                sp=e00000346db9fce0 bsp=e00000346db915c0
 [<a0000001000b8440>] warn_slowpath_common+0xc0/0x120
                                sp=e00000346db9fce0 bsp=e00000346db91588
 [<a0000001000b8590>] warn_slowpath_fmt+0x90/0xc0
                                sp=e00000346db9fce0 bsp=e00000346db91528
 [<a00000010032f8b0>] sysfs_add_one+0x150/0x180
                                sp=e00000346db9fd20 bsp=e00000346db914e8
 [<a000000100330640>] create_dir+0x80/0x100
                                sp=e00000346db9fd20 bsp=e00000346db914b0
 [<a000000100330730>] sysfs_create_dir+0x70/0x100
                                sp=e00000346db9fd40 bsp=e00000346db91490
 [<a0000001004ac570>] kobject_add_internal+0x210/0x5c0
                                sp=e00000346db9fd50 bsp=e00000346db91448
 [<a0000001004acb20>] kobject_add_varg+0x60/0xc0
                                sp=e00000346db9fd50 bsp=e00000346db91410
 [<a0000001004accd0>] kobject_add+0x90/0x140
                                sp=e00000346db9fd50 bsp=e00000346db913a8
 [<a000000100636f00>] device_add+0x1a0/0xbc0
                                sp=e00000346db9fd80 bsp=e00000346db91348
 [<a000000100637950>] device_register+0x30/0x60
                                sp=e00000346db9fd90 bsp=e00000346db91328
 [<a000000100637b00>] device_create_vargs+0x180/0x1a0
                                sp=e00000346db9fd90 bsp=e00000346db912d8
 [<a0000001001c95d0>] bdi_register+0xf0/0x420
                                sp=e00000346db9fd90 bsp=e00000346db91268
 [<a0000001001c9940>] bdi_register_dev+0x40/0x60
                                sp=e00000346db9fdc0 bsp=e00000346db91240
 [<a0000001004395c0>] add_disk+0x320/0x3c0
                                sp=e00000346db9fdc0 bsp=e00000346db91210
 [<a000000204e7c310>] sd_probe_async+0x1f0/0x4a0 [sd_mod]
                                sp=e00000346db9fdd0 bsp=e00000346db911b8
 [<a000000100105180>] run_one_entry+0x180/0x4c0
                                sp=e00000346db9fdd0 bsp=e00000346db91170
 [<a0000001001055b0>] async_thread+0xf0/0x1c0
                                sp=e00000346db9fdd0 bsp=e00000346db91140
 [<a0000001000f51e0>] kthread+0x100/0x140
                                sp=e00000346db9fe00 bsp=e00000346db91108
 [<a0000001000154f0>] kernel_thread_helper+0xd0/0x100
                                sp=e00000346db9fe30 bsp=e00000346db910e0
 [<a00000010000a4c0>] start_kernel_thread+0x20/0x40
                                sp=e00000346db9fe30 bsp=e00000346db910e0
---[ end trace 509bba4ec4cded97 ]---
kobject_add_internal failed for 0:0 with -EEXIST, don't try to register things with the same name in the same directory.


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8c9b275..72bb658 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2252,11 +2252,10 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	index = sdkp->index;
 	dev = &sdp->sdev_gendev;
 
-	if (index < SD_MAX_DISKS) {
-		gd->major = sd_major((index & 0xf0) >> 4);
-		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-		gd->minors = SD_MINORS;
-	}
+	gd->major = sd_major((index & 0xf0) >> 4);
+	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+	gd->minors = SD_MINORS;
+		
 	gd->fops = &sd_fops;
 	gd->private_data = &sdkp->driver;
 	gd->queue = sdkp->device->request_queue;
@@ -2346,6 +2345,12 @@ static int sd_probe(struct device *dev)
 	if (error)
 		goto out_put;
 
+	if (index >= SD_MAX_DISKS) {
+		error = -ENODEV;
+		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name space exhausted.\n");
+		goto out_free_index;
+	}
+
 	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
 	if (error)
 		goto out_free_index;
