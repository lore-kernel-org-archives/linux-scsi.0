From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] SCSI and FibreChannel Hotswap for linux 2.5.44-bk2
Date: Wed, 30 Oct 2002 15:42:21 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200210302042.g9UKgLS02419@localhost.localdomain>
References: <sdake@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: Message from Steven Dake <sdake@mvista.com>
   of "Wed, 30 Oct 2002 11:54:47 MST." <3DC02AF7.6020209@mvista.com>
To: Steven Dake <sdake@mvista.com>
Cc: torvalds@transmeta.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

sdake@mvista.com said:
>  This patch has been reviewed by Alan Cox, Greg KH, Christoph Hellwig,
>  Patrick Mansfield, Rob Landly, Jeff Garzik, Scott Murray, James
> Bottomley, Mike Anderson, Randy Dunlap and Patrick Mochel. 

Well, I reviewed it but my though was that it should be built on the emerging 
hotplug infrastructure.

I'm currently trying to move things like this into the user layer, so from a 
design principle I don't want to have 90% using the user space stuff and 10% 
using its in-kernel equivalent because that means we have two mechanisms to 
maintain, thus doubling the work.

The problem you had with this was the 10ms requirement from removal 
notification to removal completion.  Several people have already suggested 
that if that really is a hard and fast requirement, then you could simply 
treat the removal as a surprise removal rather than a planned one and work on 
fixing our surprise removal problems instead.

The bottom line is that I'm not convinced this can't be done using the 
existing infrastructure or a generic enhancement to it.

James
