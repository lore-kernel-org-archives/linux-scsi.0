From: minemoto <minemoto@soft.fujitsu.com>
Subject: [kernel 2.6.21.5] The panic occurs if lun is done in scan while processing Devloss timeout.
Date: Thu, 21 Jun 2007 18:37:06 +0900
Message-ID: <20070621093637.92F171C007@mail2-sv.soft.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38287 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbXFUJgk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jun 2007 05:36:40 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id l5L9acFI031776
	for <linux-scsi@vger.kernel.org> (envelope-from minemoto@soft.fujitsu.com);
	Thu, 21 Jun 2007 18:36:38 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 8FB7A53C11D
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2007 18:36:38 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 6A9A62400A3
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2007 18:36:38 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1 [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 56677133C01E
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2007 18:36:38 +0900 (JST)
Received: from mail2-sv.soft.fujitsu.com (smtp.soft.fujitsu.com [10.124.20.53])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id E170D133C018
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2007 18:36:37 +0900 (JST)
Received: from mail2-sv.soft.fujitsu.com (mail2-sv [127.0.0.1])
	by localhost.soft.fujitsu.com (Postfix) with ESMTP id B5A371C009
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2007 18:36:37 +0900 (JST)
Received: from smtp.soft.fujitsu.com (unknown [10.124.100.246])
	by mail2-sv.soft.fujitsu.com (Postfix) with SMTP id 92F171C007
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2007 18:36:37 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello!

We are using linux-2.6.21.5 .

When [echo "- - - " > scan] is executed before Devloss timeout is generated
after unplug the Fibre Channel cable connected to the HBA, the system panic occurs.

Panic can be reproduced by 100%.
Qla is generated though it tested with lpfc this time. The phenomenon doesn't
 depend on the HBA driver. 

lpfc 0000:01:0a.0: 0:1305 Link Down Event x2 receiv
ed Data: x2 x20 x0
 rport-3:0-0: blocked FC remote port time out: removing target and saving binding
lpfc 0000:01:0a.0: 0:0203 Devloss timeout on WWPN 21:0:0:e0:0:41:a:cd NPort xef 
Data: x8 x7 x1
BUG: unable to handle kernel paging request at virtual address 750001e9
 printing eip:
e0867c74
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in: autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 ib_iser rdma_
cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi scsi_transport_is
csi dm_mirror dm_multipath dm_mod video sbs i2c_ec button battery asus_acpi ac l
p floppy sg pcspkr i2c_piix4 i2c_core tg3 parport_pc parport ide_cd cdrom serio_
raw lpfc scsi_transport_fc megaraid_mbox megaraid_mm aic79xx scsi_transport_spi 
sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
CPU:    0
EIP:    0060:[<e0867c74>]    Not tainted VLI
EFLAGS: 00010206   (2.6.21.5 #1)
EIP is at scsi_is_host_device+0x0/0x11 [scsi_mod]
eax: 7500007d   ebx: dfde4698   ecx: 00000000   edx: 00000001
esi: 7500007d   edi: ffffffff   ebp: dfde46e0   esp: d6f9de8c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process bash (pid: 8307, ti=d6f9d000 task=c96c9a90 task.ti=d6f9d000)
Stack: e086e7a7 ffffffff 00000001 00000001 ffffffff 00000000 00000001 dfde4698 
       ffffffff ffffffff df468000 e084be06 ffffffff 00000001 dfde46e0 df468000 
       e084bdae d6f9defb df46825c e086f01c ffffffff e0879289 d6f9df19 d6f9df0a 
Call Trace:
 [<e086e7a7>] scsi_scan_target+0x37/0xc0 [scsi_mod]
 [<e084be06>] fc_user_scan+0x58/0x81 [scsi_transport_fc]
 [<e084bdae>] fc_user_scan+0x0/0x81 [scsi_transport_fc]
 [<e086f01c>] store_scan+0x95/0xc0 [scsi_mod]
 [<c0457480>] __alloc_pages+0x59/0x29b
 [<c0460d0b>] vma_merge+0x168/0x178
 [<e086ef87>] store_scan+0x0/0xc0 [scsi_mod]
 [<c054c33b>] class_device_attr_store+0x1b/0x1f
 [<c04a497b>] sysfs_write_file+0xae/0xd8
 [<c04a48cd>] sysfs_write_file+0x0/0xd8
 [<c046ee75>] vfs_write+0xa8/0x12a
 [<c046f402>] sys_write+0x41/0x67
 [<c0404db8>] syscall_call+0x7/0xb
 =======================
Code: 12 8b 43 40 3b 86 8c 01 00 00 75 07 8b 14 24 89 d8 ff d5 89 da 89 f8 e8 65
 f5 ff ff 85 c0 89 c3 75 d4 5b 5b 5e 5f 5d c3 90 90 90 <81> b8 6c 01 00 00 fb 7c
 86 e0 0f 94 c0 0f b6 c0 c3 83 ec 08 89 
EIP: [<e0867c74>] scsi_is_host_device+0x0/0x11 [scsi_mod] SS:ESP 0068:d6f9de8c
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..


The procedure to panic is as follows.

 1.Connect FC disk to server with FC HBA.
 2.Confirm lun can be recognized.
 3.Unplug FC cable from HBA.
 4.Type "echo '- - -' > /sys/class/scsi_host/host<host no>/scan" before devloss-timeout
 is generated.
 5. When devloss-timeout is generated, the system does the panic. 

The panic occurs by following sequence from our investigation.

 1.Link Down Event
 2.fc_remote_port_delete()
 3.fc_user_scan()
 4.fc_timeout_deleted_rport()
 5.fc_user_scan()
 6.panic

First of all, when linkdown is occured, fc_remote_port_delete() is called. 
When [echo "- - - " > scan] is executed, fc_user_scan() is called at this time,
this command response doesn't return until the processing of devloss timeout
is completed because of linkdown. 

When devloss timeout is detected, fc_timeout_deleted_rport() 
is called, and rport is deleted here.
Then the response returns to fc_user_scan().
However, there is some inconsistency with rport because it already 
starts continuing processing with original rport in fc_user_scan().
I guess this causes panic.


I am not on this mailing list, please cc to me.
to : minemoto@soft.fujitsu.com

Best regards,
Shintaro minemoto



