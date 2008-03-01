From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: oops in ibmvstgt, in __scsi_alloc_queue
Date: Sat, 1 Mar 2008 15:43:38 +0900
Message-ID: <20080301154342O.tomof@acm.org>
References: <20080229155825.GA25293@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:32982 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbYCAGnr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Mar 2008 01:43:47 -0500
In-Reply-To: <20080229155825.GA25293@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olh@suse.de
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Fri, 29 Feb 2008 16:58:25 +0100
Olaf Hering <olh@suse.de> wrote:

> 
> loading ibmvstgt in 2.6.25-rc3 gives the oops below.
> loading it in 2.6.24 works.
> This is an 8 cpu pseries IBM,9133-55A, 6gb ram, firmware SF235_185.
> 
> ....
> IBM eServer i/pSeries Virtual SCSI Target Driver
> vio_register_driver: driver ibmvscsis registering
> Unable to handle kernel paging request for data at address 0x000001c0
> Faulting instruction address: 0xd00000000009ed80
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=128 NUMA pSeries
> Modules linked in: ibmvstgt(+) ses(+) e1000(+) enclosure libsrp scsi_transport_srp scsi_tgt sg sd_mod pata_pdc2027x ipr libata scsi_mod firmware_class
> NIP: d00000000009ed80 LR: d00000000009ed7c CTR: c000000000219874
> REGS: c00000017c397270 TRAP: 0300   Tainted: G        N  (2.6.25-rc3-20080228160715-ppc64)
> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24022484  XER: 00000010
> DAR: 00000000000001c0, DSISR: 0000000040000000
> TASK = c00000017c84aa60[660] 'modprobe' THREAD: c00000017c394000 CPU: 6
> GPR00: d00000000009ed7c c00000017c3974f0 d0000000000daff8 c00000017c7a4810 
> GPR04: 00000000ffffffff 0000000000000000 c00000017cd7b200 c0000000006a9228 
> GPR08: 0000000000000002 c00000000085d300 0000000000000071 c000000000219874 
> GPR12: d0000000000a84e0 c0000000006c0f00 d00000000011ee70 d000000000145d50 
> GPR16: c00000017c397cc0 000000000000008f 0000000000000007 d00000000011e670 
> GPR20: 0000000000000000 0000000000000124 000000000000001e d000000000117000 
> GPR24: c00000017cdfbdf8 c00000017cdfb000 c00000017c5f5c00 d000000000145b78 
> GPR28: 0000000000000000 c00000017cdfb000 d0000000000d90b8 c00000017c7a4810 
> NIP [d00000000009ed80] .__scsi_alloc_queue+0xa4/0x130 [scsi_mod]
> LR [d00000000009ed7c] .__scsi_alloc_queue+0xa0/0x130 [scsi_mod]

Thanks for report.

Can you try the following patchset?

http://marc.info/?l=linux-scsi&m=120435349330391&w=2


It fixes the problem for me.
