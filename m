From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 17 Jan 2003 11:55:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301171155.36452.oliver@neukum.name>
References: <10426732153816@kroah.com> <200301170043.36577.oliver@neukum.name> <20030117085047.GB2531@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030117085047.GB2531@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Am Freitag, 17. Januar 2003 09:50 schrieb Mike Anderson:
> Oliver Neukum [oliver@neukum.name] wrote:
> > Am Donnerstag, 16. Januar 2003 21:48 schrieb Mike Anderson:
> > > David Brownell [david-b@pacbell.net] wrote:
> > > > Have any of the SCSI people been looking much at SCSI hotplug on 2.5?
> > > > I attach "/etc/hotplug/scsi.agent" from one of my desktops; all it
> > > > does is make sure the right drivers are loaded, it doesn't have a
> > > > clue yet about whether/how/where to mount disks or do other stuff.
> > >
> > > SCSI has added newer interfaces for host drivers to use that allow
> > > single adds and removes. The api document is located in
> > > /Documentation/scsi/scsi_mid_low_api.txt. I believe it is fairly
> > > current.
> >
> > This is good news in principle.
> > But what use is a function like scsi_remove_host() if it can fail?
> > If a device is gone, it is gone and all the complaining in the world
> > won't alter that.
> > Could you explain how a LLD can ensure that this function will always
> > succeed?
>
> The interface was focused on clean removes. There may be layers above
> the SCSI subsystem using the device that may need user space
> intervention to release. Currently the request_queue exported to the
> block layer is tied to the scsi device and cannot dis-associated.
>
> (NOTE: in looking at this in 2.5.58 it appears that there maybe some
> checks missing in scsi_check_device_busy that would make
> scsi_remove_host succeed more often than it should).

That is simply wrong. Reporting somebody having pulled a plug must
not fail. What are you supposed to do with an error here?

There must be a way for a LLD to report that reliably.
If the answer is, take that lock, call that function, error all pending
requests, release that lock and call that function, it's OK.

But it must work in all cases.

> If the device disappears the host needs to return all IOs in flight with
> an error, and  we need to ensure new ones do not start ( setting the
> device offline and maybe host_self_blocked). This is a start on getting
> the scsi_remove_host to succed.

Could you provide some details?

	Regards
		Oliver

