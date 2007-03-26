From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Disabling block layer
Date: Mon, 26 Mar 2007 16:35:57 -0500
Message-ID: <1174944957.3549.63.camel@mulgrave.il.steeleye.com>
References: <656559.33072.qm@web63001.mail.re1.yahoo.com>
	 <460839BC.9020204@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:51209 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932808AbXCZVgD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Mar 2007 17:36:03 -0400
In-Reply-To: <460839BC.9020204@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Mark Lobo <ntdeveloper2002@yahoo.com>, linux-scsi@vger.kernel.org

On Mon, 2007-03-26 at 17:23 -0400, Douglas Gilbert wrote:
> Mark Lobo wrote:
> > I had a question about disabling the block layer for SCSI devices. We
> > have an embedded device, and it runs 2.4.30. We need to be able to
> > support a lot of SCSI devices (in the thousands) for our device, and we
> > talk to the devices via SG. We are facing a memory allocation problem
> > after discovering a few thousand devices. For every device,  there
> > seems to be a lot of memory allocated in the block layer. This memory
> > includes cache memory (which IIRC is reclaimable by the kernel memory
> > subsystem when it needs it) and also pages that are used for the
> > alloc_pages pool.
> > 
> > 
> > 
> > My questions were relating to disabling the block layer for the
> > devices. We always talk direct passthrough to the storage(except the
> > local hard disk),  and do not need the block layer at all. 
> > 
> > 1. Is there a way to disable the block layer for specific devices?
> > 
> > 2. If yes, how can that be done, and  are there any gotchas associated with that?
> 
> Mark,
> Tempting thought that: linux without a block layer.
> I think you have no hope in the lk 2.4 series and
> even less in the lk 2.6 series.
> 
> Now for some thoughts. If you don't need to mount any
> SCSI disks, you could build a kernel with sd as a
> module and remove/hide sd_mod.o . A more invasive method
> would be to modify the sd driver so that it was no
> longer interested in SCSI devices whose peripheral
> device type was zero (i.e. disks).
> 
> On the sg driver side, if lots of sg file descriptors
> are open to those thousands of SCSI devices, then
> reducing the per fd SG_DEF_RESERVED_SIZE from 32 KB
> may help. This could be reduced by editing
> include/scsi/sg.h .

If it's just a question of tearing down all the resources for a given
device, wasn't 

scsi remove-single-device <h> <c> <t> <L> > /proc/scsi/scsi

The accepted way of doing it, even in 2.4?

James


