From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Two questions on scsi_device_{get,put}
Date: Mon, 11 Aug 2003 13:37:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030811203734.GB1323@beaverton.ibm.com>
References: <20030808125956.GA13589@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:13232 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S274723AbTHKUdy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 16:33:54 -0400
Content-Disposition: inline
In-Reply-To: <20030808125956.GA13589@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Please excuse the delay in reply. I was on vacation and I am just
catching up.

Christoph Hellwig [hch@lst.de] wrote:
> I'm trying to forward-port my locking infrastructure for
> shost->my_devices to the current scsi tree.  As this list is
> acquired from irq context we need these locks to be spinlocks,
> but for that to work scsi_device_get/scsi_device_put must not
> block.
> 

my_devices should be redundant now with shost_gendev.children. Will we
not have consistency issues with LDM managing a list with r/w sema and
my_devices being managed with spinlocks.

> But after your changes it's using the class r/w semaphore for
> synchronisation.  What it this protecting except sdev->access_count?

Yes, access_count is what is being protected. The r/w semaphore could be
changed to spinlock protection if needed.

> Also what's the reason we can't do the device_del directly but have
> to do it in scsi_device_put?

When we converted the upper level drivers to the driver model the probe
/ remove routines get called in response to device_add and device_delete
calls respectively. 

The problem I ran into was in sd_remove when we call del_gendisk.
del_gendisk calls delete_partition which is bad if we are still using
the block device.

I think maybe the gendisk kobject should have a release function, but
that would touch quite a few files and I had not discussed this with Al /
others.

> 
> A final nitpick:  you're losing a module refernece for some failure
> pathes of scsi_module_get.

By scsi_module_get do you mean try_module_get on the host module? I see
that I have a ref leak on failure of get_device in scsi_device_get.

-andmike
--
Michael Anderson
andmike@us.ibm.com

