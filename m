From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11713] New: bugcheck with modprobe -r sym53c8xx
Date: Mon,  6 Oct 2008 15:54:58 -0700 (PDT)
Message-ID: <bug-11713-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbYJFWz3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2008 18:55:29 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m96MswUu020950
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 15:54:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11713

           Summary: bugcheck with modprobe -r sym53c8xx
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.26.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: sym53c8xx
        AssignedTo: scsi_drivers-sym53c8xx@kernel-bugs.osdl.org
        ReportedBy: drescherjm@gmail.com


Latest working kernel version:
?
Earliest failing kernel version:
?
Distribution:
Gentoo
Hardware Environment:
x86_64
Software Environment:
Problem Description:
modprobe -r sym53c8xx 
causes bugcheck.

[  528.044059] sym1: detaching ...
[  528.044059] sym1: resetting chip
[  528.044059] ------------[ cut here ]------------
[  528.044059] WARNING: at arch/x86/kernel/pci-dma.c:488
dma_free_coherent+0x97/0xa0()
[  528.044059] Modules linked in: nfsd exportfs w83627hf hwmon_vid floppy
i2c_amd756 i2c_amd8111 st tg3 e1000 nfs nfs_acl lockd sunrpc sbp2 ohci1394
ieee1394 usbhid ohci_hcd uhci_hcd usb_storage ehci_hcd scsi_transport_fc sx8
qla1280 dmx3191d sym53c8xx(-) scsi_transport_spi gdth BusLogic scsi_wait_scan
[  528.044059] Pid: 6606, comm: modprobe Not tainted 2.6.26.5 #1
[  528.044059]
[  528.044059] Call Trace:
[  528.044059]  [<ffffffff802362c4>] warn_on_slowpath+0x64/0xa0
[  528.044059]  [<ffffffff8022cb13>] __wake_up+0x43/0x70
[  528.044059]  [<ffffffff80211e87>] dma_free_coherent+0x97/0xa0
[  528.044059]  [<ffffffffa0030c01>]
:sym53c8xx:___free_dma_mem_cluster+0x51/0x80
[  528.044059]  [<ffffffffa0030fd3>] :sym53c8xx:__sym_mfree_dma+0x73/0xc0
[  528.044059]  [<ffffffffa0029c55>] :sym53c8xx:sym_hcb_free+0x55/0x1b0
[  528.044059]  [<ffffffffa00276e6>] :sym53c8xx:sym_free_resources+0x46/0x80
[  528.044059]  [<ffffffffa00277bd>] :sym53c8xx:sym_detach+0x9d/0xc0
[  528.044059]  [<ffffffffa0027813>] :sym53c8xx:sym2_remove+0x33/0x60
[  528.044059]  [<ffffffff803d777c>] pci_device_remove+0x2c/0x60
[  528.044059]  [<ffffffff8044df4f>] __device_release_driver+0x6f/0xb0
[  528.044059]  [<ffffffff8044e4e4>] driver_detach+0xb4/0xc0
[  528.044059]  [<ffffffff8044d104>] bus_remove_driver+0x84/0xb0
[  528.044059]  [<ffffffff803d7aa9>] pci_unregister_driver+0x29/0x90
[  528.044059]  [<ffffffffa0031a90>] :sym53c8xx:sym2_exit+0x10/0x20
[  528.044059]  [<ffffffff8025a68d>] sys_delete_module+0x14d/0x210
[  528.044059]  [<ffffffff803c8272>] __up_write+0x22/0x130
[  528.044059]  [<ffffffff8020c2ab>] system_call_after_swapgs+0x7b/0x80
[  528.044059]
[  528.044059] ---[ end trace d40f428fa8728350 ]---
[  528.044059] ------------[ cut here ]------------


dev6 ~ # zgrep -i sym53 /proc/config.gz
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
