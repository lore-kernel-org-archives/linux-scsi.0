From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] [RFC] Advanced TCA SCSI Disk Hotswap
Date: Thu, 24 Oct 2002 15:02:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210242002.g9OK27W03864@localhost.localdomain>
References: <sdake@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id NAA28275
	for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2002 13:02:11 -0700
In-Reply-To: Message from Steven Dake <sdake@mvista.com>
   of "Thu, 24 Oct 2002 12:40:10 PDT." <3DB84C9A.2030702@mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: linux-scsi@vger.kernel.org

sdake@mvista.com said:
> I plan to produce a now patch that dumps the filesystem interface and
> replaces it with driverfs files in /sys/bus/scsi.  These things take
> time, but I hope to be  finished by October 25th. 

OK, that's good, thanks.

> The current remove interface is unmaintained, doesn't contain locking,
>  and requires laborious string processing resulting in slow results.

It is maintained (well, I was planning on looking after it).  The locking can 
be added (the 1st part of your patch).  It does two in kernel strncmps.  
That's not really slow by most definitions.

> Further there is  no usage information (which means the usage must
> come by looking at  drivers/scsi/scsi.c which is beyond most typical
> users).

I don't really think it's the job of the kernel to conatin usage information.  
That's the job of the user level documentation.

> Imagine scanning each disk in driverfs looking at its WWN attribute
> (if  it has one) until a match is found.  Assume there are 16 FC
> devices.  That is  several hundred syscalls just to complete one
> hotswap operation. 

Why is speed so important?

> This requires the adaptor to maintain a mapping of WWNs to SCSI IDs,
> however, this is already required by most FibreChannel firmware I've
> seen (and hence is available  in the driver database already). 

There will be a point where for a large number of drivers, a linear scan even 
in the kernel will be slower than a good DB lookup in userspace.

> Hotplugs on FibreChannel don't trigger "events".  What they can do is
> LIP (loop initialization procedure) if the device has been configured
> in it's SCSI code pages to  do such a thing.  Since this is device
> specific I'd hate to rely on it for hotswap. 

They don't now, but they should.  The LIP protocol makes the FC driver aware 
of the gain or loss of devices.  This should be communicated to the mid-layer 
and then trigger a hotplug event.  Someone needs to write this, I was just 
wondering if you might.

> I think this would be too slow.  10 msec for my entire hotswap is
> available.  If you calculate 2msec for the actual hotswap disk
> operation, that leaves 8 msec for the rest of the mess.  Scanning
> through tables or scanning tens or hundreds of files through hundreds
> of  syscalls may betoo slow. 

Where does the 10ms figure come from?

James


