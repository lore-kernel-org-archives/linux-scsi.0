From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: (as54) Fix hot-unplugging for sr.c
Date: Wed, 9 Jul 2003 12:02:34 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307091147290.885-100000@ida.rowland.org>
References: <20030709144410.GA3544@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:6148 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S268386AbTGIPr4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2003 11:47:56 -0400
In-Reply-To: <20030709144410.GA3544@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 9 Jul 2003, Mike Anderson wrote:

> struct device_driver remove() is called as a result of device_unregister
> or device_del being called which usually is called by the SCSI core.
> 
> I changed scsi_device_put to check if access_count drops to zero and the
> device is marked to be deleted. If these two checks are true then call
> device_del. access_count is also checked in the scsi_sysfs.c code under
> a common sema.

I'll need to see all the changes together to fully grasp it.  There are 
lots of little things not described explicitly anywhere but only implicit 
in the code.  In particular, the detailed nature of the interlocks 
relating the struct scsi_device and the struct scsi_cd is unclear (and 
seems to be changing rapidly).  Not to mention the struct gendisk and the 
struct cdrom_device_info.

> > Speaking of /proc/scsi, have you given any thought to making the procinfo 
> > contents available through sysfs?  That way the /proc entry points can be 
> > deprecated and eventually removed, but the information will still be 
> > easily available.
> 
> Yes we should look into this. A old issue was a policy for sysfs of
> one attribute value per file. This would be a large overhead for some of
> the LLDDs to convert to and it would probably be a mess in the
> directory.

As far as I'm concerned, that policy need not be a stumbling block.  I can 
envision two reasons for wanting to have more than one value per file:

	1. The file might represent a snapshot of real-time data being
maintained by the driver.  If the values were stored in different 
attribute files there would be no way to retrieve a consistent snapshot.

	2. The file might be intended to convey summarized information
of interest to a human but not meant to be parsed by any sort of automatic 
tool.  A summary is a lot easier to use when it's all in one place and not 
scattered among lots of little files.

Of course, the information in /proc/scsi/scsi is already in sysfs, obeying 
the one-value-per-file dictate.  But the /proc/scsi/host/host# files were 
never meant to be structured at all, so far as I know -- they would fall 
under category 2 above.

Alan Stern

