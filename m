From: Naveen Burmi <naveenb@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Tue, 11 Nov 2003 17:26:36 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03111117263601.01918@naveenb-lnx.cisco.com>
References: <20031027153932.A16679@infradead.org> <018b01c39e1f$e013bab0$a0074d0a@apac.cisco.com> <20031029134557.A17523@infradead.org>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:57139 "EHLO
	sj-iport-2.cisco.com") by vger.kernel.org with ESMTP
	id S263466AbTKKLxD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2003 06:53:03 -0500
In-Reply-To: <20031029134557.A17523@infradead.org>
List-Id: linux-scsi@vger.kernel.org
Cc: 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Wednesday 29 October 2003 07:15 pm, 'Christoph Hellwig' wrote:
> On Wed, Oct 29, 2003 at 06:53:43PM +0530, Surekha.PC wrote:
> > Hi,
> >
> >  I have interspersed my answers below for 2 of your comments.
> >
> > >	- kill the is_root_disk special casing.  drivers can't know
> > >	what the root disks is, there might not even be a single one.
> >
> > This flag is needed for our iSCSI network boot implementation to check
> > if we are booted on iSCSI disk. This is used while trying to shutdown
> > the iSCSI service.
>
> What if the root device changes (pivot_root syscall, namespaces)?  You need
> to find a way to do what you want without having knowledge about beeing
> a root device in the LLDD - there might not be a single root device and it
> could change all the time.

During shutdown iSCSI driver gets signal to stop itself. In turn iSCSI driver 
umounts all the partitions present of iSCSI disks, makes all the iSCSI disks 
unavailble to the system and gracefully terminate. 
But if iSCSI disk contains the root partition OR is part of root partition 
then iSCSI driver must not try to umount the root partition and the iSCSI 
disks must be available until the buffer cache gets flushed properly. For 
this to happen iSCSI driver must be aware of all the iSCSI disk(s) that 
constitute the root partition/devices.

	Q. What kernel data structures/API's are available that provide the 
information about root device(s)?

>
> > This is again needed for network boot. The n/w driver and iSCSI driver
> > are loaded during early boot. Since the n/w interface is not setup at
> > that time, we need to bring up the interface through this call in iSCSI
> > driver.
>
> That's bogus.  Look at the ip autoconfig code used by rootnfs and reuse
> that instead of creating such bogus hacks.  A driver has no business
> dealing with the network configuration.

During shutdown iSCSI driver must bring up the network interface, if it goes 
down, so to make available the iSCSI disk(s) on which the root partition 
exists. iscsi_set_if_addr is used to bring up the newtwork interface at the 
time of shutdown. 
Q. Is ip autoconfig code helps us to bring up the newtwork interface at the 
time of shutdown? 

Thanks,
Naveen.

>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
