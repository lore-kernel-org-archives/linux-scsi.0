From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Tue, 11 Nov 2003 17:36:22 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031111173622.A12435@infradead.org>
References: <20031027153932.A16679@infradead.org> <018b01c39e1f$e013bab0$a0074d0a@apac.cisco.com> <20031029134557.A17523@infradead.org> <03111117263601.01918@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:18185 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263598AbTKKRgX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2003 12:36:23 -0500
Content-Disposition: inline
In-Reply-To: <03111117263601.01918@naveenb-lnx.cisco.com>; from naveenb@cisco.com on Tue, Nov 11, 2003 at 05:26:36PM +0530
List-Id: linux-scsi@vger.kernel.org
To: Naveen Burmi <naveenb@cisco.com>
Cc: linux-scsi@vger.kernel.org, davmyers@cisco.com

On Tue, Nov 11, 2003 at 05:26:36PM +0530, Naveen Burmi wrote:
> During shutdown iSCSI driver gets signal to stop itself. In turn iSCSI driver 
> umounts all the partitions present of iSCSI disks, makes all the iSCSI disks 
> unavailble to the system and gracefully terminate. 
> But if iSCSI disk contains the root partition OR is part of root partition 
> then iSCSI driver must not try to umount the root partition and the iSCSI 
> disks must be available until the buffer cache gets flushed properly. For 
> this to happen iSCSI driver must be aware of all the iSCSI disk(s) that 
> constitute the root partition/devices.

I think you'd rather want a reboot notifier for after the final sync..

> 	Q. What kernel data structures/API's are available that provide the 
> information about root device(s)?

there is no such information.  you can only know the root device of a
particular process and that information is not available to drivers.

> > that instead of creating such bogus hacks.  A driver has no business
> > dealing with the network configuration.
> 
> During shutdown iSCSI driver must bring up the network interface, if it goes 
> down, so to make available the iSCSI disk(s) on which the root partition 
> exists. iscsi_set_if_addr is used to bring up the newtwork interface at the 
> time of shutdown. 

you don't need to shut down interfaces on system shutdown.

> Q. Is ip autoconfig code helps us to bring up the newtwork interface at the 
> time of shutdown?

no.

