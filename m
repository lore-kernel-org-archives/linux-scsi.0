From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH RFC] more struct scsi_lun
Date: Mon, 24 Oct 2005 12:27:07 -0400
Message-ID: <435D0B5B.7010706@adaptec.com>
References: <20051023043301.GA22615@havoc.gtf.org> <20051023044953.GA23354@havoc.gtf.org> <435B5C15.5070106@s5r6.in-berlin.de> <435B8CC9.5000600@s5r6.in-berlin.de> <435BBF05.6010109@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:36321 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751140AbVJXQ1N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 12:27:13 -0400
In-Reply-To: <435BBF05.6010109@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

On 10/23/05 12:49, Jeff Garzik wrote:
> Stefan Richter wrote:
> 
>>I wrote:
>>
>>
>>>       for (i = 0; i < 8; ++i)
>>>               sprintf(s+2*i, %02x, lun[i]);
>>
>>                 sprintf(s+2*i, "%02x", lun.scsi_lun[i]);
>>#-)
> 
> 
> 
> There is obviously room for improvement.  Any naive representation is 
> sub-optimal, be it for small luns (my current code) or larger luns (your 
> example).
> 
> For situations with smaller luns, we should probably continue to use the 
> current scsilun_to_int() conversion, while using your example for larger 
> luns, i.e.
> 
> 	if (upper 4 bytes zero)
> 		scsilun to int
> 		printk %d
> 	else
> 		for each byte
> 			printk %x
> 
> But Douglas's code suggested that if we are more motivated, we could 
> provide an even better representation.

If a LUN is u8[8], then,

#define SAS_ADDR(_sa)   ((unsigned long long) be64_to_cpu(*(__be64 *)(_sa)))

"%016llx", SAS_ADDR(LUN)  prints it like this (e.g.):

sas: 5000c50000513329 probing LUN:0000000000000000
sas: device 500000e000031c12 LUN: 0000000000000000 powering up or not ready yet, sleeping...
sas: 500000e000031c12 probing LUN:0000000000000000
sas: device 50001c171601060d LUN: 0000000000000000 powering up or not ready yet, sleeping...

This is from drivers/scsi/sas/sas_discover.c.

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
