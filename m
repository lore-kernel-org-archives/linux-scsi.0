From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: LUN discovery by SCSI midlayer?
Date: Tue, 15 Feb 2005 08:06:42 -0600
Message-ID: <20050215140642.GA2431@lists.us.dell.com>
References: <7526e30505021420354e6a1707@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from lists.us.dell.com ([143.166.224.162]:35260 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261732AbVBOOGs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 09:06:48 -0500
Content-Disposition: inline
In-Reply-To: <7526e30505021420354e6a1707@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Scsi <joe.scsi@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Feb 14, 2005 at 08:35:25PM -0800, Joe Scsi wrote:
> Hi,
> 
> I'm working on a driver for a SCSI protocol that is transported over a network.
> My basic plan is that when the driver is loaded, it will create a SCSI
> host structure
> for its initiator port.  Then target ports will be discovered
> asynchronously (and
> may appear/disappear as target devices come and go on the network).
> 
> I'm wondering what the best way to handle LUN discovery is.  Unfortunately it
> seems that scsi_add_device() can only add a single LUN at a time.  However,
> for my protocol, I see target ports and then need to find the LUNs.  So far I've
> come up with a couple of ideas but I'm not totally happy with either:
> 
>   (ugly) Do all the REPORT_LUNs stuff in my driver every time I find a new
>   target port, or
> 
>   (ab)use the "channel" index and call scsi_scan_single_target() every time
>   I connect to a new target port.  This seems OK but I'm a little put off by the
>   fact that a quick grep shows no callers of scsi_scan_single_target in the
>   current kernel tree.
> 
> So what is the correct way to handle this?  I'm sure the FC and iSCSI people
> must have dealt with a similar issue.


Can you take a look at the patches I posted last week and see if that
would work for you?

http://marc.theaimsgroup.com/?l=linux-scsi&m=110780092314985&w=2

  See then the megaraid_mbox.c driver patch in the thread for how it
converts logical drive numbers into HCTL values and invokes the
hotplug subsystem.  In your case, you'd use whatever your addressing
mechanism is, and convert it into HCTL before invoking the hotplug calls.

Then you've got 2 options:
1) if you have a userspace app that knows when LUNs appear and
   disappear, then you write to /sys/class/scsi_host/hostN/lun_found
   (akin to logical_drive_created).

2) if your driver is what sees LUN arrivals/removals on the topology,
   then the driver just invokes the hotplug calls directly rather than
   expecting the event to originate via a sysfs file.


Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
