From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] - mptfusion - adding back the spin locks in eh handle
	 rs
Date: Fri, 24 Jun 2005 11:24:04 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C02DD9381@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:13756 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263389AbVFXRY1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2005 13:24:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, linux scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Jeff - I didn't realize that the host-lock spin locks were removed inside
scsi mid layer scsi_error.c code.  I just applied James
scsi-misc-2.6.diff against the 2.6.12 kerne.  Just built this kernel
and tested the fusion driver, and I'm happy.  No problem, ignore yesterdays
patch.

I will have to repost the other two patch's later today; e.g. 
- change_queue_depth API
- FC transport support.

Eric


On Thursday, June 23, 2005 5:18 PM, Jeff Garzik wrote:
> Moore, Eric Dean wrote:
> > Luben
> > 
> > Ok - So you agree that completing Task management request
> > in the same context as the eh threads is the way to go, right?
> > 
> > Because that is what this LLD is doing.  Have you had
> > a chance to look at our code?
> > 
> > That previous patch submitted by Jeff(I guess) was removing 
> code which
> > enabled interrupts.  My patch was restoring it back to previous
> > working code which doesn't hang the driver.
> 
> What was broken?
> 
> MPT abort handler would release the spinlock at the beginning, and 
> reacquire it at the end, essentially reversing the spinlocks 
> in the old 
> spinlocked EH code.
> 

