From: Patrick Mochel <mochel@osdl.org>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Tue, 25 Mar 2003 15:04:48 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0303251500470.999-100000@localhost.localdomain>
References: <1048618939.1790.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1048618939.1790.29.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


On 25 Mar 2003, James Bottomley wrote:

> On Tue, 2003-03-25 at 12:45, Mike Anderson wrote:
> > Even if we went with a subsystem bus_for_each function I believe you are
> > asking for more state as previous discussed on the host offline subject
> > to not allow more additions. Correct?
> 
> Really, yes.  Once we're notified the host is going away we need to
> quiesce it and all its lists (disallow at least addition).
> 
> > > This problem can't be unique to SCSI, so I think what we need is
> > > something like a device generic function, like bus_for_each_device,
> > > except that it's device_for_each_child or something. where we get a
> > > properly ref counted and protected list traversal that will work for
> > > hotplugging.

Sure, that's sane. It should be relatively easy to implement. If you don't 
see anything in the next couple of days, bug me. 

> > A possible side issue that Mochel can correct me on is that the calling
> > function would be restricted some as it cannot call device_register /
> > device_unregister as it would block.
> 
> Well...I'm not a huge fan of the kernel doing all the work.  I think the
> most sensible way forward is to have the kernel trigger an agreed set of
> events and have the nicely scriptable user level do the rest.  However,
> if you want to do it this way, the function could use the kernel event
> thread to do the actual work although it's a bit more overhead.

<shameless plug>
I'm not exactly sure what the context is, but maybe it's something that 
could be off-loaded to /sbin/hotplug ?

> > If we want to head this direction we may need to alter the relationship
> > of children nodes off hosts.
> 
> All I think we need to be sure of is that where generic device provides
> hotplug usable infrastructure (like refcounting, etc) SCSI makes use of
> it.  (Obviously, the more of the generic infrastructure we use, the more
> of somebody else's problem it becomes...)

Actually, the more generic infrastructure you use, the more of everybody 
else's problem it becomes, which is better in a sense. ;)


	-pat

