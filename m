From: Patrick Mochel <mochel@osdl.org>
Subject: Re: [RFC] scsi host sysfs support [0/4]
Date: Mon, 14 Apr 2003 16:02:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0304141600070.15980-100000@cherise>
References: <20030414183759.GA4162@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:45464 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263972AbTDNWwc (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 18:52:32 -0400
In-Reply-To: <20030414183759.GA4162@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net


On Mon, 14 Apr 2003, Mike Anderson wrote:

> This patch set is against 2.5.67 current. It will not apply to scsi-miscs-2.5
> as the decl_subsys macro has added a third argument.
> 
> This patch set changes the sysfs support for scsi hosts.
> - Removes the previous support of shost_devclass device class.
> 
> - Modifies scsi_debug to support the new order of object cleanup and also
>   changes the structure of sdebug_host_info to help in object cleanup.
> 
> - Creates a scsi subsystem. This is rooted at the top of the sysfs tree.

No. Period. 

This will not fly. Not now, and not ever. 

> - Creates a scsi_host subsystem under the scsi subsystem. Modified the
>   cleanup in scsi remove host. Switched to a kobject embedded in
>   scsi_host. If a driver has not be converted to the driver model or does
>   not use the scsi_set_device call it will still show up in the scsi_host
>   subsystem, but will not have a symlink to the parent.
> 
> The usage of driver model classes for scsi hosts was removed because many
> of our drivers have not been converted to the driver model so this gave an
> inconsistent model to count on for cleanup and migration of some the
> procfs support. I tried adding some fake structures to use classes, but it
> failed to cleanup properly do to asymmetric cleanup interfaces in the core
> code and also did not seem like the correct direction to go.


Then you need to fix the code, or do some work to fix up the class 
support. You have no right to promote scsi to a top-level subsystem, and I 
will not support. I'll not even read the rest of the patches. 

I realize that block and net are top-level subsystems. They are there for 
two reasons - 1) they _are_ that important, and 2) they're temporary steps 
to them being converted to classes. 

I realize that you think SCSI is just as important as block devices or net 
devices, but it's just not true for most systems, and I will not open the 
flood gates for you to abuse even more interfaces.

Thanks,


	-pat

