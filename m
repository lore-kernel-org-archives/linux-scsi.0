From: Alexander Jolk <alexj@buf.com>
Subject: Re: SCSI tape (Re: scsi negotiation problem on aic79xx (39320A) in
 2.6.14)
Date: Mon, 27 Nov 2006 18:28:50 +0100
Message-ID: <456B2052.1060300@buf.com>
References: <Impo.871wnune7w@hush.zonix.de> <F7D518BF-C626-4964-B184-1AC4C6D2C3B2@cococafe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.buf.fr ([195.68.52.65]:425 "EHLO mail.buf.fr")
	by vger.kernel.org with ESMTP id S1758466AbWK0R2z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Nov 2006 12:28:55 -0500
In-Reply-To: <F7D518BF-C626-4964-B184-1AC4C6D2C3B2@cococafe.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denny Page <denny@cococafe.com>
Cc: Raymond Scholz <rscholz@zonix.de>, linux-scsi@vger.kernel.org

Denny Page wrote:
> The problem has to do with the speed negotiation that occurs on  driver 
> initialization.
> 
> That I know of, there are 2 ways to address the problem.
> 
> For kernel 2.6.17 (and later), you can go into the Adaptec scsi bios  
> and explicitly limit the transfer speed for the target device to 160  MB/s.
> 
> Alternatively, for kernel 2.6.16 (and later), you can add the  following 
> to your boot init file:
> 
>   # Fix scsi speed negotiation on tape drive
>   SYS_TAPE=/sys/class/spi_transport/target0:0:3
>   echo "12.5" > $SYS_TAPE/min_period
>   echo "1"    > $SYS_TAPE/revalidate
> 
> [Remember to change the SYS_TAPE variable to match your target device]
> 
> You will know that you've done it correctly when you see 160MB/s as  the 
> value of User/Goal/Curr for your target in /proc/scsi/aic79xx/*.
> 
> In my case, it's still unclear to me whether or not the problem is  the 
> AIC79xx, the HP LTO drive, or the scsi driver.

I have successfully used your procedure in order to get an HP LTO-3 
driver to work that's attached to an LSI/Fusion/MPT controller.  That 
would seem to point to the drive or the scsi driver rather than the 
controller.

Alex


-- 
Alexander Jolk         /         BUF Compagnie
tel +33-1 42 68 18 28 /  fax +33-1 42 68 18 29
