From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Notify about errors during initialization
Date: Mon, 5 Jan 2004 15:32:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040105233221.GC1936@beaverton.ibm.com>
References: <20040105021047.GD30408@one-eyed-alien.net> <Pine.LNX.4.44L0.0401051659180.604-100000@ida.rowland.org> <20040105221302.A7678@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:22500 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S265849AbUAEX1z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2004 18:27:55 -0500
Content-Disposition: inline
In-Reply-To: <20040105221302.A7678@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Christoph Hellwig [hch@infradead.org] wrote:
> On Mon, Jan 05, 2004 at 05:04:59PM -0500, Alan Stern wrote:
> > James:
> > 
> > Can you or someone else on the SCSI development list answer this question?
> > 
> > When a new host is registered and scanned for devices, are we guaranteed
> > that the scanning procedure will be finished when scsi_scan_host()  
> > returns?
> 
> With the current code the scanning activity has finished when we return.
> But I'm not sure whether we should document that assumption - if we're
> moving to parallel scanning that assumption might soon be void.
> 

It would appear that saying the scan requested by scsi_scan_host is
completed when the function returns would be the expected result. The
LLDD writer should be aware that once scsi_add_host has been called
hotplug events to user space could allow the user space to scan and
delete devices through sysfs making assumptions on devices found or not
found iffy.

> > The reason for asking is so that the usb-storage driver can test whether 
> > any devices were found.  Depressingly often some incompatibility causes 
> > the scan to fail, and when that happens it would be nice to put a 
> > notification in the system log, unregister the host, and generally avoid 
> > loading the driver as though everything was okay.
> 
> Hmm.  maybe we should guarantee that scsi_scan_host will have finished
> and introduce a scsi_scan_host_parallel when we go down that route.  Or
> do it the other way and add a serialized version for usb-storage..

I thought we where moving to not calling a scan api from the LLDD and
using hotplug events. Then user space would define the scan policy it
wanted.

-andmike
--
Michael Anderson
andmike@us.ibm.com

