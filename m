From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: Suggestions for determining if device currently in-use
Date: Tue, 23 Dec 2003 09:07:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <C2CB6D8BA015124783C0EB9B33D24FFD047D50@otcexc01.otc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:41382 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S265144AbTLWOHa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2003 09:07:30 -0500
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>, 'SCSI development list' <linux-scsi@vger.kernel.org>
Cc: 'Mark Haverkamp' <markh@osdl.org>

Christoph, in the past you indicated that access_count would drop away, as
it has.

The RAID drivers are capable of changing the devices geometry and status
live, and as such we need to protect against actions associated with those
changes when devices are mounted, in error recovery, or in-use by some form
of direct access applications.

The new internal structure member (sd.c) `openers' replaces that
functionality, but is not accessible externally.

What is the recommended means to determine if the device is in-use or
in-error-recovery?

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Christoph Hellwig
Sent: Thursday, December 11, 2003 6:39 AM
To: Alan Stern; SCSI development list
Subject: Re: Suggestion for aiding debugging of host removal

On Wed, Dec 10, 2003 at 11:48:28PM -0800, Mike Anderson wrote:
> > > I've got a question about host removal.  Once scsi_remove_host() has
> > > returned, the host driver's module is free to unload from memory
(assuming
> > > the module's reference count is 0, which it normally is).  Hence it is
a
> > > mistake to access the host template in any way after that time.
> 
> Normally it would not be zero on the return from scsi_remove_host. It
> would not go to zero until scsi_host_put is called. If the scsi_host_put
> is the last ref then prior to the returning of the scsi_host_put
> scsi_host_dev_release would have been called. If it is not then there
> must of been a open on a device outstanding (which would keep a rmmod
> from being called, but would allow hotplug and unexpectged disconnects).

An opened sysfs file won't stop the unload.  Only if we still have
a scsi_device still referencing the host.

> > I'll see whether I can come up with a fix.
> 
> Unless I missing something I do not see any interlock / wait in
free_netdev
> (in looking at test11).

Sorry, it's actually unregister_nedevice (throuch netdev_run_todo and
netdev_wait_allrefs).

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
