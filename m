From: Stephan Rattai <srattai@zmnh.uni-hamburg.de>
Subject: Re: aic79xx
Date: Mon, 27 Feb 2006 13:53:47 +0100
Message-ID: <200602271353.47559.srattai@zmnh.uni-hamburg.de>
References: <200602221618.58553.srattai@zmnh.uni-hamburg.de> <200602221839.09470.srattai@zmnh.uni-hamburg.de> <1140969107.3692.2.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rzaixsrv2.rrz.uni-hamburg.de ([134.100.32.71]:36254 "EHLO
	rzaixsrv2.rrz.uni-hamburg.de") by vger.kernel.org with ESMTP
	id S1750800AbWB0Mxy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2006 07:53:54 -0500
Received: from mail.zmnh.uni-hamburg.de (mail.zmnh.uni-hamburg.de [134.100.101.11])
	by rzaixsrv2.rrz.uni-hamburg.de (8.12.10/8.12.9) with ESMTP id k1RCrrpx130772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2006 13:53:53 +0100
Received: from snoopy.zmnh.uni-hamburg.de (snoopy.zmnh.uni-hamburg.de [192.168.100.1])
	by mail.zmnh.uni-hamburg.de (8.13.3/8.13.3) with ESMTP id k1RCrm0X029728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2006 13:53:48 +0100
Received: from konfuzius.zmnh.uni-hamburg.de (localhost [127.0.0.1])
	by snoopy.zmnh.uni-hamburg.de (8.13.4/8.13.4) with ESMTP id k1RCrmQZ008460
	for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2006 13:53:48 +0100
In-Reply-To: <1140969107.3692.2.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> OK, I'm afraid this is a bit more serious than I thought.  Apparently
> the aic7xxx code that pulls the settings out of the seeprom didn't get
> ported over to the aic79xx driver.
>
> Temporarily, to achive what you want, you can just do
>
> echo 12.5 > /sys/class/spi_transport/target1\:0\:1/min_period
> echo 1 > /sys/class/spi_transport/target1\:0\:1/revalidate
>
> and that should bring the speed down to U160.
>
> I'll see what it will take to get the seeprom functions ported, but they
> probably won't make 2.6.16.
>
> James

Well, if I try this, the 
echo 1 > /sys/class/spi_transport/target1\:0\:1/revalidate
never returns. 

cat /proc/scsi/aic79xx/1 says:
Target 1 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
        Goal: 3.300MB/s transfers
        Curr: 3.300MB/s transfers

Thinks like mt -f /dev/nst0 never return. 

I think I'll just use 2.6.13, the target is working fine there.

Thanks,
Stephan
