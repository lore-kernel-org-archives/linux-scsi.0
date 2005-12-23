From: Dave Jones <davej@redhat.com>
Subject: scsi_run_queue oops
Date: Fri, 23 Dec 2005 15:12:27 -0500
Message-ID: <20051223201227.GA7020@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50074 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1161033AbVLWUMg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 15:12:36 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11/8.12.11) with ESMTP id jBNKCTvL027787
	for <linux-scsi@vger.kernel.org>; Fri, 23 Dec 2005 15:12:29 -0500
Received: from devserv.devel.redhat.com (devserv.devel.redhat.com [172.16.58.1])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id jBNKCT121384
	for <linux-scsi@vger.kernel.org>; Fri, 23 Dec 2005 15:12:29 -0500
Received: from nwo.kernelslacker.org (vpn83-121.boston.redhat.com [172.16.83.121])
	by devserv.devel.redhat.com (8.12.11/8.12.11) with ESMTP id jBNKCSfA020813
	for <linux-scsi@vger.kernel.org>; Fri, 23 Dec 2005 15:12:29 -0500
Received: from nwo.kernelslacker.org (localhost.localdomain [127.0.0.1])
	by nwo.kernelslacker.org (8.13.5/8.13.4) with ESMTP id jBNKCSII021276
	for <linux-scsi@vger.kernel.org>; Fri, 23 Dec 2005 15:12:28 -0500
Received: (from davej@localhost)
	by nwo.kernelslacker.org (8.13.5/8.13.5/Submit) id jBNKCRjK021275
	for linux-scsi@vger.kernel.org; Fri, 23 Dec 2005 15:12:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I got a report from a user who periodically sees
an oops in this function in our 2.6.14.3 based update.

Does this look familiar to anyone?

Unable to handle kernel NULL pointer dereference
  printing eip:
*pde = 00426001
Oops: 0000 [#1]
SMP
Modules linked in: sata_nv libata scsi_mod e1000 nfs lockd nfs_acl sunrpc
CPU:    0
EIP:    0060:[<e09528e6>]    Not tainted VLI
EFLAGS: 00010286   (2.6.14-1.1644_FC4smp)
EIP is at scsi_run_queue+0x10/0xaf [scsi_mod]
eax: 00000000   ebx: dd98007c   ecx: dffef880   edx: 00000001
esi: ddc99e00   edi: 00000246   ebp: dd9071fc   esp: c042af14
ds: 007b   es: 007b   ss: 0068
Process ksoftirqd/0 (pid: 3, threadinfo=c042a000 task=dfc41ab0)
Stack: dd9071fc dd98007c ddc99e00 00000246 dd9071fc e0952a7d ddc99e00 00000000
        00000000 dd98007c e0952e88 00000001 e088260b dcd3a570 c15e3380 dcd3a570
        00000000 00000000 00040000 00000024 dd9071fc 00000000 00000000 00000292
Call Trace:
  [<e0952a7d>] scsi_end_request+0x83/0xb0 [scsi_mod]
  [<e0952e88>] scsi_io_completion+0x29e/0x4d2 [scsi_mod]
  [<e088260b>] e1000_clean_rx_irq+0x95/0x4f1 [e1000]
  [<e094dcb2>] scsi_finish_command+0x82/0xb5 [scsi_mod]
  [<e094db97>] scsi_softirq+0xc0/0x133 [scsi_mod]
  [<c02bdf4e>] net_rx_action+0xb7/0x1bb
  [<c01258c2>] __do_softirq+0x72/0xdc
  [<c0105c43>] do_softirq+0x4b/0x4f
  =======================
  [<c0125ec2>] ksoftirqd+0x9c/0xe8
  [<c0125e26>] ksoftirqd+0x0/0xe8
  [<c0133d89>] kthread+0x93/0x97
  [<c0133cf6>] kthread+0x0/0x97
  [<c0101d5d>] kernel_thread_helper+0x5/0xb
Code: c5 8f df 8b 14 24 8b 42 44 e8 37 b6 9c df 89 44 24 04 89 d8 e8 2e b6 ff ff
eb b1 55 57 56 53 83 ec \
04 89 04 24 8b 80 10 01 00 00 <8b> 38 80 b8 85 01 00 00 00 0f 88 86 00 00 00 8b
47 44 e8 03 b6


The user mentions that the workstation is actually diskless, so I'm
puzzled why we're doing SCSI IO at all, but nevertheless...
I've asked for more info.

		Dave

