From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Large Sequential Reads Being Broken Up. Why?
Date: Mon, 30 Jan 2006 11:17:01 -0500
Message-ID: <43DE3BFD.3090902@emulex.com>
References: <43DE2EB0.2040700@datadirectnet.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:17907 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932350AbWA3QRP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 11:17:15 -0500
In-Reply-To: <43DE2EB0.2040700@datadirectnet.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin W. Schlining III" <mschlining@datadirectnet.com>
Cc: linux-scsi@vger.kernel.org

Here's one thing that will help you....
   in the lpfc driver (in rev 8.0.13 - the file is lpfc_fcp.c), in the
   scsi_driver_template structure - add the field:
       .max_sectors = 0xFFFF,

As of 2.6.10, the kernel started paying attention to this field, which the
emulex driver, as of that time, didn't set. The result was the kernel
dropped back to a default max_sectors of 1024 - which results in a 512k max.
The lpfc driver was updated in rev 8.0.29 with this change.

Caveat is : Even with this change, you must be using O_DIRECT to get high
bandwidth. Otherwise, the upper layers will segment the requests (if I
remember right, we had a hard time making a "normal" config exceed 256k).

-- james s

Martin W. Schlining III wrote:
> I am running a program on my Linux box which is asking for 2M IO (reads 
> and writes) with the file handle being opened with the O_DIRECT flag. 
> However, the IO being put out on the wire is no larger than 512K.  My 
> target device is the SCSI block device (/dev/sdb in this case). What is 
> preventing me from getting large IO through the SCSI block layer? How 
> can I fix it?
> 
> The sg device can achieve the 2M IO size, so I know its at least 
> possible. How can I improve the IO size for the SCSI block layer?
> 
> Details:
> 
> Dell 2850 server with dual Xeons, 1G RAM
> OS: Linux racerx 2.6.11.4-21.10-smp #1 SMP Tue Nov 29 14:32:49 UTC 2005 
> x86_64 x86_64 x86_64 GNU/Linux
> Emulex LP11000 Fibre Channel HBA using driver version 8.0.13 (changing 
> the driver hasn't helped, so far)
> I set the lookahead value pretty large to improve read performance 
> (hdparm -a)
> The scheduler for this device is anticipatory.
> 
> Any ideas?
> 
> Thanks,
> Martin Schlining
> 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
