From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Mon, 3 Feb 2003 09:17:26 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030203171726.GA1583@beaverton.ibm.com>
References: <20030123213423.GA26415@redhat.com> <200301232339.40892.oliver@neukum.name> <20030123152554.F12788@one-eyed-alien.net> <20030124214831.GA28812@redhat.com> <20030124152540.B27859@one-eyed-alien.net> <20030125000529.GE28812@redhat.com> <20030124164553.C27859@one-eyed-alien.net> <20030125010729.GG28812@redhat.com> <20030202101317.A26796@one-eyed-alien.net> <20030202120628.A28024@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030202120628.A28024@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Sorry Matthew I got side tracked on some issues for the last week. The
scsi_set_device_offline(); function has not been added to any of James
linux-scsi trees. You could add a ifndef in your code until we get the
interface in the tree. 

Would scsi_set_device_offline() do more than sdev->online = 0? It
depends on the state of the device at the calling of the function.

I currently have scsi_set_device_offline() trying to do the following:
	1.) set device offline and mark host in_recovery.
	2.) mark all outstanding commands to be canceled and wake up
	error handler.
	3.) flush the request queue.
	4.) Once device is really offline send hotplug event.

(2) needs some changes in the error handler which are needed in other
cases. This the large part of the change, but it is not directly part of
your request.

(3) need a cleaner way to flush request specials off the queue . It
would also be nice if there was a method to stop the incoming side of the
request queue.

(4) need export of do_hotplug interface or a method to generate a call
to it for an offline event.

I am working on these changes pretty much in order.

Doug suggested a scsi_schedule_host_removal(), but I thought we could
just change scsi_remove_host() to handle this task unless there is a
side effect that all callers would not want???.

-andmike

Matthew Dharm [mdharm-scsi@one-eyed-alien.net] wrote:
> Willem Riede <wrlk@riede.org> suggested to me that I simply set
> sdev->online = 0 for scsi_set_device_offline()
> 
> Any reason that isn't good enough?
> 
> On Sun, Feb 02, 2003 at 10:13:17AM -0800, Matthew Dharm wrote:
> > So, was any of this ever implemented?  As far as I can tell, the required
> > changes were:
> > 
> > (o) addition of scsi_schedule_host_removal() (possibly optional)
> > (o) implementation of scsi_set_device_offline() (possibly optional)
> > (o) change the behavior of the 'hotplug initialization model' to call my
> > release function
> > 
> > Matt
> > > then call the set_scsi_device_offline(), then send back any outstanding
> > > commands via scsi_done(), then possibly call the
> > > scsi_schedule_host_removal() if Mike adds that function.  Then return.  
> > > Don't to anything else.  Take all the remaining code you would normally
> > > run at this point and put it into a function in your source called
> > > usb_release() and in your Scsi_Host_Template struct that you pass to the
> > > scsi layer, init the release pointer with the address of your
> > > usb_release() routine.  That way, the scsi layer can do what it's best at,
> > > taking care of the clean up details we've been talking about, and when
> > > it's all done, it will call your usb_release() routine with a single
> > > argument of the host struct you are wanting released.  At that point, you
> > > can do all the freeing you would have done in that khubd loop (at least I
> > > think that's the context you are doing the freeing from now) and know for
> > > a fact that not only are you freeing everything, but so is the scsi mid
> > > layer.  I think this will solve all the issues you've had, because this
> > > *won't* leak, it won't block your other actions, and it lets the scsi
> > > subsystem clean up properly.


-andmike
--
Michael Anderson
andmike@us.ibm.com

