From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Notify about errors during initialization
Date: Tue, 6 Jan 2004 09:15:39 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040106091538.A10957@beaverton.ibm.com>
References: <20040105021047.GD30408@one-eyed-alien.net> <Pine.LNX.4.44L0.0401051659180.604-100000@ida.rowland.org> <20040105221302.A7678@infradead.org> <20040105233221.GC1936@beaverton.ibm.com> <20040106161731.A17858@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:18838 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264574AbUAFRQh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2004 12:16:37 -0500
Content-Disposition: inline
In-Reply-To: <20040106161731.A17858@infradead.org>; from hch@infradead.org on Tue, Jan 06, 2004 at 04:17:31PM +0000
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, Jan 06, 2004 at 04:17:31PM +0000, Christoph Hellwig wrote:

> My idea was that in the brave new hotplug world scsi_scan_host would
> do nothing but simply sending a SCAN hotplug even.  With that design
> we'd have a hard time to find out when the scanning has finished in
> kernelspace.

Why not trigger off the scsi_host hotplug event? Though we will have races
similiar to udev where the sysfs attribute files are created after the
hotplug event - we really ought to have a device_init/setup, create the
sysfs files, then device_add/enable.

For user space scanning, we could special case the USB driver to check
that we find the expected number of targets.

-- Patrick Mansfield
