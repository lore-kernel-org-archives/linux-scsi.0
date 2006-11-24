From: Denny Page <denny@cococafe.com>
Subject: Re: SCSI tape (Re: scsi negotiation problem on aic79xx (39320A) in 2.6.14)
Date: Fri, 24 Nov 2006 14:11:21 -0800
Message-ID: <F7D518BF-C626-4964-B184-1AC4C6D2C3B2@cococafe.com>
References: <Impo.871wnune7w@hush.zonix.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cococafe.com ([64.142.30.235]:63973 "EHLO
	mail.cococafe.com") by vger.kernel.org with ESMTP id S935095AbWKXWLY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Nov 2006 17:11:24 -0500
In-Reply-To: <Impo.871wnune7w@hush.zonix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raymond Scholz <rscholz@zonix.de>
Cc: linux-scsi@vger.kernel.org

Ray,

The problem has to do with the speed negotiation that occurs on  
driver initialization.

That I know of, there are 2 ways to address the problem.

For kernel 2.6.17 (and later), you can go into the Adaptec scsi bios  
and explicitly limit the transfer speed for the target device to 160  
MB/s.

Alternatively, for kernel 2.6.16 (and later), you can add the  
following to your boot init file:

   # Fix scsi speed negotiation on tape drive
   SYS_TAPE=/sys/class/spi_transport/target0:0:3
   echo "12.5" > $SYS_TAPE/min_period
   echo "1"    > $SYS_TAPE/revalidate

[Remember to change the SYS_TAPE variable to match your target device]

You will know that you've done it correctly when you see 160MB/s as  
the value of User/Goal/Curr for your target in /proc/scsi/aic79xx/*.

In my case, it's still unclear to me whether or not the problem is  
the AIC79xx, the HP LTO drive, or the scsi driver.

Hope this helps.

Denny



On Nov 23, 2006, at 11:40 , Raymond Scholz wrote:

> Hello Denny,
>
> sorry for bothering you with this but I spent the whole day searching
> the net for the reason why our SCSI LTO-2 tape suddenly dropped
> performance down to 2MB/s after upgrading the Linux kernel.
>
> Your description and hardware comes close to the behaviour we  
> observed:
>
> http://www.spinics.net/lists/linux-scsi/msg06003.html
> http://thread.gmane.org/gmane.linux.scsi/22010/focus=22021
>
> Did you receive any response or (even better) found a better solution
> than downgrading the kernel?
>
> Cheers, Ray
> -- 
> Raymond Scholz - rscholz@zonix.de - GnuPG/PGP - http://www.zonix.de/
>

