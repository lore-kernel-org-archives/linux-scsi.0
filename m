From: Daniel Drake <dsd@gentoo.org>
Subject: Bootup oops in scsi_run_queue with megaraid-newgen
Date: Fri, 25 Nov 2005 11:52:06 +0000
Message-ID: <4386FAE6.10101@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta09-winn.ispmail.ntl.com ([81.103.221.49]:27428 "EHLO
	mta09-winn.ispmail.ntl.com") by vger.kernel.org with ESMTP
	id S1751453AbVKYLwK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Nov 2005 06:52:10 -0500
Received: from aamta09-winn.ispmail.ntl.com ([81.103.221.35])
          by mta09-winn.ispmail.ntl.com with ESMTP
          id <20051125115208.GVDW8609.mta09-winn.ispmail.ntl.com@aamta09-winn.ispmail.ntl.com>
          for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2005 11:52:08 +0000
Received: from [192.168.1.103] (really [82.17.179.48])
          by aamta09-winn.ispmail.ntl.com with ESMTP
          id <20051125115208.BLCZ1233.aamta09-winn.ispmail.ntl.com@[192.168.1.103]>
          for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2005 11:52:08 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

A Gentoo user has reported he is unable to boot using the megaraid-newgen 
driver, whereas the legacy driver works fine.

This is on kernel 2.6.14.2 on x86-64.

The problem is fixed in 2.6.15-rc2 but I'm curious as to whether anybody knows 
which patch solved this, so that it can be submitted to linux-stable and added 
to Gentoo's kernel releases.

Here is the oops (transcribed from a low quality photo, might include some typos)

scsi0: LSI Logic MegaRAID driver
scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
scsi[0]: scanning scsi channel 1 [Phy 1] for non-raid devices
Unable to handle kernel null pointer dereference at .. RIP : scsi_run_queue+25
Oops: 0000 [1] SMP
CPU 1
Pid: 0, comm: swapper Not tainted
Call Trace:
	<IRQ> scsi_end_request
	scsi_io_completion
	scsi_softirq
	__do_softirq
	call_softirq
	do_softirq
	do_IRQ
	ret_from_intr
	<EOI> flat_scmd_IFI_mask
	default_idle
	cpu_idle
	start_secondary

Any ideas? The original bug is at http://bugs.gentoo.org/show_bug.cgi?id=113463


Thanks,
Daniel
