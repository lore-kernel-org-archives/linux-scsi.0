From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Suggestion for aiding debugging of host removal
Date: Thu, 11 Dec 2003 11:39:08 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031211113908.A17005@infradead.org>
References: <20030709144410.GA3544@beaverton.ibm.com> <Pine.LNX.4.44L0.0312100947550.775-100000@ida.rowland.org> <20031210151456.A2927@infradead.org> <20031211074827.GA3076@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:36366 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264884AbTLKLjL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2003 06:39:11 -0500
Content-Disposition: inline
In-Reply-To: <20031211074827.GA3076@beaverton.ibm.com>; from andmike@us.ibm.com on Wed, Dec 10, 2003 at 11:48:28PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, Dec 10, 2003 at 11:48:28PM -0800, Mike Anderson wrote:
> > > I've got a question about host removal.  Once scsi_remove_host() has
> > > returned, the host driver's module is free to unload from memory (assuming
> > > the module's reference count is 0, which it normally is).  Hence it is a
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
> Unless I missing something I do not see any interlock / wait in free_netdev
> (in looking at test11).

Sorry, it's actually unregister_nedevice (throuch netdev_run_todo and
netdev_wait_allrefs).

