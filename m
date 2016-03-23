From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] cxlflash: Fix regression issue with re-ordering patch
Date: Wed, 23 Mar 2016 16:19:11 -0500
Message-ID: <69D2835D-982E-4292-B636-BC19EC229695@linux.vnet.ibm.com>
References: <1458762572-44316-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1458762626-44386-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:35654 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbcCWVTR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2016 17:19:17 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 23 Mar 2016 15:19:16 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id C805019D8045
	for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2016 15:07:06 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2NLJD3T37093530
	for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2016 14:19:13 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2NLJCGs017839
	for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2016 15:19:12 -0600
In-Reply-To: <1458762626-44386-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@us.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Mar 23, 2016, at 2:50 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> From: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
> 
> While running 'sg_reset -H' back to back the following exception was seen:
> 
> [  735.115695] Faulting instruction address: 0xd0000000098c0864
> cpu 0x0: Vector: 300 (Data Access) at [c000000ffffafa80]
>    pc: d0000000098c0864: cxlflash_async_err_irq+0x84/0x5c0 [cxlflash]
>    lr: c00000000013aed0: handle_irq_event_percpu+0xa0/0x310
>    sp: c000000ffffafd00
>   msr: 9000000000009033
>   dar: 2010000
> dsisr: 40000000
>  current = 0xc000000001510880
>  paca    = 0xc00000000fb80000   softe: 0        irq_happened: 0x01
>    pid   = 0, comm = swapper/0
> 
> Linux version 4.5.0-491-26f710d+
> 
> enter ? for help
> [c000000ffffafe10] c00000000013aed0 handle_irq_event_percpu+0xa0/0x310
> [c000000ffffafed0] c00000000013b1a8 handle_irq_event+0x68/0xc0
> [c000000ffffaff00] c0000000001404ec handle_fasteoi_irq+0xec/0x2a0
> [c000000ffffaff30] c00000000013a084 generic_handle_irq+0x54/0x80
> [c000000ffffaff60] c000000000011130 __do_irq+0x80/0x1d0
> [c000000ffffaff90] c000000000024d40 call_do_irq+0x14/0x24
> [c000000001573a20] c000000000011318 do_IRQ+0x98/0x140
> [c000000001573a70] c000000000002594 hardware_interrupt_common+0x114/0x180
> 
> This exception is being hit because the async_err interrupt path performs
> an MMIO to read the interrupt status register. The MMIO region in this
> case is not available.
> 
> Commit 6ded8b3cbd9a ("cxlflash: Unmap problem state area before detaching
> master context") re-ordered the sequence in which term_mc() and stop_afu()
> are called. This introduces a window for interrupts to come in with the
> problem space area unmapped, that did not exist previously.
> 
> The fix is to separate the disabling of all AFU interrupts to a distinct
> function, term_intr() so that it is the first thing that is done in the
> tear down process.
> 
> To keep the initialization process symmetric, separate the AFU interrupt
> setup also to a distinct function: init_intr().
> 
> Fixes: 6ded8b3cbd9a ("cxlflash: Unmap problem state area before detaching master context")
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

Looks good, thanks for the quick turnaround!

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

