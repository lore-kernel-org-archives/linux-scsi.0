From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [0/3] Last 3 patches for bidi support
Date: Thu, 08 Nov 2007 12:13:13 +0900
Message-ID: <20071108121313D.fujita.tomonori@lab.ntt.co.jp>
References: <4730ACAA.2060007@panasas.com>
	<4730B18C.20505@cs.wisc.edu>
	<4730B4A9.80809@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:38026 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbXKHDVr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 22:21:47 -0500
In-Reply-To: <4730B4A9.80809@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, pw@osc.edu, bhalevy@panasas.com

On Tue, 06 Nov 2007 20:38:33 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On Tue, Nov 06 2007 at 20:25 +0200, Mike Christie <michaelc@cs.wisc.edu> wrote:
> > Boaz Harrosh wrote:
> >> [1]
> >> I propose a small change to scsi_tgt_lib.c that will make
> >> tgt completely neutral to the scsi_data_buffer patch. And will
> >> make it all that more ready for bidi, too. TOMO is this OK?
> >>
> >> (Can you do without the GFP_KERNEL allocation flag? It could
> >> make the code a bit more simple)
> >>
> > 
> > GFP_KERNEL is nice for the target layer because it can sleep in that 
> > path you changed and it and does not have the "cannot write out pages 
> > because it may come back to the same device issues" like an initiator does.
> > 
> > If we ever changed to a softirq instead of the work queue then we would 
> > not need the flag since it would have to GFP_ATOMIC, but I am not sure 
> > if we have plans to do that anytime soon.
> 
> Yes I understand that, hence the GFP_KERNEL was kept intact in my patch.
> But I was thinking perhaps it was possible to sleep outside, if
> the return value was BLKPREP_DEFER, the way the block layer sleeps,
> just not in allocation stage.

The block layer is designed to handle that case but target drivers are
not.
