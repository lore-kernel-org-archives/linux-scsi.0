From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Wed, 31 Jan 2007 04:30:43 -0500
Message-ID: <45C061C3.8030006@garzik.org>
References: <200701301947.08478.liml@rtr.ca>	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com> <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com> <45BFF3D6.9050605@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55111 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932789AbXAaJar (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Jan 2007 04:30:47 -0500
In-Reply-To: <45BFF3D6.9050605@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <liml@rtr.ca>, "Eric D. Mudama" <edmudama@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Mark Lord wrote:
> Eric D. Mudama wrote:
>>
>> Actually, it's possibly worse, since each failure in libata will 
>> generate 3-4 retries.  With existing ATA error recovery in the drives, 
>> that's about 3 seconds per retry on average, or 12 seconds per 
>> failure.  Multiply that by the number of blocks past the error to 
>> complete the request..
> 
> It really beats the alternative of a forced reboot
> due to, say, superblock I/O failing because it happened
> to get merged with an unrelated I/O which then failed..
> Etc..


FWIW -- speaking generally -- I think there are inevitable areas where 
libata error handling combined with SCSI error handling results in 
suboptimal error handling.

Just creating a list of "<this behavior> should be handled <this way>, 
but in reality is handled in <this silly way>" would be very helpful.

Error handling is tough to get right, because the code is exercised so 
infrequently.  Tejun has actually done an above-average job here, by 
making device probe, hotplug and other "exceptions" go through the 
libata EH code, thereby exercising the EH code more than one might 
normally assume.

Some errors in libata probably should not be retried more than once, 
when we have a definitive diagnosis.  Suggestions for improvements are 
welcome.

	Jeff


