From: Matthew Wilcox <willy@debian.org>
Subject: Re: I have modified the megaraid driver v2.00.5 from kernel 2.6 t o 2 .4.22-prex-ac1
Date: Thu, 24 Jul 2003 12:41:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030724114156.GC1485@parcelfarce.linux.theplanet.co.uk>
References: <200307240505.OAA07771@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:46525 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263025AbTGXL0t
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 07:26:49 -0400
Content-Disposition: inline
In-Reply-To: <200307240505.OAA07771@toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: Matthew Wilcox <willy@debian.org>, atulm@lsil.com, Matt Domsch <Matt_Domsch@Dell.com>, linux-megaraid-devel@dell.com, linux-scsi@vger.kernel.org, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

On Thu, Jul 24, 2003 at 02:05:24PM +0900, Tomita, Haruo wrote:
>      thanks for the reply!

no problem.  just trying to make the code better.

> Yes, I  backported the 2.6 driver to 2.4.
> Thank you for pointing out the affair of compile string literals.
> I will correct a mistake. 

Great.

> Matthew> if we want linux to be PCI200X compliant (a dubious point of view
> since
> Matthew> it means we'd have to stop supporting hundreds of hardware devices
> designed
> Matthew> before this became mandatory), this should be done in the PCI
> subsystem,
> Matthew> not in individual drivers.
> 
> Please explain in detail to a slight degree.
> Although it corresponds to PCI2001 by 2.6, 
> is it having stopped corresponding with my patch?

No, not at all.  I'm criticising the original code here, not your patch.
In my opinion, we should simply delete these lines:

                subsysvid = pdev->subsystem_vendor;
                subsysid = pdev->subsystem_device;

                /*
                 * If we do not find the valid subsys vendor id, refuse to
                 * load the driver. This is part of PCI200X compliance
                 * We load the driver if subsysvid is 0.
                 */
                if( subsysvid && (subsysvid != AMI_SUBSYS_VID) &&
                                (subsysvid != DELL_SUBSYS_VID) &&
                                (subsysvid != HP_SUBSYS_VID) &&
                                (subsysvid != LSI_SUBSYS_VID) ) continue;


> Matthew> some of the other code around here needs cleaning up too; for
> example
> Matthew> you should be using pci_name() rather than printing the slot/func
> yourself.
> 
> Cleaning up of a code is not considered yet. 
> I think it priority to make it operate by 2.4.

Is the driver in 2.4 not functional for you?

> Matthew> btw, any plans to convert this driver to be hotplug capable?
>  
> I do not understand.

In 2.5, it is finally possible to write a scsi driver that can cope with
the pci card being hotplugged.  The changes are actually not too hard, but
they do have some consequences we have to accept.

For example, converting the sym8xx driver to this means the controllers will
be detected in a different order.  This is going to suck for some people,
but it's really unavoidable.  It doesn't look like megaraid would have
the same problem, though this comment scared me:

                /*
                 * re-order hosts so that one with bootable logical drive
                 * comes first
                 */

but there's no code associated with it, so it doesn't matter.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
