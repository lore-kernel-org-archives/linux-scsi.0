From: john clyne <clyne@ucar.edu>
Subject: Re: IO transfer limits
Date: Wed, 10 Jan 2007 15:47:33 -0800 (PST)
Message-ID: <8269227.post@talk.nabble.com>
References: <8260533.post@talk.nabble.com> <45A5250E.3020205@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.nabble.com ([72.21.53.35]:54636 "EHLO talk.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965245AbXAJXrg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jan 2007 18:47:36 -0500
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1H4nAL-0007Ao-CA
	for linux-scsi@vger.kernel.org; Wed, 10 Jan 2007 15:47:33 -0800
In-Reply-To: <45A5250E.3020205@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


What do the different hostX in /sys/class/scsi_host corespond to? There are
seven hostX directories, 5 with sg_tablesize set to 128 and two set to 255.

Is the implication that the hard limit is 255 * page_size, or is page_size
simply the default?



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
View this message in context: http://www.nabble.com/IO-transfer-limits-tf2953389.html#a8269227
Sent from the linux-scsi mailing list archive at Nabble.com.

