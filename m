From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: A different look at block device hotswap in the Linux kernel
Date: Fri, 24 Jan 2003 08:36:25 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D59C@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from talaria.fm.intel.com (talaria.fm.intel.com [10.1.192.39])
	by caduceus.fm.intel.com (8.11.6/8.11.6/d: outer.mc,v 1.51 2002/09/23 20:43:23 dmccart Exp $) with ESMTP id h0OGS6501391
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2003 16:28:06 GMT
Received: from fmsmsxvs042.fm.intel.com (fmsmsxvs042.fm.intel.com [132.233.42.128])
	by talaria.fm.intel.com (8.11.6/8.11.6/d: inner.mc,v 1.28 2003/01/13 19:44:39 dmccart Exp $) with SMTP id h0OGZfH05854
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2003 16:35:41 GMT
List-Id: linux-scsi@vger.kernel.org
To: "'mjacob@feral.com'" <mjacob@feral.com>, David Brownell <david-b@pacbell.net>
Cc: Oliver Neukum <oliver@neukum.name>, Steven Dake <sdake@mvista.com>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

My $.02:

The comparing of a saved device list snapshot with the current device should
be the responsibility of a user-space daemon, provided that the kernel
exposes enough information  to uniquely identify the devices (like serial
numbers, or some other UID if no ser num exists).  

The kernel would assume that the device is new (not the same) unless told so
by a daemon that is watching.  

Andy

-----Original Message-----
From: Matthew Jacob [mailto:mjacob@feral.com] 
Sent: Friday, January 24, 2003 10:26 AM
To: David Brownell
Cc: Oliver Neukum; Steven Dake; Luben Tuikov; Alan Stern; Matthew Dharm;
Mike Anderson; Greg KH; linux-usb-devel@lists.sourceforge.net; Linux SCSI
list
Subject: Re: A different look at block device hotswap in the Linux kernel



> >>...
> >
> >
> > Could this time limit be fixed (or parameterized) known to all LLDDs?
> > This would allow one to try and avoid flooding SCSI with detach/reattach
> > events for the 'same' device.
>
> And what exactly is the "same" device?  And who's keeping history
> about devices that have previously been attached?  And, says the guy
> who's full of questions, didn't Linus want to get rid of such history?

Hrmm. That's a damned good point. I was going to say things like "the
FC HBA driver knows that device XYX left the fabric and now has
returned", but if XYZ left the fabric, why am I keeping track of it
still? Once gone, it's gone. I had convinced myself that if an FC device
(re)appears, it's not up to the HBA to say it's the same (the content
may have been changed even if the container tag is the same).

Hrm.


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
