From: Christoph Hellwig <hch@lst.de>
Subject: Re: Two questions on scsi_device_{get,put}
Date: Tue, 12 Aug 2003 10:43:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030812084333.GA7457@lst.de>
References: <20030808125956.GA13589@lst.de> <20030811203734.GB1323@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:51648 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S275116AbTHLIng (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Aug 2003 04:43:36 -0400
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-6.4) with ESMTP id h7C8hXDC007512
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2003 10:43:34 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.3) id h7C8hXg1007510
	for linux-scsi@vger.kernel.org; Tue, 12 Aug 2003 10:43:33 +0200
Content-Disposition: inline
In-Reply-To: <20030811203734.GB1323@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, Aug 11, 2003 at 01:37:34PM -0700, Mike Anderson wrote:
> my_devices should be redundant now with shost_gendev.children. Will we
> not have consistency issues with LDM managing a list with r/w sema and
> my_devices being managed with spinlocks.

The problem is that we need to access my_devices in IRQ context which
is impossible with the semaphore-protected shost_gendev.children.
Thus I'd prefer to use my_devices over the scsi code for consistency.

> > But after your changes it's using the class r/w semaphore for
> > synchronisation.  What it this protecting except sdev->access_count?
> 
> Yes, access_count is what is being protected. The r/w semaphore could be
> changed to spinlock protection if needed.

or atomic_t.  Or even better killed at all - if we can do the device_del
imediately it's not needed anymore.

> > Also what's the reason we can't do the device_del directly but have
> > to do it in scsi_device_put?
> 
> When we converted the upper level drivers to the driver model the probe
> / remove routines get called in response to device_add and device_delete
> calls respectively. 
> 
> The problem I ran into was in sd_remove when we call del_gendisk.
> del_gendisk calls delete_partition which is bad if we are still using
> the block device.
> 
> I think maybe the gendisk kobject should have a release function, but
> that would touch quite a few files and I had not discussed this with Al /
> others.

That sounds like the way to go.  Care to bring it up on lkml or should I?

> > A final nitpick:  you're losing a module refernece for some failure
> > pathes of scsi_module_get.
> 
> By scsi_module_get do you mean try_module_get on the host module? I see
> that I have a ref leak on failure of get_device in scsi_device_get.

Sorry, I don't have the code in front of me currently.  I'll f'up on
this once I have.

