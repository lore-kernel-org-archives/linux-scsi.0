From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Subject: Re: ESP SCSI and QLGC,ISP SCSI drivers not finding attached devices
Date: Sat, 21 Jul 2007 02:10:18 +0100 (BST)
Message-ID: <Pine.LNX.4.61.0707210151410.8787@mtfhpc.demon.co.uk>
References: <Pine.LNX.4.61.0707201404250.7470@mtfhpc.demon.co.uk>
 <1184941136.3455.8.camel@localhost.localdomain>
 <Pine.LNX.4.61.0707201602080.7721@mtfhpc.demon.co.uk>
 <20070720.153518.59469498.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:3402 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759508AbXGUBKY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jul 2007 21:10:24 -0400
In-Reply-To: <20070720.153518.59469498.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: James.Bottomley@SteelEye.com, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org

Hi David,

Thanks for the info.

Having got the ESP driver going by increasing the Bus Timeout, I have a 
route forward to booting linux from disk.

I will look into the msleep etc. functions and see if I can identify any 
issues with them. As you say, if these are not working correctly ...

I have managed to hack a PTISP SunOS 4.x driver to work with my QLGC,isp 
ISP1000 card. Now that I know the hardware is working, I can be confident 
that the disk on the ISP1000 should be visible to Linux.
If there are no identifiable issues with the sleep functions I will get 
back to debugging the QLGC,isp linux driver and let you know if I find 
anything amiss.

Regards
 	Mark Fortescue.

On Fri, 20 Jul 2007, David Miller wrote:

>
> I think these reports all point to a problem with the sparc32
> kernel far outside of the drivers in question.
>
> We have no reports like this on sparc64.
>
> My running theory is that things like msleep() are returning
> immediately on sparc32, or at least too fast, instead of delaying
> the minimum necessary amount.
>
> This will screw up the scsi reset settle delay, and the devices will
> return scsi command status's that the SCSI bus probe will consider not
> good enough to recognize the device.
>
> This is exactly what tracing from Tom Callaway has shown in the past.
>
> So this is a sparc32 kernel bug of some sort, most likely, not a
> driver bug.
>
> -
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
