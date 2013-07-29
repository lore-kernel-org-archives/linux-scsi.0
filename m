From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Ejected Nook (usb mass storage) prevents suspend
Date: Mon, 29 Jul 2013 10:21:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1307291016220.1479-100000@iolanthe.rowland.org>
References: <1375077981.25230.5.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37239 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752499Ab3G2OVO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jul 2013 10:21:14 -0400
In-Reply-To: <1375077981.25230.5.camel@linux-fkkt.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-usb@vger.kernel.org, Linux PM List <linux-pm@lists.linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, hare@suse.de

On Mon, 29 Jul 2013, Oliver Neukum wrote:

> On Fri, 2013-07-26 at 16:31 -0400, Alan Stern wrote:
> 
> > In addition to my earlier comment, the patch below should be applied.  
> > It will fix your immediate problem, although not in the best way.
> 
> Alan,
> 
> I think your diagnosis is correct, but not the fix.
> This is run even in the runtime case. We might lose
> data if the flush is not done.

Actually no, the scsi_bus_suspend_common() routine does not run during 
runtime PM.  It gets called only from scsi_bus_suspend(), 
scsi_bus_freeze(), and scsi_bus_poweroff(), which are all part of 
system sleep.

Alan Stern

