From: john clyne <clyne@ucar.edu>
Subject: Re: IO transfer limits
Date: Fri, 12 Jan 2007 14:27:22 -0800 (PST)
Message-ID: <8307532.post@talk.nabble.com>
References: <8260533.post@talk.nabble.com> <45A5250E.3020205@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.nabble.com ([72.21.53.35]:35350 "EHLO talk.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161141AbXALW1X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jan 2007 17:27:23 -0500
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1H5Urq-0003SD-Pg
	for linux-scsi@vger.kernel.org; Fri, 12 Jan 2007 14:27:22 -0800
In-Reply-To: <45A5250E.3020205@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Increasing SCSI_MAX_PHYS_SEGMENTS to 256 has doubled the IO size to 1MB.
Thanks to all!

cheers - jc


Mike Christie wrote:
> 
> john clyne wrote:
>> Can anyone give me some guidance on where in the IO stack I might be
>> running
>> into a 512KB limit on IO transfer sizes to an external FC device? I've
>> checked IO scheduler parameter
>> (/sys/block/<dev>/queue/{max_sectors_kb,max_hw_sectors_kb}. Both are set
>> to
>> 32767. I'm using Qlogic HBAs (qla2312), but I don't see any relevent
>> parameters. I'm running RHEL 4.0 with a 2.6.9-34 kernel. Any pointers
>> would
>> be greatly appreciated.
>> 
> 
> There are also scatterlist limits.
> 
> /sys/class/scsi_host/hostX/sg_tablesize is a limit for the number of
> scatter list entries. For qla2xxx it is 255.
> 
> The scsi layer sets the queue's max_phys_segments to 128 by default. I
> thought there was ia scsi compile time option to increase this, but
> maybe you have to just modify the SCSI_MAX_PHYS_SEGMENTS define by hand.
> 
> So with the default value and with 4 K pages if you end up getting pages
> that cannot be clustered you will end up with 4K * 128.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
View this message in context: http://www.nabble.com/IO-transfer-limits-tf2953389.html#a8307532
Sent from the linux-scsi mailing list archive at Nabble.com.

