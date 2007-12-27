From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/5] sg_ring for scsi
Date: Thu, 27 Dec 2007 11:09:27 +0900
Message-ID: <20071227110927Q.fujita.tomonori@lab.ntt.co.jp>
References: <200712211426.47896.rusty@rustcorp.com.au>
	<20071221133746B.fujita.tomonori@lab.ntt.co.jp>
	<200712261127.41088.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:34314 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbXL0CLI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Dec 2007 21:11:08 -0500
In-Reply-To: <200712261127.41088.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rusty@rustcorp.com.au
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net

On Wed, 26 Dec 2007 11:27:40 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Friday 21 December 2007 15:37:46 FUJITA Tomonori wrote:
> > Some scsi drivers like ips access to sglist in a tricky way.
> 
> Indeed.  I fail to see how this code works, in fact:
> 
> drivers/scsi/ips.c:ips_queue() line 1101
> 
> 	if (ips_is_passthru(SC)) {
> 
> 		ips_copp_wait_item_t *scratch;
> 
> 		/* A Reset IOCTL is only sent by the boot CD in extreme cases.           */
> 		/* There can never be any system activity ( network or disk ), but check */
> 		/* anyway just as a good practice.                                       */
> 		pt = (ips_passthru_t *) scsi_sglist(SC);
> 		if ((pt->CoppCP.cmd.reset.op_code == IPS_CMD_RESET_CHANNEL) &&
> 		    (pt->CoppCP.cmd.reset.adapter_flag == 1)) {
> 
> Casting the scsi_sglist(SC) (which ips_is_passthrough treated as a
> scatterlist) to an ips_passthrough_t seems completely bogus.  It looks like
> it wants to access the region mapped by the scatterlist.

Yeah, it seems to be broken.

> There are many signs through the code that it needs a great deal of
> work: what is the purpose of sg_break? Why does the code check if kmap_atomic
> fails?

sg_break is a workaround for the hardware restrictions, I think.


> ===
> Convert the ips SCSI driver to sg_ring.
> 
> Slightly non-trivial conversion, will need testing.

As I said, I don't think that converting SCSI drivers to sg_ring (with
lots of non-trivial work) provides any benefits. Surely, sg_ring
enables us to modify sg lists but SCSI drivers don't need the
feature. What SCSI drivers needs is just a efficient way to get the
next sg entry (they use 'sg++' in the past and sg_next now).
