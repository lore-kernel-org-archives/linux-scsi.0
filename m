From: Daniel Stekloff <dsteklof@us.ibm.com>
Subject: Re: [PATCH 1/2] sdev_printk - scsi_device helper macro
Date: Thu, 9 Oct 2003 10:24:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200310091024.58688.dsteklof@us.ibm.com>
References: <200310071318.11847.dsteklof@us.ibm.com> <009401c38e09$7fecc8a0$2988110a@lsd.css.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:13028 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262344AbTJIRYQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Oct 2003 13:24:16 -0400
In-Reply-To: <009401c38e09$7fecc8a0$2988110a@lsd.css.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org
To: Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>, linux-scsi@vger.kernel.org


Hi,


On Wednesday 08 October 2003 07:03 pm, Hironobu Ishii wrote:
> Hi Dan,
>
> > I originally posted this patch for comments:
> >
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=106487047707538&w=2
> >
> > The sdev_printk macro is meant to provide two things for the mid-layer
> > and LLDs:
> >
> > 1) Add consistency to printing out scsi_device information.
> >
> > 2) Identifying printk with a specific scsi_device.
>
> I agree these.
>
> > diff -urN --exclude=SCCS scsi-misc-2.5/include/scsi/scsi_device.h
> > scsi-misc-2.5-sdev/include/scsi/scsi_device.h
> > --- scsi-misc-2.5/include/scsi/scsi_device.h 2003-10-06
> > 16:13:57.000000000 -0700
> > +++ scsi-misc-2.5-sdev/include/scsi/scsi_device.h 2003-10-06
> > 20:04:19.671217176 -0700
> > @@ -105,6 +105,9 @@
> >  #define class_to_sdev(d) \
> >   container_of(d, struct scsi_device, sdev_classdev)
> >
> > +#define sdev_printk(level, sdev, format, arg...) \
> > + printk(level "scsi <%s>: " format , (sdev)->sdev_gendev.bus_id , ##
> > arg) +
>
> It would be nice if the message format is the same with the dev_printk().
>
>     #define dev_printk(level, dev, format, arg...)  \
>         printk(level "%s %s: " format , (dev)->driver->name , (dev)->bus_id
> , ##
>
>
> And, there are many colon separated bus_id, I prefer adding "scsi" before
> that. Also, bus_id is separated with ":", so your idea that it is quoted by
> "< >" is nice.
> I propose the folloing format.
>
> #define sdev_printk(level, sdev, format, arg...) \
>   printk(level "%s <scsi%s>: " format , (sdev)->sdev_gendev.driver->name, \
>                 (sdev)->sdev_gendev.bus_id , ## arg)
>
> It would produce a message like this:
>     st <scsi0:0:4:0>: Device offlined - not ready after error recovery



I am open to other formats, but the problem with doing something like 
dev_printk() is the driver isn't always there, especially during scan. Or, am 
I missing something? I decided not to put the driver in because the 
sdev_printk could be used more throughout the mid-layer and especially in 
scan when the driver isn't set yet. Please let me know if I'm missing 
something. 

Thanks,

Dan


> Thanks,
> Hironobu Ishii

