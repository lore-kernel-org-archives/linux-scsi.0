From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] usb-storage / scsi : new scsi host on each
	plug
Date: 29 Oct 2003 09:53:33 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067442814.1829.21.camel@mulgrave>
References: <Pine.LNX.4.44L0.0310291020430.874-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:11014 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261928AbTJ2PyS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 10:54:18 -0500
In-Reply-To: <Pine.LNX.4.44L0.0310291020430.874-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: martin@lorenz.eu.org, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2003-10-29 at 09:24, Alan Stern wrote:
> > no matter which USB-storage-device I attach (tried CD-ROM, 
> > Flash Card Reader and memory stick) I get a new scsi host
> > every time i plug a device in.
> > 
> > so when changing devices for several times I finally end up
> > with /dev/scsi/host0 to 17 or more (diden't go on)
>
> This is a SCSI issue, not a USB one.  Maybe someone on the 
> SCSI development list can enlighten us.  As far as I can tell, the host 
> number is simply incremented every time a new host, of whatever sort, is 
> added.  The numbers never get reused.

This is really a design feature.  Not reusing hosts gives us time to
clean up the old one before the new one is initialised (and prevents
races where we could be trying to plug in a new host at the same time
we're cleaning up the old one).

In 2.6 udev discovery should ensure these devices come back to the same
name.

James


