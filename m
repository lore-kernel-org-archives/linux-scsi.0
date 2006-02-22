From: Stephan Rattai <srattai@zmnh.uni-hamburg.de>
Subject: Re: aic79xx
Date: Wed, 22 Feb 2006 18:39:08 +0100
Message-ID: <200602221839.09470.srattai@zmnh.uni-hamburg.de>
References: <200602221618.58553.srattai@zmnh.uni-hamburg.de> <1140628452.3227.25.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rzaixsrv2.rrz.uni-hamburg.de ([134.100.32.71]:59025 "EHLO
	rzaixsrv2.rrz.uni-hamburg.de") by vger.kernel.org with ESMTP
	id S1161142AbWBVRjS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 12:39:18 -0500
Received: from mail.zmnh.uni-hamburg.de (mail.zmnh.uni-hamburg.de [134.100.101.11])
	by rzaixsrv2.rrz.uni-hamburg.de (8.12.10/8.12.9) with ESMTP id k1MHdGh6167918
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 18:39:16 +0100
Received: from snoopy.zmnh.uni-hamburg.de (snoopy.zmnh.uni-hamburg.de [192.168.100.1])
	by mail.zmnh.uni-hamburg.de (8.13.3/8.13.3) with ESMTP id k1MHdBVJ007966
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 18:39:11 +0100
Received: from konfuzius.zmnh.uni-hamburg.de (localhost [127.0.0.1])
	by snoopy.zmnh.uni-hamburg.de (8.13.4/8.13.4) with ESMTP id k1MHdB8k015196
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 18:39:11 +0100
In-Reply-To: <1140628452.3227.25.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Am Mittwoch, 22. Februar 2006 18:14 schrieben Sie:
> On Wed, 2006-02-22 at 16:18 +0100, Stephan Rattai wrote:
> > Hi list,
> >
> > I would like to bother you with a problem that might be a little
> > discrepancy in the aic79xx driver. I'm not quite sure if this is a
> > aic79xx problem at all. I have an Adaptec 29320 controller with a LTO
> > (U320) drive connected. I needed to turn down the speed to 160 which I
> > did via the adapter bios. After having booted I found the following
> > output in /proc/scsi/aic79xx/1:
> >
> > Target 1 Negotiation Settings
> >         User: 160.000MB/s transfers (80.000MHz DT, 16bit)
> >         Goal: 320.000MB/s transfers (160.000MHz DT|IU|RTI, 16bit)
> >         Curr: 320.000MB/s transfers (160.000MHz DT|IU|RTI, 16bit)
> >
> > So the speed for the device is set to 320 despite my bios setting (at
> > least that's what I'm being told through the proc interface).
> >
> > With kernel 2.6.13 I get:
> >
> > Target 1 Negotiation Settings
> >         User: 160.000MB/s transfers (80.000MHz RDSTRM|DT, 16bit)
> >         Goal: 160.000MB/s transfers (80.000MHz DT, 16bit)
> >         Curr: 160.000MB/s transfers (80.000MHz DT, 16bit)
> >
> > Is this a bug or a feature ?
>
> It's definitely a bug.  What's supposed to happen in 2.6.16-rc3 is that
> aic79xx picks the parameters out of the bios and places them into the
> min_period/max_offset variables.
>
> could you look at
>
> cat /sys/class/spi_transport/target<whatever>/min_period
>
> and tell me what it says.
>
> Thanks,
>
> James

Ok, 

cat /sys/class/spi_transport/target1\:0\:1/min_period
6.25

2.6.16-rc3 ? Whatever causes this behaviour must have been introduced in 
2.6.14. The cat above is taken from 2.6.15.4. The output from 2.6.14 is the 
same (as is the output from /proc/scsi/aic79xx/1), 2.6.16-rc4 dito. 2.6.13 
was working as expected.

Thanks
Stephan
