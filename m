From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH RFC] more struct scsi_lun
Date: Sun, 23 Oct 2005 12:49:09 -0400
Message-ID: <435BBF05.6010109@pobox.com>
References: <20051023043301.GA22615@havoc.gtf.org> <20051023044953.GA23354@havoc.gtf.org> <435B5C15.5070106@s5r6.in-berlin.de> <435B8CC9.5000600@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:3523 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750775AbVJWQtL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 12:49:11 -0400
In-Reply-To: <435B8CC9.5000600@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org

Stefan Richter wrote:
> I wrote:
> 
>>        for (i = 0; i < 8; ++i)
>>                sprintf(s+2*i, %02x, lun[i]);
> 
>                  sprintf(s+2*i, "%02x", lun.scsi_lun[i]);
> #-)


There is obviously room for improvement.  Any naive representation is 
sub-optimal, be it for small luns (my current code) or larger luns (your 
example).

For situations with smaller luns, we should probably continue to use the 
current scsilun_to_int() conversion, while using your example for larger 
luns, i.e.

	if (upper 4 bytes zero)
		scsilun to int
		printk %d
	else
		for each byte
			printk %x

But Douglas's code suggested that if we are more motivated, we could 
provide an even better representation.

Regards,

	Jeff



