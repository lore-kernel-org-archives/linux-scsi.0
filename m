From: john clyne <clyne@ucar.edu>
Subject: Re: IO transfer limits
Date: Wed, 10 Jan 2007 15:07:01 -0800 (PST)
Message-ID: <8268682.post@talk.nabble.com>
References: <8260533.post@talk.nabble.com> <45A53290.1060400@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.nabble.com ([72.21.53.35]:38145 "EHLO talk.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965198AbXAJXHD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jan 2007 18:07:03 -0500
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1H4mX7-0001Pv-9D
	for linux-scsi@vger.kernel.org; Wed, 10 Jan 2007 15:07:01 -0800
In-Reply-To: <45A53290.1060400@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


So given that the HBA max_sectors_kb looks sufficiently large, my
interpretation of your article is the next place I need to look is at
ajusting SCSI_MAX_PHYS_SEGMENTS. Sounds like i can only increase this to
256. Does that than give me a max transfer size of 256 * page_size (4k) =
1MB? Is 1MB the limit or am I missing something?

thanks - jc


Douglas Gilbert wrote:
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
> 
> John,
> I discuss the subject in this page:
>    http://www.torque.net/sg/sg_io.html
> in the section titled:
> Maximum transfer size per command
> 
> Mike C. has given you the answer for the block device
> interface (e.g. via /dev/sda); you should be able
> to do about 8 times better via the scsi generic
> interface (e.g. /dev/sg0).
> 
> Doug Gilbert
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
View this message in context: http://www.nabble.com/IO-transfer-limits-tf2953389.html#a8268682
Sent from the linux-scsi mailing list archive at Nabble.com.

