From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] usb-storage and Motorola Z6
Date: Wed, 29 Aug 2007 10:07:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0708291005300.2554-100000@iolanthe.rowland.org>
References: <20070828215215.GB20127@kocom.akoenecke.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36413 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751874AbXH2OHX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Aug 2007 10:07:23 -0400
In-Reply-To: <20070828215215.GB20127@kocom.akoenecke.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Koenecke <akoenecke@akoenecke.de>
Cc: USB users list <linux-usb-users@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 28 Aug 2007, Andreas Koenecke wrote:

> * Dienstag, 28. August 2007 um 14:48 (-0600) schrieb Matthew Wilcox:
> > 
> > On Tue, Aug 28, 2007 at 04:45:59PM -0400, Alan Stern wrote:
> > > Can any SCSI experts explain what's going wrong here?
> > 
> > It's the PQ 1 -- the device is telling us that it's not actually there
> > right now.
> 
> Is anything I can try?

You can edit the source code of the SCSI core to make it ignore the PQ 
value.  In the file drivers/scsi/scsi_sysfs.c, find the 
scsi_bus_match() routine and change the last line from:

	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;

to

	return 1;

Alan Stern

