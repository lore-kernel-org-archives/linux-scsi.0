From: Jeremy Linton <JLinton@greshamstorage.com>
Subject: Re: Disabling block layer
Date: Mon, 26 Mar 2007 17:33:25 -0500
Message-ID: <46084A35.6020700@greshamstorage.com>
References: <656559.33072.qm@web63001.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from austin.greshamstorage.com ([216.143.252.250]:2131 "EHLO
	austin.greshamstorage.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933763AbXCZWuR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Mar 2007 18:50:17 -0400
in-reply-to: <656559.33072.qm@web63001.mail.re1.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lobo <ntdeveloper2002@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Mark Lobo wrote:
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
> My questions were relating to disabling the block layer for the
> devices. We always talk direct passthrough to the storage(except the
> local hard disk),  and do not need the block layer at all.

	You may consider something we experimented with here (for
performance 
reasons).. We basically recompiled one of the scsi drivers to call our 
own version of scsi_host_alloc() and then made calls to the 
queuecommand() routine directly. You then allow the kernel probe 
routines to only discover the first target with the local disk. I assume 
you know ahead of time which scsi cards your using in your system. The 
point is that you could just build a heavily modified scsi driver with 
application specific hooks.

	BTW we aren't currently doing this because in the end we got most of

what we needed by writing a driver which replaces sg and bypasses most 
of the kernel without being as invasive. In the long run we may still 
use a modified LLDD since the interfaces we depend on are changing a 
little to fast for our liking and we are not running any system devices 
on the interface cards we need to directly access.

	I'm not sure how you would go about tearing down enough of the
system 
that the device doesn't consume any resources, yet leave enough of it 
around to be accessible. I will be interested to find out what you end 
up doing.






