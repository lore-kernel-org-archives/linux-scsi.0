From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: One question about SCSI device hotplug
Date: Tue, 1 Mar 2005 22:42:38 -0600
Message-ID: <20050302044238.GA20042@lists.us.dell.com>
References: <0B1E13B586976742A7599D71A6AC733C12EC5E@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from linux.us.dell.com ([143.166.224.162]:1373 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261869AbVCBEmz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 23:42:55 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EC5E@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: matthew@wil.cx, forrest.zhao@intel.com, linux-scsi@vger.kernel.org, ramesh.caushik@intel.com

On Tue, Mar 01, 2005 at 11:35:28AM -0500, James.Smart@Emulex.Com wrote:
> > On Tue, Mar 01, 2005 at 05:06:55PM +0800, Zhao, Forrest wrote:
> > > If I surprisingly hot-remove a SCSI disk from HBA manually 
> > > without executing "echo "scsi remove-single-device
> > >  <h> <b> <t <l>" > /proc/scsi/scsi", can the "hotplug"
> > > event be notified to SCSI mid-layer or user space?
> > > 
> > > I briefly browse some code of LLDD, it seems that LLDD never
> > > report "hotplug" event to upper-level layer. Am I right?
> > 
> > I don't think it *can* ... the SCSI protocols don't tell the 
> > host "hey,
> > this device has disappeared".
> 
> All depends on what transport it is... In FC, we can detect when
> a target is removed. In the most recent FC transport code (not
> all integrated yet), it will indeed automagically invoke
> scsi_remove_device() for all luns on the target.

And in the patches I posted a couple weeks ago, userspace can notify
the kernel about an added/removed device if it knows about it but the
kernel doesn't (say, a management app does the add/remove but the LLDD
doesn't get an interrupt from the firmware on such events).

There's also the slave_{alloc,configure,destroy} callbacks in the
drivers, that let the LLDDs know about a LUN creation or removal, if
you've got device state stored in the driver.

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
