From: Luben Tuikov <luben@splentec.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Wed, 22 Jan 2003 16:50:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2F1213.8090400@splentec.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.name>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> Here's another question to add to your discussion.
> 
> When a device is unplugged, the system's representation of that device
> can't be removed immediately; there may be open fd's, mounts, pointers,
> and so on.  Until the time comes when all these handles are released, all
> interaction with the device has to fail, one way or another.
> 
> Whose responsibility is it to fail these interactions?

The transport.

When a device is plugged to the SAN/fabric (wlg) it may not be the case
that all initiators will know about it.  For this reason the transport
itself, not SCSI Core, not LLDD*, will decide if the CDB is deliverable.

* An LLDD may keep a table of seen devices (depending on the transport
it provides a portal to), and thus the decision may be made there, but
this doesn't have to be the case.

(Just think of SANs/IP SANs.)

> For something simple, like a USB serial port, it might turn out that the 
> low-level device driver gets all these requests and then fails them.  That 
> means the driver has to keep track of the fact that the device is no 
> longer connected until some reference count goes to 0.

A LLDD doesn't have to keep reference counts.  In the simple case
you mention above, it will check that the device is no longer reachable
and will return TARGET error, which will bubble up the layers, or the
Execute Command remote procedure will end with Service Delivery Failure
as the Service Response -- exactly the same effect as far as SCSI Core
is concerned.

The Service Response is Service Delivery Failure, in which case the
Status byte is undefined.

I've been wanting to include a Service Response into scsi_cmnd and
rename ``result'' into ``status'' to be closer to the SCSI Architecure,
for some time now, but we'll see when this will happen.

Newer drivers will make use of Service Response code, and be able to
address only by (target, lun) rather than (bus, target, lun), and
target may not be an int anymore.  But this is 2.7 stuff, or maybe
a separately distributed SCSI Core and LLDDs subsystem...

> For SCSI and emulated SCSI devices, it might be the one of the SCSI layers 
> that keeps track of the fact that the device has disconnected.  Or it 
> might be somewhere else in the kernel.

Right.  For this reason I'm thinking that a higher level hook on device
disconnect (if reported by the transport) might be needed.  This doesn't
mean that it has to do higher-level things, :-) , it might just call
SCSI Core, but as long as it goes through a higher layer.

> It would nice to have some sort of coherent plan for how to handle this.  
> In fact, it ought to be part of the device-driver model that underlies 
> sysfs.  But so far as I am aware, there is currently nothing in the sysfs 
> documentation to address the problem.

-- 
Luben



