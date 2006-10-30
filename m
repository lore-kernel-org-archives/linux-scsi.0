From: linas@austin.ibm.com (Linas Vepstas)
Subject: PCI error recovery for the Emulex LPFC
Date: Mon, 30 Oct 2006 16:20:47 -0600
Message-ID: <20061030222047.GN6360@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:45442 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1422699AbWJ3WUw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Oct 2006 17:20:52 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9UMKnjO008268
	for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2006 17:20:49 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9UMKnci329772
	for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2006 15:20:49 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9UMKmOx003894
	for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2006 15:20:49 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org, rlary@us.ibm.com


Hi James,

I recently started fiddling with the emulex lpfc driver
with the idea of adding PCI error recovery support to
the driver.  I'm trying to figure out how to proceed.

Some background: In IBM pSeries, and now newer PCI-E
based systems, things like parity errors, etc. on the 
PCI bus are detected by the PCI bridge chip, which
then freezes all further traffic to the adapter. 
When an error condition is detected, there's a 
handful of callbacks made to the device driver, which
can then try to recover from the error, and move 
forward.  

When io is frozen, mmio reads return all 0xffff's ...
I injected an error on the lpfc, and the (so far, 
completely unmodified) driver promptly crashed on me:

0:mon> excp
cpu 0x0: Vector: 300 (Data Access) at [c0000003fbed3890]
    pc: d000000000aa23c0: .lpfc_dev_loss_tmo_callbk+0x68/0x238 [lpfc]
    lr: c0000000002e9dac: .fc_starget_delete+0x90/0x17c
    sp: c0000003fbed3b10
   msr: 9000000000009032
   dar: 6b6b6b6b6b6b7753
 dsisr: 40000000
  current = 0xc0000003fa4ac7f0
  paca    = 0xc000000000523300
    pid   = 4714, comm = fc_wq_1

0:mon> t
[c0000003fbed3bf0] c0000000002e9dac .fc_starget_delete+0x90/0x17c
[c0000003fbed3c80] c0000000002ebc5c .fc_rport_final_delete+0x80/0x124
[c0000003fbed3d20] c000000000067268 .run_workqueue+0xdc/0x168
[c0000003fbed3dc0] c000000000067d0c .worker_thread+0x140/0x1b0
[c0000003fbed3ee0] c00000000006c24c .kthread+0x124/0x174
[c0000003fbed3f90] c000000000024d20 .kernel_thread+0x4c/0x68

This is on 2.6.19-rc1-git11 -- I'll try to track this down 
further, but thought I'd mention it now. Does sucha crash 
look familiar?

-- Linas Vepstas


