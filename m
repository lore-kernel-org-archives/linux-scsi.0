From: Daniel Stekloff <dsteklof@us.ibm.com>
Subject: Re: [PATCH] sdev_printk for ULDs, example with sd
Date: Thu, 22 Jan 2004 12:39:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401221239.53227.dsteklof@us.ibm.com>
References: <200401191355.37522.dsteklof@us.ibm.com> <200401221144.48488.dsteklof@us.ibm.com> <1074802104.1877.58.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:48028 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266435AbUAVUnd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 15:43:33 -0500
In-Reply-To: <1074802104.1877.58.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thursday 22 January 2004 12:08 pm, James Bottomley wrote:
> On Thu, 2004-01-22 at 14:44, Daniel Stekloff wrote:
> > In my recent post concerning sdev_printk I mentioned sdev_printk was
> > useful for the mid-layer and LLDs. The macro is also useful for Upper
> > Level Drivers as well. He's a patch adding sdev_printk to sd. Sample
> > output includes:
>
> Well, the thing about this is that it's a slippery slope that leads into
> posix logging.  This recently came up in network as well (for
> netdev_printk()):
>
> http://marc.theaimsgroup.com/?t=107454443000004&r=1&w=2
>
> The principle is sound, but I think the framework for doing it would
> have to cross all subsystems and be nicely extensible.  I'd really like
> to see us have some idea of the back end infrastructure before we do
> something that we'll then have to change again.
>
> James


Hi James,

Thank you for your comments. If you're referring to the Event Logging project, 
their logging infrastructure could plug into the dev macros without impacting 
driver or subsystem changes. They would only need to patch in where 
sdev_printk() is defined in scsi_device.h. The same is true for dev_printk in 
device.h and the proposed netdev_printk that the link refers to. Drivers 
wouldn't need to be changed and could continue to use the macros. We're 
really just building upon using the device structure and dev_printk macro.

I'm not sure why different macros for different subsystems is an issue, the 
different macros take advantage of specific subsystem information. The 
sdev_printk gives benefit of working with the scsi_device structure and 
prints information to identify a scsi device. The dev_printk macro could be 
used in the mid-layer in some situations, but there are places in scsi_scan.c 
where the device->driver struct hasn't been initialized, which would make 
dev_printk unusable at those points.

I'm not sure of other infrastructures in the works. 

Thanks,

Dan


