From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 17 Jan 2003 00:50:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030117085047.GB2531@beaverton.ibm.com>
References: <10426732153816@kroah.com> <3E2718A0.5020905@pacbell.net> <20030116204818.GC1137@beaverton.ibm.com> <200301170043.36577.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200301170043.36577.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Oliver Neukum [oliver@neukum.name] wrote:
> Am Donnerstag, 16. Januar 2003 21:48 schrieb Mike Anderson:
> > David Brownell [david-b@pacbell.net] wrote:
> > > Have any of the SCSI people been looking much at SCSI hotplug on 2.5?
> > > I attach "/etc/hotplug/scsi.agent" from one of my desktops; all it
> > > does is make sure the right drivers are loaded, it doesn't have a
> > > clue yet about whether/how/where to mount disks or do other stuff.
> >
> > SCSI has added newer interfaces for host drivers to use that allow
> > single adds and removes. The api document is located in
> > /Documentation/scsi/scsi_mid_low_api.txt. I believe it is fairly
> > current.
> 
> This is good news in principle.
> But what use is a function like scsi_remove_host() if it can fail?
> If a device is gone, it is gone and all the complaining in the world
> won't alter that.
> Could you explain how a LLD can ensure that this function will always
> succeed?

The interface was focused on clean removes. There may be layers above
the SCSI subsystem using the device that may need user space
intervention to release. Currently the request_queue exported to the
block layer is tied to the scsi device and cannot dis-associated.

(NOTE: in looking at this in 2.5.58 it appears that there maybe some
checks missing in scsi_check_device_busy that would make
scsi_remove_host succeed more often than it should).

If the device disappears the host needs to return all IOs in flight with
an error, and  we need to ensure new ones do not start ( setting the
device offline and maybe host_self_blocked). This is a start on getting
the scsi_remove_host to succed.

-andmike
--
Michael Anderson
andmike@us.ibm.com

