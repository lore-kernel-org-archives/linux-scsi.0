From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Wed, 20 Oct 2004 08:40:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41765CD1.8060108@adaptec.com>
References: <Pine.LNX.4.44L0.0410191738250.713-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:41398 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267668AbUJTMlB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 08:41:01 -0400
In-Reply-To: <Pine.LNX.4.44L0.0410191738250.713-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
>>A third possibility is to use the PMI bit to get the proper value
>>of the LBA of the last logical block.
>>
>>If you want to move this into sd, then do you know if those
>>devices support the use of PMI bit in READ CAPACITY CDB?
>>As block devices they should.
> 
> 
> I don't know.  Yes, they should -- but considering that the READ CAPACITY 
> support is wrong it wouldn't be surprising if the PMI support is also 
> wrong.  There's an excellent chance the devices will return the same value 
> whether PMI is set or not.

Yeah, I agree.  It's worth a try though.  If the device implements
SBC, then it should implement PMI in READ CAPACITY.  Unless it implements
RBC (Reduced Block Commands) in which case PMI is not present, neither
is READ CAPACITY(16), only the 10 byte version.

>>See the appended/attached patch.  Can you test it against such a USB
>>device?
> 
> 
> I'll ask some people to try.  Do you think that READ FORMAT CAPACITIES (op
> 0x23) might be a better approach?

READ FORMAT CAPACITIES is an _optional_ command for MMC (cd/dvd devices),
so I don't think block devices would implement it.

Given that USB block devices already implement READ CAPACITY, there's a
chance that they implement the PMI bit.  Other than that, reading a "random"
sector trying to guess the capacity might set the device into an unknown
state or hang, so this is risky.

Anyone else with such a device willing to try this patch?

	Luben

