From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic79xx
Date: Wed, 22 Feb 2006 11:14:12 -0600
Message-ID: <1140628452.3227.25.camel@mulgrave.il.steeleye.com>
References: <200602221618.58553.srattai@zmnh.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:21398 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751373AbWBVROY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 12:14:24 -0500
In-Reply-To: <200602221618.58553.srattai@zmnh.uni-hamburg.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephan Rattai <srattai@zmnh.uni-hamburg.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-02-22 at 16:18 +0100, Stephan Rattai wrote:
> Hi list,
> 
> I would like to bother you with a problem that might be a little discrepancy 
> in the aic79xx driver. I'm not quite sure if this is a aic79xx problem at 
> all. I have an Adaptec 29320 controller with a LTO (U320) drive connected. I 
> needed to turn down the speed to 160 which I did via the adapter bios. After 
> having booted I found the following output in /proc/scsi/aic79xx/1:
> 
> Target 1 Negotiation Settings
>         User: 160.000MB/s transfers (80.000MHz DT, 16bit)
>         Goal: 320.000MB/s transfers (160.000MHz DT|IU|RTI, 16bit)
>         Curr: 320.000MB/s transfers (160.000MHz DT|IU|RTI, 16bit)
>      
> So the speed for the device is set to 320 despite my bios setting (at least 
> that's what I'm being told through the proc interface). 
> 
> With kernel 2.6.13 I get:
> 
> Target 1 Negotiation Settings
>         User: 160.000MB/s transfers (80.000MHz RDSTRM|DT, 16bit)
>         Goal: 160.000MB/s transfers (80.000MHz DT, 16bit)
>         Curr: 160.000MB/s transfers (80.000MHz DT, 16bit)
> 
> Is this a bug or a feature ? 

It's definitely a bug.  What's supposed to happen in 2.6.16-rc3 is that
aic79xx picks the parameters out of the bios and places them into the
min_period/max_offset variables.

could you look at

cat /sys/class/spi_transport/target<whatever>/min_period

and tell me what it says.

Thanks,

James
 

