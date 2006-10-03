From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: list debugging BUG() hit by aic94xx
Date: Tue, 03 Oct 2006 13:56:43 -0500
Message-ID: <1159901803.3443.47.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:10409 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030362AbWJCS4p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Oct 2006 14:56:45 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k93Iui528638
	for <linux-scsi@vger.kernel.org>; Tue, 3 Oct 2006 14:56:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

If someone is bored, they can take a look at this list debug error:

list_add corruption. prev->next should be dfa0b788, but was f795fd50
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:31!
invalid opcode: 0000 [#1]
SMP 
Modules linked in: aic94xx libsas firmware_class scsi_transport_sas sd_mod scsi_transport_spi scsi_mod
CPU:    0
EIP:    0060:[<c01df32e>]    Not tainted VLI
EFLAGS: 00010286   (2.6.18 #14)
EIP is at __list_add+0x6e/0x80
eax: 00000048   ebx: dfa0b788   ecx: 00000003   edx: 00000008
esi: f7929bb8   edi: dfaa2888   ebp: dfeabeec   esp: dfeabed4
ds: 007b   es: 007b   ss: 0068
Process scsi_wq_0 (pid: 872, ti=dfeaa000 task=dfe60030 task.ti=dfeaa000)
Stack: c030a7b8 dfa0b788 f795fd50 dfa0b76c dfaa2864 00000000 dfeabf30 f884458d 
       dfaa2888 f7929bb8 dfa0b788 00000001 c0114da0 dfaefd24 dfa2c2f0 dfa088f4 
       00000286 dfa08ae4 dfa0b7ec dfaa2864 dfa0b6b8 dfa0b6bc dfaefd24 dfeabf64 
Call Trace:
 [<f884458d>] sas_discover_domain+0x2ed/0x4c0 [libsas]
 [<c012d3bf>] run_workqueue+0x7f/0x100
 [<c012dca8>] worker_thread+0x148/0x170
 [<c0130c2d>] kthread+0xfd/0x110
 [<c0103e33>] kernel_thread_helper+0x7/0x14
 =======================
Code: 08 c7 04 24 78 a7 30 c0 e8 c0 e1 f3 ff 0f 0b 1a 00 77 a2 30 c0 eb c5 89 5c 24 04 89 44 24 08 c7 04 24 b8 a7 30 c0 e8 a2 e1 f3 ff <0f> 0b 1f 00 77 a2 30 c0 eb ad 90 8d b4 26 00 00 00 00 55 89 e5 
EIP: [<c01df32e>] __list_add+0x6e/0x80 SS:ESP 0068:dfeabed4

This seems to be coming from the

	list_add_tail(&dev->dev_list_node, &port->dev_list);

in sas_get_port_device()

James


