From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic79xx
Date: Sun, 26 Feb 2006 09:51:47 -0600
Message-ID: <1140969107.3692.2.camel@mulgrave.il.steeleye.com>
References: <200602221618.58553.srattai@zmnh.uni-hamburg.de>
	 <1140628452.3227.25.camel@mulgrave.il.steeleye.com>
	 <200602221839.09470.srattai@zmnh.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:62950 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751237AbWBZPv4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 10:51:56 -0500
In-Reply-To: <200602221839.09470.srattai@zmnh.uni-hamburg.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephan Rattai <srattai@zmnh.uni-hamburg.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-02-22 at 18:39 +0100, Stephan Rattai wrote:
> cat /sys/class/spi_transport/target1\:0\:1/min_period
> 6.25
> 
> 2.6.16-rc3 ? Whatever causes this behaviour must have been introduced in 
> 2.6.14. The cat above is taken from 2.6.15.4. The output from 2.6.14 is the 
> same (as is the output from /proc/scsi/aic79xx/1), 2.6.16-rc4 dito. 2.6.13 
> was working as expected.

OK, I'm afraid this is a bit more serious than I thought.  Apparently
the aic7xxx code that pulls the settings out of the seeprom didn't get
ported over to the aic79xx driver.

Temporarily, to achive what you want, you can just do

echo 12.5 > /sys/class/spi_transport/target1\:0\:1/min_period
echo 1 > /sys/class/spi_transport/target1\:0\:1/revalidate

and that should bring the speed down to U160.

I'll see what it will take to get the seeprom functions ported, but they
probably won't make 2.6.16.

James


