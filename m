From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: 25 Mar 2003 13:02:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048618939.1790.29.camel@mulgrave>
References: <20030325100704.GC3868@beaverton.ibm.com>
	<1048613872.2070.12.camel@mulgrave>
	<20030325184530.GA1202@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030325184530.GA1202@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-03-25 at 12:45, Mike Anderson wrote:
> Even if we went with a subsystem bus_for_each function I believe you are
> asking for more state as previous discussed on the host offline subject
> to not allow more additions. Correct?

Really, yes.  Once we're notified the host is going away we need to
quiesce it and all its lists (disallow at least addition).

> > This problem can't be unique to SCSI, so I think what we need is
> > something like a device generic function, like bus_for_each_device,
> > except that it's device_for_each_child or something. where we get a
> > properly ref counted and protected list traversal that will work for
> > hotplugging.
> > 
> 
> The bus_for_each solution currently use a rw sema which I thought would
> not be a good choice for these type of operations as there is a
> possibility that we may want to call functions (offline) in interrupt
> context.

Well...I think it's not too much of a stretch to require that additions
to the device list be done only from user context (initial inquiry does
that, as does scsi add/remove-single-device), so a sema can be made OK
here.

> Are you indicating that sema operations would be ok?
> 
> A possible side issue that Mochel can correct me on is that the calling
> function would be restricted some as it cannot call device_register /
> device_unregister as it would block.

Well...I'm not a huge fan of the kernel doing all the work.  I think the
most sensible way forward is to have the kernel trigger an agreed set of
events and have the nicely scriptable user level do the rest.  However,
if you want to do it this way, the function could use the kernel event
thread to do the actual work although it's a bit more overhead.

> If we want to head this direction we may need to alter the relationship
> of children nodes off hosts.

All I think we need to be sure of is that where generic device provides
hotplug usable infrastructure (like refcounting, etc) SCSI makes use of
it.  (Obviously, the more of the generic infrastructure we use, the more
of somebody else's problem it becomes...)

James


