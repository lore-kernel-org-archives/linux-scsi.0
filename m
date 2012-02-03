From: Bjorn Helgaas <bhelgaas@google.com>
Subject: device removal causes "sysfs: can not remove 'bsg', no directory"
Date: Fri, 3 Feb 2012 14:44:44 -0800
Message-ID: <CAErSpo5vyFDA9OikJM5GvUbb8Bk6fU47JjY7t9GU4Ppqr1O_BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34159 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2BCWpG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2012 17:45:06 -0500
Received: by wics10 with SMTP id s10so2986243wic.19
        for <linux-scsi@vger.kernel.org>; Fri, 03 Feb 2012 14:45:04 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric Moore <Eric.Moore@lsi.com>, DL-MPTFusionLinux@lsi.com, "Eric W. Biederman" <ebiederm@xmission.com>

Eric recently added ce59791936, which is a check that complains if we
try to remove files from non-existent directories.

When I remove a device (LSI SAS2008 in this case, but I don't know if
it's specific to that), I hit that warning three times.  Let me know
if I can collect any more data.

# lspci -s0000:08:00.0
08:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic
SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)

# echo 0000:08:00.0 > /sys/bus/pci/drivers/mpt2sas/unbind
[  193.105962] sd 6:0:0:0: [sdb] Synchronizing SCSI cache
[  193.111132] sd 6:0:0:0: [sdb]  Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK
[  193.234690] ------------[ cut here ]------------
[  193.239302] WARNING: at fs/sysfs/inode.c:323
sysfs_hash_and_remove+0xa4/0xb0()
[  193.249908] sysfs: can not remove 'bsg', no directory
[  193.254949] Modules linked in: w1_therm ds2482 wire msr cpuid
e1000e bnx2x crc32c libcrc32c mdio ipv6 genrtc
[  193.265035] Pid: 15020, comm: bash Not tainted 3.3.0-smp-DEV #11
[  193.271030] Call Trace:
[  193.273482]  [<ffffffff8108de33>] warn_slowpath_common+0x83/0x120
[  193.279558]  [<ffffffff8108df86>] warn_slowpath_fmt+0x46/0x60
[  193.285308]  [<ffffffff81225d24>] sysfs_hash_and_remove+0xa4/0xb0
[  193.291397]  [<ffffffff81229eb6>] sysfs_remove_link+0x26/0x30
[  193.297128]  [<ffffffff8131041c>] bsg_unregister_queue+0xbc/0x100
[  193.303224]  [<ffffffff8143cb08>] sas_rphy_free+0xa8/0xe0
[  193.308611]  [<ffffffff8143d9c5>] sas_port_delete+0x35/0x170
[  193.314266]  [<ffffffff81229eb6>] ? sysfs_remove_link+0x26/0x30
[  193.320187]  [<ffffffff8146342a>] mpt2sas_transport_port_remove+0x15a/0x200
[  193.327138]  [<ffffffff8145bbdb>] _scsih_remove_device+0xbb/0xc0
[  193.333147]  [<ffffffff815f86d9>] _scsih_remove+0x294/0x343
[  193.338719]  [<ffffffff813404d7>] pci_device_remove+0x37/0x70
[  193.344452]  [<ffffffff813f621b>] __device_release_driver+0x7b/0xe0
[  193.350708]  [<ffffffff813f636d>] device_release_driver+0x2d/0x40
[  193.356797]  [<ffffffff813f5521>] driver_unbind+0xc1/0xe0
[  193.362192]  [<ffffffff813f473c>] drv_attr_store+0x2c/0x30
[  193.367665]  [<ffffffff812269b2>] sysfs_write_file+0xe2/0x170
[  193.373404]  [<ffffffff811ac0d8>] vfs_write+0xc8/0x190
[  193.378531]  [<ffffffff811ac291>] sys_write+0x51/0x90
[  193.383573]  [<ffffffff81606bdf>] sysenter_dispatch+0x7/0x1a
[  193.389228] ---[ end trace d10f9ac01058d5da ]---
[  193.393971] mpt2sas0: removing handle(0x0009), sas_addr(0x4433221100000000)
[  193.554031] sd 6:0:1:0: [sdc] Synchronizing SCSI cache
[  193.559199] sd 6:0:1:0: [sdc]  Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK
[  193.683925] ------------[ cut here ]------------
[  193.688536] WARNING: at fs/sysfs/inode.c:323
sysfs_hash_and_remove+0xa4/0xb0()
[  193.699144] sysfs: can not remove 'bsg', no directory
[  193.704183] Modules linked in: w1_therm ds2482 wire msr cpuid
e1000e bnx2x crc32c libcrc32c mdio ipv6 genrtc
[  193.714269] Pid: 15020, comm: bash Tainted: G        W    3.3.0-smp-DEV #11
[  193.721209] Call Trace:
[  193.723665]  [<ffffffff8108de33>] warn_slowpath_common+0x83/0x120
[  193.729753]  [<ffffffff8108df86>] warn_slowpath_fmt+0x46/0x60
[  193.735487]  [<ffffffff81225d24>] sysfs_hash_and_remove+0xa4/0xb0
[  193.741573]  [<ffffffff81229eb6>] sysfs_remove_link+0x26/0x30
[  193.747313]  [<ffffffff8131041c>] bsg_unregister_queue+0xbc/0x100
[  193.753393]  [<ffffffff8143cb08>] sas_rphy_free+0xa8/0xe0
[  193.758780]  [<ffffffff8143d9c5>] sas_port_delete+0x35/0x170
[  193.764425]  [<ffffffff81229eb6>] ? sysfs_remove_link+0x26/0x30
[  193.770348]  [<ffffffff8146342a>] mpt2sas_transport_port_remove+0x15a/0x200
[  193.777299]  [<ffffffff8145bbdb>] _scsih_remove_device+0xbb/0xc0
[  193.783306]  [<ffffffff815f86d9>] _scsih_remove+0x294/0x343
[  193.788864]  [<ffffffff813404d7>] pci_device_remove+0x37/0x70
[  193.794595]  [<ffffffff813f621b>] __device_release_driver+0x7b/0xe0
[  193.800853]  [<ffffffff813f636d>] device_release_driver+0x2d/0x40
[  193.806933]  [<ffffffff813f5521>] driver_unbind+0xc1/0xe0
[  193.812334]  [<ffffffff813f473c>] drv_attr_store+0x2c/0x30
[  193.817824]  [<ffffffff812269b2>] sysfs_write_file+0xe2/0x170
[  193.823558]  [<ffffffff811ac0d8>] vfs_write+0xc8/0x190
[  193.828684]  [<ffffffff811ac291>] sys_write+0x51/0x90
[  193.833733]  [<ffffffff81606bdf>] sysenter_dispatch+0x7/0x1a
[  193.839381] ---[ end trace d10f9ac01058d5db ]---
[  193.844158] mpt2sas0: removing handle(0x000a), sas_addr(0x4433221104000000)
[  193.851639] mpt2sas0: sending message unit reset !!
[  193.858290] mpt2sas0: message unit reset: SUCCESS
[  194.234126] ------------[ cut here ]------------
[  194.238736] WARNING: at fs/sysfs/inode.c:323
sysfs_hash_and_remove+0xa4/0xb0()
[  194.249335] sysfs: can not remove 'bsg', no directory
[  194.254375] Modules linked in: w1_therm ds2482 wire msr cpuid
e1000e bnx2x crc32c libcrc32c mdio ipv6 genrtc
[  194.264441] Pid: 15020, comm: bash Tainted: G        W    3.3.0-smp-DEV #11
[  194.271401] Call Trace:
[  194.273849]  [<ffffffff8108de33>] warn_slowpath_common+0x83/0x120
[  194.279926]  [<ffffffff8108df86>] warn_slowpath_fmt+0x46/0x60
[  194.285658]  [<ffffffff813fac00>] ? transport_add_device+0x20/0x20
[  194.291831]  [<ffffffff81225d24>] sysfs_hash_and_remove+0xa4/0xb0
[  194.297909]  [<ffffffff813fac00>] ? transport_add_device+0x20/0x20
[  194.304074]  [<ffffffff81229eb6>] sysfs_remove_link+0x26/0x30
[  194.309806]  [<ffffffff8131041c>] bsg_unregister_queue+0xbc/0x100
[  194.315883]  [<ffffffff8143c378>] sas_host_remove+0x48/0x60
[  194.321442]  [<ffffffff813fac31>] transport_remove_classdev+0x31/0x70
[  194.327869]  [<ffffffff813fa4b0>]
attribute_container_device_trigger+0xa0/0xe0
[  194.335069]  [<ffffffff813fabb5>] transport_remove_device+0x15/0x20
[  194.341321]  [<ffffffff8142a69f>] scsi_remove_host+0xaf/0x120
[  194.347055]  [<ffffffff815f8771>] _scsih_remove+0x32c/0x343
[  194.352612]  [<ffffffff813404d7>] pci_device_remove+0x37/0x70
[  194.358345]  [<ffffffff813f621b>] __device_release_driver+0x7b/0xe0
[  194.364602]  [<ffffffff813f636d>] device_release_driver+0x2d/0x40
[  194.370688]  [<ffffffff813f5521>] driver_unbind+0xc1/0xe0
[  194.376084]  [<ffffffff813f473c>] drv_attr_store+0x2c/0x30
[  194.381557]  [<ffffffff812269b2>] sysfs_write_file+0xe2/0x170
[  194.387289]  [<ffffffff811ac0d8>] vfs_write+0xc8/0x190
[  194.392417]  [<ffffffff811ac291>] sys_write+0x51/0x90
[  194.397467]  [<ffffffff81606bdf>] sysenter_dispatch+0x7/0x1a
[  194.403121] ---[ end trace d10f9ac01058d5dc ]---
