From: Brian King <brking@us.ibm.com>
Subject: scsi_add_device/scsi_remove_device oops
Date: Thu, 01 Jul 2004 18:29:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40E49E70.9020504@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:52210 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266365AbUGAX3y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2004 19:29:54 -0400
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e4.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id i61NTrvR878746
	for <linux-scsi@vger.kernel.org>; Thu, 1 Jul 2004 19:29:53 -0400
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i61NV2vv109320
	for <linux-scsi@vger.kernel.org>; Thu, 1 Jul 2004 19:31:02 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am experiencing an oops when calling both scsi_add_device and
scsi_remove_device at the same time. Is the API supposed to be able to
handle this? I can patch around the exact oops I encountered, but it
looks like there would be more problems in this code path as well.
If I am not following the API, I can try putting some more intelligence 
in ipr so that I don't try to delete a device that hasn't fully been 
added, but I want to make sure I am fixing this the proper way.

Looking at the backtraces, it looks like slave_configure has already 
been called on the device and we are constructing the classdev and 
trying to destroy it at the same time.

Here are the backtraces:

0xc00000033fecb5c0  0xc000000000043098  .do_page_fault +0x43c
0xc00000033fecb6f0  0xc00000000000ad28  DataAccessSLB_common +0x114
--- Exception: 380:  at .sysfs_hash_and_remove +0x2c
0xc00000033fecb9e0  0xc00000000011bc4c  .sysfs_hash_and_remove +0x2c
0xc00000033fecb9e0  0xc00000000011d644 (lr) .sysfs_remove_link +0x14
0xc00000033fecba70  0xc00000000011d644  .sysfs_remove_link +0x14
0xc00000033fecbaf0  0xc00000000024d978  .class_device_del +0x1ec
0xc00000033fecbba0  0xc00000000024d9d4  .class_device_unregister +0x1c
0xc00000033fecbc30  0xd000000000095818  .scsi_remove_device +0x54
0xc00000033fecbcb0  0xd0000000000e422c  .ipr_worker_thread +0x960
0xc00000033fecbdb0  0xc0000000000746ec  .worker_thread +0x24c
0xc00000033fecbed0  0xc00000000007a584  .kthread +0x17c
0xc00000033fecbf90  0xc000000000017924  .kernel_thread +0x4c

and

0xc0000000028e7330  0xc00000000005841c  .schedule +0xbc
0xc0000000028e7450  0xc00000000005985c  .wait_for_completion +0xec
0xc0000000028e7550  0xd000000000092738  .scsi_wait_req +0x88
0xc0000000028e7600  0xd0000000000574b0  .sd_revalidate_disk +0x160
0xc0000000028e7750  0xd000000000058b6c  .sd_probe +0x238
0xc0000000028e7800  0xc00000000024c060  .bus_match +0x94
0xc0000000028e7890  0xc00000000024c130  .device_attach +0x6c
0xc0000000028e7920  0xc00000000024c2c4  .bus_add_device +0x98
0xc0000000028e79b0  0xc00000000024a710  .device_add +0xd0
0xc0000000028e7a50  0xd0000000000959b8  .scsi_sysfs_add_sdev +0x8c
0xc0000000028e7b00  0xd000000000093c54  .scsi_probe_and_add_lun +0x87c
0xc0000000028e7c00  0xd000000000094adc  .scsi_add_device +0x78
0xc0000000028e7cb0  0xd0000000000e42c0  .ipr_worker_thread +0x9f4
0xc0000000028e7db0  0xc0000000000746ec  .worker_thread +0x24c
0xc0000000028e7ed0  0xc00000000007a584  .kthread +0x17c
0xc0000000028e7f90  0xc000000000017924  .kernel_thread +0x4c


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center


