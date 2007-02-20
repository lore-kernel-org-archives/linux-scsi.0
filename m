From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SG: cap reserved_size values at max_sectors
Date: Tue, 20 Feb 2007 14:44:38 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0702201438330.2521-100000@iolanthe.rowland.org>
References: <45DB4CA7.5090007@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46719 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030369AbXBTTol (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Feb 2007 14:44:41 -0500
In-Reply-To: <45DB4CA7.5090007@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@SteelEye.com>, Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, Jens Axboe <jens.axboe@oracle.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 20 Feb 2007, Mike Christie wrote:

> Yeah you are right getting memory is not a problem I replied about that
> in the other mail. You do not have to use it, but the min of the
> reserved buffer and max_sectors or max_hw_sectors could still be off for
> drivers that do not support clustering or if there is a weird arch
> segment boundary or limit (maybe the arch segment limits and boundary is
> not used much though).
> 
> I am working on fix to both the hack and make sure the reserved buffer
> is actually a size that the driver can handle. It is those patches that
> converts sg to use the scatterlist and request helpers and modify the
> sg.c code to allocate the reserved buffer within all the system, driver
> and hw limits.
> 
> If you are pushing your fixes for the current release, I would say do
> not wait for me, but I am also saying max_sectors and the reserved
> buffer size is not always a correct estimate for a couple reasons.

Okay, I'll stand by the original patch for now.  At least it will allow 
cdrecord to work correctly with USB devices.

It is true that many other factors come into play.  In the end, we need a 
way to tell userspace how large a transfer length will work reliably.  It 
should be available to all devices and drivers that export any sort of raw 
I/O interface -- including sg and the block layer's SG_IO interface.

Alan Stern

