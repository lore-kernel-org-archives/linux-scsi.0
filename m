From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Tue, 21 Jan 2003 16:02:54 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org>
References: <3E2DA75C.3000800@splentec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E2DA75C.3000800@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Oliver Neukum <oliver@neukum.name>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Here's another question to add to your discussion.

When a device is unplugged, the system's representation of that device
can't be removed immediately; there may be open fd's, mounts, pointers,
and so on.  Until the time comes when all these handles are released, all
interaction with the device has to fail, one way or another.

Whose responsibility is it to fail these interactions?

For something simple, like a USB serial port, it might turn out that the 
low-level device driver gets all these requests and then fails them.  That 
means the driver has to keep track of the fact that the device is no 
longer connected until some reference count goes to 0.

For SCSI and emulated SCSI devices, it might be the one of the SCSI layers 
that keeps track of the fact that the device has disconnected.  Or it 
might be somewhere else in the kernel.

It would nice to have some sort of coherent plan for how to handle this.  
In fact, it ought to be part of the device-driver model that underlies 
sysfs.  But so far as I am aware, there is currently nothing in the sysfs 
documentation to address the problem.

Alan Stern

