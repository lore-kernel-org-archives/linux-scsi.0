From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [2.6-test] Bug in usb-storage or scsi?
Date: Wed, 10 Sep 2003 12:23:43 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org>
References: <3F5E434D.6080801@unixsol.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:16132 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265170AbTIJQXp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 12:23:45 -0400
In-Reply-To: <3F5E434D.6080801@unixsol.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 10 Sep 2003, Georgi Chorbadzhiyski wrote:

> Alan Stern wrote:
> > 
> > More problems with that stupid MODE-SENSE cache page!  There are so many 
> > USB storage devices that have problems with that -- I wonder if it's worth 
> > the effort to try to continue supporting it?

> > If you want a temporary fix for 2.6.0, you can do this:  Edit the 
> > routine sd_read_cache_type in the file drivers/scsi/sd.c (near line 1100).  
> > Get rid of (or #ifdef out) most of the function; just leave the last few 
> > lines where it does:
> > 
> > 		printk(KERN_ERR "%s: assuming drive cache: write through\n",
> > 		       diskname);
> > 		sdkp->WCE = 0;
> > 		sdkp->RCD = 0;
> > 
> > You might want to change the KERN_ERR to KERN_NOTICE.
> 
> Thanks a lot! That worked fine! Now the device is detected and working.

Is there any feeling about how to handle these ongoing problems with the 
mode-sense cache page?  There doesn't seem to be any general solution that 
can work with all USB storage devices.  Some hang when asked to read the 
entire page; some hang when asked to read just part of the page; some hang 
when asked to read just the page header.

What do the SCSI folk have to say about it?

Alan Stern

