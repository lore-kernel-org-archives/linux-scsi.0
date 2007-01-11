From: john clyne <clyne@ucar.edu>
Subject: Re: IO transfer limits
Date: Thu, 11 Jan 2007 11:48:41 -0800 (PST)
Message-ID: <8284792.post@talk.nabble.com>
References: <8260533.post@talk.nabble.com> <45A53290.1060400@torque.net> <8268682.post@talk.nabble.com> <1168539824.2983.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.nabble.com ([72.21.53.35]:52687 "EHLO talk.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbXAKTso (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 14:48:44 -0500
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1H55uj-0000Dd-V2
	for linux-scsi@vger.kernel.org; Thu, 11 Jan 2007 11:48:41 -0800
In-Reply-To: <1168539824.2983.11.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


So what's the best course of action for increasing the 512kb IO transfer size
limit, changing SCSI_MAX_PHYS_SEGMENTS (currently 128 and apparently can be
set no greater than 256), or increasing the page size? Or is there another
option.

thanks - jc


James Bottomley wrote:
> 
> On Wed, 2007-01-10 at 15:07 -0800, john clyne wrote:
>> So given that the HBA max_sectors_kb looks sufficiently large, my
>> interpretation of your article is the next place I need to look is at
>> ajusting SCSI_MAX_PHYS_SEGMENTS. Sounds like i can only increase this to
>> 256. Does that than give me a max transfer size of 256 * page_size (4k) =
>> 1MB? Is 1MB the limit or am I missing something?
> 
> Well ... that's not the maximum possible ... just the maximum number of
> SG elements.  If the buffer is completely fragmented in physical memory,
> then it will be 1MB ... however, linux does a reasonable job of getting
> physically contiguous pages into a large memory allocation, so you could
> get transfers that are larger than the 1MB limit by quite a way.  And,
> of course, any system that has a larger page size or uses an iommu will
> go over this 1MB as well.
> 
> Jmaes
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
View this message in context: http://www.nabble.com/IO-transfer-limits-tf2953389.html#a8284792
Sent from the linux-scsi mailing list archive at Nabble.com.

