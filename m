From: =?utf-8?B?5LqO54ix5Y2O?= <crystal_yu@usish.com>
Subject: WARNING: at fs/sysfs/inode.c:323 sysfs_hash_and_remove+0xa4/0xb0()
Date: Thu, 22 Mar 2012 17:05:57 +0800
Message-ID: <005b01cd080a$febd81e0$fc3885a0$@com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:37468 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab2CVJGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Mar 2012 05:06:14 -0400
Content-Language: zh-cn
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

Sometimes, when I use rmmod to remove the module of pm8001, I will got problems as follows:

 WARNING: at fs/sysfs/inode.c:323 sysfs_hash_and_remove+0xa4/0xb0()
Hardware name: X7DB8
sysfs: can not remove 'device', no directory
Modules linked in: raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx ses enclosure spcv(O-) libsas scsi_transport_sas ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables tun autofs4 sunrpc p4_clockmod freq_table speedstep_lib bridge stp llc ipv6 dm_mirror dm_region_hash dm_log virtio_net virtio virtio_ring kvm_intel kvm microcode pcspkr i2c_i801 sg iTCO_wdt iTCO_vendor_support i5000_edac edac_core i5k_amb ioatdma dca e1000e shpchp ext4 mbcache jbd2 floppy sd_mod crc_t10dif pata_acpi ata_generic ata_piix radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core dm_mod [last unloaded: mperf]
Pid: 2835, comm: kworker/u:0 Tainted: G        W  O 3.3.0-rc3+ #2
Call Trace:
[<ffffffff8104c38f>] warn_slowpath_common+0x7f/0xc0
[<ffffffff8104c486>] warn_slowpath_fmt+0x46/0x50
[<ffffffff811d5e04>] sysfs_hash_and_remove+0xa4/0xb0
[<ffffffff811d8ad6>] sysfs_remove_link+0x26/0x30
[<ffffffffa00192c6>] enclosure_remove_links+0x56/0x80 [enclosure]
[<ffffffff811d805b>] ? remove_dir+0x3b/0x50
[<ffffffffa001940f>] enclosure_component_release+0x2f/0x50 [enclosure]
[<ffffffff8132c827>] device_release+0x27/0xa0
[<ffffffff81247e02>] kobject_cleanup+0x82/0x1b0
[<ffffffff81247f3d>] kobject_release+0xd/0x10
[<ffffffff81247c8c>] kobject_put+0x2c/0x60
[<ffffffff8132c417>] put_device+0x17/0x20
[<ffffffff8132d3da>] device_unregister+0x2a/0x60
[<ffffffffa0019a32>] enclosure_unregister+0x62/0x1e0 [enclosure]
[<ffffffffa002a07e>] ses_intf_remove_enclosure+0x6e/0x80 [ses]
[<ffffffffa002a118>] ses_intf_remove+0x88/0xa0 [ses]
[<ffffffff8132d2a9>] device_del+0xc9/0x1d0
[<ffffffff8132d3d2>] device_unregister+0x22/0x60
[<ffffffff81355605>] __scsi_remove_device+0xb5/0xd0
[<ffffffff81355650>] scsi_remove_device+0x30/0x50
[<ffffffff8135573d>] __scsi_remove_target+0xad/0xf0
[<ffffffff813557e0>] ? scsi_remove_target+0x60/0x60
[<ffffffff81355803>] __remove_child+0x23/0x30
[<ffffffff8132c97c>] device_for_each_child+0x4c/0x80
[<ffffffff813557b3>] scsi_remove_target+0x33/0x60
[<ffffffffa018423d>] sas_rphy_remove+0x5d/0x70 [scsi_transport_sas]
[<ffffffffa0184db6>] sas_rphy_delete+0x16/0x30 [scsi_transport_sas]
[<ffffffffa02811b9>] sas_destruct_devices+0x99/0xd0 [libsas]
[<ffffffffa0281120>] ? sas_unregister_common_dev+0x150/0x150 [libsas]
[<ffffffff81067428>] process_one_work+0x138/0x460
[<ffffffff810694da>] worker_thread+0x17a/0x3c0
[<ffffffff81069360>] ? manage_workers+0x120/0x120
[<ffffffff8106e10e>] kthread+0x9e/0xb0
[<ffffffff814ff164>] kernel_thread_helper+0x4/0x10
[<ffffffff8106e070>] ? kthread_freezable_should_stop+0x70/0x70
[<ffffffff814ff160>] ? gs_change+0x13/0x13
---[ end trace 3de392de6b7979d9 ]---

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

