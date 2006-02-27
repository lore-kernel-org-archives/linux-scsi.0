From: Stephen Degler <stephen@degler.net>
Subject: Re: aic79xx
Date: Mon, 27 Feb 2006 15:20:10 -0500
Message-ID: <44035EFA.5020602@degler.net>
References: <200602221618.58553.srattai@zmnh.uni-hamburg.de>	 <1140628452.3227.25.camel@mulgrave.il.steeleye.com>	 <200602221839.09470.srattai@zmnh.uni-hamburg.de> <1140969107.3692.2.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from crusoe.degler.net ([66.114.64.229]:14535 "EHLO
	crusoe.degler.net") by vger.kernel.org with ESMTP id S932339AbWB0UUN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2006 15:20:13 -0500
In-Reply-To: <1140969107.3692.2.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stephan Rattai <srattai@zmnh.uni-hamburg.de>, linux-scsi@vger.kernel.org

Hello,

I've observed this problem as well.  I'd be happy to test a patch, or 
derive one if the patch isn't too involved.

skd

James Bottomley wrote:

>On Wed, 2006-02-22 at 18:39 +0100, Stephan Rattai wrote:
>  
>
>>cat /sys/class/spi_transport/target1\:0\:1/min_period
>>6.25
>>
>>2.6.16-rc3 ? Whatever causes this behaviour must have been introduced in 
>>2.6.14. The cat above is taken from 2.6.15.4. The output from 2.6.14 is the 
>>same (as is the output from /proc/scsi/aic79xx/1), 2.6.16-rc4 dito. 2.6.13 
>>was working as expected.
>>    
>>
>
>OK, I'm afraid this is a bit more serious than I thought.  Apparently
>the aic7xxx code that pulls the settings out of the seeprom didn't get
>ported over to the aic79xx driver.
>
>Temporarily, to achive what you want, you can just do
>
>echo 12.5 > /sys/class/spi_transport/target1\:0\:1/min_period
>echo 1 > /sys/class/spi_transport/target1\:0\:1/revalidate
>
>and that should bring the speed down to U160.
>
>I'll see what it will take to get the seeprom functions ported, but they
>probably won't make 2.6.16.
>
>James
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>

