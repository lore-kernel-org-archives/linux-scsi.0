From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Disabling block layer
Date: Mon, 26 Mar 2007 17:23:08 -0400
Message-ID: <460839BC.9020204@torque.net>
References: <656559.33072.qm@web63001.mail.re1.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53728 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbXCZVYN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Mar 2007 17:24:13 -0400
In-Reply-To: <656559.33072.qm@web63001.mail.re1.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lobo <ntdeveloper2002@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Mark Lobo wrote:
> Hello!
> 
> I had a question about disabling the block layer for SCSI devices. We
> have an embedded device, and it runs 2.4.30. We need to be able to
> support a lot of SCSI devices (in the thousands) for our device, and we
> talk to the devices via SG. We are facing a memory allocation problem
> after discovering a few thousand devices. For every device,  there
> seems to be a lot of memory allocated in the block layer. This memory
> includes cache memory (which IIRC is reclaimable by the kernel memory
> subsystem when it needs it) and also pages that are used for the
> alloc_pages pool.
> 
> 
> 
> My questions were relating to disabling the block layer for the
> devices. We always talk direct passthrough to the storage(except the
> local hard disk),  and do not need the block layer at all. 
> 
> 1. Is there a way to disable the block layer for specific devices?
> 
> 2. If yes, how can that be done, and  are there any gotchas associated with that?

Mark,
Tempting thought that: linux without a block layer.
I think you have no hope in the lk 2.4 series and
even less in the lk 2.6 series.

Now for some thoughts. If you don't need to mount any
SCSI disks, you could build a kernel with sd as a
module and remove/hide sd_mod.o . A more invasive method
would be to modify the sd driver so that it was no
longer interested in SCSI devices whose peripheral
device type was zero (i.e. disks).

On the sg driver side, if lots of sg file descriptors
are open to those thousands of SCSI devices, then
reducing the per fd SG_DEF_RESERVED_SIZE from 32 KB
may help. This could be reduced by editing
include/scsi/sg.h .

Doug Gilbert


