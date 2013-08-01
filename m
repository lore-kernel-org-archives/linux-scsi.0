From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Ejected Nook (usb mass storage) prevents suspend
Date: Thu, 1 Aug 2013 11:53:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1308011149320.1534-100000@iolanthe.rowland.org>
References: <1375366368.1518.18.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57746 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756022Ab3HAPxM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Aug 2013 11:53:12 -0400
In-Reply-To: <1375366368.1518.18.camel@linux-fkkt.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-usb@vger.kernel.org, Linux PM List <linux-pm@lists.linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, hare@suse.de

On Thu, 1 Aug 2013, Oliver Neukum wrote:

> On Wed, 2013-07-31 at 11:13 -0400, Alan Stern wrote:
> 
> > More importantly, if we already know that the medium is not present or
> > has been changed since it was last used, then there's no reason to call
> > sd_sync_cache() at all.
> 
> Like this?

Yes, I like this a lot better, except I would put the test for 
!sdkp->media_present in sd_suspend_common() -- no need to print the 
"Synchronizing SCSI Cache" message if you're not going to go through 
with it.

What do the SCSI people think?

Alan Stern

