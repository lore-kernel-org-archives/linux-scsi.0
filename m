From: David.Egolf@bull.com
Subject: Re: Large Sequential Reads Being Broken Up. Why?
Date: Mon, 30 Jan 2006 08:51:39 -0700
Message-ID: <OF4D32A5CA.7EC1C98C-ON07257106.005719D3-07257106.00572016@us-phx1.az05.bull.com>
References: <43DE2EB0.2040700@datadirectnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nc-17.bull.com ([128.35.253.3]:8321 "EHLO nc-17.bull.com")
	by vger.kernel.org with ESMTP id S932347AbWA3Pvq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 10:51:46 -0500
In-Reply-To: <43DE2EB0.2040700@datadirectnet.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin W. Schlining III" <mschlining@datadirectnet.com>
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

Martin, 

I was just doing some informal performance testing from a RedHat linux box 
to two commercial disk arrays.  We have 
an Emulex 8000 card on the box. 

I found that exceeding 256 blocks; i.e., 128K I/O, actually decreased 
performance.  Not only was the elapsed time 
of a 200 MB file longer using sg_dd with 512MB, it consumed considerably 
more system time as reported by the 'time' command. 

When I investigated the configuration, I found that many distributions 
will limit you to 1M transfers by default. 

Certainly, the gains to be made by changing from 512K to 2MB are marginal 
and will probably add to your maintenance 
costs if you ever change anything in the I/O layer. 

-- David Egolf 

linux-scsi-owner@vger.kernel.org wrote on 01/30/2006 08:20:16 AM:

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

