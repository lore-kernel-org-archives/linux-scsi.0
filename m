From: wenxiong@linux.vnet.ibm.com
Subject: WARN_ON in ses driver on device remove
Date: Tue, 04 Dec 2012 16:46:07 -0500
Message-ID: <20121204164607.Horde.RnqK95ir309Qvm8fbTN18hA@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:38205 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab2LDVrV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2012 16:47:21 -0500
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Tue, 4 Dec 2012 14:47:21 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 1D0751FF0039
	for <linux-scsi@vger.kernel.org>; Tue,  4 Dec 2012 14:47:13 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qB4LkE1P305392
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2012 14:46:15 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qB4Lk86U008585
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2012 14:46:10 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, ">"@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com

In upstream kernel, we get the warnings when rmmod the ipr module. The  
stack is like this:


sysfs: can not remove 'enclosure_device: P1-D1      1SS6', no directory
------------[ cut here ]------------
WARNING: at fs/sysfs/inode.c:324
Modules linked in: autofs4 sunrpc ipt_REJECT nf_conntrack_ipv4  
nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6  
nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6  
dm_round_robin scsi_dh_alua dm_multipath ibmveth sg ses enclosure ext4  
jbd2 mbcache sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt  
ipr(-) dm_mirror dm_region_hash dm_log dm_mod [last unloaded:  
scsi_wait_scan]
NIP: c00000000026b9b0 LR: c00000000026b9ac CTR: 0000000000000001
REGS: c0000003f2b56de0 TRAP: 0700   Not tainted  (3.4.0-rc7-breno+)
MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28008484  XER: 20000000
SOFTE: 1
CFAR: c000000000618144
TASK = c0000003dafa18f0[12274] 'rmmod' THREAD: c0000003f2b54000 CPU: 0
GPR00: c00000000026b9ac c0000003f2b57060 c000000000edda70 000000000000004e
GPR04: 0000000000000000 ffffffffffffffff 0000000000000001 0000000000080000
GPR08: 000000000001af90 c000000000944008 000000000001af4a 00000000008c0000
GPR12: 0000000022008422 c00000000edd0000 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR24: 0000000000000000 c0000003f2b57db0 0000000000000000 c000000000e060e0
GPR28: 0000000000000000 0000000000000000 c000000000e6f7b8 c0000003ec1782c8
NIP [c00000000026b9b0] .sysfs_hash_and_remove+0xe0/0xf0
LR [c00000000026b9ac] .sysfs_hash_and_remove+0xdc/0xf0
Call Trace:
[c0000003f2b57060] [c00000000026b9ac] .sysfs_hash_and_remove+0xdc/0xf0  
(unreliable)
[c0000003f2b57110] [c00000000026f87c] .sysfs_remove_link+0x2c/0x80
[c0000003f2b57190] [d000000003b503fc]  
.enclosure_remove_links+0x3c/0x70 [enclosure]
[c0000003f2b57260] [d000000003b505a0]  
.enclosure_component_release+0x30/0x60 [enclosure]
[c0000003f2b572f0] [c0000000003d4104] .device_release+0x44/0xd0
[c0000003f2b57370] [c0000000003051a4] .kobject_cleanup+0xc4/0x210
[c0000003f2b57410] [c0000000003d3dbc] .put_device+0x1c/0x30
[c0000003f2b57480] [d000000003b50e0c] .enclosure_unregister+0x7c/0xd0  
[enclosure]
[c0000003f2b57510] [d000000003bb0098]  
.ses_intf_remove_enclosure+0x88/0xb0 [ses]
[c0000003f2b575a0] [c0000000003d59cc] .device_del+0xfc/0x260
[c0000003f2b57640] [c0000000003d5b64] .device_unregister+0x34/0x80
[c0000003f2b576c0] [c00000000040fa34] .__scsi_remove_device+0x114/0x140
[c0000003f2b57750] [c00000000040b2d4] .scsi_forget_host+0x94/0xa0
[c0000003f2b577e0] [c000000000400f38] .scsi_remove_host+0x88/0x190
[c0000003f2b57870] [d0000000028a2b90] .ipr_remove+0x8c/0x1ffc [ipr]
[c0000003f2b57900] [c00000000033b2cc] .pci_device_remove+0x6c/0x130
[c0000003f2b579a0] [c0000000003d92f0] .__device_release_driver+0xa0/0x120
[c0000003f2b57a30] [c0000000003d9498] .driver_detach+0x128/0x150
[c0000003f2b57ad0] [c0000000003d7d04] .bus_remove_driver+0xc4/0x190
[c0000003f2b57b70] [c0000000003da5dc] .driver_unregister+0x8c/0xd0
[c0000003f2b57c00] [c00000000033b6ac] .pci_unregister_driver+0x5c/0x110
[c0000003f2b57ca0] [d0000000028a0f70] .ipr_exit+0x30/0x4c [ipr]
[c0000003f2b57d20] [c0000000000ed86c] .SyS_delete_module+0x1fc/0x310
[c0000003f2b57e30] [c0000000000097dc] syscall_exit+0x0/0x38
Instruction dump:
3860fffe e8010010 eb81ffe0 eba1ffe8 ebc1fff0 ebe1fff8 7c0803a6 4e800020
e87e8008 7ca42b78 483ac761 60000000 <0fe00000> 3860fffe 4bffff94 60000000
---[ end trace 03c61bbebb31df70 ]---
sysfs: can not remove 'device', no directory
------------[ cut here ]------------
WARNING: at fs/sysfs/inode.c:324
Modules linked in: autofs4 sunrpc ipt_REJECT nf_conntrack_ipv4  
nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6  
nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6  
dm_round_robin scsi_dh_alua dm_multipath ibmveth sg ses enclosure ext4  
jbd2 mbcache sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt  
ipr(-) dm_mirror dm_region_hash dm_log dm_mod [last unloaded:  
scsi_wait_scan]
NIP: c00000000026b9b0 LR: c00000000026b9ac CTR: 0000000000000001
REGS: c0000003f2b56de0 TRAP: 0700   Tainted: G        W     (3.4.0-rc7-breno+)
MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 22008484  XER: 20000000
SOFTE: 1
CFAR: c000000000618144
TASK = c0000003dafa18f0[12274] 'rmmod' THREAD: c0000003f2b54000 CPU: 0
GPR00: c00000000026b9ac c0000003f2b57060 c000000000edda70 0000000000000033
GPR04: 0000000000000000 ffffffffffffffff 272c206e00000000 0000000000080000
GPR08: 000000000001bda8 c000000000944008 000000000001bd7d 00000000008c0000
GPR12: 0000000028008484 c00000000edd0000 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR24: 0000000000000000 c0000003f2b57db0 0000000000000000 c000000000e060e0
GPR28: 0000000000000000 0000000000000000 c000000000e6f7b8 c0000003ec1782c8
NIP [c00000000026b9b0] .sysfs_hash_and_remove+0xe0/0xf0
LR [c00000000026b9ac] .sysfs_hash_and_remove+0xdc/0xf0
Call Trace:
[c0000003f2b57060] [c00000000026b9ac] .sysfs_hash_and_remove+0xdc/0xf0  
(unreliable)
[c0000003f2b57110] [c00000000026f87c] .sysfs_remove_link+0x2c/0x80
[c0000003f2b57190] [d000000003b5040c]  
.enclosure_remove_links+0x4c/0x70 [enclosure]
[c0000003f2b57260] [d000000003b505a0]  
.enclosure_component_release+0x30/0x60 [enclosure]
[c0000003f2b572f0] [c0000000003d4104] .device_release+0x44/0xd0
[c0000003f2b57370] [c0000000003051a4] .kobject_cleanup+0xc4/0x210
[c0000003f2b57410] [c0000000003d3dbc] .put_device+0x1c/0x30
[c0000003f2b57480] [d000000003b50e0c] .enclosure_unregister+0x7c/0xd0  
[enclosure]
[c0000003f2b57510] [d000000003bb0098]  
.ses_intf_remove_enclosure+0x88/0xb0 [ses]
[c0000003f2b575a0] [c0000000003d59cc] .device_del+0xfc/0x260
[c0000003f2b57640] [c0000000003d5b64] .device_unregister+0x34/0x80
[c0000003f2b576c0] [c00000000040fa34] .__scsi_remove_device+0x114/0x140
[c0000003f2b57750] [c00000000040b2d4] .scsi_forget_host+0x94/0xa0
[c0000003f2b577e0] [c000000000400f38] .scsi_remove_host+0x88/0x190
[c0000003f2b57870] [d0000000028a2b90] .ipr_remove+0x8c/0x1ffc [ipr]
[c0000003f2b57900] [c00000000033b2cc] .pci_device_remove+0x6c/0x130
[c0000003f2b579a0] [c0000000003d92f0] .__device_release_driver+0xa0/0x120
[c0000003f2b57a30] [c0000000003d9498] .driver_detach+0x128/0x150
[c0000003f2b57ad0] [c0000000003d7d04] .bus_remove_driver+0xc4/0x190
[c0000003f2b57b70] [c0000000003da5dc] .driver_unregister+0x8c/0xd0
[c0000003f2b57c00] [c00000000033b6ac] .pci_unregister_driver+0x5c/0x110
[c0000003f2b57ca0] [d0000000028a0f70] .ipr_exit+0x30/0x4c [ipr]
[c0000003f2b57d20] [c0000000000ed86c] .SyS_delete_module+0x1fc/0x310
[c0000003f2b57e30] [c0000000000097dc] syscall_exit+0x0/0x38
Instruction dump:
3860fffe e8010010 eb81ffe0 eba1ffe8 ebc1fff0 ebe1fff8 7c0803a6 4e800020
e87e8008 7ca42b78 483ac761 60000000 <0fe00000> 3860fffe 4bffff94 60000000
---[ end trace 03c61bbebb31df71 ]---
sysfs: can not remove 'enclosure_device: P1-D2      1SS6', no directory
------------[ cut here ]------------
WARNING: at fs/sysfs/inode.c:324
Modules linked in: autofs4 sunrpc ipt_REJECT nf_conntrack_ipv4  
nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6  
nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6  
dm_round_robin scsi_dh_alua dm_multipath ibmveth sg ses enclosure ext4  
jbd2 mbcache sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt  
ipr(-) dm_mirror dm_region_hash dm_log dm_mod [last unloaded:  
scsi_wait_scan]
NIP: c00000000026b9b0 LR: c00000000026b9ac CTR: 0000000000000001
REGS: c0000003f2b56de0 TRAP: 0700   Tainted: G        W     (3.4.0-rc7-breno+)
MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28008484  XER: 20000000
SOFTE: 1
CFAR: c000000000618144
TASK = c0000003dafa18f0[12274] 'rmmod' THREAD: c0000003f2b54000 CPU: 0
GPR00: c00000000026b9ac c0000003f2b57060 c000000000edda70 000000000000004e
GPR04: 0000000000000000 ffffffffffffffff 0000000000000001 0000000000080000
GPR08: 000000000001cbe6 c000000000944008 000000000001cba0 00000000008c0000
GPR12: 0000000022008422 c00000000edd0000 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR24: 0000000000000000 c0000003f2b57db0 0000000000000000 c000000000e060e0
GPR28: 0000000000000000 0000000000000000 c000000000e6f7b8 c0000003ec178590
NIP [c00000000026b9b0] .sysfs_hash_and_remove+0xe0/0xf0
LR [c00000000026b9ac] .sysfs_hash_and_remove+0xdc/0xf0
Call Trace:
[c0000003f2b57060] [c00000000026b9ac] .sysfs_hash_and_remove+0xdc/0xf0  
(unreliable)
[c0000003f2b57110] [c00000000026f87c] .sysfs_remove_link+0x2c/0x80
[c0000003f2b57190] [d000000003b503fc]  
.enclosure_remove_links+0x3c/0x70 [enclosure]
[c0000003f2b57260] [d000000003b505a0]  
.enclosure_component_release+0x30/0x60 [enclosure]
[c0000003f2b572f0] [c0000000003d4104] .device_release+0x44/0xd0
[c0000003f2b57370] [c0000000003051a4] .kobject_cleanup+0xc4/0x210
[c0000003f2b57410] [c0000000003d3dbc] .put_device+0x1c/0x30
[c0000003f2b57480] [d000000003b50e0c] .enclosure_unregister+0x7c/0xd0  
[enclosure]
[c0000003f2b57510] [d000000003bb0098]  
.ses_intf_remove_enclosure+0x88/0xb0 [ses]
[c0000003f2b575a0] [c0000000003d59cc] .device_del+0xfc/0x260
[c0000003f2b57640] [c0000000003d5b64] .device_unregister+0x34/0x80
[c0000003f2b576c0] [c00000000040fa34] .__scsi_remove_device+0x114/0x140
[c0000003f2b57750] [c00000000040b2d4] .scsi_forget_host+0x94/0xa0
[c0000003f2b577e0] [c000000000400f38] .scsi_remove_host+0x88/0x190
[c0000003f2b57870] [d0000000028a2b90] .ipr_remove+0x8c/0x1ffc [ipr]
[c0000003f2b57900] [c00000000033b2cc] .pci_device_remove+0x6c/0x130
[c0000003f2b579a0] [c0000000003d92f0] .__device_release_driver+0xa0/0x120
[c0000003f2b57a30] [c0000000003d9498] .driver_detach+0x128/0x150
[c0000003f2b57ad0] [c0000000003d7d04] .bus_remove_driver+0xc4/0x190
[c0000003f2b57b70] [c0000000003da5dc] .driver_unregister+0x8c/0xd0
[c0000003f2b57c00] [c00000000033b6ac] .pci_unregister_driver+0x5c/0x110
[c0000003f2b57ca0] [d0000000028a0f70] .ipr_exit+0x30/0x4c [ipr]
[c0000003f2b57d20] [c0000000000ed86c] .SyS_delete_module+0x1fc/0x310
[c0000003f2b57e30] [c0000000000097dc] syscall_exit+0x0/0x38
Instruction dump:

The issue is happened in dual controller environment.  The file which  
is called "enclosure_device: P1-D1   2SS6"
in target disk directory of the secondary adapter links back to the  
enclosure of the primary controller. When we rmmod ipr, we saw the  
above issue.

In upstream new kernel, sysfs_hash_and_remove() adds the "WARN" statement.

if (!dir_sd) {
                 WARN(1, KERN_WARNING "sysfs: can not remove '%s', no  
directory\n",
                         name);
                 return -ENOENT;
         }

old kernel(sles11 sp2) only did "return -ENOENT".

Can we remove "WARN" statement in this routine?

Thanks,
Wendy

