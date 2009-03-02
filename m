From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Set manage_start_stop for some USB storage devices by
 default
Date: Mon, 2 Mar 2009 14:57:03 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0903021452570.12723-100000@netrider.rowland.org>
References: <20090302195238.GM3741@vespa.holoscopio.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2768 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754967AbZCBT5F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 14:57:05 -0500
In-Reply-To: <20090302195238.GM3741@vespa.holoscopio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2 Mar 2009, Thadeu Lima de Souza Cascardo wrote:

> > Maybe there doesn't need to be a patch for this at all.  Can't you get 
> > the same result by writing a udev rule?  In fact, isn't that how the 
> > manage_start_stop flag is intended to be set?
> 
> I did expect that doing it in user space would be the proper way. Any
> tips on how to find out the USB id's given the disk?

Look in /proc/bus/usb/devices or run lsusb.

> > As for the patch itself...  You are setting the flag in the wrong 
> > place.  The manage_start_stop flag applies only to SCSI disk devices 
> > AFAICT.  (The sysfs interface isn't present if the device isn't a disk, 
> > at any rate.)  So you should set the flag in the code that applies to 
> > disks.
> 
> I thought on adding a quirk flag to the SCSI host and, then, testing
> that in the SCSI code itself. Didn't think SCSI guys would like that.

Even if you keep the quirk in usb-storage, it should still go in the 
appropriate place, somewhat farther down than where you put it.

> > Also, this patch won't apply to the current development tree, because
> > there have been several changes to usb-storage's recently.  In
> > particular there is new code allowing quirk flags to be set by a module
> > parameter, and your new flag (if it is accepted) should be added to
> > this mechanism.
> 
> Also expected. But I didn't know about the new changes in the quirk
> flags code. Which tree should I refer to regarding usb-storage or USB,
> besides next and rc trees?

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/

I tend to use the gregkh-all-*.patch files.  However, I think 
everything in there also goes into -next.

Alan Stern

